/**
 * @description       : Request Integration Bean for sMgetAsvCessionOfLPNoLinkV1 Service
 * @author            : Prashant Jain
 * @last modified on  : 2021-06-11
 * @last modified by  : Prashant Jain
 * Modifications Log 
 * Ver   Date         Author          Modification
 * 1.0   2021-06-11   Prashant Jain   Initial Version
**/


public class sMgetAsvCessionOfLPNoLinkV1_Req_IB_v1 extends Base_IB {

	public SMgetASVCessionOfLifePoliciesNonLinkV1 SMgetASVCessionOfLifePoliciesNonLinkV1;
/** @description : Wrapper class for service */
	public class SMgetASVCessionOfLifePoliciesNonLinkV1 {
		public Nbsapdpi nbsapdpi;
		public Nbsmsgi nbsmsgi;
		public Smp232ei smp232ei;
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
	}
/** @description : Wrapper class for service */
	public class Smp232ei {
		public String clcdData;
	}

    /**
    * @description Method to create dummy request
    * @author Prashant Jain | 2021-06-11 
    * @return sMgetAsvCessionOfLPNoLinkV1_Req_IB_v1 
    **/
    public static sMgetAsvCessionOfLPNoLinkV1_Req_IB_v1 createDummyRequest() {
        
        sMgetAsvCessionOfLPNoLinkV1_Req_IB_v1 requestBean = new sMgetAsvCessionOfLPNoLinkV1_Req_IB_v1();
        
        sMgetAsvCessionOfLPNoLinkV1_Req_IB_v1.SMgetASVCessionOfLifePoliciesNonLinkV1 sMgetASVCessionOfLifePoliciesNonLinkV1 = new sMgetAsvCessionOfLPNoLinkV1_Req_IB_v1.SMgetASVCessionOfLifePoliciesNonLinkV1();
        
        sMgetAsvCessionOfLPNoLinkV1_Req_IB_v1.Nbsapdpi nbsapdpi = new sMgetAsvCessionOfLPNoLinkV1_Req_IB_v1.Nbsapdpi();
        nbsapdpi.application = 'DBP';
        nbsapdpi.channel = 'BDP';
        nbsapdpi.trace = 'Y';
        
        sMgetAsvCessionOfLPNoLinkV1_Req_IB_v1.Nbsmsgi nbsmsgi =  new sMgetAsvCessionOfLPNoLinkV1_Req_IB_v1.Nbsmsgi();
        nbsmsgi.msgLanguage = 'E';
        nbsmsgi.msgTarget = 'STD';
        
        sMgetAsvCessionOfLPNoLinkV1_Req_IB_v1.Smp232ei smp232ei = new sMgetAsvCessionOfLPNoLinkV1_Req_IB_v1.Smp232ei();
        smp232ei.clcdData = 'CLOSE  001';
        
        sMgetASVCessionOfLifePoliciesNonLinkV1.nbsapdpi = nbsapdpi;
        sMgetASVCessionOfLifePoliciesNonLinkV1.nbsmsgi = nbsmsgi;
        sMgetASVCessionOfLifePoliciesNonLinkV1.smp232ei = smp232ei;
        requestBean.SMgetASVCessionOfLifePoliciesNonLinkV1 = sMgetASVCessionOfLifePoliciesNonLinkV1;
        return requestBean;
    }
    
   
}