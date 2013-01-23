class Scadenza < ActiveRecord::Base
  belongs_to :tesdoc

  attr_accessible :data, :stato, :tesdoc_id, :tipo, :descriz, :importo

  TIPO  = $ParAzienda['SCADENZA']['TIPO']
  STATO = $ParAzienda['SCADENZA']['STATO']

  validates :data, :stato, :tesdoc_id, :tipo, :importo, :presence => true

  def self.filter (conto_id, causmag_id, dtini,dtfin, tp, stato, azienda, annoese, page)
    # Esegure la ricerca nei documenti in base ai filtri impostati

    mywhere = "tesdocs.azienda = #{azienda} AND tesdocs.annoese = #{annoese}"
    mywhere += " AND tesdocs.conto_id = #{conto_id}" if conto_id.to_i > 0
    mywhere += " AND tesdocs.causmag_id = #{causmag_id}" if causmag_id.to_i > 0
    mywhere += " AND tesdocs.data_doc >= '#{dtini}' AND tesdocs.data_doc <= '#{dtfin}'" if dtini > 0 && dtfin > 0
    mywhere += " AND scadenzas.tipo = '#{tp}'" if tp != ""
    mywhere += " AND scaddenzas.stato = '#{stato}'" if stato != ""

    page.nil? ? nrrecord = includes(:tesdoc).where(mywhere).count : nrrecord = nil
    return includes(:tesdoc).where(mywhere).paginate(:page => page, :per_page => 10, :order => "scadenzas.data"), nrrecord
  end

end
