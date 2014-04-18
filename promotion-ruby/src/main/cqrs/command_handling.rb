class CommandBus
  def initialize
    @command_handlers = {}
  end

  def register_handler(command_type, handler)
    @command_handlers[command_type] = handler
  end

  def dispatch command
    @command_handlers[command.class].send(:handle_command, command)
  end
end

module CommandHandling
  module Dsl
    def self.included(clazz)
      clazz.class_eval do
        include InstanceMethods
        def self.identity symbol
          attr_reader symbol

          define_method:identity do
            return send(symbol)
          end
        end

        def self.command_handler_for command_type
          @command_handlers[command_type]
        end

        def self.handle(command_type, &handler)
          @command_handlers = {} if @command_handlers.nil?
          @command_handlers[command_type] = handler
        end

        def self.from(command_type, &handler)
          @command_handlers = {} if @command_handlers.nil?
          @command_handlers[command_type] = handler
        end

        define_singleton_method :create_from do |command|
          handler = command_handler_for(command.class)
          ar = clazz.new
          ar.instance_exec(command, &handler)
          ar
        end
      end
    end

    module InstanceMethods
      def handle_command command
        handler = command_handler_for command
        instance_exec(command, &handler)
      end

      def command_handler_for command
        self.class.send(:command_handler_for, command.class)
      end

      private :handle_command, :command_handler_for
    end
  end
end
