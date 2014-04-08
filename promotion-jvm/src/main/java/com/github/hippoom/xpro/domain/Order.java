package com.github.hippoom.xpro.domain;

import java.util.List;

public class Order {
	private int discount;
	private List<Item> items;

	public Order(List<Item> items) {
		this.items = items;
	}

	public int cost() {
		return origin() - discount;
	}

	public int origin() {
		int cost = 0;
		for (Item item : items) {
			cost += item.subtotal();
		}
		return cost;
	}

	public void apply(Coupon coupon) {
		coupon.applyTo(this);
	}

	public void apply(int applied) {
		this.discount = applied;
	}

	public List<Item> items() {
		return items;
	}
}
