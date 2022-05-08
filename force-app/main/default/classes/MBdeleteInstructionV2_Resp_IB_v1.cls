/*
 * Response Integration Bean for MBdeleteInstructionV2 Service
 * @author Rudolf Niehaus
 * @created 2020-03-21
 */

public class MBdeleteInstructionV2_Resp_IB_v1 extends Base_IB {

    public String status;
    public Integer statusCode;
    public String message;

	public MBdeleteInstructionV2Response MBdeleteInstructionV2Response;

	public class Nbsapdpo {
		public String returnCode;
		public String reasonCode;
		public String serviceVersion;
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

	public class MBdeleteInstructionV2Response {
		public Nbsapdpo nbsapdpo;
		public Nbsmsgo nbsmsgo;
		public Mbp306o mbp306o;
	}

	public class Mbp306o {
		
		public String channel;
		public String todaysDate;
		public String timeNow;
		public String respCode;
		public String respDesc;
		public String cifKey;
		public String tieb;
		public String instrType;
		public String instrNo;
		public String multiNo;
		public String uniqueEft;
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
	}

}