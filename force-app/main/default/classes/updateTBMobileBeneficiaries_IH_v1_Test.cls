/*
* Test Integration Handler for updateTBMobileBeneficiaries service
* @author Mashudu Raidimi
* @created 2020-07-27
*/
@isTest
public class updateTBMobileBeneficiaries_IH_v1_Test {
    public static final String POSITIVE_RESPONSE_BODY = '{"updateMobileBeneficiariesResp":{"updateMessage":"Updated successfully for 0723935028"},"error":false,"errorList":[],"additionalInfo":null}';

    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(updateTBMobileBeneficiaries_IH_v1.INTEGRATION_API_NAME, new List<String>{updateTBMobileBeneficiaries_IH_v1.INTEGRATION_SERVICE_NAME});
    }

   @isTest static void testPositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));

        Test.startTest();

        updateTBMobileBeneficiaries_Resp_IB_v1 responseBean = callHandlerMethod();
        System.assertEquals(200, responseBean.statusCode);

        Test.stopTest();
    }

    private static updateTBMobileBeneficiaries_Resp_IB_v1 callHandlerMethod() {
        updateTBMobileBeneficiaries_Req_IB_v1 dummyBean = updateTBMobileBeneficiaries_Req_IB_v1.DummyRequest();
        updateTBMobileBeneficiaries_Resp_IB_v1 responseBean = updateTBMobileBeneficiaries_IH_v1.updateTBMobileBeneficiaries(dummyBean.cifKey,dummyBean.cellNo ,dummyBean.ivrPaymentNo ,dummyBean.description, dummyBean.cellProvider);
        return responseBean;
    }

}