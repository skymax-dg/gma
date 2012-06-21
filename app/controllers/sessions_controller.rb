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
      sign_in user
      set_year params[:session][:annoese]
      redirect_back_or user # Va alla pagina memorizzata o alla user => UserPage
    end
  end

#  def change_year
#    @annoese = current_annoese
#  end

#  def set_year
#    unset_year
#    set_year params[:annoese]
#  end

  def destroy
    sign_out
    redirect_to :new_session unless signed_in?
  end
end
