/*******
 * Tracy de Bruin
 * Re-wrap Service to use Jotterbit structure 
 * 17-08-2020
 * ******/
public class CreateClientCIF_Resp_IB_v1 extends Base_IB{
    public String status;
    public Integer statusCode;
    public String message;

    public UpdateJntPartByClientCode_Resp_IB_v1 updateJntPart;
    
    public class Cib003o {
		public String outputCkey;
	}

	public class CIcreateClientV12Response {
		public Nbsapdpo nbsapdpo;
		public Nbsmsgo3 nbsmsgo3;
		public Cib003o cib003o;
	}

	public class Nbsapdpo {
		public String version;
		public Integer returnCode;
		public Integer reasonCode;
		public String serviceVersion;
		public String echoKey;
	}

	public CIcreateClientV12Response CIcreateClientV12Response;

	public class Nbsmsgo3 {
		public String version;
		public String sysErrTxt;
		public Integer nbrUserMsgs;
		public Integer nbrUserErrs;
        public msgEntry msgEntry;
        public msgEntry[] msgEntries;
	}
    
    public class msgEntry {
		public String msgClass;
		public String msgCode;
		public String msgErrInd;
		public String msgTxt;
	}
    
    public Fault Fault;

	public class Fault {
		public String faultcode;
		public String faultstring;
	}
    
     public static CreateClientCIF_Resp_IB_v1 dummyResponse(){
        CreateClientCIF_Resp_IB_v1 responseBean = new CreateClientCIF_Resp_IB_v1();

        responseBean.CIcreateClientV12Response = new CreateClientCIF_Resp_IB_v1.CIcreateClientV12Response();
        responseBean.CIcreateClientV12Response.nbsapdpo = new CreateClientCIF_Resp_IB_v1.nbsapdpo();
        responseBean.CIcreateClientV12Response.nbsmsgo3 = new CreateClientCIF_Resp_IB_v1.nbsmsgo3();
        responseBean.CIcreateClientV12Response.cib003o = new CreateClientCIF_Resp_IB_v1.Cib003o();

        responseBean.status='Ok';
        responseBean.statusCode=12;
        responseBean.message='Test Message';
        responseBean.CIcreateClientV12Response.nbsapdpo.version = null;
        responseBean.CIcreateClientV12Response.nbsapdpo.returnCode = 0;
        responseBean.CIcreateClientV12Response.nbsapdpo.reasonCode = 0;
        responseBean.CIcreateClientV12Response.nbsapdpo.serviceVersion = 'BUSO009';
        responseBean.CIcreateClientV12Response.nbsapdpo.echoKey = null;

        responseBean.CIcreateClientV12Response.nbsmsgo3.version = 'MSG3001';
        responseBean.CIcreateClientV12Response.nbsmsgo3.sysErrTxt = null;
        responseBean.CIcreateClientV12Response.nbsmsgo3.nbrUserMsgs = 0;
        responseBean.CIcreateClientV12Response.nbsmsgo3.nbrUserErrs = 0;

        responseBean.CIcreateClientV12Response.cib003o.outputCkey='test1';
        
            return responseBean;
    }
}