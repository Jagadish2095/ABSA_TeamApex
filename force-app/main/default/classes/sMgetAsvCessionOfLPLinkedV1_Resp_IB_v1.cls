/**
 * @description       : Response Integration Bean for sMgetAsvCessionOfLPLinkedV1 Service
 * @author            : Prashant Jain
 * @last modified on  : 2021-06-11
 * @last modified by  : Prashant Jain
 * Modifications Log 
 * Ver   Date         Author          Modification
 * 1.0   2021-06-11   Prashant Jain   Initial Version
**/

public class sMgetAsvCessionOfLPLinkedV1_Resp_IB_v1 extends Base_IB {

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
	public class SMgetASVCessionOfLifePoliciesLinkedV1Response {
		public Nbsapdpo nbsapdpo;
		public Nbsmsgo3 nbsmsgo3;
		public Smp332eo smp332eo;
	}
/** @description : Wrapper class for service */
	public class Table {
		public String seqnoOut;
		public String polamtOut;
		public String poltypOut;
		public String ackdteOut;
		public String peotdaOut;
		public String ltddteOut;
		public String valdteOut;
		public String covamtOut;
		public String totpolOut;
		public String netvalOut;
		public String refaccOut;
		public String supsnoOut;
		public String clcd;
        public String lifassOut;
        public String specifOut;    
		public String nomvalOut;
		public String secvalOut;
		public String asvamtOut;
		public String msvamtOut;
        public String polnoOut;
        public String statusOut;
        public String institOut;
        public String ApplicationId;
	}

	public SMgetASVCessionOfLifePoliciesLinkedV1Response SMgetASVCessionOfLifePoliciesLinkedV1Response;
/** @description : Wrapper class for service */
	public class Nbsmsgo3 {
		public String version;
		public String nbrUserMsgs;
		public String nbrUserErrs;
	}
/** @description : Wrapper class for service */
	public class Smp332eo {
		//public Object clcdOut;
		//public Object nomvalTotOut;
		//public Object secvalTotOut;
		//public Object asvamtTotOut;
		//public Object msvamtTotOut;
		//public Object successInd;
		public List<Table> table;
	}
}