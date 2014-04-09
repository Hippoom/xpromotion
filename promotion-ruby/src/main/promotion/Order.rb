class Order
  def initialize items
    @items = items
  end

  def cost
    sum = 0
    @items.each {|item|
       sum += item.subtotal 
    }
    return sum
  end
end