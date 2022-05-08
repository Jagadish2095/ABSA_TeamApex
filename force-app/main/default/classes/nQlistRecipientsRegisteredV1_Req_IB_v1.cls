/*
* Request Integration Bean for NQlistRecipientsRegisteredForCustV1 Service
* @author Muvhuso Nekhubvi
* @created 2020/05/18
*/
public class nQlistRecipientsRegisteredV1_Req_IB_v1 extends Base_IB {
    
	public NQlistRecipientsRegisteredForCustV1 NQlistRecipientsRegisteredForCustV1;

	public class FinalMsgId {
		public String finalMsgClass;
		public String finalMsgCode;
	}

	public class Nqp904i {
		public String cif;
		public String registeringSite;
	}

	public class Nbsapdpi {
		public String channel;
		public String application;
		public String trace;
	}

	public class NQlistRecipientsRegisteredForCustV1 {
		public Nbsapdpi nbsapdpi;
		public Nbsmsgi nbsmsgi;
		public Nqp904i nqp904i;
	}

	public class Nbsmsgi {
		public String msgLanguage;
		public String msgTarget;
		public FinalMsgId finalMsgId;
	}
    
    public static nQlistRecipientsRegisteredV1_Req_IB_v1 createDummyRequest(){
        nQlistRecipientsRegisteredV1_Req_IB_v1 requestBean = new nQlistRecipientsRegisteredV1_Req_IB_v1();
        requestBean.NQlistRecipientsRegisteredForCustV1 = new nQlistRecipientsRegisteredV1_Req_IB_v1.NQlistRecipientsRegisteredForCustV1();
        requestBean.NQlistRecipientsRegisteredForCustV1.nbsapdpi = new nQlistRecipientsRegisteredV1_Req_IB_v1.Nbsapdpi();
        requestBean.NQlistRecipientsRegisteredForCustV1.nbsapdpi.application = 'BDP';
        requestBean.NQlistRecipientsRegisteredForCustV1.nbsapdpi.channel = 'BDP';
        requestBean.NQlistRecipientsRegisteredForCustV1.nbsapdpi.trace = 'Y';
        
        requestBean.NQlistRecipientsRegisteredForCustV1.nbsmsgi = new nQlistRecipientsRegisteredV1_Req_IB_v1.Nbsmsgi();
        requestBean.NQlistRecipientsRegisteredForCustV1.nbsmsgi.finalMsgId = new nQlistRecipientsRegisteredV1_Req_IB_v1.FinalMsgId();
        requestBean.NQlistRecipientsRegisteredForCustV1.nbsmsgi.finalMsgId.finalMsgClass = '';
        requestBean.NQlistRecipientsRegisteredForCustV1.nbsmsgi.finalMsgId.finalMsgCode = '';
        requestBean.NQlistRecipientsRegisteredForCustV1.nbsmsgi.msgLanguage = 'E';
        requestBean.NQlistRecipientsRegisteredForCustV1.nbsmsgi.msgTarget = 'STD';
        
        requestBean.NQlistRecipientsRegisteredForCustV1.nqp904i = new nQlistRecipientsRegisteredV1_Req_IB_v1.Nqp904i();
        requestBean.NQlistRecipientsRegisteredForCustV1.nqp904i.cif = 'MOOIM  002';
        requestBean.NQlistRecipientsRegisteredForCustV1.nqp904i.registeringSite = '3043';
        
        return requestBean;
    }
}