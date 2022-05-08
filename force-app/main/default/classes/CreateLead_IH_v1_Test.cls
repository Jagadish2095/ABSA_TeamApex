/**
 * @description test class for createLead service
 * @author Mbuyiseni Mbhokane
 * @since 08/05/2021
 * @LastModified : Monde Masiza
 */
@isTest
public class CreateLead_IH_v1_Test {

    
    public static final String CREATE_LEAD_RESPONSE_BODY = '{"result": [{"code": "0000","message": "Update member successful"}]}';
    
    @TestSetup
    static void createData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{CreateLead_IH_v1.INTEGRATION_SERVICE_NAME});
    }

    @isTest static void testcreateLeadPositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, CREATE_LEAD_RESPONSE_BODY));
        Test.startTest();
        CreateLead_Resp_IB_v1 responseBean = callHandlerMethod();
        system.assertEquals(200, responseBean.statusCode, 'The status code does not equals to 200');
        Test.stopTest();
    }

    private static CreateLead_Resp_IB_v1 callHandlerMethod() {
        CreateLead_Req_IB_v1 requestBean = CreateLead_Req_IB_v1.dummyRequest();
        CreateLead_Resp_IB_v1 dummyrespBean = CreateLead_Resp_IB_v1.dummyResponse();
        CreateLead_Resp_IB_v1 responseBean = CreateLead_IH_v1.createLead(requestBean);
        return responseBean;
    }
}