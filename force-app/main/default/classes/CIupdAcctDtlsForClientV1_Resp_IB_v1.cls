/*
 * Response Integration Bean for CIupdAcctDtlsForClientV1 Service
 * @author Rudolf Niehaus
 * @created 2020-06-05
 */

public class CIupdAcctDtlsForClientV1_Resp_IB_v1 extends Base_IB {

    public String status;
    public Integer statusCode;
    public String message;

	public CIupdAcctDtlsForClientV1Response CIupdAcctDtlsForClientV1Response;
	
	public class Nbsapdpo {
		public Object echoKey;
		public Integer reasonCode;
		public Integer returnCode;
		public String serviceVersion;
		public Object version;
	}

	public class Nbsmsgo3 {
		public List<MsgEntry> msgEntry;
		public Integer nbrUserErrs;
		public Integer nbrUserMsgs;
		public Object sysErrTxt;
		public String version;
	}

	public class CIupdAcctDtlsForClientV1Response {
		public Nbsapdpo nbsapdpo;
		public Nbsmsgo3 nbsmsgo3;
	}

	public class MsgEntry {
		public String msgClass;
		public String msgCode;
		public String msgErrInd;
		public String msgTxt;
	}
}