/**
 * @description Integration Response Bean for ContractLapse Service
 * @author Koketso Mpshane
 * @created 2021-06-30
 */
public class ContractLapse_Resp_IB_v1 extends Base_IB {
    
    @AuraEnabled public String status;
    @AuraEnabled public Integer statusCode;
    @AuraEnabled public String message;
    
    public contractLapseResponse contractLapseResponse;
    
	/**
	 * @description wrapper class DC2LoggedMsg
	 */
	public class DC2LoggedMsg {
		@AuraEnabled public Integer CreatedBy;
		@AuraEnabled public String CreatedDate;
		@AuraEnabled public String GID;
		@AuraEnabled public String Level;
		@AuraEnabled public Integer LevelID;
		@AuraEnabled public String Message;
		@AuraEnabled public Integer MessageID;
		@AuraEnabled public Integer OverRideLevelID;
		@AuraEnabled public String OverRideReason;
		@AuraEnabled public String OverrideLevel;
	}
	
    /**
	 * @description wrapper class PlstLoggedMessages
	 */
	public class PlstLoggedMessages {
		@AuraEnabled public List<DC2LoggedMsg> DC2LoggedMsg;
	}
    
	/**
	 * @description wrapper class Contract_LapseResponse
	 */
	public class contractLapseResponse {
		@AuraEnabled public Boolean Contract_LapseResult;
		@AuraEnabled public PlstLoggedMessages plstLoggedMessages;
	}

}