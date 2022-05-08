/**
 * @description response bean for get customer voucher history service (W-009112)
 * @author Humbelani Denge
 * @created 2021/05/10
 */
public class GetVoucherHistoryOfCustomer_Resp_IB_v1 extends Base_IB {
    @AuraEnabled public String status;
    @AuraEnabled public Integer statusCode;
    @AuraEnabled public String message;

	/**
	 * @description Header class
	 */
    public class Header {
		@AuraEnabled public String statuscode;
		@AuraEnabled public Object userAgent;
		@AuraEnabled public Object wfpt;
		@AuraEnabled public Object jsessionid;
		@AuraEnabled public Object esessionid;
		@AuraEnabled public Object xfpt;
		@AuraEnabled public String service;
		@AuraEnabled public String operation;
		@AuraEnabled public Object channel;
		@AuraEnabled public String timestamp;
		@AuraEnabled public Object sourceip;
		@AuraEnabled public Object accessAccount;
		@AuraEnabled public Object userNumber;
		@AuraEnabled public Object nonce;
		@AuraEnabled public Object language;
		@AuraEnabled public Object organization;
		@AuraEnabled public Object brand;
		@AuraEnabled public Object applicationId;
		@AuraEnabled public Object applicationKeyId;
		@AuraEnabled public Object requestToken;
		@AuraEnabled public List<ResultMessages> resultMessages;
		@AuraEnabled public Object paginationContext;
	}

	public Header header;
	@AuraEnabled public List<CustomerVoucherHistory> customerVoucherHistory;

	/**
	 * @description ResultMessages class
	 */
	public class ResultMessages {
		@AuraEnabled public String responseSeverity;
		@AuraEnabled public String responseMessage;
	}

	/**
	 * @description Vouchers class
	 */
	public class Vouchers {
		@AuraEnabled public String redemptionDateTime;
		@AuraEnabled public String channel;
		@AuraEnabled public String rewardPinVoucher;
		@AuraEnabled public String offerTier;
		@AuraEnabled public String offerDescription;
		@AuraEnabled public String offerExpiryDays;
		@AuraEnabled public String offerExpiryDateTime;
		@AuraEnabled public String offerStatus;
		@AuraEnabled public String partnerName;
		@AuraEnabled public String offerRandValue;
	}

	/**
	 * @description CustomerVoucherHistory class
	 */
	public class CustomerVoucherHistory {
		@AuraEnabled public String partnerId;
		@AuraEnabled public List<Vouchers> vouchers;
	}

}