/*
* Response Integration Bean for NHenquiryPauseCardV1 Service
* @author Muvhuso Nekhubvi
* @created 2020/05/23
*/
public class nHenquiryPauseCardV1_Resp_IB_v1 extends Base_IB{
    
 	public String status;
    public Integer statusCode;
    public String message;
    
	public class Nhs142o {
		public String tellerCode;
		public String workStation;
		public String supervisor;
		public String branchCode;
		public String pauseHold;
		public String iatmHold;
		public String iposHold;
		public String latmHold;
		public String lposHold;
		public String cnpHold;
		public String digwHold;
		public String pauseDate;
		public String rcde;
		public String rcdeType;
		public String rcdeSource;
		public String rcdeReason;
		public String rdesc;
	}

	public class Nbsapdpo {
		public String returnCode;
		public String reasonCode;
		public String serviceVersion;
		public String echoKey;
	}

	public NHenquiryPauseCardV1Response NHenquiryPauseCardV1Response;

	public class NHenquiryPauseCardV1Response {
		public Nbsapdpo nbsapdpo;
		public Nhs142o nhs142o;
	}
    public nHenquiryPauseCardV1_Resp_IB_v1(){ }
}