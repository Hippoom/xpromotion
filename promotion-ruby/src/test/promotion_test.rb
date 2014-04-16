require 'cqrs/domain.rb'
require 'cqrs/event_handling.rb'

class Promotion
  include AggregateRoot
  include EventHandling::Dsl

  on :PromotionRegisteredEvent do |event|
    @id = event.id
  end

  on :PromotionApprovedEvent do |event|
    @status = 'APPROVED'
  end

  on :PromotionDisabledEvent do |event|
    @status = 'DISABLED'
  end

  attr_reader :id

  def self.register id
    create_from PromotionRegisteredEvent.new(id)
  end

  def approved?
    @status == 'APPROVED'
  end

  def disabled?
    @status == 'DISABLED'
  end

end

class PromotionRegisteredEvent
  attr_reader :id
  def initialize id
    @id = id
  end

  def ==(o)
    o.class == self.class && o.id == @id
  end

  def hash
    @id.hash
  end
end

class PromotionApprovedEvent
  attr_reader :id
  def initialize id
    @id = id
  end

  def ==(o)
    o.class == self.class && o.id == @id
  end

  def hash
    @id.hash
  end
end

class PromotionDisabledEvent
  attr_reader :id
  def initialize id
    @id = id
  end

  def ==(o)
    o.class == self.class && o.id == @id
  end

  def hash
    @id.hash
  end
end

class PromotionRepository
  include Repository

  self.aggregate_root= Promotion

end

class EventHandlerStub
  include EventHandling::Dsl
  
  attr_reader :received
  
  def initialize
    @received= []
  end

  on :PromotionRegisteredEvent do |event|
    received <<  event
  end
end

require 'minitest/autorun'
require 'cqrs/event_handling'

class PromotionTest < MiniTest::Unit::TestCase
  def setup
    @id = 1
    @event_handler_stub = EventHandlerStub.new
    @event_bus = EventBus.new
    @event_bus.register(PromotionRegisteredEvent, @event_handler_stub)
    @event_bus.register(PromotionApprovedEvent, @event_handler_stub)
    @event_bus.register(PromotionDisabledEvent, @event_handler_stub)
  end

  def test_events_collected_when_aggregate_root_created
    ar = Promotion.register(@id)

    repo = PromotionRepository.new
    repo.event_bus= @event_bus

    repo.add ar

    assert_equal ar.events, []
    assert_equal [PromotionRegisteredEvent.new(@id)], @event_handler_stub.received
  end

  def test_reconsititute_aggregate_root
    events = {@id=> [PromotionRegisteredEvent.new(@id), PromotionApprovedEvent.new(@id), PromotionDisabledEvent.new(@id)]}

    repo = PromotionRepository.new

    class <<repo
      def events id
        @events[id]
      end

      def inject events
        @events = events
      end
    end

    repo.inject(events)

    ar = repo.load(@id)

    assert_equal @id, ar.id
    assert ar.disabled?
  end

end
