class AnagSocial < ActiveRecord::Base
  attr_accessible :saddr, :state, :stype, :anagen_id
  belongs_to :anagen
  scope :not_hidden, lambda {{:conditions => ['state = ?', 1]}}

  TIPO = $ParAzienda['ANAGEN']['TIPO_SOCIAL']
  STATI = [
    ["Visibile",1],
    ["Nascosto",0]
  ]

  def self.list_type
  end

  def dtype
    tmp = TIPO.select { |k,v| k == self.stype }
    tmp.size > 0 ? tmp.values[0] : ''
  end

  def dstate
    tmp = STATI.select { |a,b| b == self.state }
    tmp.size > 0 ? tmp[0][0] : ''
  end
end
