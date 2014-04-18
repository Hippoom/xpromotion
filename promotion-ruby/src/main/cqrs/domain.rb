module AggregateRoot
  def initialize
    @events = []
  end

  attr_reader :events

  def apply event
    events << event
  end

  def commit
    @events = []
  end

  private :apply, :commit

  def self.included(clazz)

    clazz.class_eval do
      def self.create_on event
        self.new.tap do |aggregate|
          aggregate.send(:apply, event)#apply is private
        end
      end
    end
  end
end

class Repository
  attr_accessor :aggregate_root_type
  attr_accessor :event_bus
  attr_writer :event_store
  
  def load id
    ar = aggregate_root_type.new
    @event_store.read_events(aggregate_root_type, id).each do |event|
      ar.send(:handle_event, event)
    end
    return ar
  end

  def add aggregate_root
    event_bus.publish(aggregate_root.events)
    aggregate_root.send(:commit)
  end

  def store aggregate_root
    add aggregate_root
  end

end