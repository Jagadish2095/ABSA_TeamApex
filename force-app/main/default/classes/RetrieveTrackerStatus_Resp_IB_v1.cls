public class RetrieveTrackerStatus_Resp_IB_v1 extends Base_IB 
{
	public String status;
    public Integer statusCode;
    public String message;
    public cls_nbsapdpo nbsapdpo;
    public cls_nbsmsgo nbsmsgo;
    public cls_awp035o awp035o;
	
	public class cls_nbsapdpo {
		public String version;
		public String returnCode;
		public String reasonCode;
		public String serviceVersion;
		public String echoKey; 
	}
	
	public class cls_nbsmsgo {
		public String version;
		public String sysErrTxt;
		public String nbrUserMsgs;
		public String nbrUserErrs;
	}
	
	public class cls_awp035o {
		public String cifKey;
		public String trackStat;
		public String recordCount;	
		public List<cls_trackerRecord> trackerRecord;
	}
	
	public class cls_trackerRecord {
		public String trackerDate;
		public String trackerUserId;
		public String trackerAction;
		public String trackerPrevId;
	}
}