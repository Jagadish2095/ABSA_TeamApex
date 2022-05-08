/**
 * @description       :
 * @author            : Willy zuvana
 * @last modified on  : 2021-07-21
 * @last modified by  : Willy zuvana
 * Modifications Log
 * Ver   Date         Author         Modification
 * 1.0   2021-07-21   Willy zuvana   Initial Version
**/
public class IBmaintainUserDetailsV1_Resp_IB_v1 Extends Base_IB{

    /**
    * @description Nbsapdpo
    */
	public class Nbsapdpo {
		public Object version;
		public String returnCode;
		public String reasonCode;
		public String serviceVersion;
		public Object echoKey;
	}

	/**
    * @description Nbsmsgo
    */
	public class Nbsmsgo {
		public String version;
		public String sysErrTxt;
		public String nbrUserMsgs;
		public String nbrUserErrs;
		public List<MsgEntry> msgEntry;
	}

	/**
    * @description IBmaintainUserDetailsV1Response
    */
	public class IBmaintainUserDetailsV1Response {
		public Nbsapdpo nbsapdpo;
		public Nbsmsgo nbsmsgo;
	}

	public IBmaintainUserDetailsV1Response IBmaintainUserDetailsV1Response;

	/**
    * @description MsgEntry
    */
	public class MsgEntry {
		public String msgClass;
		public String msgCode;
		public String msgErrInd;
		public String msgTxt;
	}
}