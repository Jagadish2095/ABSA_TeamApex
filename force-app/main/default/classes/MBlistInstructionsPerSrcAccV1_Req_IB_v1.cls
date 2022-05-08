/*
 * Request Integration Bean for MBlistInstructionsPerSourceAccV1 Service
 * @author Mashudu Raidimi
 * @created 2020-08-11
 */

public class MBlistInstructionsPerSrcAccV1_Req_IB_v1 extends Base_IB{
    
    public MBlistInstructionsPerSourceAccV1 MBlistInstructionsPerSourceAccV1;
    public class MBlistInstructionsPerSourceAccV1{
		public nbsmsgi nbsmsgi;
		public mbs326i mbs326i;
		public nbsapdpi nbsapdpi;
	}
    
	public class nbsmsgi{
		public String msgLanguage;
		public finalMsgId finalMsgId;
		public String msgTarget;
	}
	public class nbsapdpi{
		public String trace;
		public String application;
		public String channel;
	}
	public class mbs326i{
		public String processInd;
		public String cifKey;
		public String altTieb;
		public String tieb;
		public String origStatus;
		public String instrType;
		public String origType;
		public String instrNo;
		public String maxRetrieve;
		public String multiNo;
		public String ichannel;
		public String instrStatus;
		public String srcAcc;
	}
	
	public class finalMsgId{
		public String finalMsgCode;
		public String finalMsgClass;
	}
    
    public static MBlistInstructionsPerSrcAccV1_Req_IB_v1  dummyRequest(){
        
        MBlistInstructionsPerSrcAccV1_Req_IB_v1 bean =  new MBlistInstructionsPerSrcAccV1_Req_IB_v1();
        bean.MBlistInstructionsPerSourceAccV1 = new MBlistInstructionsPerSrcAccV1_Req_IB_v1.MBlistInstructionsPerSourceAccV1();
        bean.MBlistInstructionsPerSourceAccV1.mbs326i = new MBlistInstructionsPerSrcAccV1_Req_IB_v1.mbs326i();
        bean.MBlistInstructionsPerSourceAccV1.nbsapdpi = new MBlistInstructionsPerSrcAccV1_Req_IB_v1.nbsapdpi();
        bean.MBlistInstructionsPerSourceAccV1.nbsmsgi = new MBlistInstructionsPerSrcAccV1_Req_IB_v1.nbsmsgi();
        bean.MBlistInstructionsPerSourceAccV1.nbsmsgi.finalMsgId = new MBlistInstructionsPerSrcAccV1_Req_IB_v1.finalMsgId();
        
        
        bean.MBlistInstructionsPerSourceAccV1.mbs326i.processInd = '';
		bean.MBlistInstructionsPerSourceAccV1.mbs326i.cifKey = 'PIERIDO001';
		bean.MBlistInstructionsPerSourceAccV1.mbs326i.altTieb = '0';
		bean.MBlistInstructionsPerSourceAccV1.mbs326i.tieb = '0';
		bean.MBlistInstructionsPerSourceAccV1.mbs326i.origStatus = '';
		bean.MBlistInstructionsPerSourceAccV1.mbs326i.instrType = 'VP';
		bean.MBlistInstructionsPerSourceAccV1.mbs326i.origType = '';
		bean.MBlistInstructionsPerSourceAccV1.mbs326i.instrNo = '0';
		bean.MBlistInstructionsPerSourceAccV1.mbs326i.maxRetrieve = '50';
		bean.MBlistInstructionsPerSourceAccV1.mbs326i.multiNo = '0';
		bean.MBlistInstructionsPerSourceAccV1.mbs326i.ichannel = 'SALESFOR';
		bean.MBlistInstructionsPerSourceAccV1.mbs326i.instrStatus = 'CURRENT';
		bean.MBlistInstructionsPerSourceAccV1.mbs326i.srcAcc = '04451450000062516';

        bean.MBlistInstructionsPerSourceAccV1.nbsapdpi.trace = 'Y';
		bean.MBlistInstructionsPerSourceAccV1.nbsapdpi.application = 'SALESFOR';
		bean.MBlistInstructionsPerSourceAccV1.nbsapdpi.channel = 'SALESFOR';
        
        bean.MBlistInstructionsPerSourceAccV1.nbsmsgi.msgLanguage = 'E';
        bean.MBlistInstructionsPerSourceAccV1.nbsmsgi.msgTarget = 'STD';
        bean.MBlistInstructionsPerSourceAccV1.nbsmsgi.finalMsgId.finalMsgClass = '';
        bean.MBlistInstructionsPerSourceAccV1.nbsmsgi.finalMsgId.finalMsgCode = '';
        
        return bean;
        
    }

}