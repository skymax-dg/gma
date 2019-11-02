#
#	config/routes.rb 
#		post 'authenticate', to: 'authentication#authenticate'
#
class AuthenticationController < ApplicationController

  protect_from_forgery with: :null_session
	skip_before_filter :verify_authenticity_token, if: :json_request?

  def json_request?
    request.format.json?
  end

  def authenticate
		@email = params[:email]
		@password = params[:password]
		@duration = params[:duration]

		if tk = appo_authenticate
			render json: { auth_token: tk }
		else
			render json: { error: -1, email: @email, password: @password, tk: tk}, status: :unauthorized
		end
  end

	private

	attr_accessor :email, :password

  def appo_authenticate
		if user
			puts "user %d " % [ user.id ]
      if @duration
        JsonWebToken::encode({user_id: user.id}, @duration)
      else
        JsonWebToken::encode(user_id: user.id)
      end
		else
			puts "no user"
		end
  end

	def user
		puts "email %s password %s" % [@email,@password]
		auser = User.find_by_email(@email)
		return auser if auser && auser.has_password?(@password)
	end
end
