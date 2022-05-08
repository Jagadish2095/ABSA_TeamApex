/**
* Test Class For QuotesAgreementsAdditionalDetailsCTRL 
*
* @author  Gulafsha 
* @since   2020-12-03
* UserStory W-008016
*/
@isTest
public class QuotesAgreementsAdditionalDetCTRLTest {
@testSetup
    public static void dataCreation() {
       
        
        insertUser();
        
       Account account = new Account();
        account.Name = 'Test Account001';
        account.Client_Type__c = 'Private Individual';
        account.CIF__c = 'Test+001';
        insert account;
        
        Contact testContact = new Contact();
        testContact.FirstName = 'Test Contact';
        testContact.LastName = '1';
        insert testContact; 
        
        Opportunity oppCovid = new Opportunity();
        oppCovid.Name = 'Covid Onboarding';
        oppCovid.CloseDate = Date.today();
        oppCovid.StageName = 'New';
        oppCovid.AccountId = account.Id;
        insert oppCovid;
        
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
        oppLineItem.OpportunityId = oppCovid.id;
        oppLineItem.Product2Id = prod.id;
        oppLineItem.PricebookEntryId = customPrice.id;
        oppLineItem.Quantity = 1;
        oppLineItem.TotalPrice = 100;
        insert oppLineItem;
        
         Application__c  appcovid = new Application__c();
        appcovid.Opportunity__c = oppCovid.id;
        appcovid.Title__c = 'Dr';
        appcovid.FirstNameSignature__c = 'Rob';
        appcovid.SurnameSignature__c = 'Robbello';
        appcovid.Signing_Date__c = System.today();
        insert appcovid;
        
        String abfupdateStatusResponse= '{"nbsapdpo": {"version": null,"returnCode": "0","reasonCode": "0","serviceVersion": "BUSO001","echoKey": null},"nbsmsgo3": {"version": "MSG3001","sysErrTxt": null,"nbrUserMsgs": "1","nbrUserErrs": "1","msgEntry": [{"msgClass": "PLSMGC01","msgCode": "0020","msgErrInd": "E","msgTxt": "Account status is invalid"}]},"plpa03o": {"mandateNbr": "0","contractSignedInd": null,"contractSignIndUpdbl": null,"payMethodReqInd": null,"cessionPledgeInd": null,"autoSettlementInd": null,"autoSettleIndUpdbl": null,"creditLifeInd": null,"creditLifeIndUpdbl": null,"landlordWaiverInd": null,"insuranceInd": null,"elecTransferInd": null,"elecTransferIndUpdbl": null}}';

        Application_Product__c apcCovid = new Application_Product__c();
        apcCovid.Opportunity_Product_Id__c = oppCovid.id;
        apcCovid.Opportunity__c = oppCovid.id;
        apcCovid.Annual_Turnover__c = 11000000;
        apcCovid.Asset_Value__c = 200000000;
        apcCovid.Account_Number__c = Long.valueOf('3001537899');
        apcCovid.IsMainProduct__c = true;
        apcCovid.ABFupdAccountDetails_Response__c = abfupdateStatusResponse;
        insert apcCovid;
        
        BusinessHours bh = [SELECT Id, Name FROM BusinessHours where Name = '24 Hours including Public Holidays'];
        User u = [SELECT Id, UserRoleId FROM User LIMIT 1];
        
        Case caseRec = new Case();
        caseRec.BusinessHoursId = bh.Id;
        caseRec.Subject = 'Test Case';
        caseRec.AccountId = account.Id;
        caseRec.Banker_RE__c = u.UserRoleId;
        caseRec.ContactId=testContact.Id;
        caseRec.Application_Product_Id__c = apcCovid.Id;
        
        insert caseRec;
       
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ABFupdConditionsOfAgreement_IH_v1.INTEGRATION_SERVICE_NAME});
        
        
    }
    
    @future
    private static void insertUser() {
        Profile p = [SELECT Id FROM Profile WHERE Name LIKE '%Banker%' LIMIT 1];
        UserRole r = [SELECT Id, Name FROM UserRole WHERE DeveloperName = 'Banker'];
        
        User futureUser = new User(
            ProfileId = p.Id,
            LastName = 'last',
            Email = 'puser000@amamama.com',
            Username = 'puser000@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            SiteCode__c = '8198',
            SiteType__c = '034',
            Teller_Operator_Code__c = '12345',
            Supervisor__c = '0',
            Division__c = 'RBB',
            UserRoleId = r.Id
        );
        insert(futureUser);
    }
     public static testMethod void testCalculations() {
         
         Account account1 = new Account();
         account1.Name = 'Test Account0011';
         account1.Client_Type__c = 'Private Individual';
         account1.CIF__c = 'Test+020';
         insert account1;  
         
          Contact testContact1 = new Contact();
        testContact1.FirstName = 'Test Contact';
        testContact1.LastName = '1';
        insert testContact1; 
         
         Opportunity oppCovid1 = new Opportunity();
         oppCovid1.Name = 'Covid Onboarding';
         oppCovid1.CloseDate = Date.today();
         oppCovid1.StageName = 'New';
         oppCovid1.AccountId = account1.Id;
         insert oppCovid1;
         Product2 prod = new Product2(Name = 'Cheque Product', Family = 'Cheque');
        insert prod;
          String abfupdateStatusResponse= '{"nbsapdpo": {"version": null,"returnCode": "0","reasonCode": "0","serviceVersion": "BUSO001","echoKey": null},"nbsmsgo3": {"version": "MSG3001","sysErrTxt": null,"nbrUserMsgs": "1","nbrUserErrs": "1","msgEntry": [{"msgClass": "PLSMGC01","msgCode": "0020","msgErrInd": "E","msgTxt": "Account status is invalid"}]},"plpa03o": {"mandateNbr": "0","contractSignedInd": null,"contractSignIndUpdbl": null,"payMethodReqInd": null,"cessionPledgeInd": null,"autoSettlementInd": null,"autoSettleIndUpdbl": null,"creditLifeInd": null,"creditLifeIndUpdbl": null,"landlordWaiverInd": null,"insuranceInd": null,"elecTransferInd": null,"elecTransferIndUpdbl": null}}';

         BusinessHours bh = [SELECT Id, Name FROM BusinessHours where Name = '24 Hours including Public Holidays'];
        User u = [SELECT Id, UserRoleId FROM User LIMIT 1];
         
         Id pricebookId = Test.getStandardPricebookId();

        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id, UnitPrice = 10000, IsActive = true);
        insert standardPrice;

        Pricebook2 customPB = new Pricebook2(Name='Standard Pricebook', isActive=true);
        insert customPB;

        PricebookEntry customPrice = new PricebookEntry(Pricebook2Id = customPB.Id, Product2Id = prod.Id, UnitPrice = 12000, IsActive = true);
        insert customPrice;
        
        OpportunityLineItem oppLineItem = new OpportunityLineItem();
        oppLineItem.OpportunityId = oppCovid1.id;
        oppLineItem.Product2Id = prod.id;
        oppLineItem.PricebookEntryId = customPrice.id;
        oppLineItem.Quantity = 1;
        oppLineItem.TotalPrice = 100;
        insert oppLineItem;
        
         Application__c  appcovid = new Application__c();
        appcovid.Opportunity__c = oppCovid1.id;
        appcovid.Title__c = 'Dr';
        appcovid.FirstNameSignature__c = 'Rob';
        appcovid.SurnameSignature__c = 'Robbello';
        appcovid.Signing_Date__c = System.today();
        insert appcovid;
         Application_Product__c apcCovid = new Application_Product__c();
         apcCovid.Opportunity_Product_Id__c = oppCovid1.id;
         apcCovid.Opportunity__c = oppCovid1.id;
         apcCovid.Annual_Turnover__c = 11000000;
         apcCovid.Asset_Value__c = 200000000;
         apcCovid.Account_Number__c = Long.valueOf('3001537899');
         apcCovid.IsMainProduct__c = true;
         apcCovid.ABFupdAccountDetails_Response__c = abfupdateStatusResponse;
         
         List<Application_Product__c> appProd = new List<Application_Product__c>();
         appProd.add(apcCovid);
         insert appProd;
         Case caseRec1 = new Case();
        caseRec1.BusinessHoursId = bh.Id;
        caseRec1.Subject = 'Test Case';
        caseRec1.AccountId = account1.Id;
        caseRec1.Banker_RE__c = u.UserRoleId;
        caseRec1.ContactId=testContact1.Id;
        caseRec1.Application_Product_Id__c = appProd[0].Id;
        
        insert caseRec1;
         
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING,  '{     "messageHeaders": {         "outPutMessageHeaders": {             "serviceVersion": "BUSO002",             "returnCode": 0,             "reasonCode": 0         }     },     "messageErrors": {         "outPutMessageErrors": {             "sysErrorText": "",             "nbrUserMessages": 1,             "MessageEntryTabel": [                 {                     "messageText": "Account is already current",                     "messageErrorInd": "E",                     "messageClass": "PLSMGC01",                     "messageCode": "0021"                 },                 {                     "messageText": "",                     "messageErrorInd": "",                     "messageClass": "",                     "messageCode": ""                 },                 {                     "messageText": "",                     "messageErrorInd": "",                     "messageClass": "",                     "messageCode": ""                 },                 {                     "messageText": "",                     "messageErrorInd": "",                     "messageClass": "",                     "messageCode": ""                 },                 {                     "messageText": "",                     "messageErrorInd": "",                     "messageClass": "",                     "messageCode": ""                 }             ],             "nbrUserErrors": 1,             "version": ""         }     } }'));
      case cs = [SELECT Id,Application_Product_Id__c FROM case WHERE Subject = 'Test Case' LIMIT 1];
       Test.startTest();
       String service1 = QuotesAgreementsAdditionalDetailsCTRL.getCalculateQuotesService1(oppCovid1.Id ,'20201103','TLN','Y', 
                                                    '000' ,'Y','Y','','','','','',''); 
       System.assert(service1 != null);
       String service2 = QuotesAgreementsAdditionalDetailsCTRL.getCalculateQuotesService2(oppCovid1.Id ,'20201103','Y', 
                                                    '000' ,'Y','Y'); 
       System.assert(service2 != null);
       String service3 = QuotesAgreementsAdditionalDetailsCTRL.getCalculateQuotesService3(oppCovid1.Id);
       System.assert(service3 != null);
       String service4 = QuotesAgreementsAdditionalDetailsCTRL.getCalculateQuotesService4(oppCovid1.Id ,'21','003'); 
       System.assert(service4 != null);
            //QuotesAgreementsAdditionalDetai lsCTRL.getAppProduct (caseRec1.Id);       
        
        Test.stopTest();
    }

}