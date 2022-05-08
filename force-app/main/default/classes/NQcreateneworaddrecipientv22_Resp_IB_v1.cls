/*
* Integration Response Bean for NQcreateneworaddrecipientv2 Service  (for NOTIFY ME integration flow)
* @author Satya Boyenepalli
* @created 01-12-2020
*/

public class NQcreateneworaddrecipientv22_Resp_IB_v1 extends Base_IB {
     
    @AuraEnabled public String status;
    @AuraEnabled public Integer statusCode;
    @AuraEnabled public String message;

    	public NQcreateNewOrAddRecipientV2Response NQcreateNewOrAddRecipientV2Response;
	
	public class Nbsapdpo {
		@AuraEnabled public String returnCode;
		@AuraEnabled public String reasonCode;
		@AuraEnabled public String serviceVersion;
	}

	public class Nqp906o {
		public String rcode;
		public String pnsRecipientIdO;
	}

	public class Nbsmsgo {
		public String version;
		public String nbrUserMsgs;
		public String nbrUserErrs;
		public MsgEntry msgEntry;
	}

	public class MsgEntry {
		public String msgClass;
		public String msgCode;
		public String msgErrInd;
		public String msgTxt;
	}

	public class NQcreateNewOrAddRecipientV2Response {
	@AuraEnabled	public Nbsapdpo nbsapdpo;
	@AuraEnabled	public Nbsmsgo nbsmsgo;
	@AuraEnabled	public Nqp906o nqp906o;
	}

	

}