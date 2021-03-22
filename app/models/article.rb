class Article < ActiveRecord::Base
  #acts_as_reportable
  before_destroy :require_no_rigdocs
  belongs_to :iva

  has_many :rigdocs
  has_many :key_word_rels, as: :key_wordable
  has_many :key_words, through: :key_word_rels
  has_many :anagen_articles
  has_many :anagens, through: :anagen_articles
  has_many :events

  attr_accessible :codice, :descriz, :prezzo, :azienda, :categ, :iva_id, :costo, :subtitle, :sinossi, :abstract, :quote, :weigth, :ppc, :ppb, :state, :width, :height, :dtpub, :discount, :pagine, :rilegatura, :issuee_link, :translator, :series, :director_series, :collaborator, :youtube_presentation

  validates :codice, :descriz, :azienda, :categ, :iva_id, :costo, :presence => true
  #validates :codice, :descriz, :uniqueness => {:case_sensitive => false}
  validates :codice,               :length => {:maximum => 20}
  validates :descriz,              :length => {:maximum => 50}
  validates :translator,           :length => {:maximum => 30}
  validates :series,               :length => {:maximum => 30}
  validates :director_series,      :length => {:maximum => 30}
  validates :collaborator,         :length => {:maximum => 30}
  validates :youtube_presentation, :length => {:maximum => 50}
  
  scope :azienda, lambda { |azd| {:conditions => ['articles.azienda = ?', azd]}}
  scope :not_hidden, -> { where("articles.state != 5") }
  scope :by_author, ->(aid) { includes(:anagen_articles).where("anagen_articles.mode = 1 AND anagen_articles.anagen_id=?", aid) }
  scope :by_supplier, ->(aid) { includes(:anagen_articles).where("anagen_articles.mode = 3 AND anagen_articles.anagen_id=?", aid) }
  scope :by_key_word, ->(kid) { includes(:key_word_rels).where("key_word_rels.key_word_id = ?", kid) }

  CATEG = $ParAzienda['ARTICLE']['CATEG']
  STATES = [
    ["In preparazione",1], 
    ["Disponibile",2], 
    ["In ristampa",3], 
    ["Fuori catalogo",4], 
    ["Nascosto",5],
    ["In prenotazione",6]
  ]

  RILEGATURE = [
    ["Cartonato",1], 
    ["Brossura",2], 
    ["Libretto + CD",2], 
  ]

  def self.filter(azienda, tp, des, page)
    # Esegure la ricerca articoli in base ai filtri impostati

    nrrecord = nil
    hsh = {"DE" => "descriz", "CO" => "codice"}
    hshvar = Hash.new
    whart = "" 
    whart = " UPPER(articles.#{hsh[tp]}) like UPPER(:d)" unless des.blank?
    hshvar[:d] = "%#{des}%" unless des.blank?

    nrrecord = where([whart, hshvar]).count if page.nil?

    return azienda(azienda).where([whart, hshvar]).paginate(:page => page, :per_page => 10,
                                           :order => "codice ASC"), nrrecord unless hsh[tp].nil?
  end

  def self.chk_art_xls(azienda, xls, wks, rownr, colnr)
    # Controlla che nel file excel xls nello sheet wks(0base), partendo dalla riga rownr,
    # ogni valore della colonna colnr corrisponda ad un codice articolo nel DB 
    errors = []
    xls.worksheet(wks).each rownr do |row|
      unless row[colnr].blank?
        if not find_by_azienda_and_codice(azienda, row[colnr].to_s.strip)
          errors << "Articolo: #{row[colnr].to_s.strip} sulla riga: #{(row.idx + 1).to_s} non presente in banca dati."
        end
      end
    end
    return errors
  end

  def desest1
    "#{self.codice} #{self.descriz}"
  end

  def des_plus
    "#{self.descriz} (#{Article::CATEG[self.categ]})"
  end

  def self.movmag(id)
    # Tutti i movimenti di magazzino di un articolo (titolo)
    Article.find_by_sql("SELECT tesdocs.data_doc AS Data_doc, tesdocs.num_doc AS Numero,
                                causmags.descriz AS Causale, causmags.tipo AS Mov, rigdocs.qta AS Qta,
                                causmags.movimpmag AS Mag
                           FROM articles INNER JOIN rigdocs ON (articles.id = rigdocs.article_id)
                                         INNER JOIN tesdocs ON (rigdocs.tesdoc_id = tesdocs.id)
                                         INNER JOIN causmags ON (tesdocs.causmag_id = causmags.id)
                          WHERE causmags.movimpmag IN ('M', 'I') AND articles.id = #{id} 
                          ORDER BY tesdocs.data_doc, tesdocs.num_doc")
  end

  def self.exp_movart_xls(tp, artmov, idanagen, nrmag, anarif, azienda, grpmag, annoese, dti, dtf, idcausmag)
    book = Spreadsheet::Workbook.new # istanzio il workbook (file xls)
    formatbold = Spreadsheet::Format.new :weight=>:bold, :border=>:thin
    formatbord = Spreadsheet::Format.new :border=>:thin
    shmovart = book.create_worksheet :name => 'Movimenti' # istanzio lo sheet

    if tp == "M"
      shmovart.row(0).concat %w{Articolo Descrizione Anagrafica Data_Doc Nr_Doc Causale Magazzino Carico Scarico Giacenza Impegnato Disponib}
    elsif tp == "V"
      shmovart.row(0).concat %w{Articolo Descrizione Anagrafica Data_Doc Nr_Doc Causale Vendite Resi Prezzo Fatturato Accrediatato Progr}
    else
      errore
    end
    12.times{|i|shmovart.row(0).set_format(i, formatbold)}
    nrrow = 1
    artmov.each do |dataart|
      art = Article.find(dataart.attributes["artid"])
      Tesdoc.anagen_mov_artic(art.id, idanagen, nrmag, anarif, tp, annoese, dti, dtf, idcausmag).each do |tesdoc|
        anarif == "S" ? idanagen = azienda : idanagen = tesdoc.attributes["idanagen"]
        desanagen = Anagen.find(idanagen).denomin
        Tesdoc.mag_mov_artic_anagen(art.id, idanagen, nrmag, anarif, grpmag, tp, annoese, dti, dtf, idcausmag).each do |tesdoc|
          if tp == "M"
            giac = 0
            tcar = 0
            tsca = 0
            timp = 0
            Tesdoc.mov_artanagenmag(art.id, idanagen, tesdoc.attributes["nrmag"], anarif, grpmag, annoese, dti, dtf, idcausmag).each do |r|
              dt_doc  = r.attributes["data_doc"]
              num     = r.attributes["numero"]
              cau     = r.attributes["causale"]
              nrmag   = r.attributes["nrmag"]
              tipomov = r.attributes["tipomov"]
              qta     = r.attributes["qta"].to_i
              tpmag   = r.attributes["tipomag"]
              movmag  = r.attributes["movmag"]
              car, sca, imp = set_car_sca_imp(anarif, tipomov, tpmag, movmag, qta)
              giac += car.to_i - sca.to_i
              tcar += car.to_i
              tsca += sca.to_i
              timp += imp.to_i
              shmovart.row(nrrow).concat [art.codice, art.descriz, desanagen, dt_doc, num, cau,
                                          nrmag,      car,         sca,       giac,   imp, giac-imp.to_i]
              12.times{|i|shmovart.row(nrrow).set_format(i, formatbord)}
              nrrow += 1
            end
            shmovart.row(nrrow).concat [art.codice, art.descriz, desanagen, "TOTALI:", "",   "",
                                        "",         tcar,        tsca,      giac,      timp, giac-timp]
            12.times{|i|shmovart.row(nrrow).set_format(i, formatbold)}
            nrrow += 2
          else
            prg  = 0
            tven = 0
            tres = 0
            tfatt = 0
            taccr = 0
            Tesdoc.ven_artanagen(art.id, idanagen, anarif, dti, dtf, idcausmag).each do |r|
              dt_doc  = r.attributes["data_doc"]
              num     = r.attributes["numero"]
              cau     = r.attributes["causale"]
              tipomov = r.attributes["tipomov"]
              qta     = r.attributes["qta"].to_i
              prezzo  = r.attributes["prezzo"].to_f

              (tipomov == "U" or tipomov == "V") ? ven=qta : ven=""
              (tipomov == "E" or tipomov == "R") ? res=qta : res=""
              res == "" ? fatt = qta * prezzo : fatt = 0
              ven == "" ? accr = qta * prezzo : accr = 0
              prg  += ven.to_i - res.to_i
              tven += ven.to_i
              tres += res.to_i
              tfatt += fatt.to_f
              taccr += accr.to_f
              shmovart.row(nrrow).concat [art.codice, art.descriz, desanagen, dt_doc, num,  cau,
                                          ven,        res,         prezzo,    fatt,   accr, prg.to_i]
              12.times{|i|shmovart.row(nrrow).set_format(i, formatbord)}
              nrrow += 1
            end
            shmovart.row(nrrow).concat [art.codice, art.descriz, desanagen, "TOTALI:", "",    "",
                                        tven,       tres,        "",        tfatt,     taccr, prg.to_i]
            12.times{|i|shmovart.row(nrrow).set_format(i, formatbold)}
            shmovart.column(1).width = 60
            shmovart.column(2).width = 30
            shmovart.column(5).width = 30
            nrrow += 2
  #          tfatt = tfatt.round(2).to_s
  #          tfatt << "0" if tfatt[tfatt.length-2] == '.' # 6.20 diventava 6.2, così rimane 6.20
  #          taccr = taccr.round(2).to_s
  #          taccr << "0" if taccr[taccr.length-2] == '.' # 6.20 diventava 6.2, così rimane 6.20
  #          @tb << ["TOTALI:", "", "", tven, tres, "", tfatt, taccr, prg]
          end
        end
      end
    end
    data = StringIO.new('')
    book.write(data)
    return data.string
  end

  def dstate
    if self.state
      tmp = STATES.select { |x| x[1] == self.state }
      tmp.size > 0 && tmp[0][0]
    end
  end

  def drilegatura
    if self.rilegatura
      tmp = RILEGATURE.select { |x| x[1] == self.rilegatura }
      tmp.size > 0 && tmp[0][0]
    end
  end

  def has_key_word?(kw)
    self.key_words.include?(kw)
  end

  def libro?
    kw = KeyWordArticle.where(desc: "Libro").first
    self.has_key_word?(kw)
  end

  def contenuto_digitale?
    kw = KeyWordArticle.where(desc: "Digitale").first
    kw.childs.each do |k|
      return true if self.has_key_word?(k)
    end
    false
  end

  def rivista?
    kw = KeyWordArticle.where(desc: "Rivista").first
    self.has_key_word?(kw)
  end

  def evento?
    kw = KeyWordArticle.where(desc: "Evento").first
    self.has_key_word?(kw)
  end

  def generico?
    kw = KeyWordArticle.where(desc: "Generico").first
    self.has_key_word?(kw)
  end

  def self.contenuti_digitali
    kw = KeyWordArticle.where(desc: "Digitale").first
    ids = kw.childs.map { |x| x.id }

    Article.joins(:key_words).where("key_words.id in (?)", ids)
  end

  def self.libri
    kw = KeyWordArticle.where(desc: "Libro").first
    if kw
      Rails.logger.info "--------------------- kw.id: #{kw.id}"
      Article.joins(:key_words).where("key_words.id = ?", kw.id)
    else
      []
    end
  end

  def self.eventi
    kw = KeyWordArticle.where(desc: "Evento").first
    Article.joins(:key_words).where("key_words.id = ?", kw.id)
  end

  def self.announcements(n)
    kw = KeyWordArticle.where(desc: "Novita'").first
    r = Article.joins(:key_words).where("key_words.id = ?", kw.id)
    n > 0 ? r.limit(n) : r
  end
  
  def self.promotions(n)
    kw = KeyWordArticle.where(desc: "Promozioni").first
    r = Article.joins(:key_words).where("key_words.id = ?", kw.id)
    n > 0 ? r.limit(n) : r
  end
  
  def self.bestsellers(n)
    kw = KeyWordArticle.where(desc: "Bestseller").first
    r = Article.joins(:key_words).where("key_words.id = ?", kw.id)
    n > 0 ? r.limit(n) : r
  end
  
  def self.products(n)
    kw = KeyWordArticle.where(desc: "Generico").first
    r = Article.joins(:key_words).where("key_words.id = ?", kw.id)
    n > 0 ? r.limit(n) : r
  end

  def can_buy?
    [2, 3, 6].include? self.state
    #self.state == 2
  end

  def final_price
    (self.prezzo - ((self.prezzo*self.discount)/100)).round(2)
  end

  def price_with_vat
    if self.iva && self.iva.aliq
      al = self.iva.aliq / 100
      (self.prezzo * (1.0 + al)).round(2)   
    else
      self.prezzo
    end
  end

  def in_prenotazione?
    self.state == 6
  end

  def self.global_search(key)
    Rails.logger.info "global_seargh --------------------- key #{key}"


    # cerco per autore
    aa = Anagen.where("UPPER(denomin) like UPPER(?)", "%#{key}%")
    Rails.logger.info ".... autore #{aa.size}" 
    if aa.size > 0
      aa.each do |aut|
        rr = Article.not_hidden.by_author(aut.id) 
        if rr.size > 0
          return rr
        end
      end
    end
     
    # cerco per titolo
    aa = Article.not_hidden.where("UPPER(descriz) like UPPER(?)", "%#{key}%")
    Rails.logger.info ".... titolo #{aa.size}" 
    if aa.size > 0
      return aa
    end

    # cerco per codice
    aa = Article.not_hidden.where("codice = ?",key)
    Rails.logger.info ".... codice #{aa.size}" 
    if aa.size > 0
      return aa
    end

    []

  end

  private
    def require_no_rigdocs
      self.errors.add :base, "Almeno una riga documento fa riferimento all'articolo che si desidera eliminare."
      raise ActiveRecord::RecordInvalid.new self unless rigdocs.count == 0
    end
end

