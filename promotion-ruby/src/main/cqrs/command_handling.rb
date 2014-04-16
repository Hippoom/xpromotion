class CommandBus
  def initialize
    @command_handlers = {}
  end

  def register command_type, repository
    handler = Object.new
    class <<handler
      attr_accessor :repository

      def handle_command command
        ar = repository.class.aggregate_root.register(command)
        repository.add ar
      end
    end
    handler.repository=repository
    @command_handlers[command_type] = handler
  end

  def dispatch command
    @command_handlers[command.class].send(:handle_command, command)
  end
end
