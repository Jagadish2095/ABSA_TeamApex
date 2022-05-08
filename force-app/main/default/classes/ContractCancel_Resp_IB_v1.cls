/**
 * @description Integration Response Bean for ContractCancel Service
 * @author Koketso Mpshane
 * @created 2021-06-30
 */
public class ContractCancel_Resp_IB_v1 extends Base_IB {
    
    @AuraEnabled public String status;
    @AuraEnabled public Integer statusCode;
    @AuraEnabled public String message;
    
    public Contract_CancelResponse Contract_CancelResponse;
	/**
	 * @description wrapper class DC2LoggedMsg
	 */
	public class DC2LoggedMsg {
		@AuraEnabled public Integer CreatedBy;
		@AuraEnabled public Object CreatedDate;
		@AuraEnabled public Object GID;
		@AuraEnabled public Object Level;
		@AuraEnabled public Integer LevelID;
		@AuraEnabled public Object Message;
		@AuraEnabled public Integer MessageID;
		@AuraEnabled public Integer OverRideLevelID;
		@AuraEnabled public Object OverRideReason;
		@AuraEnabled public Object OverrideLevel;
	}
	/**
	 * @description wrapper class PlstLoggedMessages
	 */
	public class PlstLoggedMessages {
		@AuraEnabled public List<DC2LoggedMsg> DC2LoggedMsg;
	}
	/**
	 * @description wrapper class Contract_CancelResponse
	 */
	public class Contract_CancelResponse {
		@AuraEnabled public String Contract_CancelResult;
		@AuraEnabled public PlstLoggedMessages plstLoggedMessages;
	}

}