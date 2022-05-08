@isTest
public class TradingAsNamesSelectorTest {
	@isTest
	private static void testSelectById() {
		WimiTestDataFactory testDataFactory = new WimiTestDataFactory();

		//Create Trading as Name test records
		Trading_as_Name__c testTradingAsName = new Trading_as_Name__c();
		testTradingAsName.Name = 'T/A Test';
		testTradingAsName.Account__c = testDataFactory.testAccount.id;
		insert testTradingAsName;

		Set<Id> accIdSet = new Set<Id>();
		accIdSet.add(testDataFactory.testAccount.Id);

		System.assertNotEquals(testTradingAsName.id, null);
		System.assertNotEquals(testDataFactory.testAccount.id, null);
		TradingAsNamesSelector testTradingAsNamesSelector = new TradingAsNamesSelector();
		Trading_as_Name__c tradingNameRec = testTradingAsNamesSelector.selectById(testTradingAsName.id);
		List<Trading_as_Name__c> tradingNameList = testTradingAsNamesSelector.selectByAccountId(accIdSet);
	}
}