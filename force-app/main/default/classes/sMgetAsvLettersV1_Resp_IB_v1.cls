/**
 * @description       : Response Integration Bean for sMgetAsvLettersV1 Service
 * @author            : Prashant Jain
 * @last modified on  : 2021-06-11
 * @last modified by  : Prashant Jain
 * Modifications Log 
 * Ver   Date         Author          Modification
 * 1.0   2021-06-11   Prashant Jain   Initial Version
**/


public class sMgetAsvLettersV1_Resp_IB_v1 extends Base_IB {

    public String status;
    public Integer statusCode;
    public String message;
/** @description : Wrapper class for service */
	public class Nbsapdpo {
		public String returnCode;
		public String reasonCode;
		public String serviceVersion;
	}

	public SMgetASVLettersV1Response SMgetASVLettersV1Response;
/** @description : Wrapper class for service */
	public class SMgetASVLettersV1Response {
		public Nbsapdpo nbsapdpo;
		public Nbsmsgo3 nbsmsgo3;
		public Smn140o smn140o;
	}
/** @description : Wrapper class for service */
	public class Nbsmsgo3 {
		public String version;
		public String nbrUserMsgs;
		public String nbrUserErrs;
	}
/** @description : Wrapper class for service */
	public class LettersTable {
		public String specific;
		public String status;
		public String seqno;
		public String refacc;
		public String nomVal;
		public String secVal;
		public String masvVal;
		public String ocasVal;
		public String svperc;
		public String asvperc;
        public String clcd;
        public String ApplicationId;
	}
/** @description : Wrapper class for service */
	public class Smn140o {
		//public Object clcdOut;
		//public Object successInd;
		//public Object tnomVal;
		//public Object tsecVal;
		//public Object tasvVal;
		//public Object tmasvVal;
		public List<LettersTable> lettersTable;
	}
}