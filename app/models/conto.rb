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

  def self.new_codice(anno, azd, tpc)
    (self.maximum("codice", :conditions => ["annoese = :ae AND azienda = :azd AND tipoconto = :tpc",
                                             {:ae=>anno, :azd=>azd, :tpc=>tpc}]).to_i||0) + 1
  end

  def self.create_default(azd, tpc, ana_id)
    @conto = Conto.new(:annoese   => current_annoese, :azienda=>azd, :tipoconto => tpc,
                       :anagen_id => ana_id,          :tipopeo => "P")
    @conto.codice = Conto.new_codice(@conto.annoese, @conto.azienda, @conto.tipoconto)

    err=Array.new
    err<<"Tipologia conto errato" if tpc!='C' && tpc!='F' 
    err<<"Anagrafica generale non presente" if Anagen.where(:id=>ana_id).count=0
    err<<"Conto gia' presente" if Conto.where(:annoese  =>@conto.annoese,   :azienda  =>@conto.azienda,
                                              :tipoconto=>@conto.tipoconto, :anagen_id=>@conto.anagen_id).count > 0
    if err.count==0
      @conto.descriz = Anagen.find(ana_id).denomin
      err<<"salvataggio fallito" unless @conto.save
    end
    err
  end

  def self.filter (tpc, tp, des, azienda, annoese, page)
    # Esegure la ricerca del conto in base ai filtri impostati

    nrrecord = nil
    hsh = {"DE" => "descriz", "RS" => "denomin", "CC" => "codice"}
    hshvar = Hash.new
    whconto = " tipoconto = :tpc"
    hshvar[:tpc] = "#{tpc}"
    whanagen = ""
    if (not des.blank?)
      whconto += " and UPPER(contos.#{hsh[tp]}) like UPPER(:d)" if tp=="DE" 
      hshvar[:d] = "%#{des}%" if tp=="DE"
      whanagen += " and UPPER(anagens.#{hsh[tp]}) like UPPER(:e)" if tp=="RS"
      hshvar[:e] = "%#{des}%" if tp=="RS"
      whconto += " and UPPER(CAST(contos.#{hsh[tp]} AS text)) like UPPER(:d)" if tp=="CC"
      hshvar[:d] = "%#{des}%" if tp=="CC"
    end
    nrrecord = includes(:anagen).where([whconto + whanagen, hshvar]).azdanno(azienda, annoese).count if page.nil?

    return includes(:anagen).where([whconto + whanagen, hshvar]).azdanno(azienda, annoese).paginate(
      :page => page,
      :per_page => 10,
      :order => "contos.codice ASC"), nrrecord unless hsh[tp].nil?
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
    return "#{self.codice.to_s} #{Conto::TIPOCONTO[self.tipoconto]} #{self.anagen.denomin}" if self.anagen
    return "#{self.codice.to_s} #{Conto::TIPOCONTO[self.tipoconto]}"
  end
  
  def self.findbytipoconto(azienda, annoese, tipoconto)
    where(["azienda = :az and annoese = :ae and tipoconto = :tpc", {:az => azienda, :ae => annoese, :tpc => tipoconto}])
  end

  def self.find_distributori(azienda, annoese)
    includes(:anagen=>[:anainds]).where(["contos.azienda   = :az and
                                           contos.annoese   = :ae and
                                           contos.tipoconto = 'C' and
                                           anainds.flmg ='S'", {:az => azienda, :ae => annoese}])
  end

  def self.find4docfilter(cfa, tpf, des, azienda, annoese)
    # Filtra i conti referenziati dalle anagrafiche (anagen) in like sul dato CodFis/ParIva/Denomin
    hsh = {"RS" => "denomin", "CF" => "codfis", "PI" => "pariva"}
    hsh.default = "denomin"
    whana = "anagens.#{hsh[tpf]} like '%#{des}%' and "
    includes(:anagen).where([whana + "contos.tipoconto IN (:tpc) and azienda = :azd and annoese = :anno",
                                        {:tpc => cfa, :azd => azienda, :anno => annoese}])
  end

  private
    def require_no_tesdocs
      self.errors.add :base, "Almeno un documento fa riferimento al conto che si desidera eliminare."
      raise ActiveRecord::RecordInvalid.new self unless tesdocs.count == 0
    end
end
