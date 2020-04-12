class MenuController < ApplicationController
  before_filter :authenticate

  def home
	  redirect_to :new_session unless signed_in?
    stat = User.statistics
    
    @stat_users = stat[0]
    @stat_orders = stat[1][0..7]
    @stat_months = stat[2]
  end

  def contact
  end

  def help
  end
end
