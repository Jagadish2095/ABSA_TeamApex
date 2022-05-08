/**
 * @description Response Integration Bean for GetAvailableVouchers Service
 * @author Simangaliso Mathenjwa
 * @created 2021-11-04
 */
public class GetAvailableVouchers_Resp_IB_v1 extends Base_IB {
	@AuraEnabled
	public Integer statusCode;
	@AuraEnabled
	public String status;
	@AuraEnabled
	public String message;
	/**
	 * @description VoucherPartners class
	 */
	public class VoucherPartners {
		@AuraEnabled
		public String partnerId;
		@AuraEnabled
		public List<PartnerOffers> partnerOffers;
	}

	@AuraEnabled
	public Header header;
	@AuraEnabled
	public String txnReference;
	@AuraEnabled
	public List<VoucherPartners> voucherPartners;

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
		@AuraEnabled
		public Object reasonCode;
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

	/**
	 * @description PartnerOffers class
	 */
	public class PartnerOffers {
		@AuraEnabled
		public String offerId;
		@AuraEnabled
		public String offerTier;
		@AuraEnabled
		public String offerExpiryDays;
		@AuraEnabled
		public String offerDescription;
	}
}