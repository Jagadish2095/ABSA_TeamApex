/**
 * @description Test class for ContractGetComponent Service
 * @author Koketso Mpshane
 * @created 2021-08-17
 */
@isTest
public class ContractGetComponent_IH_v1_Test {
    
    public static final String STATIC_RESOURCE_NAME_MOCK_POSITIVE = 'Mock_Positive_ContractGetComponent_v1';

    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ContractGetComponent_IH_v1.INTEGRATION_SERVICE_NAME});
    }

    @IsTest
    static void testPositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(StringConstants.POSITIVE_STRING, STATIC_RESOURCE_NAME_MOCK_POSITIVE));

        Test.startTest();

        ContractGetComponent_Resp_IB_v1 responseBean = callHandlerMethod();
        System.assertEquals(200, responseBean.statusCode, 'Assert Failed');

        Test.stopTest();
    }

    private static ContractGetComponent_Resp_IB_v1 callHandlerMethod() {
        ContractGetComponent_Req_IB_v1 dummyBean = ContractGetComponent_Req_IB_v1.createDummyRequest();
        ContractGetComponent_Resp_IB_v1 responseBean = ContractGetComponent_IH_v1.ContractGetComponent(dummyBean.Contract_getComponents.pintContractTypeID);
        return responseBean;
    }

}