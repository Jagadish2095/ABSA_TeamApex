/**
 * @description Apex Enterprise Design Patters
 * Test Class for the Selector layer for Application__c objects
 * @author  Nelson Chisoko (Dariel)
 * @since   14/02/2019
 * @updated 14/06/2021
 * @updated 09/07/2021
 * @updated 30/07/2021
 * @updated 20/08/2021
 *  
 */

@IsTest
private class ApplicationsSelectorTest {
	/**
	 * @description testGetSObjectType Method
	 */
	@IsTest
	private static  void testGetSObjectType() {
		test.startTest();
		System.assert(new ApplicationsSelector().getSObjectType() != null, 'not null');
		test.stopTest();
	}

	/**
	 * @description testGetSObjectFieldList Method
	 */
	@IsTest
	private static void testGetSObjectFieldList() {
		test.startTest();
		System.assert(new ApplicationsSelector().getSObjectFieldList() != null, 'not null');
		test.stopTest();
	}

	/**
	 * @description testSelectById Method
	 */
	@IsTest
	private static void testSelectById() {
		test.startTest();
		Opportunity testOpportunity = WillsTestDataFactory.createOpportunity();
		Application__c application = new ApplicationsSelector().selectByOpportunityId(testOpportunity.Id).get(0);
		System.assert(new ApplicationsSelector().selectById(application.Id) != null, 'not null');
		test.stopTest();
	}

	// PJAIN: 20200708: Not my method, but writing this method to bring code coverage up
	/**
	 * @description testSelectByIdForValueAddService Method
	 */
	@IsTest
	private static void testSelectByIdForValueAddService() {
		test.startTest();
		Opportunity testOpportunity = WillsTestDataFactory.createOpportunity();
		Application__c application = new ApplicationsSelector().selectByOpportunityId(testOpportunity.Id).get(0);
		System.assert(new ApplicationsSelector().selectByIdForValueAddService(application.Id) != null, 'not null');
		test.stopTest();
	}

	/**
	 * @description testSelectByOpportunityId Method
	 */
	@IsTest
	private static void testSelectByOpportunityId() {
		test.startTest();
		Opportunity testOpportunity = WillsTestDataFactory.createOpportunity();
		System.assert(new ApplicationsSelector().selectByOpportunityId(testOpportunity.Id) != null, 'not null');
		test.stopTest();
	}

	/**
	 * @description testselectByOpportunityBranchId Method
	 */
	@IsTest
	private static void testselectByOpportunityBranchId() {
		test.startTest();
		Opportunity testOpportunity = WillsTestDataFactory.createOpportunity();
		System.assert(new ApplicationsSelector().selectByOpportunityBranchId(testOpportunity.Id) != null, 'not null');
		test.stopTest();
	}

	// PJAIN: 20200708: Not my method, but writing this method to bring code coverage up
	/**
	 * @description testSelectByOpportunityOnboardId Method
	 */
	@IsTest
	private static void testSelectByOpportunityOnboardId() {
		test.startTest();
		Opportunity testOpportunity = WillsTestDataFactory.createOpportunity();
		System.assert(new ApplicationsSelector().selectByOpportunityOnboardId(testOpportunity.Id) != null, 'not null');
		test.stopTest();
	}

	/**
	 * @description testSelectByOpportunityIdList Method
	 */
	@IsTest
	private static void testSelectByOpportunityIdList() {
		test.startTest();
		Opportunity testOpportunity = WillsTestDataFactory.createOpportunity();
		Set<Id> oppSet = new Set<Id>();
		oppSet.add(testOpportunity.Id);
		System.assert(new ApplicationsSelector().selectByOpportunityIdList(oppSet) != null, 'not null');
		test.stopTest();
	}
	/**
	 * @description testSelectByOpportunityIdList Method
	 */
	@IsTest
	static void testSelectByIdForContract() {
		test.startTest();
		Opportunity testOpportunity = WillsTestDataFactory.createOpportunity();
		Application__c application = new ApplicationsSelector().selectByOpportunityId(testOpportunity.Id).get(0);
		System.assert(new ApplicationsSelector().selectByIdForContract(application.Id) != null);
		test.stopTest();
	}
}