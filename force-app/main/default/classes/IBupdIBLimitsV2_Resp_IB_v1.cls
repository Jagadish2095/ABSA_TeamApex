/**
 * @description IBupdIBLimitsV2_Resp_IB_v1
 */
public class IBupdIBLimitsV2_Resp_IB_v1 extends Base_IB {
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
	 * @description Nbsmsgo3
	 */
	public class Nbsmsgo3 {
		public String version;
		public String sysErrTxt;
		public String nbrUserMsgs;
		public String nbrUserErrs;
	}
	/**
	 * @description IBupdIBLimitsV2Response
	 */
	public class IBupdIBLimitsV2Response {
		public Nbsapdpo nbsapdpo;
		public Nbsmsgo3 nbsmsgo3;
	}

	public IBupdIBLimitsV2Response IBupdIBLimitsV2Response;
}