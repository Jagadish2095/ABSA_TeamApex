/**
 * @description       : Request Integration Bean for sMgetAsvCreditLifePolicyV1 Service
 * @author            : Prashant Jain
 * @last modified on  : 2021-06-10
 * @last modified by  : Prashant Jain
 * Modifications Log 
 * Ver   Date         Author          Modification
 * 1.0   2021-06-10   Prashant Jain   Initial Version
**/


public class sMgetAsvCreditLifePolicyV1_Req_IB_v1 extends Base_IB {
     /**
 * @description       : Request Integration Bean for sMgetAsvCreditLifePolicyV1 Service
 * @author            : Prashant Jain
 * */
	public class SMgetASVcreditLifePoliciesV1 {
		public Nbsapdpi nbsapdpi;
		public Nbsmsgi nbsmsgi;
		public Smn151i smn151i;
	}

	public SMgetASVcreditLifePoliciesV1 SMgetASVcreditLifePoliciesV1;
    /**
 * @description       : Request Integration Bean for sMgetAsvCreditLifePolicyV1 Service
 * @author            : Prashant Jain
 * */
	public class Nbsapdpi {
		public String channel;
		public String application;
		public String trace;
	}
    /**
 * @description       : Request Integration Bean for sMgetAsvCreditLifePolicyV1 Service
 * @author            : Prashant Jain
 * */
	public class Smn151i {
		public String clcd;
	}
    /**
 * @description       : Request Integration Bean for sMgetAsvCreditLifePolicyV1 Service
 * @author            : Prashant Jain
 * */
	public class Nbsmsgi {
		public String msgLanguage;
		public String msgTarget;
	}
    /**
    * @description 
    * @author Prashant Jain | 2021-06-10 
    * @return sMgetAsvCreditLifePolicyV1_Req_IB_v1 
    **/
    public static sMgetAsvCreditLifePolicyV1_Req_IB_v1 createDummyRequest() {
        sMgetAsvCreditLifePolicyV1_Req_IB_v1 requestBean = new sMgetAsvCreditLifePolicyV1_Req_IB_v1();
        sMgetAsvCreditLifePolicyV1_Req_IB_v1.SMgetASVcreditLifePoliciesV1 sMgetASVcreditLifePoliciesV1 = new sMgetAsvCreditLifePolicyV1_Req_IB_v1.SMgetASVcreditLifePoliciesV1();
        sMgetAsvCreditLifePolicyV1_Req_IB_v1.Nbsapdpi nbsapdpi = new sMgetAsvCreditLifePolicyV1_Req_IB_v1.Nbsapdpi();
        nbsapdpi.channel = 'BDP';
        nbsapdpi.application = 'BDP';
        nbsapdpi.trace = 'Y';
        sMgetAsvCreditLifePolicyV1_Req_IB_v1.Nbsmsgi nbsmsgi = new sMgetAsvCreditLifePolicyV1_Req_IB_v1.Nbsmsgi();
        nbsmsgi.msgLanguage = 'E';
        nbsmsgi.msgTarget = 'STD';
        sMgetAsvCreditLifePolicyV1_Req_IB_v1.Smn151i smn151i = new sMgetAsvCreditLifePolicyV1_Req_IB_v1.Smn151i();
        smn151i.clcd = 'CLOSE  001';
        sMgetASVcreditLifePoliciesV1.nbsapdpi = nbsapdpi;
        sMgetASVcreditLifePoliciesV1.nbsmsgi = nbsmsgi;
        sMgetASVcreditLifePoliciesV1.smn151i = smn151i;
        requestBean.SMgetASVcreditLifePoliciesV1 = sMgetASVcreditLifePoliciesV1;
        
        return requestBean;
    }
}