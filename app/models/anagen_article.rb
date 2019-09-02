class AnagenArticle < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :anagen
  belongs_to :article

  #validates :anagen, :uniqueness => {:scope => [:article, :mode]}

  AUTHOR  = 1
  PRINTER = 2

  before_create :set_mode

  scope :by_author, where(:mode => AUTHOR)
  scope :by_printer, where(:mode => PRINTER)

  private
    def set_mode
      self.mode = self.anagen.author? ? AUTHOR : PRINTER
    end
end
