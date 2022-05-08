public class CreateTracker_Resp_IB_v1 extends Base_IB {
	public String status;
    public Integer statusCode;
    public String message;
	public cls_awp200so awp200so;
    public cls_nbsapdpo nbsapdpo;
	
	public class cls_nbsapdpo {
		public String version;
		public String returnCode;
		public String reasonCode;
		public String serviceVersion;
		public String echoKey; 
	}
	
	public class cls_awp200so {
		public String tran;
		public String func;
		public String rc;
		public String rcMessage;
		public String willNo;
		public String updateStatus;
	}
}