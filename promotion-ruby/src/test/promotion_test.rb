require 'cqrs/domain.rb'

class Promotion
  include AggregateRoot

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

require 'minitest/autorun'

class PromotionTest < MiniTest::Unit::TestCase
  def setup
    @id = 1
  end

  def test_events_collected_when_aggregate_root_created
    ar = Promotion.register(@id)

    assert_equal ar.events, [PromotionRegisteredEvent.new(@id)]
  end

  def test_reconsititute_aggregate_root
    ar = Promotion.new

    ar.send(:handle, PromotionRegisteredEvent.new(@id))
    assert_equal @id, ar.id

    ar.send(:handle, PromotionApprovedEvent.new(@id))
    assert ar.approved?

    ar.send(:handle, PromotionDisabledEvent.new(@id))
    assert ar.disabled?

  end
end
