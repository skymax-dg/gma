class Anagen < ActiveRecord::Base
  #has_many :prezzoarticclis, :foreign_key => "anag_id",
  #                           :dependent => :destroy
  before_destroy :require_no_contos
  has_many :contos
  has_many :anainds, :dependent => :destroy
  
  attr_accessible :codice, :tipo, :denomin, :codfis, :pariva, :telefono, :email, :fax, :web, :sconto

  validates :codice, :tipo, :denomin, :presence => true
  validates :codice, :uniqueness => true

  # Fare un validate su :tipo con i valori ammessi
  validates :tipo,  :length => { :maximum => 1}
  validates :denomin, :length => { :maximum => 150}
  validates :codfis, :length => { :maximum => 16}
  validates :pariva, :length => { :maximum => 11}
  validates :telefono, :length => { :maximum => 20}
  validates :email, :length => { :maximum => 50}
  validates :fax, :length => { :maximum => 20}
  validates :web, :length => { :maximum => 50}

  TIPO = $ParAzienda['ANAGEN']['TIPO SOGGETTO']

  def magsavailable(inivalue)
    # Ricerco i magazzini inseriti sull'anagrafica, con il .map creo un array formato dai vari nrmag,
    # con il comando select applicato all'hash Anaind::NRMAG restituisco un altro hash formato
    # dai magazzini disponibili ovvero che hanno corrispondenza sull'array creato dal comando map
    mags = Anaind.find(:all,
                       :select => "nrmag",
                       :conditions => ["anagen_id = :anaid and flmg = 'S'", {:anaid => self.id}]).map{|c| c.nrmag}
    Hash[*Anaind::NRMAG.select{|k,v| (mags+inivalue).index(k)}.flatten]
  end

  private

  def require_no_contos
    self.errors.add :base, "Almeno un conto fa riferimento all' anagrafica che si desidera eliminare."
    raise ActiveRecord::RecordInvalid.new self unless contos.count == 0
  end

end
