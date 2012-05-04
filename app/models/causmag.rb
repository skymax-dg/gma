class Causmag < ActiveRecord::Base
  belongs_to :magsrc
  belongs_to :magdst
  attr_accessible :descriz, :fattura, :tipo
end
