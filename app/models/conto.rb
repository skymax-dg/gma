#include ContosHelper
class Conto < ActiveRecord::Base
  before_destroy :require_no_tesdocs
  has_many :tesdocs
  belongs_to :anagen

  default_scope :order => 'contos.descriz ASC'

  attr_accessible :annoese, :azienda, :codice, :descriz, :anagen_id, :tipoconto, :tipopeo, :cntrpartita, :sconto

  validates :annoese, :azienda, :codice, :descriz, :tipoconto, :tipopeo, :sconto, :presence => true
  validates :descriz, :length => { :maximum => 150}
  validates :codice, :numericality => { :only_integer => true }
  validate :codice_toobig4integer #(non mettendo niente la validazione scatta su create e update), :on => :create
  validates_uniqueness_of :codice, :scope => [:azienda, :annoese]
  validates_uniqueness_of :anagen_id, :scope => [:azienda, :annoese, :tipoconto]
  
  scope :azdanno, lambda { |azd, anno| {:conditions => ['contos.azienda = ? and contos.annoese = ?', azd, anno]}}

  TIPOCONTO = $ParAzienda['CONTO']['TIPOCONTO']
  TIPOPEO = $ParAzienda['CONTO']['TIPOPEO']

  def self.filter (tp, des, azienda, annoese, page)
    # Esegure la ricerca del conto in base ai filtri impostati

    hsh = {"DE" => "descriz", "RS" => "denomin", "CC" => "codice"}
    hshvar = Hash.new
    whconto = "" 
    whanagen = ""
    if des.strip.length > 0
      whconto = " contos.#{hsh[tp]} like :d" if tp=="DE" 
      hshvar[:d] = "%#{des}%" if tp=="DE"
      whconto = " CAST(contos.#{hsh[tp]} AS text) like :d" if tp=="CC"
      hshvar[:d] = "%#{des}%" if tp=="CC"
      whanagen = " anagens.#{hsh[tp]} like :e" if tp=="RS"
      hshvar[:e] = "%#{des}%" if tp=="RS"
    end
    includes(:anagen).where([whanagen + whconto, hshvar]).azdanno(azienda, annoese).paginate(
      :page => page,
      :per_page => 10,
      :order => "contos.codice ASC") unless hsh[tp].nil?
  end

  def codice_toobig4integer
    errors.add(:codice, "Valore massimo consentito: 2147483647") if self.codice > 2147483647
  end

  def magsavailable(inivalue)
    #trova i magazzini disponibili (per popolare una combo)
    return Hash[*Anaind::NRMAG.select{|k,v| inivalue.index(k)}.flatten] if self.anagen.nil?
    return self.anagen.magsavailable(inivalue)
  end

  def desest1
    self.codice.to_s + " " + Conto::TIPOCONTO[self.tipoconto] + " " + self.anagen.denomin
  end
  
  def self.findbytipoconto(azienda, annoese, tipoconto)
    where(["azienda = :az and annoese = :ae and tipoconto = :tpc", {:az => azienda, :ae => annoese, :tpc => tipoconto}])
  end

  def self.find4docfilter(cfa, tpf, des, azienda, annoese)
    # Filtra i conti referenziati dalle anagrafiche (anagen) in like sul dato CodFis/ParIva/Denomin
    hsh = {"RS" => "denomin", "CF" => "codfis", "PI" => "pariva"}
    hsh.default = "denomin"
    whana = "anagens." + hsh[tpf] + " like '%" + des + "%' and "
    includes(:anagen).where([whana + "contos.tipoconto IN (:tpc) and azienda = :azd and annoese = :anno",
                                        {:tpc => cfa, :azd => azienda, :anno => annoese}])
  end

  private
    def require_no_tesdocs
      self.errors.add :base, "Almeno un documento fa riferimento al conto che si desidera eliminare."
      raise ActiveRecord::RecordInvalid.new self unless tesdocs.count == 0
    end
end
