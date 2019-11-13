class AnagenArticle < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :anagen
  belongs_to :article

  #validates :anagen, :uniqueness => {:scope => [:article, :mode]}

  AUTHOR   = 1
  PRINTER  = 2
  SUPPLIER = 3

  before_create :set_mode

  scope :by_author, where(:mode => AUTHOR)
  scope :by_printer, where(:mode => PRINTER)
  scope :by_supplier, where(:mode => SUPPLIER)

  private
    def set_mode
      self.mode = if self.anagen.author? 
                    AUTHOR 
                  elsif self.anagen.stampatore? 
                    PRINTER
                  elsif self.anagen.produttore? 
                    SUPPLIER
                  end
    end
end
