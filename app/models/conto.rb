class Conto < ActiveRecord::Base
  before_destroy :require_no_tesdocs
  has_many :tesdocs
  belongs_to :anagen

  attr_accessible :annoese, :azienda, :codice, :descriz, :anagen_id, :tipoconto, :cntrpartita, :sconto

  validates :annoese, :azienda, :codice, :descriz, :tipoconto, :sconto, :presence => true
  validates :descriz, :length => { :maximum => 150}
  
  TIPOCONTO = $ParAzienda['CONTO']['TIPOCONTO']

  def magsavailable(inivalue)
    return Hash[*Anaind::NRMAG.select{|k,v| inivalue.index(k)}.flatten] if self.anagen.nil?
    return self.anagen.magsavailable(inivalue)
  end

  def desest1
    self.codice.to_s + " " + Conto::TIPOCONTO[self.tipoconto] + " " + self.anagen.denomin
  end
  
  def self.find4docfilter(cfa, tpf, des)
    hsh = {"RS" => "denomin", "CF" => "codfis", "PI" => "pariva"}
    hsh.default = "denomin"
    whana = "anagens." + hsh[tpf] + " like '%" + des + "%' and "
    includes(:anagen).where([whana + "contos.tipoconto IN (:tpc)", {:tpc => cfa}])
  end

  private

  def require_no_tesdocs
    self.errors.add :base, "Almeno un documento fa riferimento al conto che si desidera eliminare."
    raise ActiveRecord::RecordInvalid.new self unless tesdocs.count == 0
  end

end
