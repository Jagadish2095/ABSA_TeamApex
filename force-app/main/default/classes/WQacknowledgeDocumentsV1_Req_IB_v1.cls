/**
* Apex Integration Request Bean class for WQacknowledgeDocumentsV1 service
* @author  Anka Ganta : Absa
* @since   2020-04-15
*
**/
public class WQacknowledgeDocumentsV1_Req_IB_v1 {
    public WQacknowledgeDocumentsV1 WQacknowledgeDocumentsV1;

	public class WQacknowledgeDocumentsV1 {
		public Nbsapdpi nbsapdpi;
		public Wqp132i wqp132i;
	}

	public class Nbsapdpi {
		public String channel;
		public String application;
		public String trace;
	}

	public class RequiredDocs {
		public String docCode;
		public String received;
		public String inOrder;
		public String nonConfirm;
	}

	public class Wqp132i {
		public String refNo;
		public String version;
		public String branch;
		public String user;
		public String docNo;
		public List<RequiredDocs> requiredDocs;
	}
    
    
    public static WQacknowledgeDocumentsV1_Req_IB_v1 createDummyRequest(){
        WQacknowledgeDocumentsV1_Req_IB_v1 requestbean = new WQacknowledgeDocumentsV1_Req_IB_v1();
        WQacknowledgeDocumentsV1_Req_IB_v1.Nbsapdpi Nbsapdpibean = new WQacknowledgeDocumentsV1_Req_IB_v1.Nbsapdpi();
        WQacknowledgeDocumentsV1_Req_IB_v1.wqp132i wqp132ibean = new WQacknowledgeDocumentsV1_Req_IB_v1.wqp132i();
        WQacknowledgeDocumentsV1_Req_IB_v1.RequiredDocs RequiredDocsbean = new WQacknowledgeDocumentsV1_Req_IB_v1.RequiredDocs();
        List<WQacknowledgeDocumentsV1_Req_IB_v1.RequiredDocs> RequiredDocsbeanList = new List<WQacknowledgeDocumentsV1_Req_IB_v1.RequiredDocs>();
        WQacknowledgeDocumentsV1_Req_IB_v1.WQacknowledgeDocumentsV1 WQacknowledgeDocumentsV1bean = new WQacknowledgeDocumentsV1_Req_IB_v1.WQacknowledgeDocumentsV1();
        
        Nbsapdpibean.channel = 'ESP';
        Nbsapdpibean.application = 'ESP';
        Nbsapdpibean.trace = 'Y';
        
        RequiredDocsbean.docCode = '0005';
        RequiredDocsbean.received = 'Y';
        RequiredDocsbean.inOrder = 'Y';
        RequiredDocsbean.nonConfirm = '';
        RequiredDocsbeanList.add(RequiredDocsbean);
        
        wqp132ibean.refNo = '9881';
        wqp132ibean.version = 'TEST123';
        wqp132ibean.branch = '';
        wqp132ibean.user = '9881';
        wqp132ibean.docNo = 'TEST123';
        wqp132ibean.requiredDocs = RequiredDocsbeanList;
        
        WQacknowledgeDocumentsV1bean.nbsapdpi = nbsapdpibean;
        WQacknowledgeDocumentsV1bean.wqp132i = wqp132ibean;
        
        requestbean.WQacknowledgeDocumentsV1 = WQacknowledgeDocumentsV1bean;
        return requestbean;
    }
}