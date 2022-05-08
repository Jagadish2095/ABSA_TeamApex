/*
* Test Integration Handler for GBGetContBranchDetV1_IH_v1 Service
* @author Saurabh
* @created 2020-09-22
*/

@isTest
public class GBGetContBranchDetV1_IH_v1_Test {

    public static final String POSITIVE_RESPONSE_BODY = '{"GSB021O":{"GSB021O":{"GSB021O_BUSINESS_SUB_SEG":"","GSB021O_OVER_CONT_OFF_NUM":0,"GSB021O_BUSINESS_SEG":"","GSB021O_AGRI_CLIENT":"","GSB021O_DATE_APPROVED":0,"GSB021O_CONTROL_BRANCH":0,"GSB021O_CAP_BY_EMPLOYEE":0,"GSB021O_GROUP_REVIEW_DATE":0,"GSB021O_CONT_OFF_NUM":0,"GSB021O_STATUS":"","GSB021O_BANKING_SECTOR":"","GSB021O_OVERALL_CONTROL":0,"GSB021O_CONT_OFF_TYPE":"","GSB021O_FRANCHISOR_CODE":0,"GSB021O_DATE_CREATED":0,"GSB021O_FRANCH_CODE_DESC":"","GSB021O_OVER_CONT_OFF_TYP":"","GSB021O_BANK_SECTOR_CODE":0,"GSB021O_APP_BY_EMPLOYEE":0,"GSB021O_INDV_GROUP":"","GSB021O_DIVISION_CODE":"","GSB021O_SQL_MESS_CODE":"","GSB021O_LAST_ACTION":"","GSB021O_EXPOSURE_POLICY":""}},"NBSAPDPO":{"NBSAPLO":{"returnCode":0,"outputServiceVersion":"BUSO001","reasonCode":0}},"NBSMSGO3":{"NBSMSGO3":{"NBNMSGO3_NBR_USER_ERRS":1,"NBSMSGO3_VERSION":"","NBNMSGO3_SYS_ERR_TXT":"","NBNMSGO3_NBR_USER_MSGS":1,"NBNMSGO3_MSG_ENTRY":[{"NBNMSGO3_MSG_ERR_IND":"E","NBNMSGO3_MSG_TXT":"Invalid Input Data Received","NBNMSGO3_MSG_CLASS":"GBSMGC01","NBNMSGO3_MSG_CODE":"0036"},{"NBNMSGO3_MSG_ERR_IND":"","NBNMSGO3_MSG_TXT":"","NBNMSGO3_MSG_CLASS":"","NBNMSGO3_MSG_CODE":""},{"NBNMSGO3_MSG_ERR_IND":"","NBNMSGO3_MSG_TXT":"","NBNMSGO3_MSG_CLASS":"","NBNMSGO3_MSG_CODE":""},{"NBNMSGO3_MSG_ERR_IND":"","NBNMSGO3_MSG_TXT":"","NBNMSGO3_MSG_CLASS":"","NBNMSGO3_MSG_CODE":""},{"NBNMSGO3_MSG_ERR_IND":"","NBNMSGO3_MSG_TXT":"","NBNMSGO3_MSG_CLASS":"","NBNMSGO3_MSG_CODE":""}]}}}';
    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{GBGetContBranchDetV1_IH_v1.INTEGRATION_SERVICE_NAME});
    }

    @isTest static void testPositive() {
        // Set mock callout class
        gbGetContBranchTestMock();

        Test.startTest();

        GBGetContBranchDetV1_Resp_IB_v1 responseBean = callHandlerMethod();
        System.assertEquals(200, responseBean.statusCode);

        Test.stopTest();
    }

    public static void gbGetContBranchTestMock() {
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
    }

    private static GBGetContBranchDetV1_Resp_IB_v1 callHandlerMethod() {
        GBGetContBranchDetV1_Req_IB_v1 dummyBean = GBGetContBranchDetV1_Req_IB_v1.createDummyRequest();
        GBGetContBranchDetV1_Resp_IB_v1 responseBean = GBGetContBranchDetV1_IH_v1.GBGetContBranchDetV1(dummyBean);
        return responseBean;
    }
}