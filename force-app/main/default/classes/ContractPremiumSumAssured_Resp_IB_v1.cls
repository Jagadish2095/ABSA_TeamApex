/**
* @description Response Integration Bean for ContractPremiumSumAssured Service
* @author Chandra Bhushan Singh
* @created 2021-04-08
* @updated Koketso Mpshane 2021-06-23
*/

public class ContractPremiumSumAssured_Resp_IB_v1 extends Base_IB {

    @AuraEnabled public String status;
    @AuraEnabled public Integer statusCode;
    @AuraEnabled public String message;
	/**
	* @description V3_DC2_LoggedMsg
	*/
    public class V3_DC2_LoggedMsg {
		@AuraEnabled public Integer CreatedBy;
		@AuraEnabled public String CreatedDate;
		@AuraEnabled public String GID;
		@AuraEnabled public String Level;
		@AuraEnabled public Integer LevelID;
		@AuraEnabled public String Message;
		@AuraEnabled public Integer MessageID;
		@AuraEnabled public Integer OverRideLevelID;
		@AuraEnabled public Object OverRideReason;
		@AuraEnabled public Object OverrideLevel;
	}

	public Contract_Premium_SumAssuredResponse Contract_Premium_SumAssuredResponse;
	/**
	* @description Contract_Premium_SumAssuredResponse
	*/
	public class Contract_Premium_SumAssuredResponse {
		@AuraEnabled public String Contract_Premium_SumAssuredResult;
		@AuraEnabled public PcolValidationMessages pcolValidationMessages;
	}
	/**
	* @description 	PcolValidationMessages
	*/
	public class PcolValidationMessages {
		@AuraEnabled public List<V3_DC2_LoggedMsg> V3_DC2_LoggedMsg;
	}

}