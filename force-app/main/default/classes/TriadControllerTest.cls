/**
 * @description       : Test class Controller used by lightning components for Conditions of grant
 * @author            : Almas Aleem : Absa
 * @last modified on  : 2021-07-14
 * @last modified by  : Gulafsha
 * Modifications Log 
 * Ver   Date         Author   Modification
 * 1.0   2020-09-15      Initial Version
**/

@isTest
public class TriadControllerTest {
    /**
     * @description method to setup test data
     * @author Almas.Aleem@absa.africa | 2020-09-15
    **/
    @testSetup static void createData(){
        Account testAccount = new Account();
        testAccount.Registration_Number__c = null;
        testAccount.Company_Registration_Number__c = null;
		testAccount.CASA_Reference_Number__c = '1712994';
		testAccount.CASA_Risk_Status__c = 'Low';
		testAccount.CASA_Screening_Date__c = Date.valueOf('2018-06-30');
		testAccount.CASA_Screening_Status__c = 'Approved';
		testAccount.CASA_Analyst_Comments__c = '30406';
		testAccount.Name = 'EXPERIAN';
		testAccount.Client_Type__c = 'Company';
		testAccount.Phone = '0114453322';
		testAccount.CIF__c = 'AFIFTAP001';
		testAccount.Date_Established__c = System.today();
        insert testAccount;

        //Opportunity
        Opportunity testOpportunity = new Opportunity();
		testOpportunity.Name = 'Cheque Credit Onboarding';
		testOpportunity.AccountId = testAccount.Id;
		testOpportunity.Spouse_Account_Id__c = String.valueOf(testAccount.Id);
		testOpportunity.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Credit Onboarding').getRecordTypeId();
		testOpportunity.StageName = 'New';
		testOpportunity.CloseDate = Date.today()+10;
		testOpportunity.Illustrative_Decision__c = true;
		insert testOpportunity;

		//Application__c
		Application__c app = new Application__c();
		app.Opportunity__c = testOpportunity.Id;
		app.Preferred_Communication_Method__c = 'test@absa.africa';
		app.Preferred_SMS__c = '1111111';
		app.Preferred_Communication_Method__c = 'Email';
		app.Fees_Waived__c = true;
		app.Products_And_Services__c = 'NotifyMe';
		insert app;

        //create triad data
        Boolean isMainApplicant= true;
        String POSITIVE_RESPONSE_BODY = '{"TRC519O": {"TRC519O_OUTPUT_PROCESS_RESULTS": { "TRC519O_RETURN_CODE": 10   },   "TRC519O_OUTPUT_DATA": { "TRC519O_AGE_CUST_RELATIONSHIP": 0, "TRC519O_LIMIT_ACCL": 0, "TRC519O_TOT_VAL_CREDITS_L6M": 0, "TRC519O_TRIAD_EXCL_REASON": "", "TRC519O_DATaE_OPEN_OLDEST_SAV": 0, "TRC519O_AVG_CTO_L3M_L6M": 0.00, "TRC519O_BEH_SCORE_AVAF": 0, "TRC519O_NUM_MTS_EXS_L6M": 0, "TRC519O_DATE_OPEN_OLDEST_CHQ": 0, "TRC519O_LIMIT_ABRA": 0, "TRC519O_LIMIT_AMMR": 0, "TRC519O_DATE_CUST_REL": 0, "TRC519O_BEH_SCORE_LOANS": 0, "TRC519O_MAX_CONSEQ_DAYS_EXS": 0, "TRC519O_TRIAD_EXCLUSION": "", "TRC519O_NUM_CHQ_RD_L6M": 0, "TRC519O_BEH_SCORE_CHQ": 0, "TRC519O_VAL_SAV_RET_PYMNT_L6M": 0, "TRC519O_LIMIT_CAPPED_AOL": 0, "TRC519O_NUM_SAV_RD_L3M": 0, "TRC519O_NUM_SAV_RD_L6M": 0, "TRC519O_DAYS_IN_CREDIT_CHQ_L6M": 0, "TRC519O_AGE_CHQ_RELATIONSHIP": 0, "TRC519O_CFAC_EXCLUSION_REASON": 0, "TRC519O_LIMIT_AMLR": 0, "TRC519O_TOT_VAL_DEBITS_L6M": 0, "TRC519O_DAYS_IN_DEBIT_CHQ_L6M": 0, "TRC519O_BEH_SCORE_CARD": 0, "TRC519O_EXP_CREDIT_TURNOVER_CU": 0, "TRC519O_AGE_SAV_RELATIONSHIP": 0, "TRC519O_MAX_ORD_CRED_EXPOSURE": 0, "TRC519O_VAL_CHQ_RET_PYMNT_L6M": 0, "TRC519O_EXP_CREDIT_TURNOVER_CQ": 0, "TRC519O_LIMIT_AOL": 0, "TRC519O_AGE_ACC_RELATIONSHIP": 0, "TRC519O_CUST_ALIGN_SCORE": 0, "TRC519O_PROT_NCA": "", "TRC519O_CFAC_EXCLUSION": "", "TRC519O_AVG_CTO_L6M_L12M": 0.00, "TRC519O_DATE_OPEN_OLDEST_ACC": 0, "TRC519O_LIMIT_AMR": 0, "TRC519O_NUM_CHQ_RD_L3M": 0, "TRC519O_COND_ACCOUNT_DETAILS": [    { "TRC519O_COND_ACC_VAL_DP_RETPY": 0, "TRC519O_COND_ACC_VAL_CQ_RETPY": 0, "TRC519O_COND_ACC_MIN_BAL": 0, "TRC519O_COND_ACC_DAYS_EXCESS": 0, "TRC519O_COND_ACC_DR_TURNOVER": 0, "TRC519O_COND_ACC_AVG_BAL": 0, "TRC519O_COND_ACC_CR_TURNOVER": 0, "TRC519O_COND_ACC_TOT_LIMIT": 0, "TRC519O_COND_ACC_NUM_DR_SAV": 0, "TRC519O_COND_ACC_NUM_CQ_RD_EV": 0, "TRC519O_COND_CLNT_RISK_GRADE": 0, "TRC519O_COND_ACC_HIGH_LIMIT": 0, "TRC519O_COND_ACC_DAYS_DR_CHQ": 0, "TRC519O_COND_ACC_NUM_DP_RD_EV": 0, "TRC519O_COND_ACC_MAX_BAL": 0, "TRC519O_COND_ACC_NUM_DR_CHQ": 0, "TRC519O_COND_NO_OPEN_CQ_ACC": 0, "TRC519O_COND_ACC_DAYS_CR_CHQ": 0    },    { "TRC519O_COND_ACC_VAL_DP_RETPY": 0, "TRC519O_COND_ACC_VAL_CQ_RETPY": 0, "TRC519O_COND_ACC_MIN_BAL": 0, "TRC519O_COND_ACC_DAYS_EXCESS": 0, "TRC519O_COND_ACC_DR_TURNOVER": 0, "TRC519O_COND_ACC_AVG_BAL": 0, "TRC519O_COND_ACC_CR_TURNOVER": 0, "TRC519O_COND_ACC_TOT_LIMIT": 0, "TRC519O_COND_ACC_NUM_DR_SAV": 0, "TRC519O_COND_ACC_NUM_CQ_RD_EV": 0, "TRC519O_COND_CLNT_RISK_GRADE": 0, "TRC519O_COND_ACC_HIGH_LIMIT": 0, "TRC519O_COND_ACC_DAYS_DR_CHQ": 0, "TRC519O_COND_ACC_NUM_DP_RD_EV": 0, "TRC519O_COND_ACC_MAX_BAL": 0, "TRC519O_COND_ACC_NUM_DR_CHQ": 0, "TRC519O_COND_NO_OPEN_CQ_ACC": 0, "TRC519O_COND_ACC_DAYS_CR_CHQ": 0    },    { "TRC519O_COND_ACC_VAL_DP_RETPY": 0, "TRC519O_COND_ACC_VAL_CQ_RETPY": 0, "TRC519O_COND_ACC_MIN_BAL": 0, "TRC519O_COND_ACC_DAYS_EXCESS": 0, "TRC519O_COND_ACC_DR_TURNOVER": 0, "TRC519O_COND_ACC_AVG_BAL": 0, "TRC519O_COND_ACC_CR_TURNOVER": 0, "TRC519O_COND_ACC_TOT_LIMIT": 0, "TRC519O_COND_ACC_NUM_DR_SAV": 0, "TRC519O_COND_ACC_NUM_CQ_RD_EV": 0, "TRC519O_COND_CLNT_RISK_GRADE": 0, "TRC519O_COND_ACC_HIGH_LIMIT": 0, "TRC519O_COND_ACC_DAYS_DR_CHQ": 0, "TRC519O_COND_ACC_NUM_DP_RD_EV": 0, "TRC519O_COND_ACC_MAX_BAL": 0, "TRC519O_COND_ACC_NUM_DR_CHQ": 0, "TRC519O_COND_NO_OPEN_CQ_ACC": 0, "TRC519O_COND_ACC_DAYS_CR_CHQ": 0    },    { "TRC519O_COND_ACC_VAL_DP_RETPY": 0, "TRC519O_COND_ACC_VAL_CQ_RETPY": 0, "TRC519O_COND_ACC_MIN_BAL": 0, "TRC519O_COND_ACC_DAYS_EXCESS": 0, "TRC519O_COND_ACC_DR_TURNOVER": 0, "TRC519O_COND_ACC_AVG_BAL": 0, "TRC519O_COND_ACC_CR_TURNOVER": 0, "TRC519O_COND_ACC_TOT_LIMIT": 0, "TRC519O_COND_ACC_NUM_DR_SAV": 0, "TRC519O_COND_ACC_NUM_CQ_RD_EV": 0, "TRC519O_COND_CLNT_RISK_GRADE": 0, "TRC519O_COND_ACC_HIGH_LIMIT": 0, "TRC519O_COND_ACC_DAYS_DR_CHQ": 0, "TRC519O_COND_ACC_NUM_DP_RD_EV": 0, "TRC519O_COND_ACC_MAX_BAL": 0, "TRC519O_COND_ACC_NUM_DR_CHQ": 0, "TRC519O_COND_NO_OPEN_CQ_ACC": 0, "TRC519O_COND_ACC_DAYS_CR_CHQ": 0    },    { "TRC519O_COND_ACC_VAL_DP_RETPY": 0, "TRC519O_COND_ACC_VAL_CQ_RETPY": 0, "TRC519O_COND_ACC_MIN_BAL": 0, "TRC519O_COND_ACC_DAYS_EXCESS": 0, "TRC519O_COND_ACC_DR_TURNOVER": 0, "TRC519O_COND_ACC_AVG_BAL": 0, "TRC519O_COND_ACC_CR_TURNOVER": 0, "TRC519O_COND_ACC_TOT_LIMIT": 0, "TRC519O_COND_ACC_NUM_DR_SAV": 0, "TRC519O_COND_ACC_NUM_CQ_RD_EV": 0, "TRC519O_COND_CLNT_RISK_GRADE": 0, "TRC519O_COND_ACC_HIGH_LIMIT": 0, "TRC519O_COND_ACC_DAYS_DR_CHQ": 0, "TRC519O_COND_ACC_NUM_DP_RD_EV": 0, "TRC519O_COND_ACC_MAX_BAL": 0, "TRC519O_COND_ACC_NUM_DR_CHQ": 0, "TRC519O_COND_NO_OPEN_CQ_ACC": 0, "TRC519O_COND_ACC_DAYS_CR_CHQ": 0    },    { "TRC519O_COND_ACC_VAL_DP_RETPY": 0, "TRC519O_COND_ACC_VAL_CQ_RETPY": 0, "TRC519O_COND_ACC_MIN_BAL": 0, "TRC519O_COND_ACC_DAYS_EXCESS": 0, "TRC519O_COND_ACC_DR_TURNOVER": 0, "TRC519O_COND_ACC_AVG_BAL": 0, "TRC519O_COND_ACC_CR_TURNOVER": 0, "TRC519O_COND_ACC_TOT_LIMIT": 0, "TRC519O_COND_ACC_NUM_DR_SAV": 0, "TRC519O_COND_ACC_NUM_CQ_RD_EV": 0, "TRC519O_COND_CLNT_RISK_GRADE": 0, "TRC519O_COND_ACC_HIGH_LIMIT": 0, "TRC519O_COND_ACC_DAYS_DR_CHQ": 0, "TRC519O_COND_ACC_NUM_DP_RD_EV": 0, "TRC519O_COND_ACC_MAX_BAL": 0, "TRC519O_COND_ACC_NUM_DR_CHQ": 0, "TRC519O_COND_NO_OPEN_CQ_ACC": 0, "TRC519O_COND_ACC_DAYS_CR_CHQ": 0    },    { "TRC519O_COND_ACC_VAL_DP_RETPY": 0, "TRC519O_COND_ACC_VAL_CQ_RETPY": 0, "TRC519O_COND_ACC_MIN_BAL": 0, "TRC519O_COND_ACC_DAYS_EXCESS": 0, "TRC519O_COND_ACC_DR_TURNOVER": 0, "TRC519O_COND_ACC_AVG_BAL": 0, "TRC519O_COND_ACC_CR_TURNOVER": 0, "TRC519O_COND_ACC_TOT_LIMIT": 0, "TRC519O_COND_ACC_NUM_DR_SAV": 0, "TRC519O_COND_ACC_NUM_CQ_RD_EV": 0, "TRC519O_COND_CLNT_RISK_GRADE": 0, "TRC519O_COND_ACC_HIGH_LIMIT": 0, "TRC519O_COND_ACC_DAYS_DR_CHQ": 0, "TRC519O_COND_ACC_NUM_DP_RD_EV": 0, "TRC519O_COND_ACC_MAX_BAL": 0, "TRC519O_COND_ACC_NUM_DR_CHQ": 0, "TRC519O_COND_NO_OPEN_CQ_ACC": 0, "TRC519O_COND_ACC_DAYS_CR_CHQ": 0    },    { "TRC519O_COND_ACC_VAL_DP_RETPY": 0, "TRC519O_COND_ACC_VAL_CQ_RETPY": 0, "TRC519O_COND_ACC_MIN_BAL": 0, "TRC519O_COND_ACC_DAYS_EXCESS": 0, "TRC519O_COND_ACC_DR_TURNOVER": 0, "TRC519O_COND_ACC_AVG_BAL": 0, "TRC519O_COND_ACC_CR_TURNOVER": 0, "TRC519O_COND_ACC_TOT_LIMIT": 0, "TRC519O_COND_ACC_NUM_DR_SAV": 0, "TRC519O_COND_ACC_NUM_CQ_RD_EV": 0, "TRC519O_COND_CLNT_RISK_GRADE": 0, "TRC519O_COND_ACC_HIGH_LIMIT": 0, "TRC519O_COND_ACC_DAYS_DR_CHQ": 0, "TRC519O_COND_ACC_NUM_DP_RD_EV": 0, "TRC519O_COND_ACC_MAX_BAL": 0, "TRC519O_COND_ACC_NUM_DR_CHQ": 0, "TRC519O_COND_NO_OPEN_CQ_ACC": 0, "TRC519O_COND_ACC_DAYS_CR_CHQ": 0    },    { "TRC519O_COND_ACC_VAL_DP_RETPY": 0, "TRC519O_COND_ACC_VAL_CQ_RETPY": 0, "TRC519O_COND_ACC_MIN_BAL": 0, "TRC519O_COND_ACC_DAYS_EXCESS": 0, "TRC519O_COND_ACC_DR_TURNOVER": 0, "TRC519O_COND_ACC_AVG_BAL": 0, "TRC519O_COND_ACC_CR_TURNOVER": 0, "TRC519O_COND_ACC_TOT_LIMIT": 0, "TRC519O_COND_ACC_NUM_DR_SAV": 0, "TRC519O_COND_ACC_NUM_CQ_RD_EV": 0, "TRC519O_COND_CLNT_RISK_GRADE": 0, "TRC519O_COND_ACC_HIGH_LIMIT": 0, "TRC519O_COND_ACC_DAYS_DR_CHQ": 0, "TRC519O_COND_ACC_NUM_DP_RD_EV": 0, "TRC519O_COND_ACC_MAX_BAL": 0, "TRC519O_COND_ACC_NUM_DR_CHQ": 0, "TRC519O_COND_NO_OPEN_CQ_ACC": 0, "TRC519O_COND_ACC_DAYS_CR_CHQ": 0    },    { "TRC519O_COND_ACC_VAL_DP_RETPY": 0, "TRC519O_COND_ACC_VAL_CQ_RETPY": 0, "TRC519O_COND_ACC_MIN_BAL": 0, "TRC519O_COND_ACC_DAYS_EXCESS": 0, "TRC519O_COND_ACC_DR_TURNOVER": 0, "TRC519O_COND_ACC_AVG_BAL": 0, "TRC519O_COND_ACC_CR_TURNOVER": 0, "TRC519O_COND_ACC_TOT_LIMIT": 0, "TRC519O_COND_ACC_NUM_DR_SAV": 0, "TRC519O_COND_ACC_NUM_CQ_RD_EV": 0, "TRC519O_COND_CLNT_RISK_GRADE": 0, "TRC519O_COND_ACC_HIGH_LIMIT": 0, "TRC519O_COND_ACC_DAYS_DR_CHQ": 0, "TRC519O_COND_ACC_NUM_DP_RD_EV": 0, "TRC519O_COND_ACC_MAX_BAL": 0, "TRC519O_COND_ACC_NUM_DR_CHQ": 0, "TRC519O_COND_NO_OPEN_CQ_ACC": 0, "TRC519O_COND_ACC_DAYS_CR_CHQ": 0    },    { "TRC519O_COND_ACC_VAL_DP_RETPY": 0, "TRC519O_COND_ACC_VAL_CQ_RETPY": 0, "TRC519O_COND_ACC_MIN_BAL": 0, "TRC519O_COND_ACC_DAYS_EXCESS": 0, "TRC519O_COND_ACC_DR_TURNOVER": 0, "TRC519O_COND_ACC_AVG_BAL": 0, "TRC519O_COND_ACC_CR_TURNOVER": 0, "TRC519O_COND_ACC_TOT_LIMIT": 0, "TRC519O_COND_ACC_NUM_DR_SAV": 0, "TRC519O_COND_ACC_NUM_CQ_RD_EV": 0, "TRC519O_COND_CLNT_RISK_GRADE": 0, "TRC519O_COND_ACC_HIGH_LIMIT": 0, "TRC519O_COND_ACC_DAYS_DR_CHQ": 0, "TRC519O_COND_ACC_NUM_DP_RD_EV": 0, "TRC519O_COND_ACC_MAX_BAL": 0, "TRC519O_COND_ACC_NUM_DR_CHQ": 0, "TRC519O_COND_NO_OPEN_CQ_ACC": 0, "TRC519O_COND_ACC_DAYS_CR_CHQ": 0    },    { "TRC519O_COND_ACC_VAL_DP_RETPY": 0, "TRC519O_COND_ACC_VAL_CQ_RETPY": 0, "TRC519O_COND_ACC_MIN_BAL": 0, "TRC519O_COND_ACC_DAYS_EXCESS": 0, "TRC519O_COND_ACC_DR_TURNOVER": 0, "TRC519O_COND_ACC_AVG_BAL": 0, "TRC519O_COND_ACC_CR_TURNOVER": 0, "TRC519O_COND_ACC_TOT_LIMIT": 0, "TRC519O_COND_ACC_NUM_DR_SAV": 0, "TRC519O_COND_ACC_NUM_CQ_RD_EV": 0, "TRC519O_COND_CLNT_RISK_GRADE": 0, "TRC519O_COND_ACC_HIGH_LIMIT": 0, "TRC519O_COND_ACC_DAYS_DR_CHQ": 0, "TRC519O_COND_ACC_NUM_DP_RD_EV": 0, "TRC519O_COND_ACC_MAX_BAL": 0, "TRC519O_COND_ACC_NUM_DR_CHQ": 0, "TRC519O_COND_NO_OPEN_CQ_ACC": 0, "TRC519O_COND_ACC_DAYS_CR_CHQ": 0    } ], "TRC519O_BEH_SCORE_MLOAN": 0   }      },      "NBSAPDPO": {  "NBSAPLO": { "NBNAPLO_REASON_CODE": 0, "NBNAPLO_RETURN_CODE": 0, "NBNAPLO_SERVICE_VERSION": "BUSO002"   }     }  }';
 		GetTriads_Resp_IB_v1 responseBean = new GetTriads_Resp_IB_v1();
         responseBean = (GetTriads_Resp_IB_v1)responseBean.deserialize(POSITIVE_RESPONSE_BODY, GetTriads_Resp_IB_v1.class);

        //insertion of triad records
        Application_Triad__c appTriad = new Application_Triad__c();
        appTriad.Client_Code__c = 'absa 002';
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
                system.debug('dateBackmonth---'+DateBackMonth);
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
        IntegrationTestDataFactory.insertIntegrationSettings(GetTriads_IH_v1.INTEGRATION_SERVICE_NAME, new List<String>{GetTriads_IH_v1.INTEGRATION_SERVICE_NAME});
    }

    /**
     * @description test method for getApplicationTriad
     * @author Almas.Aleem@absa.africa | 2020-09-15
     **/
    @isTest static void testGetApplication1() {

        Opportunity opp = [SELECT Id FROM Opportunity WHERE Name =:'Cheque Credit Onboarding' LIMIT 1];
        Application__c app1 = [SELECT Id FROM Application__C WHERE Opportunity__c = :opp.id];
        Account testAccount = [SELECT Id,Name,CIF__c,Registration_Number__c FROM Account LIMIT 1];

        Opportunity opp1 = new Opportunity();
        opp1.AccountId = testAccount.Id;
        opp1.Name = 'EPP';
        opp1.StageName = 'Not Interested';
        opp1.CloseDate = Date.today() + 10;
        insert opp1;

        Application__c app3 = new Application__c();
        app3.Opportunity__c = opp1.Id;
        app3.Preferred_Communication_Method__c = 'test@absa.co.za';
		app3.Preferred_SMS__c = '11114566111';
		app3.Preferred_Communication_Method__c = 'Email';
		app3.Fees_Waived__c = true;
		app3.Products_And_Services__c = 'NotifyMe';
        insert app3;

        Application_Principal__c testAppPrinc = new Application_Principal__c();
		testAppPrinc.Application__c = app3.Id;
        testAppPrinc.Principal_Shareholder_Name__c = 'SOUTH AFRICAN COMPENSATORS (PTY) LTD';
		testAppPrinc.Casa_Reference__c = '12345';
		testAppPrinc.Casa_Result__c = 'Approved';
		testAppPrinc.CIF__c = 'AFIFTAP003';
		testAppPrinc.Controlling_Interest__c = 10;
		testAppPrinc.Id_Number__c = null;
		testAppPrinc.Main__c = true;
        insert testAppPrinc;

        List<Application_Profile__c> testAppProfList = new List<Application_Profile__c>();
		Application_Profile__c testAppProf = new Application_Profile__c();
        testAppProf.Application__c = app3.Id;
		testAppProf.Applicant_Type__c = 'Main Applicant';
		testAppProf.Client_Name__c = testAccount.Name;
		testAppProf.Client_CIF_Code__c = testAccount.CIF__c;
		testAppProf.Related_to_Client_ID_or_Reg_Number__c = testAccount.Registration_Number__c;
        testAppProfList.Add(testAppProf);

        testAppProf = new Application_Profile__c();
		testAppProf.Application__c = app3.Id;
		testAppProf.Applicant_Type__c = 'Principal';
		testAppProf.Client_Name__c = testAppPrinc.Principal_Shareholder_Name__c;
		testAppProf.Client_CIF_Code__c = testAppPrinc.CIF__c;
		testAppProf.Related_to_Client_ID_or_Reg_Number__c = testAppPrinc.Id_Number__c;
		testAppProfList.Add(testAppProf);
        insert testAppProfList;

        Test.startTest();
        //List<Application_Triad__c> appTriadList
        Application__c app = TriadController.getApplicationTriad(opp1.id);
        Application__c app2 = TriadController.getApplicationTriad(opp.id);
        TriadExclusionController.getTriadDataList(app1.id);
        TriadExclusionController.getTriadDataList(app3.id);
        System.assert(app != null,true);
        System.assert(app2 != null,true);

        List<Application_Triad_Detail__c> appTriadDetailList = TriadMonthlyValueController.getMonthlyValues(app1.id);
        Test.stopTest();
    }
}