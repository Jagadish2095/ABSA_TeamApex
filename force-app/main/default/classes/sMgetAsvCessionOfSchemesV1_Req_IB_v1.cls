/**
 * @description       : Request Integration Bean for sMgetAsvCessionOfSchemesV1 Service
 * @author            : Prashant Jain
 * @last modified on  : 2021-06-11
 * @last modified by  : Prashant Jain
 * Modifications Log 
 * Ver   Date         Author          Modification
 * 1.0   2021-06-11   Prashant Jain   Initial Version
**/

public class sMgetAsvCessionOfSchemesV1_Req_IB_v1 extends Base_IB {
    /**
 * @description       : Request Integration Bean for sMgetAsvCessionOfSchemesV1 Service*/
	public class SMgetASVCessionOfSchemesV1 {
		public Nbsapdpi nbsapdpi;
		public Nbsmsgi nbsmsgi;
		public Smp135ei smp135ei;
	}
    /**
 * @description       : Request Integration Bean for sMgetAsvCessionOfSchemesV1 Service*/
	public class Smp135ei {
		public String clcdData;
	}
    /**
 * @description       : Request Integration Bean for sMgetAsvCessionOfSchemesV1 Service*/
	public SMgetASVCessionOfSchemesV1 SMgetASVCessionOfSchemesV1;
    /**
 * @description       : Request Integration Bean for sMgetAsvCessionOfSchemesV1 Service*/
	public class Nbsapdpi {
		public String channel;
		public String application;
		public String trace;
	}
/**
 * @description       : Request Integration Bean for sMgetAsvCessionOfSchemesV1 Service*/
	public class Nbsmsgi {
		public String msgLanguage;
		public String msgTarget;
	}

    /**
    * @description 
    * @author Prashant Jain | 2021-06-11 
    * @return sMgetAsvCessionOfSchemesV1_Req_IB_v1 
    **/
    public static sMgetAsvCessionOfSchemesV1_Req_IB_v1 createDummyRequest() {
        sMgetAsvCessionOfSchemesV1_Req_IB_v1 requestBean = new sMgetAsvCessionOfSchemesV1_Req_IB_v1();
        sMgetAsvCessionOfSchemesV1_Req_IB_v1.SMgetASVCessionOfSchemesV1 sMgetASVCessionOfSchemesV1 = new sMgetAsvCessionOfSchemesV1_Req_IB_v1.SMgetASVCessionOfSchemesV1();
        sMgetAsvCessionOfSchemesV1_Req_IB_v1.Nbsapdpi nbsapdpi = new sMgetAsvCessionOfSchemesV1_Req_IB_v1.Nbsapdpi();
        nbsapdpi.channel = 'BDP';
        nbsapdpi.application = 'BDP';
        nbsapdpi.trace = 'Y';
        sMgetAsvCessionOfSchemesV1_Req_IB_v1.Nbsmsgi nbsmsgi = new sMgetAsvCessionOfSchemesV1_Req_IB_v1.Nbsmsgi();
        nbsmsgi.msgLanguage = 'E';
        nbsmsgi.msgTarget = 'STD';
        sMgetAsvCessionOfSchemesV1_Req_IB_v1.Smp135ei smp135ei = new sMgetAsvCessionOfSchemesV1_Req_IB_v1.Smp135ei();
        smp135ei.clcdData = 'CLOSE  001';
	
        sMgetASVCessionOfSchemesV1.nbsapdpi = nbsapdpi;
        sMgetASVCessionOfSchemesV1.nbsmsgi = nbsmsgi;
        sMgetASVCessionOfSchemesV1.smp135ei = smp135ei;
        requestBean.SMgetASVCessionOfSchemesV1 = sMgetASVCessionOfSchemesV1;
        return requestBean;
    }
}