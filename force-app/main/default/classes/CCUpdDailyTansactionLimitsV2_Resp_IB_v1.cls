/*
* Response Integration Bean for CCUpdDailyTansactionLimitsV2 Service
 * @author Willy Zuvana
 * @created 2020-11-11
*/
public class CCUpdDailyTansactionLimitsV2_Resp_IB_v1 Extends Base_IB{
	
	public CCupdDailyTransactionLimitsV2Response CCupdDailyTransactionLimitsV2Response;
	
	public String status;
    public Integer statusCode;
    public String message;

    public class CCupdDailyTransactionLimitsV2Response {
		public Nbsapdpo nbsapdpo;
		public Nbsmsgo nbsmsgo;
		public Ccp321o ccp321o;
	}

	public class Nbsapdpo {
		public String version;
		public String returnCode;
		public String reasonCode;
		public String serviceVersion;
		public String echoKey;
	}

	public class Nbsmsgo {
		public String version;
		public String sysErrTxt;
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

	public class Ccp321o {
		public String limRec;
	}
}