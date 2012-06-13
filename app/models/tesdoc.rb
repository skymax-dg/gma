class Tesdoc < ActiveRecord::Base
  belongs_to :causmag
  belongs_to :conto
  has_many :rigdocs, :dependent => :destroy

  attr_accessible :azienda, :annoese, :tipo_doc, :num_doc, :data_doc, :descriz,
                  :causmag_id, :nrmagsrc, :nrmagdst, :seguefatt, :conto_id, :sconto

  validates :azienda, :annoese, :tipo_doc, :num_doc, :data_doc, :descriz,
            :causmag_id, :conto_id, :nrmagsrc, :nrmagdst, :seguefatt, :sconto, :presence => true
  validates :descriz,  :length => { :maximum => 150}

  NRMAG = $ParAzienda['ANAIND']['NRMAG']
  SEGUEFATT = $ParAzienda['TESDOC']['SEGUEFATT']
  TIPO_DOC = $ParAzienda['CAUSMAG']['TIPO_DOC']

  def rigdocbyxls(xls, wks, rownr, hshcol)
    # Carica una riga documento per ogni riga presente nel file excel xls nello sheet wks(0base),
    # partendo dalla riga rownr 

    success = []
    errors = []
    prgrig = 1
    prgrig = self.rigdocs.last.prgrig + 1 unless self.rigdocs.empty?
    xls.worksheet(wks).each rownr do |row|
      unless row[hshcol[:article_id_bycod]].blank? || row[hshcol[:qta]].blank? 
        @rigdoc = self.rigdocs.build # La Build valorizza automaticamente il campo rigdoc.tesdoc_id
        @rigdoc.article_id = Article.find_by_codice(row[hshcol[:article_id_bycod]].to_s.strip).id
        @rigdoc.descriz = Article.find_by_codice(row[hshcol[:article_id_bycod]].to_s.strip).descriz
        @rigdoc.qta = row[hshcol[:qta]]||0
        @rigdoc.prezzo = row[hshcol[:prezzo]].to_s.sub(",",".")||0
        @rigdoc.sconto = row[hshcol[:sconto]]||0
        @rigdoc.prgrig = prgrig
        if @rigdoc.qta > 0
          if @rigdoc.save
            prgrig += 1
            success << "Caricato articolo:" + row[hshcol[:article_id_bycod]].to_s.strip + " " + @rigdoc.descriz +
                       " qta:" + @rigdoc.qta.to_s + " prezzo:" + @rigdoc.prezzo.to_s + " sconto:" + @rigdoc.sconto.to_s
          else
            errors  << "Errore articolo:" + row[hshcol[:article_id_bycod]].to_s.strip + " " + @rigdoc.descriz +
                       " qta:" + @rigdoc.qta.to_s + " prezzo:" + @rigdoc.prezzo.to_s + " sconto:" + @rigdoc.sconto.to_s
          end
        end
      end
    end
    return errors, success
  end

  def self.filter (tp, des, tpc, tipo_doc, causmag, conto, page)
    # Esegure la ricerca nei documenti in base ai filtri impsotati

    hsh = {"RS" => "denomin", "CF" => "codfis", "PI" => "pariva"}
    hshvar = Hash.new

    whcausmag = "causmags.tipo_doc = :tipo_doc"
    hshvar[:tipo_doc] = tipo_doc.to_i
    whcausmag += " and causmags.id = :cm" unless causmag == "" or causmag.nil?
    hshvar[:cm] = causmag unless causmag == "" or causmag.nil?

    whconto = " and contos.tipoconto IN (:tpc)"
    hshvar[:tpc] = tpc
    whconto += " and contos.id = :cn" unless conto == "" or conto.nil?
    hshvar[:cn] = conto unless conto == "" or conto.nil?

    whana = "" 
    whana = " and anagens.#{hsh[tp]} like :d" unless des == ""
    hshvar[:d] = "%#{des}%" unless des == ""
    
    includes(:causmag, :conto =>[:anagen]).where([whcausmag + whconto + whana,
                                                  hshvar]).paginate(:page => page, :per_page => 10) unless hsh[tp].nil?
  end

  def self.art_mov(idart, idconto, nrmag, anarif)
    # Documenti che movimentano uno o più articoli per uno o più conti per uno o più magazzini
    idart == "all" ? filter_art = "" : filter_art = " AND articles.id = " + idart.to_s
    if anarif == "S"
      filter_conto = ""
      # Movimenti per l'anagrafica interna di riferimento
      filter_tpmov = " AND causmags.tipo IN ('U','E','T')"
    else 
      idconto == "" ? filter_conto = "" : filter_conto = " AND contos.id = " + idconto.to_s
      filter_tpmov = " AND causmags.tipo IN ('U','E','V','R')"
    end 
    nrmag == "" ? filter_nrmag = "" : filter_nrmag = " AND (tesdocs.nrmagsrc = " + nrmag.to_s +
                                                     " OR   tesdocs.nrmagdst = " + nrmag.to_s + ")"
    Tesdoc.find_by_sql("SELECT DISTINCT articles.id AS artid
                          FROM tesdocs INNER JOIN rigdocs  ON (rigdocs.tesdoc_id = tesdocs.id)
                                       INNER JOIN articles ON (articles.id = rigdocs.article_id)
                                       INNER JOIN causmags ON (tesdocs.causmag_id = causmags.id)
                                       INNER JOIN contos   ON (tesdocs.conto_id = contos.id)
                                       WHERE causmags.movimpmag IN ('M', 'I') " + filter_art +
                                       filter_conto + filter_tpmov + filter_nrmag +
                     " ORDER BY articles.id")
  end
  
  def self.conti_mov_artic(idart, idconto, nrmag, anarif)
    # Elenco conti movimentati da un articolo per uno o più magazzini
    return Tesdoc.find_by_sql("SELECT '' AS idconto") if anarif == "S"

    idconto == "" ? filter_conto = "" : filter_conto = " AND contos.id = " + idconto.to_s
    filter_tpmov = " AND causmags.tipo IN ('U','E','V','R')"
    nrmag == "" ? filter_nrmag = "" : filter_nrmag = " AND (tesdocs.nrmagsrc = " + nrmag.to_s +
                                                     " OR   tesdocs.nrmagdst = " + nrmag.to_s + ")"
    Tesdoc.find_by_sql("SELECT DISTINCT contos.id AS idconto
                          FROM tesdocs INNER JOIN rigdocs  ON (rigdocs.tesdoc_id = tesdocs.id)
                                       INNER JOIN articles ON (articles.id = rigdocs.article_id)
                                       INNER JOIN causmags ON (tesdocs.causmag_id = causmags.id)
                                       INNER JOIN contos   ON (tesdocs.conto_id = contos.id)
                                       WHERE causmags.movimpmag IN ('M', 'I') 
                                         AND articles.id = " + idart.to_s +
                                       filter_conto + filter_tpmov + filter_nrmag +
                    " ORDER BY idconto")
  end

  def self.mag_mov_artic_conto(idart, idconto, nrmag, anarif, grpmag)
    # Elenco magazzini movimentati da un articolo su un conto
    return Tesdoc.find_by_sql("SELECT '' AS nrmag") if grpmag == "S"

    filter_conto = ""
    if anarif == "S"
      # Movimenti per l'anagrafica interna di riferimento
      filter_magsrc = " AND  (   
                                  (causmags.movimpmag = 'M' and causmags.tipo IN ('T','U'))
                               OR (causmags.movimpmag = 'I' and causmags.tipo IN ('E'))
                             )"
      filter_magdst = " AND  (   
                                  (causmags.movimpmag = 'M' and causmags.tipo IN ('T','E'))
                               OR (causmags.movimpmag = 'I' and causmags.tipo IN ('U'))
                             )"
    else
      filter_conto = " AND contos.id = " + idconto.to_s unless idconto == ""
      filter_magsrc = " AND  (   
                                  (causmags.movimpmag = 'M' and causmags.tipo IN ('R','V','E'))
                               OR (causmags.movimpmag = 'I' and causmags.tipo IN ('U'))
                             )"
      filter_magdst = " AND  (   
                                  (causmags.movimpmag = 'M' and causmags.tipo IN ('R','V','U'))
                               OR (causmags.movimpmag = 'I' and causmags.tipo IN ('E'))
                             )"
    end
    Tesdoc.find_by_sql("SELECT DISTINCT tesdocs.nrmagsrc AS nrmag
                          FROM tesdocs INNER JOIN rigdocs  ON (rigdocs.tesdoc_id = tesdocs.id)
                                       INNER JOIN articles ON (articles.id = rigdocs.article_id)
                                       INNER JOIN causmags ON (tesdocs.causmag_id = causmags.id)
                                       INNER JOIN contos   ON (tesdocs.conto_id = contos.id)
                                       WHERE causmags.movimpmag IN ('M', 'I') 
                                         AND articles.id = " + idart.to_s +
                                         filter_conto + filter_magsrc +
                        " UNION " +
                        "SELECT DISTINCT tesdocs.nrmagdst AS nrmag
                          FROM tesdocs INNER JOIN rigdocs  ON (rigdocs.tesdoc_id = tesdocs.id)
                                       INNER JOIN articles ON (articles.id = rigdocs.article_id)
                                       INNER JOIN causmags ON (tesdocs.causmag_id = causmags.id)
                                       INNER JOIN contos   ON (tesdocs.conto_id = contos.id)
                                       WHERE causmags.movimpmag IN ('M', 'I') 
                                         AND articles.id = " + idart.to_s +
                                         filter_conto + filter_magdst +
                    " ORDER BY nrmag")
  end

  def self.mov_artcontomag(idart, idconto, nrmag, anarif, grpmag)
    # Elenco movimenti per un articolo per un conto e per un magazzino
    filter_conto = ""
    if anarif == "S"
      # Movimenti per l'anagrafica interna di riferimento
      filter_magsrc = " AND  (   
                                  (causmags.movimpmag = 'M' and causmags.tipo IN ('T','U'))
                               OR (causmags.movimpmag = 'I' and causmags.tipo IN ('E'))
                             )"
      filter_magdst = " AND  (   
                                  (causmags.movimpmag = 'M' and causmags.tipo IN ('T','E'))
                               OR (causmags.movimpmag = 'I' and causmags.tipo IN ('U'))
                             )"
    else 
      filter_conto = " AND contos.id = " + idconto.to_s unless idconto == ""
      filter_magsrc = " AND  (   
                                  (causmags.movimpmag = 'M' and causmags.tipo IN ('R','V','E'))
                               OR (causmags.movimpmag = 'I' and causmags.tipo IN ('U'))
                             )"
      filter_magdst = " AND  (   
                                  (causmags.movimpmag = 'M' and causmags.tipo IN ('R','V','U'))
                               OR (causmags.movimpmag = 'I' and causmags.tipo IN ('E'))
                             )"
    end
    if grpmag == "S"
      filter_nrmagsrc = ""
      filter_nrmagdst = ""
    else
      filter_nrmagsrc = " AND tesdocs.nrmagsrc = " + nrmag.to_s
      filter_nrmagdst = " AND tesdocs.nrmagdst = " + nrmag.to_s
    end
    Tesdoc.find_by_sql("SELECT tesdocs.data_doc   AS Data_doc, tesdocs.num_doc  AS Numero,
                               causmags.descriz   AS Causale,  tesdocs.nrmagsrc AS Nrmag,
                               causmags.movimpmag AS Movmag,   causmags.tipo    AS Tipomov,
                               rigdocs.qta        AS Qta,      'SRC'            AS Tipomag
                          FROM tesdocs INNER JOIN rigdocs  ON (rigdocs.tesdoc_id = tesdocs.id)
                                       INNER JOIN articles ON (articles.id = rigdocs.article_id)
                                       INNER JOIN causmags ON (tesdocs.causmag_id = causmags.id)
                                       INNER JOIN contos   ON (tesdocs.conto_id = contos.id)
                                       WHERE causmags.movimpmag IN ('M', 'I') 
                                         AND articles.id = " + idart.to_s +
                                         filter_conto + filter_magsrc + filter_nrmagsrc +
                       " UNION " +
                       "SELECT tesdocs.data_doc   AS Data_doc, tesdocs.num_doc  AS Numero,
                               causmags.descriz   AS Causale,  tesdocs.nrmagdst AS Nrmag,
                               causmags.movimpmag AS Movmag,   causmags.tipo    AS Tipomov,
                               rigdocs.qta        AS Qta,      'DST'            AS Tipomag
                          FROM tesdocs INNER JOIN rigdocs  ON (rigdocs.tesdoc_id = tesdocs.id)
                                       INNER JOIN articles ON (articles.id = rigdocs.article_id)
                                       INNER JOIN causmags ON (tesdocs.causmag_id = causmags.id)
                                       INNER JOIN contos   ON (tesdocs.conto_id = contos.id)
                                       WHERE causmags.movimpmag IN ('M', 'I') 
                                         AND articles.id = " + idart.to_s +
                                         filter_conto + filter_magdst + filter_nrmagdst +
                    " ORDER BY data_doc, Numero")
  end

  def self.art_mov222(idart, idconto, nrmag, anarif)
    # Documenti che movimentano uno o più articoli per uno o più conti per uno o più magazzini
    idart == "all" ? filter_art = "" : filter_art = " AND articles.id = " + idart.to_s
    if anarif == "S"
      filter_conto = ""
      # Movimenti per l'anagrafica interna di riferimento
      filter_tpmov = " AND causmags.tipo IN ('U','E','T')"
      order = " articles.id"
    else 
      idconto == "" ? filter_conto = "" : filter_conto = " AND contos.id = " + idconto.to_s
      filter_tpmov = " AND causmags.tipo IN ('U','E','V','R')"
      order = " articles.id, contos.id"
    end 
    nrmag == "" ? filter_nrmag = "" : filter_nrmag = " AND (tesdocs.nrmagsrc = " + nrmag.to_s +
                                                     " OR   tesdocs.nrmagdst = " + nrmag.to_s + ")"
    Tesdoc.find_by_sql("SELECT articles.id         AS Article_id, articles.descriz AS Desart,
                               contos.id           AS Conto_id,   contos.descriz   AS Desconto,   
                               tesdocs.nrmagsrc    AS Magsrc,     tesdocs.nrmagdst AS Magdst,
                               causmags.movimpmag  AS Mag,
                               tesdocs.data_doc    AS Data_doc,   tesdocs.num_doc  AS Numero,
                               causmags.descriz    AS Causale,    causmags.tipo    AS Mov,
                               rigdocs.qta         AS Qta
                          FROM tesdocs INNER JOIN rigdocs  ON (rigdocs.tesdoc_id = tesdocs.id)
                                       INNER JOIN articles ON (articles.id = rigdocs.article_id)
                                       INNER JOIN causmags ON (tesdocs.causmag_id = causmags.id)
                                       INNER JOIN contos   ON (tesdocs.conto_id = contos.id)
                                       WHERE causmags.movimpmag IN ('M', 'I') " + filter_art +
                                       filter_conto + filter_tpmov + filter_nrmag +
                     " ORDER BY " + order)
  end

end
