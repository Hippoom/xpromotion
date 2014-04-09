require 'minitest/autorun'
require 'promotion/RestbucksApp'
require 'promotion/Order'
require 'promotion/PlaceOrderCommand'
require 'promotion/Coupon'

class AcceptanceTest < MiniTest::Unit::TestCase
  def setup
    @app = RestbucksApp.new
    @app.register_coupon('1_off_for_3_spent', 'origin >= params[:threshold]? params[:off] : 0', {:threshold=>3, :off=>1})
      
    puts 'Test start:'
  end

  def test_place_order_without_coupon

    order = @app.place_order(PlaceOrderCommand::one_item(:drink=>'latte', :quantity=>1, :price=>3))

    assert_equal 3, order.cost
  end

  def test_place_order_with_coupon_1_off_for_3_spent_but_not_satisfied
    command = PlaceOrderCommand::one_item_with_coupon '1_off_for_3_spent', :drink=>'cappucino', :quantity=>1, :price=>2

    order = @app.place_order(command)

    assert_equal 2, order.cost
  end

  def test_place_order_with_coupon_1_off_for_3_spent
    command = PlaceOrderCommand::one_item_with_coupon '1_off_for_3_spent', :drink=>'cappucino', :quantity=>1, :price=>4

    order = @app.place_order(command)

    assert_equal 3, order.cost
  end

end