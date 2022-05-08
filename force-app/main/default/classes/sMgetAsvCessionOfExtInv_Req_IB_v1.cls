/**
 * @description       : Request Integration Bean for SMgetASVCessionOfExternalInvestmentsV1 Service
 * @author            : Muvhuso Nelhubvi
 * @last modified on  : 2021-06-11
 * @last modified by  : Prashant Jain
 * Modifications Log 
 * Ver   Date         Author          Modification
 * 1.0   2020-03-21  Muvhuso Nelhubvi  Initial Version
**/

public class sMgetAsvCessionOfExtInv_Req_IB_v1 extends Base_IB {
	/** @description : Wrapper class for service */
	public class Smp147ei {
		public String clcdData;
	}
/** @description : Wrapper class for service */
	public class SMgetASVCessionOfExternalInvestmentsV1 {
		public Nbsapdpi nbsapdpi;
		public Nbsmsgi nbsmsgi;
		public Smp147ei smp147ei;
	}

	public SMgetASVCessionOfExternalInvestmentsV1 SMgetASVCessionOfExternalInvestmentsV1;
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
    * @description dummy request creation method
    * @author Prashant Jain | 2021-06-11 
    * @return sMgetAsvCessionOfExtInv_Req_IB_v1 
    **/
    public static sMgetAsvCessionOfExtInv_Req_IB_v1 createDummyRequest(){
        sMgetAsvCessionOfExtInv_Req_IB_v1 requestBean = new sMgetAsvCessionOfExtInv_Req_IB_v1();
        sMgetAsvCessionOfExtInv_Req_IB_v1.SMgetASVCessionOfExternalInvestmentsV1 sMgetASVCessionOfExternalInvestmentsV1 = new sMgetAsvCessionOfExtInv_Req_IB_v1.SMgetASVCessionOfExternalInvestmentsV1();
        
        sMgetAsvCessionOfExtInv_Req_IB_v1.Nbsapdpi nbsapdpi = new sMgetAsvCessionOfExtInv_Req_IB_v1.Nbsapdpi();
        nbsapdpi.channel = 'BDP';
        nbsapdpi.application = 'BDP';
        nbsapdpi.trace = 'Y';
        
        sMgetAsvCessionOfExtInv_Req_IB_v1.FinalMsgId finalMsgId = new sMgetAsvCessionOfExtInv_Req_IB_v1.FinalMsgId(); 
        finalMsgId.finalMsgClass = '';
        finalMsgId.finalMsgCode = '';
        
        sMgetAsvCessionOfExtInv_Req_IB_v1.Nbsmsgi nbsmsgi = new sMgetAsvCessionOfExtInv_Req_IB_v1.Nbsmsgi();
        nbsmsgi.msgLanguage = 'E';
        nbsmsgi.msgTarget = 'STD';
        nbsmsgi.finalMsgId = finalMsgId;
        
        sMgetAsvCessionOfExtInv_Req_IB_v1.Smp147ei smp147ei = new sMgetAsvCessionOfExtInv_Req_IB_v1.Smp147ei();
        smp147ei.clcdData = 'BABICK 001';
        
        sMgetASVCessionOfExternalInvestmentsV1.nbsapdpi = nbsapdpi;
        sMgetASVCessionOfExternalInvestmentsV1.nbsmsgi = nbsmsgi;
        sMgetASVCessionOfExternalInvestmentsV1.smp147ei = smp147ei;
        
        requestBean.SMgetASVCessionOfExternalInvestmentsV1 = sMgetASVCessionOfExternalInvestmentsV1;
        
        return requestBean;
    }
}