/**
 * @description       : Response Integration Bean for sMgetAsvSecurityAndHoldsV1 Service
 * @author            : Prashant Jain
 * @last modified on  : 2021-06-10
 * @last modified by  : Prashant Jain
 * Modifications Log 
 * Ver   Date         Author          Modification
 * 1.0   2021-06-10   Prashant Jain   Initial Version
**/

public class sMgetAsvSecurityAndHoldsV1_Resp_IB_v1 extends Base_IB {

    public String status;
    public Integer statusCode;
    public String message;
	/**
 * @description       : Response Integration Bean for sMgetAsvSecurityAndHoldsV1 Service
 * @author            : Prashant Jain
 */
	public class Nbsapdpo {
		public String returnCode;
		public String reasonCode;
		public String serviceVersion;
	}

	public SMgetASVOutstandingSecurityAndHoldsV1Response SMgetASVOutstandingSecurityAndHoldsV1Response;
	/**
 * @description       : Response Integration Bean for sMgetAsvSecurityAndHoldsV1 Service
 * @author            : Prashant Jain
 */
	public class SMgetASVOutstandingSecurityAndHoldsV1Response {
		public Nbsapdpo nbsapdpo;
		public Nbsmsgo3 nbsmsgo3;
		public Smp155eo smp155eo;
	}
/**
 * @description       : Response Integration Bean for sMgetAsvSecurityAndHoldsV1 Service
 * @author            : Prashant Jain
 */
	public class Nbsmsgo3 {
		public String version;
		public String nbrUserMsgs;
		public String nbrUserErrs;
	}
/**
 * @description       : Response Integration Bean for sMgetAsvSecurityAndHoldsV1 Service
 * @author            : Prashant Jain
 */
	public class Smp155eo {
		public String clcd;
		public String outsecInd;
		public String holdInd;
		public String successInd;
		public String osv;
        public String status;
        public String ApplicationId;
	}
}