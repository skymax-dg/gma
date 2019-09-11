class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  include TesdocsHelper

  def set_fieldcase(model, fld_upcase = [], fld_dwcase = [])
    fld_upcase.each {|v| params[model][v]=params[model][v].upcase if params[model][v]}
    fld_dwcase.each {|v| params[model][v]=params[model][v].downcase if params[model][v]}
  end

  def flash_cnt(nrrecord)
    nrrecord == 0 ? flash.now[:alert] = "Ricerca negativa nessun risultato trovato!"
                  : flash.now[:success] = "La ricerca ha prodotto #{nrrecord} risultati"
  end

  def authenticate_request
		@errors = []
		decode_current_user
    @errors.each { |s| Rails.logger.info "authentication error #{s}" }
		render json: { error: 'Not authorized' }, status: 401 unless @current_user
	end

   def json_request?
     Rails.logger.info "------------------ JSON? #{request.format.json?}"
     request.format.json?
   end
private

	def decode_current_user
		@current_user ||= User.find( decoded_auth_token['user_id']) if decoded_auth_token
		@current_user || @errors << [:token, 'invalid token'] && nil
  end

  def decoded_auth_token
		@decoded_auth_token ||= JsonWebToken::decode(http_auth_header)
	end

	def http_auth_header
		if request.headers['Authorization'].present?
			return request.headers['Authorization'].split(' ').last
		else
			@errors << [ :token, 'missing token' ]
			return nil
		end
	end

end
