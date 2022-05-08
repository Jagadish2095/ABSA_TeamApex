@isTest
public class QuotesSelectorTest {
	@isTest
	private static void testSelectByOpportunityId() {
		WimiTestDataFactory testDataFactory = new WimiTestDataFactory();

		Opportunity tstOpp = testDataFactory.testOpportunity;

		QuotesSelector qs = new QuotesSelector();
		List<Quote> quotes = qs.selectByOpportunityId(tstOpp.Id);
		system.assertNotEquals(null, quotes);
	}

	@isTest
	private static void testSelectBySyncedQuoteId() {
		WimiTestDataFactory testDataFactory = new WimiTestDataFactory();

		Quote q = testDataFactory.testQuote;

		QuotesSelector qs = new QuotesSelector();
		Quote quote = qs.selectBySyncedQuoteId(q.Id);
		system.assertNotEquals(null, quote);
	}
	//added by pranav 24112020
	@isTest
	private static void testselectById() {
		WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
		Opportunity tstOpp = testDataFactory.testOpportunity;

		Quote q = testDataFactory.testQuote;
		QuotesSelector qs = new QuotesSelector();
		set<id> quteidset = new Set<id>{ q.Id };
		set<string> prodset = new Set<string>{ 'Flexi Funneral' };
		list<Quote> quote = qs.selectById(quteidset);
		system.assertNotEquals(null, quote);
		List<Quote> quotes = qs.filterByOpportunityId(tstOpp.Id);
		List<Quote> quotes1 = qs.selectQuoteByOpportunityId(tstOpp.Id);
		List<Quote> quotes2 = qs.selectByProductName(tstOpp.Id, 'Flexi Funneral');
		List<Quote> quotes3 = qs.selectByProductNames(tstOpp.Id, prodset);
		List<Quote> quotes4 = qs.selectQuoteByOpportunityIdAndProdName(tstOpp.Id, 'Flexi Funneral');
	}
}