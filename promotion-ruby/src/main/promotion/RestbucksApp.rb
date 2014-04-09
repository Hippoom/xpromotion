class RestbucksApp
  
  def initialize
    @coupons = {}
  end
  
  def place_order command
    order = Order.new command.items
    order.apply(@coupons[command.coupon])
    return order
  end
  
  def register_coupon(code, script, params)
    @coupons[code] = Coupon.new(script, params)
  end
end