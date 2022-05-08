@isTest
public class TestRecordTransferController {
    public static User getUser(){
        User uA = new User();
        Set<String> userEmails = new Set<String>();
        userEmails.add('User@testorg.com');
        List<User> userList = new UsersSelector().selectByEmail(userEmails);
        if (!userList.isEmpty() && userList != null) {
            for (User u : userList) {
                if (u.Email=='User@testorg.com') {
                    uA=u;
                }
            }
        }
        return uA;
    }
    @isTest static void quoteProcessTestA(){
        user ua = getUser();
        Account acc =new Account();
        acc.name='testcreateCif';
        acc.Type='Business Prospect Clinet';
        acc.CIF__c = 'SACOMPE259';
        insert acc;
        Opportunity testOpp = new Opportunity();
        testOpp.Name = 'Test Opp Onboarding';
        testOpp.CloseDate = Date.today();
        testOpp.StageName = 'New';
        testOpp.Pricebook2Id = Test.getStandardPricebookId();
        testOpp.AccountId = acc.id;
        insert testOpp;
        Opportunity opp = [select id,OwnerId from Opportunity where id = : testOpp.id];
        List<User> usersList = new List<User>();
        System.runAs(new User(Id=UserInfo.getUserId())){
            usersList = TestDataFactory.getTestUsers('System Administrator', 2);
            insert usersList;             
        }
        List<Lead> leadsList = TestDataFactory.getLeads('Business_Bank_Lead', 4);
        leadsList[0].Status = 'New';// change owner to test user
        leadsList[1].OwnerId = usersList[0].Id;
        leadsList[1].OwnerId = usersList[0].Id;// owner change
        leadsList[2].OwnerId = usersList[0].Id;
        leadsList[3].OwnerId = usersList[0].Id;
        insert leadsList;
        lead le = [select id,OwnerId from lead where id = : leadsList[0].id];
        RecordTransferController.changeOwner(opp.id,opp.OwnerId);
        RecordTransferController.changeOwner(le.id,le.OwnerId);
    }
    
    
}