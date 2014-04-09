require 'minitest/autorun'
require 'promotion/RestbucksApp'
require 'promotion/Order'
require 'promotion/PlaceOrderCommand'

class AcceptanceTest < MiniTest::Unit::TestCase
  def setup
    @app = RestbucksApp.new
  end

  def test_place_order_without_coupon

    order = @app.place_order(PlaceOrderCommand::one_item(:drink=>'latte', :quantity=>1, :price=>3))

    assert_equal 3, order.cost
  end

  def test_place_order_with_coupon_1_off_for_3_spent
    command = PlaceOrderCommand::one_item(:drink=>'cappucino', :quantity=>1, :price=>4)

    order = @app.place_order(command)

    assert_equal 4, order.cost
  end

end