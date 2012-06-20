class SessionsController < ApplicationController
  def new
    @title = "Accesso"
  end

  def create
    user = User.authenticate(params[:session][:login], params[:session][:pwd], params[:session][:azienda])
    if user.nil? 
      flash.now[:error] = "Login o password non valide."
      @title = "Accesso"
      render 'new'
    else
      sign_in user, params[:session][:annoese]
      redirect_back_or user # Va alla pagina memorizzata o alla user => UserPage
    end
  end

  def destroy
    sign_out
    redirect_to :action => 'new', :controller=> "sessions" unless signed_in?
  end
end
