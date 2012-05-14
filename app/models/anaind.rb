class Anaind < ActiveRecord::Base
  belongs_to :anagen
  
  attr_accessible :tpind, :indir, :cap, :localita, :anagen_id, :nrmag
  
  validates :tpind,  :presence => true, :length => { :maximum => 1, 
    :too_long  => "1 carattere obbligatorio (Valori ammessi: L=sede Legale - C=sede Ccontabile" }

end
