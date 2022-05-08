/*
 * Request Integration Bean for NQlistRecipientsRegForCustV1 Service
 * @author Khaliq Abdul
 * @created 2020-11-20
 */
public class NQlistRecipientsRegForCustV1_Req_IB_v1 extends Base_IB  {
    
    public NQlistRecipientsRegisteredForCustV1 NQlistRecipientsRegisteredForCustV1{get;set;}
    
    public class NQlistRecipientsRegisteredForCustV1 {
        public nbsapdpi nbsapdpi;
		public nbsmsgi nbsmsgi;
		public nqp904i nqp904i; 
    }
    public class nbsapdpi {
		public String channel;
		public String application;
		public String trace;
	}
    
    public class nbsmsgi{
        public String msgLanguage;
		public String msgTarget;
		public FinalMsgId finalMsgId;
    }
    
    public class FinalMsgId {
		public String finalMsgClass;
		public String finalMsgCode;
	}
    
    public class nqp904i {
		public String cif;
		public String registeringSite;
	}   
    
    public static NQlistRecipientsRegForCustV1_Req_IB_v1 createDummyRequest(){
        
        NQlistRecipientsRegForCustV1_Req_IB_v1 requestBean = new NQlistRecipientsRegForCustV1_Req_IB_v1();
        NQlistRecipientsRegForCustV1_Req_IB_v1.nbsapdpi nbsapdpiRequest = new NQlistRecipientsRegForCustV1_Req_IB_v1.nbsapdpi();
        nbsapdpiRequest.application = 'BDP';
        nbsapdpiRequest.channel = 'BDP';
        nbsapdpiRequest.trace = 'Y';
        
        NQlistRecipientsRegForCustV1_Req_IB_v1.nbsmsgi nbsmsgiRequest = new NQlistRecipientsRegForCustV1_Req_IB_v1.nbsmsgi ();
        nbsmsgiRequest.msgLanguage = 'E';
        nbsmsgiRequest.msgTarget = 'STD';

        NQlistRecipientsRegForCustV1_Req_IB_v1.finalMsgId finalMsgIdRequest = new NQlistRecipientsRegForCustV1_Req_IB_v1.finalMsgId();
        finalMsgIdRequest.finalMsgClass = '';
        finalMsgIdRequest.finalMsgCode = '';
        
        NQlistRecipientsRegForCustV1_Req_IB_v1.nqp904i nqp904iRequest = new NQlistRecipientsRegForCustV1_Req_IB_v1.nqp904i();
        Nqp904iRequest.cif =  'MOOIM  002'  ;
        Nqp904iRequest.registeringSite =  '3043'  ;
        
        NQlistRecipientsRegForCustV1_Req_IB_v1.NQlistRecipientsRegisteredForCustV1 NQlistRecipientsRegisteredForCustV1bean = new NQlistRecipientsRegForCustV1_Req_IB_v1.NQlistRecipientsRegisteredForCustV1();
        NQlistRecipientsRegisteredForCustV1bean.nbsapdpi = nbsapdpiRequest;
        NQlistRecipientsRegisteredForCustV1bean.nbsmsgi = nbsmsgiRequest;
        NQlistRecipientsRegisteredForCustV1bean.nqp904i = nqp904iRequest;
        
        requestBean.NQlistRecipientsRegisteredForCustV1 = NQlistRecipientsRegisteredForCustV1bean;

        return requestBean;
    }
}