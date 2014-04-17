require 'cqrs/command_handling'
require 'cqrs/domain.rb'
require 'cqrs/event_handling.rb'
require 'promotion/events.rb'
require 'promotion/commands.rb'
require 'promotion/domain.rb'
require 'minitest/autorun'

class EventHandlerStub
  include EventHandling::Dsl

  attr_reader :received
  def initialize
    @received= []
  end

  on XPromotion::Events::PromotionRegisteredEvent do |event|
    received <<  event
  end

  on XPromotion::Events::PromotionApprovedEvent do |event|
    received <<  event
  end

  on XPromotion::Events::PromotionDisabledEvent do |event|
    received <<  event
  end
end

class PromotionTest < MiniTest::Unit::TestCase
  def setup
    @id = 1
    @event_handler_stub = EventHandlerStub.new
    @event_bus = EventBus.new
    @event_bus.register(XPromotion::Events::PromotionRegisteredEvent, @event_handler_stub)
    @event_bus.register(XPromotion::Events::PromotionApprovedEvent, @event_handler_stub)
    @event_bus.register(XPromotion::Events::PromotionDisabledEvent, @event_handler_stub)

    @repo = XPromotion::Domain::PromotionRepository.new
    @repo.event_bus= @event_bus

    @command_bus = CommandBus.new

    @command_bus.register(XPromotion::Commands::RegisterPromotionCommand, @repo)
    @command_bus.register(XPromotion::Commands::ApprovePromotionCommand, @repo)
    @command_bus.register(XPromotion::Commands::DisablePromotionCommand, @repo)
  end

  def test_aggregate_root_created

    @command_bus.dispatch(XPromotion::Commands::RegisterPromotionCommand.new(@id))

    assert_equal [XPromotion::Events::PromotionRegisteredEvent.new(@id)], @event_handler_stub.received
  end

  def test_approve_promotion
    events = {@id=> [XPromotion::Events::PromotionRegisteredEvent.new(@id)]}

    class <<@repo
      def events id
        @events[id]
      end

      def inject events
        @events = events
      end
    end

    @repo.inject(events)

    @repo.instance_eval do
      puts @events
    end

    command = XPromotion::Commands::ApprovePromotionCommand.new(@id)

    @command_bus.dispatch(command)

    assert_equal [XPromotion::Events::PromotionApprovedEvent.new(@id)], @event_handler_stub.received
  end

  def test_disable_promotion
    events = {@id=> [XPromotion::Events::PromotionRegisteredEvent.new(@id), XPromotion::Events::PromotionApprovedEvent.new(@id)]}

    class <<@repo
      def events id
        @events[id]
      end

      def inject events
        @events = events
      end
    end

    @repo.inject(events)

    @repo.instance_eval do
      puts @events
    end

    command = XPromotion::Commands::DisablePromotionCommand.new(@id)

    @command_bus.dispatch(command)

    assert_equal [XPromotion::Events::PromotionDisabledEvent.new(@id)], @event_handler_stub.received
  end

end
