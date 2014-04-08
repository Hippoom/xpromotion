package com.github.hippoom.xpro;

import static org.hamcrest.Matchers.equalTo;
import static org.junit.Assert.assertThat;

import groovy.lang.GroovyShell;
import groovy.lang.Script;

import java.util.HashMap;
import java.util.Map;

import org.junit.Test;

import com.github.hippoom.xpro.domain.ScriptResolver;

public class ScriptResolverUnitTests {

	@Test
	public void returnsOriginTextIfContainsNonePlaceHolder() throws Throwable {
		final ScriptResolver subject = new ScriptResolver("Some Text here.",
				new HashMap<String, String>());

		final String resolved = subject.resolved();

		assertThat(resolved, equalTo("Some Text here."));
	}

	@Test
	public void returnsValueReplacedTextIfFound() throws Throwable {
		final Map<String, String> placeHolders = new HashMap<String, String>();
		placeHolders.put("key1", "Replaced");
		final ScriptResolver subject = new ScriptResolver(
				"Some Text ${key1} here.", placeHolders);

		final String resolved = subject.resolved();

		assertThat(resolved, equalTo("Some Text Replaced here."));
	}

	@Test
	public void returnsValueReplacedTextIfMultiplePlaceHoldersFound()
			throws Throwable {
		final Map<String, String> placeHolders = new HashMap<String, String>();
		placeHolders.put("key1", "Replaced1");
		placeHolders.put("key2", "Replaced2");
		final ScriptResolver subject = new ScriptResolver(
				"Some Text ${key1} her${key2}e.", placeHolders);

		final String resolved = subject.resolved();

		assertThat(resolved, equalTo("Some Text Replaced1 herReplaced2e."));
	}

	@Test
	public void returnsKeysIfOnePlaceHoldersMissing() throws Throwable {
		final Map<String, String> placeHolders = new HashMap<String, String>();
		placeHolders.put("key1", "Replaced1");
		final ScriptResolver subject = new ScriptResolver(
				"Some Text ${key1} her${key2}e.", placeHolders);

		final String resolved = subject.resolved();

		assertThat(resolved, equalTo("Some Text Replaced1 her${key2}e."));
	}

	@Test
	public void runScript() {
		GroovyShell shell = new GroovyShell();

		Script script = shell
				.parse("def quantities = [3,3]; def prices = [3,4]; def temp = 0; for (int i=0;i<quantities.size;i++) { if (2.0 < quantities[i]) {temp += prices[i]*1.0}}; return temp;");

		System.err.println(script.run());
	}

}
