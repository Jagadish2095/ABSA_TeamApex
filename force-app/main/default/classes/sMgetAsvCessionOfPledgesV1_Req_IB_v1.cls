/**
 * @description       : Request Integration Bean for sMgetAsvCessionOfPledgesV1 Service
 * @author            : Prashant Jain
 * @last modified on  : 2021-06-11
 * @last modified by  : Prashant Jain
 * Modifications Log 
 * Ver   Date         Author          Modification
 * 1.0   2021-06-11   Prashant Jain   Initial Version
**/


public class sMgetAsvCessionOfPledgesV1_Req_IB_v1 extends Base_IB {

	public SMgetASVCessionOfGeneralPledgesV1 SMgetASVCessionOfGeneralPledgesV1;
/** @description : Wrapper class for service */
	public class Smp149ei {
		public String clcdData;
	}
/** @description : Wrapper class for service */
	public class SMgetASVCessionOfGeneralPledgesV1 {
		public Nbsapdpi nbsapdpi;
		public Nbsmsgi nbsmsgi;
		public Smp149ei smp149ei;
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
    /**
    * @description Method to create dummy request
    * @author Prashant Jain | 2021-06-11 
    * @return sMgetAsvCessionOfPledgesV1_Req_IB_v1 
    **/
    public static sMgetAsvCessionOfPledgesV1_Req_IB_v1 createDummyRequest() {
        
        sMgetAsvCessionOfPledgesV1_Req_IB_v1 requestBean = new sMgetAsvCessionOfPledgesV1_Req_IB_v1();
        
        sMgetAsvCessionOfPledgesV1_Req_IB_v1.SMgetASVCessionOfGeneralPledgesV1 sMgetASVCessionOfGeneralPledgesV1 = new sMgetAsvCessionOfPledgesV1_Req_IB_v1.SMgetASVCessionOfGeneralPledgesV1();
        
        sMgetAsvCessionOfPledgesV1_Req_IB_v1.Nbsapdpi nbsapdpi = new sMgetAsvCessionOfPledgesV1_Req_IB_v1.Nbsapdpi();
        nbsapdpi.channel = 'BDP';
        nbsapdpi.application = 'BDP';
        nbsapdpi.trace = 'Y';
        
        sMgetAsvCessionOfPledgesV1_Req_IB_v1.Nbsmsgi nbsmsgi = new sMgetAsvCessionOfPledgesV1_Req_IB_v1.Nbsmsgi();
        nbsmsgi.msgLanguage = 'E';
        nbsmsgi.msgTarget = 'STD';
        
        sMgetAsvCessionOfPledgesV1_Req_IB_v1.Smp149ei Smp149ei = new sMgetAsvCessionOfPledgesV1_Req_IB_v1.Smp149ei();
        Smp149ei.clcdData = 'CLOSE  001';
        
        sMgetASVCessionOfGeneralPledgesV1.nbsapdpi = nbsapdpi;
        sMgetASVCessionOfGeneralPledgesV1.nbsmsgi = nbsmsgi;
        sMgetASVCessionOfGeneralPledgesV1.smp149ei = smp149ei;
        
        requestBean.SMgetASVCessionOfGeneralPledgesV1 = sMgetASVCessionOfGeneralPledgesV1;
		//requestBean.smp149ei = new sMgetAsvCessionOfPledgesV1_Req_IB_v1.Smp149ei();
		
		//requestBean.smp149ei.clcdData = 'CLOSE  001';

        return requestBean;
    }
}