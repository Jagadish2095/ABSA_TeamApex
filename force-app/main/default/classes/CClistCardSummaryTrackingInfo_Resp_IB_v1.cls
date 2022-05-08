/**
 * @description Response Integration Bean for CClistCardSummaryTrackingInfo Service
 * @author Jason Quevauvilliers
 * @created 2021-03-24
 */
public class CClistCardSummaryTrackingInfo_Resp_IB_v1 extends Base_IB {
	@AuraEnabled
	public List<Body_cls> body;

	/**
	 * @description inner class
	 */
	public class Body_cls {
		@AuraEnabled
		public CClistAllTrackingEventsPerSpecificCardV2Response_cls CClistAllTrackingEventsPerSpecificCardV2Response;
	}

	/**
	 * @description inner class
	 */
	public class CClistAllTrackingEventsPerSpecificCardV2Response_cls {
		@AuraEnabled
		public Nbsapdpo_cls nbsapdpo;
		@AuraEnabled
		public Nbsmsgo3_cls nbsmsgo3;
		@AuraEnabled
		public Ccs402o_cls ccs402o;
	}

	/**
	 * @description inner class
	 */
	public class Nbsapdpo_cls {
		@AuraEnabled
		public String version;
		@AuraEnabled
		public String returnCode;
		@AuraEnabled
		public String reasonCode;
		@AuraEnabled
		public String serviceVersion;
		@AuraEnabled
		public String echoKey;
	}
	/**
	 * @description inner class
	 */
	public class Nbsmsgo3_cls {
		@AuraEnabled
		public String version;
		@AuraEnabled
		public String sysErrTxt;
		@AuraEnabled
		public String nbrUserMsgs;
		@AuraEnabled
		public String nbrUserErrs;
	}
	/**
	 * @description inner class
	 */
	public class Ccs402o_cls {
		@AuraEnabled
		public String clientCode;
		@AuraEnabled
		public String regNbr;
		@AuraEnabled
		public String idNbr;
		@AuraEnabled
		public String cardNbr;
		@AuraEnabled
		public String addCard1;
		@AuraEnabled
		public String addCard2;
		@AuraEnabled
		public String addCard3;
		@AuraEnabled
		public String addCard4;
		@AuraEnabled
		public String addCard5;
		@AuraEnabled
		public String product;
		@AuraEnabled
		public String distrBranch;
		@AuraEnabled
		public String distrType;
		@AuraEnabled
		public String persName;
		@AuraEnabled
		public String delAddress1;
		@AuraEnabled
		public String delAddress2;
		@AuraEnabled
		public String delAddress3;
		@AuraEnabled
		public String delAddress4;
		@AuraEnabled
		public String postalCode;
		@AuraEnabled
		public String cellPhone;
		@AuraEnabled
		public String homePhone;
		@AuraEnabled
		public String workPhone;
		@AuraEnabled
		public String emailAddress;
		@AuraEnabled
		public String deliveryType;
		@AuraEnabled
		public String issueType;
		@AuraEnabled
		public String reason;
		@AuraEnabled
		public String cardStatus;
		@AuraEnabled
		public String actionStatus;
		@AuraEnabled
		public String copMarital;
		@AuraEnabled
		public String creditAct;
		@AuraEnabled
		public String contactPerson;
		@AuraEnabled
		public String carrierComp;
		@AuraEnabled
		public String portfolComp;
		@AuraEnabled
		public String institution;
		@AuraEnabled
		public String embosser;
		@AuraEnabled
		public String courier;
		@AuraEnabled
		public String xferDate;
		@AuraEnabled
		public String xferSite;
		@AuraEnabled
		public String counter;
		@AuraEnabled
		public List<Event_cls> event;
	}
	/**
	 * @description inner class
	 */
	public class Event_cls {
		@AuraEnabled
		public String seqNbr;
		@AuraEnabled
		public String eventStatus;
		@AuraEnabled
		public String eventDescr;
		@AuraEnabled
		public String eventDate;
		@AuraEnabled
		public String eventTime;
		@AuraEnabled
		public String operator;
	}

	public override void setIntegrationTranslations() {
		integrationTranslationsMap = new Map<String, String>();
		integrationTranslationsMap.put('body.CClistAllTrackingEventsPerSpecificCardV2Response.ccs402o.deliveryType', 'DSV;Delivery Method');
		integrationTranslationsMap.put('body.CClistAllTrackingEventsPerSpecificCardV2Response.ccs402o.issueType', 'DSV;Issue Type');
	}
}