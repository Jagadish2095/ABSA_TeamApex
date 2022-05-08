/**
 * @description Test class for Triad Monthly Activity Controller
 *
 * @author  Gopi Budaraju (ZA)
 * @version v1.0n
 * @since   2020/09/20
 * @UserStory W:006253
 *
 * @update Englarmerge Mongwe
 * @date 2021-01-07
 * Complete UserStory W:006253
 */
@IsTest
public class TriadMonthlyActivityControllerTest {
    /**
    * @description method to setup test data
    * @author englarmerdge.mongwe@absa.africa | 2020/09/20
    **/
    @testSetup
    public static void dataCreation() {
        ClientDetailsSectionCreditTest.dataCreation();
        IntegrationTestDataFactory.insertIntegrationSettings(GetTriads_IH_v1.INTEGRATION_SERVICE_NAME, new List<String>{monthlyCalculations_IH_v1.INTEGRATION_SERVICE_NAME});
    }

    /**
    * @description test method to GetApplicationTriadMonthlyActivities
    * @author englarmerdge.mongwe@absa.africa | 2020/09/20
    **/
    @IsTest
    public static void testGetApplicationTriadMonthlyActivities(){
        //Opportunity opp = [SELECT Id FROM Opportunity WHERE Name = 'Cheque Credit Onboarding' LIMIT 1];
        monthlyCalculations_IH_v1_Test.monthlyCalTestMock();
        monthlyCallHandlerMethod();

        Account ac = new Account();
        ac.Name='Test';
        ac.CIF__c= 'CLOSE  001'; //NOZENZO001';
        insert ac;

        Opportunity opp = new Opportunity();
        opp.AccountId = ac.id;
        opp.Name = 'EPP';
        opp.StageName = 'Not Interested';
        opp.CloseDate = Date.today() + 10;
        Insert opp;

        Application__c app = new Application__c();
        app.Opportunity__c = opp.Id;
        Insert app;

        //create triad data
        Boolean isMainApplicant= true;
        String POSITIVE_RESPONSE_BODY = '{"TRC519O": {"TRC519O_OUTPUT_PROCESS_RESULTS": { "TRC519O_RETURN_CODE": 10   },   "TRC519O_OUTPUT_DATA": { "TRC519O_AGE_CUST_RELATIONSHIP": 0, "TRC519O_LIMIT_ACCL": 0, "TRC519O_TOT_VAL_CREDITS_L6M": 0, "TRC519O_TRIAD_EXCL_REASON": "", "TRC519O_DATaE_OPEN_OLDEST_SAV": 0, "TRC519O_AVG_CTO_L3M_L6M": 0.00, "TRC519O_BEH_SCORE_AVAF": 0, "TRC519O_NUM_MTS_EXS_L6M": 0, "TRC519O_DATE_OPEN_OLDEST_CHQ": 0, "TRC519O_LIMIT_ABRA": 0, "TRC519O_LIMIT_AMMR": 0, "TRC519O_DATE_CUST_REL": 0, "TRC519O_BEH_SCORE_LOANS": 0, "TRC519O_MAX_CONSEQ_DAYS_EXS": 0, "TRC519O_TRIAD_EXCLUSION": "", "TRC519O_NUM_CHQ_RD_L6M": 0, "TRC519O_BEH_SCORE_CHQ": 0, "TRC519O_VAL_SAV_RET_PYMNT_L6M": 0, "TRC519O_LIMIT_CAPPED_AOL": 0, "TRC519O_NUM_SAV_RD_L3M": 0, "TRC519O_NUM_SAV_RD_L6M": 0, "TRC519O_DAYS_IN_CREDIT_CHQ_L6M": 0, "TRC519O_AGE_CHQ_RELATIONSHIP": 0, "TRC519O_CFAC_EXCLUSION_REASON": 0, "TRC519O_LIMIT_AMLR": 0, "TRC519O_TOT_VAL_DEBITS_L6M": 0, "TRC519O_DAYS_IN_DEBIT_CHQ_L6M": 0, "TRC519O_BEH_SCORE_CARD": 0, "TRC519O_EXP_CREDIT_TURNOVER_CU": 0, "TRC519O_AGE_SAV_RELATIONSHIP": 0, "TRC519O_MAX_ORD_CRED_EXPOSURE": 0, "TRC519O_VAL_CHQ_RET_PYMNT_L6M": 0, "TRC519O_EXP_CREDIT_TURNOVER_CQ": 0, "TRC519O_LIMIT_AOL": 0, "TRC519O_AGE_ACC_RELATIONSHIP": 0, "TRC519O_CUST_ALIGN_SCORE": 0, "TRC519O_PROT_NCA": "", "TRC519O_CFAC_EXCLUSION": "", "TRC519O_AVG_CTO_L6M_L12M": 0.00, "TRC519O_DATE_OPEN_OLDEST_ACC": 0, "TRC519O_LIMIT_AMR": 0, "TRC519O_NUM_CHQ_RD_L3M": 0, "TRC519O_COND_ACCOUNT_DETAILS": [    { "TRC519O_COND_ACC_VAL_DP_RETPY": 0, "TRC519O_COND_ACC_VAL_CQ_RETPY": 0, "TRC519O_COND_ACC_MIN_BAL": 0, "TRC519O_COND_ACC_DAYS_EXCESS": 0, "TRC519O_COND_ACC_DR_TURNOVER": 0, "TRC519O_COND_ACC_AVG_BAL": 0, "TRC519O_COND_ACC_CR_TURNOVER": 0, "TRC519O_COND_ACC_TOT_LIMIT": 0, "TRC519O_COND_ACC_NUM_DR_SAV": 0, "TRC519O_COND_ACC_NUM_CQ_RD_EV": 0, "TRC519O_COND_CLNT_RISK_GRADE": 0, "TRC519O_COND_ACC_HIGH_LIMIT": 0, "TRC519O_COND_ACC_DAYS_DR_CHQ": 0, "TRC519O_COND_ACC_NUM_DP_RD_EV": 0, "TRC519O_COND_ACC_MAX_BAL": 0, "TRC519O_COND_ACC_NUM_DR_CHQ": 0, "TRC519O_COND_NO_OPEN_CQ_ACC": 0, "TRC519O_COND_ACC_DAYS_CR_CHQ": 0    },    { "TRC519O_COND_ACC_VAL_DP_RETPY": 0, "TRC519O_COND_ACC_VAL_CQ_RETPY": 0, "TRC519O_COND_ACC_MIN_BAL": 0, "TRC519O_COND_ACC_DAYS_EXCESS": 0, "TRC519O_COND_ACC_DR_TURNOVER": 0, "TRC519O_COND_ACC_AVG_BAL": 0, "TRC519O_COND_ACC_CR_TURNOVER": 0, "TRC519O_COND_ACC_TOT_LIMIT": 0, "TRC519O_COND_ACC_NUM_DR_SAV": 0, "TRC519O_COND_ACC_NUM_CQ_RD_EV": 0, "TRC519O_COND_CLNT_RISK_GRADE": 0, "TRC519O_COND_ACC_HIGH_LIMIT": 0, "TRC519O_COND_ACC_DAYS_DR_CHQ": 0, "TRC519O_COND_ACC_NUM_DP_RD_EV": 0, "TRC519O_COND_ACC_MAX_BAL": 0, "TRC519O_COND_ACC_NUM_DR_CHQ": 0, "TRC519O_COND_NO_OPEN_CQ_ACC": 0, "TRC519O_COND_ACC_DAYS_CR_CHQ": 0    },    { "TRC519O_COND_ACC_VAL_DP_RETPY": 0, "TRC519O_COND_ACC_VAL_CQ_RETPY": 0, "TRC519O_COND_ACC_MIN_BAL": 0, "TRC519O_COND_ACC_DAYS_EXCESS": 0, "TRC519O_COND_ACC_DR_TURNOVER": 0, "TRC519O_COND_ACC_AVG_BAL": 0, "TRC519O_COND_ACC_CR_TURNOVER": 0, "TRC519O_COND_ACC_TOT_LIMIT": 0, "TRC519O_COND_ACC_NUM_DR_SAV": 0, "TRC519O_COND_ACC_NUM_CQ_RD_EV": 0, "TRC519O_COND_CLNT_RISK_GRADE": 0, "TRC519O_COND_ACC_HIGH_LIMIT": 0, "TRC519O_COND_ACC_DAYS_DR_CHQ": 0, "TRC519O_COND_ACC_NUM_DP_RD_EV": 0, "TRC519O_COND_ACC_MAX_BAL": 0, "TRC519O_COND_ACC_NUM_DR_CHQ": 0, "TRC519O_COND_NO_OPEN_CQ_ACC": 0, "TRC519O_COND_ACC_DAYS_CR_CHQ": 0    },    { "TRC519O_COND_ACC_VAL_DP_RETPY": 0, "TRC519O_COND_ACC_VAL_CQ_RETPY": 0, "TRC519O_COND_ACC_MIN_BAL": 0, "TRC519O_COND_ACC_DAYS_EXCESS": 0, "TRC519O_COND_ACC_DR_TURNOVER": 0, "TRC519O_COND_ACC_AVG_BAL": 0, "TRC519O_COND_ACC_CR_TURNOVER": 0, "TRC519O_COND_ACC_TOT_LIMIT": 0, "TRC519O_COND_ACC_NUM_DR_SAV": 0, "TRC519O_COND_ACC_NUM_CQ_RD_EV": 0, "TRC519O_COND_CLNT_RISK_GRADE": 0, "TRC519O_COND_ACC_HIGH_LIMIT": 0, "TRC519O_COND_ACC_DAYS_DR_CHQ": 0, "TRC519O_COND_ACC_NUM_DP_RD_EV": 0, "TRC519O_COND_ACC_MAX_BAL": 0, "TRC519O_COND_ACC_NUM_DR_CHQ": 0, "TRC519O_COND_NO_OPEN_CQ_ACC": 0, "TRC519O_COND_ACC_DAYS_CR_CHQ": 0    },    { "TRC519O_COND_ACC_VAL_DP_RETPY": 0, "TRC519O_COND_ACC_VAL_CQ_RETPY": 0, "TRC519O_COND_ACC_MIN_BAL": 0, "TRC519O_COND_ACC_DAYS_EXCESS": 0, "TRC519O_COND_ACC_DR_TURNOVER": 0, "TRC519O_COND_ACC_AVG_BAL": 0, "TRC519O_COND_ACC_CR_TURNOVER": 0, "TRC519O_COND_ACC_TOT_LIMIT": 0, "TRC519O_COND_ACC_NUM_DR_SAV": 0, "TRC519O_COND_ACC_NUM_CQ_RD_EV": 0, "TRC519O_COND_CLNT_RISK_GRADE": 0, "TRC519O_COND_ACC_HIGH_LIMIT": 0, "TRC519O_COND_ACC_DAYS_DR_CHQ": 0, "TRC519O_COND_ACC_NUM_DP_RD_EV": 0, "TRC519O_COND_ACC_MAX_BAL": 0, "TRC519O_COND_ACC_NUM_DR_CHQ": 0, "TRC519O_COND_NO_OPEN_CQ_ACC": 0, "TRC519O_COND_ACC_DAYS_CR_CHQ": 0    },    { "TRC519O_COND_ACC_VAL_DP_RETPY": 0, "TRC519O_COND_ACC_VAL_CQ_RETPY": 0, "TRC519O_COND_ACC_MIN_BAL": 0, "TRC519O_COND_ACC_DAYS_EXCESS": 0, "TRC519O_COND_ACC_DR_TURNOVER": 0, "TRC519O_COND_ACC_AVG_BAL": 0, "TRC519O_COND_ACC_CR_TURNOVER": 0, "TRC519O_COND_ACC_TOT_LIMIT": 0, "TRC519O_COND_ACC_NUM_DR_SAV": 0, "TRC519O_COND_ACC_NUM_CQ_RD_EV": 0, "TRC519O_COND_CLNT_RISK_GRADE": 0, "TRC519O_COND_ACC_HIGH_LIMIT": 0, "TRC519O_COND_ACC_DAYS_DR_CHQ": 0, "TRC519O_COND_ACC_NUM_DP_RD_EV": 0, "TRC519O_COND_ACC_MAX_BAL": 0, "TRC519O_COND_ACC_NUM_DR_CHQ": 0, "TRC519O_COND_NO_OPEN_CQ_ACC": 0, "TRC519O_COND_ACC_DAYS_CR_CHQ": 0    },    { "TRC519O_COND_ACC_VAL_DP_RETPY": 0, "TRC519O_COND_ACC_VAL_CQ_RETPY": 0, "TRC519O_COND_ACC_MIN_BAL": 0, "TRC519O_COND_ACC_DAYS_EXCESS": 0, "TRC519O_COND_ACC_DR_TURNOVER": 0, "TRC519O_COND_ACC_AVG_BAL": 0, "TRC519O_COND_ACC_CR_TURNOVER": 0, "TRC519O_COND_ACC_TOT_LIMIT": 0, "TRC519O_COND_ACC_NUM_DR_SAV": 0, "TRC519O_COND_ACC_NUM_CQ_RD_EV": 0, "TRC519O_COND_CLNT_RISK_GRADE": 0, "TRC519O_COND_ACC_HIGH_LIMIT": 0, "TRC519O_COND_ACC_DAYS_DR_CHQ": 0, "TRC519O_COND_ACC_NUM_DP_RD_EV": 0, "TRC519O_COND_ACC_MAX_BAL": 0, "TRC519O_COND_ACC_NUM_DR_CHQ": 0, "TRC519O_COND_NO_OPEN_CQ_ACC": 0, "TRC519O_COND_ACC_DAYS_CR_CHQ": 0    },    { "TRC519O_COND_ACC_VAL_DP_RETPY": 0, "TRC519O_COND_ACC_VAL_CQ_RETPY": 0, "TRC519O_COND_ACC_MIN_BAL": 0, "TRC519O_COND_ACC_DAYS_EXCESS": 0, "TRC519O_COND_ACC_DR_TURNOVER": 0, "TRC519O_COND_ACC_AVG_BAL": 0, "TRC519O_COND_ACC_CR_TURNOVER": 0, "TRC519O_COND_ACC_TOT_LIMIT": 0, "TRC519O_COND_ACC_NUM_DR_SAV": 0, "TRC519O_COND_ACC_NUM_CQ_RD_EV": 0, "TRC519O_COND_CLNT_RISK_GRADE": 0, "TRC519O_COND_ACC_HIGH_LIMIT": 0, "TRC519O_COND_ACC_DAYS_DR_CHQ": 0, "TRC519O_COND_ACC_NUM_DP_RD_EV": 0, "TRC519O_COND_ACC_MAX_BAL": 0, "TRC519O_COND_ACC_NUM_DR_CHQ": 0, "TRC519O_COND_NO_OPEN_CQ_ACC": 0, "TRC519O_COND_ACC_DAYS_CR_CHQ": 0    },    { "TRC519O_COND_ACC_VAL_DP_RETPY": 0, "TRC519O_COND_ACC_VAL_CQ_RETPY": 0, "TRC519O_COND_ACC_MIN_BAL": 0, "TRC519O_COND_ACC_DAYS_EXCESS": 0, "TRC519O_COND_ACC_DR_TURNOVER": 0, "TRC519O_COND_ACC_AVG_BAL": 0, "TRC519O_COND_ACC_CR_TURNOVER": 0, "TRC519O_COND_ACC_TOT_LIMIT": 0, "TRC519O_COND_ACC_NUM_DR_SAV": 0, "TRC519O_COND_ACC_NUM_CQ_RD_EV": 0, "TRC519O_COND_CLNT_RISK_GRADE": 0, "TRC519O_COND_ACC_HIGH_LIMIT": 0, "TRC519O_COND_ACC_DAYS_DR_CHQ": 0, "TRC519O_COND_ACC_NUM_DP_RD_EV": 0, "TRC519O_COND_ACC_MAX_BAL": 0, "TRC519O_COND_ACC_NUM_DR_CHQ": 0, "TRC519O_COND_NO_OPEN_CQ_ACC": 0, "TRC519O_COND_ACC_DAYS_CR_CHQ": 0    },    { "TRC519O_COND_ACC_VAL_DP_RETPY": 0, "TRC519O_COND_ACC_VAL_CQ_RETPY": 0, "TRC519O_COND_ACC_MIN_BAL": 0, "TRC519O_COND_ACC_DAYS_EXCESS": 0, "TRC519O_COND_ACC_DR_TURNOVER": 0, "TRC519O_COND_ACC_AVG_BAL": 0, "TRC519O_COND_ACC_CR_TURNOVER": 0, "TRC519O_COND_ACC_TOT_LIMIT": 0, "TRC519O_COND_ACC_NUM_DR_SAV": 0, "TRC519O_COND_ACC_NUM_CQ_RD_EV": 0, "TRC519O_COND_CLNT_RISK_GRADE": 0, "TRC519O_COND_ACC_HIGH_LIMIT": 0, "TRC519O_COND_ACC_DAYS_DR_CHQ": 0, "TRC519O_COND_ACC_NUM_DP_RD_EV": 0, "TRC519O_COND_ACC_MAX_BAL": 0, "TRC519O_COND_ACC_NUM_DR_CHQ": 0, "TRC519O_COND_NO_OPEN_CQ_ACC": 0, "TRC519O_COND_ACC_DAYS_CR_CHQ": 0    },    { "TRC519O_COND_ACC_VAL_DP_RETPY": 0, "TRC519O_COND_ACC_VAL_CQ_RETPY": 0, "TRC519O_COND_ACC_MIN_BAL": 0, "TRC519O_COND_ACC_DAYS_EXCESS": 0, "TRC519O_COND_ACC_DR_TURNOVER": 0, "TRC519O_COND_ACC_AVG_BAL": 0, "TRC519O_COND_ACC_CR_TURNOVER": 0, "TRC519O_COND_ACC_TOT_LIMIT": 0, "TRC519O_COND_ACC_NUM_DR_SAV": 0, "TRC519O_COND_ACC_NUM_CQ_RD_EV": 0, "TRC519O_COND_CLNT_RISK_GRADE": 0, "TRC519O_COND_ACC_HIGH_LIMIT": 0, "TRC519O_COND_ACC_DAYS_DR_CHQ": 0, "TRC519O_COND_ACC_NUM_DP_RD_EV": 0, "TRC519O_COND_ACC_MAX_BAL": 0, "TRC519O_COND_ACC_NUM_DR_CHQ": 0, "TRC519O_COND_NO_OPEN_CQ_ACC": 0, "TRC519O_COND_ACC_DAYS_CR_CHQ": 0    },    { "TRC519O_COND_ACC_VAL_DP_RETPY": 0, "TRC519O_COND_ACC_VAL_CQ_RETPY": 0, "TRC519O_COND_ACC_MIN_BAL": 0, "TRC519O_COND_ACC_DAYS_EXCESS": 0, "TRC519O_COND_ACC_DR_TURNOVER": 0, "TRC519O_COND_ACC_AVG_BAL": 0, "TRC519O_COND_ACC_CR_TURNOVER": 0, "TRC519O_COND_ACC_TOT_LIMIT": 0, "TRC519O_COND_ACC_NUM_DR_SAV": 0, "TRC519O_COND_ACC_NUM_CQ_RD_EV": 0, "TRC519O_COND_CLNT_RISK_GRADE": 0, "TRC519O_COND_ACC_HIGH_LIMIT": 0, "TRC519O_COND_ACC_DAYS_DR_CHQ": 0, "TRC519O_COND_ACC_NUM_DP_RD_EV": 0, "TRC519O_COND_ACC_MAX_BAL": 0, "TRC519O_COND_ACC_NUM_DR_CHQ": 0, "TRC519O_COND_NO_OPEN_CQ_ACC": 0, "TRC519O_COND_ACC_DAYS_CR_CHQ": 0    } ], "TRC519O_BEH_SCORE_MLOAN": 0   }      },      "NBSAPDPO": {  "NBSAPLO": { "NBNAPLO_REASON_CODE": 0, "NBNAPLO_RETURN_CODE": 0, "NBNAPLO_SERVICE_VERSION": "BUSO002"   }     }  }';
 		GetTriads_Resp_IB_v1 responseBean = new GetTriads_Resp_IB_v1();
        responseBean = (GetTriads_Resp_IB_v1)responseBean.deserialize(POSITIVE_RESPONSE_BODY, GetTriads_Resp_IB_v1.class);

        //insertion of triad records
        Application_Triad__c appTriad = new Application_Triad__c();
        appTriad.Client_Code__c = 'CLOSE  001';
        appTriad.Client_Name__c = 'absa 002';
        appTriad.Application__c = app.id;
        appTriad.Is_Main_Applicant__c = true;
        //Based on Stroy mapping fields and SDD ,mapped the triad fields from response bean
        //stroy mapping and SDD  attached to US-6252

        String ExclusionType = responseBean.TRC519O.TRC519O_OUTPUT_DATA.TRC519O_TRIAD_EXCLUSION;
        String translatedValueExType = Sys_Utilities_Integration.getIntegrationTranslationInternalValue('Triad', 'Triad Exclusion Type', ExclusionType, 'Outbound');

        appTriad.Triad_Exclusion_Type__c = translatedValueExType;
        appTriad.Triad_Exclusion_Reason__c = responseBean.TRC519O.TRC519O_OUTPUT_DATA.TRC519O_TRIAD_EXCL_REASON;

        String exclusionValueFromSystem = responseBean.TRC519O.TRC519O_OUTPUT_DATA.TRC519O_TRIAD_EXCL_REASON;
        String translatedValueEx = Sys_Utilities_Integration.getIntegrationTranslationInternalValue('Triad', 'Triad Exclusion Reason', exclusionValueFromSystem, 'Outbound');

        appTriad.Triad_Exclusion_Reason_Description__c = translatedValueEx;
        String cfacEx = responseBean.TRC519O.TRC519O_OUTPUT_DATA.TRC519O_CFAC_EXCLUSION;
        String creditfactranslatedValue = Sys_Utilities_Integration.getIntegrationTranslationInternalValue('Triad', 'Credit Facility Exclusion', cfacEx, 'Outbound');

        appTriad.Credit_Facility_Exclusion__c = creditfactranslatedValue;

        appTriad.Credit_Facility_Exclusion_Code__c = String.valueOf(responseBean.TRC519O.TRC519O_OUTPUT_DATA.TRC519O_CFAC_EXCLUSION_REASON);

        String creditFacExclusionCode = String.valueOf(responseBean.TRC519O.TRC519O_OUTPUT_DATA.TRC519O_CFAC_EXCLUSION_REASON);
       	String creditfactranslatedDesc = Sys_Utilities_Integration.getIntegrationTranslationInternalValue('Triad', 'Credit Facility Exclusion Reason', creditFacExclusionCode, 'Outbound');

        appTriad.Credit_Facility_Exclusion_Description__c =  creditfactranslatedDesc;
        //translation ends

        appTriad.Days_in_Credit_last_6_mth__c = responseBean.TRC519O.TRC519O_OUTPUT_DATA.TRC519O_DAYS_IN_CREDIT_CHQ_L6M;
        appTriad.Days_in_Debit_last_6_mth__c = responseBean.TRC519O.TRC519O_OUTPUT_DATA.TRC519O_DAYS_IN_DEBIT_CHQ_L6M;
        appTriad.Maximum_Consecutive_Days_in_Excess__c = responseBean.TRC519O.TRC519O_OUTPUT_DATA.TRC519O_MAX_CONSEQ_DAYS_EXS;
        appTriad.Months_in_Excess_last_6_mth__c = responseBean.TRC519O.TRC519O_OUTPUT_DATA.TRC519O_NUM_MTS_EXS_L6M;
        appTriad.Total_Cheque_RD_last_3_mth__c = responseBean.TRC519O.TRC519O_OUTPUT_DATA.TRC519O_NUM_CHQ_RD_L3M;
        appTriad.Total_Cheque_RD_last_6_mth__c = responseBean.TRC519O.TRC519O_OUTPUT_DATA.TRC519O_NUM_CHQ_RD_L6M;
        appTriad.Total_Savings_RD_last_3_mth__c = responseBean.TRC519O.TRC519O_OUTPUT_DATA.TRC519O_NUM_SAV_RD_L3M;
        appTriad.Total_Savings_RD_last_6_mth__c = responseBean.TRC519O.TRC519O_OUTPUT_DATA.TRC519O_NUM_SAV_RD_L6M;

        insert appTriad ;

        if(isMainApplicant){
            List<Application_Triad_Detail__c> monthlyValuesList = new List<Application_Triad_Detail__c>();
            Application_Triad_Detail__c monthlyValues ;
            Date todaysDate = Date.today();
            Integer currentDay = todaysDate.day();
            Integer currentMonth = todaysDate.month();
            Integer currentYear = todaysDate.year();
            Date FifthDate = Date.newInstance(currentYear, currentMonth, 5);
            Integer monthAdd = 0 ;

            if(todaysDate > FifthDate){
                monthAdd = 1;
            }else{
                monthAdd = 2;
            }

            for(GetTriads_Resp_IB_v1.TRC519O_COND_ACCOUNT_DETAILS monthlydata: responseBean.TRC519O.TRC519O_OUTPUT_DATA.TRC519O_COND_ACCOUNT_DETAILS) {
                monthlyValues = new Application_Triad_Detail__c();
                Date DateBackMonth = todaysDate.addMonths(-monthAdd);

                monthAdd++ ;
                monthlyValues.Month__c = DateBackMonth;
                monthlyValues.Application_Triad__c = appTriad.Id;
                monthlyValues.Risk_Grade__c = monthlydata.TRC519O_COND_CLNT_RISK_GRADE;
                monthlyValues.Minimum_Balance__c = monthlydata.TRC519O_COND_ACC_MIN_BAL;
                monthlyValues.Maximum_Balance__c = monthlydata.TRC519O_COND_ACC_MAX_BAL;
                monthlyValues.Highest_Limit__c = monthlydata.TRC519O_COND_ACC_HIGH_LIMIT;
                monthlyValues.Debit_Turnover__c = monthlydata.TRC519O_COND_ACC_DR_TURNOVER;
                monthlyValues.Credit_Turnover__c = monthlydata.TRC519O_COND_ACC_CR_TURNOVER;
                monthlyValues.Total_Limit__c = monthlydata.TRC519O_COND_ACC_TOT_LIMIT;
                monthlyValues.Average_Balance__c = monthlydata.TRC519O_COND_ACC_AVG_BAL;
                monthlyValues.Days_in_Credit__c = monthlydata.TRC519O_COND_NO_OPEN_CQ_ACC;
                monthlyValues.Days_In_Excess__c = monthlydata.TRC519O_COND_ACC_DAYS_EXCESS;
                monthlyValues.Days_in_Debit__c = monthlydata.TRC519O_COND_ACC_DAYS_DR_CHQ;
                monthlyValues.Number_of_Cheque_Accounts__c =  monthlydata.TRC519O_COND_NO_OPEN_CQ_ACC;
                monthlyValuesList.add(monthlyValues);
            }
            insert monthlyValuesList;
        }

        Test.startTest();
        //TriadMonthlyActivityController.getApplicationTriadMonthlyActivities(opp.Id);
        System.assert(TriadMonthlyActivityController.getApplicationTriadMonthlyActivities(opp.Id) != null, true);
        Test.stopTest();
    }

    /**
    * @description test method to GetMonthlyCalculationApi
    * @author englarmerdge.mongwe@absa.africa | 2020/09/20
    **/
    @IsTest
    public static void testGetMonthlyCalculationApi(){
        monthlyCalculations_IH_v1_Test.monthlyCalTestMock();

        Test.startTest();
        System.assertEquals(200, monthlyCallHandlerMethod().statusCode);
        Test.stopTest();
    }

    private static monthlyCalculations_Resp_IB_v1 monthlyCallHandlerMethod() {
        monthlyCalculations_Req_IB_v1 dummyBean = monthlyCalculations_Req_IB_v1.createDummyRequest();
        monthlyCalculations_Resp_IB_v1 resp = TriadMonthlyActivityController.getMonthlyCalculationService(dummyBean);
        return resp;
    }
}