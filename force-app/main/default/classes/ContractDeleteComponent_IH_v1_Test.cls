/**
 * @description Test class for ContractDeleteComponent Service
 * @author Koketso Mpshane
 * @created 2021-06-29
 */
@IsTest
public class ContractDeleteComponent_IH_v1_Test {

    public static final String STATIC_RESOURCE_NAME_MOCK_POSITIVE = 'Mock_Positive_contractDeleteComponent_v1';

    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ContractDeleteComponent_IH_v1.INTEGRATION_SERVICE_NAME});
    }

    @IsTest
    static void testPositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(StringConstants.POSITIVE_STRING, STATIC_RESOURCE_NAME_MOCK_POSITIVE));

        Test.startTest();

        ContractDeleteComponent_Resp_IB_v1 responseBean = callHandlerMethod();
        System.assertEquals(200, responseBean.statusCode, 'Assert Failed');

        Test.stopTest();
    }

    private static ContractDeleteComponent_Resp_IB_v1 callHandlerMethod() {
        ContractDeleteComponent_Req_IB_v1 dummyBean = ContractDeleteComponent_Req_IB_v1.createDummyRequest();
        ContractDeleteComponent_Resp_IB_v1 responseBean = ContractDeleteComponent_IH_v1.ContractDeleteComponent(dummyBean.Contract_Delete_Component.pstrContractGID, dummyBean.Contract_Delete_Component.pstrLifeAssuredGid, dummyBean.Contract_Delete_Component.pintProductId);
        return responseBean;
    }

}