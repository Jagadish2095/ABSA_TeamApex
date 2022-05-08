/**
 * @description       : Request Integration Bean for sMgetAsvCessionOfLPLinkedV1 Service
 * @author            : Prashant Jain
 * @last modified on  : 2021-06-11
 * @last modified by  : Prashant Jain
 * Modifications Log 
 * Ver   Date         Author          Modification
 * 1.0   2021-06-11   Prashant Jain   Initial Version
**/

public class sMgetAsvCessionOfLPLinkedV1_Req_IB_v1 extends Base_IB {
/** @description : Wrapper class for service */
	public class SMgetASVCessionOfLifePoliciesLinkedV1 {
	public Smp332ei smp332ei;
    public Nbsapdpi nbsapdpi;
    public Nbsmsgi nbsmsgi;
    }
    public SMgetASVCessionOfLifePoliciesLinkedV1 SMgetASVCessionOfLifePoliciesLinkedV1;
/** @description : Wrapper class for service */
	public class Smp332ei {
		public String clcdData;
	}
	/** @description : Wrapper class for service */
    public class FinalMsgId {
		public String finalMsgClass;
		public String finalMsgCode;
	}
/** @description : Wrapper class for service */
	public class Nbsapdpi {
		public String channel;
		public String application;
		public String trace;
	}
	/** @description : Wrapper class for service */
    public class Nbsmsgi {
		public String msgLanguage;
		public String msgTarget;
		public FinalMsgId finalMsgId;
	}

    /**
    * @description :method to create dummy request
    * @author Prashant Jain | 2021-06-11 
    * @return sMgetAsvCessionOfLPLinkedV1_Req_IB_v1 
    **/
    public static sMgetAsvCessionOfLPLinkedV1_Req_IB_v1 createDummyRequest() {
        sMgetAsvCessionOfLPLinkedV1_Req_IB_v1 requestBean = new sMgetAsvCessionOfLPLinkedV1_Req_IB_v1();
		//requestBean.smp332ei = new sMgetAsvCessionOfLPLinkedV1_Req_IB_v1.Smp332ei();
		
		//requestBean.smp332ei.clcdData = 'CLOSE  001';
		requestBean.SMgetASVCessionOfLifePoliciesLinkedV1=new sMgetAsvCessionOfLPLinkedV1_Req_IB_v1.SMgetASVCessionOfLifePoliciesLinkedV1();
        requestBean.SMgetASVCessionOfLifePoliciesLinkedV1.Smp332ei=new sMgetAsvCessionOfLPLinkedV1_Req_IB_v1.Smp332ei();
		requestBean.SMgetASVCessionOfLifePoliciesLinkedV1.Smp332ei.clcdData='CLOSE  001';

        return requestBean;
    }
}