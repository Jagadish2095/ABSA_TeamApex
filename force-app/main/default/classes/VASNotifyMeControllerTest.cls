/**
 * @description       : VASNotifyMeControllerTest
 * @author            : Satya boyenepalli(ABSA)
 * @last modified on  : 2021-06-24
 * @last modified by  : André Pietersen (IQ Business)
 * Modifications Log
 * Ver   Date         Author                          Modification
 * 1.0   2021-06-23   André Pietersen (IQ Business)   Initial Version
**/
@isTest
public with sharing class VASNotifyMeControllerTest{
    public static final String POSITIVE_RESPONSE_BODY = '{"NQlistRecipientsRegForCustV1_Resp_IB_v1":{"outTransferred": 2,"msgNo": 200,"msg":"Succesfully got Client Reg Details"}}';
    public static final String POSITIVE_RESPONSE_BODY_2 = '{"NQcreateNewOrAddRecipientV2Response":{"nbsapdpo":{"returnCode":"0","reasonCode":"0","serviceVersion":"BUSO001"},"nbsmsgo":{"version":"MSGO003","nbrUserMsgs":"1","nbrUserErrs":"1","msgEntry":{"msgClass":"NQSMGC01","msgCode":"9002","msgErrInd":"E","msgTxt":"The details are already recorded."}},"nqp906o":{"rcode":"9002","pnsRecipientIdO":"1"}}}';

    @testSetup
    static void makeData() {
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{NQlistRecipientsRegForCustV1_IH_v1.INTEGRATION_SERVICE_NAME});
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{NQcreateneworaddrecipientv22_IH_v1.INTEGRATION_SERVICE_NAME});

        Profile profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator (Custom)'];
        User sysAdminUser = new User();
        sysAdminUser.FirstName = 'actest';
        sysAdminUser.LastName = 'notifyme lasttest';
        sysAdminUser.Email = 'notifyme@test.com';
        sysAdminUser.Phone = '111-111-1111';
        sysAdminUser.Alias = 'test';
        sysAdminUser.EmailEncodingKey = 'UTF-8';
        sysAdminUser.ProfileId = profile.Id;
        sysAdminUser.LanguageLocaleKey = 'en_US';
        sysAdminUser.LocaleSidKey = 'en_US';
        sysAdminUser.TimeZoneSidKey = 'America/Los_Angeles';
        sysAdminUser.UserName = 'notifyme@test.com';
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
        acc.FirstName='notifymetest';
        acc.LastName='notifyme test';
        acc.CIF__c='WILLECW004';
        acc.Language__c='english';
        acc.Number_Of_Dependents__c=0;
        acc.PersonEmail='test@absa.africa';
        acc.Phone='0726631180';
        insert acc;

        site__c siteRec=new site__c();
        siteRec.Site_Code__c='1334';
        siteRec.Name='Test';
        insert siteRec;

        Opportunity opp = new Opportunity();
        opp.Name = 'Test Opo for Notifyme';
        opp.CloseDate = Date.today();
        opp.StageName = 'New';
        opp.Pricebook2Id=pb.id;
        opp.AccountId=acc.id;
        opp.Site__c=siteRec.id;
        insert opp;

        Application__c app= new Application__c();
        app.Opportunity__c=opp.id;
        app.Source_of_Funds_Savings__c='27	ALLOWANCE';
        app.Notifyme__c='YES';
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
    public static void testCheckForNotifyMeRegister() {
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
        Test.startTest();
        Opportunity opp = [SELECT Id, Name FROM Opportunity WHERE Name = 'Test Opo for Notifyme'];
   		String response = VASNotifyMeController.checkNotifyMe(opp.id);
        System.assert(response != null, 'Test Successful');
        Test.stopTest();
    }

    @isTest
    public static void testNotifyMeRegister() {
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY_2));
        Test.startTest();
        Opportunity opp = [SELECT Id, Name FROM Opportunity WHERE Name = 'Test Opo for Notifyme'];
   		String response = VASNotifyMeController.registerForNotifyMe(opp.id, 'Cheque');
        System.assert(response != null, 'Test Successful');
        Test.stopTest();
    }
}