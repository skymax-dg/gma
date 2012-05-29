class Tesdoc < ActiveRecord::Base
  belongs_to :causmag
  belongs_to :conto
  has_many :rigdocs, :dependent => :destroy

  attr_accessible :azienda, :annoese, :tipo_doc, :num_doc, :data_doc, :descriz,
                  :causmag_id, :nrmagsrc, :nrmagdst, :seguefatt, :conto_id, :sconto

  validates :azienda, :annoese, :tipo_doc, :num_doc, :data_doc, :descriz,
            :causmag_id, :conto_id, :nrmagsrc, :nrmagdst, :seguefatt, :sconto, :presence => true
  validates :descriz,  :length => { :maximum => 150}

  NRMAG = $ParAzienda['ANAIND']['NRMAG']
  SEGUEFATT = $ParAzienda['TESDOC']['SEGUEFATT']
  TIPO_DOC = $ParAzienda['CAUSMAG']['TIPO_DOC']

  def self.filter (tp, des, tpc, tipo_doc, causmag, conto, page)
    hsh = {"RS" => "denomin", "CF" => "codfis", "PI" => "pariva"}
    hshvar = Hash.new

    whcausmag = "causmags.tipo_doc = :tipo_doc"
    hshvar[:tipo_doc] = tipo_doc.to_i
    whcausmag += " and causmags.id = :cm" unless causmag == "" or causmag.nil?
    hshvar[:cm] = causmag unless causmag == "" or causmag.nil?

    whconto = " and contos.tipoconto IN (:tpc)"
    hshvar[:tpc] = tpc
    whconto += " and contos.id = :cn" unless conto == "" or conto.nil?
    hshvar[:cn] = conto unless conto == "" or conto.nil?

    whana = "" 
    whana = " and anagens.#{hsh[tp]} like :d" unless des == ""
    hshvar[:d] = "%#{des}%" unless des == ""
    
    includes(:causmag, :conto =>[:anagen]).where([whcausmag + whconto + whana,
                                                  hshvar]).paginate(:page => page, :per_page => 10) unless hsh[tp].nil?
  end
end
