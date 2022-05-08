/**
 * @description       : Response Integration Bean for sMgetAsvCessionOfPledgesV1 Service
 * @author            : Prashant Jain
 * @last modified on  : 2021-06-11
 * @last modified by  : Prashant Jain
 * Modifications Log 
 * Ver   Date         Author          Modification
 * 1.0   2021-06-11   Prashant Jain   Initial Version
**/

public class sMgetAsvCessionOfPledgesV1_Resp_IB_v1 extends Base_IB {

    public String status;
    public Integer statusCode;
    public String message;
/** @description : Wrapper class for service */
	public class SMgetASVCessionOfGeneralPledgesV1Response {
		public Nbsapdpo nbsapdpo;
		public Nbsmsgo3 nbsmsgo3;
		public Smp149eo smp149eo;
	}
/** @description : Wrapper class for service */
	public class Nbsapdpo {
		public String returnCode;
		public String reasonCode;
		public String serviceVersion;
	}
/** @description : Wrapper class for service */
	public class Table {
		public String seqnoOut;
		public String asspldout;
		public String pldamtOut;
		public String plddteOut;
		public String eotdteOut;
		public String remvalout;
		public String limitedout;
		public String assrefOut;
		public String valdteOut;
		public String specifOut;
		public String refaccOut;
		public String statusOut;
		public String nomvalOut;
		public String secvalOut;
		public String asvamtOut;
		public String msvamtOut;
        public String clcdOut;
        public String clcd;
        public String ApplicationId;
	}

	public SMgetASVCessionOfGeneralPledgesV1Response SMgetASVCessionOfGeneralPledgesV1Response;
/** @description : Wrapper class for service */
	public class Nbsmsgo3 {
		public String version;
		public String nbrUserMsgs;
		public String nbrUserErrs;
	}
/** @description : Wrapper class for service */
	public class Smp149eo {
		//public Object clcdOut;
		//public Object nomvalTotOut;
		//public Object secvalTotOut;
		//public Object asvamtTotOut;
		//public Object msvamtTotOut;
		//public Object successInd;
		public List<Table> table;
	}
}