class EventBus
  def initialize
    @event_handlers = {}
  end

  def register event_type, handler
    @event_handlers[event_type] = [] if @event_handlers[event_type].nil?
    @event_handlers[event_type] << handler
  end

  def publish events
    events.each do |event|
      @event_handlers[event.class].each do |handler|
        handler.send(:handle, event)
      end
    end
  end
end

module EventHandling
  module Dsl
    
    def handle event
      handler = self.class.event_handler event
      instance_exec(event, &handler)#shift context
    end

    private  :handle

    def self.included(clazz)
      clazz.class_eval do
        @event_handlers = {}

        def self.on(event_clazz, &handler)
          @event_handlers[event_clazz] = handler
        end

        def self.event_handler event
          @event_handlers[event.class.name.to_sym]
        end
      end
    end
  end
end