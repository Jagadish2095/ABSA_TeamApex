/**
 * @description Test class for ContractCancel Service
 * @author Koketso Mpshane
 * @created 2021-06-30
 */
@isTest
public class ContractCancel_IH_v1_Test {
    
    public static final String STATIC_RESOURCE_NAME_MOCK_POSITIVE = 'Mock_Positive_ContractCancel_v1';

    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ContractCancel_IH_v1.INTEGRATION_SERVICE_NAME});
    }

    @IsTest
    static void testPositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(StringConstants.POSITIVE_STRING, STATIC_RESOURCE_NAME_MOCK_POSITIVE));

        Test.startTest();

        ContractCancel_Resp_IB_v1 responseBean = callHandlerMethod();
        System.assertEquals(200, responseBean.statusCode, 'Assert Failed');

        Test.stopTest();
    }

    private static ContractCancel_Resp_IB_v1 callHandlerMethod() {
        ContractCancel_Req_IB_v1 dummyBean = ContractCancel_Req_IB_v1.createDummyRequest();
        ContractCancel_Resp_IB_v1 responseBean = ContractCancel_IH_v1.ContractCancel(dummyBean.Contract_Cancel.pstrContractGID, dummyBean.Contract_Cancel.pintDecisionReason, dummyBean.Contract_Cancel.pstrDecisionNote, dummyBean.Contract_Cancel.pstrCancelRequestDate, dummyBean.Contract_Cancel.pstrDecisionReason);
        return responseBean;
    }

}