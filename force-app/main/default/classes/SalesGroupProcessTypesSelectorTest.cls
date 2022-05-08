/**
 * Apex Enterprise Design Patterns
 * @description Selector Layer test class for Sales_Group_Process_Type__c objects
 *
 * @author  Chandra
 * @since   2021-06-15
 */
@isTest
private class SalesGroupProcessTypesSelectorTest {
	/*
	 * Purpose : Method to create test data
	 */
	@testSetup
	static void dataCreation() {
		Sales_Group__c salesGroup = new Sales_Group__c();
		salesGroup.Name = 'Test Group';
		insert salesGroup;

		Sales_Process_Type__c salesProcessType = new Sales_Process_Type__c();
		salesProcessType.Name = 'Test Sales Type';
		salesProcessType.Opportunity_Record_Type__c = 'Credit Onboarding';
		salesProcessType.Request_Name__c = 'Service Request';
		insert salesProcessType;

		Sales_Group_Process_Type__c salesGroupProcessType = new Sales_Group_Process_Type__c();
		salesGroupProcessType.Name = 'Test';
		salesGroupProcessType.Sales_Group__c = salesGroup.Id;
		salesGroupProcessType.Sales_Process_Type__c = salesProcessType.Id;
		insert salesGroupProcessType;

		Sales_Group_User_Entry__c salesGroupUserEntry = new Sales_Group_User_Entry__c();
		salesGroupUserEntry.Sales_Group__c = salesGroup.Id;
		salesGroupUserEntry.User__c = UserInfo.getUserId();
		insert salesGroupUserEntry;
	}

	@isTest
	private static void testSelectById() {
		Sales_Group_Process_Type__c salGrpPrcType = [SELECT Id FROM Sales_Group_Process_Type__c LIMIT 1];

		SalesGroupProcessTypesSelector sgpts = new SalesGroupProcessTypesSelector();
		Set<Id> tstSet = new Set<Id>();
		tstSet.add(salGrpPrcType.Id);
		Test.startTest();
		List<Sales_Group_Process_Type__c> grps = sgpts.selectById(tstSet);
		Test.stopTest();
		System.assertEquals(1, grps.size(), 'Assert Failed');
	}

	@isTest
	private static void testgetSalesProcessTypeWithSalesGroup() {
		Sales_Group_Process_Type__c salGrpPrcType = [SELECT Id FROM Sales_Group_Process_Type__c LIMIT 1];
		Sales_Process_Type__c salPrcType = [SELECT Id, Name FROM Sales_Process_Type__c LIMIT 1];
		Sales_Group__c salGrp = [SELECT Id, Name FROM Sales_Group__c LIMIT 1];

		SalesGroupProcessTypesSelector sgpts = new SalesGroupProcessTypesSelector();
		List<String> salesGroups = new List<String>();
		salesGroups.add(salGrp.Name);
		Test.startTest();
		List<Sales_Group_Process_Type__c> grps = sgpts.getSalesProcessTypeWithSalesGroup('Test', salesGroups);
		Test.stopTest();
		System.assertEquals(0, grps.size(), 'Assert Failed');
	}
	
}