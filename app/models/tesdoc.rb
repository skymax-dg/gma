include TesdocsHelper
class Tesdoc < ActiveRecord::Base
  belongs_to :causmag
  belongs_to :conto
  belongs_to :iva
  has_one :spediz, :dependent => :destroy
  has_many :rigdocs, :dependent => :destroy

  attr_accessible :azienda, :annoese, :tipo_doc, :num_doc, :data_doc, :descriz,
                  :causmag_id, :nrmagsrc, :nrmagdst, :seguefatt, :conto_id, :sconto, :iva_id

  validates :azienda, :annoese, :tipo_doc, :num_doc, :data_doc, :descriz,
            :causmag_id, :conto_id, :nrmagsrc, :nrmagdst, :seguefatt, :sconto, :presence => true
  validates :descriz,  :length => { :maximum => 150}

  scope :azdanno, lambda { |azd, anno| {:conditions => ['tesdocs.azienda = ? and tesdocs.annoese = ?', azd, anno]}}

  NRMAG     = $ParAzienda['ANAIND']['NRMAG']
  SEGUEFATT = $ParAzienda['TESDOC']['SEGUEFATT']
  TIPO_DOC  = $ParAzienda['CAUSMAG']['TIPO_DOC']

  def movmagint
    return false if self.causmag.movimpmag!='M'||self.causmag.tipo=='V'||self.causmag.tipo == 'R'
    return true
  end

  def self.new_num_doc(g_p, tpd, anno, azd)
#    (self.maximum("num_doc", :conditions => ["tipo_doc = :tpd AND annoese = :ae AND azienda = :azd",
#                                             {:tpd=>tpd, :ae=>anno, :azd=>azd}]).to_i||0) + 1
    (self.maximum("num_doc", :include => :causmag, :conditions => ["causmags.grp_prg = :g_p AND tesdocs.annoese = :ae AND tesdocs.azienda = :azd",
                                             {:g_p=>g_p, :ae=>anno, :azd=>azd}]).to_i||0) + 1
#    (self.maximum("num_doc", :conditions => ["grpprg = :g_p AND annoese = :ae AND azienda = :azd",
#                                             {:g_p=>g_p, :ae=>anno, :azd=>azd}]).to_i||0) + 1
  end

  def add1row4article(azienda)
    newprg = self.lastprgrig + 1
    error = 0
    Article.azienda(azienda).all(:order => :descriz).each do |art|
      rigdoc = self.rigdocs.build
      rigdoc.prgrig     = newprg
      rigdoc.article_id = art.id
      rigdoc.descriz    = art.descriz
      rigdoc.qta        = 0
      rigdoc.sconto     = self.sconto
      rigdoc.prezzo     = art.prezzo * (1 - rigdoc.sconto / 100)
      newprg += 1
      if rigdoc.save
      else
        error = 1
      end
    end
    return false if error == 1
    return true
  end

  def delrowqta0
    Rigdoc.find_by_sql("SELECT * FROM rigdocs 
                         WHERE rigdocs.tesdoc_id = #{self.id} 
                           AND rigdocs.qta = 0").each {|rigdoc| rigdoc.destroy}
    return true
  end

  def lastprgrig
    return self.rigdocs.last.prgrig unless self.rigdocs.empty?
    return 0
  end

  def imponibile
    imp = 0
    self.rigdocs.each{|r|imp += (r.qta * r.prezzo)}
    return imp
  end

  def impon_iva_Matrix
    imp={}
    self.rigdocs.each do |r| 
      r.iva.nil? ? ivaid=0 : ivaid=r.iva.id
      imp[ivaid]=Hash.new unless imp.key?(ivaid)
      imp[ivaid][:impon]=imp[ivaid][:impon].to_f + (r.qta * r.prezzo)
    end
    puts imp
    return imp
  end

  def impon_iva
    imp={}
    self.rigdocs.each do |r| 
      cat=""&&r.article&&r.article.categ
      r.iva.nil? ? ivaid=0 : ivaid=r.iva.id
      imp[cat]=Hash.new unless imp.key?(cat)
      imp[cat][ivaid]=Hash.new unless imp[cat].key?(ivaid)
      imp[cat][ivaid][:impon]=imp[cat][ivaid][:impon].to_f + (r.qta * r.prezzo)
    end
    puts imp
    return imp
  end

  def subtot_iva_Matrix
    imp=self.impon_iva
    tot_impon = 0.to_f
    tot_imposta = 0.to_f
    imp.each_key do |k|
      if k==0
        imp[k]=imp[k].merge({:desest=>"Iva non associata", :des=>"N/A",
                             :aliq=>"",                    :imposta=>"", :tot=>imp[k][:impon]})
      else
        iva = Iva.find(k)
        imp[k][:desest]=iva.desest
        imp[k][:des]=iva.descriz
        if iva.flese == "N"
          imp[k]=imp[k].merge({:aliq=>iva.aliq, :imposta=>imp[k][:impon]/100*iva.aliq,
                                                :tot=>imp[k][:impon]+imp[k][:imposta]})
        else
          imp[k]=imp[k].merge({:aliq=>"", :imposta=>"", :tot=>imp[k][:impon]})
        end
      end
      tot_impon += imp[k][:impon].to_f
      tot_imposta += imp[k][:imposta].to_f
    end
    imp[:T]=Hash.new
    imp[:T]={:desest=>"TOTALI", :des=>"",
             :impon=>tot_impon, :imposta=>tot_imposta, :tot=>tot_impon + tot_imposta}
    return imp
  end

  def subtot_iva
    imp=self.impon_iva
    tot_impon = 0.to_f
    tot_imposta = 0.to_f
    imp.each_key do |categ|
      imp[categ].each_key do |k|
        if k==0
          imp[categ][k]=imp[categ][k].merge({:desest=>"Iva non associata", :des=>"N/A",
                                             :aliq=>"", :imposta=>"", :tot=>imp[categ][k][:impon]})
        else
          iva = Iva.find(k)
          imp[categ][k][:desest]=iva.desest
          imp[categ][k][:des]=iva.descriz
          if iva.flese == "N"
            imposta=imp[categ][k][:impon]/100*iva.aliq
            imp[categ][k]=imp[categ][k].merge({:aliq=>iva.aliq, :imposta=>imposta,
                                               :tot=>imp[categ][k][:impon]+imposta})
          else
            imp[categ][k]=imp[categ][k].merge({:aliq=>"", :imposta=>"", :tot=>imp[categ][k][:impon]})
          end
        end
        tot_impon += imp[categ][k][:impon].to_f
        tot_imposta += imp[categ][k][:imposta].to_f
      end
    end
    imp[:T]=Hash.new
    imp[:T][:T]=Hash.new
    imp[:T][:T]={:desest=>"TOTALE",     :des=>"", :impon=>tot_impon, 
                 :imposta=>tot_imposta, :tot=>tot_impon + tot_imposta}
    return imp
  end

  def rigdocbyxls(xls, wks, rownr, hshcol)
    # Carica una riga documento per ogni riga presente nel file excel xls nello sheet wks(0base),
    # partendo dalla riga rownr 

    success = []
    errors  = []
    prgrig  = self.lastprgrig + 1
    xls.worksheet(wks).each rownr do |row|
      unless row[hshcol[:article_id_bycod]].blank? || row[hshcol[:qta]].blank? 
        @rigdoc = self.rigdocs.build # La Build valorizza automaticamente il campo rigdoc.tesdoc_id
        @rigdoc.article_id = Article.find_by_codice(row[hshcol[:article_id_bycod]].to_s.strip).id
        @rigdoc.descriz    = Article.find_by_codice(row[hshcol[:article_id_bycod]].to_s.strip).descriz
        @rigdoc.iva_id     = Article.find_by_codice(row[hshcol[:article_id_bycod]].to_s.strip).iva_id
        @rigdoc.qta        = row[hshcol[:qta]]||0
        if row[hshcol[:prezzo]].respond_to?(:value)
          @rigdoc.prezzo = row[hshcol[:prezzo]].value.to_s.sub(",",".")||0
        else
          @rigdoc.prezzo = row[hshcol[:prezzo]].to_s.sub(",",".")||0
        end
        @rigdoc.sconto = row[hshcol[:sconto]]||0
        @rigdoc.prgrig = prgrig
        if @rigdoc.qta > 0
          if @rigdoc.save
            prgrig += 1
            success << "Caricato articolo: #{row[hshcol[:article_id_bycod]]} #{@rigdoc.descriz} 
                        qta: #{@rigdoc.qta} prezzo: #{@rigdoc.prezzo} sconto: #{@rigdoc.sconto}"
          else
            errors  << "Errore articolo: #{row[hshcol[:article_id_bycod]]} #{@rigdoc.descriz} 
                        qta: #{@rigdoc.qta} prezzo: #{@rigdoc.prezzo} sconto: #{@rigdoc.sconto}"
          end
        end
      end
    end
    return errors, success
  end

  def self.tesrigdocbyxls(xls, wks, rowini, coltes, colrig)
    # Carica i documenti (ogni riga contiene sia testata che dettaglio riga),
    # ogni riga del file excel xls nello sheet wks(0base), partendo dalla riga rowini

    success = []
    errors = []
    xls.worksheet(wks).each rowini do |row|
#if check_info_riga_ok
      @new_azienda  = Anagen.find_by_codice(row[coltes[:col_azienda]].to_i).id
      @new_data_doc = row[coltes[:col_data_doc]].to_s.strip
      @new_num_doc  = row[coltes[:col_num_doc]].to_i
      @new_conto    = Conto.find_by_azienda_and_annoese_and_codice(
                            Anagen.find_by_codice(row[coltes[:col_azienda]].to_i).id,
                            row[coltes[:col_annoese]].to_i,
                            row[coltes[:col_conto_codice]].to_i).id
      if row.idx == rowini or
        @new_azienda  != @old_azienda or
        @new_data_doc != @old_data_doc or
        @new_num_doc  != @old_num_doc or
        @new_conto    != @old_conto
        @tesdoc = Tesdoc.new
        @tesdoc.azienda    = @new_azienda #Anagen.find_by_codice(row[coltes[:col_azienda]].to_i).id
        @tesdoc.annoese    = row[coltes[:col_annoese]].to_i
        @tesdoc.num_doc    = @new_num_doc #row[coltes[:col_num_doc]].to_i
        @tesdoc.tipo_doc   = 1
        @tesdoc.data_doc   = @new_data_doc #row[coltes[:col_data_doc]].to_s.strip
        @tesdoc.descriz    = row[coltes[:col_descriz]].to_s.strip
        @tesdoc.causmag_id = row[coltes[:col_causmag_id]].to_i
        if @new_conto.nil?
          errors << "conto non valido o nullo. Doc: #{@tesdoc.num_doc} del #{@tesdoc.data_doc}"
        else
          @tesdoc.conto_id = @new_conto #conto.id
        end
        @tesdoc.nrmagsrc = row[coltes[:col_nrmagsrc]].to_i
        @tesdoc.nrmagdst = row[coltes[:col_nrmagdst]].to_i
        if @tesdoc.save
          success << "Caricata testata. Azienda: #{@tesdoc.azienda} Annoese: #{@tesdoc.annoese} 
                      num_doc: #{@tesdoc.num_doc} data_doc: #{@tesdoc.data_doc} 
                      causale_id: #{@tesdoc.causmag_id} descriz: #{@tesdoc.descriz}"
        else
          errors  << "Errore testata. Azienda: #{@tesdoc.azienda} Annoese: #{@tesdoc.annoese} 
                      num_doc: #{@tesdoc.num_doc} data_doc: #{@tesdoc.data_doc}"
        end
        @old_azienda  = @new_azienda
        @old_data_doc = @new_data_doc
        @old_num_doc  = @new_num_doc
        @old_conto    = @new_conto
      end
      @rigdoc = @tesdoc.rigdocs.build # La Build valorizza automaticamente il campo rigdoc.tesdoc_id
      article = Article.find_by_azienda_and_codice(
                        @tesdoc.azienda,
                        row[colrig[:col_article_codice]].to_s.strip)
      if article.nil?
        errors << "Articolo non valido, non trovato o nullo. Doc: #{@tesdoc.num_doc} 
                   del #{@tesdoc.data_doc} codice articolo: #{row[colrig[:col_article_codice]]}"
      else
        @rigdoc.article_id = article.id
      end
      @rigdoc.descriz = row[colrig[:col_descriz]].to_s.strip
      @rigdoc.qta     = row[colrig[:col_qta]].to_i
      @rigdoc.prezzo  = row[colrig[:col_prezzo]]
      @rigdoc.prgrig  = row[colrig[:col_prgrig]].to_i
      @rigdoc.sconto  = 0
      if @rigdoc.qta > 0
        if @rigdoc.save
          success << "Caricata riga. Azienda: #{@tesdoc.azienda} num_doc: #{@tesdoc.num_doc} 
                      data_doc: #{@tesdoc.data_doc} idarticolo: #{@rigdoc.article_id} 
                      descriz: #{@rigdoc.descriz} qta: #{@rigdoc.qta} 
                      prezzo: #{@rigdoc.prezzo} prgrig: #{@rigdoc.prgrig}"
        else
          errors  << "Errore articolo. Azienda #{@tesdoc.azienda} num_doc: #{@tesdoc.num_doc} 
                      data_doc: #{@tesdoc.data_doc} idarticolo: #{@rigdoc.article_id} 
                      descriz: #{@rigdoc.descriz} qta: #{@rigdoc.qta} 
                      prezzo: #{@rigdoc.prezzo} prgrig: #{@rigdoc.prgrig}"
        end
      end
    end
    return errors, success
  end

  def self.filter (tp, des, tpc, tipo_doc, causmag, conto, azienda, annoese, page)
    # Esegure la ricerca nei documenti in base ai filtri impostati

    nrrecord = nil
    hsh = {"RS" => "denomin", "CF" => "codfis", "PI" => "pariva"}
    hshvar = Hash.new

    whcausmag         = "causmags.tipo_doc = :tipo_doc"
    hshvar[:tipo_doc] = tipo_doc.to_i
    whcausmag        += " and causmags.id = :cm" unless causmag.blank?
    hshvar[:cm]       = causmag unless causmag.blank?

    whconto      = " and contos.tipoconto IN (:tpc)"
    hshvar[:tpc] = tpc
    whconto     += " and contos.id = :cn" unless conto.blank?
    hshvar[:cn]  = conto unless conto.blank?

    whana = "" 
    whana = " and UPPER(anagens.#{hsh[tp]}) like UPPER(:d)" unless des.blank?
    hshvar[:d] = "%#{des}%" unless des.blank?
    
    nrrecord = includes(:causmag, :conto =>[:anagen]).where([whcausmag + whconto + whana, hshvar]).azdanno(
      azienda, annoese).count if page.nil?

    return includes(:causmag, :conto =>[:anagen]).
             where([whcausmag + whconto + whana, hshvar]).
               azdanno(azienda, annoese).
                 paginate(:page => page, 
                          :per_page => 10, 
                          :order => "data_doc DESC, num_doc, causmag_id"), nrrecord unless hsh[tp].nil?
  end

  def self.art_mov_vend(idart, idanagen, nrmag, anarif, azienda, tp)
    # Documenti che movimentano uno o piu' articoli per uno o piu' conti per uno o piu' magazzini
    idart == "all" ? where_art = " WHERE articles.azienda = #{azienda}" : where_art = " WHERE articles.id = #{idart}"
    if anarif == "S"
      filter_anagen = ""
      if tp == "M"
        # Movimenti per l'anagrafica interna di riferimento
        filter_tpmov = " AND causmags.tipo IN ('U','E','T')"
      else
        # Vendite per l'anagrafica interna di riferimento
        filter_tpmov = " AND causmags.tipo IN ('U','E','V','R')"
      end
    else
      idanagen.to_s == "" ? filter_anagen = "" : filter_anagen = " AND anagens.id = #{idanagen}"
      filter_tpmov = " AND causmags.tipo IN ('U','E','V','R')"
    end
    if tp == "M"
      filter_causmag = " AND causmags.movimpmag IN ('M', 'I') "
      nrmag == "" ? filter_nrmag = "" : filter_nrmag = " AND (tesdocs.nrmagsrc = #{nrmag.to_s} OR tesdocs.nrmagdst = #{nrmag})"
    else
      filter_nrmag = ""
      filter_causmag = " AND causmags.contabile = 'S' "
    end
    Tesdoc.find_by_sql("SELECT DISTINCT articles.id AS artid, articles.codice AS codice
                          FROM tesdocs INNER JOIN rigdocs  ON (rigdocs.tesdoc_id = tesdocs.id)
                                       INNER JOIN articles ON (articles.id = rigdocs.article_id)
                                       INNER JOIN causmags ON (tesdocs.causmag_id = causmags.id)
                                       INNER JOIN contos   ON (tesdocs.conto_id = contos.id)
                                       INNER JOIN anagens  ON (contos.anagen_id = anagens.id) 
                         #{where_art} #{filter_causmag} #{filter_anagen} #{filter_tpmov} #{filter_nrmag} ORDER BY articles.codice")
  end
  
  def self.anagen_mov_artic(idart, idanagen, nrmag, anarif, tp)
    # Elenco conti utilizzati dai movimenti/vendite di un articolo per uno o piu' magazzini
    return Tesdoc.find_by_sql("SELECT '' AS idanagen") if anarif == "S"

    idanagen.to_s == "" ? filter_anagen = "" : filter_anagen = " AND anagens.id = #{idanagen}"
    filter_tpmov = " AND causmags.tipo IN ('U','E','V','R')"
    if tp == "M"
      where_causmag = " WHERE causmags.movimpmag IN ('M', 'I') "
      nrmag == "" ? filter_nrmag = "" : filter_nrmag = " AND (tesdocs.nrmagsrc = #{nrmag} 
                                                         OR   tesdocs.nrmagdst = #{nrmag})"
    else
      where_causmag = " WHERE causmags.contabile = 'S' "
      filter_nrmag = ""
    end
    Tesdoc.find_by_sql("SELECT DISTINCT anagens.id AS idanagen, anagens.denomin AS denomin
                          FROM tesdocs INNER JOIN rigdocs  ON (rigdocs.tesdoc_id = tesdocs.id)
                                       INNER JOIN articles ON (articles.id = rigdocs.article_id)
                                       INNER JOIN causmags ON (tesdocs.causmag_id = causmags.id)
                                       INNER JOIN contos   ON (tesdocs.conto_id = contos.id)
                                       INNER JOIN anagens  ON (contos.anagen_id = anagens.id) 
                         #{where_causmag} AND articles.id = #{idart} #{filter_anagen} #{filter_tpmov} 
                         #{filter_nrmag} ORDER BY denomin")
  end

  def self.mag_mov_artic_anagen(idart, idanagen, nrmag, anarif, grpmag, tp)
    # Elenco magazzini movimentati da un articolo su un conto
    return Tesdoc.find_by_sql("SELECT '' AS nrmag") if (grpmag == "S") or (tp == "V")
    filter_anagen = ""
    if anarif == "S"
      # Movimenti per l'anagrafica interna di riferimento
      filter_magsrc = " AND  (   
                                  (causmags.movimpmag = 'M' and causmags.tipo IN ('T','U'))
                               OR (causmags.movimpmag = 'I' and causmags.tipo IN ('U'))
                             )"
      filter_magdst = " AND  (   
                                  (causmags.movimpmag = 'M' and causmags.tipo IN ('T','E'))
                               OR (causmags.movimpmag = 'I' and causmags.tipo IN ('E'))
                             )"
    else
      filter_anagen = " AND anagens.id = #{idanagen}" unless idanagen == ""
      filter_magsrc = " AND  (causmags.movimpmag = 'M' and causmags.tipo IN ('V','E'))"
      filter_magdst = " AND  (causmags.movimpmag = 'M' and causmags.tipo IN ('R','U'))"
    end
    nrmag == "" ? filter_nrmagsrc = "" : filter_nrmagsrc = " AND tesdocs.nrmagsrc = #{nrmag}"
    nrmag == "" ? filter_nrmagdst = "" : filter_nrmagdst = " AND tesdocs.nrmagdst = #{nrmag}"
    Tesdoc.find_by_sql("SELECT DISTINCT tesdocs.nrmagsrc AS nrmag
                          FROM tesdocs INNER JOIN rigdocs  ON (rigdocs.tesdoc_id = tesdocs.id)
                                       INNER JOIN articles ON (articles.id = rigdocs.article_id)
                                       INNER JOIN causmags ON (tesdocs.causmag_id = causmags.id)
                                       INNER JOIN contos   ON (tesdocs.conto_id = contos.id)
                                       INNER JOIN anagens  ON (contos.anagen_id = anagens.id) 
                         WHERE causmags.movimpmag IN ('M', 'I') 
                           AND articles.id = #{idart} #{filter_anagen} #{filter_magsrc} #{filter_nrmagsrc} 
                        UNION 
                        SELECT DISTINCT tesdocs.nrmagdst AS nrmag
                          FROM tesdocs INNER JOIN rigdocs  ON (rigdocs.tesdoc_id = tesdocs.id)
                                       INNER JOIN articles ON (articles.id = rigdocs.article_id)
                                       INNER JOIN causmags ON (tesdocs.causmag_id = causmags.id)
                                       INNER JOIN contos   ON (tesdocs.conto_id = contos.id)
                                       INNER JOIN anagens  ON (contos.anagen_id = anagens.id)
                         WHERE causmags.movimpmag IN ('M', 'I') 
                           AND articles.id = #{idart} #{filter_anagen} #{filter_magdst} #{filter_nrmagdst} 
                      ORDER BY nrmag")
  end

  def self.mov_artanagenmag(idart, idanagen, nrmag, anarif, grpmag)
    # Elenco movimenti per un articolo per un anagrafica e per un magazzino
    filter_anagen = ""
    if anarif == "S"
      # Movimenti per l'anagrafica interna di riferimento
      filter_magsrc = " AND  (   
                                  (causmags.movimpmag = 'M' and causmags.tipo IN ('T','U'))
                               OR (causmags.movimpmag = 'I' and causmags.tipo IN ('U'))
                             )"
      filter_magdst = " AND  (   
                                  (causmags.movimpmag = 'M' and causmags.tipo IN ('T','E'))
                               OR (causmags.movimpmag = 'I' and causmags.tipo IN ('E'))
                             )"
    else 
      filter_anagen = " AND anagens.id = #{idanagen}" unless idanagen.to_s == ""
      filter_magsrc = " AND  (causmags.movimpmag = 'M' and causmags.tipo IN ('V','E'))"
      filter_magdst = " AND  (causmags.movimpmag = 'M' and causmags.tipo IN ('R','U'))"
    end
    if grpmag == "S"
      filter_nrmagsrc = ""
      filter_nrmagdst = ""
    else
      filter_nrmagsrc = " AND tesdocs.nrmagsrc = #{nrmag}"
      filter_nrmagdst = " AND tesdocs.nrmagdst = #{nrmag}"
    end
    Tesdoc.find_by_sql("SELECT tesdocs.data_doc   AS Data_doc, tesdocs.num_doc  AS Numero,
                               causmags.descriz   AS Causale,  tesdocs.nrmagsrc AS Nrmag,
                               causmags.movimpmag AS Movmag,   causmags.tipo    AS Tipomov,
                               rigdocs.qta        AS Qta,      'SRC'            AS Tipomag
                          FROM tesdocs INNER JOIN rigdocs  ON (rigdocs.tesdoc_id = tesdocs.id)
                                       INNER JOIN articles ON (articles.id = rigdocs.article_id)
                                       INNER JOIN causmags ON (tesdocs.causmag_id = causmags.id)
                                       INNER JOIN contos   ON (tesdocs.conto_id = contos.id)
                                       INNER JOIN anagens  ON (contos.anagen_id = anagens.id)
                         WHERE causmags.movimpmag IN ('M', 'I') 
                                         AND articles.id = #{idart} #{filter_anagen} #{filter_magsrc} #{filter_nrmagsrc} 
                        UNION 
                        SELECT tesdocs.data_doc   AS Data_doc, tesdocs.num_doc  AS Numero,
                               causmags.descriz   AS Causale,  tesdocs.nrmagdst AS Nrmag,
                               causmags.movimpmag AS Movmag,   causmags.tipo    AS Tipomov,
                               rigdocs.qta        AS Qta,      'DST'            AS Tipomag
                          FROM tesdocs INNER JOIN rigdocs  ON (rigdocs.tesdoc_id = tesdocs.id)
                                       INNER JOIN articles ON (articles.id = rigdocs.article_id)
                                       INNER JOIN causmags ON (tesdocs.causmag_id = causmags.id)
                                       INNER JOIN contos   ON (tesdocs.conto_id = contos.id)
                                       INNER JOIN anagens  ON (contos.anagen_id = anagens.id)
                         WHERE causmags.movimpmag IN ('M', 'I') 
                                         AND articles.id = #{idart} #{filter_anagen} #{filter_magdst} #{filter_nrmagdst} 
                     ORDER BY data_doc, Numero")
  end

  def self.ven_artanagen(idart, idanagen, anarif)
    # Elenco vendite di un articolo per una anagrafica
    (anarif != "S" and idanagen.to_s != "") ? filter_anagen = " AND anagens.id = #{idanagen}" : filter_anagen = ""

    Tesdoc.find_by_sql("SELECT tesdocs.data_doc   AS Data_doc, tesdocs.num_doc  AS Numero,
                               causmags.descriz   AS Causale,  causmags.tipo    AS Tipomov,
                               rigdocs.qta        AS Qta,      rigdocs.prezzo   AS Prezzo
                          FROM tesdocs INNER JOIN rigdocs  ON (rigdocs.tesdoc_id = tesdocs.id)
                                       INNER JOIN articles ON (articles.id = rigdocs.article_id)
                                       INNER JOIN causmags ON (tesdocs.causmag_id = causmags.id)
                                       INNER JOIN contos   ON (tesdocs.conto_id = contos.id)
                                       INNER JOIN anagens  ON (contos.anagen_id = anagens.id)
                         WHERE causmags.contabile = 'S'
                           AND causmags.tipo IN ('U','E','V','R')
                           AND articles.id = #{idart} #{filter_anagen} 
                     ORDER BY data_doc, Numero")
  end
end
