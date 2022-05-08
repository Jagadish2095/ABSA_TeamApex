/**
 * @description Response Integration Bean for DLGetPaymentHistoryForCustomer Service
 * @author Jason Quevauvilliers
 * @created 2021-03-17
 */
public class DLGetPaymentHistoryForCustomer_Resp_IBv1 extends Base_IB {
	@AuraEnabled
	public Header_cls header;
	@AuraEnabled
	public List<PaymentHistory_cls> paymentHistoryList;

	/**
	 * @description inner class
	 */
	public class Header_cls {
		@AuraEnabled
		public String statuscode;
		@AuraEnabled
		public String userAgent;
		@AuraEnabled
		public String wfpt;
		@AuraEnabled
		public String jsessionid;
		@AuraEnabled
		public String esessionid;
		@AuraEnabled
		public String xfpt;
		@AuraEnabled
		public String service;
		@AuraEnabled
		public String operation;
		@AuraEnabled
		public String channel;
		@AuraEnabled
		public String timestamp;
		@AuraEnabled
		public String sourceip;
		@AuraEnabled
		public String accessAccount;
		@AuraEnabled
		public String userNumber;
		@AuraEnabled
		public String nonce;
		@AuraEnabled
		public String language;
		@AuraEnabled
		public String organization;
		@AuraEnabled
		public String brand;
		@AuraEnabled
		public String applicationId;
		@AuraEnabled
		public String applicationKeyId;
		@AuraEnabled
		public String requestToken;
		@AuraEnabled
		public String paginationContext;
		@AuraEnabled
		public List<ResultMessage_cls> resultMessages;
	}

	/**
	 * @description inner class
	 */
	public class ResultMessage_cls {
		@AuraEnabled
		public String responseSeverity;
		@AuraEnabled
		public String responseMessage;
	}

	/**
	 * @description inner class
	 */
	public class PaymentHistory_cls {
		@AuraEnabled
		public String paymentReference;
		@AuraEnabled
		public String dateCreated;
		@AuraEnabled
		public String dateModified;
		@AuraEnabled
		public String voucherDescription;
		@AuraEnabled
		public String voucherPaymentAmount;
		@AuraEnabled
		public String sourceAccountNumber;
		@AuraEnabled
		public String transactionStatus;
		@AuraEnabled
		public String exceptionMessage;
		@AuraEnabled
		public String voucherExpiryDate;
	}
}