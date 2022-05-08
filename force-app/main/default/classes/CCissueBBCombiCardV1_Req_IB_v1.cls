/**
* Apex Integration Request Bean class for CCissueBBCombiCardV1 service
* @author  Mbuyiseni Mbhokane 
* @since   2020-07-27
*
**/
public class CCissueBBCombiCardV1_Req_IB_v1 extends Base_IB{
    
    public CCissueBBCombiCardV1 CCissueBBCombiCardV1;
    
    public class FinalMsgId {
        public String finalMsgClass;
        public String finalMsgCode;
    }
    
    public class Nbsapdpi {
        public String channel;
        public String application;
        public String trace;
    }
    
    public class CCissueBBCombiCardV1 {
        public Nbsapdpi nbsapdpi;
        public Nbsmsgi nbsmsgi;
        public Ccp868i ccp868i;
    }
    
    public class Ccp868i {
        public String tellerCode;
        public String workStation;
        public String supervisor;
        public String branchCode;
        public String consumerId;
        public String clntCode;
        public String acctNbr;
        public String prodCode;
        public String brandNbr;
        public String issueBranch;
        public String sbuCode;
        public String secClntCde;
        public String persInd;
        public String nameInd;
        public String nomCheq;
        public String nomSavs;
        public String delvMethod;
        public String delvBranch;
        public String blindInd;
    }
    
    public class Nbsmsgi {
        public String msgLanguage;
        public String msgTarget;
        public FinalMsgId finalMsgId;
    }
    
    
    public static CCissueBBCombiCardV1_Req_IB_v1 createDummyRequest(){
        CCissueBBCombiCardV1_Req_IB_v1 requestBean = new CCissueBBCombiCardV1_Req_IB_v1();
        requestBean.CCissueBBCombiCardV1 = new CCissueBBCombiCardV1_Req_IB_v1.CCissueBBCombiCardV1();
        requestBean.CCissueBBCombiCardV1.nbsapdpi = new CCissueBBCombiCardV1_Req_IB_v1.Nbsapdpi();
        requestBean.CCissueBBCombiCardV1.nbsmsgi = new CCissueBBCombiCardV1_Req_IB_v1.Nbsmsgi();
        requestBean.CCissueBBCombiCardV1.ccp868i = new CCissueBBCombiCardV1_Req_IB_v1.Ccp868i();
        CCissueBBCombiCardV1_Req_IB_v1.FinalMsgId finalMsgIdBean = new CCissueBBCombiCardV1_Req_IB_v1.FinalMsgId();
        
        requestBean.CCissueBBCombiCardV1.nbsapdpi.channel = 'BDP';
        requestBean.CCissueBBCombiCardV1.nbsapdpi.application = 'BDP';
        requestBean.CCissueBBCombiCardV1.nbsapdpi.trace = 'Y';
        
        finalMsgIdBean.finalMsgClass = '';
        finalMsgIdBean.finalMsgCode = '';
        requestBean.CCissueBBCombiCardV1.nbsmsgi.msgLanguage = 'E';
        requestBean.CCissueBBCombiCardV1.nbsmsgi.msgTarget = 'STD';
        requestBean.CCissueBBCombiCardV1.nbsmsgi.finalMsgId = finalMsgIdBean; 
		
        requestBean.CCissueBBCombiCardV1.ccp868i.tellerCode = '999999';
        requestBean.CCissueBBCombiCardV1.ccp868i.workStation = '99';
        requestBean.CCissueBBCombiCardV1.ccp868i.supervisor = '999999';
        requestBean.CCissueBBCombiCardV1.ccp868i.branchCode = '8913';
        requestBean.CCissueBBCombiCardV1.ccp868i.consumerId = 'ESP';
        requestBean.CCissueBBCombiCardV1.ccp868i.clntCode = 'BBBBDO 008';
        requestBean.CCissueBBCombiCardV1.ccp868i.acctNbr = '1033081801';
        requestBean.CCissueBBCombiCardV1.ccp868i.prodCode = '11016';
        requestBean.CCissueBBCombiCardV1.ccp868i.brandNbr = '231';
        requestBean.CCissueBBCombiCardV1.ccp868i.issueBranch = '8913';
        requestBean.CCissueBBCombiCardV1.ccp868i.sbuCode = 'H';
        requestBean.CCissueBBCombiCardV1.ccp868i.secClntCde = 'BBOYS  001';
        requestBean.CCissueBBCombiCardV1.ccp868i.persInd = 'Y';
        requestBean.CCissueBBCombiCardV1.ccp868i.nameInd = 'B';
        requestBean.CCissueBBCombiCardV1.ccp868i.nomCheq = '1033081801';
        requestBean.CCissueBBCombiCardV1.ccp868i.nomSavs = '0';
        requestBean.CCissueBBCombiCardV1.ccp868i.delvMethod = 'B';
        requestBean.CCissueBBCombiCardV1.ccp868i.delvBranch = '8913';
        requestBean.CCissueBBCombiCardV1.ccp868i.blindInd = '0';

        return requestBean;
    }
    
}