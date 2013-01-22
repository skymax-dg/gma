class Iva < ActiveRecord::Base
  before_destroy :require_no_tesdocs
  has_many :tesdocs

  before_destroy :require_no_rigdocs
  has_many :rigdocs

  before_destroy :require_no_articles
  has_many :articles

  attr_accessible :codice, :descriz, :desest, :aliq, :flese

  validates :codice, :descriz, :desest, :flese, :presence => true
  validates :descriz, :length => { :maximum => 50}
  validates :desest, :length => { :maximum => 150}
  validates :flese, :length => { :maximum => 1}

  private
    def require_no_tesdocs
      self.errors.add :base, "Almeno una testata documento fa riferimento al codice iva/esenzione che si desidera eliminare."
      raise ActiveRecord::RecordInvalid.new self unless tesdocs.count == 0
    end

    def require_no_rigdocs
      self.errors.add :base, "Almeno una riga documento fa riferimento al codice iva/esenzione che si desidera eliminare."
      raise ActiveRecord::RecordInvalid.new self unless rigdocs.count == 0
    end

    def require_no_articles
      self.errors.add :base, "Almeno un articolo fa riferimento al codice iva/esenzione che si desidera eliminare."
      raise ActiveRecord::RecordInvalid.new self unless articles.count == 0
    end
end
