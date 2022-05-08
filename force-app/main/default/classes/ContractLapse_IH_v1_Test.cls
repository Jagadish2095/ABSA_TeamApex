/**
 * @description Test class for ContractLapse Service
 * @author Koketso Mpshane
 * @created 2021-06-30
 */
@isTest
public class ContractLapse_IH_v1_Test {
    
    public static final String STATIC_RESOURCE_NAME_MOCK_POSITIVE = 'Mock_Positive_ContractLapse_v1';

    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ContractLapse_IH_v1.INTEGRATION_SERVICE_NAME});
    }

    @IsTest
    static void testPositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(StringConstants.POSITIVE_STRING, STATIC_RESOURCE_NAME_MOCK_POSITIVE));

        Test.startTest();

        ContractLapse_Resp_IB_v1 responseBean = callHandlerMethod();
        System.assertEquals(200, responseBean.statusCode, 'Assert Failed');

        Test.stopTest();
    }

    private static ContractLapse_Resp_IB_v1 callHandlerMethod() {
        ContractLapse_Req_IB_v1 dummyBean = ContractLapse_Req_IB_v1.createDummyRequest();
        ContractLapse_Resp_IB_v1 responseBean = ContractLapse_IH_v1.ContractLapse(dummyBean.contractLapse.pstrContractGID, dummyBean.contractLapse.p8dtMovementDate, dummyBean.contractLapse.pintLapseReasonID, dummyBean.contractLapse.pstrLapseReasonDesc, dummyBean.contractLapse.lapseNote);
        return responseBean;
    }

}