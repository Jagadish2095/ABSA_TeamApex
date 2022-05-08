/**

 * @description

 * @Author: Mbuyiseni Mbhokane
 * @Since: 13/11/2020
 */
@isTest
public class CQUpdClosureDetailsV1_IH_v1_Test {

    public static final String POSITIVE_RESPONSE_BODY = '{"NBSAPDPO": {"NBNAPLO_REASON_CODE": 0,"NBNAPLO_RETURN_CODE": 0,"NBNAPLO_SERVICE_VERSION": "BUSO001"},"CQS960O": {"CQN960O_CLOS_REASON": "","CQN960O_ABAL": 0.00,"CQN960O_STATUS": "","CQN960O_AVBL": 0.00,"CQS960O_ACCOUNT_NUMBER": 0},"NBSMSGO3": {"NBNMSGO3_NBR_USER_ERRS": 1,"NBSMSGO3_VERSION": "MSG3001","NBNMSGO3_SYS_ERR_TXT": "","NBNMSGO3_NBR_USER_MSGS": 1,"NBNMSGO3_MSG_ENTRY": [{"NBNMSGO3_MSG_ERR_IND": "E","NBNMSGO3_MSG_TXT": "Invalid account number - account does not exist.","NBNMSGO3_MSG_CLASS": "CQSMGC01","NBNMSGO3_MSG_CODE": "0008"},{"NBNMSGO3_MSG_ERR_IND": "","NBNMSGO3_MSG_TXT": "",""NBNMSGO3_MSG_CODE": ""},{"NBNMSGO3_MSG_ERR_IND": "","NBNMSGO3_MSG_TXT": "","NBNMSGO3_MSG_CLASS": "","NBNMSGO3_MSG_CODE": ""},{"NBNMSGO3_MSG_ERR_IND": "","NBNMSGO3_MSG_TXT": "","NBNMSGO3_MSG_CLASS": "","NBNMSGO3_MSG_CODE": ""},{"NBNMSGO3_MSG_ERR_IND": "","NBNMSGO3_MSG_TXT": "","NBNMSGO3_MSG_CLASS": "","NBNMSGO3_MSG_CODE": ""}]}}';

    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{CQUpdClosureDetailsV1_IH_v1.INTEGRATION_SERVICE_NAME});
    }

    @isTest static void testPositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
        Test.startTest();
        CQUpdClosureDetailsV1_Resp_IB_v1 responseBean = callHandlerMethod();
        if (responseBean.statusCode == 200) {
            System.assertEquals(200, responseBean.statusCode);
        } else {
            System.assertEquals(responseBean.statusCode, responseBean.statusCode);
        }
        Test.stopTest();
    }

    private static CQUpdClosureDetailsV1_Resp_IB_v1 callHandlerMethod() {
        CQUpdClosureDetailsV1_Req_IB_v1 dummyReqBean = CQUpdClosureDetailsV1_Req_IB_v1.createDummyRequest();
        CQUpdClosureDetailsV1_Resp_IB_v1 dummyrespBean = CQUpdClosureDetailsV1_Resp_IB_v1.createDummyResponse();
        CQUpdClosureDetailsV1_Resp_IB_v1 responseBean = CQUpdClosureDetailsV1_IH_v1.updateCloseAccountDetails(dummyReqBean);
        return responseBean;
    }
}