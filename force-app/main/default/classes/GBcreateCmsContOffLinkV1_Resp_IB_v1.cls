/*
 * Response Integration Bean for GBcreateCmsContOffLinkV1 Service
 * @author Diksha Wasekar
 * @created 2020-04-03
 */

public class GBcreateCmsContOffLinkV1_Resp_IB_v1 extends Base_IB {

    public String status;
    public Integer statusCode;
    public String message;

	public class Nbsapdpo {
		public String returnCode;
		public String reasonCode;
		public String serviceVersion;
	}

	public class GBcreateCmsContOffLinkV1Response {
		public Nbsapdpo nbsapdpo;
		public Nbsmsgo3 nbsmsgo3;
		public Gsp020o gsp020o;
	}

	public GBcreateCmsContOffLinkV1Response GBcreateCmsContOffLinkV1Response;

	public class Nbsmsgo3 {
		public Object sysErrTxt;
		public String nbrUserMsgs;
		public String nbrUserErrs;
		public MsgEntry msgEntry;
	}

	public class MsgEntry {
		public String msgClass;
		public String msgCode;
		public String msgErrInd;
		public String msgTxt;
	}

	public class Gsp020o {
		public String confirmation;
	}

    
        public GBcreateCmsContOffLinkV1_Resp_IB_v1 dummyResponse(){
        GBcreateCmsContOffLinkV1_Resp_IB_v1 responseBean = new GBcreateCmsContOffLinkV1_Resp_IB_v1();
        responseBean.GBcreateCmsContOffLinkV1Response = new GBcreateCmsContOffLinkV1_Resp_IB_v1.GBcreateCmsContOffLinkV1Response();
        responseBean.GBcreateCmsContOffLinkV1Response.Nbsapdpo  = new GBcreateCmsContOffLinkV1_Resp_IB_v1.Nbsapdpo();
        responseBean.GBcreateCmsContOffLinkV1Response.nbsmsgo3  = new GBcreateCmsContOffLinkV1_Resp_IB_v1.Nbsmsgo3();
      //  responseBean.GBcreateCmsContOffLinkV1Response.MsgEntry  = new GBcreateCmsContOffLinkV1_Resp_IB_v1.MsgEntry();
        responseBean.GBcreateCmsContOffLinkV1Response.gsp020o  = new GBcreateCmsContOffLinkV1_Resp_IB_v1.Gsp020o();
        
        responseBean.status = 'Success';
        responseBean.statusCode = 200;
        responseBean.message = '';
        responseBean.GBcreateCmsContOffLinkV1Response.Nbsapdpo.reasonCode = '0';
        responseBean.GBcreateCmsContOffLinkV1Response.Nbsapdpo.returnCode = '0';
        responseBean.GBcreateCmsContOffLinkV1Response.Nbsapdpo.serviceVersion = 'BUSO001' ;

       
        responseBean.GBcreateCmsContOffLinkV1Response.nbsmsgo3.nbrUserErrs = '0';
        responseBean.GBcreateCmsContOffLinkV1Response.nbsmsgo3.nbrUserMsgs = '0';
        
          
        
        responseBean.GBcreateCmsContOffLinkV1Response.gsp020o.confirmation = 'CAPTURED';

        
           return responseBean;
    }


}