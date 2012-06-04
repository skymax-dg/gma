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

  private

  def require_no_rigdocs
    self.errors.add :base, "Almeno una riga documento fa riferimento all'articolo che si desidera eliminare."
    raise ActiveRecord::RecordInvalid.new self unless rigdocs.count == 0
  end
end
