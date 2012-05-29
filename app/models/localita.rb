class Localita < ActiveRecord::Base
  before_destroy :require_no_anainds

  has_many :anainds
  belongs_to :paese

  attr_accessible :cap, :codfis, :descriz, :prov, :paese_id

  validates :descriz, :paese_id, :presence => true
  validates :descriz, :length => { :maximum => 50}
  validates :cap, :length => { :maximum => 5}
  validates :codfis, :length => { :maximum => 4}
  validates :prov, :length => { :maximum => 2}

  private

  def require_no_anainds
    self.errors.add :base, "Almeno un indirizzo fa riferimento alla citta' che si desidera eliminare."
    raise ActiveRecord::RecordInvalid.new self unless anainds.count == 0
  end

end
