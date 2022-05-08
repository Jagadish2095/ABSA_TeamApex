/**
 * Response Integration Bean for MbCreateInstructionV2 Service
 * @author Englarmerdge Mongwe
 * @created 2020-12-07
 */
public class MbCreateInstructionV2_Resp_IB_v1 extends Base_IB {
    public Nbsapdpo nbsapdpo;
	public Nbsmsgo nbsmsgo;
    public Mbp304o mbp304o;

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
		public List<MsgEntry> msgEntry;
	}

	public class MsgEntry {
		public String msgClass;
		public String msgCode;
		public String msgErrInd;
		public String msgTxt;
	}

	public class Mbp304o {
		public String todaysDate;
		public String timeNow;
		public String respCode;
		public String respOther;
		public String recsReturn;
		public String respDesc;
		public String instrTypeDrcr;
		public String instrTypeDuepe;
		public String instrTypeAccs;
		public String fwWarnInd;
		public String instrNo;
		public String multiNo;
		public String intExtBenInd;
		public String actDate;
		public String trigDate;
		public String srcAcc;
		public String srcAccType;
		public String srcClrCode;
		public String srcInstCode;
		public String trgAcc;
		public String trgAccType;
		public String trgClrCode;
		public String trgInstCode;
		public String corpCode;
		public String sbu;
		public String clientType;
		public String iipAllowInd;
		public String lastChangeNo;
		public String lastMaintFunc;
		public String changeNo;
		public String changeSet;
		public String changeDate;
		public String changeTime;
		public String changeFunc;
		public String changeBranch;
		public String changeTeller;
		public String changeOverride;
	}
}