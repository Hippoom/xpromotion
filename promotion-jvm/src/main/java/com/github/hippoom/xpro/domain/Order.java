package com.github.hippoom.xpro.domain;

import java.util.List;

public class Order {

	private List<Item> items;

	public Order(List<Item> items) {
		this.items = items;
	}

	public double cost() {
		double cost = 0;
		for (Item item : items) {
			cost += item.price();
		}
		return cost;
	}

}
