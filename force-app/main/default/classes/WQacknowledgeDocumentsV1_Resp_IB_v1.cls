/**
* Apex Integration Response Bean class for WQacknowledgeDocumentsV1 service
* @author  Anka Ganta : Absa
* @since   2020-04-15
*
**/
public class WQacknowledgeDocumentsV1_Resp_IB_v1 {
    public String StatusMessage;
    public Integer StatusCode;
    public class Nbsapdpo {
		public String version;
		public String returnCode;
		public String reasonCode;
		public String serviceVersion;
	}

	public WQacknowledgeDocumentsV1Response WQacknowledgeDocumentsV1Response;

	public class WQacknowledgeDocumentsV1Response {
		public Nbsapdpo nbsapdpo;
		public Wqp132o wqp132o;
	}

	public class Wqp132o {
		public String msgNo;
		public String msg;
	}
    
    public static WQacknowledgeDocumentsV1_Resp_IB_v1 createDummyResponse(){
        WQacknowledgeDocumentsV1_Resp_IB_v1 respbean = new WQacknowledgeDocumentsV1_Resp_IB_v1();
        WQacknowledgeDocumentsV1_Resp_IB_v1.Nbsapdpo Nbsapdpobean = new WQacknowledgeDocumentsV1_Resp_IB_v1.Nbsapdpo();
        WQacknowledgeDocumentsV1_Resp_IB_v1.Wqp132o Wqp132obean = new WQacknowledgeDocumentsV1_Resp_IB_v1.Wqp132o();
        WQacknowledgeDocumentsV1_Resp_IB_v1.WQacknowledgeDocumentsV1Response WQacknowledgeDocumentsV1Responsebean = new WQacknowledgeDocumentsV1_Resp_IB_v1.WQacknowledgeDocumentsV1Response();
        
        Nbsapdpobean.reasonCode = 'test';
        Nbsapdpobean.returnCode = '200';
        Nbsapdpobean.serviceVersion = '1';
        Nbsapdpobean.version = '1';
        
        Wqp132obean.msg = 'success';
        Wqp132obean.msgNo = '0';
        
        WQacknowledgeDocumentsV1Responsebean.nbsapdpo = nbsapdpobean;
        WQacknowledgeDocumentsV1Responsebean.wqp132o = wqp132obean;
        respbean.WQacknowledgeDocumentsV1Response = WQacknowledgeDocumentsV1Responsebean;
        respbean.StatusMessage = 'Success';
        respbean.StatusCode = 200;
        return respbean;
    }   
     
}