class Agente < ActiveRecord::Base
  before_destroy :require_no_tesdocs

  has_many :tesdocs
  belongs_to :anagen

  attr_accessible :anagen_id, :provv

  validates :anagen_id, :uniqueness => true
  validates :anagen_id, :provv, :presence => true

  def denomin
    self.anagen.denomin
  end

  def provv_age
    "#{sprintf('%05.2f', self.provv)}%"
  end

  def denomin_provv
    (self.anagen.denomin+"_"*40)[0,39] + "(#{sprintf('%05.2f', self.provv)} %)"
  end

  private
    def require_no_tesdocs
      self.errors.add :base, "Almeno una testata documento fa riferimento al codice agente che si desidera eliminare."
      raise ActiveRecord::RecordInvalid.new self unless tesdocs.count == 0
    end
end
