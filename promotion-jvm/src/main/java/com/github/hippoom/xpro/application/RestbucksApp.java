package com.github.hippoom.xpro.application;

import java.util.HashMap;
import java.util.Map;

import com.github.hippoom.xpro.commands.PlaceOrderCommand;
import com.github.hippoom.xpro.domain.Coupon;
import com.github.hippoom.xpro.domain.Order;

public class RestbucksApp {

	private Map<String, Coupon> coupons = new HashMap<String, Coupon>();

	public Order placeOrder(PlaceOrderCommand command) {
		final Order order = new Order(command.getItems());
		if (coupons.get(command.getCoupon()) != null) {
			order.apply(coupons.get(command.getCoupon()));
		}
		return order;
	}

	public void register(String key, Coupon value) {
		this.coupons.put(key, value);
	}

}
