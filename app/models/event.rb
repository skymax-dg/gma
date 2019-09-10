class Event < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :description, :timetable, :dressing, :duration, :quantity, :nr_item, :yr_item, :site_anagen_id, :state, :mode, :cut_off, :dt_event, :dt_end_isc, :dt_discount

  has_many :key_word_rels, as: :key_wordable
  has_many :key_words, through: :key_word_rels
  has_many :event_states
  has_many :anagens, through: :event_states
  belongs_to :site_anagen, foreign_key: :site_anagen_id, class_name: :Anagen

  belongs_to :article

  STATES = [
    ["Desiderato",1], 
    ["Confermato",2], 
    ["Svolto",3], 
    ["Annullato",4]
  ]

  #def self.tables_list
  #  list  = []
  #  list << {plural: 'Corsi',          singular: "Corso",          type: :Course,        cls: Course }
  #  list << {plural: 'Conferenze',     singular: "Conferenza",     type: :Conference,    cls: Conference }
  #  list << {plural: 'Presentazioni',  singular: "Presentazione",  type: :Presentation,  cls: Presentation }
  #  list << {plural: 'Stampe libri',   singular: "Stampa libro",   type: :BookPrint,     cls: BookPrint }
  #  list << {plural: 'Uscite riviste', singular: "Uscita rivista", type: :MagRelease,    cls: MagRelease }
  #  #list << {plural: '', singular: "" ,type: :}

  #  list.sort { |e1,e2| e1[:plural] <=> e2[:plural] }
  #end

  #def self.decode_table(cls)
  #  self.tables_list.find { |r| r[:type] == cls } || {}
  #end

  def dstate
    if self.state
      tmp = STATES.select { |x| x[1] == self.state }
      tmp.size > 0 && tmp[0][0]
    end
  end

  def has_key_word?(kw)
    self.key_words.include?(kw)
  end

  def rivista?
    kw = KeyWordEvent.where(desc: "Rivista").first
    kw ? self.has_key_word?(kw) :  []
  end

  def libro?
    kw = KeyWordEvent.where(desc: "Libri").first
    kw ? self.has_key_word?(kw) :  []
  end

  def corso?
    kw = KeyWordEvent.where(desc: "Corsi").first
    kw ? self.has_key_word?(kw) :  []
  end
  
  def self.corsi
    kw = KeyWordEvent.where(desc: "Corsi").first
    kw ? Event.joins(:key_words).where("key_words.id = ?", kw.id) : []
  end

end
