/**
 * @description       : Response Integration Bean for SMgetASVCessionOfExternalInvestmentsV1 Service
 * @author            : Muvhuso Nelhubvi
 * @last modified on  : 2021-06-11
 * @last modified by  : Prashant Jain
 * Modifications Log 
 * Ver   Date         Author          Modification
 * 1.0   2020-03-21   Muvhuso Nelhubvi   Initial Version
**/


public class sMgetAsvCessionOfExtInv_Resp_IB_v1 extends Base_IB {
    
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
	public class Table {
		public String seqnoOut;
		public String asscoveredOut;
		public String dteSignedOut;
		public String ackdteOut;
		public String matdteOut;
		public String cessamtOut;
		public String nomvalOut;
		public String secvalOut;
		public String appsecvalOut;
		public String mappsecvalOut;
		public String invaccnoOut;
		public String invtypeOut;
		public String acchldcdOut;
		public String specificOut;
		public String refaccnoOut;
		public String aStatusOut;
        public String clcd;
        public String ApplicationId;
	}

	public SMgetASVCessionOfExternalInvestmentsV1Response SMgetASVCessionOfExternalInvestmentsV1Response;
/** @description : Wrapper class for service */
	public class SMgetASVCessionOfExternalInvestmentsV1Response {
		public Nbsapdpo nbsapdpo;
		public Nbsmsgo3 nbsmsgo3;
		public Smp147eo smp147eo;
	}
/** @description : Wrapper class for service */
	public class Nbsmsgo3 {
		public String version;
		public String nbrUserMsgs;
		public String nbrUserErrs;
	}
/** @description : Wrapper class for service */
	public class Smp147eo {
		public String clcdOut;
		public String totNomvalOut;
		public String totSecvalOut;
		public String totAppsecvalOut;
		public String totMappsecvalOut;
		public String successInd;
		public List<Table> table;        
	}
}