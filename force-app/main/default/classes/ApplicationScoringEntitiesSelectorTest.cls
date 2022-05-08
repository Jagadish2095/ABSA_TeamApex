/**
 * Test class for ApplicationScoringEntitiesSelector
 *
 * @author Ephetehe Mokgopanyane (ephetehe.mokgopanyane@tetrad.co.za)
 * @date February 2021
 */
@isTest
public class ApplicationScoringEntitiesSelectorTest {
	@testSetup
	public static void dataCreation() {
        Account account = new Account();
        account.Name = 'Test Account';
        account.CIF__c = 'SNIFFEL001';
        account.Sic='35790';
        account.AccountNumber='0';
        account.Registration_Number__c = '1990/011515/23';
        account.Client_Type__c = 'Individual';
        insert account;
        
        Opportunity opportunity = new Opportunity();
        opportunity.Name = 'Test Opp Onboarding 1';
        opportunity.CloseDate = Date.today();
        opportunity.StageName = 'New';
        opportunity.AccountId=account.Id;
        insert opportunity;
        
        Application__c application = new Application__c();
        application.Opportunity__c = opportunity.id;
        application.Account_Access__c = 'Cellphone';
        application.Surplus_Cash__c = 'Fixed Deposits';
        application.Borrowing_Requiment_General__c = 'Credit Card';
        application.Protection_Of_Services__c = 'Retirement';
        application.Title__c = 'dd';
        application.FirstNameSignature__c = 'Litha';
        application.SurnameSignature__c = 'Nosekeleza';
        application.Signing_Date__c = System.today();
        application.Stock_Number__c = '';
        insert application;
        
        Application_Scoring__c appScoring = new Application_Scoring__c();
        appScoring.Application_Number__c = application.Id;
        insert appScoring;
        
        Application_Scoring_Entity__c appScoreEntity = new Application_Scoring_Entity__c();
        appScoreEntity.Application_Scoring__c = appScoring.Id;
        insert appScoreEntity;
    }
    
    @isTest
    public static void testSelectByApplicationScoringId(){
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        Application__c app = [SELECT Id FROM Application__c WHERE Opportunity__c =: opp.Id];
        Application_Scoring__c appScoring = [SELECT Id FROM Application_Scoring__c appScoring WHERE Application_Number__c =: app.Id];
        
        Test.startTest();
        List<Application_Scoring_Entity__c> appScoreEntities = new ApplicationScoringEntitiesSelector().selectByApplicationScoringId(new Set<Id>{appScoring.Id});
        Test.stopTest();
        
        System.assert(appScoreEntities.size() != 0);
    }
}