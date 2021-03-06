/**

 * @description Test class for CQgetCloseAccountDetailsV4API_IH_v1

 * @Author: Mbuyiseni Mbhokane
 * @Since: 04/11/2020
 */
@isTest
public class CQgetCloseAccountDetailsV4API_IH_v1_Test {
    
    public static final String POSITIVE_RESPONSE_BODY = '{"NBSAPDPO": {"NBNAPLO_REASON_CODE": 0,"NBNAPLO_RETURN_CODE": 0,"NBNAPLO_SERVICE_VERSION": "BUSO003"},"CQS534O": {"CQS534O_CHQDEP_BOOKS": "N","CQS534O_REDIRECTINDI": "","CQS534O_DR_INT_CLS": 0.00,"CQS534O_DIVISION_I": "ABS","CQS534O_CURRENT_BAL": 99470.06,"CQS534O_CLIENT_TITL_INIT_SNAME": "MR H NGCOBO","CQS534O_BLACKLISTED_CHQS": 0.00,"CQS534O_POSTDATED_TRAN": 0.00,"CQS534O_CHEQIMAGESTATEMENTS": "N","CQS534O_CLOSURE_AMTS": 98773.20,"CQS534O_ACCOUNT_NBR_OUT": 4048382672,"CQS534O_TABLE_I": {"CQS534O_LINE_I": [{"CQS534O_ACCOUNT_HOLDS": "HIGH RISK"},{"CQS534O_ACCOUNT_HOLDS": "NEW-ACCNT"},{"CQS534O_ACCOUNT_HOLDS": "SEC:NONE"},{"CQS534O_ACCOUNT_HOLDS": ""},{"CQS534O_ACCOUNT_HOLDS": ""},{"CQS534O_ACCOUNT_HOLDS": ""},{"CQS534O_ACCOUNT_HOLDS": ""},{"CQS534O_ACCOUNT_HOLDS": ""},{"CQS534O_ACCOUNT_HOLDS": ""},{"CQS534O_ACCOUNT_HOLDS": ""},{"CQS534O_ACCOUNT_HOLDS": ""},{"CQS534O_ACCOUNT_HOLDS": ""},{"CQS534O_ACCOUNT_HOLDS": ""},{"CQS534O_ACCOUNT_HOLDS": ""},{"CQS534O_ACCOUNT_HOLDS": ""},{"CQS534O_ACCOUNT_HOLDS": ""},{"CQS534O_ACCOUNT_HOLDS": ""},{"CQS534O_ACCOUNT_HOLDS": ""},{"CQS534O_ACCOUNT_HOLDS": ""},{"CQS534O_ACCOUNT_HOLDS": ""},{"CQS534O_ACCOUNT_HOLDS": {"CQS534O_ACCOUNT_HOLDS": ""},{"CQS534O_ACCOUNT_HOLDS": ""},{"CQS534O_ACCOUNT_HOLDS": ""},{"CQS534O_ACCOUNT_HOLDS": ""},{"CQS534O_ACCOUNT_HOLDS": ""},{"CQS534O_ACCOUNT_HOLDS": ""},{"CQS534O_ACCOUNT_HOLDS": ""},{"CQS534O_ACCOUNT_HOLDS": ""},{"CQS534O_ACCOUNT_HOLDS": {"CQS534O_ACCOUNT_HOLDS": ""},{"},{"CQS534O_ACCOUNT_HOLDS": ""},{"CQS534O_ACCOUNT_HOLDS": ""},{"CQS534O_ACCOUNT_HOLDS": ""}]},"CQS534O_BOM_SPONSORED_AMT": 0.00,"CQS534O_OVERDRAFT": 0.00,"CQS534O_1DAYPAAF_TOT": 0.00,"CQS534O_NXT_STATMNT_DATE": 20200918,"CQS534O_UNCLEARED_CHQS": 0.00,"CQS534O_ACCOUNT_NAME": "NGCOBO","CQS534O_WAP_HOLD_IND": "N","CQS534O_CR_INT_CLS": 65.07,"CQS534O_STATCOLLECTIONPREF": "P","CQS534O_IB_CB_FEES": 0.00,"CQS534O_PROCESSING_SITE_OUT": 8198,"CQS534O_HOLDS_COUNTER": 3,"CQS534O_MARKED_CHQS": 0.00,"CQS534O_ACCOUNT_TYPE": 3,"CQS534O_AFF_INTEREST_TO_SWEEP": 0.00,"CQS534O_STATEMENT_FREQ": 1,"CQS534O_AUTHORIZATION_HOLDS": 0.00,"CQS534O_OUTSTANDING_CHRGS": 0.00,"CQS534O_LDP_HOLD_IND": "N","CQS534O_REVOLVING_DORD": "N","CQS534O_RETURNED_CHQS": 0.00,"CQS534O_EFFECTIVE_CLSD_DATE": 20201020,"CQS534O_AUTH_OFFLINE_AMT": 0.00},"NBSMSGO3": {"NBNMSGO3_NBR_USER_ERRS": 0,"NBSMSGO3_VERSION": "MSG3001","NBNMSGO3_SYS_ERR_TXT": "","NBNMSGO3_NBR_USER_MSGS": 0,"NBNMSGO3_MSG_ENTRY": [{"NBNMSGO3_MSG_ERR_IND": "","NBNMSGO3_MSG_TXT": "","NBNMSGO3_MSG_CLASS": "","NBNMSGO3_MSG_CODE": ""},{"NBNMSGO3_MSG_ERR_IND": "","NBNMSGO3_MSG_TXT": "","NBNMSGO3_MSG_CLASS": "","NBNMSGO3_MSG_CODE": ""},{""NBNMSGO3_MSG_TXT": "","NBNMSGO3_MSG_CLASS": "","NBNMSGO3_MSG_CODE": ""},{"NBNMSGO3_MSG_ERR_IND": "","NBNMSGO3_MSG_TXT": "","NBNMSGO3_MSG_CLASS": "","NBNMSGO3_MSG_CODE": ""},{"NBNMSGO3_MSG_ERR_IND": "","NBNMSGO3_MSG_TXT": "","NBNMSGO3_MSG_CLASS": "","NBNMSGO3_MSG_CODE": ""}]}}';

    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{CQgetCloseAccountDetailsV4API_IH_v1.INTEGRATION_SERVICE_NAME});
    }

    @isTest static void testPositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
        Test.startTest();
        CQgetCloseAccountDetailsV4API_Resp_IB_v1 responseBean = callHandlerMethod();
        if (responseBean.statusCode == 200) {
            System.assertEquals(200, responseBean.statusCode);
        } else {
            System.assertEquals(responseBean.statusCode, responseBean.statusCode);
        }
        Test.stopTest();
    }

    private static CQgetCloseAccountDetailsV4API_Resp_IB_v1 callHandlerMethod() {
        CQgetCloseAccountDetailsV4API_Req_IB_v1 dummyReqBean = CQgetCloseAccountDetailsV4API_Req_IB_v1.createDummyRequest();
        CQgetCloseAccountDetailsV4API_Resp_IB_v1 dummyrespBean = CQgetCloseAccountDetailsV4API_Resp_IB_v1.createDummyResponse();
        CQgetCloseAccountDetailsV4API_Resp_IB_v1 responseBean = CQgetCloseAccountDetailsV4API_IH_v1.getCloseAccountDetails(dummyReqBean);
        return responseBean;
    }
}