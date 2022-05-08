/**
* Apex Integration Response Bean class for WQconfirmDocumentReceiptV2 service
* @author  Anka Ganta : Absa
* @since   2020-06-22
*
**/
public class WQconfirmDocumentReceiptV2_Resp_IB_v1 {
    public String StatusMessage;
    public Integer StatusCode;
    public class WQconfirmDocumentReceiptV2Response {
        public Nbsapdpo nbsapdpo;
        public Wqp131o wqp131o;
    }

    public class Nbsapdpo {
        public String version;
        public String returnCode;
        public String reasonCode;
        public String serviceVersion;
    }

    public WQconfirmDocumentReceiptV2Response WQconfirmDocumentReceiptV2Response;

    public class Wqp131o {
        public String msgNo;
        public String msg;
    }
    
    public static WQconfirmDocumentReceiptV2_Resp_IB_v1 createDummyResponse(){
        WQconfirmDocumentReceiptV2_Resp_IB_v1 respbean = new WQconfirmDocumentReceiptV2_Resp_IB_v1();
        WQconfirmDocumentReceiptV2_Resp_IB_v1.Nbsapdpo Nbsapdpobean = new WQconfirmDocumentReceiptV2_Resp_IB_v1.Nbsapdpo();
        WQconfirmDocumentReceiptV2_Resp_IB_v1.Wqp131o Wqp131obean = new WQconfirmDocumentReceiptV2_Resp_IB_v1.Wqp131o();
        WQconfirmDocumentReceiptV2_Resp_IB_v1.WQconfirmDocumentReceiptV2Response WQconfirmDocumentReceiptV2Responsebean = new WQconfirmDocumentReceiptV2_Resp_IB_v1.WQconfirmDocumentReceiptV2Response();
        
        Nbsapdpobean.reasonCode = 'test';
        Nbsapdpobean.returnCode = '200';
        Nbsapdpobean.serviceVersion = '1';
        Nbsapdpobean.version = '1';
        
        Wqp131obean.msg = 'success';
        Wqp131obean.msgNo = '0';
        
        WQconfirmDocumentReceiptV2Responsebean.nbsapdpo = nbsapdpobean;
        WQconfirmDocumentReceiptV2Responsebean.wqp131o = wqp131obean;
        respbean.WQconfirmDocumentReceiptV2Response = WQconfirmDocumentReceiptV2Responsebean;
        respbean.StatusMessage = 'Success';
        respbean.StatusCode = 200;
        return respbean;
    }   
}