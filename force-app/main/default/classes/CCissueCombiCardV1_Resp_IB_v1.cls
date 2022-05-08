public class CCissueCombiCardV1_Resp_IB_v1 extends Base_IB {
    public String status;
    public Integer statusCode;
    public String message;
    
    public class Nbsapdpo {
		public String version;
		public String returnCode;
		public String reasonCode;
		public String serviceVersion;
		public String echoKey;
	}

	public CCissueCombiCardV1Response CCissueCombiCardV1Response;

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

	public class Ccp348o {
		public String cardIssueInd;
		public String newCombiNbr;
		public String lvpApplNbr;
		public String cardFeeInd;
		public String cardFeeType;
		public String cardFeeAmnt;
		public String delvFeeInd;
		public String delvFeeType;
		public String delvFeeAmnt;
	}

	public class CCissueCombiCardV1Response {
		public Nbsapdpo nbsapdpo;
		public Nbsmsgo3 nbsmsgo3;
		public Ccp348o ccp348o;
	}
	
	public override void setFieldNameSubstitutions() {
		fieldNameSubstitutionMap = new Map<String, String>();
		fieldNameSubstitutionMap.put('"number":', '"z_number":');        
	}
}