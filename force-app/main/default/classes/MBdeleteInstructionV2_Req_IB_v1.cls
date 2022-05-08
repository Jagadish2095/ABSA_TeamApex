/*
* Request Integration Bean for MBdeleteInstructionV2 Service
* @author Rudolf Niehaus
* @created 2020-03-21
*/

public class MBdeleteInstructionV2_Req_IB_v1 extends Base_IB {

	public MBdeleteInstructionV2 MBdeleteInstructionV2;

	public class MBdeleteInstructionV2 {
		public Nbsapdpi nbsapdpi;
		public Nbsmsgi nbsmsgi;
		public Mbs306i mbs306i;
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

	public class Mbs306i {
		public String channel;
		public String cifKey;
		public String tieb;
		public String instrType;
		public String instrNo;
		public String multiNo;
		public String lastMaintBrnch;
		public String lastMaintTell;
	}

	public class Nbsmsgi {
		public String msgLanguage;
		public String msgTarget;
		public FinalMsgId finalMsgId;
	}
    
    public static MBdeleteInstructionV2_Req_IB_v1 createDummyRequest() {
        
        MBdeleteInstructionV2_Req_IB_v1 requestBean = new MBdeleteInstructionV2_Req_IB_v1();
        requestBean.MBdeleteInstructionV2 = new MBdeleteInstructionV2_Req_IB_v1.MBdeleteInstructionV2();
        requestBean.MBdeleteInstructionV2.nbsapdpi = new MBdeleteInstructionV2_Req_IB_v1.Nbsapdpi();
        requestBean.MBdeleteInstructionV2.nbsmsgi = new MBdeleteInstructionV2_Req_IB_v1.Nbsmsgi();
        requestBean.MBdeleteInstructionV2.mbs306i = new MBdeleteInstructionV2_Req_IB_v1.Mbs306i();
		requestBean.MBdeleteInstructionV2.nbsmsgi.finalMsgId = new MBdeleteInstructionV2_Req_IB_v1.FinalMsgId();

        requestBean.MBdeleteInstructionV2.nbsapdpi.channel = 'SALESFOR';
        requestBean.MBdeleteInstructionV2.nbsapdpi.application = 'SALESFOR';
        requestBean.MBdeleteInstructionV2.nbsapdpi.trace = 'Y';
		
		requestBean.MBdeleteInstructionV2.nbsmsgi.msgLanguage = 'E';
		requestBean.MBdeleteInstructionV2.nbsmsgi.msgTarget = 'STD';
		requestBean.MBdeleteInstructionV2.nbsmsgi.finalMsgId.finalMsgClass = '';
		requestBean.MBdeleteInstructionV2.nbsmsgi.finalMsgId.finalMsgCode = '';

		requestBean.MBdeleteInstructionV2.mbs306i.channel = 'SALESFOR';
		requestBean.MBdeleteInstructionV2.mbs306i.cifKey = 'ZUMAD  001';
		requestBean.MBdeleteInstructionV2.mbs306i.tieb = '0';
		requestBean.MBdeleteInstructionV2.mbs306i.instrType = 'VP';
		requestBean.MBdeleteInstructionV2.mbs306i.instrNo = '50';
		requestBean.MBdeleteInstructionV2.mbs306i.multiNo = '0';
		requestBean.MBdeleteInstructionV2.mbs306i.lastMaintBrnch = '8089a';
		requestBean.MBdeleteInstructionV2.mbs306i.lastMaintTell = '11332a';
        
        return requestBean;
    }
}