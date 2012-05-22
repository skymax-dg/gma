class Anagen < ActiveRecord::Base
  #has_many :prezzoarticclis, :foreign_key => "anag_id",
  #                           :dependent => :destroy
  has_many :contos
  has_many :anainds
  
  attr_accessible :codice, :tipo, :denomin, :codfis, :pariva, :telefono, :email, :fax, :web, :sconto

  validates :codice, :tipo, :denomin, :presence => true
  validates :codice, :uniqueness => true

  # Fare un validate su :tipo con i valori ammessi
  validates :tipo,  :length => { :maximum => 1, :too_long  => "1 carattere obbligatorio (Valori ammessi: F = persona Fisica - G = persona Giuridica - I = Ditta individuale" }
  validates :denomin, :length => { :maximum => 150, :too_long  => "Lunghezza massima permessa: 150 caratteri" }
  validates :codfis, :length => { :maximum => 16, :too_long  => "Lunghezza massima permessa: 16 caratteri" }
  validates :pariva, :length => { :maximum => 11, :too_long  => "Lunghezza massima permessa: 11 caratteri" }
  validates :telefono, :length => { :maximum => 20, :too_long  => "Lunghezza massima permessa: 20 caratteri" }
  validates :email, :length => { :maximum => 50, :too_long  => "Lunghezza massima permessa: 50 caratteri" }
  validates :fax, :length => { :maximum => 20, :too_long  => "Lunghezza massima permessa: 20 caratteri" }
  validates :web, :length => { :maximum => 50, :too_long  => "Lunghezza massima permessa: 50 caratteri" }

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
end
