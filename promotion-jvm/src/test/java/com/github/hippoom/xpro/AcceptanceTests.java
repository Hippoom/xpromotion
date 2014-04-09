package com.github.hippoom.xpro;

import org.junit.runner.RunWith;

import cucumber.api.junit.Cucumber;

@RunWith(Cucumber.class)
@Cucumber.Options(features = { "classpath:" }, format = { "html:target/acceptance-cucumber-html" }
//, name = "Order with coupon:1 off for 3 spent"
)
public class AcceptanceTests {

}
