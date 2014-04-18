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
        handler.send(:handle_event, event)
      end
    end
  end
end

module EventHandling
  module Dsl
    module InstanceMethods
      
      def handle_event event
        handler = event_handler_for event
        instance_exec(event, &handler)#shift context as instance variables in blocks are bounded with class
      end

      def event_handler_for event
        self.class.send(:event_handler_for, event)
      end

      private  :handle_event, :event_handler_for
    end

    module ClassMethods
      def on(event_type, &handler)
        @event_handlers[event_type] = handler
      end

      def event_handler_for event
        @event_handlers[event.class]
      end

      private :on, :event_handler_for
    end

    def self.included(clazz)

      clazz.class_eval do
        include InstanceMethods
        extend ClassMethods
        @event_handlers = {}#init empty Hash for ClassMethods
      end

    end
  end
end