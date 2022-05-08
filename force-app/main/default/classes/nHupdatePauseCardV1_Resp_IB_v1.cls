/*
* Response Integration Bean for NHupdatePauseCardV1 Service
* @author Muvhuso Nekhubvi
* @created 2020/05/23
*/
public class nHupdatePauseCardV1_Resp_IB_v1 extends Base_IB {
    
    public String status;
    public Integer statusCode;
    public String message;
    
	public class Nbsapdpo {
		public String returnCode;
		public String reasonCode;
		public String serviceVersion;
		public String echoKey;
	}

	public class Nhs141o {
		public String pauseUpdated;
		public String rcde;
		public String rcdeType;
		public String rcdeSource;
		public String rcdeReason;
		public String rdesc;
	}

	public NHupdatePauseCardV1Response NHupdatePauseCardV1Response;

	public class NHupdatePauseCardV1Response {
		public Nbsapdpo nbsapdpo;
		public Nhs141o nhs141o;
	}
    public nHupdatePauseCardV1_Resp_IB_v1(){}
}