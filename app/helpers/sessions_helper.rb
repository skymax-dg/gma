module SessionsHelper
  def current_user
    @current_user ||= user_from_remember_token
  end

  def current_annoese
    @current_annoese ||= cookies.signed[:var_se_annoese] || [nil]
  end

  def current_user?(user)
    user == current_user
  end

  def signed_in?
    !current_user.nil?
  end

  def store_location
    session[:return_to] = request.fullpath
  end
    
  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    clear_return_to
  end

  def clear_return_to
    session[:return_to] = nil
  end

  def sign_in(user)
    cookies.permanent.signed[:remember_token] = [user.id, user.salt]
	  current_user = user
  end
  
  def set_year(annoese)
    cookies.permanent.signed[:var_se_annoese] = [annoese]
    current_annoese = annoese
  end

  def unset_year
    cookies.delete(:var_se_annoese)
    current_annoese = nil
  end

  def sign_out
    cookies.delete(:remember_token)
    current_user = nil
    unset_year
  end

  def authenticate
    deny_acess unless signed_in?
  end

  def deny_acess
    store_location
    # La redirect gestisce anche il mess. flash tramite il parametro :notice
    redirect_to :new_session, :notice => "Accesso negato, effettuare il LOGIN per accedere a questa pagina"
  end

  private
	  def user_from_remember_token
	  	User.authenticate_with_salt(*remember_token)
	  end
    
    def remember_token
      cookies.signed[:remember_token] || [nil, nil]
    end
end
