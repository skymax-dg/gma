class EventState < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :mode, :anagen_id, :anagen, :event_id, :event

  belongs_to :anagen
  belongs_to :event

  validates :anagen_id, :uniqueness => {:scope => :event_id}

  SHIPMENT   = 1
  TEACHER    = 2
  ORGANIZER  = 3
  SUBSCRIBER = 4

  scope :by_shipments,   where(:mode => SHIPMENT )
  scope :by_teachers,    where(:mode => TEACHER )
  scope :by_organizers,  where(:mode => ORGANIZER )
  scope :by_subscribers, where(:mode => SUBSCRIBER )

  scope :by_anagen, lambda { |id| where(anagen_id: id) }
end
