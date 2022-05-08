/*
* Request Integration Bean for MBListSourceInstructionsV1 Service
* @author Rudolf Niehaus
* @created 2020-05-12
*/

public class MBListSourceInstructionsV1_Req_IB_v1 extends Base_IB {

	public MBListSourceInstructionsV1 MBlistSourceInstructionsV1;

    public class FinalMsgId {
		public String finalMsgClass;
		public String finalMsgCode;
	}

	public class Nbsapdpi {
		public String channel;
		public String application;
		public String trace;
	}

	public class Mbs305i {
		public String channelI;
		public String maxRetrieve;
		public String processInd;
		public String origType;
		public String origStatus;
		public String altTieb;
		public String cifKey;
		public String tieb;
		public String instrType;
		public String instrNo;
		public String multiNo;
		public String instrStatus;
		public String srcAcc;
	}

	public class MBlistSourceInstructionsV1 {
		public Nbsapdpi nbsapdpi;
		public Nbsmsgi nbsmsgi;
		public Mbs305i mbs305i;
	}

	public class Nbsmsgi {
		public String msgLanguage;
		public String msgTarget;
		public FinalMsgId finalMsgId;
	}
    
    public static MBListSourceInstructionsV1_Req_IB_v1 createDummyRequest() {
        
        MBListSourceInstructionsV1_Req_IB_v1 requestBean = new MBListSourceInstructionsV1_Req_IB_v1();
        requestBean.MBListSourceInstructionsV1 = new MBListSourceInstructionsV1_Req_IB_v1.MBListSourceInstructionsV1();
        requestBean.MBListSourceInstructionsV1.nbsapdpi = new MBListSourceInstructionsV1_Req_IB_v1.Nbsapdpi();
        requestBean.MBListSourceInstructionsV1.nbsmsgi = new MBListSourceInstructionsV1_Req_IB_v1.Nbsmsgi();
        requestBean.MBListSourceInstructionsV1.mbs305i = new MBListSourceInstructionsV1_Req_IB_v1.Mbs305i();
		requestBean.MBListSourceInstructionsV1.nbsmsgi.finalMsgId = new MBListSourceInstructionsV1_Req_IB_v1.FinalMsgId();

        requestBean.MBListSourceInstructionsV1.nbsapdpi.channel = 'SALESFOR';
        requestBean.MBListSourceInstructionsV1.nbsapdpi.application = 'SALESFOR';
        requestBean.MBListSourceInstructionsV1.nbsapdpi.trace = 'Y';
		
		requestBean.MBListSourceInstructionsV1.nbsmsgi.msgLanguage = 'E';
		requestBean.MBListSourceInstructionsV1.nbsmsgi.msgTarget = 'STD';
		requestBean.MBListSourceInstructionsV1.nbsmsgi.finalMsgId.finalMsgClass = '';
		requestBean.MBListSourceInstructionsV1.nbsmsgi.finalMsgId.finalMsgCode = '';

		requestBean.MBListSourceInstructionsV1.mbs305i.channelI = 'SALESFOR';
		requestBean.MBListSourceInstructionsV1.mbs305i.maxRetrieve = '50';
		requestBean.MBListSourceInstructionsV1.mbs305i.processInd = '';
		requestBean.MBListSourceInstructionsV1.mbs305i.origType = 'SO';
		requestBean.MBListSourceInstructionsV1.mbs305i.origStatus = 'CURRENT';
		requestBean.MBListSourceInstructionsV1.mbs305i.altTieb = '0';
		requestBean.MBListSourceInstructionsV1.mbs305i.cifKey = 'ZUMAD 001';
		requestBean.MBListSourceInstructionsV1.mbs305i.tieb = '0';
		requestBean.MBListSourceInstructionsV1.mbs305i.instrType = 'SO';
		requestBean.MBListSourceInstructionsV1.mbs305i.instrNo = '0';
		requestBean.MBListSourceInstructionsV1.mbs305i.multiNo = '0';
		requestBean.MBListSourceInstructionsV1.mbs305i.instrStatus = 'CURRENT';
		requestBean.MBListSourceInstructionsV1.mbs305i.srcAcc = '4048017641';
        
        return requestBean;
    }
}