/**
 * @description       : Test class for FulfillmentApplicationController
 * @author            : Danie Booysen
 * @last modified on  : 2021-12-08
 * @last modified by  : almas.aleem@absa.africa
 * Modifications Log 
 * Ver   Date         Author                            Modification
 * 1.0   2021-01-18   Danie Booysen   Initial Version
**/
@IsTest
public class FulfillmentApplicationControllerTest {

    @TestSetup
    static void makeData(){

        Account mainAccount = new Account(Name = 'Test Main Account');
        insert mainAccount;

        Opportunity opp = new Opportunity (Name ='testopp', AccountId = mainAccount.Id, StageName = 'New', CloseDate = system.today());
        insert opp;

        Service_Type__c serviceType = new Service_Type__c(Name = 'Test1', Case_Record_Type__c = 'New', Subtype__c = 'Sample', Type__c = 'T01');
        insert serviceType;

        BusinessHours businessHr = [SELECT Id FROM BusinessHours LIMIT 1];

        Service_Group__c serviceGr = new Service_Group__c(
            Name = 'Credit FulFilment Group',
            Assign_Record_Type__c = 'Email',
            Response_Email_Address__c = 'evg@t.com',
            Queue__c = 'Email',
            Business_Hours__c = businessHr.Id,
            Internal_SLA_Time_Measure__c = 'Hour(s)',
            Internal_SLA_Units__c = '8'
        );
        insert serviceGr;

        serviceGr = new Service_Group__c(
            Name = 'Credit Card FulFillment Group',
            Assign_Record_Type__c = 'Email',
            Response_Email_Address__c = 'evg@t.com',
            Queue__c = 'Email',
            Business_Hours__c = businessHr.Id,
            Internal_SLA_Time_Measure__c = 'Hour(s)',
            Internal_SLA_Units__c = '8'
        );
        insert serviceGr;

        Service_Level__c serviceLevel = new Service_Level__c(
            Name = 'Test1',
            External_SLA_Time_Measure__c = 'Hour(s)',
            External_SLA_Units__c = '8',
            Default_Service_Level__c = true
        );
        insert serviceLevel;

        Service_Group_Type__c serviceGrType = new Service_Group_Type__c(
            Service_Type__c = serviceType.Id,
            Service_Group__c = serviceGr.Id,
            Service_Level__c = serviceLevel.Id
        );
        insert serviceGrType;

        Account account = new Account(Name = 'Test Account');
        insert account;

        Contact contact = new Contact(LastName = 'Test contact', AccountId = account.Id, Email = 'agents@support.co.za');
        insert contact;

        AccountContactRelation accConnRel = new AccountContactRelation();
        accConnRel.AccountId = mainAccount.Id;
        accConnRel.ContactId = contact.Id;
        insert accConnRel;

        Application_Product__c parentApplicationRecord = new Application_Product__c();
        parentApplicationRecord.Opportunity__c = opp.Id;
        parentApplicationRecord.Product_Name__c = 'Cheque';
        parentApplicationRecord.Product_Type__c = '11021';//API picklist value for CLASSIC BUSINESS ACCOUNT
        parentApplicationRecord.Account_Number__c = 123456789;
        parentApplicationRecord.Product_State__c = 'New';
        parentApplicationRecord.Opportunity_Product_Id__c = '001';
        parentApplicationRecord.Product_Status__c = 'Accepted';
        parentApplicationRecord.Facility_account_number__c ='1232131';
        parentApplicationRecord.Product_Status__c = 'Accepted';
        parentApplicationRecord.Secured_By_Mortgage_Bond__c = true;
        parentApplicationRecord.Product_Amount__c = 12321;
        parentApplicationRecord.Requested_facility_limit__c = '340';
        parentApplicationRecord.Accept_TOB__c = true;
        insert parentApplicationRecord;

        Application_Product__c parentApplicationCC = new Application_Product__c();
        parentApplicationCC.Opportunity__c = opp.Id;
        parentApplicationCC.Product_Name__c = 'Credit Card';
        parentApplicationCC.Product_Type__c = '11021';//API picklist value for CLASSIC BUSINESS ACCOUNT
        parentApplicationCC.Account_Number__c = 123456789;
        parentApplicationCC.Product_State__c = 'New';
        parentApplicationCC.Opportunity_Product_Id__c = '001';
        parentApplicationCC.Product_Status__c = 'Accepted';
        parentApplicationCC.Accept_TOB__c = true;
        insert parentApplicationCC;

        Application_Product__c childApplicationRecord = new Application_Product__c();
        childApplicationRecord.Opportunity__c = opp.Id;
        childApplicationRecord.Product_Name__c = 'Overdraft';
        childApplicationRecord.Product_Amount__c = 10000.00;
        childApplicationRecord.Product_State__c = 'New';
        childApplicationRecord.Product_Status__c = 'Accepted';
        childApplicationRecord.Opportunity_Product_Id__c = '002';
        childApplicationRecord.Application_Product_Parent__c = parentApplicationRecord.Id;
        insert childApplicationRecord;

        String responseString = '{"IPlistNCARatesV1Response":{"ipb100o":{"ncaMaxfeeCfErr":"0000 - SUCCESS","ncaMaxfeeCfMaxsf":69,"ncaMaxfeeMaErr":"0000 - SUCCESS","ncaMaxfeeMaMaxsf":69,';
        responseString += '"ncaMaxfeeOcaErr":"0000 - SUCCESS","ncaMaxfeeOcaMaxsf":69,"ncaMaxfeeStctErr":"0000 - SUCCESS","ncaMaxfeeStctMaxsf":69,"ncaMaxfeeUctErr":"0000 - SUCCESS",';
        responseString += '"ncaMaxfeeUctMaxsf":69,"ncaMaxifeeCfErr":"0000 - SUCCESS","ncaMaxifeeCfFirst":189.75,"ncaMaxifeeCfMax":6050.5,"ncaMaxifeeCfNext":11.5,"ncaMaxifeeCfPerc":1000,';
        responseString += '"ncaMaxifeeMaErr":"0000 - SUCCESS","ncaMaxifeeMaFirst":1265,"ncaMaxifeeMaMax":6037.5,"ncaMaxifeeMaNext":11.5,"ncaMaxifeeMaPerc":10000,';
        responseString += '"ncaMaxifeeOcaErr":"0000 - SUCCESS","ncaMaxifeeOcaFirst":189.75,"ncaMaxifeeOcaMax":1207.5,"ncaMaxifeeOcaNext":11.5,"ncaMaxifeeOcaPerc":1000,';
        responseString += '"ncaMaxifeeStctErr":"0000 - SUCCESS","ncaMaxifeeStctFirst":189.75,"ncaMaxifeeStctMax":1207.5,"ncaMaxifeeStctNext":11.5,"ncaMaxifeeStctPerc":1000,';
        responseString += '"ncaMaxifeeUctErr":"0000 - SUCCESS","ncaMaxifeeUctFirst":189.75,"ncaMaxifeeUctMax":6040.5,"ncaMaxifeeUctNext":11.5,"ncaMaxifeeUctPerc":1000,';
        responseString += '"ncaMaxrateCfErr":"0000 - SUCCESS","ncaMaxrateCfMaxdr":20.75,"ncaMaxrateMaErr":"0000 - SUCCESS","ncaMaxrateMaMaxdr":19,"ncaMaxrateOcaErr":"0000 - SUCCESS",';
        responseString += '"ncaMaxrateOcaMaxdr":21,"ncaMaxrateStctErr":"0000 - SUCCESS","ncaMaxrateStctMaxdr":60,"ncaMaxrateUctErr":"0000 - SUCCESS","ncaMaxrateUctMaxdr":27.75,';
        responseString += '"primeRate":6.25,"primeRateErr":"0000 - SUCCESS","repurchaseRate":7,"repurchaseRateErr":"0000 - SUCCESS"},"nbsapdpo":{"reasonCode":0,"returnCode":0,';
        responseString += '"serviceVersion":"BUSO001"},"nbsmsgo3":{"nbrUserErrs":0,"nbrUserMsgs":0,"version":"MSG3001"}}}';
        Application__c testApplication = new Application__c();
        testApplication.Opportunity__c = opp.Id;
        testApplication.Preferred_Communication_Method__c='himanshu.nimje@absa.africa';
        testApplication.Preferred_SMS__c='065892600';
        testApplication.Preferred_Communication_Method__c='Email';
        testApplication.Fees_Waived__c = true;
        testApplication.Products_And_Services__c = 'NotifyMe';
        testApplication.AIPS__c = responseString;
        insert testApplication;

        Security_Offered__c security = new Security_Offered__c();
        security.Application__c = testApplication.Id;
        security.Security_Type__c = 'Bonds';
        insert security;
        SetProductTOBController.insertTob(parentApplicationRecord.Id);
    }

    @isTest
    static void testGetClientData(){

        Opportunity testOpportunity = [SELECT Id FROM Opportunity WHERE Name = 'testopp' LIMIT 1];
        List<FulfillmentApplicationController.ClientDataWrapper> clientWrapperListTest = FulfillmentApplicationController.getClientData(testOpportunity.Id);
        System.assertNotEquals(0, clientWrapperListTest.size());
    }

    @isTest
    static void testGetSecuritiesOfferedData(){

        Opportunity testOpportunity = [SELECT Id FROM Opportunity WHERE Name = 'testopp' LIMIT 1];
        List<Security_Offered__c> securitiesOfferedListTest = FulfillmentApplicationController.getSecuritiesOfferedData(testOpportunity.Id);
        System.assertNotEquals(0, securitiesOfferedListTest.size());
    }
    @isTest
    static void testgetUpdatedCompliance(){

        Opportunity testOpportunity = [SELECT Id FROM Opportunity WHERE Name = 'testopp' LIMIT 1];
        Boolean checkboxValue1 = FulfillmentApplicationController.getUpdatedCompliance(testOpportunity.Id,true);
        Boolean checkboxValue2 = FulfillmentApplicationController.getUpdatedCompliance(testOpportunity.Id,false);
        System.assertNotEquals(null, checkboxValue1);
        System.assertNotEquals(null, checkboxValue2);
    }

    @isTest
    static void testGetCreditProductData(){

        Opportunity testOpportunity = [SELECT Id FROM Opportunity WHERE Name = 'testopp' LIMIT 1];

        FulfillmentApplicationController.fetchUser(testOpportunity.id);
        Map<String, List<FulfillmentApplicationController.ProductDataWrapper>> applicationProductListMapTest = FulfillmentApplicationController.getCreditProductData(testOpportunity.Id);
        System.assertNotEquals(0, applicationProductListMapTest.size());
    }

    @isTest
    static void testCreateFulfillmentCase(){
        Opportunity testOpportunity = [SELECT Id FROM Opportunity WHERE Name = 'testopp' LIMIT 1];
        testOpportunity.Pricing_Refer_DateTime__c = System.now();
        update testOpportunity;
        String response = FulfillmentApplicationController.createFulfillmentCase(testOpportunity.Id);
        Application_Product__c testApplicationProd = [SELECT Id,Product_Name__c, Product_State__c, Temp_Account_Number__c, Product_Status__c ,Account_Number__c,Secured_By_Mortgage_Bond__c,Product_Amount__c,Business_Credit_Card_Sub_Product_Type__c ,NCA_Appplicable__c  FROM Application_Product__c WHERE Product_Name__c = 'Cheque' LIMIT 1];

       // FulfillmentApplicationController.createFulfillmentCaseLDP(testOpportunity.id,testApplicationProd.id);     
        FulfillmentApplicationController.getCCWrapper(testApplicationProd);
        FulfillmentApplicationController.getODWrapper(testApplicationProd);     
        
        System.assertEquals('Success', response);
    }
    
    @isTest
    static void testCreateLDPFulfillmentCase(){
        Opportunity testOpportunity = [SELECT Id FROM Opportunity WHERE Name = 'testopp' LIMIT 1];
        Application_Product__c testApplicationProd = [SELECT Id,Product_Name__c, Product_State__c, Temp_Account_Number__c, Product_Status__c ,Account_Number__c,Secured_By_Mortgage_Bond__c,Product_Amount__c,Business_Credit_Card_Sub_Product_Type__c ,NCA_Appplicable__c  FROM Application_Product__c WHERE Product_Name__c = 'Cheque' LIMIT 1];

        FulfillmentApplicationController.createFulfillmentCaseLDP(testOpportunity.id,testApplicationProd.id);
        FulfillmentApplicationController.getLDPWrapper(testApplicationProd);
        FulfillmentApplicationController.getCreditProductData(testOpportunity.id);
      
        
        System.assertNotEquals(null, testApplicationProd);
    }

    @isTest
    static void testgetRequiredDocs(){
        Opportunity testOpportunity = [SELECT Id FROM Opportunity WHERE Name = 'testopp' LIMIT 1];
        List<Signed_Documents_Checklist__mdt> docs = FulfillmentApplicationController.getRequiredDocs(testOpportunity.Id);
        System.assertNotEquals(0, docs.size());
    }
}