include AnaindsHelper
class Anaind < ActiveRecord::Base
  belongs_to :anagen
  belongs_to :localita
  has_many :spedizs, :dependent => :nullify
  
  attr_accessible :indir, :cap, :desloc, :anagen_id, :localita_id, :flsl, :flsp, :flmg, :nrmag
  
  validates :flsl, :flsp, :flmg, :nrmag, :indir, :presence => true
  validates :indir, :length => { :maximum => 100}

  NRMAG = $ParAzienda['ANAIND']['NRMAG']

  def decoflgs
    deco = ""
    deco = deco + "Sede legale/" if flsl == 'S'
    deco = deco + "Indirizzo di spedizione/" if flsp == "S"
    deco = deco + "Indirizzo di magazzino/" if flmg == "S"
    if deco == "" then deco = "Indirizzo generico" else deco = deco[0, deco.length-1] end
  end

  def ind_completo
    self.indir + " " + self.cap + " " + self.desloc
  end

  def self.nrmagexist(id, anagen_id, nrmag)
    # Controlla se lo stesso magazzino e' gia' associato ad un indirizzo

    # Controllo per la action edit
    nr = Anaind.count(:conditions => ['anagen_id = :v1 and nrmag = :v2 and id != :v3',
                                       {:v1 => anagen_id, :v2 => nrmag, :v3 => id}
                                     ]) unless id.nil?
    # Controllo per la action new
    nr = Anaind.count(:conditions => ["anagen_id = :v1 and nrmag = :v2",
                                       {:v1 => anagen_id, :v2 => nrmag}
                                     ]) if id.nil?
    return false if nr == 0
    return true
  end
end
