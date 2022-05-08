/**
 * @description Integration Test Class for Payment Schedule Summaries Service
 * @author  Manideep kenche
 * @date    2021-08-31
 */
@Istest
public class RetreiveAccountPageList_IH_v1_Test {
public static final String STATIC_RESOURCE_NAME_MOCK_POSITIVE = 'Mock_Positive_RetrieveAccountPageList_v1';
    
    //creating test data
    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{RetreiveAccountPageList_IH_v1.INTEGRATION_SERVICE_NAME});
        
    }
    @IsTest
    static void testPositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(StringConstants.POSITIVE_STRING, STATIC_RESOURCE_NAME_MOCK_POSITIVE));
        
        Test.startTest();
        //pass string AGENCY_ID 
        RetreiveAccountPageList_Resp_IB_v1 responseBean = RetreiveAccountPageList_IH_v1.RetreiveAccountPageList('170221501');
        
        System.assertEquals(200, responseBean.statusCode);
        
        Test.stopTest();
    }
}