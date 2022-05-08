/**
 * @description response bean for get challenges service (W-009112)
 * @author Humbelani Denge.
 * @Created 2021/05/10.
 */
public class GetChallenges_Resp_IB_v1 extends Base_IB {
	@AuraEnabled
	public String status;
	@AuraEnabled
	public Integer statusCode;
	@AuraEnabled
	public String message;

	@AuraEnabled
	public Header header;
	@AuraEnabled
	public List<Challenges> challenges;

	/**
	 * @description CustomerChallengeStatus class
	 */
	public class CustomerChallengeStatus {
		@AuraEnabled
		public String status;
		@AuraEnabled
		public String progress;
		@AuraEnabled
		public String customerChallengeEndDate;
		@AuraEnabled
		public String customerChallengeStartDate;
		@AuraEnabled
		public String acceptedOnDate;
		@AuraEnabled
		public String addedOnDate;
		@AuraEnabled
		public String completedOnDate;
		@AuraEnabled
		public String voucherAllocationStatus;
		@AuraEnabled
		public VoucherForChallenge voucherForChallenge;
	}

	/**
	 * @description Header class
	 */
	public class Header {
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
		public List<ResultMessages> resultMessages;
		public String paginationContext;
	}

	/**
	 * @description VoucherForChallenge class
	 */
	public class VoucherForChallenge {
		@AuraEnabled
		public String voucherPin;
		@AuraEnabled
		public String voucherPartnerID;
		@AuraEnabled
		public String voucherIssueDate;
		@AuraEnabled
		public String voucherType;
		@AuraEnabled
		public String voucherValue;
		@AuraEnabled
		public String voucherExpiryDate;
		@AuraEnabled
		public String voucherStatus;
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
	 * @description Challenges class
	 */
	public class Challenges {
		@AuraEnabled
		public String longDescription;
		@AuraEnabled
		public String shortDescription;
		@AuraEnabled
		public String challengeId;
		@AuraEnabled
		public String challengeStartDate;
		@AuraEnabled
		public String challengeEndDate;
		@AuraEnabled
		public CustomerChallengeStatus customerChallengeStatus;
		@AuraEnabled
		public Boolean active;
	}
}