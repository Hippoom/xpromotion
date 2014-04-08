package com.github.hippoom.xpro.domain;

import static ch.lambdaj.Lambda.join;
import groovy.lang.GroovyShell;
import groovy.lang.Script;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class Coupon {

	private String script;
	private Map<String, String> params = new HashMap<String, String>();

	public Coupon(String script) {
		this.script = script;
	}

	public Coupon scriptIs(String script) {
		this.script = script;
		return this;
	}

	public Coupon addParam(String key, double value) {
		this.params.put(key, String.valueOf(value));
		return this;
	}

	public void applyTo(Order order) {
		order.apply(((Number) resolvedScript(order).run()).intValue());
	}

	private Script resolvedScript(Order order) {
		GroovyShell shell = new GroovyShell();
		final Map<String, String> params = new HashMap<String, String>();
		params.put("origin", String.valueOf(order.origin()));
		params.put("quantities", quantities(order));
		params.put("prices", prices(order));
		params.putAll(this.params);
		String resolved = new ScriptResolver(this.script, params).resolved();
		System.err.println(params);
		System.err.println(resolved);
		return shell.parse(resolved);
	}

	private String quantities(Order order) {
		List<String> quantities = new ArrayList<String>();
		for (Item item : order.items()) {
			quantities.add(String.valueOf(item.quantity()));
		}
		return "[" + join(quantities, ",") + "]";
	}

	private String prices(Order order) {
		List<String> prices = new ArrayList<String>();
		for (Item item : order.items()) {
			prices.add(String.valueOf(item.price()));
		}
		return "[" + join(prices, ",") + "]";
	}

}
