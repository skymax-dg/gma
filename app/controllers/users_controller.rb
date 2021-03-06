# encoding: utf-8
class UsersController < ApplicationController
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
  
  private
    def correct_user
      @user = User.find(params[:id])
      redirect_to root_path, 
                  :alert => "Nome utente e password non trovate" unless current_user?(@user) 
    end

  private
    def force_fieldcase
      set_fieldcase(:user, [:login], [])
    end
end
