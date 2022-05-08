/**
 * @description Integration Test Class for DealerVerification Service
 * @author  Manideep kenche
 * @date    2021-10-18
 * @work W-014039
 */
@isTest
public class AuthenticateDealer_IH_v1_Test {
    public static final String STATIC_RESOURCE_NAME_MOCK_POSITIVE = 'Mock_Positive_DealerVerification_v1';
    
    public static final String STATIC_RESOURCE_NAME_MOCK_NEGATIVE = 'Mock_Negative_DealerVerification_v1';
    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(
            StringConstants.JITTERBIT2,
            new List<String>{ AuthenticateDealer_IH_v1.INTEGRATION_SERVICE_NAME }
        );    }
    @IsTest
    static void testPositive() {
      
        Test.setMock(
            HttpCalloutMock.class,
            Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(
                StringConstants.POSITIVE_STRING,
                STATIC_RESOURCE_NAME_MOCK_POSITIVE
            )
        );
        Test.startTest();
        AuthenticateDealer_Resp_IB_v1 responseBean = callHandlerMethod();
        System.assertEquals(200, responseBean.statusCode);
      
        Test.stopTest();
    }
    private static AuthenticateDealer_Resp_IB_v1 callHandlerMethod() {
        AuthenticateDealer_Req_IB_v1 dummyBean = AuthenticateDealer_Req_IB_v1.createDummyRequest();
      
        AuthenticateDealer_Resp_IB_v1 responseBean = AuthenticateDealer_IH_v1.AuthenticateDealer(dummyBean.BAPI_SF_DLR_DETAILS.I_DEALER,dummyBean.BAPI_SF_DLR_DETAILS.I_USER);
       
        return responseBean;
    }
}