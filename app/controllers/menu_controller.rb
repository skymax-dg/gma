class MenuController < ApplicationController
  before_filter :authenticate

  def home
	  redirect_to :new_session unless signed_in?
  end

  def contact
  end

  def help
  end
end
