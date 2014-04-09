require 'promotion/Item'

class PlaceOrderCommand
  
  def initialize items
    @items = items
  end
  
  def self.one_item args
    item = Item.new(args)
    return PlaceOrderCommand.new [item]
  end
  
  def items
    return @items
  end
  
end