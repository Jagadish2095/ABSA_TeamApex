/**
 * @description       : Response Integration Bean for sMgetAsvCessionOfSharesV1 Service
 * @author            : Prashant Jain
 * @last modified on  : 2021-06-11
 * @last modified by  : Prashant Jain
 * Modifications Log 
 * Ver   Date         Author          Modification
 * 1.0   2021-06-11   Prashant Jain   Initial Version
**/

public class sMgetAsvCessionOfSharesV1_Resp_IB_v1 extends Base_IB {

    public String status;
    public Integer statusCode;
    public String message;
/** @description : Wrapper class for service */
	public class SMgetASVCessionOfSharesV1Response {
		public Nbsapdpo nbsapdpo;
		public Nbsmsgo3 nbsmsgo3;
		public Smn136o smn136o;
	}
/** @description : Wrapper class for service */
	public class Nbsapdpo {
		public String returnCode;
		public String reasonCode;
		public String serviceVersion;
	}

	public SMgetASVCessionOfSharesV1Response SMgetASVCessionOfSharesV1Response;
/** @description : Wrapper class for service */
	public class Smn136o {
		//public Object clcdOut;
		//public Object tnomVal;
		//public Object tsecVal;
		//public Object tasvVal;
		//public Object tmasvVal;
		//public Object ocasvVal;
		public List<OutputTbl> outputTbl;
	}
/** @description : Wrapper class for service */
	public class Nbsmsgo3 {
		public String version;
		public String nbrUserMsgs;
		public String nbrUserErrs;
	}
/** @description : Wrapper class for service */
	public class OutputTbl {
		public String specific;
		public String status;
		public String shareNm;
		public String seqno;
		public String noshares;
		public String nomVal;
		public String secVal;
		public String ascVal;
		public String mascVal;
		public String cessamt;
		public String signdte;
		public String refAcc;
        public String clcd;
        public String ApplicationId;
	}
}