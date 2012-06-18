class SessionsController < ApplicationController
  def new
    @title = "Sign in"
  end

  def create
    user = User.authenticate(params[:session][:name], params[:session][:pwd])
    if user.nil? 
      flash.now[:error] = "Login o password non valide."
      @title = "Accesso"
      render 'new'
    else
      sign_in user
      redirect_back_or user # Va alla pagina memorizzata o alla user => UserPage
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end
end
