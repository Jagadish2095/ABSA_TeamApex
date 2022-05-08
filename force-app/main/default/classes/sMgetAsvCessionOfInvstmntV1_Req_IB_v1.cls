/**
 * @description       : Integration Bean for sMgetAsvCessionOfInvstmntV1 Service
 * @author            : Prashant Jain
 * @last modified on  : 2021-06-11
 * @last modified by  : Prashant Jain
 * Modifications Log 
 * Ver   Date         Author          Modification
 * 1.0   2020-03-03   Prashant Jain   Initial Version
**/

public class sMgetAsvCessionOfInvstmntV1_Req_IB_v1 extends Base_IB {  
    /** @description : Wrapper class for service */
    public class Smn146i {  
		public String clcdData;
	}
/** @description : Wrapper class for service */
	public class SMgetASVCessionOfInternalInvestmentsV1 {
		public Nbsapdpi nbsapdpi;
		public Nbsmsgi nbsmsgi;
		public Smn146i smn146i;
	}

	public SMgetASVCessionOfInternalInvestmentsV1 SMgetASVCessionOfInternalInvestmentsV1;

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
   

    /**
    * @description : method to create dummy request
    * @author Prashant Jain | 2021-06-11 
    * @return sMgetAsvCessionOfInvstmntV1_Req_IB_v1 
    **/
    public static sMgetAsvCessionOfInvstmntV1_Req_IB_v1 createDummyRequest() {
        
        sMgetAsvCessionOfInvstmntV1_Req_IB_v1 requestBean = new sMgetAsvCessionOfInvstmntV1_Req_IB_v1();
        sMgetAsvCessionOfInvstmntV1_Req_IB_v1.SMgetASVCessionOfInternalInvestmentsV1 sMgetASVCessionOfInternalInvestmentsV1 = new sMgetAsvCessionOfInvstmntV1_Req_IB_v1.SMgetASVCessionOfInternalInvestmentsV1();
		
        sMgetAsvCessionOfInvstmntV1_Req_IB_v1.Nbsapdpi nbsapdpi = new sMgetAsvCessionOfInvstmntV1_Req_IB_v1.Nbsapdpi();
        nbsapdpi.application = 'BDP';
        nbsapdpi.channel = 'BDP';
        nbsapdpi.trace = 'Y';
        
        sMgetAsvCessionOfInvstmntV1_Req_IB_v1.Nbsmsgi nbsmsgi = new sMgetAsvCessionOfInvstmntV1_Req_IB_v1.Nbsmsgi();
        nbsmsgi.msgLanguage = 'E';
        nbsmsgi.msgTarget = 'STD';
        
        
        sMgetAsvCessionOfInvstmntV1_Req_IB_v1.Smn146i smn146i = new sMgetAsvCessionOfInvstmntV1_Req_IB_v1.Smn146i();
        smn146i.clcdData = 'CLOSE  001';
        
        sMgetASVCessionOfInternalInvestmentsV1.nbsapdpi =  nbsapdpi;
        sMgetASVCessionOfInternalInvestmentsV1.nbsmsgi =  nbsmsgi;
        sMgetASVCessionOfInternalInvestmentsV1.smn146i = smn146i;
        
        requestBean.sMgetASVCessionOfInternalInvestmentsV1 = sMgetASVCessionOfInternalInvestmentsV1;
        
        return requestBean;
    }
}