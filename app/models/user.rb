class User < ActiveRecord::Base
  attr_accessor :pwd
  attr_accessible :azienda, :login, :pwd, :pwd_confirmation

  validates :login, :presence => true,
                    :uniqueness => {:case_sensitive => false},
                    :length => { :maximum => 20, :too_long  => "Lunghezza massima permessa: 20 caratteri" }
  validates :pwd, :presence => true,
  				  :confirmation => true,
				    :length => {:within => 6..20}

  before_save :encrypt_password
  
#  def signed_in?
#    true
#  end

  # Return true if the user's password matches the submitted password.
  def has_password?(submitted_password)
  	pwdcript == encrypt(submitted_password)
  	#Compare encrypted_password with the encrypted version of submitted_password
  end
  
  # Return user if the submitted password and email match with db information.
  def self.authenticate(login, submitted_password, azienda)
    user = find_by_login_and_azienda(login, azienda)
    return nil if user.nil? # user not found 
    return user if user.has_password?(submitted_password) # Password match
    # return nil otherwise
    #I 3 return commentati sopra possono essere sostituiti con l'istruzione seguente
    user && user.has_password?(submitted_password) ? user : nil
  end

  # Check the link between id and cockie_salt
  def self.authenticate_with_salt(id, coockie_salt)
    user = find_by_id(id)
    #user = find(id)
# L'istruzione sopra darebbe errore in caso di id = nil    
    #return nil if user.nil? # user not found 
    #return user if user.salt == coockie_salt
    # return nil otherwise
    #I 3 return commentati sopra possono essere sostituiti con l'istruzione seguente
    (user && user.salt == coockie_salt) ? user : nil
  end

  private
    def encrypt_password
      self.salt = make_salt if new_record?
      self.pwdcript = encrypt(pwd)
	  end
    
    def encrypt(string)
      secure_hash("#{salt}--#{string}")
    end

    def make_salt
      secure_hash("#{Time.now.utc}--#{pwd}")
    end

    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end
end
