/*
 * Request Integration Bean for SiebelGetPolicyDetailsById Service
 * @author Poulami Banerjee
 * @created 2021-04-14
 */
/**
 * @description SiebelGetPolicyDetailsById_Resp_IB_v1 Description
 *
 */
public class SiebelGetPolicyDetailsById_Resp_IB_v1 extends Base_IB {
	@AuraEnabled
	public Response Response;
	/**
	 * @description Response Description
	 *
	 */
	public class Response {
		@AuraEnabled
		public Message Message;
		@AuraEnabled
		public Result Result;
	}
	/**
	 * @description ListOfPolicy Description
	 *
	 */
	public class ListOfPolicy {
		@AuraEnabled
		public String policyNumber;
		@AuraEnabled
		public String productDesc;
		@AuraEnabled
		public Integer coverAmt;
		@AuraEnabled
		public Double premium;
		@AuraEnabled
		public Double outstandingAmt;
		@AuraEnabled
		public String itcFlag;
		@AuraEnabled
		public String sasriaFlag;
		@AuraEnabled
		public String policyStatus;
		@AuraEnabled
		public String actionCode;
		@AuraEnabled
		public String sourceSystem;
		@AuraEnabled
		public String endorseFlag;
		@AuraEnabled
		public String inceptionDate;
		@AuraEnabled
		public String effectiveDate;
		@AuraEnabled
		public String renewDate;
	}
	/**
	 * @description Message Description
	 *
	 */
	public class Message {
		@AuraEnabled
		public GetPoliciesByIDResponse GetPoliciesByIDResponse;
	}
	/**
	 * @description GetPoliciesByIDResponse Description
	 *
	 */
	public class GetPoliciesByIDResponse {
		@AuraEnabled
		public List<ListOfPolicy> ListOfPolicy;
	}
	/**
	 * @description Result Description
	 *
	 */
	public class Result {
		public String TransactionId;
		public Integer Code;
		@AuraEnabled
		public String Status;
		@AuraEnabled
		public String Description;
	}
}