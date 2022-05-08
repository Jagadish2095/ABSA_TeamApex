/*
* Test Integration Handler for addTBMobileBeneficiaries service
* @author Mashudu Raidimi
* @created 2020-07-27
*/
@isTest
public class addTBMobileBeneficiaries_IH_v1_Test {
    public static final String POSITIVE_RESPONSE_BODY = '{"addMobileBeneficiariesResp":{"saveMessage":"Saved successfully for 0723935028"},"error":false,"errorList":[],"additionalInfo":null}';

    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(addTBMobileBeneficiaries_IH_v1.INTEGRATION_API_NAME, new List<String>{addTBMobileBeneficiaries_IH_v1.INTEGRATION_SERVICE_NAME});
    }

    @isTest static void testPositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));

        Test.startTest();

        addTBMobileBeneficiaries_Resp_IB_v1 responseBean = callHandlerMethod();
        System.assertEquals(200, responseBean.statusCode);

        Test.stopTest();
    }

    private static addTBMobileBeneficiaries_Resp_IB_v1 callHandlerMethod() {
        addTBMobileBeneficiaries_Req_IB_v1 dummyBean = addTBMobileBeneficiaries_Req_IB_v1.DummyRequest();
        addTBMobileBeneficiaries_Resp_IB_v1 responseBean = addTBMobileBeneficiaries_IH_v1.addTBMobileBeneficiaries(dummyBean.cifKey,dummyBean.cellNo ,dummyBean.ivrPaymentNo ,dummyBean.description, dummyBean.cellProvider);
        return responseBean;
    }

}