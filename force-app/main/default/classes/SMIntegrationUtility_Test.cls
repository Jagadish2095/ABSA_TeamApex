/**
* @description Integration Utility
* @author  Taras Kuliievych
* @since 2021-07-14
**/
@isTest
public class SMIntegrationUtility_Test {

    /**
    * @description
    **/
    private static final String INTEGRATION_SERVICE_NAME = 'SMIntegrationUtility_Test_SERVICE';

    /**
    * @description
    **/
    private static final String POSITIVE_RESPONSE_BODY = '{}';

    /**
    * @description
    * @author  Taras Kuliievych
    * @since 2021-07-27
    **/
    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{INTEGRATION_SERVICE_NAME});
    }

    /**
    * @description
    * @author  Taras Kuliievych
    * @since 2021-07-27
    **/
    @isTest
    static void deserializedIntegrationServiceCallTest() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
        Sys_Utilities_Integration_Test_Req_IB requestBean = new Sys_Utilities_Integration_Test_Req_IB();
        requestBean.testRequestAttr = 'testRequestAttr';
        Map<String, String> customHeaders = new Map<String, String>();
        customHeaders.put('key', 'value');

        Test.startTest();
        SMIntegrationUtility integrationUtility = new SMIntegrationUtility(
            requestBean, '?endpointSuffix=endpointSuffix', customHeaders,
            INTEGRATION_SERVICE_NAME, Sys_Utilities_Integration_Test_Resp_IB.class,
            new Map<String, String>{'ad' => 'abb'});
        Sys_Utilities_Integration_Test_Resp_IB responseBean = (Sys_Utilities_Integration_Test_Resp_IB) integrationUtility.deserializedIntegrationServiceCall();
        System.assertEquals(200, responseBean.statusCode, 'deserializedIntegrationServiceCall');

        Test.stopTest();
    }

    /**
    * @description
    * @author  Taras Kuliievych
    * @since 2021-07-27
    **/
    @isTest
    static void serializedIntegrationServiceCallTest() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
        Sys_Utilities_Integration_Test_Req_IB requestBean = new Sys_Utilities_Integration_Test_Req_IB();
        requestBean.testRequestAttr = 'testRequestAttr';
        Map<String, String> customHeaders = new Map<String, String>();
        customHeaders.put('key', 'value');

        Test.startTest();

        SMIntegrationUtility integrationUtility = new SMIntegrationUtility(
            requestBean, '?endpointSuffix=endpointSuffix', customHeaders,
            INTEGRATION_SERVICE_NAME, Sys_Utilities_Integration_Test_Resp_IB.class,
            new Map<String, String>{'ad' => 'abb'});

        String response = (String) integrationUtility.serializedIntegrationServiceCall();
        System.assert(!String.isBlank(response), 'deserializedIntegrationServiceCall');

        Test.stopTest();
    }

    /**
    * @description
    * @author  Taras Kuliievych
    * @since 2021-07-27
    **/
    @isTest
    static void deserializedIntegrationServiceCallRequestAndResposeAsTextTest() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
        Sys_Utilities_Integration_StringBody_IB requestBean = new Sys_Utilities_Integration_StringBody_IB();
        requestBean.body = 'TEXT BODY';

        Test.startTest();
        SMIntegrationUtility integrationUtility = new SMIntegrationUtility(
            requestBean, null, null, INTEGRATION_SERVICE_NAME,
            Sys_Utilities_Integration_StringBody_IB.class,
            new Map<String, String>());
        Sys_Utilities_Integration_StringBody_IB responseBean = (Sys_Utilities_Integration_StringBody_IB) integrationUtility.deserializedIntegrationServiceCall();
        System.assertEquals(200, responseBean.statusCode, 'deserializedIntegrationServiceCallRequestAndResposeAsText');
        Test.stopTest();
    }

    /**
    * @description
    * @author  Taras Kuliievych
    * @since 2021-07-27
    **/
    @isTest
    static void deserializedIntegrationServiceCallMultipleIntegrationSettingsTest() {
        // Duplicate Integration Service record inserted to cause failure
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{INTEGRATION_SERVICE_NAME});
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.NEGATIVE_STRING, null));
        Sys_Utilities_Integration_Test_Req_IB requestBean = new Sys_Utilities_Integration_Test_Req_IB();
        requestBean.testRequestAttr = 'testRequestAttr';

        Test.startTest();

        SMIntegrationUtility integrationUtility = new SMIntegrationUtility(
            requestBean, null, null, INTEGRATION_SERVICE_NAME,
            Sys_Utilities_Integration_Test_Resp_IB.class,
            new Map<String, String>());

        Sys_Utilities_Integration_Test_Resp_IB responseBean = (Sys_Utilities_Integration_Test_Resp_IB) integrationUtility.deserializedIntegrationServiceCall();
        System.assertEquals(500, responseBean.statusCode, 'deserializedIntegrationServiceCallMultipleIntegrationSettings');

        Test.stopTest();
    }

    /**
    * @description
    * @author  Taras Kuliievych
    * @since 2021-07-27
    **/
    @isTest
    static void deserializedIntegrationServiceCallNoIntegrationSettingsTest() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.NEGATIVE_STRING, null));
        Sys_Utilities_Integration_Test_Req_IB requestBean = new Sys_Utilities_Integration_Test_Req_IB();
        requestBean.testRequestAttr = 'testRequestAttr';

        Test.startTest();

        SMIntegrationUtility integrationUtility = new SMIntegrationUtility(
            requestBean, null, null, 'INTEGRATION_SERVICE_NOT_FOUND',
            Sys_Utilities_Integration_Test_Resp_IB.class, new Map<String, String>());

        Sys_Utilities_Integration_Test_Resp_IB responseBean = (Sys_Utilities_Integration_Test_Resp_IB) integrationUtility.deserializedIntegrationServiceCall();
        System.assertEquals(500, responseBean.statusCode, 'deserializedIntegrationServiceCallNoIntegrationSettings');

        Test.stopTest();
    }

    /**
    * @description
    * @author  Taras Kuliievych
    * @since 2021-07-27
    **/
    @IsTest
    public static void deserializedIntegrationServiceCallRequiredFieldEmptyTest() {
        try{
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(null, null));
            Sys_Utilities_Integration_Test_Req_IB requestBean = new Sys_Utilities_Integration_Test_Req_IB();
            SMIntegrationUtility integrationUtility = new SMIntegrationUtility(
                requestBean, null, null, INTEGRATION_SERVICE_NAME,
                Sys_Utilities_Integration_Test_Resp_IB.class,
                new Map<String, String>());
            Sys_Utilities_Integration_Test_Resp_IB responseBean = (Sys_Utilities_Integration_Test_Resp_IB) integrationUtility.deserializedIntegrationServiceCall();
            Test.stopTest();
        }
        catch(Exception ex){
            system.assert(String.isNotBlank(ex.getMessage()), 'deserializedIntegrationServiceCallRequiredFieldEmpty');
        }
    }

    /**
    * @description
    * @author  Taras Kuliievych
    * @since 2021-07-27
    **/
    @isTest
    static void deserializedIntegrationServiceCallRequiredFieldMissingTest() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
        Sys_Utilities_Integration_Test_Req_IB requestBean = new Sys_Utilities_Integration_Test_Req_IB();

        Test.startTest();

        SMIntegrationUtility integrationUtility = new SMIntegrationUtility(
            requestBean, null, null, INTEGRATION_SERVICE_NAME,
            Sys_Utilities_Integration_Test_Resp_IB.class,
            new Map<String, String>());

        Sys_Utilities_Integration_Test_Resp_IB responseBean = (Sys_Utilities_Integration_Test_Resp_IB) integrationUtility.deserializedIntegrationServiceCall();
        System.assertEquals(400, responseBean.statusCode, 'deserializedIntegrationServiceCallRequiredFieldMissing');

        Test.stopTest();
    }

    /**
    * @description
    * @author  Taras Kuliievych
    * @since 2021-07-27
    **/
    @isTest
    static void deserializedIntegrationServiceCallRequiredFieldMissingExceptionWithoutParamsTest() {
        Sys_Utilities_Integration_Test_Req_IB requestBean = new Sys_Utilities_Integration_Test_Req_IB();

        Test.startTest();
        SMIntegrationUtility integrationUtility = new SMIntegrationUtility(
            null, null, null, null,
            null, null);

        try {
            Sys_Utilities_Integration_Test_Resp_IB responseBean = (Sys_Utilities_Integration_Test_Resp_IB) integrationUtility.deserializedIntegrationServiceCall();
        } catch (Exception e) {
            system.assert(String.isNotBlank(e.getMessage()));
        }

        Test.stopTest();
    }

    /**
    * @description
    * @author  Taras Kuliievych
    * @since 2021-07-27
    **/
    @isTest
    static void serializedIntegrationServiceCallRequiredFieldMissingExceptionTest() {
        Sys_Utilities_Integration_Test_Req_IB requestBean = new Sys_Utilities_Integration_Test_Req_IB();

        Test.startTest();
        SMIntegrationUtility integrationUtility = new SMIntegrationUtility(
            requestBean, null, null, INTEGRATION_SERVICE_NAME,
            null, null);

        try {
            String responseBean = (String) integrationUtility.serializedIntegrationServiceCall();
        } catch (Exception e) {
            system.assert(String.isNotBlank(e.getMessage()));
        }

        Test.stopTest();
    }

    /**
    * @description
    * @author  Taras Kuliievych
    * @since 2021-07-27
    **/
    @isTest
    static void serializedIntegrationServiceCallRequiredFieldMissingExceptionWithoutParamsTest() {
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.ERROR_MSG_XDS_NO_ID_FOUND, POSITIVE_RESPONSE_BODY));
        Sys_Utilities_Integration_Test_Req_IB requestBean = new Sys_Utilities_Integration_Test_Req_IB();

        Test.startTest();
        SMIntegrationUtility integrationUtility = new SMIntegrationUtility(
            null, null, null, null,
            null, null);

        try {
            String responseBean = (String) integrationUtility.serializedIntegrationServiceCall();
        } catch (Exception e) {
            system.assert(String.isNotBlank(e.getMessage()));
        }

        Test.stopTest();
    }

    /**
    * @description
    * @author  Taras Kuliievych
    * @since 2021-07-27
    **/
    private class Sys_Utilities_Integration_Test_Req_IB extends Base_IB{
        String testRequestAttr;

        public override void setRequiredFields(){
            requiredFieldsSet = new Set<String>();
            requiredFieldsSet.add('testRequestAttr');
        }
    }

    /**
    * @description
    * @author  Taras Kuliievych
    * @since 2021-07-27
    **/
    private class Sys_Utilities_Integration_Test_Resp_IB extends Base_IB{
        public String status;
        public Integer statusCode;
        public String message;

        String testResponseAttr;
    }

}