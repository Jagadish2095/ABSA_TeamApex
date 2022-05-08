/**
 * @description       :
 * @author            : Mradul Maheshwari
 * @last modified on  : 2021-09-08
 * @last modified by  : humbelani.denge@absa.africa
 * @Work Id           : W-005674
 **/
public with sharing class AccountPreValidationRequest_Resp_IB_v1 extends Base_IB {
	@AuraEnabled
	public String status;
	@AuraEnabled
	public Integer statusCode;
	@AuraEnabled
	public String message;

	@AuraEnabled
	public Integer accountNumber;
	@AuraEnabled
	public RestructureResults restructureResults;
	/**
	 * @description RestructureResults
	 * **/
	public class RestructureResults {
		@AuraEnabled
		public List<Result> result;
	}
	/**
	 * @description Result
	 * **/
	public class Result {
		@AuraEnabled
		public String description;
		@AuraEnabled
		public String type;
		@AuraEnabled
		public String allowed;
		public String reason;
		@AuraEnabled
		public Integer code;
	}
}