/*
 * Integration Handler for CQcreateAndLinkAccountV9 Service Test Class
 * @author André Pietersen
 * @created 2020-10-30
 * 1.1   2021-05-27   André Pietersen (IQ Business)   Added Multiple SOF
 */

@isTest
public class CQcreateAndLinkAccountV9_IH_v1_Test {
    public static final String POSITIVE_RESPONSE_BODY = '{ "CQS411O": { "outputErrorMessage": { "creditBackdateLimit": "", "crditBackdateLimitA": "",             "studiesCompleted": "",             "surechequeIndA": "",             "studyCourseA": "",             "riskTypeA": "",             "shadowLimitInd": "",             "corpCode": "ABS",             "corpSubProductA": "",             "postGradStudent": "",             "trustS781Acct": 0,             "clientType": 101,             "corpSubProduct": "",             "surechequeInd": "",             "mandateNbrA": "",             "trustS781AcctA": "",             "repayingInd": "",             "acctOpenDate": 0,             "clientNameA": "",             "studyInstitution": "",             "unilateralLimitIndA": "",             "studentLoanInd": "",             "extraFinanceReqrd": "",             "nbrYearsRepeated": 0,             "studiesCompletedA": "",             "businessAcct": 0,             "chqBookColectSiteA": "",             "acctOpenReason": 0,             "debitBackdateLimit": "",             "siteNameA": "",             "shadowLimitIndA": "",             "repaymentStartDateA": "",             "debitBackdateLimitA": "",             "lawSocietyRegionA": "",             "fullTimeStudent": "",             "managerNbrA": "",             "lowRiskHoldAmountA": "",             "fullTimeStudentA": "",             "clientName": "",             "accountName": "",             "siteName": "",             "repayingIndA": "",             "repaymentStartDate": 0,             "acbUserA": "",             "studentNbrA": "",             "normalDurationA": "",             "AccountNbrOut": 0,             "acbUser": "",             "riskType": "",             "currentAcademicYear": 0,             "acctStoppedInd": "",             "unilateralLimitInd": "",             "postGradStudentA": "",             "relatedAcctNbr": 0,             "curentAcademicYearA": "",             "trustSweepingInd": "",             "trustSweepingIndA": "",             "surechequeRetention": 0,             "studyInstitutionA": "",             "lawSocietyRegion": "",             "chqBookCollectSite": 0,             "managerNbr": 0,             "extraFinanceReqrdA": "",             "acctOpenReasonA": "",             "mandateNbr": 0,             "lowRiskHoldAmount": 0,             "businessAcctA": "",             "nbrYearsRepeatedA": "",             "normalDuration": 0,             "studentNbr": "",             "sicCode": 0,             "acctStoppedIndA": "",             "accountNameA": "",             "finalYear": "",             "studyCourse": "",             "finalYearA": "",             "surechequeRetentionA": "",             "acctOpenDateA": ""         }     },     "NBSAPDPO": {         "outputErrorHeaders": {             "returnCode": 0,             "outputServiceVersion": "BUSO002",             "reasonCode": 0         }     },     "MSGO": {         "NBSMSGO3": {             "NBNMSGO3_NBR_USER_ERRS": 1,             "NBSMSGO3_VERSION": "",             "NBNMSGO3_SYS_ERR_TXT": "",             "NBNMSGO3_NBR_USER_MSGS": 1,             "NBNMSGO3_MSG_ENTRY": [                 {                     "NBNMSGO3_MSG_ERR_IND": "E",                     "NBNMSGO3_MSG_TXT": "The open date may only be back-dated 7 days.",                     "NBNMSGO3_MSG_CLASS": "CQSMGC01",                     "NBNMSGO3_MSG_CODE": "0029"                 },                 {                     "NBNMSGO3_MSG_ERR_IND": "",                     "NBNMSGO3_MSG_TXT": "",                     "NBNMSGO3_MSG_CLASS": "",                     "NBNMSGO3_MSG_CODE": ""                 },                 {                     "NBNMSGO3_MSG_ERR_IND": "",                     "NBNMSGO3_MSG_TXT": "",                     "NBNMSGO3_MSG_CLASS": "",                     "NBNMSGO3_MSG_CODE": ""                 },                 {                     "NBNMSGO3_MSG_ERR_IND": "",                     "NBNMSGO3_MSG_TXT": "",                     "NBNMSGO3_MSG_CLASS": "",                     "NBNMSGO3_MSG_CODE": ""                 },                 {                     "NBNMSGO3_MSG_ERR_IND": "",                     "NBNMSGO3_MSG_TXT": "",                     "NBNMSGO3_MSG_CLASS": "",                     "NBNMSGO3_MSG_CODE": ""                 }             ]         }     } }';

    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{CQcreateAndLinkAccountV9_IH_v1.INTEGRATION_SERVICE_NAME});
    }

    @isTest static void testPositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
        Test.startTest();
        CQcreateAndLinkAccountV9_Resp_IB_v1 responseBean = callHandlerMethod();
        System.assertEquals(200, responseBean.statusCode);
        Test.stopTest();
    }

    private static CQcreateAndLinkAccountV9_Resp_IB_v1 callHandlerMethod() {        
        CQcreateAndLinkAccountV9_Req_IB_v1 dummyBean = CQcreateAndLinkAccountV9_Req_IB_v1.createDummyRequest();
        CQcreateAndLinkAccountV9_Resp_IB_v1 responseBean = CQcreateAndLinkAccountV9_IH_v1.createAndLinkAccount(dummyBean);
        return responseBean;
    }
}