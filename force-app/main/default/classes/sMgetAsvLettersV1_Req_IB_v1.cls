/**
 * @description       : Request Integration Bean for sMgetAsvLettersV1 Service
 * @author            : Prashant Jain
 * @last modified on  : 2021-06-11
 * @last modified by  : Prashant Jain
 * Modifications Log 
 * Ver   Date         Author          Modification
 * 1.0   2021-06-11   Prashant Jain   Initial Version
**/

public class sMgetAsvLettersV1_Req_IB_v1 extends Base_IB {

	public SMgetASVLettersV1 SMgetASVLettersV1;
/** @description : Wrapper class for service */
	public class Nbsapdpi {
		public String channel;
		public String application;
		public String trace;
	}
/** @description : Wrapper class for service */
	public class SMgetASVLettersV1 {
		public Nbsapdpi nbsapdpi;
		public Nbsmsgi nbsmsgi;
		public Smn140i smn140i;
	}
/** @description : Wrapper class for service */
	public class Smn140i {
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
    * @return sMgetAsvLettersV1_Req_IB_v1 
    **/
    public static sMgetAsvLettersV1_Req_IB_v1 createDummyRequest() {
        sMgetAsvLettersV1_Req_IB_v1 requestBean = new sMgetAsvLettersV1_Req_IB_v1();
        sMgetAsvLettersV1_Req_IB_v1.SMgetASVLettersV1 sMgetASVLettersV1 = new sMgetAsvLettersV1_Req_IB_v1.SMgetASVLettersV1();
        
        sMgetAsvLettersV1_Req_IB_v1.Nbsapdpi nbsapdpi = new sMgetAsvLettersV1_Req_IB_v1.Nbsapdpi();
        nbsapdpi.channel = 'BDP';
        nbsapdpi.application = 'BDP';
        nbsapdpi.trace = 'Y';
        
        sMgetAsvLettersV1_Req_IB_v1.Nbsmsgi nbsmsgi = new sMgetAsvLettersV1_Req_IB_v1.Nbsmsgi();
        nbsmsgi.msgLanguage = 'E';
        nbsmsgi.msgTarget = 'STD';
        
        sMgetAsvLettersV1_Req_IB_v1.Smn140i smn140i = new sMgetAsvLettersV1_Req_IB_v1.Smn140i();
        smn140i.clcd = 'CLOSE  001';
        
        sMgetASVLettersV1.nbsapdpi = nbsapdpi;
        sMgetASVLettersV1.nbsmsgi = nbsmsgi;
        sMgetASVLettersV1.smn140i = smn140i;
        
        requestBean.sMgetASVLettersV1 = sMgetASVLettersV1;
		//requestBean.smn140i = new sMgetAsvLettersV1_Req_IB_v1.Smn140i();
		
		//requestBean.smn140i.clcd = 'CLOSE  001';

        return requestBean;
    }
}