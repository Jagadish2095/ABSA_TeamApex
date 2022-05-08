/**
 * @description       : PowerCurveOutputController Test
 * @author            : Tinashe M Shoko | 2021-06-12 
 * @last modified on  : 2021-06-12
 * @last modified by  : 
 * Modifications Log 
 * Ver   Date         Author   Modification
 * 1.0   2021-06-12      Initial Version
**/
@isTest
public class PowerCurveOutputControllerTest {
    /**
     * @description dataCreation description
     *
     */
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

        Id pricebookId = Test.getStandardPricebookId();

        //For Policy without Spouse
        Product2 product1 = new Product2();
        product1.name = 'EPP Executor Fees Policy';
        product1.IsActive = true;
        insert product1;
        PricebookEntry pricebookEntry1 = new PricebookEntry();
        pricebookEntry1.UnitPrice = 0;
        pricebookEntry1.Product2Id = product1.id;
        pricebookEntry1.Pricebook2Id = pricebookId;
        pricebookEntry1.IsActive = true;
        insert pricebookEntry1;

        OpportunityLineItem oppLineItem = new OpportunityLineItem();
        oppLineItem.OpportunityId = opportunity.Id;
        oppLineItem.Product2Id = product1.Id;
        oppLineItem.PricebookEntryId = pricebookEntry1.Id;
        oppLineItem.Quantity = 1;
        oppLineItem.TotalPrice = 100;
        Insert oppLineItem;

        Application_Product__c testAppProdCred = new Application_Product__c();
        testAppProdCred.Opportunity_Product_Id__c = oppLineItem.Id;
        testAppProdCred.Account_Number__c = 1234;
        testAppProdCred.Account_Number__c = 124345;
        testAppProdCred.Account_Balance__c = 100;
        testAppProdCred.Opportunity__c = opportunity.id;
        insert testAppProdCred;

        Application_Product__c testAppProdCredC = new Application_Product__c();
        testAppProdCredC.Opportunity_Product_Id__c = oppLineItem.Id;
        testAppProdCredC.Application_Product_Parent__c = testAppProdCred.Id;
        testAppProdCredC.Opportunity__c = opportunity.id;
        insert testAppProdCredC;

        Application_Triad__c triad = new Application_Triad__c();
        triad.Application__c = application.Id;
        triad.Is_Main_Applicant__c = true;
        triad.Additional_Overdraft_Limit__c = 100000;
        insert triad;
    }

    /**
     * @description testScoringObject description
     *
     *
     */
    @isTest
    public static void testScoringObject(){
    Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
    test.startTest();
    PowerCurveOutputController.getData(opp.id,'2');
    PowerCurveOutputController.getPCO6Data(opp.id,'2');
    PowerCurveOutputController.getChequeAndOverdraft(opp.id);
    PowerCurveOutputController.getApplicationTriadPreAdviced(opp.id);
    PowerCurveOutputController.getPCO7Data(opp.id, '01');
    PowerCurveOutputController.updateOpportunity(opp.Id,100);
    system.assertNotEquals(null,PowerCurveOutputController.makePCOCall(opp.Id),'We should return something');
    test.stopTest();
    //System.assertNotEquals(null, appScoringRecords);
    }

}