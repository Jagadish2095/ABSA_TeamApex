/**
 * @description       : Request Integration Bean for SMgetASVCessionOfUnitTrustsV1 Service
 * @author            : Gulafsha
 * @last modified on  : 2021-06-11
 * Modifications Log 
 * Ver   Date         Author          Modification
 * 1.0   2021-06-11   Gulafsha   Initial Version
**/

/*
 * Request Integration Bean for SMgetASVCessionOfUnitTrustsV1 Service
 * @author Gulafsha
 * @created 2021-01-04
 */
public class SMgetASVCessionOfUnitTrustsV1_Resp_IB_v1 extends Base_IB {

    public String status;
    public Integer statusCode;
    public String message;
/** @description : Wrapper class for service */
	public class nbsapdpo {
		public String returnCode;
		public String reasonCode;
		public String serviceVersion;
	}

	public SMgetASVCessionOfUnitTrustsV1Response SMgetASVCessionOfUnitTrustsV1Response;
/** @description : Wrapper class for service */
	public class SMgetASVCessionOfUnitTrustsV1Response {
		public Nbsapdpo nbsapdpo;
		public Nbsmsgo3 nbsmsgo3;
		public smn236o smn236o;
	}
/** @description : Wrapper class for service */
	public class Nbsmsgo3 {
		public String version;
		public String nbrUserMsgs;
		public String nbrUserErrs;
	}
/** @description : Wrapper class for service */
	public class smn236o {
		public String tnomVal;
        public String clcdOut;
		public String tsecVal;
		public String tasvVal;
		public String tmasvVal;
		public List<outputTbl> outputTbl;
	}
/** @description : Wrapper class for service */
	public class outputTbl {
		public String specific;
        public String status;
		public String redmFrmHeld;
		public String shareNm;
		public String seqno;
        public String noshares;
        public String nomVal;
        public String secVal;
		public String ascVal;
        public String mascVal;
		public String cessamt;
		public String signdte;
		public String ackndte;
		public String refAcc;
        public String limite;//NOT FOUND ON JSON
        public String certnum;//Not Found on json
        public String ApplicationId;
        public String clcd;
	}

}