/**
 * Integration Response for MBinitiatePaymentV12 Service
 * @author Almas Aleem
 * @created 2020-12-15
 */
public class MBinitiatePaymentV12_Resp_IB_v1 extends Base_IB{
    public class Nbsapdpo {
		public String version;
		public String returnCode;
		public String reasonCode;
		public String serviceVersion;
		public String echoKey;
	}

	public Nbsapdpo nbsapdpo;
	public Nbsmsgo3 nbsmsgo3;
	public Mbp301o mbp301o;

	public class Nbsmsgo3 {
		public String version;
		public String sysErrTxt;
		public String nbrUserMsgs;
		public String nbrUserErrs;
		public List<MsgEntry> msgEntry;
	}

	public class Mbp301o {
		public String todaysDate;
		public String timeNow;
		public String respCode;
		public String respOther;
		public String recsReturn;
		public String respDesc;
		public String instrTypeDrcr;
		public String instrTypeDuepe;
		public String instrTypeAccs;
		public String keyFormat;
		public String fwWarnInd;
		public String uniqueEft;
		public String intExtBenInd;
		public String actDate;
		public String trigDate;
		public String startDate;
		public String endDate;
		public String freq;
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
		public String minPayAmnt;
		public String maxPayAmnt;
		public String iipAllowInd;
		public String lastChangeNo;
		public String lastMaintFunc;
		public String lastMaintDate;
		public String lastMaintTime;
		public String lastMaintBrnch;
		public String lastMaintTell;
		public String lastMaintOvrId;
		public String paymNo;
		public String paymBusRef;
		public String lastMaintOvr2Id;
		public String lastPaymDate;
		public String lastPaymAmnt;
		public String lastPaymErr;
		public String abal;
		public String avbl;
		public String statusCde;
		public String statusIndx;
		public String statusDesc;
		public String primEvno;
		public String secEvno;
		public String emvscScriptDataLgth;
		public String emvscScriptData;
		public String productsSpa;
		public String initpaymOverride;
		public String benGender;
		public String benNonResStat;
		public String exref;
	}

	public class MsgEntry {
		public String msgClass;
		public String msgCode;
		public String msgErrInd;
		public String msgTxt;
	}

}