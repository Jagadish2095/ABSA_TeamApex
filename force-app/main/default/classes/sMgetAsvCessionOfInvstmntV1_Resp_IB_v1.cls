/**
 * @description       : Integration Bean for sMgetAsvCessionOfInvstmntV1 Service
 * @author            : Prashant Jain
 * @last modified on  : 2021-06-11
 * @last modified by  : Prashant Jain
 * Modifications Log 
 * Ver   Date         Author          Modification
 * 1.0   2021-06-11   Prashant Jain   Initial Version
**/


public class sMgetAsvCessionOfInvstmntV1_Resp_IB_v1 extends Base_IB {

    public String status;
    public Integer statusCode;
    public String message;
/** @description : Wrapper class for service */
	public class Nbsapdpo {
		public String returnCode;
		public String reasonCode;
		public String serviceVersion;
	}

	public SMgetASVCessionOfInternalInvestmentsV1Response SMgetASVCessionOfInternalInvestmentsV1Response;
/** @description : Wrapper class for service */
	public class Nbsmsgo3 {
		public String version;
		public String nbrUserMsgs;
		public String nbrUserErrs;
	}
/** @description : Wrapper class for service */
	public class SMgetASVCessionOfInternalInvestmentsV1Response {
		public Nbsapdpo nbsapdpo;
		public Nbsmsgo3 nbsmsgo3;
		public Smn146o smn146o;
	}
/** @description : Wrapper class for service */
	public class Smn146o {
		//public Object clcdOut;
		//public Object totNomvalOut;
		//public Object totSecvalOut;
		//public Object totAppsecvalOut;
		//public Object totMappsecvalOut;
		//public Object successInd;
		public List<Smn146oTable> smn146oTable;
	}
/** @description : Wrapper class for service */
	public class Smn146oTable {
		public String seqnoOut;
		public String dteSignedOut;
		public String ackdteOut;
		public String matdteOut;
		public String cessamtOut;
		public String nomvalOut;
		public String secvalOut;
		public String appsecvalOut;
		public String mappsecvalOut;
		public String ainvnoOut;
		public String accbalOut;
		public String camt1Out;
		public String camt2Out;
		public String camt3Out;
		public String camt4Out;
		public String camt5Out;
        public String chold1Out;
		public String chold2Out;
		public String chold3Out;
		public String chold4Out;
		public String chold5Out;
		public String totcesOut;
		public String avlamtOut;
		public String refaccnoOut;
        public String aStatusOut;
        public String limcesOut;
        public String clcd;
        public String ApplicationId;      
        public String specificout;
	}
}