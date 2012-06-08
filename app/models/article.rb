class Article < ActiveRecord::Base
  acts_as_reportable
  before_destroy :require_no_rigdocs
  has_many :rigdocs

  attr_accessible :codice, :descriz, :prezzo, :azienda

  validates :codice, :descriz, :azienda, :presence => true
  validates :codice, :descriz, :uniqueness => true
  validates :codice,  :length => { :maximum => 10}
  validates :descriz, :length => { :maximum => 50}

  def self.chk_art_xls(xls, wks, rownr, colnr)
    errors = []
    xls.worksheet(wks).each rownr do |row|
      unless row[colnr].blank?
        if not find_by_codice(row[colnr].to_s.strip)
          errors << "L'articolo con codice: " + row[colnr].to_s.strip + " riportato sulla riga: " + (row.idx + 1).to_s + " non e' presente in banca dati."
        end
      end
    end
    return errors
  end

  def self.movimentati(id)
    id == "all" ? filter_art = "" : filter_art = " AND articles.id = " + id.to_s
    Article.find_by_sql("SELECT DISTINCT articles.id, articles.codice, articles.descriz
                           FROM articles INNER JOIN rigdocs ON (articles.id = rigdocs.article_id)
                                         INNER JOIN tesdocs ON (rigdocs.tesdoc_id = tesdocs.id)
                                         INNER JOIN causmags ON (tesdocs.causmag_id = causmags.id)
                                         WHERE causmags.movimpmag IN ('M', 'I') " + filter_art + 
                     " ORDER BY articles.descriz")
  end

  def self.movmag(id)
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
    id == "all" ? filter_art = "" : filter_art = " AND articles.id = " + id.to_s
    Article.find_by_sql("SELECT DISTINCT articles.id, articles.codice, articles.descriz
                           FROM articles INNER JOIN rigdocs ON (articles.id = rigdocs.article_id)
                                         INNER JOIN tesdocs ON (rigdocs.tesdoc_id = tesdocs.id)
                                         INNER JOIN causmags ON (tesdocs.causmag_id = causmags.id)
                                         WHERE causmags.magcli IN ('C', 'S') " + filter_art +
                     " ORDER BY articles.descriz")
  end

  def self.distit(id)
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
end
