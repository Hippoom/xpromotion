class Order
  def initialize items
    @items = items
  end

  def cost
    return origin - (@applied || 0)
  end

  def origin
    sum = 0
    @items.each {|item|
      sum += item.subtotal
    }
    return sum
  end

  def apply coupon
    @applied = coupon.apply_to self unless coupon.nil?
  end
end