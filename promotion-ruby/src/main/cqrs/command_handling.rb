class CommandBus
  def initialize
    @command_handlers = {}
  end

  def register command_type, repository
    handler = Object.new
    class <<handler
      attr_accessor :repository
      def handle_command command
        handle_exists command if command.respond_to?(:identity)
        create_new command unless command.respond_to?(:identity)
      end

      def create_new command
        ar = repository.class.aggregate_root.create_from(command)
        repository.add ar
      end

      def handle_exists command
        ar  = repository.load(command.identity)
        ar.send(:handle_command,command)
        repository.store ar
      end
    end
    handler.repository=repository
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
        def self.identity symbol
          attr_reader symbol

          define_method:identity do
            return send(symbol)
          end
        end

        def self.command_handler command_type
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
          handler = command_handler(command.class)
          ar = clazz.new
          ar.instance_exec(command, &handler)
          ar
        end
      end
    end

    def handle_command(command)
      handler = self.class.command_handler(command.class)
      instance_exec(command, &handler)
    end

    private :handle_command
  end
end
