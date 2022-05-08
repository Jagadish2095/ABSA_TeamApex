/*
 * Request Integration Bean for CQupdAcctOpenDetailV4Service Service
 * @author Willy Zuvana
 * @created 2021-04-06
 */
@isTest
public class CQupdAcctOpenDetailV4Service_IH_v1_Test {
    
    public static final String POSITIVE_RESPONSE_BODY = '{"NBSAPDPO":{"NBSAPLO":{"returnCode":0,"outputServiceVersion":"BUSO002","reasonCode":0}},"NBSMSGO3":{"NBSMSGO3":{"NBNMSGO3_NBR_USER_ERRS":1,"NBSMSGO3_VERSION":"MSG3001","NBNMSGO3_SYS_ERR_TXT":"","NBNMSGO3_NBR_USER_MSGS":1,"NBNMSGO3_MSG_ENTRY":[{"NBNMSGO3_MSG_ERR_IND":"E","NBNMSGO3_MSG_TXT":"The open date may only be back-dated 7 days.","NBNMSGO3_MSG_CLASS":"CQSMGC01","NBNMSGO3_MSG_CODE":"0029"},{"NBNMSGO3_MSG_ERR_IND":"","NBNMSGO3_MSG_TXT":"","NBNMSGO3_MSG_CLASS":"","NBNMSGO3_MSG_CODE":""},{"NBNMSGO3_MSG_ERR_IND":"","NBNMSGO3_MSG_TXT":"","NBNMSGO3_MSG_CLASS":"","NBNMSGO3_MSG_CODE":""},{"NBNMSGO3_MSG_ERR_IND":"","NBNMSGO3_MSG_TXT":"","NBNMSGO3_MSG_CLASS":"","NBNMSGO3_MSG_CODE":""},{"NBNMSGO3_MSG_ERR_IND":"","NBNMSGO3_MSG_TXT":"","NBNMSGO3_MSG_CLASS":"","NBNMSGO3_MSG_CODE":""}]}},"CQT413O":{"outputArea":{"oSiteName":"","oTypeStudyCourseDesc":"","oTransactionTime":0,"oShadowLimitIndDesc":"","oStudiesCompletedDesc":"","oFinalYearDesc":"","oRiskTypeAmount":"","oNormalDurationDesc":"","oAcctStoppedDesc":"","oACBUserDesc":"","oDepositIDTelephone":"","oAcctOpenReasonDesc":"","oFullTimeStudentDesc":"","oAccountTypeDesc":"","oCurrentAcadYearDesc":"","oNewAccountDesc":"","oRepayingIndDesc":"","oTrustSweepingIndDesc":"","oDepositIDName":"","oNextStatementDate":0,"oSpecialInstructions":"","oDuplicateStatement":"","oDbtBackdateLimitDesc":"","oExtraFinanceReqDesc":"","oTransactionDate":"","oCrdBackdateLimitDesc":"","oStatementFrequency":"","oDepositIDMessage":"","oNbrYearsFailed":"","oSiteDivision":"","oCorpSubProductDesc":"","oUniltrlLimitIndDesc":"","oStudyCourseDesc2":"","oPostGradStudentDesc":"","oMandateHolderName":"","oStudyCourseDesc1":""}}}';

    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{CQupdAcctOpenDetailV4Service_IH_v1.INTEGRATION_SERVICE_NAME});
    }

    @isTest static void testPositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
        Test.startTest();
        CQupdAcctOpenDetailV4Service_Resp_IB_v1 responseBean = callHandlerMethod();
        System.assertEquals(200, responseBean.statusCode);
        Test.stopTest();
    }

    private static CQupdAcctOpenDetailV4Service_Resp_IB_v1 callHandlerMethod() {
        
        CQupdAcctOpenDetailV4Service_Req_IB_v1 dummyBean = CQupdAcctOpenDetailV4Service_Req_IB_v1.createDummyRequest();
        CQupdAcctOpenDetailV4Service_Resp_IB_v1 responseBean = CQupdAcctOpenDetailV4Service_IH_v1.CQupdAcctOpenDetailV4Service(dummyBean);
        return responseBean;
    }
}