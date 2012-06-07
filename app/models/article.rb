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

  def self.movimentati
    Article.find_by_sql("SELECT DISTINCT articles.id, articles.codice, articles.descriz
                           FROM articles INNER JOIN rigdocs ON (articles.id = rigdocs.article_id)
                                         INNER JOIN tesdocs ON (rigdocs.tesdoc_id = tesdocs.id)
                                         INNER JOIN causmags ON (tesdocs.causmag_id = causmags.id)
                                         WHERE causmags.movimpmag IN ('M') ")
  end

  def self.movmag(id)
    sql = "SELECT tesdocs.data_doc AS Data_doc, tesdocs.num_doc AS Numero,
                  causmags.descriz AS Causale, causmags.tipo AS Mov, rigdocs.qta AS Qta,
                  causmags.movimpmag AS Mag
             FROM articles INNER JOIN rigdocs ON (articles.id = rigdocs.article_id)
                           INNER JOIN tesdocs ON (rigdocs.tesdoc_id = tesdocs.id)
                           INNER JOIN causmags ON (tesdocs.causmag_id = causmags.id)
            WHERE causmags.movimpmag IN ('M') AND articles.id = " + id.to_s +
         " ORDER BY tesdocs.data_doc, tesdocs.num_doc"
    table = Ruport::Data::Table.new
    col_head = ["Data_doc", "Numero", "Causale", "Carico", "Scar.", "Giac."]
    giac = 0
    Article.find_by_sql(sql).each do |r|
      data = r.attributes["data_doc"]
      num = r.attributes["numero"]
      cau = r.attributes["causale"]
      mov = r.attributes["mov"]
      qta = r.attributes["qta"]
      mov == "E" ? car=qta : car=""
      mov == "U" ? sca=qta : sca=""
      giac = giac + car.to_i - sca.to_i
      table << Ruport::Data::Record.new([data, num, cau, car, sca, giac.to_s],
                                        :attributes => col_head)
    end
    table.column_names = col_head
    table# = Grouping(table, :by => ["Articolo"])
  end

  private

  def require_no_rigdocs
    self.errors.add :base, "Almeno una riga documento fa riferimento all'articolo che si desidera eliminare."
    raise ActiveRecord::RecordInvalid.new self unless rigdocs.count == 0
  end
end
