class Anagen < ActiveRecord::Base
  #has_many :prezzoarticclis, :foreign_key => "anag_id",
  #                           :dependent => :destroy
  before_destroy :require_no_contos

  has_many :contos
  has_many :anainds, :dependent => :destroy
  has_many :anag_socials, :dependent => :destroy
  has_many :key_word_rels, as: :key_wordable
  has_many :key_words, through: :key_word_rels
  has_many :anagen_articles
  has_many :articles, through: :anagen_articles
  has_many :event_states
  has_many :events, through: :event_states
  has_many :coupons, dependent: :destroy

  belongs_to :localita, :foreign_key => "luogonas_id"
  belongs_to :paese_nas, :foreign_key => "paese_nas_id", class_name: "Paese"
  belongs_to :primary_address, :foreign_key => "primary_address_id", class_name: "Anaind"

  has_one :agente, :dependent => :destroy
  has_one :user, :dependent => :destroy
  
#  default_scope :order => 'anagens.denomin ASC' Non funziona perchè c'è una select max

  attr_accessible :codice, :tipo, :denomin, :codfis, :pariva, :dtnas, :luogonas_id, :sesso,
                  :telefono, :email, :fax, :web, :sconto, :referente, :codnaz, :codident, :pec, :bio, :userp, :cod_cig, :cod_cup, 
                  :split_payement, :cod_carta_docente, :cod_carta_studente, :fl1_consenso, :fl2_consenso, :dt_consenso, :fl_newsletter,
                  :cellulare, :youtube_presentation

  validates :codice, :tipo, :denomin, :presence => true
  validates :codice, :denomin, :uniqueness => true
  validates :codfis, :uniqueness => true, :unless => "codfis.blank?"
  validates :pariva, :uniqueness => true, :unless => "pariva.blank?"

  # Fare un validate su :tipo con i valori ammessi
  validates :tipo,      :length => {:maximum => 1}
  validates :denomin,   :length => {:maximum => 150}
  validates :referente, :length => {:maximum => 150}
  validates :codfis,    :length => {:maximum => 16}
  validates :pariva,    :length => {:maximum => 11}
  validates :sesso,     :length => {:maximum => 1}
  validates :telefono,  :length => {:maximum => 20}
  validates :email,     :length => {:maximum => 50}
  validates :fax,       :length => {:maximum => 20}
  validates :web,       :length => {:maximum => 50}
  validates :cellulare, :length => {:maximum => 15}

  TIPO = $ParAzienda['ANAGEN']['TIPO_SOGGETTO']

  SPLIT_PAYEMENTS = [
    ["NO",0], 
    ["SI",1]
  ]

  def self.filter (tp, des, page)
    # Esegure la ricerca delle anagrafiche soggetto in base ai filtri impostati
    hsh = {"RS" => "denomin", "CF" => "codfis", "PI" => "pariva"}
    nrrecord = nil
    hshvar = Hash.new
    whana = "" 
    whana = " UPPER(anagens.#{hsh[tp]}) like UPPER(:d)" unless des.blank?
    hshvar[:d] = "%#{des}%" unless des.blank?

    # Se il param. page non è valorizzato allora stiamo facendo una nuova ricerca altrimenti
    # abbiamo richiesto una pagina successiva o precedente e non serve la count
    nrrecord = where([whana, hshvar]).count if page.nil?

    return where([whana, hshvar]).paginate(:page => page, :per_page => 10,
                                           :order => "denomin ASC"), nrrecord unless hsh[tp].nil?
  end

  def sedelegale
    sl={}
    self.anainds.each {|ind| sl={:indir => ind.indir, :desloc => ind.desloc} if ind.flsl=="S"}
    sl
  end

  def magsavailable(inivalue)
    # Ricerco i magazzini inseriti sull'anagrafica, con il .map creo un array formato dai vari nrmag,
    # con il comando select applicato all'hash Anaind::NRMAG restituisco un altro hash formato
    # dai magazzini disponibili ovvero che hanno corrispondenza sull'array creato dal comando map
#    mags = Anaind.find(:all,
#                       :select => "nrmag",
#                       :conditions => ["anagen_id = :anaid and flmg = 'S'", {:anaid => self.id}]).map{|c| c.nrmag}
#    Hash[*Anaind::NRMAG.select{|k,v| (mags+inivalue).index(k)}.flatten]
    magsplus=Hash.new
    mags = Anaind.find(:all,
                             :select => "nrmag, desloc",
                             :conditions => ["anagen_id = :anaid and flmg = 'S'", {:anaid => self.id}]
                             ).each{|m| magsplus[m.nrmag]=m.desloc}
    inivalue.each{|v|magsplus[v]=Anaind::NRMAG[v]}
    magsplus
  end

  def self.without_conto_or_self(id, az, ae, tc)
    Anagen.all(:conditions => "id = #{id||0} OR NOT EXISTS (SELECT 1 FROM contos WHERE anagen_id = anagens.id AND azienda = #{az} AND annoese = #{ae} AND tipoconto = '#{tc}')", :order => :denomin)
  end

  def self.without_agente_or_self(id)
    Anagen.all(:conditions => "id = #{id||0} OR NOT EXISTS (SELECT 1 FROM agentes WHERE anagen_id = anagens.id)", :order => :denomin)
  end

  def self.with_mag
    Anagen.all(:joins=>:anainds, :conditions => "anainds.flmg = 'S'", :order => :denomin)
  end

  def self.find_by_cf_pi(cf, pi)
    r=nil
    r=Anagen.find_by_codfis(cf) if (not cf.blank?)
    r=Anagen.find_by_pariva(pi) if (not pi.blank?) && r.nil
    r=Anagen.find_by_codfis(pi) if (not pi.blank?) && r.nil
  end

  def self.newcod()
    (self.maximum("codice").to_i||0) + 1
  end

  def pi_or_cf
    self.pariva && (not self.pariva.blank?) ? self.pariva : self.codfis||""
  end

  def contocli(az, ae)
    contos.where(["tipoconto = 'C' and azienda = :az and annoese = :ae", {:az=>az, :ae=>ae}])
  end

  def self.findbytpconto(azienda, tipoconto)
    find_by_sql("SELECT DISTINCT anagens.id, anagens.denomin 
                   FROM anagens INNER JOIN contos ON (anagens.id = contos.anagen_id)
                  WHERE contos.tipoconto = '#{tipoconto.to_s}' AND contos.azienda = #{azienda.to_s} 
                  ORDER BY anagens.denomin")
  end

  #def self.tables_list
  #  list  = []
  #  list << {plural: 'Clienti',       singular: "Cliente",       type: :Customer,   cls: Customer}
  #  list << {plural: 'Fornitori',     singular: "Fornitore",     type: :Supplier,   cls: Supplier}
  #  list << {plural: 'Insegnanti',    singular: "Insegnante",    type: :Teacher,    cls: Teacher}
  #  list << {plural: 'Organizzatori', singular: "Organizzatore", type: :Organizer,  cls: Organizer}
  #  list << {plural: 'Autori',        singular: "Autore",        type: :Author,     cls: Author}
  #  list << {plural: 'Abbonati',      singular: "Abbonato",      type: :Subscriber, cls: Subscriber}
  #  list << {plural: 'Studenti',      singular: "Studente",      type: :Student,    cls: Student}
  #  #list << {plural: '', singular: "" ,type: , cls: }

  #  list.sort { |e1,e2| e1[:plural] <=> e2[:plural] }
  #end

  #def self.decode_table(cls)
  #  self.tables_list.find { |r| r[:type] == cls } || {}
  #end

  def has_key_word?(kw)
    self.key_words.include?(kw)
  end

  def author?
    kw = KeyWordAnagen.where(desc: "Autore").first
    self.has_key_word? kw 
  end

  def stampatore?
    kw = KeyWordAnagen.where(desc: "Stampatore").first
    self.has_key_word? kw 
  end

  def produttore?
    kw = KeyWordAnagen.where(desc: "Produttore").first
    self.has_key_word? kw 
  end

  def connect_article(art_id, mode=nil)
    if Article.exists? art_id
      art = Article.find(art_id)
      unless self.has_article?(art)
        if mode
          AnagenArticle.create(anagen: self, article: art, mode: mode)
        else
          self.articles << art
        end
        true
      end
    end
  end

  def has_article?(art)
    self.articles.include? art
  end

  def remove_article(art_id)
    if Article.exists? art_id
      art = Article.find(art_id)
      self.articles.delete(art)
      true
    end
  end

  def self.teachers
    kw = KeyWordAnagen.where(desc: "Insegnante").first
    kw ? Anagen.joins(:key_words).where("key_words.id = ?", kw.id).order("anagens.denomin") : []
  end

  def self.organizers
    kw = KeyWordAnagen.where(desc: "Organizzatore").first
    kw ? Anagen.joins(:key_words).where("key_words.id = ?", kw.id).order("anagens.denomin") : []
  end

  def self.courses_locations
    kw = KeyWordAnagen.where(desc: "Sede corso").first
    kw ? Anagen.joins(:key_words).where("key_words.id = ?", kw.id).order("anagens.denomin") : []
  end

  def self.authors
    kw = KeyWordAnagen.where(desc: "Autore").first
    kw ? Anagen.joins(:key_words).where("key_words.id = ?", kw.id).order("anagens.denomin") : []
  end

  def self.printers
    kw = KeyWordAnagen.where(desc: "Stampatore").first
    kw ? Anagen.joins(:key_words).where("key_words.id = ?", kw.id).order("anagens.denomin") : []
  end

  def self.suppliers
    kw = KeyWordAnagen.where(desc: "Produttore").first
    kw ? Anagen.joins(:key_words).where("key_words.id = ?", kw.id).order("anagens.denomin") : []
  end

  def connect_event(event_id, mode)
    if Event.exists? event_id
      unless self.has_event?(event_id, mode)
        EventState.create(anagen: self, event_id: event_id, mode: mode)
        true
      end
    end
  end

  def has_event?(event_id, mode)
    self.event_states.where(mode: mode, event_id: event_id).count > 0
  end

  def remove_event(event_id, mode)
    if Event.exists? event_id
      event = Event.find(event_id)
      self.events.delete(event)
      true
    end
  end

  def prenotazioni
    #kw = KeyWordEvent.type_event_book
    #self.events.joins(:key_words).where("key_words.id = ?", kw.id).order("events.dt_event DESC")
    kw = KeyWordArticle.where(desc: "Libro").first
    self.events.select { |e| e.article.has_key_word?(kw) }
  end

  def corsi
    #kw = KeyWordEvent.type_event_course
    #self.events.joins(:key_words).where("key_words.id = ?", kw.id).order("events.dt_event DESC")
    kw = KeyWordArticle.where(desc: "Evento").first
    self.events.select { |e| e.article.has_key_word?(kw) }
  end

  def abbonamenti
    kw = KeyWordArticle.where(desc: "Rivista").first
    self.events.select { |e| e.article.has_key_word?(kw) }
    #kw = KeyWordEvent.type_event_magazine
    #self.events.joins(:key_words).where("key_words.id = ?", kw.id).order("events.dt_event DESC")
  end

  def encode_denomin(surname, name)
    if surname.split.size > 1
      self.denomin = "%s, %s"%[surname, name]
    else
      self.denomin = "%s %s"%[surname, name]
    end
  end

  def decode_denomin
    if self.denomin =~ /,/
      self.denomin.split(",")[0..1].map { |x| x.strip }
    else
      surname = self.denomin.split()[0].strip
      name = self.denomin.gsub(surname, '').strip
      [surname, name]
    end
  end

  def use_rag_soc?
    ["G", "I", "E"].include? self.tipo
  end

  def gac_dati_completi?
    self.appo_info_check[0]
  end

  def appo_info_check
    st = true
    ds = []
    ds << [:referente,          ["G", "I", "E"] ]
    ds << [:denomin,            ["G", "I", "E", "F", "S", "D"] ]
    ds << [:codfis,             ["G", "I", "E", "F", "S", "D"] ]
    ds << [:pariva,             ["G", "I", "E"] ]
    ds << [:cod_carta_studente, ["S"] ]
    ds << [:cod_carta_docente,  ["D"] ]
    ds << [:cellulare,          ["G", "I", "E", "F", "S", "D"]]
    ds << [:codident,           ["G", "I", "E"] ]
    ds << [:pec,                ["G", "I", "E"] ]
    ds << [:cod_cig,            ["E"] ]
    ds << [:cod_cup,            ["E"] ]

    ee = []
    
    ds.each do |k, tps|
      if tps.include?(self.tipo)
        puts "Checking #{k} on #{self[k]}"
        ee << "manca #{k}" if ["", nil].include?(self[k])
      end
    end

    [ ee == [], ee ]
  end

  # LCG 191102
  def info_check
    ck = appo_info_check
    if ck[0]
      "dati corretti"
    else
      ck[1].join(",")
    end
  end

  def self.add_addr(par)
    if Anagen.exists?(par[:anagen_id])
      an = Anagen.find(par[:anagen_id])
      addr = an.anainds.create(flsl: "N", flsp: "S", flmg: "N", nrmag: 0)
      addr.encode_indir(par[:indirizzo], par[:civico])
      addr.desloc = par[:citta]
      addr.cap = par[:cap]
      if addr.save 
        return [true, addr.id] 
      else
        Rails.logger.info addr.errors.full_messages
        return [false, nil]
      end
    end
  end

  def self.random_author
    kw = KeyWordAnagen.where(desc: "Autore").first
    n = Random.rand(kw.key_word_rels.count)
    id = kw.key_word_rels.offset(n).first.key_wordable_id
    Anagen.find(id)
  end

  def get_coupons
    c1 = self.coupons.not_used.order("coupons.dt_start DESC").map { |x| x.map_json }
    c1.concat Coupon.not_discount_codes.generic.order("coupons.dt_start DESC").map { |x| x.map_json }
  end

  def self.gen_coupon(anagen_id, params, user_id)
    h = {
      anagen_id: anagen_id, 
      code: params[:coupon_code], 
      dt_start: params[:coupon][:dt_start],
      dt_end: params[:coupon][:dt_end],
      value: params[:coupon_val],
      perc: params[:coupon_perc],
      ord_min: params[:coupon_ord_min],
      batch_code: Coupon.gen_batch_code(user_id)
    }
    Rails.logger.info "-------------------- ANAGEN.GEN_COUPON -> h: #{h.to_s}"
    Coupon.create( h ) 
  end

  def get_socials
    h = {}
    self.anag_socials.not_hidden.map do |x| 
      h[x.dtype] = x.saddr
    end
    h
  end

  def orders(cod_azienda, anno=0)
    #h = { azienda: cod_azienda, tipoconto: "C", anagen_id: self.id, tesdocs: {causmag_id: 77} }
    #if anno != 0
    #  h[:annoese] = anno
    #end
    #Conto.joins(:tesdocs).where( h )
    query = 'SELECT * FROM "contos" INNER JOIN "tesdocs" ON "tesdocs"."conto_id" = "contos"."id" WHERE "contos"."azienda" = %d AND "contos"."tipoconto" = %s AND "contos"."anagen_id" = %d AND "tesdocs"."causmag_id" = 77 ORDER BY contos.descriz ASC'%[cod_azienda, "'C'", self.id]
    Conto.find_by_sql( query )
    #tmp = ds.map { |x| x.tesdocs.where(causmag_id: 77) }
    #tmp.flatten.uniq
  end

  def newsletter?
    self.fl_newsletter == 1
  end

  #def add_digital_content(article_id)
  #end

  def has_order_in_dt_range?(dt1, dt2)
    if (dt1 && dt2 && dt1 <= dt2) 
      dt1.year.upto(dt2.year) do |y|
        self.orders(self.user.azienda, y).each do |c|
          dt = Date.parse(c.data_doc)
          return true if dt >= dt1 && dt <= dt2
        end
      end
    end
    false
  end

  def has_order_by_key_word?(kw_id, dt1=nil, dt2=nil)
    kw = KeyWord.find kw_id
    if (dt1 && dt2 && dt1 <= dt2) 
      dt1.year.upto(dt2.year) do |y|
        self.orders(self.user.azienda, y).each do |c|
          return true if check_key_word_tesdoc(c.id, kw)
        end
      end
    else
      self.orders(self.user.azienda).each do |c|
        return true if check_key_word_tesdoc(c.id, kw)
      end
    end
    false
  end

  def has_order_by_article?(art_id, dt1=nil, dt2=nil)
    if (dt1 && dt2 && dt1 <= dt2) 
      dt1.year.upto(dt2.year) do |y|
        self.orders(self.user.azienda, y).each do |c|
          return true if check_article_tesdoc(c.id, art_id)
        end
      end
    else
      self.orders(self.user.azienda).each do |c|
        return true if check_article_tesdoc(c.id, art_id)
      end
    end
    false
  end

  def coupon_in_scadenza?
    self.coupons.each do |c|
      if !c.used? && c.dt_start <= Date.today && c.dt_end >= Date.today && (Date.today + Coupon::NOTIFY_DAYS.days >= c.dt_end)
        return true
      end
    end
    false
  end

  def is_in_region?(reg_code)
    self.anainds.each do |ind|
      if ind.localita && ind.localita.cod_regione == reg_code
        return true
      end
    end
    false
  end

  def is_in_province?(prov_code)
    self.anainds.each do |ind|
      if ind.localita && ind.localita.prov == prov_code
        return true
      end
    end
    false
  end

  def self.activate_discount_code(anag_id, dc)
    n = 0
    if Anagen.exists?(anag_id) && !Coupon.has_anagen?(anag_id, dc)
      cs = Coupon.discount_codes.where(discount_code: dc)
      cs.each do |c|
        nc = c.duplicate
        nc.state = 0	# coupon attivo
        nc.anagen_id = anag_id
        nc.save
        n += 1
      end # each
    end # if
    n	# ritorno il numero di coupon generati, se vale 0 c'è stato un problema
  end

  private
    def check_article_tesdoc(t_id, art_id)
      t = Tesdoc.find(t_id)
      t.rigdocs.each do |r|
        return true if r.article && r.article_id == art_id
      end
      false
    end

    def check_key_word_tesdoc(t_id, kw)
      t = Tesdoc.find(t_id)
      t.rigdocs.each do |r|
        return true if r.article && r.article.has_key_word?(kw)
      end
      false
    end

    def require_no_contos
      self.errors.add :base, "Almeno un conto fa riferimento all' anagrafica che si desidera eliminare."
      raise ActiveRecord::RecordInvalid.new self unless contos.count == 0
    end
end
