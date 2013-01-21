class Scadenza < ActiveRecord::Base
  belongs_to :tesdoc

  attr_accessible :data, :stato, :tesdoc_id, :tipo, :descriz, :importo

  TIPO  = $ParAzienda['SCADENZA']['TIPO']
  STATO = $ParAzienda['SCADENZA']['STATO']

  validates :data, :stato, :tesdoc_id, :tipo, :importo, :presence => true

  def self.filter (conto_id, causmag_id, dtini,dtfin, tp, stato, azienda, annoese, page)
    # Esegure la ricerca nei documenti in base ai filtri impostati

    nrrecord = nil

#    hsh = {"RS" => "denomin", "CF" => "codfis", "PI" => "pariva"}
#    hshvar = Hash.new

#    whcausmag         = "causmags.tipo_doc = :tipo_doc"
#    hshvar[:tipo_doc] = tipo_doc.to_i
#    whcausmag        += " and causmags.id = :cm" unless causmag.blank?
#    hshvar[:cm]       = causmag unless causmag.blank?

#    whconto      = " and contos.tipoconto IN (:tpc)"
#    hshvar[:tpc] = tpc
#    whconto     += " and contos.id = :cn" unless conto.blank?
#    hshvar[:cn]  = conto unless conto.blank?

#    whana = "" 
#    whana = " and UPPER(anagens.#{hsh[tp]}) like UPPER(:d)" unless des.blank?
#    hshvar[:d] = "%#{des}%" unless des.blank?
    
#    nrrecord = includes(:causmag, :conto =>[:anagen]).where([whcausmag + whconto + whana, hshvar]).azdanno(
#      azienda, annoese).count if page.nil?

#    return includes(:causmag, :conto =>[:anagen]).
#             where([whcausmag + whconto + whana, hshvar]).
#               azdanno(azienda, annoese).
#                 paginate(:page => page, 
#                          :per_page => 10, 
#                          :order => "data_doc DESC, num_doc, causmag_id"), nrrecord unless hsh[tp].nil?
  end

end
