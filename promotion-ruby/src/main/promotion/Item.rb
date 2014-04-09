class Item
  def initialize args
    @drink = args[:drink]
    @quantity = args[:quantity]
    @price = args[:price]
  end
  
  def subtotal
    return @price * @quantity
  end
end