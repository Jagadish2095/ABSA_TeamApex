/*
 * Integration Utility class for MBlistInstructionsPerSourceAccV1 Service
 * @author Mashudu Raidimi
 * @created 2020-08-11
 */
public class MBlistInstructionsPerSrcAccV1_IU_v1 {

    
    public static MBlistInstructionsPerSrcAccV1_Req_IB_v1 mapRequestFields(String  cifKeyP,String srcAccP){
        
        MBlistInstructionsPerSrcAccV1_Req_IB_v1 bean =  new MBlistInstructionsPerSrcAccV1_Req_IB_v1();
        bean.MBlistInstructionsPerSourceAccV1 = new MBlistInstructionsPerSrcAccV1_Req_IB_v1.MBlistInstructionsPerSourceAccV1();
        bean.MBlistInstructionsPerSourceAccV1.mbs326i = new MBlistInstructionsPerSrcAccV1_Req_IB_v1.mbs326i();
        bean.MBlistInstructionsPerSourceAccV1.nbsapdpi = new MBlistInstructionsPerSrcAccV1_Req_IB_v1.nbsapdpi();
        bean.MBlistInstructionsPerSourceAccV1.nbsmsgi = new MBlistInstructionsPerSrcAccV1_Req_IB_v1.nbsmsgi();
        bean.MBlistInstructionsPerSourceAccV1.nbsmsgi.finalMsgId = new MBlistInstructionsPerSrcAccV1_Req_IB_v1.finalMsgId();
        
        bean.MBlistInstructionsPerSourceAccV1.mbs326i.processInd = '';
		bean.MBlistInstructionsPerSourceAccV1.mbs326i.cifKey = cifKeyP;
		bean.MBlistInstructionsPerSourceAccV1.mbs326i.altTieb = '0';
		bean.MBlistInstructionsPerSourceAccV1.mbs326i.tieb = '27';
		bean.MBlistInstructionsPerSourceAccV1.mbs326i.origStatus = '';
		bean.MBlistInstructionsPerSourceAccV1.mbs326i.instrType = 'VP';
		bean.MBlistInstructionsPerSourceAccV1.mbs326i.origType = '';
		bean.MBlistInstructionsPerSourceAccV1.mbs326i.instrNo = '54';
		bean.MBlistInstructionsPerSourceAccV1.mbs326i.maxRetrieve = '50';
		bean.MBlistInstructionsPerSourceAccV1.mbs326i.multiNo = '0';
		bean.MBlistInstructionsPerSourceAccV1.mbs326i.ichannel = 'SALESFOR';
		bean.MBlistInstructionsPerSourceAccV1.mbs326i.instrStatus = 'CURRENT';
		bean.MBlistInstructionsPerSourceAccV1.mbs326i.srcAcc = srcAccP;

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