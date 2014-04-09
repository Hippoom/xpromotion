class RestbucksApp
  
  def place_order command
    Order.new command.items
  end
  
end