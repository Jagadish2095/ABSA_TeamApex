/*
 *  1.3	 06-09-2021   Brian Maswanganyi 				add test to pull request
 */
@isTest
public class SVcreateLinkSavingsDepAccount_IH_v2_Test {
  	
    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{'SVcreateLinkSavingsNoticeDepAccountV6'});
    } 
    
    @isTest static void testPositive() {
         Account account = new Account();
        account.Name = 'Test Account';
        insert account;
        Contact contact = new Contact(LastName='Test contact', AccountId = account.Id, Email = 'agents@support.co.za');
        insert contact;
        Opportunity testOpp = new Opportunity();
        testOpp.Name = 'Test Opp Onboarding 1';
        testOpp.CloseDate = Date.today();
        testOpp.StageName = 'New';
        testOpp.AccountId=account.Id;
        // testOpp.Site__c='Test';
        insert testOpp;

        Product2 prod = new Product2(Name = 'Cheque Product', Family = 'Cheque');
        insert prod;

        Id pricebookId = Test.getStandardPricebookId();

        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id, UnitPrice = 10000, IsActive = true);
        insert standardPrice;

        Pricebook2 customPB = new Pricebook2(Name='Standard Pricebook', isActive=true);
        insert customPB;

        PricebookEntry customPrice = new PricebookEntry(Pricebook2Id = customPB.Id, Product2Id = prod.Id, UnitPrice = 12000, IsActive = true);
        insert customPrice;

        OpportunityLineItem oppLineItem = new OpportunityLineItem();
        oppLineItem.OpportunityId = testOpp.id;
        oppLineItem.Product2Id = prod.id;
        oppLineItem.PricebookEntryId = customPrice.id;
        oppLineItem.Quantity = 1;
        oppLineItem.TotalPrice = 100;
        insert oppLineItem;
        String pOSITIVERESPONSEBODY = '{"SVcreateLinkSavingsNoticeDepAccountV6Response": {"nbsapdpo": {"echoKey": null,"reasonCode": 0,"returnCode": 0,"serviceVersion": "BUSO006","version": null},        "nbsmsgo3": {"nbrUserErrs": 0,"nbrUserMsgs": 0,"sysErrTxt": null,"version": null},"svpp15o": {"accountNumber": 9051373299}}}';
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, pOSITIVERESPONSEBODY));
        
        
        Test.startTest();
        
        SVcreateLinkSavingsDepAccount_Resp_IB_v2 resp = SVcreateLinkSavingsDepAccount_IH_v2.callToSVcreateLinkSavingsDepAccount(testOpp.Id, oppLineItem.Id, '', '', '', '', '', '');
        SVcreateLinkSavingsDepAccount_Req_IB_v2.createDummyRequest();
        SVcreateLinkSavingsDepAccount_Resp_IB_v2.createDummyResponse();
        System.assertNotEquals('',resp.serialize(resp));
        Test.stopTest();
    }
    
     @isTest static void testNegative() {
         Account account = new Account();
        account.Name = 'Test Account';
        insert account;
        Contact contact = new Contact(LastName='Test contact', AccountId = account.Id, Email = 'agents@support.co.za');
        insert contact;
        Opportunity testOpp = new Opportunity();
        testOpp.Name = 'Test Opp Onboarding 1';
        testOpp.CloseDate = Date.today();
        testOpp.StageName = 'New';
        testOpp.AccountId=account.Id;
        // testOpp.Site__c='Test';
        insert testOpp;

        Product2 prod = new Product2(Name = 'Cheque Product', Family = 'Cheque');
        insert prod;

        Id pricebookId = Test.getStandardPricebookId();

        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id, UnitPrice = 10000, IsActive = true);
        insert standardPrice;

        Pricebook2 customPB = new Pricebook2(Name='Standard Pricebook', isActive=true);
        insert customPB;

        PricebookEntry customPrice = new PricebookEntry(Pricebook2Id = customPB.Id, Product2Id = prod.Id, UnitPrice = 12000, IsActive = true);
        insert customPrice;

        OpportunityLineItem oppLineItem = new OpportunityLineItem();
        oppLineItem.OpportunityId = testOpp.id;
        oppLineItem.Product2Id = prod.id;
        oppLineItem.PricebookEntryId = customPrice.id;
        oppLineItem.Quantity = 1;
        oppLineItem.TotalPrice = 100;
        insert oppLineItem;
        String nEGETIVERESPONSEBODY = '{"SVcreateLinkSavingsNoticeDepAccountV6Response": {"nbsapdpo": {"echoKey": null,"reasonCode": 0,"returnCode": 0,"serviceVersion": "BUSO006","version": null},        "nbsmsgo3": {"nbrUserErrs": 1,"nbrUserMsgs": 0,"sysErrTxt": null,"version": null},"svpp15o": {"accountNumber": 0}}}';
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, nEGETIVERESPONSEBODY));
        
        
        Test.startTest();
        
        SVcreateLinkSavingsDepAccount_Resp_IB_v2 resp = SVcreateLinkSavingsDepAccount_IH_v2.callToSVcreateLinkSavingsDepAccount(testOpp.Id, oppLineItem.Id, '', '', '', '', '', '');
        SVcreateLinkSavingsDepAccount_Req_IB_v2.createDummyRequest();
        System.assertEquals(0,resp.SVcreateLinkSavingsNoticeDepAccountV6Response.svpp15o.accountNumber);
        Test.stopTest();
    }
}