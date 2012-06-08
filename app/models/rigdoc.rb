class Rigdoc < ActiveRecord::Base
  belongs_to :article
  belongs_to :tesdoc

  default_scope :order => 'rigdocs.prgrig ASC'
  
  attr_accessible :descriz, :prezzo, :qta, :sconto, :article_id, :tesdoc_id, :prgrig
  validates :descriz, :length => { :maximum => 150}

  def move(dir)
    # sposta su/giu la riga documento (tramite il campo prgrig)
    
    oldprg = self.prgrig
    tesdoc = Tesdoc.find(self.tesdoc_id)
    oldidx = tesdoc.rigdocs.index(self)
    near_rigdoc = tesdoc.rigdocs[oldidx - 1] if dir == :up and oldidx != 0 
    # test oldidx <> 0 perchè diventando poi -1, la prima riga diventerebbe l'ultima
    near_rigdoc = tesdoc.rigdocs[oldidx + 1] if dir == :down
    return 0 if near_rigdoc.nil?
    self.update_attributes(:prgrig => 0)
    newprg = near_rigdoc.prgrig
    near_rigdoc.update_attributes(:prgrig => oldprg)
    self.update_attributes(:prgrig => newprg)
    return 1
  end
end
