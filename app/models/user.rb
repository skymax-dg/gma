class User < ActiveRecord::Base
  attr_accessible :login, :pwd
  
  validates :login, :presence => true,
                    #:uniqueness => true,
                    :length => { :maximum => 20, :too_long  => "Lunghezza massima permessa: 20 caratteri" }
#  validates :pwd, :presence => true,
#                  :length => { :maximum => 20, :too_long  => "Lunghezza massima permessa: 20 caratteri" }
  def signed_in?
    true
  end
end
