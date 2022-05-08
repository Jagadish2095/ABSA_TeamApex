/**
* Apex Integration Response Bean class for Generatedocumentsv7 service
* @author  Anka Ganta : Absa
* @since   2020-04-15
*
**/
public class Generatedocumentsv7_Resp_IB_v1 {
    public String StatusMessage;
    public Integer StatusCode;
    public Envelope Envelope;

	public class Documentation {
		public String docCode;
		public String docDesc;
	}

	public class GetDocsResponse {
		public String DocNo;
		public String VersionNo;
		public String msgNo;
		public String msg;
		public List<Documentation> documentation;
	}

	public class Envelope {
		public Body Body;
	}

	public class Body {
		public GetDocsResponse GetDocsResponse;
	}
    
     
    public static Generatedocumentsv7_Resp_IB_v1 createDummyResponse(){
        Generatedocumentsv7_Resp_IB_v1 respbean = new Generatedocumentsv7_Resp_IB_v1();
        Generatedocumentsv7_Resp_IB_v1.Documentation Documentationbean = new Generatedocumentsv7_Resp_IB_v1.Documentation();
        List<Generatedocumentsv7_Resp_IB_v1.Documentation> DocumentationListbean = new List<Generatedocumentsv7_Resp_IB_v1.Documentation>();
        Generatedocumentsv7_Resp_IB_v1.GetDocsResponse GetDocsResponsebean = new Generatedocumentsv7_Resp_IB_v1.GetDocsResponse();
        Generatedocumentsv7_Resp_IB_v1.Body Bodybean = new Generatedocumentsv7_Resp_IB_v1.Body();
        Generatedocumentsv7_Resp_IB_v1.Envelope Envelopebean = new Generatedocumentsv7_Resp_IB_v1.Envelope();
        Documentationbean.docCode = '000001';
        Documentationbean.docDesc = 'ID';
        DocumentationListbean.add(Documentationbean);
        GetDocsResponsebean.DocNo = '7';
        GetDocsResponsebean.msg = 'Success';
        GetDocsResponsebean.msgNo = '0';
        GetDocsResponsebean.VersionNo = '112';
        GetDocsResponsebean.documentation = DocumentationListbean;
        Bodybean.GetDocsResponse = GetDocsResponsebean;
        Envelopebean.Body = Bodybean;
        respbean.Envelope = Envelopebean; 
        //requestbean.GetDocsRequest = GetDocsRequestbean;
        return respbean;
    }
}