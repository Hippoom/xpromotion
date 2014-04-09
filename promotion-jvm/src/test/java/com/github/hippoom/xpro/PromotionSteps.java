package com.github.hippoom.xpro;

import static org.hamcrest.Matchers.is;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertThat;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import lombok.extern.slf4j.Slf4j;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;

import com.github.hippoom.xpro.application.RestbucksApp;
import com.github.hippoom.xpro.commands.PlaceOrderCommand;
import com.github.hippoom.xpro.domain.Item;
import com.github.hippoom.xpro.domain.Order;

import cucumber.api.DataTable;
import cucumber.api.java.After;
import cucumber.api.java.en.Given;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;

@ContextConfiguration({ "classpath:acceptance.xml" })
@Slf4j
public class PromotionSteps {
	@Autowired
	private RestbucksApp app;

	private String coupon;

	private Order order;
	
	@After
	public void print() {
		log.info(app.toString());
	}

	@Given("^coupon template setup$")
	public void coupon_template_setup(DataTable template) throws Throwable {
		for (Map<String, String> t : template.asMaps()) {
			app.registerTemplate(t.get("code"), t.get("script"));
		}
	}

	@Then("^I publish coupons named \"([^\"]*)\" with template \"([^\"]*)\"$")
	public void I_publish_coupons_named(String code, String template,
			DataTable params) throws Throwable {
		Map<String, String> p = new HashMap<String, String>();
		for (Map<String, String> param : params.asMaps()) {
			p.put(param.get("key"), param.get("value"));
		}
		app.registerCoupon(code, template, p);
	}

	@Given("^I have a coupon \"([^\"]*)\"$")
	public void I_have_a_coupon(String coupon) throws Throwable {
		this.coupon = coupon;
	}

	@When("^I order drink with$")
	public void I_order_drink_with(DataTable items) throws Throwable {
		order = app.placeOrder(new PlaceOrderCommand(coupon, as(items)));
	}

	private List<Item> as(DataTable items) {
		final List<Item> itemList = new ArrayList<Item>();
		for (Map<String, String> item : items.asMaps()) {
			itemList.add(new Item(item.get("drink"), item.get("milk"), item
					.get("size"), Integer.valueOf(item.get("quantity")),
					Integer.valueOf(item.get("price"))));
		}
		return itemList;
	}

	@Then("^an order should be placed$")
	public void an_order_should_be_placed() throws Throwable {
		assertNotNull(order);
	}

	@Then("^the cost is (\\d+)$")
	public void the_cost_is(int expected) throws Throwable {
		assertThat(order.cost(), is(expected));
	}
}
