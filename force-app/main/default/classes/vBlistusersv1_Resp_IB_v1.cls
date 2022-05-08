/*
 * Response Integration Bean for vBlistusersv1 Service
 * @author Mashudu Raidmi
 * @created 2020-07-15
 */
public class vBlistusersv1_Resp_IB_v1 extends Base_IB {
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

	public VBlistUsersV1Response VBlistUsersV1Response;

	public class Nbsmsgo {
		public String sysErrTxt;
		public String nbrUserMsgs;
		public String nbrUserErrs;
		public MsgEntry msgEntry;
	}

	public class Vbp451o {
		public String cifKey;
		public String segCode;
		public String custId;
		public String custName;
		public String iplmMax;
		public String oplmMax;
		public String ablmMax;
		public String fdlmMax;
		public String moreUsers;
		public String numberOcc;
		public List<Users> users;
	}

	public class MsgEntry {
		public String msgClass;
		public String msgCode;
		public String msgErrInd;
		public String msgTxt;
	}

	public class Users {
		public String userNo;
		public String userName;
		public String userType;
		public String userId;
		public String userFica;
	}

	public class VBlistUsersV1Response {
		public Nbsapdpo nbsapdpo;
		public Nbsmsgo nbsmsgo;
		public Vbp451o vbp451o;
	}
    public vBlistusersv1_Resp_IB_v1(){}
}