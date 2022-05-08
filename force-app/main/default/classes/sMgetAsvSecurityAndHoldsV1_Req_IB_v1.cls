/**
 * @description       : Request Integration Bean for sMgetAsvSecurityAndHoldsV1 Service
 * @author            : Prashant Jain
 * @last modified on  : 2021-06-10
 * @last modified by  : Prashant Jain
 * Modifications Log 
 * Ver   Date         Author          Modification
 * 1.0   2020-03-10   Prashant Jain   Initial Version
**/


public class sMgetAsvSecurityAndHoldsV1_Req_IB_v1 extends Base_IB {

	public SMgetASVOutstandingSecurityAndHoldsV1 SMgetASVOutstandingSecurityAndHoldsV1;
    
    /**
 * @description       : Request Integration Bean for sMgetAsvSecurityAndHoldsV1 Service
 * @author            : Prashant Jain
**/
	public class Nbsapdpi {
		public String channel;
		public String application;
		public String trace;
	}

    /**
 * @description       : Request Integration Bean for sMgetAsvSecurityAndHoldsV1 Service
 * @author            : Prashant Jain
**/
	public class SMgetASVOutstandingSecurityAndHoldsV1 {
		public Nbsapdpi nbsapdpi;
		public Nbsmsgi nbsmsgi;
		public Smp155ei smp155ei;
	}
/**
 * @description       : Request Integration Bean for sMgetAsvSecurityAndHoldsV1 Service
 * @author            : Prashant Jain
**/
	public class Smp155ei {
		public String clcd;
	}
/**
 * @description       : Request Integration Bean for sMgetAsvSecurityAndHoldsV1 Service
 * @author            : Prashant Jain
**/
	public class Nbsmsgi {
		public String msgLanguage;
		public String msgTarget;
	}

    /**
    * @description 
    * @author Prashant Jain | 2021-06-10 
    * @return sMgetAsvSecurityAndHoldsV1_Req_IB_v1 
    **/
    public static sMgetAsvSecurityAndHoldsV1_Req_IB_v1 createDummyRequest() {
        sMgetAsvSecurityAndHoldsV1_Req_IB_v1 requestBean = new sMgetAsvSecurityAndHoldsV1_Req_IB_v1();
        
        sMgetAsvSecurityAndHoldsV1_Req_IB_v1.SMgetASVOutstandingSecurityAndHoldsV1 sMgetASVOutstandingSecurityAndHoldsV1 = new sMgetAsvSecurityAndHoldsV1_Req_IB_v1.SMgetASVOutstandingSecurityAndHoldsV1();
		
        sMgetAsvSecurityAndHoldsV1_Req_IB_v1.Nbsapdpi nbsapdpi = new sMgetAsvSecurityAndHoldsV1_Req_IB_v1.Nbsapdpi();
        nbsapdpi.channel = 'BDP';
        nbsapdpi.application = 'BDP';
        nbsapdpi.trace = 'Y';
        
        sMgetAsvSecurityAndHoldsV1_Req_IB_v1.Nbsmsgi nbsmsgi = new sMgetAsvSecurityAndHoldsV1_Req_IB_v1.Nbsmsgi();
        nbsmsgi.msgLanguage = 'E';
        nbsmsgi.msgTarget = 'STD';
        
        sMgetAsvSecurityAndHoldsV1_Req_IB_v1.Smp155ei smp155ei = new sMgetAsvSecurityAndHoldsV1_Req_IB_v1.Smp155ei();
        smp155ei.clcd = 'CLOSE  001';
        
        sMgetASVOutstandingSecurityAndHoldsV1.nbsapdpi = nbsapdpi;
        sMgetASVOutstandingSecurityAndHoldsV1.nbsmsgi = nbsmsgi;
        sMgetASVOutstandingSecurityAndHoldsV1.smp155ei = smp155ei;
        
        requestBean.sMgetASVOutstandingSecurityAndHoldsV1 = sMgetASVOutstandingSecurityAndHoldsV1;
        
        return requestBean;
    }
}