class Article < ActiveRecord::Base
  acts_as_reportable
  before_destroy :require_no_rigdocs
  has_many :rigdocs

  attr_accessible :codice, :descriz, :prezzo, :azienda

  validates :codice, :descriz, :azienda, :presence => true
  validates :codice, :descriz, :uniqueness => true
  validates :codice,  :length => { :maximum => 10}
  validates :descriz, :length => { :maximum => 50}
  
  scope :azienda, lambda { |azd| {:conditions => ['articles.azienda = ?', azd]}}
  default_scope :order => 'articles.codice ASC' 

  def self.chk_art_xls(xls, wks, rownr, colnr)
    # Controlla che nel file excel xls nello sheet wks(0base), partendo dalla riga rownr,
    # ogni valore della colonna colnr corrisponda ad un codice articolo nel DB 
    errors = []
    xls.worksheet(wks).each rownr do |row|
      unless row[colnr].blank?
        if not find_by_azienda_and_codice(StaticData::AZIENDA, row[colnr].to_s.strip)
          errors << "L'articolo con codice: " + row[colnr].to_s.strip + " riportato sulla riga: " + (row.idx + 1).to_s + " non e' presente in banca dati."
        end
      end
    end
    return errors
  end

  def desest1
    self.codice.to_s + " " + self.descriz
  end

  def self.movmag(id)
    # Tutti i movimenti di magazzino di un articolo (titolo)
    Article.find_by_sql("SELECT tesdocs.data_doc AS Data_doc, tesdocs.num_doc AS Numero,
                                causmags.descriz AS Causale, causmags.tipo AS Mov, rigdocs.qta AS Qta,
                                causmags.movimpmag AS Mag
                           FROM articles INNER JOIN rigdocs ON (articles.id = rigdocs.article_id)
                                         INNER JOIN tesdocs ON (rigdocs.tesdoc_id = tesdocs.id)
                                         INNER JOIN causmags ON (tesdocs.causmag_id = causmags.id)
                          WHERE causmags.movimpmag IN ('M', 'I') AND articles.id = " + id.to_s +
                       " ORDER BY tesdocs.data_doc, tesdocs.num_doc")
  end

  def self.titcvend(id)
    # Articoli (titoli) collegati ad un movimento magazzino del cliente (rivenditore)
    id == "all" ? filter_art = " AND articles.azienda = " + StaticData::AZIENDA.to_s : filter_art = " AND articles.id = " + id.to_s
    Article.find_by_sql("SELECT DISTINCT articles.id, articles.codice, articles.descriz
                           FROM articles INNER JOIN rigdocs ON (articles.id = rigdocs.article_id)
                                         INNER JOIN tesdocs ON (rigdocs.tesdoc_id = tesdocs.id)
                                         INNER JOIN causmags ON (tesdocs.causmag_id = causmags.id)
                                         WHERE causmags.magcli IN ('C', 'S') " + filter_art +
                     " ORDER BY articles.descriz")
  end

  def self.distit(id)
    # Clienti (Rivenditori) il cui articolo (titolo) ha movimentato il magazzino (cliente)
    Article.find_by_sql("SELECT DISTINCT anagens.id, anagens.codice, anagens.denomin
                           FROM articles INNER JOIN rigdocs ON (articles.id = rigdocs.article_id)
                                         INNER JOIN tesdocs ON (rigdocs.tesdoc_id = tesdocs.id)
                                         INNER JOIN causmags ON (tesdocs.causmag_id = causmags.id)
                                         INNER JOIN contos ON (tesdocs.conto_id = contos.id)
                                         INNER JOIN anagens ON (contos.anagen_id = anagens.id)
                                         WHERE causmags.magcli IN ('C', 'S') AND articles.id = " + id.to_s +
                     " ORDER BY anagens.denomin")
  end

  def self.vendtitdist(tit_id, dis_id)
    # Tutti i movimenti generati sul magazzino di uno specifico cliente (rivenditore) da un articolo (titolo)
    Article.find_by_sql("SELECT tesdocs.data_doc AS Data_doc, tesdocs.num_doc AS Numero,
                                causmags.descriz AS Causale,
                                causmags.magcli AS Magcli, causmags.movimpmag AS Movmag, rigdocs.qta AS Qta
                           FROM articles INNER JOIN rigdocs ON (articles.id = rigdocs.article_id)
                                         INNER JOIN tesdocs ON (rigdocs.tesdoc_id = tesdocs.id)
                                         INNER JOIN causmags ON (tesdocs.causmag_id = causmags.id)
                                         INNER JOIN contos ON (tesdocs.conto_id = contos.id)
                                         WHERE causmags.magcli IN ('C', 'S') 
                                           AND articles.id = " + tit_id.to_s +
                                         " AND contos.anagen_id = " + dis_id.to_s +
                                    " ORDER BY tesdocs.data_doc, tesdocs.num_doc")
  end

  private

  def require_no_rigdocs
    self.errors.add :base, "Almeno una riga documento fa riferimento all'articolo che si desidera eliminare."
    raise ActiveRecord::RecordInvalid.new self unless rigdocs.count == 0
  end

#  def self.movimentati(id)
    # Articoli collegati ad un movimento di magazzino
#    id == "all" ? filter_art = "" : filter_art = " AND articles.id = " + id.to_s
#    Article.find_by_sql("SELECT DISTINCT articles.id, articles.codice, articles.descriz
#                           FROM articles INNER JOIN rigdocs ON (articles.id = rigdocs.article_id)
#                                         INNER JOIN tesdocs ON (rigdocs.tesdoc_id = tesdocs.id)
#                                         INNER JOIN causmags ON (tesdocs.causmag_id = causmags.id)
#                                         WHERE causmags.movimpmag IN ('M', 'I') " + filter_art + 
#                     " ORDER BY articles.descriz")
#  end

#  def self.movimentati(idart, idconto, nrmag)
#    # Articoli collegati ad un movimento di magazzino su un determinato conto in un determinato magazzino
#    idart == "all" ? filter_art = "" : filter_art = " AND articles.id = " + idart.to_s
#    idconto == "" ? filter_conto = "" : filter_conto = " AND conto.id = " + idconto.to_s
#    nrmag == "" ? filter_nrmag = "" : filter_nrmag = " AND (tesdoc.nrmagsrc = " + nrmag.to_s +
#                                                     " OR   tesdoc.nrmagdst = " + nrmag.to_s + ")"
#    Article.find_by_sql("SELECT DISTINCT articles.id, articles.codice, articles.descriz
#                           FROM articles INNER JOIN rigdocs ON (articles.id = rigdocs.article_id)
#                                         INNER JOIN tesdocs ON (rigdocs.tesdoc_id = tesdocs.id)
#                                         INNER JOIN causmags ON (tesdocs.causmag_id = causmags.id)
#                                         INNER JOIN contos ON (tesdocs.conto_id = contos.id)
#                                         WHERE causmags.movimpmag IN ('M', 'I') " + filter_art +
#                                         filter_conto + filter_nrmag 
#                     " ORDER BY articles.descriz")
#  end
end
