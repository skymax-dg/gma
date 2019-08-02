class Event < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :type, :desc

  has_many :key_word_rels, as: :key_wordable

  belongs_to :article


  def self.tables_list
    list  = []
    list << {plural: 'Corsi',          singular: "Corso",          type: :Course,        cls: Course }
    list << {plural: 'Conferenze',     singular: "Conferenza",     type: :Conference,    cls: Conference }
    list << {plural: 'Presentazioni',  singular: "Presentazione",  type: :Presentation,  cls: Presentation }
    list << {plural: 'Stampe libri',   singular: "Stampa libro",   type: :BookPrint,     cls: BookPrint }
    list << {plural: 'Uscite riviste', singular: "Uscita rivista", type: :MagRelease,    cls: MagRelease }
    #list << {plural: '', singular: "" ,type: :}

    list.sort { |e1,e2| e1[:plural] <=> e2[:plural] }
  end

  def self.decode_table(cls)
    self.tables_list.find { |r| r[:type] == cls } || {}
  end
end
