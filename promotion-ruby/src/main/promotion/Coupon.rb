class Coupon
  def initialize(script, params)
    @script = script
    @params = params
  end

  def apply_to order
    origin = order.origin
    params = @params;
    puts 'script:' + @script
    applied = eval @script
    puts 'applied:' + applied.to_s
    return applied
  end
end