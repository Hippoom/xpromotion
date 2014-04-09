package com.github.hippoom.xpro.application;

import java.util.HashMap;
import java.util.Map;

import lombok.ToString;

import com.github.hippoom.xpro.commands.PlaceOrderCommand;
import com.github.hippoom.xpro.domain.Coupon;
import com.github.hippoom.xpro.domain.Order;
@ToString
public class RestbucksApp {
	private Map<String, String> templates = new HashMap<String, String>();
	private Map<String, Coupon> coupons = new HashMap<String, Coupon>();

	public Order placeOrder(PlaceOrderCommand command) {
		final Order order = new Order(command.getItems());
		if (coupons.get(command.getCoupon()) != null) {
			order.apply(coupons.get(command.getCoupon()));
		}
		return order;
	}

	public void registerCoupon(String key, Coupon value) {
		this.coupons.put(key, value);
	}

	public void registerCoupon(String key, String template, Map<String, String> params) {
		final String script = templates.get(template);
		registerCoupon(key, new Coupon(script).add(params));
	}

	public void registerTemplate(String code, String script) {
		this.templates.put(code, script);
	}

}
