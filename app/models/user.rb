class User < ActiveRecord::Base
  attr_accessor :pwd
  attr_accessible :azienda, :login, :pwd, :pwd_confirmation, :anagen_id, :user_tp, :privilege, :email

  validates :login, :presence => true,
                    :uniqueness => {:case_sensitive => false, scope: :azienda},
                    :length => { :maximum => 20, :too_long  => "Lunghezza massima permessa: 20 caratteri" }
  validates :pwd, :presence => true,
  				  :confirmation => true,
				    :length => {:within => 6..20},
            :unless => "pwd.blank? || pwd.nil?"

  belongs_to :anagen

  before_save :encrypt_password

  #before_create :create_anagen

  USER_TPS = [
    ["GMA",1], 
    ["GAC",2],
    ["JSON",3]
  ]

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  
#  def signed_in?
#    true
#  end

  # Return true if the user's password matches the submitted password.
  def has_password?(submitted_password)
  	pwdcript == encrypt(submitted_password)
  	#Compare encrypted_password with the encrypted version of submitted_password
  end

  def self.find_by_email(str)
    User.where(login: str)[0]
  end
  
  # Return user if the submitted password and email match with db information.
  def self.authenticate(login, submitted_password, azienda)
    user = find_by_login_and_azienda(login.upcase, azienda)
    return nil if user.nil? # user not found 
    return user if user.has_password?(submitted_password) # Password match
    # return nil otherwise
    #I 3 return commentati sopra possono essere sostituiti con l'istruzione seguente
    user && user.has_password?(submitted_password) && user.can_login_gma? ? user : nil
  end

  def self.gac_authenticate(login, submitted_password, azienda)
    user = find_by_email_and_azienda(login, azienda)
    user.has_password?(submitted_password) && user.can_login_gac? ? user.get_gac_user : nil if user
  end

  def get_gac_user
    st  = Struct.new(:id, :email, :denomin, :privilege, :codfis, :pariva, :telefono, :fax, :codident, :pec, :tipo, :referente, :cod_carta_studente, :cod_carta_docente, :cod_cig, :cod_cup, :ind_sede, :ind_sped)
    ind = Struct.new(:id, :indir, :desloc, :cap)

    ris = nil
    an = self.anagen
    if an
      sede = nil
      sped = nil

      tmp = an.anainds.where(flsp: "S").first #spedizione
      sped = tmp ? ind.new(tmp.id, tmp.indir, tmp.desloc, tmp.cap) : nil
      tmp = an.anainds.where(flsl: "S").first #sede legale
      sede = tmp ? ind.new(tmp.id, tmp.indir, tmp.desloc, tmp.cap) : nil
          
      ris = st.new(self.id, self.email, an.denomin, self.privilege, an.codfis, an.pariva, an.telefono, an.fax, an.codident, an.pec, an.tipo, an.referente, an.cod_carta_studente, an.cod_carta_docente, an.cod_cig, an.cod_cup, sede, sped)
    else
      ris = st.new(self.id, self.email, self.login, self.privilege, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil)
    end
    ris
  end

  def can_login_gma?
    self.d_user_tp == "GMA"
  end

  def can_login_gac?
    self.d_user_tp == "GAC"
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

  def d_user_tp
    tmp = USER_TPS.select { |a,b| b == self.user_tp }
    tmp.size > 0 ? tmp[0][0] : ''
  end

  def self.temporary_account(mail, azienda)
    if [nil, ""].include?(mail) || !(mail =~ VALID_EMAIL_REGEX) || User.exists?(email: mail, azienda: azienda)
      return [-2, nil]
    else
      login = mail.split("@")[0][0..19]
      user = User.new(email: mail, azienda: azienda, user_tp: 2, login: login)
      user.pwd = user.random_pwd
      if user.save 
        user.gen_token
        [1, user] 
      else
        Rails.logger.info "-------------- User not saved: #{user.errors.full_messages}"
        [-1, nil]
      end
    end
  end

  def random_pwd
    ss = "%s_#!*%.6f"%[self.email, Time.now.to_f]
    Digest::MD5.hexdigest(ss).upcase[0..19]
  end

  def gen_token
    num = Random.rand(1000)
    self.token = Digest::MD5.hexdigest("%s%d"%[self.email,num])
    self.dt_exp_token = Time.now + 2.days
    self.save
  end

  def self.check_token(user_id, token, azienda)
    if User.exists?(id: user_id, azienda: azienda)
      u = User.find user_id
      if u.dt_exp_token > Time.now
        return [true, u] if u.token == token
      end
    end
    [false, nil] 
  end

  def self.appo_update(par)
    Rails.logger.info "--------- PAR: #{par}"
    if User.exists? par[:user_id]
      user = User.find(par[:user_id])
      par = par.symbolize_keys
      st = true

      if par[:password1]
        Rails.logger.info "----------- SET PASSWORD: #{par[:password1]}"
        user.pwd = par[:password1]
        user.token = nil
      end

      if user.anagen
        an = user.anagen
      else
        an = Anagen.new(codice: Anagen.newcod)
      end

      an.encode_denomin(par[:cognome], par[:nome]) if par[:cognome] != "" && par[:nome] != ""
      an.denomin = par[:ragsoc] if par[:ragsoc] != ""
      Rails.logger.info "------------ denomin: #{an.denomin}"

      an.codfis = par[:codfis]
      an.pariva = par[:pariva]
      an.telefono = par[:telefono]
      an.fax = par[:fax]
      an.codident = par[:coddest]
      an.pec = par[:pec]
      an.referente = par[:referente]
      an.cod_carta_studente = par[:cod_carta_studente]
      an.cod_carta_docente = par[:cod_carta_docente]
      an.cod_cig = par[:cod_cig]
      an.cod_cup = par[:cod_cup]
      #an.tipo = ["",nil].include?(an.pariva) ? "F" : "G"
      an.tipo = case par[:user_tp]
                when "1" then "F" #privato (ita o straniero)
                when "2" then "G" #società
                when "3" then "I" #ditta individuale
                when "4" then "G" #foreign company
                when "5" then "E" #ente statale
                when "6" then "S" #studente
                when "7" then "D" #docente
                else nil
                end

      if an.save 
        if par[:indirizzo] != ""
          unless user.anagen
            user.anagen = an
          end
          if user.changed?
            Rails.logger.info "------------ ERR: #{user.errors.full_messages}" unless user.save
          end
          ind = an.anainds.new(nrmag: 0)
          ind.indir = "%s, %s"%[par[:indirizzo].gsub(",",""), par[:civico]]
          ind.desloc = par[:citta]
          ind.cap = par[:cap]
          ind.flsl = "N"
          ind.flsp = "S"
          ind.flmg = "N"
          unless ind.save
            Rails.logger.info "--------------- Errore indirizzo 1: #{ind.errors.full_messages}"
            st = false 
          end

          if st && par[:indirizzo2] != ""
            ind2 = an.anainds.new(nrmag: 0)
            ind2.indir = "%s, %s"%[par[:indirizzo2].gsub(",",""), par[:civico2]]
            ind2.desloc = par[:citta2]
            ind2.cap = par[:cap2]
            ind2.flsl = "S"
            ind2.flsp = "N"
            ind2.flmg = "N"
            unless ind2.save
              Rails.logger.info "--------------- Errore indirizzo 2: #{ind2.errors.full_messages}"
              st = false 
            end
          end
        end
      else
        Rails.logger.info "--------------- Errore anagen: #{an.errors.full_messages}"
        st = false
      end
      st
    end
    st
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
