class KeyWordEvent < KeyWord
  # attr_accessible :title, :body
  
  def self.type_event_root
    KeyWordEvent.where(desc: "Tipo evento").first
  end

  def self.type_event_course
    r = self.type_event_root
    r.childs.where(desc: "Corsi").first
  end

  def self.type_event_book
    r = self.type_event_root
    r.childs.where(desc: "Libri").first
  end

  def self.type_event_magazine
    r = self.type_event_root
    r.childs.where(desc: "Rivista").first
  end

end
