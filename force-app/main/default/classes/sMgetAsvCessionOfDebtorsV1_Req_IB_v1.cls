/**
 * @description       : Request Integration Bean for sMgetAsvCessionOfDebtorsV1 Service
 * @author            : Prashant Jain
 * @last modified on  : 2021-06-11
 * @last modified by  : Prashant Jain
 * Modifications Log 
 * Ver   Date         Author          Modification
 * 1.0   2021-06-11   Prashant Jain   Initial Version
**/


public class sMgetAsvCessionOfDebtorsV1_Req_IB_v1 extends Base_IB {

	public SMgetASVCessionOfDebtorsV1 SMgetASVCessionOfDebtorsV1;
/** @description : Wrapper class */
	public class Nbsapdpi {
		public String channel;
		public String application;
		public String trace;
	}
/** @description : Wrapper class */
	public class SMgetASVCessionOfDebtorsV1 {
		public Nbsapdpi nbsapdpi;
		public Nbsmsgi nbsmsgi;
		public Smp170ei smp170ei;
	}
/** @description : Wrapper class */
	public class Smp170ei {
		public String clcdData;
	}
/** @description : Wrapper class */
	public class Nbsmsgi {
		public String msgLanguage;
		public String msgTarget;
	}

    /**
    * @description createDummyRequest
    * @author Prashant Jain | 2021-06-11 
    * @return sMgetAsvCessionOfDebtorsV1_Req_IB_v1 
    **/
    public static sMgetAsvCessionOfDebtorsV1_Req_IB_v1 createDummyRequest() {
        sMgetAsvCessionOfDebtorsV1_Req_IB_v1 requestBean = new sMgetAsvCessionOfDebtorsV1_Req_IB_v1();
        
        sMgetAsvCessionOfDebtorsV1_Req_IB_v1.SMgetASVCessionOfDebtorsV1 request = new sMgetAsvCessionOfDebtorsV1_Req_IB_v1.SMgetASVCessionOfDebtorsV1();
        
        sMgetAsvCessionOfDebtorsV1_Req_IB_v1.Nbsapdpi nbsapdpi = new sMgetAsvCessionOfDebtorsV1_Req_IB_v1.Nbsapdpi();
        
        nbsapdpi.channel = 'BDP';
        nbsapdpi.application = 'BDP';
        nbsapdpi.trace = 'Y';
        
        sMgetAsvCessionOfDebtorsV1_Req_IB_v1.Nbsmsgi  nbsmsgi = new sMgetAsvCessionOfDebtorsV1_Req_IB_v1.Nbsmsgi();
        nbsmsgi.msgLanguage = 'E';
        nbsmsgi.msgTarget = 'STD';
        
        sMgetAsvCessionOfDebtorsV1_Req_IB_v1.Smp170ei smp170ei = new sMgetAsvCessionOfDebtorsV1_Req_IB_v1.Smp170ei();
        smp170ei.clcdData = 'CLOSE  001';
        
        request.nbsapdpi = nbsapdpi;
        request.nbsmsgi = nbsmsgi;
        request.smp170ei = smp170ei;
		
        requestBean.sMgetASVCessionOfDebtorsV1 = request;

        return requestBean;
    }
}