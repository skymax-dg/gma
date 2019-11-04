class Rigdoc < ActiveRecord::Base
  belongs_to :article
  belongs_to :tesdoc
  belongs_to :iva

  default_scope :order => 'rigdocs.prgrig ASC'
  
  attr_accessible :descriz, :prezzo, :qta, :sconto, :article_id, :tesdoc_id, :prgrig, :iva_id
  validates :prezzo, :sconto, :qta, :presence => true
  validates :descriz, :length => { :maximum => 150}

  def move(dir)
    # sposta su/giu la riga documento (tramite il campo prgrig)
    
    oldprg = self.prgrig
    tesdoc = Tesdoc.find(self.tesdoc_id)
    oldidx = tesdoc.rigdocs.index(self)
    near_rigdoc = tesdoc.rigdocs[oldidx - 1] if dir == :up and oldidx != 0 
    # test oldidx <> 0 perche' diventando poi -1, la prima riga diventerebbe l'ultima
    near_rigdoc = tesdoc.rigdocs[oldidx + 1] if dir == :down
    return 0 if near_rigdoc.nil?
    self.update_attributes(:prgrig => 0)
    newprg = near_rigdoc.prgrig
    near_rigdoc.update_attributes(:prgrig => oldprg)
    self.update_attributes(:prgrig => newprg)
    return 1
  end

  def impon
#    self.qta * self.prezzo
    self.qta != 0 && self.prezzo != 0 ? self.qta*(self.prezzo*(100-self.sconto)/100) : 0
  end

  def prezzo_vendita
    return 0.0 unless self.iva
    (1+self.iva.aliq/100) * (self.prezzo*(100-self.sconto)/100)
  end

  def imp_list
    self.article&&self.article.prezzo != 0&&self.qta != 0 ? self.qta * self.article.prezzo : 0
  end

  def imposta
    self.iva.aliq > 0 && self.impon  !=  0 ? self.impon*self.iva.aliq/100 : 0;
  end

  def map_json
    st = Struct.new(:id, :descriz, :qta, :prezzo, :sconto, :prezzo_finale)
    st.new(self.id, self.descriz, self.qta, self.prezzo_vendita, self.sconto, self.qta*self.prezzo)
  end
end
