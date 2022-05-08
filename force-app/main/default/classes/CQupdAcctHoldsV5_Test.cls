/*
* Test Integration Handler for CQupdAcctHoldsV5 Service
* @author Satya Boyenepalli
* @created 2020-12-08
*/
@isTest
public  class CQupdAcctHoldsV5_Test {
    
    public static final String POSITIVE_RESPONSE_BODY = '{"NBSAPDPO":{"outputHeader":{"NBNAPLO_ECHO_KEY":"","NBNAPLO_REASON_CODE":0,"NBNAPLO_RETURN_CODE":0,"NBNAPLO_VERSION":"","NBNAPLO_SERVICE_VERSION":"BUSO004"}},"CQS525O":{"outputCopybook":{"CQN525O_ACCOUNT_NBR_OUT":0,"CQN525O_CONFIRMATION_DETAILS":[{"CQN525O_DETAILS":""},{"CQN525O_DETAILS":""},{"CQN525O_DETAILS":""},{"CQN525O_DETAILS":""},{"CQN525O_DETAILS":""},{"CQN525O_DETAILS":""},{"CQN525O_DETAILS":""},{"CQN525O_DETAILS":""},{"CQN525O_DETAILS":""},{"CQN525O_DETAILS":""},{"CQN525O_DETAILS":""},{"CQN525O_DETAILS":""},{"CQN525O_DETAILS":""},{"CQN525O_DETAILS":""},{"CQN525O_DETAILS":""},{"CQN525O_DETAILS":""},{"CQN525O_DETAILS":""},{"CQN525O_DETAILS":""},{"CQN525O_DETAILS":""},{"CQN525O_DETAILS":""},{"CQN525O_DETAILS":""},{"CQN525O_DETAILS":""},{"CQN525O_DETAILS":""}]}},"NBSMSGO3":{"outputErrorMessage":{"NBNMSGO3_NBR_USER_ERRS":1,"NBSMSGO3_VERSION":"","NBNMSGO3_SYS_ERR_TXT":"","NBNMSGO3_NBR_USER_MSGS":1,"NBNMSGO3_MSG_ENTRY":[{"NBNMSGO3_MSG_ERR_IND":"E","NBNMSGO3_MSG_TXT":"Data has not been changed - please enter changes.","NBNMSGO3_MSG_CLASS":"CQSMGC01","NBNMSGO3_MSG_CODE":"0012"},{"NBNMSGO3_MSG_ERR_IND":"","NBNMSGO3_MSG_TXT":"","NBNMSGO3_MSG_CLASS":"","NBNMSGO3_MSG_CODE":""},{"NBNMSGO3_MSG_ERR_IND":"","NBNMSGO3_MSG_TXT":"","NBNMSGO3_MSG_CLASS":"","NBNMSGO3_MSG_CODE":""},{"NBNMSGO3_MSG_ERR_IND":"","NBNMSGO3_MSG_TXT":"","NBNMSGO3_MSG_CLASS":"","NBNMSGO3_MSG_CODE":""},{"NBNMSGO3_MSG_ERR_IND":"","NBNMSGO3_MSG_TXT":"","NBNMSGO3_MSG_CLASS":"","NBNMSGO3_MSG_CODE":""}]}}}';

    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{CQupdAcctHoldsV5_IH_v1.INTEGRATION_SERVICE_NAME});
    }

    @isTest static void testPositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));

        Test.startTest();

        CQupdAcctHoldsV5_Resp_IB_v1 responseBean = callHandlerMethod();
        System.assertEquals(200, responseBean.statusCode);

        Test.stopTest();
    }

    private static CQupdAcctHoldsV5_Resp_IB_v1 callHandlerMethod() {
        
        CQupdAcctHoldsV5_Req_IB_v1 dummyBean = CQupdAcctHoldsV5_Req_IB_v1.createDummy();
        CQupdAcctHoldsV5_Resp_IB_v1 responseBean = CQupdAcctHoldsV5_IH_v1.CQupdAcctHoldsV5(dummyBean);

        return responseBean;
    }

}