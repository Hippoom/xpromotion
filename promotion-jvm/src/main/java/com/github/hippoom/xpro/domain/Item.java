package com.github.hippoom.xpro.domain;

public class Item {
	private String drink;
	private String milk;
	private String size;
	private int quantity;
	private int price;

	public Item(String drink, String milk, String size, int quantity, int price) {
		this.drink = drink;
		this.milk = milk;
		this.size = size;
		this.quantity = quantity;
		this.price = price;
	}

	public int price() {
		return price;
	}

	public int quantity() {
		return quantity;
	}

	public int subtotal() {
		return quantity() * price();
	}

}
