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

        
        
  def self.movmag(id)
        Ruport::Formatter::Template.create(:simple) do |t|
          t.page_format = {
            :size   => "LETTER",
            :layout => :landscape
          }
          t.text_format = {
            :font_size => 6
          }
          t.table_format = {
            :font_size      => 6,
            :show_headings  => false
          }
          t.column_format = {
            :alignment => :center,
            :heading => { :justification => :right }
          }
          t.grouping_format = {
            :style => :separated
          }
        end
    id == :all ? add = "" : add = " AND articles.id = " + id.to_s 
    sql = "SELECT 'ARTICOLO: ' || articles.codice || '    ' || articles.descriz AS Articolo,
                  tesdocs.data_doc AS Data_documento, tesdocs.num_doc AS Numero,
                  causmags.descriz AS Causale, causmags.tipo AS Mov, rigdocs.qta AS Qta,
                  causmags.movimpmag AS Mag
             FROM articles INNER JOIN rigdocs ON (articles.id = rigdocs.article_id)
                           INNER JOIN tesdocs ON (rigdocs.tesdoc_id = tesdocs.id)
                           INNER JOIN causmags ON (tesdocs.causmag_id = causmags.id)
            WHERE causmags.movimpmag IN ('M') " + add +
         " ORDER BY articles.id, tesdocs.data_doc, tesdocs.num_doc"
    table = Ruport::Data::Table.new
    col_head = ["Articolo", "Data_documento", "Numero", "Causale", "Carico", "Scarico", "Progr"]
    art = ""
    prg = 0
    Article.find_by_sql(sql).each do |r|
      car = ""
      sca = ""
      if art == "" or art != r.attributes["articolo"]
        prg = 0
      end
      art = r.attributes["articolo"]
      data = r.attributes["data_documento"]
      num = r.attributes["numero"]
      cau = r.attributes["causale"]
      mov = r.attributes["mov"]
      qta = r.attributes["qta"]
      mov == "E" ? car=qta : car=""
      mov == "U" ? sca=qta : sca=""
      prg = prg + car.to_i - sca.to_i
      table << Ruport::Data::Record.new([art, data, num, cau, car, sca, prg.to_s],
                                        :attributes => col_head)
    end
    table.column_names = col_head
    table = Grouping(table, :by => ["Articolo"])
  end

  private

  def require_no_rigdocs
    self.errors.add :base, "Almeno una riga documento fa riferimento all'articolo che si desidera eliminare."
    raise ActiveRecord::RecordInvalid.new self unless rigdocs.count == 0
  end
end
