# encoding: utf-8
class UsersController < ApplicationController
  before_filter :authenticate_request, if: :json_request?
  before_filter :authenticate, :except => [:new, :create]
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

    when "4"
      u = User.find(params[:id]) if User.exists? params[:id]
      render json: u ? u.get_gac_user : nil

    when "5"
      st = User.appo_update(params)
      Rails.logger.info "------------------ status: #{st} (#{st.class})"
      render json: { status: st, errors: st ? nil : "WIP" }

    when "6"
      st, id = Anagen.add_addr(params)
      Rails.logger.info "------------------ status: #{st}, id: #{id}"
      render json: { status: st, id: id }

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
