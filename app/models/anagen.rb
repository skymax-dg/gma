class Anagen < ActiveRecord::Base
  #has_many :prezzoarticclis, :foreign_key => "anag_id",
  #                           :dependent => :destroy
  before_destroy :require_no_contos
  has_many :contos
  has_many :anainds, :dependent => :destroy
  belongs_to :localita, :foreign_key => "luogonas_id"
  
#  default_scope :order => 'anagens.denomin ASC' Non funziona perchè c'è una select max

  attr_accessible :codice, :tipo, :denomin, :codfis, :pariva, :dtnas, :luogonas_id, :sesso,
                  :telefono, :email, :fax, :web, :sconto

  validates :codice, :tipo, :denomin, :presence => true
  validates :codice, :denomin, :uniqueness => true
  validates :codfis, :uniqueness => true, :unless => "codfis.blank?"
  validates :pariva, :uniqueness => true, :unless => "pariva.blank?"

  # Fare un validate su :tipo con i valori ammessi
  validates :tipo,     :length => {:maximum => 1}
  validates :denomin,  :length => {:maximum => 150}
  validates :codfis,   :length => {:maximum => 16}
  validates :pariva,   :length => {:maximum => 11}
  validates :sesso,    :length => {:maximum => 1}
  validates :telefono, :length => {:maximum => 20}
  validates :email,    :length => {:maximum => 50}
  validates :fax,      :length => {:maximum => 20}
  validates :web,      :length => {:maximum => 50}

  TIPO = $ParAzienda['ANAGEN']['TIPO_SOGGETTO']

  def self.filter (tp, des, page)
    # Esegure la ricerca delle anagrafiche soggetto in base ai filtri impostati
    hsh = {"RS" => "denomin", "CF" => "codfis", "PI" => "pariva"}
    nrrecord = nil
    hshvar = Hash.new
    whana = "" 
    whana = " UPPER(anagens.#{hsh[tp]}) like UPPER(:d)" unless des.blank?
    hshvar[:d] = "%#{des}%" unless des.blank?

    # Se il param. page non è valorizzato allora stiamo facendo una nuova ricerca altrimenti
    # abbiamo richiesto una pagina successiva o precedente e non serve la count
    nrrecord = where([whana, hshvar]).count if page.nil?

    return where([whana, hshvar]).paginate(:page => page, :per_page => 10,
                                           :order => "denomin ASC"), nrrecord unless hsh[tp].nil?
  end

  def sedelegale
    sl={}
    self.anainds.each {|ind| sl={:indir => ind.indir, :desloc => ind.desloc} if ind.flsl=="S"}
    sl
  end

  def magsavailable(inivalue)
    # Ricerco i magazzini inseriti sull'anagrafica, con il .map creo un array formato dai vari nrmag,
    # con il comando select applicato all'hash Anaind::NRMAG restituisco un altro hash formato
    # dai magazzini disponibili ovvero che hanno corrispondenza sull'array creato dal comando map
#    mags = Anaind.find(:all,
#                       :select => "nrmag",
#                       :conditions => ["anagen_id = :anaid and flmg = 'S'", {:anaid => self.id}]).map{|c| c.nrmag}
#    Hash[*Anaind::NRMAG.select{|k,v| (mags+inivalue).index(k)}.flatten]
    magsplus=Hash.new
    mags = Anaind.find(:all,
                             :select => "nrmag, desloc",
                             :conditions => ["anagen_id = :anaid and flmg = 'S'", {:anaid => self.id}]
                             ).each{|m| magsplus[m.nrmag]=m.desloc}
    inivalue.each{|v|magsplus[v]=Anaind::NRMAG[v]}
    magsplus
  end

  def self.newcod()
    (self.maximum("codice").to_i||0) + 1
    #(select("max(codice) as maxcod")[0].maxcod.to_i||0) + 1
  end

  def pi_or_cf
    self.pariva && (not self.pariva.blank?) ? self.pariva : self.codfis||""
  end

  def self.findbytpconto(azienda, tipoconto)
    find_by_sql("SELECT DISTINCT anagens.id, anagens.denomin 
                   FROM anagens INNER JOIN contos ON (anagens.id = contos.anagen_id)
                  WHERE contos.tipoconto = '#{tipoconto.to_s}' AND contos.azienda = #{azienda.to_s} 
                  ORDER BY anagens.denomin")
  end
  private
    def require_no_contos
      self.errors.add :base, "Almeno un conto fa riferimento all' anagrafica che si desidera eliminare."
      raise ActiveRecord::RecordInvalid.new self unless contos.count == 0
    end
end
