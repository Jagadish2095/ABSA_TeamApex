/**
* Apex Integration Request Bean class for Generatedocumentsv1 service(docPack Orchestration service)
* @author  Anka Ganta : Absa
* @since   2020-07-20
*
**/
public class GetDocumentsv1_Resp_IB_v1 extends Base_IB{
   
  @AuraEnabled  public String status;
  @AuraEnabled  public Integer statusCode;
  @AuraEnabled  public String message;

   public class Nbsapdpo {
        public String version;
        public String returnCode;
        public String reasonCode;
        public String serviceVersion;
    }

    public class ResponseHeader {
        public String code;
        public String description;
    }

    public GenerateDocument GenerateDocument;

    public class WQacknowledgeDocumentsV1Response {
        public Nbsapdpo nbsapdpo;
        public Wqp132o wqp132o;
    }

    public class GenerateDocument {
        public ResponseHeader ResponseHeader;
        public ResponseMessage ResponseMessage;
    }

    public class Wqp132o {
        public String msgNo;
        public String msg;
    }

    public class ResponseMessage {
        public WQacknowledgeDocumentsV1Response WQacknowledgeDocumentsV1Response;
    }
    
    public static GetDocumentsv1_Resp_IB_v1 createDummyResponse(){
        GetDocumentsv1_Resp_IB_v1 respbean = new GetDocumentsv1_Resp_IB_v1();
        GetDocumentsv1_Resp_IB_v1.GenerateDocument GenerateDocumentbean = new GetDocumentsv1_Resp_IB_v1.GenerateDocument();
        GetDocumentsv1_Resp_IB_v1.ResponseHeader ResponseHeaderbean = new GetDocumentsv1_Resp_IB_v1.ResponseHeader();
        GetDocumentsv1_Resp_IB_v1.ResponseMessage ResponseMessagebean = new GetDocumentsv1_Resp_IB_v1.ResponseMessage();
        GetDocumentsv1_Resp_IB_v1.WQacknowledgeDocumentsV1Response WQacknowledgeDocumentsV1Responsebean = new GetDocumentsv1_Resp_IB_v1.WQacknowledgeDocumentsV1Response();
         GetDocumentsv1_Resp_IB_v1.Nbsapdpo Nbsapdpobean = new GetDocumentsv1_Resp_IB_v1.Nbsapdpo();
        GetDocumentsv1_Resp_IB_v1.Wqp132o Wqp132obean = new GetDocumentsv1_Resp_IB_v1.Wqp132o();
        
        Nbsapdpobean.version = 'APLO003';
        Nbsapdpobean.returnCode = '0';
        Nbsapdpobean.reasonCode = '0';
        Nbsapdpobean.serviceVersion = 'BUSO001';
        
        Wqp132obean.msgNo = '58';
        Wqp132obean.msg = 'Records have not been quality assured yet';
        
        WQacknowledgeDocumentsV1Responsebean.Nbsapdpo = Nbsapdpobean;
        WQacknowledgeDocumentsV1Responsebean.Wqp132o = Wqp132obean;
        ResponseMessagebean.WQacknowledgeDocumentsV1Response = WQacknowledgeDocumentsV1Responsebean;
        ResponseHeaderbean.code = 'Success';
        ResponseHeaderbean.description = 'Records have not been quality assured yet';
        GenerateDocumentbean.ResponseHeader = ResponseHeaderbean;
        GenerateDocumentbean.ResponseMessage = ResponseMessagebean;
        respbean.GenerateDocument = GenerateDocumentbean;
        return respbean;
    }
}