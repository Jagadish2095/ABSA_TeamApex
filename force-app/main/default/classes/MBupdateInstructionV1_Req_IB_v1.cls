/*
* Request Integration Bean for MBupdateInstructionV1 Service
* @author Rudolf Niehaus
* @created 2020-03-20
*/

public class MBupdateInstructionV1_Req_IB_v1 extends Base_IB {

	public MBupdateInstructionV1 MBupdateInstructionV1;

    public class MBupdateInstructionV1 {
		public Nbsapdpi nbsapdpi;
		public Nbsmsgi nbsmsgi;
		public Mbp300i mbp300i;
	}

	public class FinalMsgId {
		public String finalMsgClass;
		public String finalMsgCode;
	}

	public class Nbsapdpi {
		public String channel;
		public String application;
		public String trace;
	}

	public class Mbp300i {
		public String channel;
		public String maxRetrieve;
		public String confirmInd;
		public String updateLevel;
		public String ivrCustNo;
        public String ivrNominate;
		public String cifKey;
		public String tieb;
		public String instrType;
		public String instrNo;
		public String multiNo;
		public String instrStatus;
		public String actDate;
		public String startDate;
		public String instrRefName;
		public String srcAcc;
		public String srcAccType;
		public String srcClrCode;
		public String srcStmtRef;
		public String trgAcc;
		public String trgAccType;
		public String trgClrCode;
		public String trgStmtRef;
		public String lastMaintFunc;
		public String lastMaintDate;
		public String lastMaintTime;
		public String lastMaintBrnch;
		public String lastMaintTell;
         public String amount; //added by lulu
	}

	public class Nbsmsgi {
		public String msgLanguage;
		public String msgTarget;
		public FinalMsgId finalMsgId;
	}
    
    public static MBupdateInstructionV1_Req_IB_v1 createDummyRequest() {
        
        MBupdateInstructionV1_Req_IB_v1 requestBean = new MBupdateInstructionV1_Req_IB_v1();
        requestBean.MBupdateInstructionV1 = new MBupdateInstructionV1_Req_IB_v1.MBupdateInstructionV1();
        requestBean.MBupdateInstructionV1.nbsapdpi = new MBupdateInstructionV1_Req_IB_v1.Nbsapdpi();
        requestBean.MBupdateInstructionV1.nbsmsgi = new MBupdateInstructionV1_Req_IB_v1.Nbsmsgi();
        requestBean.MBupdateInstructionV1.mbp300i = new MBupdateInstructionV1_Req_IB_v1.Mbp300i();
		requestBean.MBupdateInstructionV1.nbsmsgi.finalMsgId = new MBupdateInstructionV1_Req_IB_v1.FinalMsgId();

        requestBean.MBupdateInstructionV1.nbsapdpi.channel = 'SALESFOR';
        requestBean.MBupdateInstructionV1.nbsapdpi.application = 'SALESFOR';
        requestBean.MBupdateInstructionV1.nbsapdpi.trace = 'Y';
		
		requestBean.MBupdateInstructionV1.nbsmsgi.msgLanguage = 'E';
		requestBean.MBupdateInstructionV1.nbsmsgi.msgTarget = 'STD';
		requestBean.MBupdateInstructionV1.nbsmsgi.finalMsgId.finalMsgClass = '';
		requestBean.MBupdateInstructionV1.nbsmsgi.finalMsgId.finalMsgCode = '';

		requestBean.MBupdateInstructionV1.mbp300i.channel = 'SALESFOR';
		requestBean.MBupdateInstructionV1.mbp300i.maxRetrieve = '1';
		requestBean.MBupdateInstructionV1.mbp300i.confirmInd = 'C';
		requestBean.MBupdateInstructionV1.mbp300i.updateLevel = 'F';
		requestBean.MBupdateInstructionV1.mbp300i.ivrCustNo = '0';
		requestBean.MBupdateInstructionV1.mbp300i.cifKey = 'ZUMAD  001';
		requestBean.MBupdateInstructionV1.mbp300i.tieb = '0';
		requestBean.MBupdateInstructionV1.mbp300i.instrType = 'VP';
		requestBean.MBupdateInstructionV1.mbp300i.instrNo = '50';
		requestBean.MBupdateInstructionV1.mbp300i.multiNo = '0';
		requestBean.MBupdateInstructionV1.mbp300i.instrStatus = 'CURRENT';
		requestBean.MBupdateInstructionV1.mbp300i.actDate = '20200310';
		requestBean.MBupdateInstructionV1.mbp300i.startDate = '20200310';
		requestBean.MBupdateInstructionV1.mbp300i.instrRefName = '2021';
		requestBean.MBupdateInstructionV1.mbp300i.srcAcc = '4048017641';
		requestBean.MBupdateInstructionV1.mbp300i.srcAccType = '02';
		requestBean.MBupdateInstructionV1.mbp300i.srcClrCode = '632005a';
		requestBean.MBupdateInstructionV1.mbp300i.srcStmtRef = '2021';
		requestBean.MBupdateInstructionV1.mbp300i.trgAcc = '62001847237';
		requestBean.MBupdateInstructionV1.mbp300i.trgAccType = '02';
		requestBean.MBupdateInstructionV1.mbp300i.trgClrCode = '250655a';
		requestBean.MBupdateInstructionV1.mbp300i.trgStmtRef = '2021';
		requestBean.MBupdateInstructionV1.mbp300i.lastMaintFunc = '';
		requestBean.MBupdateInstructionV1.mbp300i.lastMaintDate = '0';
		requestBean.MBupdateInstructionV1.mbp300i.lastMaintTime = '0';
		requestBean.MBupdateInstructionV1.mbp300i.lastMaintBrnch = '8089a';
		requestBean.MBupdateInstructionV1.mbp300i.lastMaintTell = '11332a';
        
        return requestBean;
    }
}