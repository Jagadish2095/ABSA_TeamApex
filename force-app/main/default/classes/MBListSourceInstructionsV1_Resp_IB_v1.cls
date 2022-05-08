/*
 * Response Integration Bean for MBListSourceInstructionsV1 Service
 * @author Rudolf Niehaus
 * @created 2020-05-13
 */

public class MBListSourceInstructionsV1_Resp_IB_v1 extends Base_IB {

    public String status;
    public Integer statusCode;
    public String message;

	public MBlistSourceInstructionsV1Response MBlistSourceInstructionsV1Response;

	public class Mbn305o {
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
		public String altTieb;
		public String accessAcc;
		public List<Instruction> instruction;
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

	public class Instruction {
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
		public String clientType;
		public String payDay;
		public String doType;
		public String freeBankInd;
		public String priNo;
		public String mandNo;
		public String timeRange;
		public String creditTrack;
		public String iipAllowInd;
		public String lastMaintDate;
		public String lastMaintTell;
	}

	public class MBlistSourceInstructionsV1Response {
		public Nbsapdpo nbsapdpo;
		public Nbsmsgo nbsmsgo;
		public Mbn305o mbn305o;
	}
}