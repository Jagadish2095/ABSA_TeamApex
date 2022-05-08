/**
 * @description       : Request Integration Bean for SMgetASVCessionOfFireShortTermInsuranceV1Response Service
 * @author            : Prashant Jain
 * @last modified on  : 2021-06-10
 * @last modified by  : Prashant Jain
 * Modifications Log 
 * Ver   Date         Author          Modification
 * 1.0   2021-06-10   Prashant Jain   Initial Version
**/


public class SMgetASVCessionOfFireShortV1_Req_IB_v1 extends Base_IB {
	public SMgetASVCessionOfFireShortTermInsuranceV1 SMgetASVCessionOfFireShortTermInsuranceV1;
    /**
 * @description       : Request Integration Bean for SMgetASVCessionOfFireShortTermInsuranceV1Response Service
 * @author            : Prashant Jain
 * */
	public class FinalMsgId {
		public String finalMsgClass;
		public String finalMsgCode;
	}
    /**
 * @description       : Request Integration Bean for SMgetASVCessionOfFireShortTermInsuranceV1Response Service
 * @author            : Prashant Jain
 * */
	public class SMgetASVCessionOfFireShortTermInsuranceV1 {
		public Nbsapdpi nbsapdpi;
		public Nbsmsgi nbsmsgi;
		public Smp132ei smp132ei;
	}
/**
 * @description       : Request Integration Bean for SMgetASVCessionOfFireShortTermInsuranceV1Response Service
 * @author            : Prashant Jain
 * */
	public class Nbsapdpi {
		public String channel;
		public String application;
		public String trace;
	}
/**
 * @description       : Request Integration Bean for SMgetASVCessionOfFireShortTermInsuranceV1Response Service
 * @author            : Prashant Jain
 * */
	public class Smp132ei {
		public String clcdData;
	}
/**
 * @description       : Request Integration Bean for SMgetASVCessionOfFireShortTermInsuranceV1Response Service
 * @author            : Prashant Jain
 * */
	public class Nbsmsgi {
		public String msgLanguage;
		public String msgTarget;
		public FinalMsgId finalMsgId;
	}
    
    /**
    * @description 
    * @author Prashant Jain | 2021-06-10 
    * @return SMgetASVCessionOfFireShortV1_Req_IB_v1 
    **/
    public static SMgetASVCessionOfFireShortV1_Req_IB_v1 createDummyRequest(){
        SMgetASVCessionOfFireShortV1_Req_IB_v1 requestBean = new SMgetASVCessionOfFireShortV1_Req_IB_v1();
        
        SMgetASVCessionOfFireShortV1_Req_IB_v1.SMgetASVCessionOfFireShortTermInsuranceV1 sMgetASVCessionOfFireShortTermInsuranceV1 = new SMgetASVCessionOfFireShortV1_Req_IB_v1.SMgetASVCessionOfFireShortTermInsuranceV1();
        
        SMgetASVCessionOfFireShortV1_Req_IB_v1.Nbsapdpi nbsapdpi = new SMgetASVCessionOfFireShortV1_Req_IB_v1.Nbsapdpi();
        nbsapdpi.channel = 'BDP';
        nbsapdpi.application = 'BDP';
        nbsapdpi.trace = 'Y';
        
        SMgetASVCessionOfFireShortV1_Req_IB_v1.Nbsmsgi nbsmsgi = new SMgetASVCessionOfFireShortV1_Req_IB_v1.Nbsmsgi();
        nbsmsgi.msgLanguage = 'E';
        nbsmsgi.msgTarget = 'STD';
        
        SMgetASVCessionOfFireShortV1_Req_IB_v1.FinalMsgId finalMsgId = new SMgetASVCessionOfFireShortV1_Req_IB_v1.FinalMsgId();
        finalMsgId.finalMsgClass = '';
        finalMsgId.finalMsgCode = '';
        
        SMgetASVCessionOfFireShortV1_Req_IB_v1.Smp132ei smp132ei = new SMgetASVCessionOfFireShortV1_Req_IB_v1.Smp132ei();
        smp132ei.clcdData = 'BABICK 001';
        
        sMgetASVCessionOfFireShortTermInsuranceV1.nbsapdpi = nbsapdpi;
        sMgetASVCessionOfFireShortTermInsuranceV1.nbsmsgi = nbsmsgi;
        sMgetASVCessionOfFireShortTermInsuranceV1.smp132ei = smp132ei;
        
        requestBean.sMgetASVCessionOfFireShortTermInsuranceV1 = sMgetASVCessionOfFireShortTermInsuranceV1;

        return requestBean;
    }
}