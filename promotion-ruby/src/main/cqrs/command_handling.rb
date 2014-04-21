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
  module AnonymousAggregateRootCommand
    def self.included(clazz)
      clazz.class_eval do
        def self.target_aggregate_root_identity symbol
          attr_reader symbol

          define_method:target_aggregate_root_identity do
            send(symbol)
          end
        end
      end
    end
  end

  module AnonymousAggregateRootCommandHandler
    def self.included(clazz)
      clazz.class_eval do
        include CommandHandler
        def self.from(command_type, &handler)
          handle(command_type, &handler)
        end

        define_singleton_method :create_from do |command|
          ar = clazz.new
          ar.send(:handle_command, command)
          ar
        end
      end
    end
  end

  module CommandHandler
    def self.included(clazz)
      clazz.class_eval do
        @command_handlers = {}

        extend ClassMethods
        include InstanceMethods
      end
    end

    module ClassMethods
      def command_handler_for command
        @command_handlers[command.class]
      end

      def handle(command_type, &handler)
        @command_handlers[command_type] = handler
      end

      private :handle, :command_handler_for
    end

    module InstanceMethods
      def handle_command command
        handler = command_handler_for command
        instance_exec(command, &handler)
      end

      def command_handler_for command
        self.class.send(:command_handler_for, command)
      end

      private :handle_command, :command_handler_for
    end
  end
end
