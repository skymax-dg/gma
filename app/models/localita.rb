class Localita < ActiveRecord::Base
  before_destroy :require_no_anainds
  before_destroy :require_no_anagens

  has_many :anainds
  has_many :anagens, :foreign_key => "luogonas_id"
  belongs_to :paese

  attr_accessible :cap, :codfis, :descriz, :prov, :paese_id

  validates :descriz, :paese_id, :presence => true
  validates :descriz, :length => { :maximum => 50}
  validates :cap, :length => { :maximum => 5}
  validates :codfis, :length => { :maximum => 4}
  validates :prov, :length => { :maximum => 2}

  private

  def self.filter (tp, des, page)
    # Esegure la ricerca delle citta' in base ai filtri impostati

    hsh = {"DE" => "descriz", "CP" => "cap", "NA" => "descriz"}
    hshvar = Hash.new
    whloc = "" 
    whloc = " localitas.#{hsh[tp]} like :d" unless des == ""||tp =="NA"
    hshvar[:d] = "%#{des}%" unless des == ""||tp =="NA"
    whpaese = ""
    whpaese = " paeses.#{hsh[tp]} like :e" unless des == ""||tp !="NA"
    hshvar[:e] = "%#{des}%" unless des == ""||tp !="NA"
    
    includes(:paese).where([whpaese + whloc, hshvar]).paginate(:page => page,
                                                               :per_page => 10,
                                                               :order => "localitas.descriz ASC") unless hsh[tp].nil?
  end

  def require_no_anainds
    self.errors.add :base, "Almeno un indirizzo fa riferimento alla citta' che si desidera eliminare."
    raise ActiveRecord::RecordInvalid.new self unless anainds.count == 0
  end

  def require_no_anagens
    self.errors.add :base, "Almeno un luogo di nascita anagrafico fa riferimento alla citta' che si desidera eliminare."
    raise ActiveRecord::RecordInvalid.new self unless anagens.count == 0
  end
end
