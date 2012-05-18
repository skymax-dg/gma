class Anaind < ActiveRecord::Base
  belongs_to :anagen
  belongs_to :localita
  
  attr_accessible :indir, :cap, :desloc, :anagen_id, :localita_id, :flsl, :flsp, :flmg, :nrmag
  
  validates :flsl, :flsp, :flmg, :nrmag, :indir, :presence => true
  validates :flsl, :flsp, :flmg, :length => { :maximum => 1, :too_long  => "1 carattere obbligatorio per i flag (S/N)" }
  validates :indir, :length => { :maximum => 100, :too_long  => "Lunghezza massima: 100 caratteri" }

  NRMAG = $ParAzienda['ANAIND']['NRMAG']

  def decoflgs
    deco = ""
    deco = deco + "Sede legale/" if flsl == 'S'
    deco = deco + "Indirizzo di spedizione/" if flsp == "S"
    deco = deco + "Indirizzo di magazzino/" if flmg == "S"
    if deco == "" then deco = "Indirizzo generico" else deco = deco[0, deco.length-1] end
  end

  def self.nrmagexist(id, anagen_id, nrmag)
    nr = Anaind.count(:conditions => ['anagen_id = :v1 and nrmag = :v2 and id != :v3',
#    nr = Anaind.count(:conditions => ["Fanagen_id = " + anagen_id + " and nrmag = :v2 and id != :v3",
                                       {:v1 => anagen_id, :v2 => nrmag, :v3 => id}
                                     ]) unless id.nil?
    nr = Anaind.count(:conditions => ["anagen_id = :v1 and nrmag = :v2",
                                       {:v1 => anagen_id, :v2 => nrmag}
                                     ]) if id.nil?
    return false if nr == 0
    return true
  end
end
