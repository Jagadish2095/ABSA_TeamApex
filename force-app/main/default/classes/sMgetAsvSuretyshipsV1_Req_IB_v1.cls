/*
 * Request Integration Bean for sMgetAsvSuretyshipsV1 Service
 * @author Prashant Jain
 * @created 2020-03-03
 */

public class sMgetAsvSuretyshipsV1_Req_IB_v1 extends Base_IB {

	public SMgetASVSuretyshipsV1 SMgetASVSuretyshipsV1;

	public class Smn152i {
		public String clcd;
	}

	public class SMgetASVSuretyshipsV1 {
		public Nbsapdpi nbsapdpi;
		public Nbsmsgi nbsmsgi;
		public Smn152i smn152i;
	}

	public class Nbsapdpi {
		public String channel;
		public String application;
		public String trace;
	}

	public class Nbsmsgi {
		public String msgLanguage;
		public String msgTarget;
	}
    
    public static sMgetAsvSuretyshipsV1_Req_IB_v1 createDummyRequest() {
       
        sMgetAsvSuretyshipsV1_Req_IB_v1 requestBean = new sMgetAsvSuretyshipsV1_Req_IB_v1();
         
        sMgetAsvSuretyshipsV1_Req_IB_v1.SMgetASVSuretyshipsV1 sMgetASVSuretyshipsV1 = new sMgetAsvSuretyshipsV1_Req_IB_v1.SMgetASVSuretyshipsV1();
        
        sMgetAsvSuretyshipsV1_Req_IB_v1.Nbsapdpi nbsapdpi = new sMgetAsvSuretyshipsV1_Req_IB_v1.Nbsapdpi();
        nbsapdpi.channel = 'BDP';
        nbsapdpi.application = 'BDP';
        nbsapdpi.trace = 'Y';
        
        sMgetAsvSuretyshipsV1_Req_IB_v1.Nbsmsgi nbsmsgi = new sMgetAsvSuretyshipsV1_Req_IB_v1.Nbsmsgi();
        nbsmsgi.msgLanguage = 'E';
        nbsmsgi.msgTarget = 'STD';
        
        sMgetAsvSuretyshipsV1_Req_IB_v1.Smn152i smn152i = new sMgetAsvSuretyshipsV1_Req_IB_v1.Smn152i();
        
        smn152i.clcd = 'CLOSE  001';
        
        sMgetASVSuretyshipsV1.nbsapdpi = nbsapdpi;
        sMgetASVSuretyshipsV1.nbsmsgi = nbsmsgi;
        sMgetASVSuretyshipsV1.smn152i = smn152i;
        requestBean.SMgetASVSuretyshipsV1 = sMgetASVSuretyshipsV1;
        return requestBean;
    }
}