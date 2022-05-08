public class CIgetRelationshipsV1_Req_IB_v1 extends Base_IB {
    
   public CIgetRelationshipsV1 CIgetRelationshipsV1;
    
    public class cib128i {
		public String clientKey;
        public String acno;
        public String maxRetrieve;
        public String restartKey;
        public String siteCode;
        public String tellerCode;
        
	}

	public class nbsapdpi {
		public String channel;
		public String application;
		public String trace;
	}

	public class nbsmsgi {
		public String msgLanguage;
		public String msgTarget;
	}

	public class CIgetRelationshipsV1 {
		public Nbsapdpi nbsapdpi;
		public Nbsmsgi nbsmsgi;
		public cib128i cib128i;
	}
    
    public static CIgetRelationshipsV1_Req_IB_v1 createDummyRequest() {
        CIgetRelationshipsV1_Req_IB_v1 requestBean = new CIgetRelationshipsV1_Req_IB_v1();
        
        CIgetRelationshipsV1_Req_IB_v1.CIgetRelationshipsV1 CIgetRelationshipsV1 = new CIgetRelationshipsV1_Req_IB_v1.CIgetRelationshipsV1();
        
        CIgetRelationshipsV1_Req_IB_v1.Nbsapdpi nbsapdpi = new CIgetRelationshipsV1_Req_IB_v1.Nbsapdpi();
        nbsapdpi.channel = 'CIF';
        nbsapdpi.application = 'CIF';
        nbsapdpi.trace = 'N';
        
        CIgetRelationshipsV1_Req_IB_v1.Nbsmsgi nbsmsgi = new CIgetRelationshipsV1_Req_IB_v1.Nbsmsgi();
        nbsmsgi.msgLanguage = 'E';
        nbsmsgi.msgTarget = 'STD';
        
        CIgetRelationshipsV1_Req_IB_v1.cib128i cib128i = new CIgetRelationshipsV1_Req_IB_v1.cib128i();
        cib128i.clientKey='';
        cib128i.acno='3001532603';
        cib128i.maxRetrieve='15';
        cib128i.restartKey='';
        cib128i.siteCode='8392';
        cib128i.tellerCode='2479519';
        CIgetRelationshipsV1.nbsapdpi = nbsapdpi;
        CIgetRelationshipsV1.nbsmsgi = nbsmsgi;
        CIgetRelationshipsV1.cib128i = cib128i;
        
        requestBean.CIgetRelationshipsV1 = CIgetRelationshipsV1;
        
        return requestBean;
    }

}