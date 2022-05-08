@IsTest
public class ServiceGroupUserEntriesSelectorTest {
	@TestSetup
	static void makeData() {
		Service_Group__c serviceGroup = new Service_Group__c(Name = 'Test SG');
		insert serviceGroup;

		Service_Group_User_Entry__c serviceGroupUserEntry = new Service_Group_User_Entry__c(Service_Group__c = serviceGroup.Id, User__c = UserInfo.getUserId());
		insert serviceGroupUserEntry;
	}

	@IsTest
	private static void testSelectById() {
		Service_Group_User_Entry__c serviceGroupUserEntry = [SELECT Id FROM Service_Group_User_Entry__c LIMIT 1];

		Set<Id> idSet = new Set<Id>();
		idSet.add(serviceGroupUserEntry.Id);

		Test.startTest();
		List<Service_Group_User_Entry__c> serviceGroupUserEntries = new ServiceGroupUserEntriesSelector().selectById(idSet);
		Test.stopTest();

		System.assertEquals(serviceGroupUserEntries.size(), 1, 'Assert Failed');
	}

	@IsTest
	private static void testSelectByUserId() {
		Set<Id> userIdSet = new Set<Id>();
		userIdSet.add(UserInfo.getUserId());

		Test.startTest();
		List<Service_Group_User_Entry__c> serviceGroupUserEntries = new ServiceGroupUserEntriesSelector().selectByUserId(userIdSet);
		Test.stopTest();

		System.assertEquals(serviceGroupUserEntries.size(), 1, 'Assert Failed');
	}

	@IsTest
	private static void testCountUserRelatedEntries() {
		Id userId = UserInfo.getUserId();
		List<String> sGroupNames = new List<String>{ 'Test SG' };

		Test.startTest();
		Integer userEntries = new ServiceGroupUserEntriesSelector().countUserRelatedEntries(userId, sGroupNames);
		Test.stopTest();

		System.assertEquals(userEntries, 1, 'Assert Failed');
	}
}