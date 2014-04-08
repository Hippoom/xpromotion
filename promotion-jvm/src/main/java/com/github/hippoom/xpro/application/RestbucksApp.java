package com.github.hippoom.xpro.application;

import com.github.hippoom.xpro.commands.PlaceOrderCommand;
import com.github.hippoom.xpro.domain.Order;

public class RestbucksApp {

	public Order placeOrder(PlaceOrderCommand command) {
		final Order order = new Order(command.getItems());
		return order;
	}

}
