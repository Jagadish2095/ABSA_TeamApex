/**
* Apex Integration Request Bean class for Generatedocumentsv1 service(docPack Orchestration service)
* @author  Anka Ganta : Absa
* @since   2020-07-20
*
**/
public class GetDocumentsv1_Req_IB_v1 extends Base_IB{
   public GenerateDocument GenerateDocument;

    public class Header {
        public String transID;
        public String sourceApp;
    }

    public class GenerateDocument {
        public Header Header;
        public RequestMessage RequestMessage;
    }

    public class RequestMessage {
        public GetDocsRequest GetDocsRequest;
    }

    public class GetDocsRequest {
        public String RefNumber;
        public String SBU;
        public String OriginatingSystem;
        public String Branch;
        public String InitialAB;
        public String Additional_Docs;
    }    
    
    public static GetDocumentsv1_Req_IB_v1 createDummyRequest() {
        GetDocumentsv1_Req_IB_v1 requestbean = new GetDocumentsv1_Req_IB_v1();
        GetDocumentsv1_Req_IB_v1.GetDocsRequest GetDocsRequestbean = new GetDocumentsv1_Req_IB_v1.GetDocsRequest();
        GetDocumentsv1_Req_IB_v1.RequestMessage RequestMessagebean = new GetDocumentsv1_Req_IB_v1.RequestMessage();
        GetDocumentsv1_Req_IB_v1.Header Headerbean = new GetDocumentsv1_Req_IB_v1.Header();
        GetDocumentsv1_Req_IB_v1.GenerateDocument GenerateDocumentbean = new GetDocumentsv1_Req_IB_v1.GenerateDocument();
        GetDocsRequestbean.RefNumber = '1742694';
        GetDocsRequestbean.SBU = '0';
        GetDocsRequestbean.OriginatingSystem = 'ESP';
        GetDocsRequestbean.Branch = '9881';
        GetDocsRequestbean.InitialAB = '';
        GetDocsRequestbean.Additional_Docs = '';
        Headerbean.transID = '12344';
        Headerbean.sourceApp = 'Salesforce';
        RequestMessagebean.GetDocsRequest = GetDocsRequestbean;
        
        GenerateDocumentbean.Header = Headerbean;
        GenerateDocumentbean.RequestMessage = RequestMessagebean;
        requestbean.GenerateDocument = GenerateDocumentbean;
        return requestbean;
    }
}