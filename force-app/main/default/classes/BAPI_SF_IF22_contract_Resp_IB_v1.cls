/**
* @description Request Bean class for the BAPI_SF_IF22_contractInformation
* @author  Kabelo Aphane
* @create   25 June 2021
*/
public class BAPI_SF_IF22_contract_Resp_IB_v1 extends Base_IB{

	@AuraEnabled public String status;
    @AuraEnabled public Integer statusCode;
    @AuraEnabled public String message;
    
	@AuraEnabled public BAPI_SF_IF22 BAPI_SF_IF22;
/**
* @description BAPI_SF_IF22
*/
	public class BAPI_SF_IF22 {
		@AuraEnabled public E_ACC_DETAILS E_ACC_DETAILS;
		@AuraEnabled public Integer E_RESPONSE;
		@AuraEnabled public String E_RESPONSE_DESC;
	}
/**
* @description E_ACC_DETAILS
*/
	public class E_ACC_DETAILS {
		@AuraEnabled public String ACCT_NUM;
		@AuraEnabled public String ISTPAYDT;
		@AuraEnabled public Double INSTAL_AMT;
		@AuraEnabled public String REMAINING_TERM;
		@AuraEnabled public String ORIGINAL_TERM;
		@AuraEnabled public Double DEPOSIT_ATM;
		@AuraEnabled public String LAST_PAYMT_DATE;
		@AuraEnabled public Double LAST_PAYMT_AMT;
		@AuraEnabled public String CT_LIFE_INS_TYPE;
		@AuraEnabled public String RISK_TYPE;
		@AuraEnabled public Double SCHED_PAY_AMT;
		@AuraEnabled public String DO_ACC_TYPE;
		@AuraEnabled public String GL_DIVISION_CODE;
		@AuraEnabled public Double CURR_RATE;
		@AuraEnabled public String NID;
		@AuraEnabled public String ARTICLE_DESC;
		@AuraEnabled public String CHASSIS_NUM;
		@AuraEnabled public String ENGINE_NUM;
		@AuraEnabled public String DATE_SOLD;
		@AuraEnabled public String DATE_BOOKED;
		@AuraEnabled public String SOLD_AMNT;
		@AuraEnabled public Double VALUATION_AMT;
		@AuraEnabled public String OFFER_ACCPT_DATE;
		@AuraEnabled public String NEXT_BILL_DATE;
		@AuraEnabled public Double RESIDUAL_VALUE;
		@AuraEnabled public String CURR_DELINQ;
		@AuraEnabled public String DATE_WOF;
		@AuraEnabled public String KUNNR;
		@AuraEnabled public String PAY_METHOD;
		@AuraEnabled public Double PREV_RATE;
		@AuraEnabled public String RATE_TYPE;
		@AuraEnabled public Double PRINDEBT;
		@AuraEnabled public Double ORIG_RATE;
		@AuraEnabled public Double ADV_CAP_AMT;
		@AuraEnabled public String ADV_CAP_DATE;
		@AuraEnabled public String AIP_DESCR;
		@AuraEnabled public String CVR_DESCR;
		@AuraEnabled public String CLI_DESCR;
		@AuraEnabled public String WAR_DESCR;
		@AuraEnabled public String ZMSF;
		@AuraEnabled public String EXPIRY_DATE;
	}
}