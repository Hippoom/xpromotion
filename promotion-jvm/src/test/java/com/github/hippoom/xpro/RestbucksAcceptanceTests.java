package com.github.hippoom.xpro;

import static org.hamcrest.Matchers.is;
import static org.junit.Assert.assertThat;

import org.junit.Before;
import org.junit.Test;

import com.github.hippoom.xpro.application.RestbucksApp;
import com.github.hippoom.xpro.commands.PlaceOrderCommand;
import com.github.hippoom.xpro.domain.Coupon;
import com.github.hippoom.xpro.domain.Item;
import com.github.hippoom.xpro.domain.Order;

public class RestbucksAcceptanceTests {

	private RestbucksApp app = new RestbucksApp();

	@Before
	public void register() {
		app.register("1_off_for_3_spent",
				new Coupon("return ${origin} >= ${threshold}? ${off}: 0")
						.addParam("off", 1).addParam("threshold", 3));
		app.register("1_off_for_every_3_spent", new Coupon(
				"return ${origin}/${threshold}*${off}").addParam("off", 1)
				.addParam("threshold", 3));
		app.register(
				"1_off_for_2_ordered",
				new Coupon(
						"def quantities = ${quantities}; " +
						"def prices = ${prices}; " +
						"def temp = 0; " +
						"for (int i=0;i<quantities.size;i++) { " +
						"if (${threshold} < quantities[i]) {temp += prices[i]*${off};}" +
						"}; " +
						"return temp;")
						.addParam("off", 1).addParam("threshold", 2));
	}

	@Test
	public void places_an_order_with_one_item() throws Throwable {
		final Order order = app.placeOrder(with(cappuccino(3, 1)));

		assertThat(order.cost(), is(3));
	}

	@Test
	public void places_an_order_with_double_items() throws Throwable {
		final Order order = app.placeOrder(with(cappuccino(3, 1), latte(4, 1)));

		assertThat(order.cost(), is(7));
	}

	@Test
	public void places_an_order_applying_x_off_for_y_spent() throws Throwable {
		String coupon = "1_off_for_3_spent";

		final Order order = app.placeOrder(with(coupon, cappuccino(3, 1),
				latte(4, 1)));

		assertThat(order.cost(), is(6));
	}

	@Test
	public void places_an_order_applying_x_off_for_every_y_spent()
			throws Throwable {
		String coupon = "1_off_for_every_3_spent";

		final Order order = app.placeOrder(with(coupon, cappuccino(3, 1),
				latte(4, 1)));

		assertThat(order.cost(), is(5));
	}

	@Test
	public void places_an_order_applying_x_free_for_y_ordered()
			throws Throwable {
		String coupon = "1_off_for_2_ordered";

		final Order order = app.placeOrder(with(coupon, cappuccino(3, 3),
				latte(4, 3)));

		assertThat(order.cost(), is(14));
	}

	private PlaceOrderCommand with(String coupon, Item... items) {
		return new PlaceOrderCommand(coupon, items);
	}

	private PlaceOrderCommand with(Item... items) {
		return with(null, items);
	}

	private Item cappuccino(int price, int quantity) {
		return new Item("cappuccino", "semi", "large", quantity, price);
	}

	private Item latte(int price, int quantity) {
		return new Item("latte", "semi", "large", quantity, price);
	}
}
