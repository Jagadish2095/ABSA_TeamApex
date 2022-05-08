/**
 * @description Test class for DLGetPaymentHistoryForCustomer Service
 * @author Jason Quevauvilliers
 * @created 2021-03-31

 * @updated Jason Quevauvilliers

 */
@IsTest
public class DLGetPaymentHistoryForCustomer_IH_v1Test {
    public static final String STATIC_RESOURCE_NAME_MOCK_POSITIVE = 'Mock_Positive_GetPaymentHistory_v1';

    @TestSetup
    static void makeData() {
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ DLGetPaymentHistoryForCustomer_IH_v1.INTEGRATION_SERVICE_NAME });
    }

    @isTest
    static void testGetPaymentHistory() {
        // Set mock callout class
        Test.setMock(
            HttpCalloutMock.class,
            Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(StringConstants.POSITIVE_STRING, STATIC_RESOURCE_NAME_MOCK_POSITIVE)
        );

        Test.startTest();
        DLGetPaymentHistoryForCustomer_Resp_IBv1 respBean = callHandlerMethod();
        System.assertEquals(200, respBean.statusCode, 'Assert Failed');
        Test.stopTest();
    }

    /**
	 * @description method to call the Handler class
	 * @return DLGetPaymentHistoryForCustomer_Resp_IBv1
	 */
    private static DLGetPaymentHistoryForCustomer_Resp_IBv1 callHandlerMethod() {
        DLGetPaymentHistoryForCustomer_Req_IB_v1 req = DLGetPaymentHistoryForCustomer_Req_IB_v1.createDummyRequest();
        DLGetPaymentHistoryForCustomer_Resp_IBv1 respBean = DLGetPaymentHistoryForCustomer_IH_v1.getPaymentHistory(req.cifKey, req.idNumber);
        return respBean;
    }
}