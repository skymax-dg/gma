class Article < ActiveRecord::Base
  acts_as_reportable
  before_destroy :require_no_rigdocs
  has_many :rigdocs

  attr_accessible :codice, :descriz, :prezzo, :azienda

  validates :codice, :descriz, :azienda, :presence => true
  validates :codice, :descriz, :uniqueness => true
  validates :codice,  :length => { :maximum => 10}
  validates :descriz, :length => { :maximum => 50}
  
  scope :azienda, lambda { |azd| {:conditions => ['articles.azienda = ?', azd]}}
  default_scope :order => 'articles.codice ASC' 

  def self.chk_art_xls(xls, wks, rownr, colnr)
    # Controlla che nel file excel xls nello sheet wks(0base), partendo dalla riga rownr,
    # ogni valore della colonna colnr corrisponda ad un codice articolo nel DB 
    errors = []
    xls.worksheet(wks).each rownr do |row|
      unless row[colnr].blank?
        if not find_by_azienda_and_codice(current_user.azienda, row[colnr].to_s.strip)
          errors << "L'articolo con codice: " + row[colnr].to_s.strip + " riportato sulla riga: " + (row.idx + 1).to_s + " non e' presente in banca dati."
        end
      end
    end
    return errors
  end

  def desest1
    self.codice.to_s + " " + self.descriz
  end

  def self.movmag(id)
    # Tutti i movimenti di magazzino di un articolo (titolo)
    Article.find_by_sql("SELECT tesdocs.data_doc AS Data_doc, tesdocs.num_doc AS Numero,
                                causmags.descriz AS Causale, causmags.tipo AS Mov, rigdocs.qta AS Qta,
                                causmags.movimpmag AS Mag
                           FROM articles INNER JOIN rigdocs ON (articles.id = rigdocs.article_id)
                                         INNER JOIN tesdocs ON (rigdocs.tesdoc_id = tesdocs.id)
                                         INNER JOIN causmags ON (tesdocs.causmag_id = causmags.id)
                          WHERE causmags.movimpmag IN ('M', 'I') AND articles.id = " + id.to_s +
                       " ORDER BY tesdocs.data_doc, tesdocs.num_doc")
  end

  private
    def require_no_rigdocs
      self.errors.add :base, "Almeno una riga documento fa riferimento all'articolo che si desidera eliminare."
      raise ActiveRecord::RecordInvalid.new self unless rigdocs.count == 0
    end
end
