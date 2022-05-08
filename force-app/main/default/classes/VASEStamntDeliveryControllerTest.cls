/**
 * @description       : VASEStamntDeliveryControllerTest
 * @author            : Khaliq Abdul
 * @last modified on  : 2021-06-24
 * @last modified by  : André Pietersen (IQ Business)
 * Modifications Log
 * Ver   Date         Author                          Modification
 * 1.0   2021-06-24   André Pietersen (IQ Business)   Initial Version
**/
@isTest
public class VASEStamntDeliveryControllerTest {
    public static final String POSITIVE_RESPONSE_BODY = '{"EImaintainESDDetailsV3_Resp_IB_v1":{"outTransferred": 2,"msgNo": 200,"msg":"Succesfully got Client Details"}}';

    @testSetup
    static void makeData() {
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{EImaintainESDDetailsV3_IH_v2.INTEGRATION_SERVICE_NAME});

        Profile profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator (Custom)'];

        User sysAdminUser = new User();
        sysAdminUser.FirstName = 'actest';
        sysAdminUser.LastName = 'last_test';
        sysAdminUser.Email = 'testSf@test.com';
        sysAdminUser.Phone = '111-111-1111';
        sysAdminUser.Alias = 'test';
        sysAdminUser.EmailEncodingKey = 'UTF-8';
        sysAdminUser.ProfileId = profile.Id;
        sysAdminUser.LanguageLocaleKey = 'en_US';
        sysAdminUser.LocaleSidKey = 'en_US';
        sysAdminUser.TimeZoneSidKey = 'America/Los_Angeles';
        sysAdminUser.UserName = 'sftestCase@test.com';
        sysAdminUser.IsActive = true;
        insert sysAdminUser;

        Product2 prod = new Product2(Name = 'Cheque Product', Family = 'Cheque', ProductCode = '11032');
        insert prod;

        Pricebook2 pb = new Pricebook2();
        pb.IsActive=true;
        pb.id =test.getStandardPricebookId();
        update pb;
        PricebookEntry customPrice = new PricebookEntry(Pricebook2Id = pb.Id, Product2Id = prod.Id, UnitPrice = 12000, IsActive = true);
        insert customPrice;

        Account acc = new Account();
        acc.FirstName='First test';
        acc.LastName='last test';
        acc.CIF__c='LTD 933';
        acc.Language__c='english';
        acc.Number_Of_Dependents__c=0;
        acc.PersonEmail='test@absa.africa';
        acc.Phone='0819908786';
        insert acc;

        site__c siteRec=new site__c();
        siteRec.Site_Code__c='1334';
        siteRec.Name='Test';
        insert siteRec;

        Opportunity opp = new Opportunity();
        opp.Name = 'Test Opp Onboarding';
        opp.CloseDate = Date.today();
        opp.StageName = 'New';
        opp.Pricebook2Id=pb.id;
        opp.AccountId=acc.id;
        opp.Site__c=siteRec.id;
        insert opp;

        Application__c app= new Application__c();
        app.Opportunity__c=opp.id;
        app.Source_of_Funds_Savings__c='27	ALLOWANCE';
        app.Electronic_Statements__c=false;
        insert app;

        OpportunityLineItem oppLineItem = new OpportunityLineItem();
        oppLineItem.OpportunityId = opp.id;
        oppLineItem.Product2Id = prod.id;
        oppLineItem.PricebookEntryId = customPrice.id;
        oppLineItem.Quantity = 1;
        oppLineItem.TotalPrice = 100;
        oppLineItem.Policy_Number__c='4048272164';
        insert oppLineItem;
    }

    @isTest
    public static void testgetEStamntDeliveryPositive() {
        Opportunity opp = [SELECT Id, Name FROM Opportunity WHERE Name = 'Test Opp Onboarding'];
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
        Test.startTest();
        EImaintainESDDetailsV3_Resp_IB_v1 resp = VASEStamntDeliveryController.getEStamntDelivery(opp.Id, true, 'Cheque');
        System.assert(resp != null, 'Test Successful');
        Test.stopTest();
    }

    @isTest
    public static void testgetEStamntDeliveryNegative() {
        Opportunity opp = [SELECT Id, Name FROM Opportunity WHERE Name = 'Test Opp Onboarding'];
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
        Test.startTest();
        EImaintainESDDetailsV3_Resp_IB_v1 resp = VASEStamntDeliveryController.getEStamntDelivery(opp.Id, false, 'Cheque');
        System.assert(resp != null, 'Test Successful');
        Test.stopTest();
    }
}