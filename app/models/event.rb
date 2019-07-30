class Event < ActiveRecord::Base
  # attr_accessible :title, :body

  def self.tables_list
    list  = []
    list << {plural: 'Corsi',         singular: "Corso",         type: :Course,       cls: Course }
    list << {plural: 'Conferenze',    singular: "Conferenza",    type: :Conference,   cls: Conference }
    list << {plural: 'Presentazioni', singular: "Presentazione", type: :Presentation, cls: Presentation }
    #list << {plural: '', singular: "" ,type: :}

    list.sort { |e1,e2| e1[:plural] <=> e2[:plural] }
  end

  def self.decode_table(cls)
    self.tables_list.find { |r| r[:type] == cls } || {}
  end
end
