class Anagen < ActiveRecord::Base
  #has_many :prezzoarticclis, :foreign_key => "anag_id",
  #                           :dependent => :destroy
  #has_many :tesdocs
  
  attr_accessible :codice, :tipo, :cognome, :nome, :ragsoc, :codfis, :pariva, :sconto

  validates :codice, :tipo, :presence => true
  validates :codice, :uniqueness => true

  # Fare un validate su :tipo con i valori ammessi
  validates :tipo,  :length => { :maximum => 1, :too_long  => "1 carattere obbligatorio (Valori ammessi: F = persona Fisica - G = persona Giuridica - D = Ditta individuale" }
  validates :cognome, :nome, :length => { :maximum => 50, :too_long  => "Lunghezza massima permessa: 50 caratteri" }
  validates :ragsoc, :length => { :maximum => 100, :too_long  => "Lunghezza massima permessa: 100 caratteri" }
  validates :codfis, :length => { :maximum => 16, :too_long  => "Lunghezza massima permessa: 16 caratteri" }
  validates :pariva, :length => { :maximum => 11, :too_long  => "Lunghezza massima permessa: 11 caratteri" }
  #validates :codfis, :length => { :in => 11..16, :too_long  => "Lunghezza massima permessa: 16 caratteri", :too_short => "Lunghezza minima permessa: 11 caratteri" }
  #validates :pariva, :length => { :is => 11 }

  def nominativo
    return "#{cognome}-#{nome}" unless tipo == "G"
    return ragsoc
  end

end
