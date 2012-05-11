class Rigdoc < ActiveRecord::Base
  belongs_to :article
  belongs_to :tesdoc

  #scope :order, :qta
  default_scope :order => 'rigdocs.prgrig ASC'
  
  attr_accessible :descriz, :prezzo, :qta, :sconto, :article_id, :tesdoc_id, :prgrig
  
  def move(dir)
    oldprg = self.prgrig
tesdoc = Tesdoc.find(self.tesdoc_id)
oldidx = tesdoc.rigdocs.index(self)
near_rigdoc = tesdoc.rigdocs[oldidx - 1] if dir == :up and oldidx != 0 
  # testo oldidx <> 0 perch� diventando poi -1, la prima riga diventerebbe l'ultima
near_rigdoc = tesdoc.rigdocs[oldidx + 1] if dir == :down
    #near_rigdoc = Rigdoc.find_by_tesdoc_id_and_prgrig(self.tesdoc_id, oldprg - 1) if dir == :up 
    #near_rigdoc = Rigdoc.find_by_tesdoc_id_and_prgrig(self.tesdoc_id, oldprg + 1) if dir == :down
    return 0 if near_rigdoc.nil?
    self.update_attributes(:prgrig => 0)
    newprg = near_rigdoc.prgrig
    near_rigdoc.update_attributes(:prgrig => oldprg)
    self.update_attributes(:prgrig => newprg)
    return 1
  end
  
end
