/*
* @description Test Integration Handler for ContractAlterSumAssured Service
*
* @author  Chandra Bhushan Singh : ABSA
* @version v1.0
* @since   2021-04-08
* @W-007781
*/

@IsTest
public class ContractAlterSumAssured_IH_v1_Test {

    public static final String STATIC_RESOURCE_NAME_MOCK_POSITIVE = 'Mock_Positive_ContractAlterSumAssured_v1';

    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ContractAlterSumAssured_IH_v1.INTEGRATION_SERVICE_NAME});
    }

    @IsTest
    static void testPositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(StringConstants.POSITIVE_STRING, STATIC_RESOURCE_NAME_MOCK_POSITIVE));

        Test.startTest();

        ContractAlterSumAssured_Resp_IB_v1 responseBean = callHandlerMethod();
        System.assertEquals(200, responseBean.statusCode, 'Assert Failed');

        Test.stopTest();
    }

    private static ContractAlterSumAssured_Resp_IB_v1 callHandlerMethod() {
        ContractAlterSumAssured_Req_IB_v1 dummyBean = ContractAlterSumAssured_Req_IB_v1.createDummyRequest();
        ContractAlterSumAssured_Resp_IB_v1 responseBean = ContractAlterSumAssured_IH_v1.ContractAlterSumAssured(dummyBean.Contract_Alter_SumAssured.pstrContractGID, dummyBean.Contract_Alter_SumAssured.pstrLifeAssuredGid, dummyBean.Contract_Alter_SumAssured.pintProductId, dummyBean.Contract_Alter_SumAssured.pintCover);
        return responseBean;
    }
}