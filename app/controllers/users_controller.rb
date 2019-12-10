# encoding: utf-8
class UsersController < ApplicationController
  before_filter :authenticate_request, if: :json_request?
  before_filter :authenticate#, :except => [:new, :create]
  before_filter :force_fieldcase, :only => [:create, :update]

  def new
    @title = "Creazione utente"
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      set_year Time.now.year
      flash[:success] = "Benvenuto in GMA! #{@user.login}"
      redirect_to @user
    else
	  	@title = "Creazione utente"
      render 'new'
    end
  end

  def show
    @user = User.find(params[:id])
    @title = "Mostra utente"
    store_location
  end

  def edit
    @user = User.find(params[:id]) #find gia' fatto nella correct_user
    @title = "Modifica Utente"
  end

  def update
    @user = User.find(params[:id]) #find gia' fatto nella correct_user
    if @user.update_attributes(params[:user])
      flash[:success] = "Utente aggiornato con successo."
      redirect_to user_path
    else
      @title = "Modifica Utente"
      render 'edit'
    end
  end

  def index
    @title = "Elenco Utenti"
    @users = User.where("azienda = #{current_user.azienda.to_s}").paginate(:page => params[:page])
  end

  def destroy
    if current_user.id.to_s == params[:id]
      flash[:alert] = "Non e' possibile eliminare l'utente loggato."
      redirect_to users_path
    else
      User.find(params[:id]).destroy
      flash[:success] = "Utente cancellato."
      redirect_to users_path
    end
  end
  
  #modes:
  # 1 => make temporary account
  # 2 => check token
  # 3 => login user
  # 4 => read user
  # 5 => update user
  # 6 => add expedition address
  # 7 => gen token x cambio password
  # 8 => get tesdocs
  # 9 => find tesdoc
  # 10 => get socials
  # 11 => get digital products
  def users_query
    case params[:mode]
    when "1"
      #data la mail cerco l'utente e genero l'account provvisorio
      st, ris = User.temporary_account(params[:email], @current_user.azienda)
      if st > 0
        render json: { status: true, token: ris.token, id: ris.id, email: ris.email }
        return
      else
        render json: { status: false }
        return
      end

    when "2"
      st, user = User.check_token(params[:token], @current_user.azienda)
      #st, user = User.check_token(params[:user_id], params[:token], @current_user.azienda)
      render json: { status: st, user: map_user(user) }
      return

    when "3"
      ris = User.gac_authenticate(params[:login], params[:password], @current_user.azienda)
      render json: {result: ris ? ris.id : false}
      return

    when "4"
      #u = User.find(params[:id]) if User.exists? params[:id]
      if params[:id] && User.exists?(params[:id])
        u = User.find(params[:id])
      elsif params[:token]
        u = User.where(token: params[:token]).first
      else
        u = nil
      end
      if u
        render json: { status: true, user: u.get_gac_user }
      else
        render json: { status: false, user: {} }
      end
      # render json: u ? u.get_gac_user : {}
      return

    when "5"
      st, errs = User.appo_update(params)
      Rails.logger.info "------------------ status: #{st} (#{st.class})"
      render json: { status: st, errors: st ? nil : errs }
      return

    when "6"
      st, id = Anagen.add_addr(params)
      Rails.logger.info "------------------ status: #{st}, id: #{id}"
      render json: { status: st, id: id }
      return

    when "7"
      st, user = User.gen_token(params[:email])
      name = (user && user.anagen) ? user.anagen.denomin : ""
      render json: { status: st, token: user ? user.token : nil, email: user ? user.email : nil, name: name }
      return

    when "8"
      st = false
      if Anagen.exists?(params[:anagen_id])
        anagen = Anagen.find(params[:anagen_id])
        st = true
        cs = anagen.orders(anagen.user.azienda)
        ris = []
        #c = anagen.contos.where(tipoconto: "C").first
        if cs
          cs.each do |c|
            c.tesdocs.by_causmag_id(Causmag::ESHOP).each { |x| ris << x.map_json }
          end
        end
      end
      render json: { status: st, ds: ris }

    when "9"
      an_id = params[:anagen_id]
      td_id = params[:tesdoc_id]
      if Anagen.exists?(an_id)
        anagen = Anagen.find(an_id)
        st = true
        c = anagen.contos.where(tipoconto: "C").first
        t = c.tesdocs.where(id: td_id).first if c
      end
      render json: { status: t ? true : false, tesdoc: t && t.map_json }

    when "10"
      if params[:anagen_id] && Anagen.exists?(params[:anagen_id])
        an = Anagen.find(params[:anagen_id])
      end
      render json: { status: an ? true : false, socials: an ? an.get_socials : {} }

    when "11"
      st = false
      if Anagen.exists?(params[:anagen_id])
        anagen = Anagen.find(params[:anagen_id])
        st = true
        ris = anagen.anagen_articles.by_cd_owner.map { |x| x.article.codice }
      end
      render json: { status: st, ds: ris }

    end
  end

  def export_filter
    kw = KeyWord.find(125) #Categorie
    @key_words = KeyWord.sort_by_din(kw.get_childs.flatten)

    @articles = Article.all.sort_by { |x| x.descriz }
  end

  def do_export_filter
    if params[:export_xls]
      data = User.filter_and_export_to_xls(params, current_user.azienda)
      send_data(data, {
        :disposition => 'attachment',
        :encoding => 'utf8',
        :stream => false,
        :type => 'application/excel',
        :filename => 'export_users.xls'})
      return
    elsif params[:gen_coupons]
      num, notice = User.filter_and_generate_coupons(params, current_user.azienda, current_user.id)
      redirect_to :back, notice: notice || "Generati %d coupon"%[num]
    end
  end

  private
    def correct_user
      @user = User.find(params[:id])
      redirect_to root_path, 
                  :alert => "Nome utente e password non trovate" unless current_user?(@user) 
    end

    def map_user(x)
      a = [:id, :login]
      h = {}
      a.each { |y| h[y] = x[y] }
      h
    end

  private
    def force_fieldcase
      set_fieldcase(:user, [:login], [])
    end
end
