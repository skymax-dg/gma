class AnagenArticle < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :anagen
  belongs_to :article

  before_create :set_mode

 scope :by_author, where(:mode => 1)
 scope :by_printer, where(:mode => 2)

  MODE = [["Autore",1], ["Stampatore",2]]

  private
    def set_mode
      self.mode = self.anagen.author? ? 1 : 2
    end
end
