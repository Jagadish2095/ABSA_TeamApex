/**
 * @description Response Integration Bean for DLGetExceptionReport Service
 * @author Jason Quevauvilliers
 * @created 2021-03-29
 */
public class DLGetExceptionReport_Resp_IB_v1 extends Base_IB {
	//Used the Header_cls defined in the DLGetPaymentHistoryForCustomer_Resp_IBv1 class as they are the same structure
	@AuraEnabled
	public DLGetPaymentHistoryForCustomer_Resp_IBv1.Header_cls header;
	@AuraEnabled
	public List<CustomerDigitalLifestyleException_cls> customerDigitalLifestyleException;

	/**
	 * @description inner class
	 */
	public class CustomerDigitalLifestyleException_cls {
		@AuraEnabled
		public String cifKey;
		@AuraEnabled
		public String transactionID;
		@AuraEnabled
		public String transactionDate;
		@AuraEnabled
		public String transactionAmount;
		@AuraEnabled
		public String transactionAccount;
		@AuraEnabled
		public String voucherId;
		@AuraEnabled
		public String platformCode;
		@AuraEnabled
		public String transactionStatus;
		@AuraEnabled
		public String exceptionDescription;
		@AuraEnabled
		public String paymentType;
	}
}