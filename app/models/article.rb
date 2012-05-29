class Article < ActiveRecord::Base
  before_destroy :require_no_rigdocs
  has_many :rigdocs

  attr_accessible :codice, :descriz, :prezzo, :azienda

  validates :codice, :descriz, :azienda, :presence => true
  validates :codice, :descriz, :uniqueness => true
  validates :codice,  :length => { :maximum => 10}
  validates :descriz, :length => { :maximum => 50}

  private

  def require_no_rigdocs
    self.errors.add :base, "Almeno una riga documento fa riferimento all'articolo che si desidera eliminare."
    raise ActiveRecord::RecordInvalid.new self unless rigdocs.count == 0
  end

end
