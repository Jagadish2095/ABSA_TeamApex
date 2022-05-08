/**
* Apex Integration Request Bean class for WQconfirmDocumentReceiptV2 service
* @author  Anka Ganta : Absa
* @since   2020-06-22
*
**/
public class WQconfirmDocumentReceiptV2_Req_IB_v1 {
 public class Wqp131i {
        public String refNo;
        public String version;
        public String branch;
        public String user;
        public String docNo;
        public List<RequiredDocs> requiredDocs;
    }

    public WQconfirmDocumentReceiptV2 WQconfirmDocumentReceiptV2;

    public class WQconfirmDocumentReceiptV2 {
        public Nbsapdpi nbsapdpi;
        public Wqp131i wqp131i;
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
        public String scanYn;
    }
    
      
    public static WQconfirmDocumentReceiptV2_Req_IB_v1 createDummyRequest(){
        WQconfirmDocumentReceiptV2_Req_IB_v1 requestbean = new WQconfirmDocumentReceiptV2_Req_IB_v1();
        WQconfirmDocumentReceiptV2_Req_IB_v1.Nbsapdpi Nbsapdpibean = new WQconfirmDocumentReceiptV2_Req_IB_v1.Nbsapdpi();
        WQconfirmDocumentReceiptV2_Req_IB_v1.wqp131i wqp131ibean = new WQconfirmDocumentReceiptV2_Req_IB_v1.wqp131i();
        WQconfirmDocumentReceiptV2_Req_IB_v1.RequiredDocs RequiredDocsbean = new WQconfirmDocumentReceiptV2_Req_IB_v1.RequiredDocs();
        List<WQconfirmDocumentReceiptV2_Req_IB_v1.RequiredDocs> RequiredDocsbeanList = new List<WQconfirmDocumentReceiptV2_Req_IB_v1.RequiredDocs>();
        WQconfirmDocumentReceiptV2_Req_IB_v1.WQconfirmDocumentReceiptV2 WQconfirmDocumentReceiptV2bean = new WQconfirmDocumentReceiptV2_Req_IB_v1.WQconfirmDocumentReceiptV2();
        
        Nbsapdpibean.channel = 'ESP';
        Nbsapdpibean.application = 'ESP';
        Nbsapdpibean.trace = 'Y';
        
        RequiredDocsbean.docCode = '0005';
        RequiredDocsbean.received = 'Y';
        RequiredDocsbean.inOrder = 'Y';
        RequiredDocsbean.scanYn = 'N';
        RequiredDocsbeanList.add(RequiredDocsbean);
        
        wqp131ibean.refNo = '9881';
        wqp131ibean.version = 'TEST123';
        wqp131ibean.branch = '';
        wqp131ibean.user = '9881';
        wqp131ibean.docNo = 'TEST123';
        wqp131ibean.requiredDocs = RequiredDocsbeanList;
        
        WQconfirmDocumentReceiptV2bean.nbsapdpi = nbsapdpibean;
        WQconfirmDocumentReceiptV2bean.wqp131i = wqp131ibean;
        
        requestbean.WQconfirmDocumentReceiptV2 = WQconfirmDocumentReceiptV2bean;
        return requestbean;
    }
}