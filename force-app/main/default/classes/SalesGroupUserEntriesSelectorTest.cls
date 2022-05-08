/**
 * Apex Enterprise Design Patterns
 * @description Selector Layer test class for Sales_Group_User_Entry__c objects
 *
 * @author  Chandra
 * @since   2021-06-15
 */
@IsTest
public class SalesGroupUserEntriesSelectorTest {
	@TestSetup
	static void makeData() {
		Sales_Group__c salesGroup = new Sales_Group__c(Name = 'Test SG');
		insert salesGroup;

		Sales_Group_User_Entry__c salesGroupUserEntry = new Sales_Group_User_Entry__c(Sales_Group__c = salesGroup.Id, User__c = UserInfo.getUserId());
		insert salesGroupUserEntry;
	}

	@IsTest
	private static void testSelectById() {
		Sales_Group_User_Entry__c salesGroupUserEntry = [SELECT Id FROM Sales_Group_User_Entry__c LIMIT 1];

		Set<Id> idSet = new Set<Id>();
		idSet.add(salesGroupUserEntry.Id);

		Test.startTest();
		List<Sales_Group_User_Entry__c> salesGroupUserEntries = new SalesGroupUserEntriesSelector().selectById(idSet);
		Test.stopTest();

		System.assertEquals(salesGroupUserEntries.size(), 1, 'Assert Failed');
	}

	@IsTest
	private static void testSelectByUserId() {
		Set<Id> userIdSet = new Set<Id>();
		userIdSet.add(UserInfo.getUserId());

		Test.startTest();
		List<Sales_Group_User_Entry__c> salesGroupUserEntries = new SalesGroupUserEntriesSelector().selectByUserId(userIdSet);
		Test.stopTest();

		System.assertEquals(salesGroupUserEntries.size(), 1, 'Assert Failed');
	}
	
}