class UsersController < ApplicationController
 def new
    @user = User.new
  	@title = "Creazione utente"
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Benvenuto in GMA!"
      redirect_to @user
    else
	  	@title = "Creazione utente"
      render 'new'
    end
  end

  def show
    @user = User.find(params[:id])
    @title = @user.login
    store_location
  end

  def edit
    #@user = User.find(params[:id]) find già fatto nella correct_user
    @title = "Edit user"
  end

  def update
    #@user = User.find(params[:id]) find già fatto nella correct_user
    if @user.update_attributes(params[:user])
      flash[:success] = "Utente aggiornato con successo."
      redirect_to user_path
    else
      @title = "Edit user"
      render 'edit'
    end
  end

  def index
    @title = "All users"
    @users = User.paginate(:page => params[:page])
#    @users = User.all #oppure User.find(:all)
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "Utente cancellato."
    redirect_to users_path
  end
  
  private

    def correct_user
      @user = User.find(params[:id])
      redirect_to root_path, 
                  :notice => "Nome utente e password non trovate" unless current_user?(@user) 
    end

end
