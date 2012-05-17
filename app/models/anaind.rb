class Anaind < ActiveRecord::Base
  belongs_to :anagen
  belongs_to :localita
  
  attr_accessible :indir, :cap, :desloc, :anagen_id, :localita_id, :flsl, :flsp, :flmg, :nrmag
  
  validates :flsl, :flsp, :flmg, :presence => true
  validates :flsl, :flsp, :flmg, :length => { :maximum => 1, :too_long  => "1 carattere obbligatorio per i flag (S/N)" }

  def decoflgs
    deco = ""
    deco = deco + "Sede legale/" if flsl == 'S'
    deco = deco + "Indirizzo di spedizione/" if flsp == "S"
    deco = deco + "Indirizzo di magazzino/" if flmg == "S"
    if deco == "" then deco = "Indirizzo generico" else deco = deco[0, deco.length-1] end
  end
end
