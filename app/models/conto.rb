class Conto < ActiveRecord::Base
  before_destroy :require_no_tesdocs
  has_many :tesdocs
  belongs_to :anagen

  attr_accessible :annoese, :azienda, :codice, :descriz, :anagen_id, :tipoconto, :tipopeo, :cntrpartita, :sconto

  validates :annoese, :azienda, :codice, :descriz, :tipoconto, :tipopeo, :sconto, :presence => true
  validates :descriz, :length => { :maximum => 150}
  
  scope :azdanno, lambda { |azd, anno| {:conditions => ['contos.azienda = ? and contos.annoese = ?', azd, anno]}}

  TIPOCONTO = $ParAzienda['CONTO']['TIPOCONTO']
  TIPOPEO = $ParAzienda['CONTO']['TIPOPEO']

  def magsavailable(inivalue)
    #trova i magazzini disponibili (per popolare una combo)
    return Hash[*Anaind::NRMAG.select{|k,v| inivalue.index(k)}.flatten] if self.anagen.nil?
    return self.anagen.magsavailable(inivalue)
  end

  def desest1
    self.codice.to_s + " " + Conto::TIPOCONTO[self.tipoconto] + " " + self.anagen.denomin
  end
  
  def self.findbytipoconto(azienda, annoese, tipoconto)
    where(["azienda = :az and annoese = :ae and tipoconto = :tpc", {:az => azienda, :ae => annoese, :tpc => tipoconto}])
  end

  def self.find4docfilter(cfa, tpf, des)
    # Filtra i conti referenziati dalle anagrafiche (anagen) in like sul dato CodFis/ParIva/Denomin

    hsh = {"RS" => "denomin", "CF" => "codfis", "PI" => "pariva"}
    hsh.default = "denomin"
    whana = "anagens." + hsh[tpf] + " like '%" + des + "%' and "
    includes(:anagen).where([whana + "contos.tipoconto IN (:tpc) and azienda = :azd and annoese = :anno",
                                        {:tpc => cfa, :azd => StaticData::AZIENDA, :anno => StaticData::ANNOESE}])
  end

  private

  def require_no_tesdocs
    self.errors.add :base, "Almeno un documento fa riferimento al conto che si desidera eliminare."
    raise ActiveRecord::RecordInvalid.new self unless tesdocs.count == 0
  end

end
