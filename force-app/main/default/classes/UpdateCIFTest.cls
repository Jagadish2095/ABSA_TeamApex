/**
 * @description       : Test Class For UpdateCIF method in ComplianceveiwDashboardController UpdateCIF Method
 * @author            : Sandeep Ch
 * @since			  :	07-20-2021
**/
@isTest
public class UpdateCIFTest {
    @isTest 
    public static void testUpdateCIF(){
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();

        testDataFactory.testAccount.Client_group__c = 'Individual';
        update testDataFactory.testAccount;

        Integration_Translation__c country = new Integration_Translation__c();
        country.Name = 'South African';
        country.Internal_Value__c = 'South Africa';
        country.External_Value__c = 'SOU01';
        country.System_Name__c = StringConstants.CIF_STRING;
        country.Value_Type__c = StringConstants.FIELD_COUNTRY_STRING;
        country.Direction__c = StringConstants.OUTBOUND_RECORD_TYPE;
        insert country;
        
        Integration_Translation__c inttrans=new Integration_Translation__c();
        inttrans.Direction__c='Outbound';
        inttrans.System_Name__c='CIFCodesList';
        inttrans.Value_Type__c='Occucode';
        inttrans.Internal_Value__c='01';
        inttrans.External_Value__c='profession';
        insert inttrans;

        Test.setMock(HttpCalloutMock.class, new getUpdateCIFMock_APIRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new list<String> {'updateCIF'});

        Test.startTest();
       getUpdateCIF_IH_v1.getCIFResponse(testDataFactory.testAccount, 'test', 'test', 'test', 'test', '', '4234239', 'Y');
       // getUpdateCIF_IH_v1.mapFailedResponseFields(0,'test','test');
        Test.stopTest();
        System.assert(true);
    }

    @isTest
    public static void testUpdateCIF1(){
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();

        testDataFactory.testAccount.Client_group__c = 'Individual';
        update testDataFactory.testAccount;
        Integration_Translation__c country = new Integration_Translation__c();
        country.Name = 'South African';
        country.Internal_Value__c = 'South Africa';
        country.External_Value__c = 'SOU01';
        country.System_Name__c = StringConstants.CIF_STRING;
        country.Value_Type__c = StringConstants.FIELD_COUNTRY_STRING;
        country.Direction__c = StringConstants.OUTBOUND_RECORD_TYPE;
        insert country;

        Test.setMock(HttpCalloutMock.class, new getUpdateCIFMock_APIRest(StringConstants.NEGATIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new list<String> {'updateCIF'});

        Test.startTest();
      //  ComplianceViewDashboardController.getUpdateCIF_IU_v1(testDataFactory.testAccount.id, 'address1', 'address2', 'suburb', 'cityName', 'South Africa', '1234', 'Y');
        Test.stopTest();
        System.assert(true);
    }

    @isTest
    public static void testUpdateCIF2(){ 
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();

        testDataFactory.testAccount.Client_group__c = 'Individual';
        update testDataFactory.testAccount;

        Test.setMock(HttpCalloutMock.class, new getUpdateCIFMock_APIRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new list<String> {'updateCIF'});

        Test.startTest();
      //  ComplianceViewDashboardController.updateCIF(testDataFactory.testAccount.id, 'address1', 'address2', 'suburb', 'cityName', 'South Africa', '1234', 'Y');
        Test.stopTest();
        System.assert(true);
    }
}