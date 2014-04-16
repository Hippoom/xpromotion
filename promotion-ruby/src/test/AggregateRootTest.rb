module AggregateRoot

  attr_reader :events
  def apply event
    @events = [] if events.nil?
    events << event
  end

  def handle event
    operation = self.class.event_handlers[event.class.name.to_sym]
    instance_exec(event, &operation)
  end

  def self.included(clazz)
    clazz.class_eval do
      @event_handlers = {}

      def self.on event_clazz, &operation
        @event_handlers[event_clazz] = operation
      end

      def self.event_handlers
        @event_handlers
      end
    end
  end
end

class Coupon
  include AggregateRoot

  on :CouponApprovedEvent do |event|
    puts 'env=' + self.to_s
    puts 'event=' + event.to_s
    #TODO event not received
    @status = 'APPROVED'
  end

  on :CouponDisabledEvent do |event|
    @status = 'DISABLED'
  end

  def initialize id
    apply CouponRegisteredEvent.new(id)
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
    @ar = Coupon.new(@id)
  end

  def test_events_collected_when_aggregate_root_created
    assert_equal @ar.events, [CouponRegisteredEvent.new(@id)]
  end

  def test_reconsititute_aggregate_root
    @ar.handle(CouponApprovedEvent.new(@id))

    assert @ar.approved?

    @ar.handle(CouponDisabledEvent.new(@id))
    assert @ar.disabled?

  end
end
