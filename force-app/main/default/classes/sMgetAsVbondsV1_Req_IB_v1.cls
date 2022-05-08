/**
 * @description       : Request Integration Bean for sMgetAsVbondsV1 Service
 * @author            : Prashant Jain
 * @last modified on  : 2021-06-10
 * @last modified by  : Prashant Jain
 * Modifications Log 
 * Ver   Date         Author          Modification
 * 1.0   2021-06-10   Prashant Jain   Initial Version
**/


public class sMgetAsVbondsV1_Req_IB_v1 extends Base_IB {

    /**
 * @description       : Request Integration Bean for sMgetAsVbondsV1 Service
 * @author            : Prashant Jain
 **/
	public class Smn145i {
		public String clcd;
	}

	public SMgetASVbondsV1 SMgetASVbondsV1;
    /**
 * @description       : Request Integration Bean for sMgetAsVbondsV1 Service
 * @author            : Prashant Jain
 **/
	public class Nbsapdpi {
		public String channel;
		public String application;
		public String trace;
	}
    /**
 * @description       : Request Integration Bean for sMgetAsVbondsV1 Service
 * @author            : Prashant Jain
 **/
	public class Nbsmsgi {
		public String msgLanguage;
		public String msgTarget;
	}
    /**
 * @description       : Request Integration Bean for sMgetAsVbondsV1 Service
 * @author            : Prashant Jain
 **/
	public class SMgetASVbondsV1 {
		public Nbsapdpi nbsapdpi;
		public Nbsmsgi nbsmsgi;
		public Smn145i smn145i;
	}
    
    /**
    * @description 
    * @author Prashant Jain | 2021-06-10 
    * @return sMgetAsVbondsV1_Req_IB_v1 
    **/
    public static sMgetAsVbondsV1_Req_IB_v1 createDummyRequest() {
        sMgetAsVbondsV1_Req_IB_v1 requestBean = new sMgetAsVbondsV1_Req_IB_v1();
        
        sMgetAsVbondsV1_Req_IB_v1.SMgetASVbondsV1 sMgetASVbondsV1 = new sMgetAsVbondsV1_Req_IB_v1.SMgetASVbondsV1();
        
        sMgetAsVbondsV1_Req_IB_v1.Nbsapdpi nbsapdpi = new sMgetAsVbondsV1_Req_IB_v1.Nbsapdpi();
        nbsapdpi.channel = 'BDP';
        nbsapdpi.application = 'BDP';
        nbsapdpi.trace = 'Y';
        
        sMgetAsVbondsV1_Req_IB_v1.Nbsmsgi nbsmsgi = new sMgetAsVbondsV1_Req_IB_v1.Nbsmsgi();
        nbsmsgi.msgLanguage = 'E';
        nbsmsgi.msgTarget = 'STD';
        
        sMgetAsVbondsV1_Req_IB_v1.Smn145i smn145i = new sMgetAsVbondsV1_Req_IB_v1.Smn145i();
        smn145i.clcd = 'CLOSE  001';
        sMgetASVbondsV1.nbsapdpi = nbsapdpi;
        sMgetASVbondsV1.nbsmsgi = nbsmsgi;
        sMgetASVbondsV1.smn145i = smn145i;
        
        requestBean.SMgetASVbondsV1 = sMgetASVbondsV1;
        
        return requestBean;
    }

}