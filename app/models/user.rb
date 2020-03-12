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

  scope :has_anagen, lambda { }


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
    st  = Struct.new(:id, :email, :denomin, :nome, :cognome, :privilege, :codfis, :pariva, :telefono, :fax, :codident, :pec, :tipo, :referente, :cod_carta_studente, :cod_carta_docente, :cod_cig, :cod_cup, :ind_sede, :ind_sped, :dati_completi, :anagen_id, :primary_address, :dtnas, :gender, :luogo_nas, :prov_nas, :paese_nas, :cellulare, :coupons, :dt_consenso, :dt_revoca_consenso, :fl1_consenso, :fl2_consenso, :fl3_consenso, :fl4_consenso, :fl5_consenso, :fl6_consenso, :stato_consenso)
    #ind = Struct.new(:id, :indir, :desloc, :cap)
    ind = Struct.new(:id, :indirizzo, :civico, :citta, :cap, :paese, :regione, :prov, :comune, :city_id, :nation_id, :state)

    ris = nil
    an = self.anagen
    if an
      sede = []
      sped = []

      tmp = an.anainds.where(flsp: "S") #spedizione
      tmp.each do |x| 
        loc   = x.localita
        naz   = loc ? 'IT'            : nil
        reg   = loc ? loc.cod_regione : nil
        prov  = loc ? loc.prov        : nil
        com   = loc ? loc.descriz     : nil
        cid   = loc ? loc.id          : nil
        pid   = loc ? loc.paese_id    : nil
        state = loc ? loc.state       : nil
        sped << ind.new(x.id, x.decode_indir[0], x.decode_indir[1], x.desloc, x.cap, naz, reg, prov, com, cid, pid, state) 
      end
      #sped = tmp ? ind.new(tmp.id, tmp.decode_indir[0], tmp.decode_indir[1], tmp.desloc, tmp.cap, '', '') : nil
      #sped = tmp ? ind.new(tmp.id, tmp.indir, tmp.desloc, tmp.cap) : nil

      tmp = an.anainds.where(flsl: "S") #sede legale
      tmp.each do |x| 
        loc   = x.localita
        naz   = loc ? 'IT'            : nil
        reg   = loc ? loc.cod_regione : nil
        prov  = loc ? loc.prov        : nil
        com   = loc ? loc.descriz     : nil
        cid   = loc ? loc.id          : nil
        pid   = loc ? loc.paese_id    : nil
        state = loc ? loc.state       : nil
        sede << ind.new(x.id, x.decode_indir[0], x.decode_indir[1], x.desloc, x.cap, naz, reg, prov, com, cid, pid, state) 
      end
      #sede = tmp ? ind.new(tmp.id, tmp.decode_indir[0], tmp.decode_indir[1], tmp.desloc, tmp.cap, '', '') : nil
      #sede = tmp ? ind.new(tmp.id, tmp.indir, tmp.desloc, tmp.cap) : nil

      tmp = an.primary_address
      if tmp
        loc   = tmp.localita
        naz   = loc ? 'IT'            : nil
        reg   = loc ? loc.cod_regione : nil
        prov  = loc ? loc.prov        : nil
        com   = loc ? loc.descriz     : nil
        cid   = loc ? loc.id          : nil
        pid   = loc ? loc.paese_id    : nil
        state = loc ? loc.state       : nil
        prim = ind.new(tmp.id, tmp.decode_indir[0], tmp.decode_indir[1], tmp.desloc, tmp.cap, naz, reg, prov, com, cid, pid, state) 
      end

      cognome, nome = an.decode_denomin
          
      ris = st.new(self.id, self.email, an.denomin, nome, cognome, self.privilege, an.codfis, an.pariva, an.telefono, an.fax, an.codident, an.pec, an.tipo, an.referente, an.cod_carta_studente, an.cod_carta_docente, an.cod_cig, an.cod_cup, sede, sped, an.gac_dati_completi? ? 1 : 0, an.id, prim, an.dtnas, an.sesso, an.luogonas_id, an.localita ? an.localita.prov : '', an.paese_nas_id, an.cellulare, an.get_coupons, an.dt_consenso, an.dt_revoca_consenso, an.fl1_consenso, an.fl2_consenso, an.fl3_consenso, an.fl4_consenso, an.fl5_consenso, an.fl6_consenso, an.stato_consenso)
    else
      ris = st.new(self.id, self.email, nil, nil, nil, self.privilege)
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

  def self.gen_token(mail)
    if User.exists?(email: mail)
      user = User.where(email: mail).first
      user.gen_token
      user.save
      st = true
    else
      st = false
      user = false
    end
    [st, user]
  end

  def self.check_token(token, azienda)
    if User.exists?(token: token, azienda: azienda)
      u = User.where(token: token, azienda: azienda).first
      [true, u]
    else
      [false, nil]
    end
  end

  #deprecated
  def self.check_token_old(user_id, token, azienda)
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
    errs = []
    st = false    # se lo user non esiste ritorno false
    if User.exists? par[:user_id]
      user = User.find(par[:user_id])
      par = par.symbolize_keys
      st = true

      if par[:password1]
        Rails.logger.info "----------- SET PASSWORD: #{par[:password1]}"
        user.pwd = par[:password1]
        user.token = nil
        user.save
      end

      if user.anagen
        an = user.anagen
        fnew = false
      elsif Anagen.where(codfis: par[:codfis]).size == 1
        an = Anagen.where(codfis: par[:codfis]).first
        fnew = false
      elsif Anagen.where(pariva: par[:pariva]).size == 1
        an = Anagen.where(pariva: par[:pariva]).first
        fnew = false
      else
        an = Anagen.new(codice: Anagen.newcod)
        fnew = true
      end
      Rails.logger.info "-------------- new_record? #{an.new_record?} | #{fnew}"

      if par[:edit_anagen]
        an.tipo               = par[:tipo]               unless ["", nil].include?(par[:tipo])

        if fnew
          if !(["", nil].include?(par[:cognome])) &&  !(["", nil].include?(par[:nome])) 
            an.encode_denomin(par[:cognome], par[:nome]) 
          end
          Rails.logger.info "-------------- use rag_soc? #{an.use_rag_soc?} (#{par[:ragsoc]}) - tipo: #{an.tipo}"
          if !(["", nil].include?(par[:ragsoc])) && an.use_rag_soc?
            an.denomin = par[:ragsoc] 
          end
          an.codfis             = par[:codfis]             unless ["", nil].include?(par[:codfis])
          an.pariva             = par[:pariva]             unless ["", nil].include?(par[:pariva])
        end

        an.telefono           = par[:telefono]           unless ["", nil].include?(par[:telefono])
        an.cellulare          = par[:cellulare]          unless ["", nil].include?(par[:cellulare])
        an.fax                = par[:fax]                unless ["", nil].include?(par[:fax])
        an.codident           = par[:coddest]            unless ["", nil].include?(par[:coddest])
        an.pec                = par[:pec]                unless ["", nil].include?(par[:pec])
        an.referente          = par[:referente]          unless ["", nil].include?(par[:referente])
        an.cod_carta_studente = par[:cod_carta_studente] unless ["", nil].include?(par[:cod_carta_studente])
        an.cod_carta_docente  = par[:cod_carta_docente]  unless ["", nil].include?(par[:cod_carta_docente])
        an.cod_cig            = par[:cod_cig]            unless ["", nil].include?(par[:cod_cig])
        an.cod_cup            = par[:cod_cup]            unless ["", nil].include?(par[:cod_cup])
        an.sesso              = par[:gender]             unless ["", nil].include?(par[:gender])
        an.dtnas              = par[:dtnas]              unless ["", nil].include?(par[:dtnas])
        an.luogonas_id        = par[:city_nasc]          unless ["", nil].include?(par[:city_nasc])
        an.paese_nas_id       = par[:paese_nas]          unless ["", nil].include?(par[:paese_nas])
      end
      an.primary_address_id = par[:primary_address_id] unless [nil, ""].include?(par[:primary_address_id])
      an.fl1_consenso   = par[:fl1_consenso].to_i   unless [nil, ""].include?(par[:fl1_consenso])
      an.fl2_consenso   = par[:fl2_consenso].to_i   unless [nil, ""].include?(par[:fl2_consenso])
      an.fl3_consenso   = par[:fl3_consenso].to_i   unless [nil, ""].include?(par[:fl3_consenso])
      an.fl4_consenso   = par[:fl4_consenso].to_i   unless [nil, ""].include?(par[:fl4_consenso])
      an.fl5_consenso   = par[:fl5_consenso].to_i   unless [nil, ""].include?(par[:fl5_consenso])
      an.fl6_consenso   = par[:fl6_consenso].to_i   unless [nil, ""].include?(par[:fl6_consenso])
      an.dt_consenso    = par[:dt_consenso]         unless [nil, ""].include?(par[:dt_consenso])
      an.dt_revoca_consenso = par[:dt_revoca_consenso] unless [nil, ""].include?(par[:dt_revoca_consenso])
      an.fl_newsletter  = par[:fl_newsletter].to_i  unless [nil, ""].include?(par[:fl_newsletter])
      an.stato_consenso = par[:state].to_i          unless [nil, ""].include?(par[:state])
      an.email          = user.email

      if an.changed? && !an.save
        Rails.logger.info "--------------- Errore anagen: #{an.errors.full_messages}"
        st = false
        errs = an.errors.full_messages
      end
      unless user.anagen
        Rails.logger.info "XXXXXXXXXXXXXXXX ASSEGNO ANAGEN!!!"
        user.anagen = an
        Rails.logger.info "XXXXXXXXXXXXXXXX Errore save: #{user.errors.full_messages}" unless user.save
      end

      if par[:indirizzo] != "" && par[:indirizzo] != nil
        if par[:indir_id] && an.anainds.exists?(par[:indir_id])
          Rails.logger.info "------Cerco per id: #{ par[:indir_id] }"
          ind = an.anainds.find(par[:indir_id])
        else
          Rails.logger.info "------Creo indirizzo"
          ind = an.anainds.new(nrmag: 0)
        end
        ind.encode_indir(par[:indirizzo], par[:civico])
        #ind.indir = "%s, %s"%[par[:indirizzo].gsub(",",""), par[:civico]]
        Rails.logger.info "------------- START"
        if par[:city_id]
          ind.localita_id = par[:city_id]
        elsif par[:nazione_id] && Paese.exists?(par[:nazione_id])
          paese = Paese.find(par[:nazione_id]) 
          tmp = paese.localitas.where(state: par[:state], descriz: par[:citta]).first
          Rails.logger.info "------------------ creo localita..." unless tmp
          tmp = paese.localitas.create(state: par[:state], descriz: par[:citta], cap: par[:cap]) unless tmp
          Rails.logger.info "------------------ Errore creazione localita: #{tmp.errors.full_messages}" if tmp.errors.any?
          ind.localita = tmp
        end
        Rails.logger.info "------------- END"
        ind.desloc = par[:citta]
        ind.cap = par[:cap]
        ind.flsl = par[:flsl] || "N"
        ind.flsp = par[:flsp] || "S"
        ind.flmg = "N"
        if ind.save
          an.primary_address = ind
          an.save
        else
          Rails.logger.info "--------------- Errore indirizzo 1: #{ind.errors.full_messages}"
          st = false 
          errs = ind.errors.full_messages
        end

        #if st && !(["", nil].include?(par[:indirizzo2]))
        #  if par[:indir_id2] && an.anainds.exists?(par[:indir_id2])
        #    Rails.logger.info "------Cerco per id: #{ par[:indir_id2] }"
        #    ind2 = an.anainds.find(par[:indir_id2])
        #  else
        #    Rails.logger.info "------Creo indirizzo2 (#{ par[:indir_id2] })"
        #    ind2 = an.anainds.new(nrmag: 0)
        #  end
        #  ind2.encode_indir(par[:indirizzo2], par[:civico2])
        #  #ind2.indir = "%s, %s"%[par[:indirizzo2].gsub(",",""), par[:civico2]]
        #  ind2.desloc = par[:citta2]
        #  ind2.cap = par[:cap2]
        #  ind2.flsl = "S"
        #  ind2.flsp = "N"
        #  ind2.flmg = "N"
        #  unless ind2.save
        #    Rails.logger.info "--------------- Errore indirizzo 2: #{ind2.errors.full_messages}"
        #    st = false 
        #    errs = ind2.errors.full_messages
        #  end
        #end
      end
    end
    [st, errs]
  end

  # LCG 191102
  def info_check
    if self.anagen
      self.anagen.info_check 
    else
      "anagrafica non inserita"
    end
  end

  def self.statistics
    nt = User.all.size
    na = User.where("anagen_id <> 0").size
    nc = 0
    User.where("anagen_id <> 0").each { |u| nc += 1 if u.anagen.gac_dati_completi? }


    # statistica utenti
    h = {}
    h["completi"] = [nc, 100.0*nc.to_f/nt ]
    h["dati mancanti"] = [na-nc, 100.0*(na-nc).to_f/nt ]
    h["stand by"] = [nt-na, 100.0*(nt-na).to_f/nt]
    h["totale"] = [nt, 100.0]
    
    # Statistica Ordini
    o2 = []
    nt = Tesdoc.where(causmag_id: 77).size
    o2 << ["",nt]
    Tesdoc.select("date(data_doc) as data, count(*) as numero").where("causmag_id = 77").group("date(data_doc)").order('data DESC').each do |r|
      o2 << [r["data"].to_s , r["numero"].to_i ]
    end
    
    [h, o2]
  end

  # deprecato
  #x = User.export_filter( {"status" => "2", "fl_newsletter" => "0", "fl_ordine" => "1"}, 9 ); x.size
  def self.export_filter0(filters, azienda)
    ds = []

    #STATO
    case filters["status"]
    when "1" #anagrafica non completa
      #User.all.each { |u| ds << u unless u.anagen && u.anagen.gac_dati_completi? }
      ds = User.clear_nil( User.where("anagen_id <> 0").map { |u| u unless u.anagen.gac_dati_completi? } )
    when "2" #anagrafica completa
      #User.all.each { |u| ds << u if u.anagen && u.anagen.gac_dati_completi? }
      ds = User.clear_nil( User.where("anagen_id <> 0").map { |u| u if u.anagen.gac_dati_completi? } )
    end
    return ds
    
    #CONSENSO NEWSLETTER
    ds = User.clear_nil( ds.map { |u| u if u.anagen && u.anagen.newsletter?  } ) if filters["fl_newsletter"] == "1"

    #ORDINE EFFETTUATO
    case filters["fl_ordine"] 
    when "0"
      tmp = ds.map { |u| u if u.anagen.orders(azienda).size == 0 }
    when "1"
      tmp = ds.map { |u| u if u.anagen.orders(azienda).size != 0 }
    end
    ds = User.clear_nil( tmp )
    
    Rails.logger.info "XXXXXX params: #{filters}"
    Rails.logger.info "XXXXXX size: #{ds.size}"
    return ds
    #User.export_xls(ds)
  end

  def self.gen_coupons(ds, params, user_id)
    ds.each { |d| Anagen.gen_coupon(d[-1], params, user_id) }
  end

  def self.filter_and_generate_coupons(params, azienda, user_id)
    Rails.logger.info "------------- GEN_COUPON PARAMS: #{params}"
    
    if params[:coupon][:dt_start] && params[:coupon][:dt_end] && Date.parse(params[:coupon][:dt_start]) <= Date.parse(params[:coupon][:dt_end])
      if params[:coupon_val] && params[:coupon_val].to_i >= 0 && params[:coupon_perc] && params[:coupon_perc].to_i >= 0 && params[:coupon_perc].to_i <= 100 
        if params[:coupon_val].to_i == 0 && params[:coupon_perc].to_i == 0
          [-3, "Definire una percentuale e/o un valore assoluto"]
        else
          Rails.logger.info "------------- INIZIO GENERAZIONE"
          ds = self.export_filter(params, azienda)
          Rails.logger.info "------------- DS: #{ds.size}"
          self.gen_coupons(ds, params, user_id) 
          [ds.size, nil]
        end
      else
        [-2, "Percentuale e/o valore assoluto non valido"]
      end
    else
      [-1, "Date non valide"]
    end
  end

  def self.filter_and_export_to_xls(params, azienda)
#    ds = self.export_filter2(params, azienda)
    ds = self.export_filter(params, azienda)
    self.export_xls(ds)
  end

  # deprecato
  def self.export_filter2(params, azienda)
    t1 = Time.now
    Rails.logger.info "ZZZZZZZ params: #{params}"
    ds = []
    st = false
    self.where("anagen_id <> 0").each do |u|
      st = 0 if u.anagen_id == 3421
      if  (params["status"] == "0" && !u.anagen.gac_dati_completi?) || (params["status"] == "1" && u.anagen.gac_dati_completi?) || (params["status"] == "-1")
        st = 1 if u.anagen_id == 3421

        if (params["fl_consenso"] == "1" && u.anagen.newsletter?) || (params["fl_consenso"] == "-1")
          st = 2 if u.anagen_id == 3421
          fl_ordine = params["fl_ordine"] == "1"

          if (fl_ordine && u.anagen.orders(azienda).size > 0) || !fl_ordine
            st = 3 if u.anagen_id == 3421
            dt1 = ["",nil].include?(params["export_filter"]["dt_start"]) ? nil : Date.parse(params["export_filter"]["dt_start"])
            dt2 = ["",nil].include?(params["export_filter"]["dt_end"])   ? nil : Date.parse(params["export_filter"]["dt_end"])

            Rails.logger.info "------------ fl_ordine? #{fl_ordine}"
            if fl_ordine && (!dt1 || !dt2 || u.anagen.has_order_in_dt_range?(dt1, dt2)) || !fl_ordine
              st = 4 if u.anagen_id == 3421
              kw_id = [nil, ""].include?(params["key_word_id"]) ? nil : params["key_word_id"]

              if fl_ordine && ((kw_id && u.anagen.has_order_by_key_word?(kw_id, dt1, dt2)) || !kw_id) || !fl_ordine
                st = 5 if u.anagen_id == 3421
                art_id = [nil, ""].include?(params["article_id"]) ? nil : params["article_id"].to_i

                if fl_ordine && ( (art_id && u.anagen.has_order_by_article?(art_id, dt1, dt2)) || !art_id ) || !fl_ordine
                  st = 6 if u.anagen_id == 3421
                  coupon_scad = [nil, ""].include?(params["coupon_in_scadenza"]) ? -1 : params["coupon_in_scadenza"].to_i

                  if (coupon_scad == 1 && u.anagen.coupon_in_scadenza?) || coupon_scad == -1
                    st = 7 if u.anagen_id == 3421
                    reg_code = ["",nil].include?(params["region_code"]) ? nil : params["region_code"].to_i
                    Rails.logger.info "---------- reg_code: #{reg_code} (#{reg_code.class})"

                    if (reg_code  && u.anagen.is_in_region?(reg_code)) || !reg_code 
                      st = 8 if u.anagen_id == 3421
                      prov_code = ["",nil].include?(params["province_code"]) ? nil : params["province_code"]

                      if (prov_code  && u.anagen.is_in_province?(prov_code)) || !prov_code 
                        st = 9 if u.anagen_id == 3421
                        n,c = u.anagen.decode_denomin
                        ds << [n, c, u.email, u.anagen_id]
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
    Rails.logger.info "---------- st: #{st}"
    Rails.logger.info "---------- ds.size: #{ds.size}"
    t = Time.now - t1
    Rails.logger.info "-------------- export_xls params %s time %.02f nr rec %d" % [params, t, ds.size]
    ds
  end

  def check_anagrafica?(m, reg_code, prov_code)
    return true if m == -1
    an = self.anagen
    if an.gac_dati_completi?
      if m == 1
        return false if (reg_code  && !an.is_in_region?(reg_code))
        return false if (prov_code  && !an.is_in_province?(prov_code))
        true
      else
        false
      end
    else
      m == 0
    end
  end

  def check_coupon?(m)
    return true if m == -1
    self.anagen.coupon_in_scadenza? ? m == 1 : m == 0
  end

  def check_consenso?(m)
    return true if m == -1
    self.anagen.newsletter? ? m == 1 : m == 0
  end

  def check_ordine?(m, azienda, dt1, dt2, kw_id, art_id)
    return true if m == -1
    if self.anagen.orders(azienda).size > 0  
      return false if m == 0
      return false if dt1 && dt2 && !a.has_order_in_dt_range?(dt1, dt2)
      return false if kw_id && !a.has_order_by_key_word?(kw_id, dt1, dt2)
      return false if art_id && !a.has_order_by_article?(art_id, dt1, dt2)
      true
    else
      m == 0
    end
  end

  def self.export_filter(params, azienda)
    t1 = Time.now
    dt1 = ["",nil].include?(params["export_filter"]["dt_start"]) ? nil : Date.parse(params["export_filter"]["dt_start"])
    dt2 = ["",nil].include?(params["export_filter"]["dt_end"])   ? nil : Date.parse(params["export_filter"]["dt_end"])
    coupon_scad = [nil, ""].include?(params["coupon_in_scadenza"]) ? -1 : params["coupon_in_scadenza"].to_i
    reg_code = ["",nil].include?(params["region_code"]) ? nil : params["region_code"].to_i
    prov_code = ["",nil].include?(params["province_code"]) ? nil : params["province_code"]
    kw_id = [nil, ""].include?(params["key_word_id"]) ? nil : params["key_word_id"]
    art_id = [nil, ""].include?(params["article_id"]) ? nil : params["article_id"].to_i
    ds = []

    status = params["status"].to_i    # 1 anagrafica completa 0 anagrafica non completa -1 non importa
    fl_cons = params["fl_consenso"].to_i # 1 consenso SI  0 consenso no  -1 non importa
    fl_ordine = params["fl_ordine"].to_i  #  1 ordine presente 0 ordine non presente -1 non importa

    self.where("anagen_id <> 0").each do |u|
      if u.check_anagrafica?(status, reg_code, prov_code) &&
          u.check_consenso?(fl_cons) &&
          u.check_coupon?(coupon_scad) &&
          u.check_ordine?(fl_ordine, azienda, dt1, dt2, kw_id, art_id)
            n,c = u.anagen.decode_denomin
            ds << [n, c, u.email, u.anagen_id]
      end
    end

    t = Time.now - t1
    Rails.logger.info "-------------- export_xls params %s time %.02f nr rec %d" % [params, t, ds.size]
    ds
  end

  # deprecato
  def self.clear_nil(ds)
    ds.delete_if { |x| !x }
  end

  def self.export_xls(ds)
    book = Spreadsheet::Workbook.new # istanzio il workbook (file xls)
    sheet = book.create_worksheet :name => 'Utenti' # istanzio lo sheet

    ds.each_with_index do |u,i|
      sheet.row(i).concat u[0..2]
    end

    data = StringIO.new('')
    book.write(data)
    return data.string
    #book.write Rails.root.join "test.xls"
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
