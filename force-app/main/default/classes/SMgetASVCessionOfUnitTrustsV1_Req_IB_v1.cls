/**
 * @description       : Request Integration Bean for SMgetASVCessionOfUnitTrustsV1 Service
 * @author            : Gulafsha
 * @last modified on  : 2021-06-11
 * Modifications Log 
 * Ver   Date         Author          Modification
 * 1.0   2021-06-11   Gulafsha   Initial Version
**/

/*
 * Request Integration Bean for SMgetASVCessionOfUnitTrustsV1 Service
 * @author Gulafsha
 * @created 2021-01-04
 */
public class SMgetASVCessionOfUnitTrustsV1_Req_IB_v1 extends Base_IB {
/** @description : Wrapper class for service */
	public class smn236i {
		public String clcd;
	}

	public SMgetASVCessionOfUnitTrustsV1 SMgetASVCessionOfUnitTrustsV1;
/** @description : Wrapper class for service */
	public class nbsapdpi {
		public String channel;
		public String application;
		public String trace;
	}
/** @description : Wrapper class for service */
	public class nbsmsgi {
		public String msgLanguage;
		public String msgTarget;
	}
/** @description : Wrapper class for service */
	public class SMgetASVCessionOfUnitTrustsV1 {
		public Nbsapdpi nbsapdpi;
		public Nbsmsgi nbsmsgi;
		public smn236i smn236i;
	}
   /**
    * @description method to create dummy request
    * @author Prashant Jain | 2021-06-11 
    * @return SMgetASVCessionOfUnitTrustsV1_Req_IB_v1 
    **/ 
    public static SMgetASVCessionOfUnitTrustsV1_Req_IB_v1 createDummyRequest() {
        SMgetASVCessionOfUnitTrustsV1_Req_IB_v1 requestBean = new SMgetASVCessionOfUnitTrustsV1_Req_IB_v1();
        
        SMgetASVCessionOfUnitTrustsV1_Req_IB_v1.SMgetASVCessionOfUnitTrustsV1 SMgetASVCessionOfUnitTrustsV1 = new SMgetASVCessionOfUnitTrustsV1_Req_IB_v1.SMgetASVCessionOfUnitTrustsV1();
        
        SMgetASVCessionOfUnitTrustsV1_Req_IB_v1.Nbsapdpi nbsapdpi = new SMgetASVCessionOfUnitTrustsV1_Req_IB_v1.Nbsapdpi();
        nbsapdpi.channel = 'BDP';
        nbsapdpi.application = 'BDP';
        nbsapdpi.trace = 'Y';
        
        SMgetASVCessionOfUnitTrustsV1_Req_IB_v1.Nbsmsgi nbsmsgi = new SMgetASVCessionOfUnitTrustsV1_Req_IB_v1.Nbsmsgi();
        nbsmsgi.msgLanguage = 'E';
        nbsmsgi.msgTarget = 'STD';
        
        SMgetASVCessionOfUnitTrustsV1_Req_IB_v1.smn236i smn236i = new SMgetASVCessionOfUnitTrustsV1_Req_IB_v1.smn236i();
        smn236i.clcd = 'CLOSE  001';
        SMgetASVCessionOfUnitTrustsV1.nbsapdpi = nbsapdpi;
        SMgetASVCessionOfUnitTrustsV1.nbsmsgi = nbsmsgi;
        SMgetASVCessionOfUnitTrustsV1.smn236i = smn236i;
        
        requestBean.SMgetASVCessionOfUnitTrustsV1 = SMgetASVCessionOfUnitTrustsV1;
        
        return requestBean;
    }
}