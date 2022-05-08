/**
 * @description       : Request Integration Bean for sMgetAsvCessionOfSharesV1 Service
 * @author            : Prashant Jain
 * @last modified on  : 2021-06-11
 * @last modified by  : Prashant Jain
 * Modifications Log 
 * Ver   Date         Author          Modification
 * 1.0   2021-06-11   Prashant Jain   Initial Version
**/

public class sMgetAsvCessionOfSharesV1_Req_IB_v1 extends Base_IB {

	public SMgetASVCessionOfSharesV1 SMgetASVCessionOfSharesV1;
/** @description : Wrapper class for service */
	public class Nbsapdpi {
		public String channel;
		public String application;
		public String trace;
	}
/** @description : Wrapper class for service */
	public class SMgetASVCessionOfSharesV1 {
		public Nbsapdpi nbsapdpi;
		public Nbsmsgi nbsmsgi;
		public Sms136i sms136i;
	}
/** @description : Wrapper class for service */
	public class Nbsmsgi {
		public String msgLanguage;
		public String msgTarget;
	}
/** @description : Wrapper class for service */
	public class Sms136i {
		public String clcd;
	}

    /**
    * @description method to create dummy request
    * @author Prashant Jain | 2021-06-11 
    * @return sMgetAsvCessionOfSharesV1_Req_IB_v1 
    **/
    public static sMgetAsvCessionOfSharesV1_Req_IB_v1 createDummyRequest() {
        
        sMgetAsvCessionOfSharesV1_Req_IB_v1 requestBean = new sMgetAsvCessionOfSharesV1_Req_IB_v1();
        sMgetAsvCessionOfSharesV1_Req_IB_v1.SMgetASVCessionOfSharesV1 sMgetASVCessionOfSharesV1 = new sMgetAsvCessionOfSharesV1_Req_IB_v1.SMgetASVCessionOfSharesV1();
        
        sMgetAsvCessionOfSharesV1_Req_IB_v1.Nbsapdpi nbsapdpi = new sMgetAsvCessionOfSharesV1_Req_IB_v1.Nbsapdpi();
        nbsapdpi.channel = 'BDP';
        nbsapdpi.application = 'BDP';
        nbsapdpi.trace = 'Y';
        
        sMgetAsvCessionOfSharesV1_Req_IB_v1.Nbsmsgi nbsmsgi = new sMgetAsvCessionOfSharesV1_Req_IB_v1.Nbsmsgi();
        nbsmsgi.msgLanguage = 'E';
        nbsmsgi.msgTarget = 'STD';
        
        sMgetAsvCessionOfSharesV1_Req_IB_v1.Sms136i sms136i = new sMgetAsvCessionOfSharesV1_Req_IB_v1.Sms136i();
        sms136i.clcd = 'CLOSE  001';
        
        sMgetASVCessionOfSharesV1.nbsapdpi = nbsapdpi;
        sMgetASVCessionOfSharesV1.nbsmsgi = nbsmsgi;
        sMgetASVCessionOfSharesV1.sms136i = sms136i;
        requestBean.sMgetASVCessionOfSharesV1 = sMgetASVCessionOfSharesV1;
		//requestBean.sms136i = new sMgetAsvCessionOfSharesV1_Req_IB_v1.Sms136i();
		
		//requestBean.sms136i.clcd = 'CLOSE  001';

        return requestBean;
    }
}