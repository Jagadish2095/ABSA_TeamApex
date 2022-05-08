/**
* Apex Integration Request Bean class for Generatedocumentsv7 service
* @author  Anka Ganta : Absa
* @since   2020-04-15
*
**/
public class Generatedocumentsv7_Req_IB_v1 {
   public GetDocsRequest GetDocsRequest;

	public class GetDocsRequest {
		public String RefNumber;
		public String SBU;
		public String OriginatingSystem;
		public String Branch;
		public String InitialAB;
		public String Additional_Docs;
	}
    
    public static Generatedocumentsv7_Req_IB_v1 createDummyRequest(){
        Generatedocumentsv7_Req_IB_v1 requestbean = new Generatedocumentsv7_Req_IB_v1();
        Generatedocumentsv7_Req_IB_v1.GetDocsRequest GetDocsRequestbean = new Generatedocumentsv7_Req_IB_v1.GetDocsRequest();
        GetDocsRequestbean.RefNumber = '1742694';
        GetDocsRequestbean.SBU = '';
        GetDocsRequestbean.OriginatingSystem = 'ESP';
        GetDocsRequestbean.Branch = '9881';
        GetDocsRequestbean.InitialAB = 'TEST123';
        GetDocsRequestbean.Additional_Docs = '';
        requestbean.GetDocsRequest = GetDocsRequestbean;
        return requestbean;
    }
}