/*
* Integration Handler Test class for Triad Service
* @author
* @created 2020-09-22
*/
@isTest
public class GetTriads_IH_v1_Test {

    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{GetTriads_IH_v1.INTEGRATION_SERVICE_NAME});
    }

  	@isTest
    static void testPositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, generatePositiveResponseBody()));
        Test.startTest();

        GetTriads_Resp_IB_v1 responseBean = callHandlerMethod();
        System.assertEquals(200, responseBean.statusCode);

        Test.stopTest();
    }

    @isTest
    static void testgetTriadsFromService() {
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, generatePositiveResponseBody()));
        Application__c Application = new Application__c();
        Insert Application;

        Test.startTest();
        GetTriadsController.getTriadsFromService('',Application.Id,true,'');
        Application_Triad__c appTriad = [Select id from Application_Triad__c where Application__c =: Application.Id];
        system.assertNotEquals(null, appTriad,'There should be a value');
        Test.stopTest();
    }

  	private static GetTriads_Resp_IB_v1 callHandlerMethod() {
        //GetTriads_Req_IB_v1 dummyBean = GetTriads_Req_IB_v1.createDummyRequest();
        GetTriads_Resp_IB_v1 responseBean = GetTriads_IH_v1.GetTriads('absa 001');
        return responseBean;
    }

    /**
     * @description generatePositiveResponseBody description
     *
     * @return String: Return description
     */
    public static String generatePositiveResponseBody(){
        String POSITIVE_RESPONSE_BODY = '{"TRC519O":{"TRC519O_OUTPUT_PROCESS_RESULTS":{"TRC519O_RETURN_CODE":10},"TRC519O_OUTPUT_DATA":{"TRC519O_AGE_CUST_RELATIONSHIP":0,';
        POSITIVE_RESPONSE_BODY += '"TRC519O_LIMIT_ACCL":0,"TRC519O_TOT_VAL_CREDITS_L6M":0,"TRC519O_TRIAD_EXCL_REASON":"","TRC519O_DATE_OPEN_OLDEST_SAV":20060130,';
        POSITIVE_RESPONSE_BODY += '"TRC519O_AVG_CTO_L3M_L6M":0.00,"TRC519O_BEH_SCORE_AVAF":0,"TRC519O_NUM_MTS_EXS_L6M":0,"TRC519O_DATE_OPEN_OLDEST_CHQ":20060130,';
        POSITIVE_RESPONSE_BODY += '"TRC519O_LIMIT_ABRA":0,"TRC519O_LIMIT_AMMR":0,"TRC519O_DATE_CUST_REL":0,"TRC519O_BEH_SCORE_LOANS":0,"TRC519O_MAX_CONSEQ_DAYS_EXS":0,';
        POSITIVE_RESPONSE_BODY += '"TRC519O_TRIAD_EXCLUSION":"","TRC519O_NUM_CHQ_RD_L6M":0,"TRC519O_BEH_SCORE_CHQ":0,"TRC519O_VAL_SAV_RET_PYMNT_L6M":0,';
        POSITIVE_RESPONSE_BODY += '"TRC519O_LIMIT_CAPPED_AOL":0,"TRC519O_NUM_SAV_RD_L3M":0,"TRC519O_NUM_SAV_RD_L6M":0,"TRC519O_DAYS_IN_CREDIT_CHQ_L6M":0,';
        POSITIVE_RESPONSE_BODY += '"TRC519O_AGE_CHQ_RELATIONSHIP":0,"TRC519O_CFAC_EXCLUSION_REASON":0,"TRC519O_LIMIT_AMLR":0,"TRC519O_TOT_VAL_DEBITS_L6M":0,';
        POSITIVE_RESPONSE_BODY += '"TRC519O_DAYS_IN_DEBIT_CHQ_L6M":0,"TRC519O_BEH_SCORE_CARD":0,"TRC519O_EXP_CREDIT_TURNOVER_CU":0,"TRC519O_AGE_SAV_RELATIONSHIP":0,';
        POSITIVE_RESPONSE_BODY += '"TRC519O_MAX_ORD_CRED_EXPOSURE":0,"TRC519O_VAL_CHQ_RET_PYMNT_L6M":0,"TRC519O_EXP_CREDIT_TURNOVER_CQ":0,"TRC519O_LIMIT_AOL":0,';
        POSITIVE_RESPONSE_BODY += '"TRC519O_AGE_ACC_RELATIONSHIP":0,"TRC519O_CUST_ALIGN_SCORE":0,"TRC519O_PROT_NCA":"","TRC519O_CFAC_EXCLUSION":"",';
        POSITIVE_RESPONSE_BODY += '"TRC519O_AVG_CTO_L6M_L12M":0.00,"TRC519O_DATE_OPEN_OLDEST_ACC":0,"TRC519O_LIMIT_AMR":0,"TRC519O_NUM_CHQ_RD_L3M":0,';
        POSITIVE_RESPONSE_BODY += '"TRC519O_COND_ACCOUNT_DETAILS":[{"TRC519O_COND_ACC_VAL_DP_RETPY":0,"TRC519O_COND_ACC_VAL_CQ_RETPY":0,"TRC519O_COND_ACC_MIN_BAL":0,';
        POSITIVE_RESPONSE_BODY += '"TRC519O_COND_ACC_DAYS_EXCESS":0,"TRC519O_COND_ACC_DR_TURNOVER":0,"TRC519O_COND_ACC_AVG_BAL":0,"TRC519O_COND_ACC_CR_TURNOVER":0,';
        POSITIVE_RESPONSE_BODY += '"TRC519O_COND_ACC_TOT_LIMIT":0,"TRC519O_COND_ACC_NUM_DR_SAV":0,"TRC519O_COND_ACC_NUM_CQ_RD_EV":0,"TRC519O_COND_CLNT_RISK_GRADE":0,';
        POSITIVE_RESPONSE_BODY += '"TRC519O_COND_ACC_HIGH_LIMIT":0,"TRC519O_COND_ACC_DAYS_DR_CHQ":0,"TRC519O_COND_ACC_NUM_DP_RD_EV":0,"TRC519O_COND_ACC_MAX_BAL":0,';
        POSITIVE_RESPONSE_BODY += '"TRC519O_COND_ACC_NUM_DR_CHQ":0,"TRC519O_COND_NO_OPEN_CQ_ACC":0,"TRC519O_COND_ACC_DAYS_CR_CHQ":0},{"TRC519O_COND_ACC_VAL_DP_RETPY":0,';
        POSITIVE_RESPONSE_BODY += '"TRC519O_COND_ACC_VAL_CQ_RETPY":0,"TRC519O_COND_ACC_MIN_BAL":0,"TRC519O_COND_ACC_DAYS_EXCESS":0,"TRC519O_COND_ACC_DR_TURNOVER":0,';
        POSITIVE_RESPONSE_BODY += '"TRC519O_COND_ACC_AVG_BAL":0,"TRC519O_COND_ACC_CR_TURNOVER":0,"TRC519O_COND_ACC_TOT_LIMIT":0,"TRC519O_COND_ACC_NUM_DR_SAV":0,';
        POSITIVE_RESPONSE_BODY += '"TRC519O_COND_ACC_NUM_CQ_RD_EV":0,"TRC519O_COND_CLNT_RISK_GRADE":0,"TRC519O_COND_ACC_HIGH_LIMIT":0,"TRC519O_COND_ACC_DAYS_DR_CHQ":0,';
        POSITIVE_RESPONSE_BODY += '"TRC519O_COND_ACC_NUM_DP_RD_EV":0,"TRC519O_COND_ACC_MAX_BAL":0,"TRC519O_COND_ACC_NUM_DR_CHQ":0,"TRC519O_COND_NO_OPEN_CQ_ACC":0,';
        POSITIVE_RESPONSE_BODY += '"TRC519O_COND_ACC_DAYS_CR_CHQ":0},{"TRC519O_COND_ACC_VAL_DP_RETPY":0,"TRC519O_COND_ACC_VAL_CQ_RETPY":0,"TRC519O_COND_ACC_MIN_BAL":0,';
        POSITIVE_RESPONSE_BODY += '"TRC519O_COND_ACC_DAYS_EXCESS":0,"TRC519O_COND_ACC_DR_TURNOVER":0,"TRC519O_COND_ACC_AVG_BAL":0,"TRC519O_COND_ACC_CR_TURNOVER":0,';
        POSITIVE_RESPONSE_BODY += '"TRC519O_COND_ACC_TOT_LIMIT":0,"TRC519O_COND_ACC_NUM_DR_SAV":0,"TRC519O_COND_ACC_NUM_CQ_RD_EV":0,"TRC519O_COND_CLNT_RISK_GRADE":0,';
        POSITIVE_RESPONSE_BODY += '"TRC519O_COND_ACC_HIGH_LIMIT":0,"TRC519O_COND_ACC_DAYS_DR_CHQ":0,"TRC519O_COND_ACC_NUM_DP_RD_EV":0,"TRC519O_COND_ACC_MAX_BAL":0,';
        POSITIVE_RESPONSE_BODY += '"TRC519O_COND_ACC_NUM_DR_CHQ":0,"TRC519O_COND_NO_OPEN_CQ_ACC":0,"TRC519O_COND_ACC_DAYS_CR_CHQ":0}],"TRC519O_BEH_SCORE_MLOAN":0}},';
        POSITIVE_RESPONSE_BODY += '"NBSAPDPO":{"NBSAPLO":{"NBNAPLO_REASON_CODE":0,"NBNAPLO_RETURN_CODE":0,"NBNAPLO_SERVICE_VERSION":"BUSO002"}}}';

        return POSITIVE_RESPONSE_BODY;
    }
}