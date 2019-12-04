class AnagenArticle < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :anagen
  belongs_to :article
  attr_accessible :anagen_id, :article_id, :article, :anagen, :mode

  #validates :anagen, :uniqueness => {:scope => [:article, :mode]}

  AUTHOR   = 1
  PRINTER  = 2
  SUPPLIER = 3
  CD_OWNER = 4

  before_create :set_mode

  scope :by_author, where(:mode => AUTHOR)
  scope :by_printer, where(:mode => PRINTER)
  scope :by_supplier, where(:mode => SUPPLIER)
  scope :by_cd_owner, where(:mode => CD_OWNER)

  private
    def set_mode
      if self.mode == 0
        self.mode = if self.anagen.author? 
                      AUTHOR 
                    elsif self.anagen.stampatore? 
                      PRINTER
                    elsif self.anagen.produttore? 
                      SUPPLIER
                    else
                      CD_OWNER
                    end
      end
    end
end
