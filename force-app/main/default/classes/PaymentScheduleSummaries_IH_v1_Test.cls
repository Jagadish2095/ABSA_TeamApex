/**
@description Integration Test Class for Retreive Account PageList Service
 * @author  Manideep kenche
 * @date    2021-08-20
 */
@isTest
public class PaymentScheduleSummaries_IH_v1_Test {
public static final String STATIC_RESOURCE_NAME_MOCK_POSITIVE = 'Mock_Positive_PaymentScheduleSummaries_v1';
    
    //creating test data
    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{PaymentScheduleSummaries_IH_v1.INTEGRATION_SERVICE_NAME});
        
    }
    @IsTest
    static void testPositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(StringConstants.POSITIVE_STRING, STATIC_RESOURCE_NAME_MOCK_POSITIVE));
        
        Test.startTest();
        //pass string AGENCY_ID 
        PaymentScheduleSummaries_Resp_IB_v1 responseBean = PaymentScheduleSummaries_IH_v1.GetPaymentScheduleSummaries('8595354');
   
        System.assertEquals(200, responseBean.statusCode);
        
        Test.stopTest();
    }
}