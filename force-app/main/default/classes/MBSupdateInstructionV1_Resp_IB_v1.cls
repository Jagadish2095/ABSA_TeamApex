/*
 * Response Integration Bean for MBupdateInstructionV1 Service
 * @author Rudolf Niehaus
 * @created 2020-05-16
 */

public class MBSupdateInstructionV1_Resp_IB_v1 extends Base_IB {

    public String status;
    public Integer statusCode;
    public String message;

	public MBupdateInstructionV1Response MBupdateInstructionV1Response;

	public class Nbsapdpo {
		public String returnCode;
		public String reasonCode;
		public String serviceVersion;
	}

	public class Nbsmsgo {
		public String version;
		public String nbrUserMsgs;
		public String nbrUserErrs;
	}

	public class Mbp300o {
		public String channel;
		public String maxRetrieve;
		public String origType;
		public String origStatus;
		public String todaysDate;
		public String timeNow;
		public String respCode;
		public String respOther;
		public String recsReturn;
		public String respDesc;
		public String fwWarnInd;
		public String accessAcc;
		public String cifKey;
		public String tieb;
		public String instrType;
		public String instrNo;
		public String multiNo;
		public String uniqueEft;
		public String instrStatus;
		public String ivrNominate;
		public String intExtBenInd;
		public String actDate;
		public String trigDate;
		public String startDate;
		public String endDate;
		public String freq;
		public String amount;
		public String instrRefName;
		public String srcAcc;
		public String srcAccType;
		public String srcClrCode;
		public String srcInstCode;
		public String srcStmtRef;
		public String trgAcc;
		public String trgAccType;
		public String trgClrCode;
		public String trgInstCode;
		public String trgStmtRef;
		public String trgBusinessCode;
		public String corpCode;
		public String sbu;
		public String clientType;
		public String prelBypass;
		public String minPayAmnt;
		public String maxPayAmnt;
		public String payDay;
		public String doType;
		public String chqFlag;
		public String freeBankInd;
		public String priNo;
		public String mandNo;
		public String pinAuth;
		public String retryDate;
		public String retryAmount;
		public String retryCount;
		public String timeRange;
		public String verifTemplate;
		public String cardAuth;
		public String acbUserCode;
		public String acbUcIndex;
		public String creditTrack;
		public String notifInd;
		public String srcFaxCode;
		public String srcFaxNo;
		public String srcFaxText;
		public String srcCellCode;
		public String srcCellNo;
		public String srcCellText;
		public String srcEmailAddr;
		public String srcEmailText;
		public String srcNotifMed;
		public String trgFaxCode;
		public String trgFaxNo;
		public String trgFaxText;
		public String trgCellCode;
		public String trgCellNo;
		public String trgCellText;
		public String trgEmailAddr;
		public String trgEmailText;
		public String trgNotifMed;
		public String iipAllowInd;
		public String lastChangeNo;
		public String lastMaintFunc;
		public String lastMaintDate;
		public String lastMaintTime;
		public String lastMaintBrnch;
		public String lastMaintTell;
		public String lastMaintOvrId;
		public String lastMaintOvr2Id;
		public String lastPaymDate;
		public String lastPaymAmnt;
		public String lastPaymErr;
		public String userNumber;
		public String firstName;
		public String surname;
		public String streetAddress;
		public String city;
		public String state;
		public String country;
	}

	public class MBupdateInstructionV1Response {
		public Nbsapdpo nbsapdpo;
		public Nbsmsgo nbsmsgo;
		public Mbp300o mbp300o;
	}
}