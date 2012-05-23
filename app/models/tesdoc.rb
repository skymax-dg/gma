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
  
  def self.filter (tp, des, tpc, tipo_doc, causmag, page)
    whcausmag = ""
    whcausmag = "and causmags.id = " + causmag unless causmag == "" or causmag.nil?
    if tp == "RS"
      includes(:causmag, :conto =>[:anagen]).where(["causmags.tipo_doc = :tipo_doc " +
                                                    whcausmag +
                                                    " and anagens.denomin like :d and contos.tipoconto IN (:tpc)",
                                                    {:tipo_doc => tipo_doc.to_i, :d => "%#{des}%", :tpc => tpc}
                                                   ]).paginate(:page => page, :per_page => 10)
    elsif tp == "CF" then
      includes(:causmag, :conto =>[:anagen]).where(["causmags.tipo_doc = :tipo_doc " +
                                                    whcausmag +
                                                    " and anagens.codfis like :d and contos.tipoconto IN (:tpc)",
                                                    {:tipo_doc => tipo_doc.to_i, :d => "%#{des}%", :tpc => tpc}
                                                   ]).paginate(:page => page, :per_page => 10)
    elsif tp == "PI" then
      includes(:causmag, :conto =>[:anagen]).where(["causmags.tipo_doc = :tipo_doc " +
                                                    whcausmag +
                                                    " and anagens.pariva like :d and contos.tipoconto IN (:tpc)",
                                                    {:tipo_doc => tipo_doc.to_i, :d => "%#{des}%", :tpc => tpc}
                                                   ]).paginate(:page => page, :per_page => 10)
    elsif tp == "MS" then
      includes(:causmag, :conto =>[:anagen]).where(["causmags.tipo_doc = :tipo_doc " +
                                                    whcausmag +
                                                    " and contos.codice >= :d and contos.codice <= :d and contos.tipoconto IN (:tpc)",
                                                    {:tipo_doc => tipo_doc.to_i, :d => des.to_i, :tpc => tpc}
                                                   ]).paginate(:page => page, :per_page => 10)
    elsif tp.nil? then
      includes(:causmag).where(["causmags.tipo_doc = :tipo_doc " + whcausmag,
                                          {:tipo_doc => tipo_doc.to_i}
                                         ]).paginate(:page => page, :per_page => 10)
    end
  end

  NRMAG = $ParAzienda['ANAIND']['NRMAG']
  SEGUEFATT = $ParAzienda['TESDOC']['SEGUEFATT']
  TIPO_DOC = $ParAzienda['CAUSMAG']['TIPO_DOC']

end
