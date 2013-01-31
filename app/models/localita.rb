class Localita < ActiveRecord::Base
  before_destroy :require_no_anainds
  has_many :anainds

  before_destroy :require_no_anagens
  has_many :anagens, :foreign_key => "luogonas_id"

  belongs_to :paese

  attr_accessible :cap, :codfis, :descriz, :prov, :paese_id

  validates :descriz, :paese_id, :presence => true
  validates :descriz, :length => { :maximum => 50}
  validates :cap, :length => { :maximum => 5}
  validates :codfis, :length => { :maximum => 4}
  validates :prov, :length => { :maximum => 2}

  def self.find_by_cf(cf)
    find_by_codfis(Cfpi.locnas_by_cf(cf)) if Cfpi.locnas_by_cf(cf)
  end

  private

    def self.filter(tp, des, page)
      # Esegure la ricerca delle citta' in base ai filtri impostati

      nrrecord = nil
      hsh = {"DE" => "descriz", "CP" => "cap", "NA" => "descriz"}
      hshvar = Hash.new
      whloc = "" 
      whloc = " UPPER(localitas.#{hsh[tp]}) like UPPER(:d)" unless des.blank?||tp=="NA"
      hshvar[:d] = "%#{des}%" unless des.blank?||tp=="NA"
      whpaese = ""
      whpaese = " UPPER(paeses.#{hsh[tp]}) like UPPER(:e)" unless des.blank?||tp!="NA"
      hshvar[:e] = "%#{des}%" unless des.blank?||tp!="NA"

      nrrecord = includes(:paese).where([whpaese + whloc, hshvar]).count if page.nil?
      return includes(:paese).where([whpaese + whloc, hshvar]).paginate(
        :page => page,
        :per_page => 10,
        :order => "localitas.descriz ASC"), nrrecord unless hsh[tp].nil?
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
