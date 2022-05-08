/**
 * @description Test class for EMOBoards
 * @author Nagpal
 * @created 2021-06-04
 */

@isTest
public class EMOBoards_Test {
	static String name = 'Lit';
	static String mood = 'Lit';
	static Date selectedDate = System.today();

	@testSetup
	private static void setup() {
		User user = [SELECT id, FirstName FROM User WHERE id = :userInfo.getUserId()];
		CollaborationGroup collabGroup = new CollaborationGroup(Name = 'Test1', CollaborationType = 'Public');
		insert collabGroup;
	}

	@isTest
	private static void testFatchUser() {
		User user = [SELECT id, FirstName FROM User WHERE id = :userInfo.getUserId()];
		test.startTest();
		System.runAs(user) {
			User receivedUser = EMOBoards.fetchUser();
			test.stopTest();
			system.assertEquals(true, receivedUser.Id != null, 'Assertion Failed');
		}
	}

	@isTest
	private static void getGroupMemberInfoTest() {
		test.startTest();
		List<CollaborationGroupMember> colGroupMembList = EMOBoards.getGroupMemberInfo();
		test.stopTest();
		system.assertEquals(1, colGroupMembList.size(), 'Assertion Failed');
	}

	@isTest
	private static void getCollaborationMoodTest() {
		CollaborationGroup collGroup = [SELECT Id FROM CollaborationGroup WHERE Name = 'Test1'];
		test.startTest();
		List<Collaboration__c> CollaborationList = EMOBoards.getCollaborationMood(selectedDate, collGroup.Id);
		test.stopTest();
		system.assertEquals(0, CollaborationList.size(), 'Assertion Failed');
	}

	@isTest
	private static void createCollaborationTest() {
		User user = [SELECT id, FirstName FROM User WHERE id = :userInfo.getUserId()];
		CollaborationGroup collGroup = [SELECT Id FROM CollaborationGroup WHERE Name = 'Test1'];
		test.startTest();
		System.runAs(user) {
			String returnedString = EMOBoards.createCollaboration(name, mood, '', user.Id, collGroup.Id);
			test.stopTest();
			List<Collaboration__c> CollaborationList = new List<Collaboration__c>(
				[SELECT Capture_Mood__c FROM Collaboration__c WHERE Reported_Date__c = :selectedDate]
			);
			system.assertEquals('Success', returnedString, 'Assertion Failed');
		}
	}
}