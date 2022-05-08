/*
* Integration Bean test for NewMemberRegistration Service
* @author Khaliq Abdul
* @created 2020-11-02
*/
@isTest
public class NewMemberRegistration_IH_v1_Test {

    public static final String POSITIVE_RESPONSE_BODY = '{"NewMemberRegistration_Resp_IB_v1":{"outTransferred": 2,"msgNo": 200,"msg":"Succesfully update reward Details"}}';

    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{NewMemberRegistration_IH_v1.INTEGRATION_SERVICE_NAME});
    }

    @isTest static void testPositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
        Test.startTest();

        NewMemberRegistration_Resp_IB_v1 responseBean = callHandlerMethod();
        System.assertEquals(200, responseBean.statusCode);

        Test.stopTest();
    }

    private static NewMemberRegistration_Resp_IB_v1 callHandlerMethod() {
        
        NewMemberRegistration_Req_IB_v1 dummyBean = NewMemberRegistration_Req_IB_v1.createDummyRequest();
        NewMemberRegistration_Resp_IB_v1 dummyResponseBean =  NewMemberRegistration_Resp_IB_v1.dummyResponse();
        
        NewMemberRegistration_Resp_IB_v1 responseBean = NewMemberRegistration_IH_v1.NewMemberRegistration(dummyBean);

        return responseBean;
    }
}