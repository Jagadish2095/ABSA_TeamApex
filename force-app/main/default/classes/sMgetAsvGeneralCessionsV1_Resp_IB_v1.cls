/**
 * @description       : Response Integration Bean for sMgetAsvGeneralCessionsV1 Service
 * @author            : Prashant Jain
 * @last modified on  : 2021-06-11
 * @last modified by  : Prashant Jain
 * Modifications Log 
 * Ver   Date         Author          Modification
 * 1.0   2021-06-11   Prashant Jain   Initial Version
**/


public class sMgetAsvGeneralCessionsV1_Resp_IB_v1 extends Base_IB {
	
    public String status;
    public Integer statusCode;
    public String message;
    /** @description : Wrapper class for service */
    public class Nbsapdpo {
		public String returnCode;
		public String reasonCode;
		public String serviceVersion;
	}
/** @description : Wrapper class for service */
	public class Sms148o {
		public String clcd;
		public String tnomVal;
		public String tsecVal;
		public String tasvVal;
		public String tmasvVal;
		public String cashAccVal;
		public List<GcessTable> gcessTable;
	}

	public SMgetASVGeneralCessionsV1Response SMgetASVGeneralCessionsV1Response;
/** @description : Wrapper class for service */
	public class SMgetASVGeneralCessionsV1Response {
		public Nbsapdpo nbsapdpo;
		public Nbsmsgo3 nbsmsgo3;
		public Sms148o sms148o;
	}
/** @description : Wrapper class for service */
	public class GcessTable {
		public String specific;
		public String limited;
		public String status;
		public String cessionType;
		public String seqno;
		public String cessionAmnt;
		public String realmv;
		public String rentIncome;
		public String dateSign;
		public String valDate;
		public String matureDate;
		public String refAcc;
		public String nomVal;
		public String secVal;
		public String asvVal;
		public String masvVal;
		public String svPerc;
		public String asvPerc;
        public String clcd;
        public String ApplicationId;
	}
/** @description : Wrapper class for service */
	public class Nbsmsgo3 {
		public String version;
		public String nbrUserMsgs;
		public String nbrUserErrs;
	}
}