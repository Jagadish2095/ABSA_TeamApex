/**
 * @description       : Response Integration Bean for SMgetASVCessionOfFireShortTermInsuranceV1Response Service
 * @author            : Prashant Jain
 * @last modified on  : 2021-06-10
 * @last modified by  : Prashant Jain
 * Modifications Log 
 * Ver   Date         Author          Modification
 * 1.0   2021-06-10   Prashant Jain   Initial Version
**/

public class SMgetASVCessionOfFireShortV1_Resp_IB_v1 extends Base_IB{
    public String status;
    public Integer statusCode;
    public String message;
    
	/**
 * @description       : Response Integration Bean for SMgetASVCessionOfFireShortTermInsuranceV1Response Service
 * @author            : Prashant Jain
 * */
	public class SMgetASVCessionOfFireShortTermInsuranceV1Response {
		public Nbsapdpo nbsapdpo;
		public Nbsmsgo3 nbsmsgo3;
		public Smp132eo smp132eo;
	}
    /**
 * @description       : Response Integration Bean for SMgetASVCessionOfFireShortTermInsuranceV1Response Service
 * @author            : Prashant Jain
 * */
	public class Nbsapdpo {
		public String returnCode;
		public String reasonCode;
		public String serviceVersion;
	}
  /**
 * @description       : Response Integration Bean for SMgetASVCessionOfFireShortTermInsuranceV1Response Service
 * @author            : Prashant Jain
 * */
	public class Table {
		public String seqnoOut;
		public String institOut;
		public String polnoOut;
		public String polamtOut;
		public String poltypOut;
		public String ackdteOut;
		public String peotdaOut;
		public String specifOut;
		public String refaccOut;
		public String statusOut;
        public String clcd;
        public String ApplicationId;
        public String nomvalTotOut;
        public String msvamtTotOut;
	}

	public SMgetASVCessionOfFireShortTermInsuranceV1Response SMgetASVCessionOfFireShortTermInsuranceV1Response;
    /**
 * @description       : Response Integration Bean for SMgetASVCessionOfFireShortTermInsuranceV1Response Service
 * @author            : Prashant Jain
 * */
	public class Smp132eo {
		public String clcdOut;
		public String nomvalTotOut;
		public String secvalTotOut;
		public String asvamtTotOut;
		public String msvamtTotOut;
		public String successInd;
		public List<Table> table;
	}
    /**
 * @description       : Response Integration Bean for SMgetASVCessionOfFireShortTermInsuranceV1Response Service
 * @author            : Prashant Jain
 * */
	public class Nbsmsgo3 {
		public String version;
		public String nbrUserMsgs;
		public String nbrUserErrs;
	}
}