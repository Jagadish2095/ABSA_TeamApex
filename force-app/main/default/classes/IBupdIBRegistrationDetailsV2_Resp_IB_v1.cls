/*
 * Response Integration Bean for IBupdIBRegistrationDetailsV2 Service
 * @author Linda Motaung
 * @created 2020-10-15
 */

public class IBupdIBRegistrationDetailsV2_Resp_IB_v1 extends Base_IB {

	public IBupdIBRegistrationDetailsV2Response IBupdIBRegistrationDetailsV2Response;
	
	public class Nbsapdpo {
		public String echoKey;
		public Integer reasonCode;
		public Integer returnCode;
		public String serviceVersion;
		public String version;
	}

	public class IBupdIBRegistrationDetailsV2Response {
		public Nbsapdpo nbsapdpo;
		public Nbsmsgo3 nbsmsgo3;
		public Fault Fault;
	}

	public class Nbsmsgo3 {
		public MsgEntry msgEntry;
		public Integer nbrUserErrs;
		public Integer nbrUserMsgs;
		public String sysErrTxt;
		public String version;
	}

	public class MsgEntry {
		public String msgClass;
		public String msgCode;
		public String msgErrInd;
		public String msgTxt;
	}

	public class Fault {
		public String faultcode;
		public String faultstring;
	}

	public override void setFieldNameSubstitutions() {
		fieldNameSubstitutionMap = new Map<String, String>();
		fieldNameSubstitutionMap.put('"number":', '"z_number":');        
	}
}