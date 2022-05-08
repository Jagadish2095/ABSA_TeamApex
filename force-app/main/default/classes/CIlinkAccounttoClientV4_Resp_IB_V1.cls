/*
 * Response Integration Bean for CIlinkAccounttoClientV4 Service
 * @author Saurabh
 * @created 2020-06-03
 */


public class CIlinkAccounttoClientV4_Resp_IB_V1 extends Base_IB {

    public String status;
    public Integer statusCode;
	public String message;

	public String faultcode;
    public String faultstring;

	@auraenabled public CIlinkAccountToClientV4Response CIlinkAccountToClientV4Response;

	public class CIlinkAccountToClientV4Response {
		public Nbsapdpo nbsapdpo;
		public Nbsmsgo3 nbsmsgo3;
	}

	public class Nbsapdpo {
		public String version;
		public String returnCode;
		public String reasonCode;
		public String serviceVersion;
		public String echoKey;
	}

	public class Nbsmsgo3 {
		public String version;
		public String sysErrTxt;
		public String nbrUserMsgs;
		public String nbrUserErrs;
		public List<MsgEntry> msgEntry;
	}

	public class MsgEntry {
		public String msgClass;
		public String msgCode;
		public String msgErrInd;
		public String msgTxt;
	}
}