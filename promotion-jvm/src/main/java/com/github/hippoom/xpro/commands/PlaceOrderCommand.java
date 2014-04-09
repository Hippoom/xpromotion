package com.github.hippoom.xpro.commands;

import java.util.Arrays;
import java.util.List;

import com.github.hippoom.xpro.domain.Item;

public class PlaceOrderCommand {
	private String coupon;
	private List<Item> items;

	public PlaceOrderCommand(String coupon, Item... items) {
		this.coupon = coupon;
		this.items = Arrays.asList(items);
	}

	public PlaceOrderCommand(String coupon, List<Item> items) {
		this.coupon = coupon;
		this.items = items;
	}

	public List<Item> getItems() {
		return items;
	}

	public String getCoupon() {
		return coupon;
	}

}
