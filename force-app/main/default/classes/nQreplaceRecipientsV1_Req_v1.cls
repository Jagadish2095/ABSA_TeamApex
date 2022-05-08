/*
* Request Integration Bean for NQreplaceRecipientsAcrossAllAcntsV1 Service
* @author Muvhuso Nekhubvi
* @created 2020/05/18
*/
public class nQreplaceRecipientsV1_Req_v1 extends Base_IB {
    
	public class Nqp096i {
		public String registeringSite;
		public String cif;
		public String recipNm;
		public String pnsRecipientId;
		public String contactPref;
		public String lng;
		public String email;
		public String cellPhone;
	}

	public NQreplaceRecipientsAcrossAllAcntsV1 NQreplaceRecipientsAcrossAllAcntsV1;

	public class FinalMsgId {
		public String finalMsgClass;
		public String finalMsgCode;
	}

	public class NQreplaceRecipientsAcrossAllAcntsV1 {
		public Nbsapdpi nbsapdpi;
		public Nbsmsgi nbsmsgi;
		public Nqp096i nqp096i;
	}

	public class Nbsapdpi {
		public String channel;
		public String application;
		public String trace;
	}

	public class Nbsmsgi {
		public String msgLanguage;
		public String msgTarget;
		public FinalMsgId finalMsgId;
	}
    
    public static nQreplaceRecipientsV1_Req_v1 createDummyRequest(){
        nQreplaceRecipientsV1_Req_v1 requestBean = new nQreplaceRecipientsV1_Req_v1();
        requestBean.NQreplaceRecipientsAcrossAllAcntsV1 = new nQreplaceRecipientsV1_Req_v1.NQreplaceRecipientsAcrossAllAcntsV1();
		requestBean.NQreplaceRecipientsAcrossAllAcntsV1.nbsapdpi =  new nQreplaceRecipientsV1_Req_v1.Nbsapdpi();
        requestBean.NQreplaceRecipientsAcrossAllAcntsV1.nbsapdpi.application = 'BDP';
        requestBean.NQreplaceRecipientsAcrossAllAcntsV1.nbsapdpi.channel = 'BDP';
        requestBean.NQreplaceRecipientsAcrossAllAcntsV1.nbsapdpi.trace = 'Y';
        
        requestBean.NQreplaceRecipientsAcrossAllAcntsV1.nbsmsgi = new nQreplaceRecipientsV1_Req_v1.Nbsmsgi();
        requestBean.NQreplaceRecipientsAcrossAllAcntsV1.nbsmsgi.msgLanguage = 'E';
        requestBean.NQreplaceRecipientsAcrossAllAcntsV1.nbsmsgi.msgTarget = 'STD';
        requestBean.NQreplaceRecipientsAcrossAllAcntsV1.nqp096i = new nQreplaceRecipientsV1_Req_v1.Nqp096i();
        requestBean.NQreplaceRecipientsAcrossAllAcntsV1.nqp096i.registeringSite = '3043';
        requestBean.NQreplaceRecipientsAcrossAllAcntsV1.nqp096i.cif = 'ZUMAD  001';
        requestBean.NQreplaceRecipientsAcrossAllAcntsV1.nqp096i.recipNm = '1';
        requestBean.NQreplaceRecipientsAcrossAllAcntsV1.nqp096i.pnsRecipientId = '1';
        requestBean.NQreplaceRecipientsAcrossAllAcntsV1.nqp096i.contactPref = 'E';
        requestBean.NQreplaceRecipientsAcrossAllAcntsV1.nqp096i.lng = 'E';
        requestBean.NQreplaceRecipientsAcrossAllAcntsV1.nqp096i.email = 'sizwe@absa.co.za';
        requestBean.NQreplaceRecipientsAcrossAllAcntsV1.nqp096i.cellPhone = '';
        return requestBean;
    }
}