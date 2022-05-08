/**
 * @description Integration Response Bean for ContractDeleteComponent Service
 * @author Koketso Mpshane
 * @created 2021-06-29
 */
public class ContractDeleteComponent_Resp_IB_v1  extends Base_IB {

    @AuraEnabled public String status;
    @AuraEnabled public Integer statusCode;
    @AuraEnabled public String message;
	/**
	 * @description wrapper class Contract_Delete_ComponentResponse
	 */
    public class Contract_Delete_ComponentResponse {
		@AuraEnabled public String Contract_Delete_ComponentResult;
		@AuraEnabled public PcolValidationMessages pcolValidationMessages;
	}
	/**
	 * @description wrapper class V3_DC2_LoggedMsg
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

	public Contract_Delete_ComponentResponse Contract_Delete_ComponentResponse;
	/**
	 * @description wrapper class PcolValidationMessages
	 */
	public class PcolValidationMessages {
		@AuraEnabled public List<V3_DC2_LoggedMsg> V3_DC2_LoggedMsg;
    }

}