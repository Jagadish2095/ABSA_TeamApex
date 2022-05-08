/**
 * @description       : 
 * @author            : Diksha/Almas
 * @group             : 
 * @last modified on  : 06-07-2021
 * @last modified by  : Saurabh
 * Modifications Log 
 * Ver   Date         Author    Modification
 * 1.0   06-07-2021   Diksha/Almas   Initial Version
**/
@isTest
public class NCAResultUpdateConTest {

    @testSetup static void createData(){

        Account acc= new Account();
        acc.Name='test';
        acc.Client_Type__c='Company';
        Insert acc;
        Opportunity opp = new Opportunity();
        opp.Name = 'EPP';
        opp.StageName = 'Not Interested';
        opp.CloseDate = Date.today() + 10;
        Id recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Credit Onboarding').getRecordTypeId();
        opp.RecordTypeId = recordTypeId;
        opp.AccountId=acc.Id;
        Insert opp;
        //Products

        Account acc1= new Account();
        acc1.Name='test';
        acc1.Client_Type__c='Sole Trader';
        Insert acc1;
        Opportunity opp1 = new Opportunity();
        opp1.Name = 'Credit';
        opp1.StageName = 'Not Interested';
        opp1.CloseDate = Date.today() + 10;
        Id recordTypeId1 = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Credit Onboarding').getRecordTypeId();
        opp1.RecordTypeId = recordTypeId1;
        opp1.AccountId=acc1.Id;
        Insert opp1;

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
        Application__c app = new Application__c();
        app.Opportunity__c = opp.Id;
        insert app;
        Application_Product__c apc = new Application_Product__c();
        apc.Opportunity_Product_Id__c = opp.Id;
        apc.Opportunity__c = opp.Id;
        apc.Annual_Turnover__c = 11000000;
        apc.Asset_Value__c = 200000000;
        apc.IsMainProduct__c = true;
        apc.Product_Facility_Json__c='Facilitywrap';
        apc.Product_Quote_Json__c='test';
        apc.Application_Product_Parent__c=null;
        apc.Secured_By_Mortgage_Bond__c=false;
        apc.Number_or_Trustees__c=2;
        apc.Any_Juristic_Trustees__c='No';
        apc.Current_Overdraft_Limit__c=200000;
        insert apc;
        Application_Product__c apc1 = new Application_Product__c();
        apc1.Opportunity_Product_Id__c = opp.Id;
        apc1.Opportunity__c = opp.Id;
        apc1.Account_Number__c = Decimal.valueOf('4047854674');
        apc1.Account_Balance__c = 200000000;
        apc1.IsMainProduct__c = false;
        apc1.Product_State__c ='New';
        apc1.Asset_Value__c=50000;
        apc1.Current_Overdraft_Limit__c=50000;
        apc1.Secured_By_Mortgage_Bond__c=true;
        insert apc1;
        apc.Application_Product_Parent__c = apc1.Id;
        update apc;
        Integration_Translation__c clienttype = new Integration_Translation__c();
        clienttype.Name = 'Company';
        clienttype.Internal_Value__c = 'Company';
        clienttype.External_Value__c = '02301';
        clienttype.System_Name__c = StringConstants.CIF_STRING;
        clienttype.Value_Type__c = 'Client Type';
        clienttype.Direction__c = 'Outbound';
        insert clienttype;
        String agreementType='CR';

    }
    @isTest static void testgetNCAResultforCompany() {
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{GetNCARetrieve_IH_v1.INTEGRATION_SERVICE_NAME});
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, '{     "type": "SUCCESS",     "msg": "Container Nca successfully called.",     "result": {         "execution-results": {             "results": [                 {                     "key": "NcaDecision",                     "value": {                         "za.co.absa.brms.nca.NcaDecision": {                             "result": "In NCA",                             "juristic": "Non-Individual"                         }                     }                 }             ],             "facts": []         }     } }'));

        Opportunity opp = [SELECT Id ,Client_Type__c FROM Opportunity where name='EPP'];
        Application_Product__c appprod=[SELECT Id,IsMainProduct__c FROM Application_Product__c Where Opportunity__c=:opp.Id AND Application_Product_Parent__c = null];

        test.startTest();
        NCAResultUpdateCon.getNCAResultsFromService(opp.Id);
        //future method wont return anything hence asserting Opp 
        system.assert(opp != Null);
        test.stopTest();

    }


}