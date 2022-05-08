/**
 * @description       : Response Integration Bean for sMgetAsvCreditLifePoliciesV1 Service
 * @author            : Prashant Jain
 * @last modified on  : 2021-06-10
 * @last modified by  : Prashant Jain
 * Modifications Log 
 * Ver   Date         Author          Modification
 * 1.0   2021-06-10   Prashant Jain   Initial Version
**/


public class sMgetAsvCreditLifePolicyV1_Resp_IB_v1 extends Base_IB {
    
    public String status;
    public Integer statusCode;
    public String message;
    /**
 * @description       : Response Integration Bean for sMgetAsvCreditLifePoliciesV1 Service
 * @author            : Prashant Jain
 * */
    public class Nbsapdpo {
        public String returnCode;
        public String reasonCode;
        public String serviceVersion;
    }
    
    public SMgetASVcreditLifePoliciesV1Response SMgetASVcreditLifePoliciesV1Response;
     /**
 * @description       : Response Integration Bean for sMgetAsvCreditLifePoliciesV1 Service
 * @author            : Prashant Jain
 * */
    public class Nbsmsgo3 {
        public String version;
        public String nbrUserMsgs;
        public String nbrUserErrs;
    }
     /**
 * @description       : Response Integration Bean for sMgetAsvCreditLifePoliciesV1 Service
 * @author            : Prashant Jain
 * */
    public class SMgetASVcreditLifePoliciesV1Response {
        public Nbsapdpo nbsapdpo;
        public Nbsmsgo3 nbsmsgo3;
        public Smn151o smn151o;
    }
     /**
 * @description       : Response Integration Bean for sMgetAsvCreditLifePoliciesV1 Service
 * @author            : Prashant Jain
 * */
    public class Smn151o {
        //public Object tnomVal;
        //public Object tsecVal;
        //public Object tasvVal;
        //public Object tmasvVal;
        public List<ClTable> clTable;
    }
     /**
 * @description       : Response Integration Bean for sMgetAsvCreditLifePoliciesV1 Service
 * @author            : Prashant Jain
 * */
    public class ClTable {
        public String polId;
        public String seqNo;
        public String polType;
        public String polno;
        //public String polamnt;
        public String polamt;
        public String startDate;
        public String renewDate;
        public String refacc;
        public String ApplicationId;
        public String tasvVal;
        public String totmasval;
        public String Status;
        public String assurco;
        public String clcd;
    }
}