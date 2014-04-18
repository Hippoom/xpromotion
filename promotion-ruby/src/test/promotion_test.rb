require 'cqrs/command_handling'
require 'cqrs/domain'
require 'cqrs/event_handling'
require 'cqrs/event_store'
require 'promotion/events'
require 'promotion/commands'
require 'promotion/domain'
require 'minitest/autorun'

class Fixture < MiniTest::Unit::TestCase
  def initialize aggregate_root_type
    @aggregate_root_type = aggregate_root_type
    @event_bus = EventBus.new
    @command_bus = CommandBus.new
    @event_store = EventStore.new
    @repository = Repository.new
    @repository.aggregate_root_type= aggregate_root_type
    @repository.event_bus= @event_bus
    @repository.event_store= @event_store
  end

  def register_anomynous_handler_for command_type
    handler = Object.new
    class <<handler
      attr_accessor :repository
      def handle_command command
        handle_exists command if command.respond_to?(:identity)
        create_new command unless command.respond_to?(:identity)
      end

      def create_new command
        ar = repository.aggregate_root_type.create_from(command)
        repository.add ar
      end

      def handle_exists command
        ar  = repository.load(command.identity)
        ar.send(:handle_command,command)
        repository.store ar
      end
    end
    handler.repository=@repository
    @command_bus.register_handler(command_type, handler)
  end

  def _when command
    @command_bus.dispatch(command)
  end

  def _given *events
    @event_store.append_events(@aggregate_root_type, events)
  end

  def _then_expect_events *events
    assert_equal events, @event_bus.received
  end
end

class PromotionTest < MiniTest::Unit::TestCase
  def setup
    @id = 1
    @fixture = Fixture.new XPromotion::Domain::Promotion
    @fixture.register_anomynous_handler_for XPromotion::Commands::RegisterPromotionCommand
    @fixture.register_anomynous_handler_for XPromotion::Commands::ApprovePromotionCommand
    @fixture.register_anomynous_handler_for XPromotion::Commands::DisablePromotionCommand
  end

  def test_aggregate_root_created

    @fixture._when(XPromotion::Commands::RegisterPromotionCommand.new(@id))

    @fixture._then_expect_events XPromotion::Events::PromotionRegisteredEvent.new(@id)
  end

  def test_approve_promotion
    @fixture._given XPromotion::Events::PromotionRegisteredEvent.new(@id)

    @fixture._when XPromotion::Commands::ApprovePromotionCommand.new(@id)

    @fixture._then_expect_events XPromotion::Events::PromotionApprovedEvent.new(@id)
  end

  def test_disable_promotion
    @fixture._given(XPromotion::Events::PromotionRegisteredEvent.new(@id), XPromotion::Events::PromotionApprovedEvent.new(@id))

    @fixture._when XPromotion::Commands::DisablePromotionCommand.new(@id)

    @fixture._then_expect_events XPromotion::Events::PromotionDisabledEvent.new(@id)
  end

end
