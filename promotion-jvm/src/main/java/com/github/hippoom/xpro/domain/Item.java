package com.github.hippoom.xpro.domain;

public class Item {
	private String drink;
	private String milk;
	private String size;
	private double price;

	public Item(String drink, String milk, String size, double price) {
		this.drink = drink;
		this.milk = milk;
		this.size = size;
		this.price = price;
	}

	public double price() {
		return price;
	}

}
