require 'promotion/Item'

class PlaceOrderCommand
  def initialize coupon, items
    @coupon = coupon
    @items = items
  end

  def self.one_item args
    item = Item.new(args)
    return PlaceOrderCommand.new(nil, [item])
  end

  def self.one_item_with_coupon coupon, args
    item = Item.new(args)
    return PlaceOrderCommand.new(coupon, [item])
  end

  def items
    return @items
  end

  def coupon
    return @coupon
  end

end