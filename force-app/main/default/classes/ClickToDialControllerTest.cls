@isTest
public class ClickToDialControllerTest {
    @testSetup private static void setupData(){
        List<Account> accListInsert = TestDataFactory.getPersonAccounts('lastName', 'Individual_Client', 1);
        accListInsert[0].PersonBirthdate = System.today().addYears(-30);
        accListInsert[0].ExecutionLayerRequestID__c = 'e46b46fc-c2a0-43f2-8580-a7ece88d7c41';
        insert accListInsert;
        List<Opportunity> oppsList = TestDataFactory.getOpportunities(null, 'Investment_Opportunity', 1);
        oppsList[0].StageName = 'Proposal';
        oppsList[0].accountId = accListInsert[0].Id;
        insert oppsList;
    }
    @isTest private static void testClickDialInfo(){
        Opportunity opp = [SELECT Id FROM Opportunity WHERE RecordType.Name='Investment Opportunity'LIMIT 1];
        Test.startTest();
        Object result = ClickToDialController.getClickToDialInfo(opp.Id,'Mobile__c');
        Test.stopTest();
        System.assertEquals(result!=null, true);
    }
}