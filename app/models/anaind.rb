class Anaind < ActiveRecord::Base
  belongs_to :anagen
  
  attr_accessible :tpind, :indir, :cap, :desloc, :anagen_id, :nrmag
  
  validates :tpind, :presence => true
  validates :tpind, :length => { :maximum => 2, :too_long  => "2 carattere obbligatorio (Valori ammessi: SL=Sede Legale - SO=Sede Operativa - ..." }

end
