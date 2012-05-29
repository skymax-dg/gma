class Localita < ActiveRecord::Base
  has_many :anainds
  belongs_to :paese

  attr_accessible :cap, :codfis, :descriz, :prov, :paese_id

  validates :descriz, :paese_id, :presence => true
  validates :descriz, :length => { :maximum => 50}
  validates :cap, :length => { :maximum => 5}
  validates :codfis, :length => { :maximum => 4}
  validates :prov, :length => { :maximum => 2}
end
