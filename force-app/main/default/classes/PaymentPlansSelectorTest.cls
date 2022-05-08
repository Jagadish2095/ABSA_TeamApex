/**
 * @description       : 
 * @author            : Manish.battu@absa.africa
 * @last modified on  : 2021-06-11
 * @last modified by  : Manish.battu@absa.africa
 * Modifications Log 
 * Ver   Date         Author                     Modification
 * 1.0   2021-06-11   Manish.battu@absa.africa   Initial Version
**/
@isTest
public class PaymentPlansSelectorTest {
	@isTest
    private static void testSelectById() {
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        Payment_Plan__c tstPaymentPlan = testDataFactory.testPaymentPlan;
        PaymentPlansSelector pps = new PaymentPlansSelector();
        Test.startTest();
        List<Payment_Plan__c> payplans = pps.selectById(tstPaymentPlan.Id, 1);
        payplans = pps.selectById(tstPaymentPlan.Id, 1);
        System.assertNotEquals(payplans, null, '');
        Test.stopTest();
    }
    @isTest
    private static void testSelectByTypeByApplicationId() {
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        Opportunity tstOpportunity = testDataFactory.testOpportunity;
        Payment_Plan__c tstPaymentPlan = testDataFactory.testPaymentPlan;
        PaymentPlansSelector pps = new PaymentPlansSelector();
        Test.startTest();
        List<Payment_Plan__c> payplans = pps.selectByTypeByApplicationId(tstOpportunity.Id, tstPaymentPlan.Type__c, 1);
        payplans = pps.selectByTypeByApplicationId(tstOpportunity.Id, tstPaymentPlan.Type__c, 1);
        System.assertNotEquals(payplans, null, '');
        Test.stopTest();
    }
    //selectByApplicationIdByTypeByName
    @isTest
    private static void testSelectByApplicationIdByTypeByName() {
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        Opportunity tstOpportunity = testDataFactory.testOpportunity;
        Payment_Plan__c tstPaymentPlan = testDataFactory.testPaymentPlan;
        Test.startTest();
        PaymentPlansSelector pps = new PaymentPlansSelector();
        List<Payment_Plan__c> payplans = pps.selectByApplicationIdByTypeByName(tstOpportunity.Id, tstPaymentPlan.Type__c, tstPaymentPlan.Name, 1);
        //pps.selectByApplicationIdByTypeDetails('', '', 1);
        payplans = pps.selectByApplicationIdByTypeByName(tstOpportunity.Id, tstPaymentPlan.Type__c, tstPaymentPlan.Name, 1);
        System.assertNotEquals(payplans, null, '');
        Test.stopTest();
    }
     @isTest
    private static void testSelectByApplicationIdByTypeDetails() {
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        Opportunity tstOpportunity = testDataFactory.testOpportunity;
        Payment_Plan__c tstPaymentPlan = testDataFactory.testPaymentPlan;
        Test.startTest();
        PaymentPlansSelector pps = new PaymentPlansSelector();
        List<Payment_Plan__c> payplans = pps.selectByApplicationIdByTypeDetails(tstOpportunity.Id, '', 1);
        System.assertNotEquals(payplans, null, '');
        Test.stopTest();
    }
     @isTest
    private static void testselectByApplicationProductId() {
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        Opportunity tstOpportunity = testDataFactory.testOpportunity;
        Application_Product__c apcCovid = new Application_Product__c();
        apcCovid.Opportunity_Product_Id__c = tstOpportunity.id;
        apcCovid.Opportunity__c = tstOpportunity.id;
        apcCovid.Annual_Turnover__c = 11000000;
        apcCovid.Asset_Value__c = 200000000;
        apcCovid.IsMainProduct__c = true;
        insert apcCovid;
		Test.startTest();
        Payment_Plan__c tstPaymentPlan = testDataFactory.testPaymentPlan;
        PaymentPlansSelector pps = new PaymentPlansSelector();
        List<Payment_Plan__c> payplans = pps.selectByApplicationProductId(apcCovid.Id);
        System.assertNotEquals(payplans, null, '');
		Test.stopTest();

    }
    //Added By Himani Joshi

        @testSetup static void createData(){
        Opportunity opp = new Opportunity();
        opp.Name = 'EPP';
        opp.StageName = 'Not Interested';
        opp.CloseDate = Date.today() + 10;
        Insert opp;
        Contact testContact = new Contact();
        testContact.FirstName = 'Test Contact';
        testContact.LastName = '1';
        insert testContact;

        //Products
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
        oppLineItem.OpportunityId = opp.Id;
        oppLineItem.Product2Id = product1.Id;
        oppLineItem.PricebookEntryId = pricebookEntry1.Id;
        oppLineItem.Quantity = 1;
        oppLineItem.TotalPrice = 100;
        Insert oppLineItem;

        Application_Product__c testAppProdCred = new Application_Product__c();
        testAppProdCred.Opportunity_Product_Id__c = oppLineItem.Id;
        insert testAppProdCred;

        Case caseRecord=new Case();
        caseRecord.Status='New';
        caseRecord.Application_Product_Id__c=testAppProdCred.Id;
        caseRecord.Opportunity__c=opp.Id;
        caseRecord.ContactId=testContact.Id;
        insert caseRecord;

    }


    @isTest
    private static void testSelectByAppProductAndCaseNo(){
        Case cse=[select Id,casenumber from Case];
        Application_product__c app=[select Id from Application_product__c];
        test.startTest();
        System.assert(new PaymentPlansSelector().selectByAppProductAndCaseId(app.Id,cse.CaseNumber) != null);
        test.stopTest();
    }
}