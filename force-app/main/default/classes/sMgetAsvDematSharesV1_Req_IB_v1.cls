/**
 * @description       : Request Integration Bean for sMgetAsvDematSharesV1 Service
 * @author            : Prashant Jain
 * @last modified on  : 2021-06-11
 * @last modified by  : Prashant Jain
 * Modifications Log 
 * Ver   Date         Author          Modification
 * 1.0   2021-06-11   Prashant Jain   Initial Version
**/

public class sMgetAsvDematSharesV1_Req_IB_v1 extends Base_IB {
/** @description : Wrapper class for service */
	public class SMgetASVDematerializedSharesV1 {
		public Nbsapdpi nbsapdpi;
		public Nbsmsgi nbsmsgi;
		public Smn336i smn336i;
	}

	public SMgetASVDematerializedSharesV1 SMgetASVDematerializedSharesV1;
/** @description : Wrapper class for service */
	public class Nbsapdpi {
		public String channel;
		public String application;
		public String trace;
	}
/** @description : Wrapper class for service */
	public class Smn336i {
		public String clcd;
	}
/** @description : Wrapper class for service */
	public class Nbsmsgi {
		public String msgLanguage;
		public String msgTarget;
	}

    /**
    * @description Method to create dummy request
    * @author Prashant Jain | 2021-06-11 
    * @return sMgetAsvDematSharesV1_Req_IB_v1 
    **/
    public static sMgetAsvDematSharesV1_Req_IB_v1 createDummyRequest() {
        sMgetAsvDematSharesV1_Req_IB_v1 requestBean = new sMgetAsvDematSharesV1_Req_IB_v1();
        sMgetAsvDematSharesV1_Req_IB_v1.SMgetASVDematerializedSharesV1 sMgetASVDematerializedSharesV1 = new  sMgetAsvDematSharesV1_Req_IB_v1.SMgetASVDematerializedSharesV1();
		sMgetAsvDematSharesV1_Req_IB_v1.Nbsapdpi nbsapdpi = new sMgetAsvDematSharesV1_Req_IB_v1.Nbsapdpi();
        nbsapdpi.channel = 'BDP';
        nbsapdpi.application = 'BDP';
        nbsapdpi.trace = 'Y';
        
        sMgetAsvDematSharesV1_Req_IB_v1.Nbsmsgi nbsmsgi = new sMgetAsvDematSharesV1_Req_IB_v1.Nbsmsgi();
        nbsmsgi.msgLanguage = 'E';
        nbsmsgi.msgTarget = 'STD';
        
        sMgetAsvDematSharesV1_Req_IB_v1.Smn336i smn336i = new sMgetAsvDematSharesV1_Req_IB_v1.Smn336i();
        smn336i.clcd = 'CLOSE  001';
        
        sMgetASVDematerializedSharesV1.nbsapdpi = nbsapdpi;
        sMgetASVDematerializedSharesV1.nbsmsgi = nbsmsgi;
        sMgetASVDematerializedSharesV1.smn336i = smn336i;
        requestBean.SMgetASVDematerializedSharesV1 = SMgetASVDematerializedSharesV1;
        
  
        return requestBean;
    }
}