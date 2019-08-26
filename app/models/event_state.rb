class EventState < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :anagens
  belongs_to :event
end
