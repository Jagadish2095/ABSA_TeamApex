/**
 * @description       : Response Integration Bean for sMgetAsvSuretyshipsV1 Service
 * @author            : Prashant Jain
 * @last modified on  : 2021-06-11
 * @last modified by  : Prashant Jain
 * Modifications Log 
 * Ver   Date         Author          Modification
 * 1.0   2021-06-11   Prashant Jain   Initial Version
**/

public class sMgetAsvSuretyshipsV1_Resp_IB_v1 extends Base_IB {

    public String status;
    public Integer statusCode;
    public String message;
/** @description : Wrapper class for service */
	public class Nbsapdpo {
		public String returnCode;
		public String reasonCode;
		public String serviceVersion;
	}

	public SMgetASVSuretyshipsV1Response SMgetASVSuretyshipsV1Response;
/** @description : Wrapper class for service */
	public class SMgetASVSuretyshipsV1Response {
		public Nbsapdpo nbsapdpo;
		public Nbsmsgo3 nbsmsgo3;
		public Smn152o smn152o;
	}
/** @description : Wrapper class for service */
	public class SuretyTable {
		public String apprvSec;
		public String suppSec;
		public String suretyname;
		public String suretyClcd;
		public String seqno;
		public String suretyAcc;
		public String dateSign;
		public String suretyamt;
		public String refAcc;
		public String secVal;
		public String nomVal;
		public String asv;
		public String mortasv;
        public String clcd;
        public String status;
        public String specifc;
        public String ApplicationId;
	}
/** @description : Wrapper class for service */
	public class Nbsmsgo3 {
		public String version;
		public String nbrUserMsgs;
		public String nbrUserErrs;
	}
/** @description : Wrapper class for service */
	public class Smn152o {
		//public Object clcdOut;
		//public Object successInd;
		//public Object tnomVal;
		//public Object tsecVal;
		//public Object tasvVal;
		//public Object tmasvVal;
		public List<SuretyTable> suretyTable;
	}
}