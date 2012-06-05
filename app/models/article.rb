require 'spreadsheet'
class Article < ActiveRecord::Base
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

  def movmag
    find_by_sql(
      "SELECT articles.codice AS codice, articles.descriz AS descriz,
              rigdocs.qta AS qta,
              tesdocs.num_doc AS num_doc, tesdocs.data_doc AS data_doc,
              causmags.descriz AS causale, causmags.tipo AS direz, causmags.movimpmag AS mag
         FROM articles INNER JOIN rigdocs ON (articles.id = rigdocs.article_id)
                       INNER JOIN tesdocs ON (rigdocs.tesdoc_id = tesdocs.id)
                       INNER JOIN causmags ON (tesdocs.causmag_id = causmags.id)
        WHERE movimpmag IN ('M', 'I')
          AND articles.id = self.id 
     ORDER BY data_doc, num_doc") 
  end

#  def vendite
#    find_by_sql(
#      "SELECT articles.codice AS codart, articles.descriz AS desart,
#              rigdocs.qta AS qta,
#              tesdocs.num_doc AS num_doc, tesdocs.data_doc AS data_doc,
#              anagens.denomin AS denomin,
#              causmags.descriz AS descau, causmags.tipo AS direz, causmags.contabile AS mag
#         FROM articles INNER JOIN rigdocs ON (articles.id = rigdocs.article_id)
#                       INNER JOIN tesdocs ON (rigdocs.tesdoc_id = tesdocs.id)
#                       INNER JOIN causmags ON (tesdocs.causmag_id = causmags.id)
#                       INNER JOIN contos ON (tesdocs.conto_id = contos.id)
#                       INNER JOIN anagens ON (contos.anagen_id = anagens.id)
#        WHERE contabile = 'S'
#          AND articles.id = self.id
#     ORDER BY denomin, data_doc, num_doc") 
#  end

  private

  def require_no_rigdocs
    self.errors.add :base, "Almeno una riga documento fa riferimento all'articolo che si desidera eliminare."
    raise ActiveRecord::RecordInvalid.new self unless rigdocs.count == 0
  end
end
