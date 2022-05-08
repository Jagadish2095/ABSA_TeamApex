/**
 * @description Response Integration Bean for CClistAccsLinkedToCombiV1 Service
 * @author: Humbelani Denge
 * @created 2021-02-12
 */
public class CClistAccsLinkedToCombiV1_Resp_IB_v1 extends Base_IB {
	@AuraEnabled
	public String status;
	@AuraEnabled
	public Integer statusCode;
	@AuraEnabled
	public String message;
	/**
	 * @description inner class
	 */
	public class CClistAccsLinkedToACombiCardV1Response {
		@AuraEnabled
		public Nbsapdpo nbsapdpo;
		@AuraEnabled
		public Nbsmsgo nbsmsgo;
		@AuraEnabled
		public Ccp308o ccp308o;
	}
	/**
	 * @description inner class
	 */
	public class Nbsapdpo {
		@AuraEnabled
		public String returnCode;
		@AuraEnabled
		public String reasonCode;
		@AuraEnabled
		public String serviceVersion;
	}

	@AuraEnabled
	public CClistAccsLinkedToACombiCardV1Response CClistAccsLinkedToACombiCardV1Response;
	/**
	 * @description inner class
	 */
	public class Nbsmsgo {
		@AuraEnabled
		public String version;
		@AuraEnabled
		public String nbrUserMsgs;
		@AuraEnabled
		public String nbrUserErrs;
	}
	/**
	 * @description inner class
	 */
	public class Ccp308o {
		@AuraEnabled
		public String nbrAccntRet;
		@AuraEnabled
		public List<LnkAccntLst> lnkAccntLst;
		@AuraEnabled
		public String lnkNxtAccnt;
	}
	/**
	 * @description inner class
	 */
	public class LnkAccntLst {
		@AuraEnabled
		public String accntNbr;
		@AuraEnabled
		public String balDspInd;
		@AuraEnabled
		public String wthDwlInd;
		@AuraEnabled
		public String thirdPtyInd;
		@AuraEnabled
		public Integer banktelCde;
		@AuraEnabled
		public Integer accClsDate;
		@AuraEnabled
		public Integer secCshLim;
		@AuraEnabled
		public Integer secTrfLim;
		@AuraEnabled
		public Integer secPosLim;
	}
}