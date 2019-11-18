class AnagSocial < ActiveRecord::Base
  attr_accessible :saddr, :state, :stype
  belongs_to :anagen

  TIPO = $ParAzienda['ANAGEN']['TIPO_SOCIAL']

  def self.list_type
  end

  def dtype
  end
end
