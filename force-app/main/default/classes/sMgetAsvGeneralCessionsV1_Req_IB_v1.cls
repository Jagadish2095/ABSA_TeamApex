/**
 * @description       : Request Integration Bean for sMgetAsvGeneralCessionsV1 Service
 * @author            : Prashant Jain
 * @last modified on  : 2021-06-11
 * @last modified by  : Prashant Jain
 * Modifications Log 
 * Ver   Date         Author          Modification
 * 1.0   2021-06-11   Prashant Jain   Initial Version
**/

public class sMgetAsvGeneralCessionsV1_Req_IB_v1 extends Base_IB {
	public SMgetASVGeneralCessionsV1 SMgetASVGeneralCessionsV1;
/** @description : Wrapper class for service */
	public class FinalMsgId {
		public String finalMsgClass;
		public String finalMsgCode;
	}
/** @description : Wrapper class for service */
	public class SMgetASVGeneralCessionsV1 {
		public Nbsapdpi nbsapdpi;
		public Nbsmsgi nbsmsgi;
		public Sms148i sms148i;
	}
/** @description : Wrapper class for service */
	public class Nbsapdpi {
		public String channel;
		public String application;
		public String trace;
	}
/** @description : Wrapper class for service */
	public class Sms148i {
		public String clcd;
	}
/** @description : Wrapper class for service */
	public class Nbsmsgi {
		public String msgLanguage; 
		public String msgTarget;
		public FinalMsgId finalMsgId;
	}
    
    /**
    * @description Create Dummy method
    * @author Prashant Jain | 2021-06-11 
    * @return sMgetAsvGeneralCessionsV1_Req_IB_v1 
    **/
    public static sMgetAsvGeneralCessionsV1_Req_IB_v1 createDummyRequest(){
        sMgetAsvGeneralCessionsV1_Req_IB_v1 requestBean = new sMgetAsvGeneralCessionsV1_Req_IB_v1();
        sMgetAsvGeneralCessionsV1_Req_IB_v1.SMgetASVGeneralCessionsV1 sMgetASVGeneralCessionsV1 = new sMgetAsvGeneralCessionsV1_Req_IB_v1.SMgetASVGeneralCessionsV1();
        sMgetAsvGeneralCessionsV1_Req_IB_v1.Nbsapdpi nbsapdpi = new sMgetAsvGeneralCessionsV1_Req_IB_v1.Nbsapdpi();
        nbsapdpi.channel = 'BDP';
        nbsapdpi.application = 'BDP';
        nbsapdpi.trace = 'Y';
        
        sMgetAsvGeneralCessionsV1_Req_IB_v1.Nbsmsgi nbsmsgi = new sMgetAsvGeneralCessionsV1_Req_IB_v1.Nbsmsgi();
        sMgetAsvGeneralCessionsV1_Req_IB_v1.FinalMsgId FinalMsgId = new sMgetAsvGeneralCessionsV1_Req_IB_v1.FinalMsgId();
        FinalMsgId.finalMsgClass  = '';
        FinalMsgId.finalMsgCode = '';
        nbsmsgi.msgLanguage = 'E';
        nbsmsgi.msgTarget = 'STD';
        nbsmsgi.finalMsgId  = FinalMsgId;
        sMgetAsvGeneralCessionsV1_Req_IB_v1.Sms148i sms148i = new sMgetAsvGeneralCessionsV1_Req_IB_v1.Sms148i();
        sms148i.clcd = 'BABICK 001';
        SMgetASVGeneralCessionsV1.nbsapdpi = nbsapdpi;
        SMgetASVGeneralCessionsV1.nbsmsgi = nbsmsgi;
        SMgetASVGeneralCessionsV1.sms148i = sms148i;
        requestBean.SMgetASVGeneralCessionsV1 =  SMgetASVGeneralCessionsV1;
        return requestBean;
    }
}