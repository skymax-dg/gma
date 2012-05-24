class Tesdoc < ActiveRecord::Base
  belongs_to :causmag
  belongs_to :conto
  has_many :rigdocs

  attr_accessible :azienda, :annoese, :tipo_doc, :num_doc, :data_doc, :descriz,
                  :causmag_id, :nrmagsrc, :nrmagdst, :seguefatt, :conto_id, :sconto

  validates :azienda, :annoese, :tipo_doc, :num_doc, :data_doc, :descriz,
            :causmag_id, :conto_id, :nrmagsrc, :nrmagdst, :seguefatt, :sconto, :presence => true
# Fare un validate su :tipo_doc con i valori ammessi
  validates :descriz,  :length => { :maximum => 150, :too_long  => "Lunghezza massima permessa: 150 caratteri" }

  NRMAG = $ParAzienda['ANAIND']['NRMAG']
  SEGUEFATT = $ParAzienda['TESDOC']['SEGUEFATT']
  TIPO_DOC = $ParAzienda['CAUSMAG']['TIPO_DOC']

  def self.filter (tp, des, tpc, tipo_doc, causmag, conto, page)
    whcausmag = " "
    whconto = " "
    whcausmag = " and causmags.id = " + causmag unless causmag == "" or causmag.nil?
    whconto = " and contos.id = " + conto unless conto == "" or conto.nil?

    hsh = {"RS" => "denomin", "CF" => "codfis", "PI" => "pariva"}
    includes(:causmag, :conto =>[:anagen]).where(["causmags.tipo_doc = :tipo_doc" +
                                                  whcausmag + whconto +
                                                  " and anagens.#{hsh[tp]} like :d and contos.tipoconto IN (:tpc)",
                                                  {:tipo_doc => tipo_doc.to_i, :d => "%#{des}%", :tpc => tpc}
                                                 ]).paginate(:page => page, :per_page => 10) unless hsh[tp].nil?
  end
end
