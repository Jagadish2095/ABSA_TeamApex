/*
* Request Integration Bean for MBupdateInstructionV1 Service
* @author Rudolf Niehaus
* @created 2020-05-16
*/

public class MBSupdateInstructionV1_Req_IB_v1 extends Base_IB {

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
		public String cifKey;
		public String instrType;
		public String instrNo;
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
		public String srcStmtRef;
		public String trgAcc;
		public String trgAccType;
		public String trgClrCode;
		public String trgStmtRef;
		public String payDay;
		public String lastMaintBrnch;
		public String lastMaintTell;
	}

	public class Nbsmsgi {
		public String msgLanguage;
		public String msgTarget;
		public FinalMsgId finalMsgId;
	}
    
    public static MBSupdateInstructionV1_Req_IB_v1 createDummyRequest() {
        
        MBSupdateInstructionV1_Req_IB_v1 requestBean = new MBSupdateInstructionV1_Req_IB_v1();
        requestBean.MBupdateInstructionV1 = new MBSupdateInstructionV1_Req_IB_v1.MBupdateInstructionV1();
        requestBean.MBupdateInstructionV1.nbsapdpi = new MBSupdateInstructionV1_Req_IB_v1.Nbsapdpi();
        requestBean.MBupdateInstructionV1.nbsmsgi = new MBSupdateInstructionV1_Req_IB_v1.Nbsmsgi();
        requestBean.MBupdateInstructionV1.mbp300i = new MBSupdateInstructionV1_Req_IB_v1.Mbp300i();
		requestBean.MBupdateInstructionV1.nbsmsgi.finalMsgId = new MBSupdateInstructionV1_Req_IB_v1.FinalMsgId();

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
		requestBean.MBupdateInstructionV1.mbp300i.cifKey = 'ZUMAD  001';
		requestBean.MBupdateInstructionV1.mbp300i.instrType = 'SO';
		requestBean.MBupdateInstructionV1.mbp300i.instrNo = '3';
		requestBean.MBupdateInstructionV1.mbp300i.actDate = '20200601';
		requestBean.MBupdateInstructionV1.mbp300i.trigDate = '20200601';
		requestBean.MBupdateInstructionV1.mbp300i.startDate = '20200601';
		requestBean.MBupdateInstructionV1.mbp300i.endDate = '20207506';
		requestBean.MBupdateInstructionV1.mbp300i.freq = '1M';
		requestBean.MBupdateInstructionV1.mbp300i.amount = '200';
		requestBean.MBupdateInstructionV1.mbp300i.instrRefName = '2021';
		requestBean.MBupdateInstructionV1.mbp300i.srcAcc = '4048017641';
		requestBean.MBupdateInstructionV1.mbp300i.srcAccType = '02';
		requestBean.MBupdateInstructionV1.mbp300i.srcClrCode = '632005';
		requestBean.MBupdateInstructionV1.mbp300i.srcStmtRef = '2021';
		requestBean.MBupdateInstructionV1.mbp300i.trgAcc = ' 62001847237';
		requestBean.MBupdateInstructionV1.mbp300i.trgAccType = '02';
		requestBean.MBupdateInstructionV1.mbp300i.trgClrCode = '250655';
		requestBean.MBupdateInstructionV1.mbp300i.trgStmtRef = '2021';
		requestBean.MBupdateInstructionV1.mbp300i.payDay = '2';
		requestBean.MBupdateInstructionV1.mbp300i.lastMaintBrnch = '8089';
		requestBean.MBupdateInstructionV1.mbp300i.lastMaintTell = '11332';

        return requestBean;
    }
}