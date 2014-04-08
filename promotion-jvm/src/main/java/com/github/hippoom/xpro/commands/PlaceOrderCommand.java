package com.github.hippoom.xpro.commands;

import java.util.Arrays;
import java.util.List;

import com.github.hippoom.xpro.domain.Item;

public class PlaceOrderCommand {
	private List<Item> items;

	public PlaceOrderCommand(Item... items) {
		this.items = Arrays.asList(items);
	}

	public List<Item> getItems() {
		return items;
	}

}
