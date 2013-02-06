class SessionsController < ApplicationController
  def new
    @title = "Accesso"
    @user = User.new
    @login = params[:login]
  end

  def create
    user = User.authenticate(params[:session][:login], params[:session][:pwd], params[:session][:azienda])
    if user.nil? 
      @title = "Accesso"
      flash.now[:alert] = "Login o password non valide."
      render 'new'
    else
      sign_in user
      set_year params[:session][:annoese]
      flash[:success] = "Benvenuto in GMA! #{user.login}"
      redirect_to root_path
    end
  end

  def destroy
    sign_out
    redirect_to :new_session unless signed_in?
  end
end
