@isTest
public class ScorecardControllerTest {
    @TestSetup
    static void makeData(){

        Account mainAccount = new Account(Name = 'Test Main Account');
        insert mainAccount;

        Opportunity opp = new Opportunity (Name ='testopp', AccountId = mainAccount.Id, StageName = 'New', CloseDate = system.today());
        insert opp;

        Application__c applicationRecord = new Application__c();
        applicationRecord.Opportunity__c = opp.Id;
        insert applicationRecord;

        Application_Scoring__c appScoring = new Application_Scoring__c();
        appScoring.Application_Number__c = applicationRecord.Id;
        insert appScoring;

    }

    @isTest
    static void testGetScorecardData(){

        Opportunity testOpportunity = [SELECT Id FROM Opportunity LIMIT 1];
        Application_Scoring__c appScoring = ScorecardController.getScorecardData(testOpportunity.Id);
        System.assertNotEquals(null, appScoring.Id);
    }
}