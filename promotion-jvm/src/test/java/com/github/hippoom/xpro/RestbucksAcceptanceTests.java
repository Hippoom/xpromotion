package com.github.hippoom.xpro;

import static org.hamcrest.Matchers.is;
import static org.junit.Assert.assertThat;

import org.junit.Test;

import com.github.hippoom.xpro.application.RestbucksApp;
import com.github.hippoom.xpro.commands.PlaceOrderCommand;
import com.github.hippoom.xpro.domain.Item;
import com.github.hippoom.xpro.domain.Order;

public class RestbucksAcceptanceTests {

	private RestbucksApp app = new RestbucksApp();

	@Test
	public void places_an_order_with_one_item() throws Throwable {
		final Order order = app.placeOrder(with(oneItemCost(3)));

		assertThat(order.cost(), is(3.0));
	}

	@Test
	public void places_an_order_with_double_items() throws Throwable {
		final Order order = app
				.placeOrder(with(oneItemCost(3), oneItemCost(4)));

		assertThat(order.cost(), is(7.0));
	}

	private PlaceOrderCommand with(Item... items) {
		return new PlaceOrderCommand(items);
	}

	private Item oneItemCost(double price) {
		return new Item("cappuccino", "semi", "large", price);
	}
}
