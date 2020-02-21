class Coupon < ActiveRecord::Base
  attr_accessible :anagen_id, :state, :value, :perc, :dt_start, :dt_end, :dt_use, :ord_min, :code, :batch_code, :togli_spese_spedizione, :article_id, :discount_code

  belongs_to :anagen
  belongs_to :article

  scope :not_used,           lambda {{:conditions => ['state = ?', 0]}}
  scope :discount_codes,     lambda {{:conditions => ['state = ?', 2]}}
  scope :not_discount_codes, lambda {{:conditions => ['state != ?', 2]}}
  scope :generic,            lambda {{:conditions => ['anagen_id = ?', 0]}}

  STATES = [ ["DISP.",0], ["USATO",1], ["CODICE SCONTO", 2] ]
  SPEDIZ = [ ["NO",0], ["SI",1] ]
  NOTIFY_DAYS = 30

  def d_state
    tmp = STATES.select { |a,b| b == self.state }
    tmp.size > 0 ? tmp[0][0] : ''
  end

  def used?
    self.state == 1
  end

  def map_json
    st = Struct.new(:id, :state, :value, :perc, :dt_start, :dt_end, :dt_use, :ord_min, :togli_spese_spedizione, :article_id, :d_article)
    st.new(self.id, self.state, self.value, self.perc, self.dt_start, self.dt_end, self.dt_use, self.ord_min, self.togli_spese_spedizione, self.article_id, self.article && self.article.descriz)
  end

  def self.gen_batch_code(user_id)
    date = Time.now.strftime("%Y%m%d%H%M")
    "%d_%d"%[user_id, date]
  end

  def mail_title
    msg = "Conferma di iscrizione alla newsletter e COUPON Sconto!"
    msg
  end

  def mail_body
    msg = ""
    if self.anagen
      msg << "Ciao #{self.anagen.denomin},\n\n"

      msg << "grazie per esserti iscritto alla nostra Newsletter, ti terremo sempre aggiornato sui nuovi prodotti e sulle nostre incredibili offerte.\n\n"

      msg << "Siamo felici di comunicarti che il tuo COUPON SCONTO e' ora attivo!\n"
      msg << "Per poterlo utilizzare non ti resta che andare su www.eifis.it, accedere, e fare i tuoi acquisti, al momento del pagamento ti sara' data la possibilita' di utilizzare il tuo COUPON.\n\n\n"



      val = "%.2f"%[self.value || 0.0]
      msg << "IL COUPON HA UN VALORE DI #{val} EURO\n"
      dt = "#{self.dt_end.day}/#{self.dt_end.month}/#{self.dt_end.year}" 
      msg << "e sara' valido fino al #{dt}\n\n\n"


      msg << "Per qualsiasi richiesta, dubbio o necessita' scrivici a ordini@eifis.it\n\n"


      msg << "Porta piu' Energia nella tua vita!\n"
      msg << "Lo staff di EIFIS Editore\n"
      msg << "www.eifis.it\n\n"
    end
    msg.gsub("\n","%0D%0A")
  end

  def d_spediz
    tmp = SPEDIZ.select { |a,b| b == self.state }
    tmp.size > 0 ? tmp[0][0] : ''
  end

  def duplicate
    self.dup
  end

  def d_article
    self.article ? self.article.descriz : ""
  end

  def self.has_anagen?(anag_id, code)
    Coupon.where(discount_code: code, anagen_id: anag_id).size > 0
  end

end
