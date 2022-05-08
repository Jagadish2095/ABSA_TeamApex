/**
 * @description Integration Bean for RewardsGetlookups response Service
 * @author Jabulani Mashia
 * @created 2021-08-026
 **/
public without sharing class RewardsGetlookups_Resp_IB_v1 extends Base_IB {
	public RewardsGetlookupsResponse RewardsGetlookupsResponse;
	public GetLookupsResponse GetLookupsResponse;
	public DebitOrderAmounts DebitOrderAmounts;
	public GetLookupsResult GetLookupsResult;
	/**
	 * @description RewardsGetlookupsResponse
	 * @author Jabulani Mashia
	 **/
	public class RewardsGetlookupsResponse {
		public GetLookupsResponse GetLookupsResponse;
	}

	/**
	 * @description GetLookupsResult
	 * @author Jabulani Mashia
	 **/
	public class GetLookupsResult {
		public DebitOrderAmounts DebitOrderAmounts;
		public Languages Languages;
		public MethodResponse MethodResponse;
		public NotificationMethods NotificationMethods;
		public Object RedemptionTypes;
		public StatementNotificationMethods StatementNotificationMethods;
	}

	/**
	 * @description DebitOrderAmounts
	 * @author Jabulani Mashia
	 **/
	public class DebitOrderAmounts {
		public Double NonStaffAnnualFee;
		public Double NonStaffMonthlyFee;
		public Double StaffAnnualFee;
		public Double StaffMonthlyFee;
	}

	/**
	 * @description Languages
	 * @author Jabulani Mashia
	 **/
	public class Languages {
		public List<Language> Language;
	}

	/**
	 * @description StatementNotificationMethods
	 * @author Jabulani Mashia
	 **/
	public class StatementNotificationMethods {
		public List<Language> StatementNotificationMethod;
	}

	/**
	 * @description MethodResponse
	 * @author Jabulani Mashia
	 **/
	public class MethodResponse {
		public String ErrorCode;
		public String ErrorReferenceNumber;
		public String DetailedError;
	}

	/**
	 * @description GetLookupsResponse
	 * @author Jabulani Mashia
	 **/
	public class GetLookupsResponse {
		public GetLookupsResult GetLookupsResult;
	}

	/**
	 * @description Language
	 * @author Jabulani Mashia
	 **/
	public class Language {
		public String Code;
		public String Description;
	}

	/**
	 * @description NotificationMethods
	 * @author Jabulani Mashia
	 **/
	public class NotificationMethods {
		public List<Language> NotificationMethod;
	}

	/**
	 * @description dummyResponse
	 * @author Jabulani Mashia
	 * @return rewardsGetlookups_Resp_IB_v1
	 **/
	//public static rewardsGetlookups_Resp_IB_v1 dummyResponse(){
	//  rewardsGetlookups_Resp_IB_v1 responseBean = new rewardsGetlookups_Resp_IB_v1();

	//return responseBean;
	//}
}