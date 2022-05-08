/*
* Test Integration Handler for ContractPremiumSumAssured Service
*
* @author  Chandra Bhushan Singh : ABSA
* @version v1.0
* @since   2021-04-08
* @W-007781
*/

@IsTest
public class ContractPremiumSumAssured_IH_v1_Test {

    public static final String STATIC_RESOURCE_NAME_MOCK_POSITIVE = 'Mock_Positive_ContractPremiumSumAssured_v1';

    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ContractPremiumSumAssured_IH_v1.INTEGRATION_SERVICE_NAME});
    }

    @IsTest
    static void testPositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(StringConstants.POSITIVE_STRING, STATIC_RESOURCE_NAME_MOCK_POSITIVE));

        Test.startTest();

        ContractPremiumSumAssured_Resp_IB_v1 responseBean = callHandlerMethod();
        System.assertEquals(200, responseBean.statusCode, 'Assert Failed');

        Test.stopTest();
    }

    private static ContractPremiumSumAssured_Resp_IB_v1 callHandlerMethod() {
        ContractPremiumSumAssured_Req_IB_v1 dummyBean = ContractPremiumSumAssured_Req_IB_v1.createDummyRequest();
        ContractPremiumSumAssured_Resp_IB_v1 responseBean = ContractPremiumSumAssured_IH_v1.ContractPremiumSumAssured(dummyBean.Contract_Premium_SumAssured.pstrContractGID, dummyBean.Contract_Premium_SumAssured.pstrLifeAssuredGid, dummyBean.Contract_Premium_SumAssured.pintProductId, dummyBean.Contract_Premium_SumAssured.pintCover);
        return responseBean;
    }
}