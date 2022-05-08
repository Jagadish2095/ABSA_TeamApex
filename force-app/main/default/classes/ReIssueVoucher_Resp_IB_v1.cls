/**
 * @description response bean ReIssueVoucher
 * @author Simangaliso Mathenjwa
 * @created 2021 11 16
 */
public class ReIssueVoucher_Resp_IB_v1 extends Base_IB {
	@AuraEnabled
	public Integer statusCode;
	@AuraEnabled
	public String status;
	@AuraEnabled
	public String message;

	@AuraEnabled
	public Header header;
	@AuraEnabled
	public String valid;
	@AuraEnabled
	public String redemptionDateTime;
	@AuraEnabled
	public String voucherPin;
	@AuraEnabled
	public String partnerId;
	@AuraEnabled
	public String partnerCategory;
	@AuraEnabled
	public String partnerName;
	@AuraEnabled
	public String offerId;
	@AuraEnabled
	public String offerTier;
	@AuraEnabled
	public String offerRandValue;
	@AuraEnabled
	public String offerPointsValue;
	@AuraEnabled
	public String offerExpiryDays;
	@AuraEnabled
	public String offerDescription;
	@AuraEnabled
	public String voucherExpiryDateTime;
	@AuraEnabled
	public String txnReference;

	/**
	 * @description Header class
	 */
	public class Header {
		@AuraEnabled
		public String statuscode;
		@AuraEnabled
		public Object userAgent;
		@AuraEnabled
		public Object wfpt;
		@AuraEnabled
		public Object jsessionid;
		@AuraEnabled
		public Object esessionid;
		@AuraEnabled
		public Object xfpt;
		@AuraEnabled
		public String service;
		@AuraEnabled
		public String operation;
		@AuraEnabled
		public Object channel;
		@AuraEnabled
		public String timestamp;
		@AuraEnabled
		public Object sourceip;
		@AuraEnabled
		public Object accessAccount;
		@AuraEnabled
		public Object userNumber;
		@AuraEnabled
		public Object nonce;
		@AuraEnabled
		public Object language;
		@AuraEnabled
		public Object organization;
		@AuraEnabled
		public Object brand;
		@AuraEnabled
		public Object applicationId;
		@AuraEnabled
		public Object applicationKeyId;
		@AuraEnabled
		public Object requestToken;
		@AuraEnabled
		public List<ResultMessages> resultMessages;
		@AuraEnabled
		public Object paginationContext;
	}

	/**
	 * @description ResultMessages class
	 */
	public class ResultMessages {
		@AuraEnabled
		public String responseSeverity;
		@AuraEnabled
		public String responseMessage;
	}
}