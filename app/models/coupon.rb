class Coupon < ActiveRecord::Base
  attr_accessible :anagen_id, :state, :value, :perc, :dt_start, :dt_end, :dt_use, :ord_min, :code, :batch_code

  belongs_to :anagen

  scope :not_used, lambda {{:conditions => ['state = ?', 0]}}
  scope :generic, lambda {{:conditions => ['anagen_id = ?', 0]}}

  STATES = [ ["DISPONIBILE",0], ["USATO",1] ]

  def d_state
    tmp = STATES.select { |a,b| b == self.state }
    tmp.size > 0 ? tmp[0][0] : ''
  end

  def map_json
    st = Struct.new(:id, :state, :value, :perc, :dt_start, :dt_end, :dt_use, :ord_min)
    st.new(self.id, self.state, self.value, self.perc, self.dt_start, self.dt_end, self.dt_use, self.ord_min)
  end

  def self.gen_batch_code(user_id)
    date = Time.now.strftime("%Y%m%d%H%M")
    "%d_%d"%[user_id, date]
  end

  def mail_body
    msg = ""
    msg
  end

  def mail_body
    msg = ""
    if self.anagen
      msg << "Ciao #{self.anagen.denomin}!\n"
    end
    msg
  end
end
