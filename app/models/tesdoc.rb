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
  
  def self.filter (tp, des, tpc, page)
    if tp == "RS"
      joins(:conto).where(["contos.descriz like :d and contos.tipoconto IN (:tpc)",
                                {:d => "%#{des}%", :tpc => tpc}
                               ]).paginate(:page => page, :per_page => 10)
    elsif tp == "MS" then
      des = des.to_i
      joins(:conto).where(["contos.codice >= :d and contos.codice <= :d and contos.tipoconto IN (:tpc)",
                                {:d => des, :tpc => tpc}
                               ]).paginate(:page => page, :per_page => 10)
    elsif tp == "CF" then
      paginate(:page => page, :per_page => 10)
    elsif tp == "PI" then
      paginate(:page => page, :per_page => 10)
    end
  end

  NRMAG = $ParAzienda['ANAIND']['NRMAG']
  SEGUEFATT = $ParAzienda['TESDOC']['SEGUEFATT']
  TIPO_DOC = $ParAzienda['TESDOC']['TIPO_DOC']

end
