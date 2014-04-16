module AggregateRoot

  attr_reader :events
  def apply event
    @events = [] if events.nil?
    events << event
  end

  def handle event
    handler = self.class.event_handler event
    instance_exec(event, &handler)
  end

  def self.included(clazz)

    clazz.class_eval do
      @event_handlers = {}

      def self.create_from event
        self.new.tap do |aggregate|
          aggregate.apply event
        end
      end

      def self.on event_clazz, &handler
        @event_handlers[event_clazz] = handler
      end

      def self.event_handler event
        @event_handlers[event.class.name.to_sym]
      end
    end
  end
end

class Coupon
  include AggregateRoot

  on :CouponRegisteredEvent do |event|
    @id = event.id
  end

  on :CouponApprovedEvent do |event|
    @status = 'APPROVED'
  end

  on :CouponDisabledEvent do |event|
    @status = 'DISABLED'
  end

  attr_reader :id

  def self.register id
    create_from CouponRegisteredEvent.new(id)
  end

  def approved?
    @status == 'APPROVED'
  end

  def disabled?
    @status == 'DISABLED'
  end

end

class CouponRegisteredEvent
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

class CouponApprovedEvent
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

class CouponDisabledEvent
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

require 'minitest/autorun'

class CouponTest < MiniTest::Unit::TestCase
  def setup
    @id = 1
  end

  def test_events_collected_when_aggregate_root_created
    ar = Coupon.register(@id)

    assert_equal ar.events, [CouponRegisteredEvent.new(@id)]
  end

  def test_reconsititute_aggregate_root
    ar = Coupon.new

    ar.handle(CouponRegisteredEvent.new(@id))
    assert_equal @id, ar.id

    ar.handle(CouponApprovedEvent.new(@id))
    assert ar.approved?

    ar.handle(CouponDisabledEvent.new(@id))
    assert ar.disabled?

  end
end
