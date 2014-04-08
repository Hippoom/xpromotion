package com.github.hippoom.xpro.domain;

public class ApplyXFreeForYOrdered implements Coupon {
	private int threshold;
	private int applied;

	public ApplyXFreeForYOrdered(int applied, int threshold) {
		this.threshold = threshold;
		this.applied = applied;
	}

	@Override
	public void applyTo(Order order) {
		int applied = 0;
		for (Item item : order.items()) {
			if (item.quantity() >= threshold) {
				applied += item.price() * this.applied;
			}
		}
		order.apply(applied);
	}
}
