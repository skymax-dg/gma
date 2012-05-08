class Tesdoc < ActiveRecord::Base
  belongs_to :causmag
  belongs_to :conto
  
  has_many :rigdocs

  attr_accessible :azienda, :annoese, :tipo_doc, :num_doc, :data_doc, :descriz, :causmag_id, :conto_id, :sconto

  validates :azienda, :annoese, :tipo_doc, :num_doc, :data_doc, :descriz, :causmag_id, :conto_id, :sconto, :presence => true

  # Fare un validate su :tipo_doc con i valori ammessi
  validates :tipo_doc, :length => { :maximum => 1, :too_long  => "1 carattere obbligatorio (Valori ammessi: ????? )"}
  validates :descriz,  :length => { :maximum => 150, :too_long  => "Lunghezza massima permessa: 150 caratteri" }

end
