/**
 * @description       : Integration Bean for sMgetAsvCessionOfSchemesV1 Service
 * @author            : Prashant Jain
 * @last modified on  : 2021-06-11
 * @last modified by  : Prashant Jain
 * Modifications Log 
 * Ver   Date         Author          Modification
 * 1.0   2021-06-11   Prashant Jain   Initial Version
**/

public class sMgetAsvCessionOfSchemesV1_Resp_IB_v1 extends Base_IB {
 
    public String status;
    public Integer statusCode;
    public String message;
	/** @description       : Integration Bean for sMgetAsvCessionOfSchemesV1 Service*/
	public class Nbsapdpo {
		public String returnCode;
		public String reasonCode;
		public String serviceVersion;
	}
	/** @description       : Integration Bean for sMgetAsvCessionOfSchemesV1 Service*/
	public class Table {
		public String seqnoOut;
		public String schtypOut;
		public String schnumOut;
		public String schamtOut;
		public String origlnOut;
		public String guarntOut;
		public String crisdtOut;
		public String specifOut;
		public String refaccOut;
		public String statusOut;
        public String clcd;
        public String nomvalOut;
        public String ApplicationId;
        public String Status;
        public string msvamtTotOut;
        
	}

	public SMgetASVCessionOfSchemesV1Response SMgetASVCessionOfSchemesV1Response;
	/** @description       : Integration Bean for sMgetAsvCessionOfSchemesV1 Service*/
	public class Smp135eo {
		public List<Table> table;
        public string asvamtTotOut;
	}
	/** @description       : Integration Bean for sMgetAsvCessionOfSchemesV1 Service*/
	public class Nbsmsgo3 {
		public String version;
		public String nbrUserMsgs;
		public String nbrUserErrs;
	}
	/** @description       : Integration Bean for sMgetAsvCessionOfSchemesV1 Service*/
	public class SMgetASVCessionOfSchemesV1Response {
		public Nbsapdpo nbsapdpo;
		public Nbsmsgo3 nbsmsgo3;
		public Smp135eo smp135eo;
	}
}