/**
 * @description       : Test class for BorrowingCapacityCtrl 
 * @author            : Ephetehe Mokgopanyane (ephetehe.mokgopanyane@tetrad.co.za)
 * @last modified on  : 2021-06-08
 * @last modified by  : Himanshu.Nimje@absa.africa
 * Modifications Log 
 * Ver   Date         Author                       Modification
 * 1.0   2021-01-21   Ephetehe Mokgopanyane (ephetehe.mokgopanyane@tetrad.co.za)   Initial Version
**/

@isTest
public class BorrowingCapacityCtrlTest {
    /**
    * @description  Data creation
    * @author Ephetehe Mokgopanyane (ephetehe.mokgopanyane@tetrad.co.za)| 2021-06-07 
    **/
    	@testSetup
    public static void dataCreation() {
        Account account = new Account();
        account.Name = 'Test Account';
        account.Client_Type__c = 'Private Individual';
        account.CIF__c = 'Test+001';
        insert account;

        Opportunity opportunity = new Opportunity();
        opportunity.Name = 'Test Opp Onboarding 1';
        opportunity.CloseDate = Date.today();
        opportunity.StageName = 'New';
        opportunity.AccountId = account.Id;
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
        appScoring.Ceiling_Limit__c = 10000;
        appScoring.Potential_Ordinary_Credit__c = 10000;
        appScoring.Residual_Unsecured_Borrowing_Capacity__c = 10000;
        appScoring.Net_Existing_ASV__c = 10000;
        appScoring.Specific_ASV_Available__c = 10000;
        appScoring.ASV_Offered__c = 10000;
        appScoring.Residual_Borrowing_Capacity_on_FTO__c = 10000;
        appScoring.BE_Net_Worth__c = 10000;
        appScoring.Residual_Borrowing_Capacity_after_BENW__c = 10000;
        appScoring.Principal_Net_Worth__c = 10000;
        appScoring.Residual_Borrowing_Capacity_after_PNW__c = 10000;
        appScoring.ASV_Shortfall_Amount_after_Tolerance__c = 10000;
        appScoring.Stage__c = '2';
        insert appScoring;
    }
    /**
    * @description Positive test method
    * @author Ephetehe Mokgopanyane (ephetehe.mokgopanyane@tetrad.co.za) | 2021-06-07 
    **/
    @isTest
    public static void testGetApplicationScoringRecordIdPositive(){
        Application__c application = [SELECT Id FROM Application__c LIMIT 1];
        Application_Scoring__c appScoring = new Application_Scoring__c();
        appScoring.Application_Number__c = application.Id;
        appScoring.Ceiling_Limit__c = 10000;
        appScoring.Potential_Ordinary_Credit__c = 10000;
        appScoring.Residual_Unsecured_Borrowing_Capacity__c = 10000;
        appScoring.Net_Existing_ASV__c = 10000;
        appScoring.Specific_ASV_Available__c = 10000;
        appScoring.ASV_Offered__c = 10000;
        appScoring.Residual_Borrowing_Capacity_on_FTO__c = 10000;
        appScoring.BE_Net_Worth__c = 10000;
        appScoring.Residual_Borrowing_Capacity_after_BENW__c = 10000;
        appScoring.Principal_Net_Worth__c = 10000;
        appScoring.Residual_Borrowing_Capacity_after_PNW__c = 10000;
        appScoring.ASV_Shortfall_Amount_after_Tolerance__c = 10000;
        insert appScoring;
        
        List<Opportunity> opportunities = [SELECT Id FROM Opportunity LIMIT 1];

        Test.startTest();
        Id appScoringId = BorrowingCapacityCtrl.getApplicationScoringRecordId(opportunities[0].Id);
        Test.stopTest();
        
        System.assertNotEquals(null, appScoringId);
    }

    /**
    * @description Negative test method
    * @author Ephetehe Mokgopanyane (ephetehe.mokgopanyane@tetrad.co.za) | 2021-06-07 
    **/
    @isTest
    public static void testGetApplicationScoringRecordIdNegative(){
        List<Opportunity> opportunities = [SELECT Id FROM Opportunity LIMIT 1];

        Test.startTest();
        Id appScoringId = BorrowingCapacityCtrl.getApplicationScoringRecordId(opportunities[0].Id);
        Test.stopTest();

        System.assertNotEquals(null, appScoringId);
    }

}