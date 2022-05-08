/**
 * @description       : 
 * @author            : muvhuso.nekhubvi@absa.africa
 * @last modified on  : 2021-06-11
 * @last modified by  : muvhuso.nekhubvi@absa.africa
 * Modifications Log 
 * Ver   Date         Author                         Modification
 * 1.0   2021-06-11   muvhuso.nekhubvi@absa.africa   Initial Version
**/
@isTest

public class controlOfficerLinkingBankerDetailTest {
   @isTest
   public static void getOppDetailsTest(){
        Account account = new Account();
        account.Name = 'Test Account';
        insert account;
        Opportunity testOpp = new Opportunity();
        testOpp.Name = 'Test Opp Onboarding';
        testOpp.CloseDate = Date.today();
        testOpp.StageName = 'New';
        testOpp.AccountId = account.Id;
        insert testOpp;
        System.debug('testOpp1+++'+testOpp);
        testOpp.Control_Officer_Type__c='SBBM – ENTERPRISE EB / INSTANT BUSINESS';
        testOpp.Control_Officer_Number__c='1';
        testOpp.Employee_Number__c='';
        testOpp.Branch_Region_Site__c='8198';
        testOpp.Group_or_Individual__c='Individual';
        testOpp.Overall_Site_Code__c='25698';
        testOpp.Business_Segment_Indicator__c='LARGE BUSINESS';
        testOpp.Business_Sub_Segment_Indicator__c='BUSINESS SECTOR';
        testOpp.Banking_Sector__c='Business Banking Service';
        testOpp.Franchise_Sector__c='AC KENTUCKY FRIED CHICKEN KFC';
        testOpp.Approved_by_Employee__c='9091968';
        testOpp.Captured_by_Employee__c='0939943';

        update testOpp;
        System.debug('testOpp2+++'+testOpp);
        Test.startTest();
        if(testOpp != null){
             String ConformationOfBanker=controlOfficerLinkingBankerDetailsCon.LinkBanker(testOpp.id);
        }

        System.assertNotEquals(null, testOpp.id);

        Test.stopTest();
    }
    @isTest
    public static void getOppDetailsTest2(){

        Account account = new Account();
        account.Name = 'Test Account';
        insert account;

        Opportunity testOpp = new Opportunity();
        testOpp.Name = 'Test Opp Onboarding';
        testOpp.CloseDate = Date.today();
        testOpp.StageName = 'New';
        testOpp.AccountId = account.Id;
        insert testOpp;

        Test.startTest();

        String ConformationOfBanker=controlOfficerLinkingBankerDetailsCon.LinkBanker(testOpp.id);
        System.assertNotEquals(null, testOpp.id);

        Test.stopTest();
    }
    @isTest
    public static void getOppDetailsTest3(){
        GBcreateCmsContOffLinkV1_Req_IB_v1 dummyBeanParent = GBcreateCmsContOffLinkV1_Req_IB_v1.createDummyRequest();
        GBcreateCmsContOffLinkV1_Req_IB_v1.Gsp020i dummyBean = dummyBeanParent.GBcreateCmsContOffLinkV1.Gsp020i;
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new GBcreateCmsContOffLinkV1_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, new list < String > {
            StringConstants.GB_CREATE_CMS_CONTOFFLINK_V1
        });

        Account account = new Account();
        account.Name = 'Test Account';
        insert account;
        Opportunity testOpp = new Opportunity();
        testOpp.Name = 'Test Opp Onboarding';
        testOpp.CloseDate = Date.today();
        testOpp.CMS_Linking_Status__c = 'CAPTURED';
        testOpp.StageName = 'New';
        testOpp.AccountId = account.Id;
        insert testOpp;
        Test.startTest();
        String ConformationOfBanker=controlOfficerLinkingBankerDetailsCon.LinkBanker(testOpp.id);
        System.assertNotEquals(null, testOpp.id);
        Test.stopTest();
    }
}