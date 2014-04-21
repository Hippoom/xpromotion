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
    
    @event_bus = EventBus.new
    @command_bus = CommandBus.new
    @event_store = EventStore.new
    @repository = EventSourcingRepository.new
    @repository.aggregate_root_type= aggregate_root_type
    @repository.event_bus= @event_bus
    @repository.event_store= @event_store
    
    handler = anomynous_aggregate_root_handler
    handler.command_types.each do |command_type|
      @command_bus.register_handler(command_type, handler)  
    end
  end

  def anomynous_aggregate_root_handler
    handler = Object.new
    class <<handler
      include CommandHandling::AnonymousAggregateRootCommandHandler
      
      def command_types
        repository.aggregate_root_type.command_types
      end
    end
    handler.repository=@repository
    handler
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
