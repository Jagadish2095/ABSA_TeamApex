/**
 * Request Integration Bean for MbCreateInstructionV2 Service
 * @author Englarmerdge Mongwe
 * @created 2020-12-07
 */
public class MbCreateInstructionV2_Req_IB_v1 extends Base_IB {
    public MBcreateInstructionV2 MBcreateInstructionV2;
    
    public class MBcreateInstructionV2 {
        public Nbsapdpi nbsapdpi;
        public Nbsmsgi nbsmsgi;
        public Mbp304i mbp304i;
    }
    
	public class Nbsapdpi {
		public String channel;
		public String application;
		public String trace;
	}

	public class Nbsmsgi {
		public String msgLanguage;
		public String msgTarget;
		public FinalMsgId finalMsgId;
    }

    public class FinalMsgId {
		public String finalMsgClass;
		public String finalMsgCode;
	}

    public class Mbp304i {
		public String channel;
		public String function;
		public String maxRetrieve;
		public String confirmInd;
		public String futureInd;
		public String accessAcc;
		public String instrType;
		public String actDate;
		public String startDate;
		public String endDate;
		public String freq;
		public String amount;
		public String instrRefName;
		public String srcAcc;
		public String srcAccType;
		public String srcClrCode;
		public String srcStmtRef;
		public String trgAcc;
		public String trgAccType;
		public String trgClrCode;
		public String trgStmtRef;
		public String trgBusinessCode;
		public String minPayAmnt;
		public String maxPayAmnt;
		public String payDay;
		public String doType;
		public String chqFlag;
		public String priNo;
		public String mandNo;
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
		public String lastMaintBrnch;
		public String lastMaintTell;
		public String lastMaintOvrId;
		public String cardAuth;
		public String lastMaintOvr2Id;
    }

    public static MbCreateInstructionV2_Req_IB_v1 createDummyRequest() {
        String jsonString = '{"MBcreateInstructionV2":{"nbsmsgi":{"msgTarget":"STD","msgLanguage":"E","finalMsgId":{"finalMsgCode":"","finalMsgClass":""}},"nbsapdpi":{"trace":"N","channel":"SALESFOR","application":"SALESFOR"},"mbp304i":{"trgAcc":"4048154875","startDate":"20201218","srcStmtRef":"zuma","srcClrCode":"632005","srcAccType":"01","srcAcc":"4048017641","maxRetrieve":"1","mandNo":"","lastMaintTell":"017464","lastMaintOvrId":"999999","lastMaintBrnch":"5746","instrType":"OOP","iipAllowInd":"","function":"CREATE","endDate":"","doType":"DA","confirmInd":"A","chqFlag":"N","channel":"ESP","actDate":"20201218"}}}}';
        MbCreateInstructionV2_Req_IB_v1 requestBean = (MbCreateInstructionV2_Req_IB_v1)JSON.deserializeStrict(jsonString, MbCreateInstructionV2_Req_IB_v1.class);

        return requestBean;
    }
}