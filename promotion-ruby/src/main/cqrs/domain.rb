module AggregateRoot

  attr_reader :events
  
  def apply event
    @events = [] if events.nil?
    events << event
  end

  def handle event
    handler = self.class.event_handler event
    instance_exec(event, &handler)
  end

  private :apply, :handle

  def self.included(clazz)

    clazz.class_eval do
      @event_handlers = {}

      def self.create_from event
        self.new.tap do |aggregate|
          aggregate.send(:apply, event)#apply is private
        end
      end

      def self.on(event_clazz, &handler)
        @event_handlers[event_clazz] = handler
      end

      def self.event_handler event
        @event_handlers[event.class.name.to_sym]
      end
    end
  end
end