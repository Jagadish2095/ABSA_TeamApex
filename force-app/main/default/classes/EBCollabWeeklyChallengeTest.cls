/**
* @description Test class for EBCollabWeeklyChallenge class
* @author Bhanumurty Rayala
* @created 2021-06-01
* @User story W-011455
*/
@isTest()
public class EBCollabWeeklyChallengeTest {

    @TestSetup
    static void makeData(){

        CollaborationGroup testGroup = new CollaborationGroup(Name = 'Test1', CollaborationType = 'Public');
        insert testGroup;

        Collaboration__c collab = new Collaboration__c(Name = 'Test Collab', Collaboration_Group_Id__c = testGroup.Id);
        insert collab;

        Profile testProfile = [SELECT Id FROM profile WHERE name LIKE '%System%' LIMIT 1];

        User testUser = new User(Alias = 'test', Email='test@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = testProfile.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='testName@testorg.com');
        insert testUser;

        CollaborationGroupMember testGroupMember = new CollaborationGroupMember();
        testGroupMember.CollaborationGroupId = testGroup.Id;
        testGroupMember.MemberId = testUser.Id;
        testGroupMember.CollaborationRole = 'Standard';
        testGroupMember.NotificationFrequency='P';
        insert testGroupMember;

    }

    @isTest static void getGroupMemberInformationTest() {

        Test.startTest();
        CollaborationGroup testGroupId = [SELECT Id, Name FROM CollaborationGroup WHERE Name LIKE 'Test1'];
        List<CollaborationGroupMember> testGroup = EBCollabWeeklyChallenge.getGroupMemberInformation(testGroupId.Id);
        Test.stopTest();
        System.assertEquals(1, testGroup.size(), 'Assert Failed');
    }

    @isTest static void getWeeklyChallengeTest() {
        CollaborationGroup testGroup = [SELECT Id FROM CollaborationGroup WHERE Name = :'Test1'];
        Test.startTest();
        List<Collaboration__c> testCollab = EBCollabWeeklyChallenge.getWeeklyChallenge(testGroup.Id);
        Test.stopTest();
        System.assertEquals(1, testCollab.size(), 'Assert Failed');
    }

    @isTest static void getGroupMembersTest() {
        CollaborationGroup testGroup = [SELECT Id FROM CollaborationGroup WHERE Name = :'Test1'];
        Test.startTest();
        List<User> testCollab = EBCollabWeeklyChallenge.getGroupMembers(testGroup.Id);
        Test.stopTest();
        System.assertNotEquals(0, testCollab.size(), 'Assert Failed');
    }

    @isTest static void createWeeklyChallengeInsertTest() {
        String selChallenge = 'Test Challenge';
        String otherChallenge = '';
        String lookWinner = 'Testing';
        Date endDate = System.today();
        String buttonAction = 'ADD';
        String recordId = '';
        CollaborationGroupMember testGroup = new CollaborationGroupMember();
        String collaborationGroupId = testGroup.Id;
        Test.startTest();
        EBCollabWeeklyChallenge.createWeeklyChallenge(selChallenge, otherChallenge, lookWinner, endDate, buttonAction, recordId, collaborationGroupId);
        List<Collaboration__c> editTestList = new List<Collaboration__c>([SELECT Id FROM Collaboration__c]);
        Test.stopTest();
        System.assertEquals(editTestList.size(), 2, 'Assert failed');
    }

    @isTest static void createWeeklyChallengeOtherPicklistInsertTest() {
        String selChallenge = 'Test Challenge';
        String otherChallenge = 'New Test Challenge';
        String lookWinner = 'Testing';
        Date endDate = System.today();
        String buttonAction = 'ADD';
        String recordId = '';
        CollaborationGroupMember testGroup = new CollaborationGroupMember();
        String collaborationGroupId = testGroup.Id;
        Test.startTest();
        EBCollabWeeklyChallenge.createWeeklyChallenge(selChallenge, otherChallenge, lookWinner, endDate, buttonAction, recordId, collaborationGroupId);
        List<Collaboration__c> editTestList = new List<Collaboration__c>([SELECT Id FROM Collaboration__c]);
        Test.stopTest();
        System.assertEquals(editTestList.size(), 2, 'Assert failed');
    }

    @isTest static void createWeeklyChallengeEditTest() {
        String selChallenge = 'Test Challenge';
        String otherChallenge = '';
        String lookWinner = 'Testing Edited';
        Date endDate = System.today();
        String buttonAction = 'EDIT';
        Collaboration__c editTest = [SELECT Id FROM Collaboration__c];
        String recordId = editTest.Id;
        CollaborationGroupMember testGroup = new CollaborationGroupMember();
        String collaborationGroupId = testGroup.Id;
        Test.startTest();
        EBCollabWeeklyChallenge.createWeeklyChallenge(selChallenge, otherChallenge, lookWinner, endDate, buttonAction, recordId, collaborationGroupId);
        List<Collaboration__c> editTestList = new List<Collaboration__c>([SELECT Id, Winner_Criteria__c FROM Collaboration__c]);
        Test.stopTest();
        System.assertEquals(editTestList.get(0).Winner_Criteria__c, 'Testing Edited', 'Assert failed');
    }

    @isTest static void assignWinnerTest() {
        String winner = UserInfo.getUserId();
        String duration = 'One Week';
        String comment = 'Testing';
        Date startDate = System.today();
        Collaboration__c assignTest = [SELECT Id FROM Collaboration__c];
        String recordId = assignTest.Id;

        Test.startTest();
        EBCollabWeeklyChallenge.assignWinner(recordId, winner, duration, startDate, comment);
        List<Collaboration__c> editTestList = new List<Collaboration__c>([SELECT Id, Comments__c FROM Collaboration__c]);
        Test.stopTest();
        System.assertEquals(editTestList.get(0).Comments__c, 'Testing', 'Assert failed');
    }
}