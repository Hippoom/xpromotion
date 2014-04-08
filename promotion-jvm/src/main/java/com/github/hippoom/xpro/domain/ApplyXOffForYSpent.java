package com.github.hippoom.xpro.domain;

public class ApplyXOffForYSpent implements Coupon {
	private int threshold;
	private int applied;

	public ApplyXOffForYSpent(int applied, int threshold) {
		this.threshold = threshold;
		this.applied = applied;
	}

	@Override
	public void applyTo(Order order) {
		final int origin = order.origin();
		order.apply(applied(origin));
	}

	private int applied(final int origin) {
		return origin >= threshold ? applied : 0;
	}
}
