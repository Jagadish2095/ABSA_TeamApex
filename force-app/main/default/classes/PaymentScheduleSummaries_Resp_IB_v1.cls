/**
 *  * @description Response Integration Bean for Payment Schedule Summaries Service
 * @author manideep kenche
 * @created 2021-08-31
 */
public class PaymentScheduleSummaries_Resp_IB_v1 extends Base_IB{
public Integer total;	//3
	public String status;	//success
	@AuraEnabled public list<data> data;
	class data {
		public Integer scheduleId;	//2560
		public Integer consumerId;	//8595354
		public paymentScheduleTypeReference paymentScheduleTypeReference;
		public paymentScheduleStatusReference paymentScheduleStatusReference;
		public paymentScheduleReasonReference paymentScheduleReasonReference;
		public String comments;	//
		public createdUser createdUser;
		public nextPaymentEntryRM nextPaymentEntryRM;
		//public cls_accountIds[] accountIds;
		public boolean hasSettlementDetail;
		public boolean payoffSchedule;
		public boolean treatAsPromise;
		public achAuthorizationRequired achAuthorizationRequired;
		public achAuthorizationNoticeId achAuthorizationNoticeId;
		public achAuthorizationReceivedDate achAuthorizationReceivedDate;
		public achAuthorizationRecordedByUserId achAuthorizationRecordedByUserId;
		//public Integer createdDate;	//1589892961263
		public linkedScheduleId linkedScheduleId;
		public Integer rehabMinPaymentWindowInDays;	//0
		public totalPaymentAmount totalPaymentAmount;
		@AuraEnabled public regularPaymentAmount regularPaymentAmount;
		@AuraEnabled public Integer numOfPayments;	//1
		@AuraEnabled public paymentScheduleFrequencyReference paymentScheduleFrequencyReference;
		public Integer frequencyRate;	//1
	//	public String statusUpdateDate;
		public scheduleMetadataReference scheduleMetadataReference;
		public daysOfMonth daysOfMonth;
		public daysOfWeek daysOfWeek;
		public monthsOfYear monthsOfYear;
		public weeksOfMonth weeksOfMonth;
		public daysOffSet daysOffSet;
		@AuraEnabled public String startYMDDateInput;
		public endYMDDateInput endYMDDateInput;
		@AuraEnabled public numberOfMonthsInput numberOfMonthsInput;
		public String endYMDDate;	//20200520
		@AuraEnabled public downPaymentAmount downPaymentAmount;
		@AuraEnabled public string downPaymentYMDDate;
		public version version;
		public String businessKey;	//2560
	}
	class paymentScheduleTypeReference {
		public String resourceKey;	//crs.core.reference.schdld_pymnt_typ_cd.promiseschedule
		public String valueText;	//PROMISESCHEDULE
		public String descriptionText;	//promise scheduled payment type
		public Integer version;	//0
		public String businessKey;	//PROMISESCHEDULE
	}
	class paymentScheduleStatusReference {
		public String resourceKey;	//crs.core.reference.schdld_pymnt_stts_cd.broken
		@AuraEnabled public String valueText;	//BROKEN
		public String descriptionText;	//broken scheduled payment status code
		public Integer version;	//0
		public String businessKey;	//BROKEN
	}
	class paymentScheduleReasonReference {
		public String resourceKey;	//crs.core.reference.ref_pymnt_rsn_cd.payment
		public String valueText;	//PAYMENT
		public String descriptionText;	//Payment
		public Integer version;	//0
		public String businessKey;	//PAYMENT
	}
	class createdUser {
		public String username;	//ABNMAJN
		public boolean active;
		public String firstName;	//Mercy
		public String lastName;	//Mfeka
		public String businessKey;	//ABNMAJN
	}
	class nextPaymentEntryRM {
	}
	class cls_accountIds {
	}
	class achAuthorizationRequired {
	}
	class achAuthorizationNoticeId {
	}
	class achAuthorizationReceivedDate {
	}
	class achAuthorizationRecordedByUserId {
	}
	class linkedScheduleId {
	}
	class totalPaymentAmount {
		public Double amount;	//333230.21
		public currencyRefCode currencyRefCode;
	}
	class currencyRefCode {
	}
	class regularPaymentAmount {
		@AuraEnabled public Double amount;	//333230.21
		public currencyRefCode currencyRefCode;
	}
	class paymentScheduleFrequencyReference {
		public String resourceKey;	//crs.core.reference.pymnt_frqncy_cd.daily
		@AuraEnabled public String valueText;	//DAILY
		public String descriptionText;	//daily payment frequency code
		public Integer version;	//0
		public String businessKey;	//DAILY
	}
	class scheduleMetadataReference {
	}
	class daysOfMonth {
	}
	class daysOfWeek {
	}
	class monthsOfYear {
	}
	class weeksOfMonth {
	}
	class daysOffSet {
	}
	class endYMDDateInput {
	}
	class numberOfMonthsInput {
	}
	class downPaymentAmount {
	}
	class downPaymentYMDDate {
	}
	class version {
	}
}