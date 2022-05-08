/**
 * @description       : 
 * @author            : Gulafsha
 * @last modified on  : 2021-07-13
 * @last modified by  : Gulafsha
 * Modifications Log 
 * Ver   Date         Author     Modification
 * 1.0   2021-07-13   Gulafsha   Initial Version
**/
@isTest
public class ConditionOfGrantReadOnlyConTest {
    /**
    * @description 
    * @author Gulafsha | 2021-07-13 
    **/
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
    @isTest 
    public static void testCalculations() {
        
        Account account1 = new Account();
        account1.Name = 'Test Account0011';
        account1.Client_Type__c = 'Private Individual';
        account1.CIF__c = 'Test+020';
        insert account1;  
        
        Opportunity oppCovid1 = new Opportunity();
        oppCovid1.Name = 'Covid Onboarding';
        oppCovid1.CloseDate = Date.today();
        oppCovid1.StageName = 'New';
        oppCovid1.AccountId = account1.Id;
        insert oppCovid1;
        
        
        Application_Product__c apcCovid = new Application_Product__c();
        apcCovid.Opportunity_Product_Id__c = oppCovid1.id;
        apcCovid.Opportunity__c = oppCovid1.id;
        apcCovid.Annual_Turnover__c = 11000000;
        apcCovid.Asset_Value__c = 200000000;
        apcCovid.Account_Number__c = Long.valueOf('3001537899');
        apcCovid.IsMainProduct__c = true;
        
        List<Application_Product__c> appProd = new List<Application_Product__c>();
        appProd.add(apcCovid);
        insert appProd;
        
        Application__c  appcovid = new Application__c();
        appcovid.Opportunity__c = oppCovid1.id;
        appcovid.Title__c = 'Dr';
        appcovid.FirstNameSignature__c = 'Rob';
        appcovid.SurnameSignature__c = 'Robbello';
        appcovid.Signing_Date__c = System.today();
        insert appcovid;
        test.startTest();
        
        Application_Condition__c apcond= new Application_Condition__c();
        apcond.Application__c=appcovid.id;
        apcond.Category__c ='Custom';
        apcond.Comment__c='comment';
        apcond.Condition__c='Free text field only';
        apcond.Type__c ='Customer Condition';
        insert apcond;
        
        List<String> Values=new List<String>();
        Values.add('Yes');
        Values.add('Yes');
        Values.add('Yes');
        Values.add('Yes');
        Values.add('Yes');
        Values.add('Yes');
        Values.add('No');
        Security_Offered__c sc1=new Security_Offered__c();
        sc1.Account__c=oppCovid1.AccountId;
        sc1.Physical_Address_line_1__c=null;
        sc1.Security_Type__c = 'Bonds and 99-year Leasehold';
        sc1.bond_type__c ='CESSBOND - CESSION OF EXTERNAL BOND';
        sc1.Specific_Security__c ='No';
        insert sc1;
        
        ConditionOfGrantReadOnlyCon.getApplicationDetails(oppCovid1.id);
        ConditionOfGrantReadOnlyCon.getApplicationConditions(oppCovid1.id);
        ConditionOfGrantReadOnlyCon.deleteApplicationConditions(apcond.id);
        ConditionOfGrantReadOnlyCon.getApplicationConditionsRecordTypes();
        ConditionOfGrantReadOnlyCon.saveCoP(values, oppCovid1.id);
        ConditionOfGrantReadOnlyCon.getApplicationConditionPrecedent(oppCovid1.id);
        ConditionOfGrantReadOnlyCon.saveSpecialCondition(values,oppCovid1.id,'ShareholderDirectorVal','ExternalCOG','InternalCOG');
        ConditionOfGrantReadOnlyCon.getSpecialCondition(oppCovid1.id);
        ConditionOfGrantReadOnlyCon.getSecuritiesOffered(oppCovid1.id);
        
        List<Security_Offered__c> updateSOList = new List<Security_Offered__c>();
        sc1.Other_Securities__c='abcdef';
        updateSOList.add(sc1);
        ConditionOfGrantReadOnlyCon.saveOSec(updateSOList);
        
        Account accRecord=new account();
        accRecord.Name='Test Acc1114';
        insert accRecord;

        Account accRecord2=new account();
        accRecord2.Name='Test Acc2';
        insert accRecord2;

        contact conRecord=new contact();
        conRecord.AccountId=oppCovid1.accountid;
        conrecord.lastname='TestCon1114';
        insert conRecord;
        AccountContactRelation acr = new AccountContactRelation(); 
        acr.Accountid = accRecord2.id;
        acr.Contactid = conRecord.id;
        insert acr;
        ConditionOfGrantReadOnlyCon.getRelatedParties(oppCovid1.Id);
        System.assert(acr != null);
        Test.stopTest();
    }
    
}