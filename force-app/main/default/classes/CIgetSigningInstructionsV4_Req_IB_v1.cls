/*
* Request Integration Bean for CIgetSigningInstructionsV4 Service
* @author Prashant Jain
* @created 2020-03-05
*/

public class CIgetSigningInstructionsV4_Req_IB_v1 extends Base_IB {
    
    public CIgetSigningInstructionsV4 CIgetSigningInstructionsV4;
    
    public class FinalMsgId {
        public String finalMsgClass;
        public String finalMsgCode;
    }
    
    public class Nbsapdpi {
        public String channel;
        public String application;
        public String trace;
    }
    
    public class CIgetSigningInstructionsV4 {
        public Nbsapdpi nbsapdpi;
        public Nbsmsgi nbsmsgi;
        public Cip082di cip082di;
    }
    
    public class Nbsmsgi {
        public String msgLanguage;
        public String msgTarget;
        public FinalMsgId finalMsgId;
    }
    
    public class Cip082di {
        public String accountNumber;
        public String option;
        public String siteCode;
        public String maxRetrieve;
        public String restartKey;
    }
    
    public static CIgetSigningInstructionsV4_Req_IB_v1 createDummyRequest() {
        
        CIgetSigningInstructionsV4_Req_IB_v1 requestBean = new CIgetSigningInstructionsV4_Req_IB_v1();
        requestBean.CIgetSigningInstructionsV4 = new CIgetSigningInstructionsV4_Req_IB_v1.CIgetSigningInstructionsV4();
        requestBean.CIgetSigningInstructionsV4.nbsapdpi = new CIgetSigningInstructionsV4_Req_IB_v1.Nbsapdpi();
        requestBean.CIgetSigningInstructionsV4.nbsmsgi = new CIgetSigningInstructionsV4_Req_IB_v1.Nbsmsgi();
        requestBean.CIgetSigningInstructionsV4.cip082di = new CIgetSigningInstructionsV4_Req_IB_v1.Cip082di();
        
        requestBean.CIgetSigningInstructionsV4.nbsapdpi.channel = 'BPD';
        requestBean.CIgetSigningInstructionsV4.nbsapdpi.application = 'BPD';
        requestBean.CIgetSigningInstructionsV4.nbsapdpi.trace = 'Y';
        requestBean.CIgetSigningInstructionsV4.nbsmsgi.msgLanguage = 'E';
        requestBean.CIgetSigningInstructionsV4.nbsmsgi.msgTarget = 'STD';
        
        requestBean.CIgetSigningInstructionsV4.cip082di.accountNumber = '4048009098';
        requestBean.CIgetSigningInstructionsV4.cip082di.option = 'E';
        requestBean.CIgetSigningInstructionsV4.cip082di.siteCode = '8198';
        requestBean.CIgetSigningInstructionsV4.cip082di.maxRetrieve = '5';
        requestBean.CIgetSigningInstructionsV4.cip082di.restartKey = 'Y';
        
        return requestBean;
    }
}