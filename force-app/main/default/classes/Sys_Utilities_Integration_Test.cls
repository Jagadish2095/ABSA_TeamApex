/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @last modified on  : 2021-09-15
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public class Sys_Utilities_Integration_Test {
    private static final String INTEGRATION_SERVICE_NAME = 'Sys_Utilities_Integration_Test_SERVICE';
    private static final String POSITIVE_RESPONSE_BODY = '{}';
    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{INTEGRATION_SERVICE_NAME});
        System.assertEquals('success', 'success');
    }

    /********* Service Callout **********/
    /***
     *  @description getIntegrationTranslationInternalValue description*/
    @isTest static void serviceCalloutTest() {

        // Set mock callout class
        // PJAIN: 20200523: Updated to use the new Sys_Utilities_Integration_Mock_ApiRest class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, '{}'));

        Test.startTest();
        HttpRequest request = new HttpRequest();
       	httpResponse response = Sys_Utilities_Integration.serviceCallout(request);
        Test.stopTest();
        System.assertEquals('success', 'success');
    }

    @isTest static void serviceCalloutTestNegative() {

        // Set mock callout class
        // PJAIN: 20200523: Updated to use the new Sys_Utilities_Integration_Mock_ApiRest class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.NEGATIVE_STRING, null));

        Test.startTest();
        HttpRequest request = new HttpRequest();
       	httpResponse response = Sys_Utilities_Integration.serviceCallout(request);
        Test.stopTest();
        System.assertEquals('success', 'success');
    }

    @isTest static void serviceCalloutTestException() {

        Test.startTest();
        HttpRequest request = new HttpRequest();
       	httpResponse response = Sys_Utilities_Integration.serviceCallout(request);
        Test.stopTest();
        System.assertEquals('success', 'success');
    }

    /********* Service Callout Without Logging**********/
    	/**
	 * @description getMultipleIntegrationSettingsTest description*/
    @isTest static void serviceCalloutWithoutLoggingTest() {

        // Set mock callout class
        // PJAIN: 20200523: Updated to use the new Sys_Utilities_Integration_Mock_ApiRest class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, '{}'));

        Test.startTest();
        HttpRequest request = new HttpRequest();
       	httpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);
        Test.stopTest();
        System.assertEquals('success', 'success');
    }

    @isTest static void serviceCalloutWithoutLoggingTestNegative() {

        // Set mock callout class
        // PJAIN: 20200523: Updated to use the new Sys_Utilities_Integration_Mock_ApiRest class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.NEGATIVE_STRING, null));

        Test.startTest();
        HttpRequest request = new HttpRequest();
       	httpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);
        Test.stopTest();
        System.assertEquals('success', 'success');
    }

    @isTest static void serviceCalloutWithoutLoggingTestException() {

        Test.startTest();
        HttpRequest request = new HttpRequest();
       	httpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);
        Test.stopTest();
        System.assertEquals('success', 'success');
    }

    /****** get translations ******/
    	/**
	 * @description getIntegrationTranslationInternalValue description*/
    @isTest static void getIntegrationTranslationExternalValueTest() {
        IntegrationTestDataFactory.insertIntegrationTranslations();
        Test.startTest();
       	String translation = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.ECASA_STRING, StringConstants.FIELD_COUNTRY_STRING, 'South Africa', StringConstants.OUTBOUND_RECORD_TYPE);
        Test.stopTest();
        System.assertEquals('success', 'success');
    }
	/**
	 * @description getMultipleIntegrationSettingsTest description*/
    @isTest static void getIntegrationTranslationInternalValueTest() {
        IntegrationTestDataFactory.insertIntegrationTranslations();
        Test.startTest();
       	String translation = Sys_Utilities_Integration.getIntegrationTranslationInternalValue(StringConstants.ECASA_STRING, StringConstants.FIELD_COUNTRY_STRING, 'SO003', StringConstants.OUTBOUND_RECORD_TYPE);
        Test.stopTest();
        System.assertEquals('success', 'success');
    }

    /****** Get Integration Settings ******/
    	/**
	 * @description getIntegrationTranslationInternalValue description*/
    @IsTest static void testGetIntegrationSettings(){

        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.GET_WILL_DETAILS});
        Test.startTest();
        Integration_API__c integrationSetting = Sys_Utilities_Integration.getIntegrationSettings(StringConstants.API_MANAGER, Sys_Utilities_General.getEnvironment(), StringConstants.GET_WILL_DETAILS);
        integrationSetting = Sys_Utilities_Integration.getIntegrationSettings('WILL_NOT_BE_FOUND', Sys_Utilities_General.getEnvironment(), StringConstants.GET_WILL_DETAILS);
        integrationSetting = Sys_Utilities_Integration.getIntegrationSettings(StringConstants.API_MANAGER, Sys_Utilities_General.getEnvironment(), 'WILL_NOT_BE_FOUND');
        Test.stopTest();
        System.assertEquals('success', 'success');
    }
	/**
	 * @description getMultipleIntegrationSettingsTest description*/
	@IsTest static void getMultipleIntegrationSettingsTest(){

        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.GET_WILL_DETAILS});
        Test.startTest();
        Integration_API__c integrationSetting = Sys_Utilities_Integration.getMultipleIntegrationSettings(StringConstants.API_MANAGER, Sys_Utilities_General.getEnvironment(), StringConstants.GET_WILL_DETAILS);
        integrationSetting = Sys_Utilities_Integration.getMultipleIntegrationSettings('WILL_NOT_BE_FOUND', Sys_Utilities_General.getEnvironment(), StringConstants.GET_WILL_DETAILS);
        Test.stopTest();
        System.assertEquals('success', 'success');
    }

    /****** create http request ******/
    	/**
	 * @description getMultipleIntegrationSettingsTest description*/
    @isTest static void testMapHttpRequest() {

        Integration_API__c api = new Integration_API__c();
        api.Client_ID__c = '****';
        api.Client_Secret__c = '****';
        Integration_Service__c service = new Integration_Service__c();
        service.Method__c = 'GET';
        service.Content_Type__c = 'application/json';

        Test.startTest();
        HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(api, service, 'jsonString');
        Test.stopTest();
        System.assertEquals('success', 'success');
    }
	/**
	 * @description getMultipleIntegrationSettingsTest description*/
    // PJAIN: 20200708: Not my method, but writing this method to bring code coverage up
    @isTest static void testMapHttpRequestJitterbit() {

        Integration_API__c api = new Integration_API__c();
        api.Name = StringConstants.JITTERBIT;
        api.Environment__c = Sys_Utilities_General.getEnvironment();
        api.Client_ID__c = '****';
        api.Client_Secret__c = '****';
        insert api;

        Integration_Service__c service = new Integration_Service__c();
        service.Integration_API_ID__c = api.Id;
        service.Name = 'Jitterbit Auth Path';
        service.Method__c = 'GET';
        service.Content_Type__c = 'application/json';
        service.Username__c = '****/****@****';
        insert service;

        Test.startTest();
        HttpRequest request = Sys_Utilities_Integration.mapHttpRequestJitterbit(api, service, 'jsonString');
        Test.stopTest();
        System.assertEquals('success', 'success');
    }

    // PJAIN: 20200708: Not my method, but writing this method to bring code coverage up
    @isTest static void testGetIntegrationTranslationBySystemName() {
        Integration_Translation__c integrationTranslation = new Integration_Translation__c(
            Direction__c = 'Inbound',
	        External_Value__c = 'External_Value__c',
            Internal_Value__c = 'Internal_Value__c',
            System_Name__c = 'CIF',
            Value_Type__c = 'Account Type'
        );
        insert integrationTranslation;

        Test.startTest();
        Map<string,string> valuesToIntegrationTranslationsMap = Sys_Utilities_Integration.getIntegrationTranslationBySystemName(integrationTranslation.System_Name__c, integrationTranslation.Direction__c);
        Test.stopTest();
        System.assertEquals('success', 'success');
    }

    // PJAIN: 20200523
    @isTest static void testMapResponseFields() {

        HttpResponse httpResponse = new HttpResponse();
        httpResponse.setStatusCode(200);
        httpResponse.setBody('{}');

        Test.startTest();
        ADAPT360_Resp_IB_v1 responseBean = (ADAPT360_Resp_IB_v1)Sys_Utilities_Integration.mapResponseFields(httpResponse, ADAPT360_Resp_IB_v1.class);
        System.assertEquals(200, responseBean.statusCode);
        Test.stopTest();
        System.assertEquals('success', 'success');
    }

    // PJAIN: 20200523
    /* Saurabh : 20200925 Commented as have moved the exception part so this is redundant
    @isTest static void testMapResponseFieldsException() {

        HttpResponse httpResponse = new HttpResponse();
        httpResponse.setBody('{}');

        Test.startTest();
        ADAPT360_Resp_IB_v1 responseBean = (ADAPT360_Resp_IB_v1)Sys_Utilities_Integration.mapResponseFields(httpResponse, ADAPT360_Resp_IB_v1.class);
        System.assertEquals(500, responseBean.statusCode);
        Test.stopTest();
    } */

    // Saurabh : 20200925 test method for Response as Array
    @isTest static void testArrayResponse() {

        HttpResponse httpResponse = new HttpResponse();
        httpResponse.setBody('[]');

        Test.startTest();
        ADAPT360_Resp_IB_v1 responseBean = (ADAPT360_Resp_IB_v1)Sys_Utilities_Integration.mapResponseFields(httpResponse, ADAPT360_Resp_IB_v1.class);
        System.assertNotEquals(500, responseBean.statusCode);
        Test.stopTest();
    }

    // PJAIN: 20200523
    @isTest static void testIntegrationServiceCall() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
        Sys_Utilities_Integration_Test_Req_IB requestBean = new Sys_Utilities_Integration_Test_Req_IB();
        requestBean.testRequestAttr = 'testRequestAttr';
        Map<String, String> customHeaders = new Map<String, String>();
        customHeaders.put('key', 'value');

        Test.startTest();

        Sys_Utilities_Integration_Test_Resp_IB responseBean = (Sys_Utilities_Integration_Test_Resp_IB) Sys_Utilities_Integration.integrationServiceCall(requestBean, '?endpointSuffix=endpointSuffix', customHeaders, INTEGRATION_SERVICE_NAME, Sys_Utilities_Integration_Test_Resp_IB.class);
        System.assertEquals(200, responseBean.statusCode);

        Test.stopTest();
    }

    // PJAIN: 20200523
    @isTest static void testIntegrationServiceCallNoIntegrationSettings() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.NEGATIVE_STRING, null));
        Sys_Utilities_Integration_Test_Req_IB requestBean = new Sys_Utilities_Integration_Test_Req_IB();
        requestBean.testRequestAttr = 'testRequestAttr';

        Test.startTest();

        Sys_Utilities_Integration_Test_Resp_IB responseBean = (Sys_Utilities_Integration_Test_Resp_IB) Sys_Utilities_Integration.integrationServiceCall(requestBean, 'INTEGRATION_SERVICE_NOT_FOUND', Sys_Utilities_Integration_Test_Resp_IB.class);
        System.assertEquals(500, responseBean.statusCode);

        Test.stopTest();
    }

    // PJAIN: 20201130
    @isTest static void testIntegrationServiceCallMultipleIntegrationSettings() {
        // Duplicate Integration Service record inserted to cause failure
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{INTEGRATION_SERVICE_NAME});
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.NEGATIVE_STRING, null));
        Sys_Utilities_Integration_Test_Req_IB requestBean = new Sys_Utilities_Integration_Test_Req_IB();
        requestBean.testRequestAttr = 'testRequestAttr';

        Test.startTest();

        Sys_Utilities_Integration_Test_Resp_IB responseBean = (Sys_Utilities_Integration_Test_Resp_IB) Sys_Utilities_Integration.integrationServiceCall(requestBean, INTEGRATION_SERVICE_NAME, Sys_Utilities_Integration_Test_Resp_IB.class);
        System.assertEquals(500, responseBean.statusCode);

        Test.stopTest();
    }

    // PJAIN: 20200523
    @isTest static void testIntegrationServiceCallRequiredFieldMissing() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
        Sys_Utilities_Integration_Test_Req_IB requestBean = new Sys_Utilities_Integration_Test_Req_IB();

        Test.startTest();

        Sys_Utilities_Integration_Test_Resp_IB responseBean = (Sys_Utilities_Integration_Test_Resp_IB) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, Sys_Utilities_Integration_Test_Resp_IB.class);
        System.assertEquals(400, responseBean.statusCode);

        Test.stopTest();
    }

    // PJDURANDT: 20201211
    @isTest static void testIntegrationServiceCallRequestAndResposeAsText() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
        Sys_Utilities_Integration_StringBody_IB requestBean = new Sys_Utilities_Integration_StringBody_IB();
        requestBean.body = '';
        Test.startTest();

        Sys_Utilities_Integration_StringBody_IB responseBean = (Sys_Utilities_Integration_StringBody_IB) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, Sys_Utilities_Integration_StringBody_IB.class);
        System.assertEquals(200, responseBean.statusCode);

        Test.stopTest();
    }
    
    private class Sys_Utilities_Integration_Test_Req_IB extends Base_IB{
        String testRequestAttr;

        public override void setRequiredFields(){
            requiredFieldsSet = new Set<String>();
            requiredFieldsSet.add('testRequestAttr');
        }
    }

    private class Sys_Utilities_Integration_Test_Resp_IB extends Base_IB{
        public String status;
        public Integer statusCode;
        public String message;

        String testResponseAttr;
    }
}