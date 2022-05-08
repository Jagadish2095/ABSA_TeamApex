/**
 * @description Controller class for Triad Service
 * @author Almas Aleem
 * @created 2020-09-18
 *
 * @updated Englarmerdge Mongwe
 * @date 2021-01-07
 * Added missing fields for monthly activity data
 */
public class GetTriadsController {
/**
 * @description getTriadsFromService description
 *
 * @param clientCode (String): clientCode
 * @param ApplicationId (Id): ApplicationId
 * @param isMainApplicant (Boolean): isMainApplicant
 * @param clientName (String): clientName
 */
	public static void getTriadsFromService(String clientCode, Id ApplicationId, Boolean isMainApplicant, String clientName) {
		//clientCode =    'SBSOUTP001';
		GetTriads_Resp_IB_v1 responseBean = GetTriads_IH_v1.GetTriads(clientCode); // call to service
        Integer expectedCreditTurnover = 0;

		//insertion of triad records
		Application_Triad__c appTriad = new Application_Triad__c();
		appTriad.Client_Code__c = clientCode;
		appTriad.Client_Name__c = clientName;
		appTriad.Application__c = applicationId;
        appTriad.Is_Main_Applicant__c = isMainApplicant;

		//Based on Stroy mapping fields and SDD ,mapped the triad fields from response bean
		//stroy mapping and SDD  attached to US-6252
		String exclusionType = responseBean.TRC519O.TRC519O_OUTPUT_DATA.TRC519O_TRIAD_EXCLUSION;
		String translatedValueExType = Sys_Utilities_Integration.getIntegrationTranslationInternalValue('Triad', 'Triad Exclusion Type', exclusionType, 'Outbound');
		appTriad.Triad_Exclusion_Type__c = translatedValueExType;
        if (responseBean.TRC519O.TRC519O_OUTPUT_DATA.TRC519O_TRIAD_EXCL_REASON != null) {
        	appTriad.Triad_Exclusion_Reason__c = responseBean.TRC519O.TRC519O_OUTPUT_DATA.TRC519O_TRIAD_EXCL_REASON.replaceFirst('^0+', '');
        }

        if (responseBean.TRC519O.TRC519O_OUTPUT_DATA.TRC519O_TRIAD_EXCL_REASON != null) {
            String exclusionValueFromSystem = responseBean.TRC519O.TRC519O_OUTPUT_DATA.TRC519O_TRIAD_EXCL_REASON.replaceFirst('^0+', '');
			String translatedValueExReason = Sys_Utilities_Integration.getIntegrationTranslationInternalValue('Triad', 'Triad Exclusion Reason', exclusionValueFromSystem, 'Outbound');
        	appTriad.Triad_Exclusion_Reason_Description__c = translatedValueExReason;
        }

		String cfacEx = responseBean.TRC519O.TRC519O_OUTPUT_DATA.TRC519O_CFAC_EXCLUSION;
		String creditfactranslatedValue = Sys_Utilities_Integration.getIntegrationTranslationInternalValue('Triad', 'Credit Facility Exclusion', cfacEx, 'Outbound');
		appTriad.Credit_Facility_Exclusion__c = creditfactranslatedValue;
        appTriad.Credit_Facility_Exclusion_Code__c = String.valueOf(responseBean.TRC519O.TRC519O_OUTPUT_DATA.TRC519O_CFAC_EXCLUSION_REASON);

		String creditFacExclusionCode = String.valueOf(responseBean.TRC519O.TRC519O_OUTPUT_DATA.TRC519O_CFAC_EXCLUSION_REASON);
		String creditfactranslatedDesc = Sys_Utilities_Integration.getIntegrationTranslationInternalValue('Triad', 'Credit Facility Exclusion Reason', creditFacExclusionCode, 'Outbound');
        appTriad.Credit_Facility_Exclusion_Description__c = creditfactranslatedDesc;

		//translation ends
		appTriad.Days_in_Credit_last_6_mth__c = responseBean.TRC519O.TRC519O_OUTPUT_DATA.TRC519O_DAYS_IN_CREDIT_CHQ_L6M;
		appTriad.Days_in_Debit_last_6_mth__c = responseBean.TRC519O.TRC519O_OUTPUT_DATA.TRC519O_DAYS_IN_DEBIT_CHQ_L6M;
		appTriad.Maximum_Consecutive_Days_in_Excess__c = responseBean.TRC519O.TRC519O_OUTPUT_DATA.TRC519O_MAX_CONSEQ_DAYS_EXS;
		appTriad.Months_in_Excess_last_6_mth__c = responseBean.TRC519O.TRC519O_OUTPUT_DATA.TRC519O_NUM_MTS_EXS_L6M;
		appTriad.Total_Cheque_RD_last_3_mth__c = responseBean.TRC519O.TRC519O_OUTPUT_DATA.TRC519O_NUM_CHQ_RD_L3M;
		appTriad.Total_Cheque_RD_last_6_mth__c = responseBean.TRC519O.TRC519O_OUTPUT_DATA.TRC519O_NUM_CHQ_RD_L6M;
		appTriad.Total_Savings_RD_last_3_mth__c = responseBean.TRC519O.TRC519O_OUTPUT_DATA.TRC519O_NUM_SAV_RD_L3M;
		appTriad.Total_Savings_RD_last_6_mth__c = responseBean.TRC519O.TRC519O_OUTPUT_DATA.TRC519O_NUM_SAV_RD_L6M;
		appTriad.Additional_Overdraft_Limit__c = responseBean.TRC519O.TRC519O_OUTPUT_DATA.TRC519O_LIMIT_CAPPED_AOL; //TRC519O_LIMIT_AOL; - Tinashe defect W-011436
		appTriad.Additional_Monthly_Loan_Repayment__c = responseBean.TRC519O.TRC519O_OUTPUT_DATA.TRC519O_LIMIT_AMLR;
		appTriad.Additional_Monthly_Repayment__c = responseBean.TRC519O.TRC519O_OUTPUT_DATA.TRC519O_LIMIT_AMR;
		appTriad.Additional_Credit_Card_Limit__c = responseBean.TRC519O.TRC519O_OUTPUT_DATA.TRC519O_LIMIT_ACCL;
		appTriad.Additional_Asset_Finance_Repayment__c = responseBean.TRC519O.TRC519O_OUTPUT_DATA.TRC519O_LIMIT_ABRA;
		appTriad.Additional_Monthly_Mortgage_Repayment__c = responseBean.TRC519O.TRC519O_OUTPUT_DATA.TRC519O_LIMIT_AMMR;
		appTriad.Maximum_Ordinary_Credit_Exposure_Capped__c = responseBean.TRC519O.TRC519O_OUTPUT_DATA.TRC519O_MAX_ORD_CRED_EXPOSURE;
        appTriad.Expected_Credit_Turnover__c = responseBean.TRC519O.TRC519O_OUTPUT_DATA.TRC519O_EXP_CREDIT_TURNOVER_CU;

		//Triad - Relationship
		appTriad.Months_Since_Oldest_Relationship__c = responseBean.TRC519O.TRC519O_OUTPUT_DATA.TRC519O_AGE_CUST_RELATIONSHIP;
		appTriad.Months_Since_Oldest_Account__c = responseBean.TRC519O.TRC519O_OUTPUT_DATA.TRC519O_AGE_ACC_RELATIONSHIP;
		appTriad.Months_Since_Oldest_Cheque_Account__c = responseBean.TRC519O.TRC519O_OUTPUT_DATA.TRC519O_AGE_CHQ_RELATIONSHIP;
		appTriad.Months_Since_Oldest_Savings_Account__c = responseBean.TRC519O.TRC519O_OUTPUT_DATA.TRC519O_AGE_SAV_RELATIONSHIP;
		appTriad.Date_First_Relationship__c = formatDate(responseBean.TRC519O.TRC519O_OUTPUT_DATA.TRC519O_DATE_CUST_REL);
		appTriad.Date_Oldest_Account_Opened__c = formatDate(responseBean.TRC519O.TRC519O_OUTPUT_DATA.TRC519O_DATE_OPEN_OLDEST_ACC);
		appTriad.Date_Oldest_Cheque_Account_Opened__c = formatDate(responseBean.TRC519O.TRC519O_OUTPUT_DATA.TRC519O_DATE_OPEN_OLDEST_CHQ);
        appTriad.Date_Oldest_Savings_Account_Opened__c = formatDate(responseBean.TRC519O.TRC519O_OUTPUT_DATA.TRC519O_DATE_OPEN_OLDEST_SAV);

		//Triad - Aggregated Values
		appTriad.ECTO_Monthly_Avg_Last_12_Mth__c = responseBean.TRC519O.TRC519O_OUTPUT_DATA.TRC519O_EXP_CREDIT_TURNOVER_CU;
		appTriad.Total_Credit_Last_6_Mth__c = responseBean.TRC519O.TRC519O_OUTPUT_DATA.TRC519O_TOT_VAL_CREDITS_L6M;
		appTriad.Total_Debit_Last_6_Mth__c = responseBean.TRC519O.TRC519O_OUTPUT_DATA.TRC519O_TOT_VAL_DEBITS_L6M;
		appTriad.ECTO_Cheque_Monthly_Avg_Last_12_Mth__c = responseBean.TRC519O.TRC519O_OUTPUT_DATA.TRC519O_EXP_CREDIT_TURNOVER_CQ;
		appTriad.Average_Credit_TurnOver_Last_3_6_Mth__c = responseBean.TRC519O.TRC519O_OUTPUT_DATA.TRC519O_AVG_CTO_L3M_L6M;
		appTriad.Average_Credit_TurnOver_Last_6_12_Mth__c = responseBean.TRC519O.TRC519O_OUTPUT_DATA.TRC519O_AVG_CTO_L6M_L12M;
		appTriad.Value_Cheque_RD_Last_6_Mth__c = responseBean.TRC519O.TRC519O_OUTPUT_DATA.TRC519O_VAL_CHQ_RET_PYMNT_L6M;
        appTriad.Value_Savings_RD_Last_6_Mth__c = responseBean.TRC519O.TRC519O_OUTPUT_DATA.TRC519O_VAL_SAV_RET_PYMNT_L6M;

		for (GetTriads_Resp_IB_v1.TRC519O_COND_ACCOUNT_DETAILS monthlydata : responseBean.TRC519O.TRC519O_OUTPUT_DATA.TRC519O_COND_ACCOUNT_DETAILS) {
			expectedCreditTurnover += monthlydata.TRC519O_COND_ACC_CR_TURNOVER;
        }

        appTriad.ECTO_Total_For_Period__c = expectedCreditTurnover;

		//Triad - Behaviour
		appTriad.Customer_Alignment_Score__c = responseBean.TRC519O.TRC519O_OUTPUT_DATA.TRC519O_CUST_ALIGN_SCORE;
		appTriad.Cheque_Score__c = responseBean.TRC519O.TRC519O_OUTPUT_DATA.TRC519O_BEH_SCORE_CHQ;
		appTriad.Credit_Card_Score__c = responseBean.TRC519O.TRC519O_OUTPUT_DATA.TRC519O_BEH_SCORE_CARD;
		appTriad.Mortgage_Score__c = responseBean.TRC519O.TRC519O_OUTPUT_DATA.TRC519O_BEH_SCORE_MLOAN;
		appTriad.AVAF_Score__c = responseBean.TRC519O.TRC519O_OUTPUT_DATA.TRC519O_BEH_SCORE_AVAF;
        appTriad.Loan_Score__c = responseBean.TRC519O.TRC519O_OUTPUT_DATA.TRC519O_BEH_SCORE_LOANS;

		try {
			insert appTriad;
		}
		catch (DmlException e) {
			System.debug('The following exception has occurred: ' + e.getMessage());
        }

        List<Application_Triad_Detail__c> monthlyValuesList = new List<Application_Triad_Detail__c>();

		if (isMainApplicant) {
			Application_Triad_Detail__c monthlyValues;
			Date todaysDate = Date.today();
			Integer currentDay = todaysDate.day();
			Integer currentMonth = todaysDate.month();
			Integer currentYear = todaysDate.year();
			Date fifthDate = Date.newInstance(currentYear, currentMonth, 5);
            Integer monthAdd = 0;

			if (todaysDate > fifthDate) {
				monthAdd = 1;
			}
			else {
				monthAdd = 2;
            }

			for (GetTriads_Resp_IB_v1.TRC519O_COND_ACCOUNT_DETAILS monthlydata : responseBean.TRC519O.TRC519O_OUTPUT_DATA.TRC519O_COND_ACCOUNT_DETAILS) {
				monthlyValues = new Application_Triad_Detail__c();
				Date dateBackMonth = todaysDate.addMonths(-monthAdd);
				monthAdd++;
				monthlyValues.Month__c = dateBackMonth;
				monthlyValues.Application_Triad__c = appTriad.Id;
				monthlyValues.Risk_Grade__c = monthlydata.TRC519O_COND_CLNT_RISK_GRADE;
				monthlyValues.Minimum_Balance__c = monthlydata.TRC519O_COND_ACC_MIN_BAL;
				monthlyValues.Maximum_Balance__c = monthlydata.TRC519O_COND_ACC_MAX_BAL;
				monthlyValues.Highest_Limit__c = monthlydata.TRC519O_COND_ACC_HIGH_LIMIT;
				monthlyValues.Debit_Turnover__c = monthlydata.TRC519O_COND_ACC_DR_TURNOVER;
				monthlyValues.Credit_Turnover__c = monthlydata.TRC519O_COND_ACC_CR_TURNOVER;
				monthlyValues.Total_Limit__c = monthlydata.TRC519O_COND_ACC_TOT_LIMIT;
				monthlyValues.Average_Balance__c = monthlydata.TRC519O_COND_ACC_AVG_BAL;
				monthlyValues.Days_in_Credit__c = monthlydata.TRC519O_COND_ACC_DAYS_CR_CHQ; //TRC519O_COND_ACC_DAYS_CR_CHQ
				monthlyValues.Days_In_Excess__c = monthlydata.TRC519O_COND_ACC_DAYS_EXCESS;
                monthlyValues.Days_in_Debit__c = monthlydata.TRC519O_COND_ACC_DAYS_DR_CHQ;
                monthlyValues.Number_of_Cheque_Accounts__c = monthlydata.TRC519O_COND_NO_OPEN_CQ_ACC;
                monthlyValues.Number_of_Debits_Cheques__c = monthlydata.TRC519O_COND_ACC_NUM_DR_CHQ;
                monthlyValues.Number_of_Debits_Deposits__c = monthlydata.TRC519O_COND_ACC_NUM_DR_SAV;
				monthlyValues.Number_of_Cheque_RD_Events__c = monthlydata.TRC519O_COND_ACC_NUM_CQ_RD_EV;
				monthlyValues.Number_of_Savings_RD_Events__c = monthlydata.TRC519O_COND_ACC_NUM_DP_RD_EV;
				monthlyValues.Returned_Items_Value_Cheques_value__c = monthlydata.TRC519O_COND_ACC_VAL_CQ_RETPY;
				monthlyValues.Returned_Items_Value_Savings_value__c = monthlydata.TRC519O_COND_ACC_VAL_DP_RETPY;
				monthlyValuesList.add(monthlyValues);
            }

			try {
				insert monthlyValuesList;
			}
			catch (DmlException e) {
				System.debug('The following exception has occurred: ' + e.getMessage());
			}
		}
	}

	private static Date formatDate(String dateString) {
		String[] dateStringArray = dateString.split('');
        Date formattedDate = null;

		if (dateString.length() == 8) {
			String year = '';
			String month = '';
			String day = '';
			for (Integer i = 0; i < dateString.length(); i++) {
				if (i < 4) {
					year += dateStringArray[i];
				}
				else if (i > 3 && i < 6) {
					month += dateStringArray[i];
				}
				else if (i > 5) {
					day += dateStringArray[i];
				}
			}
			formattedDate = Date.parse(year + '/' + month + '/' + day);
		}
		return formattedDate;
	}
}