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
  
  TIPO = {'F' => 'Fisica', 'G' => 'Giuridica'}
  
end
