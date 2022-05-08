/**
* Apex Integration Request Bean class for CCIssueV2 service
* @author  Mbuyiseni Mbhokane 
* @since   2020-07-27
*
**/

public class CCIssueV2_Req_IB_v1 extends Base_IB{
    
    public class CCIssueV2 {
        public Nbsapdpi nbsapdpi;
        public Nbsmsgi nbsmsgi;
        public Ccp311i ccp311i;
    }
    
    public CCIssueV2 CCIssueV2;
    
    public class FinalMsgId {
    }
    
    public class Ccp311i {
        public String tellerCode;
        public String supervisor;
        public String branchCode;
        public String agencyCode;
        public String cardReqdInd;
        public String persInd;
        public String cardNbr;
        public String clientCode;
        public String brandNbr;
        public String prodCode;
        public String issueBranch;
        public String autoLink;
        public String nomCheq;
        public String nomSavs;
        public String nomCred;
        public String pinReqdInd;
        public String cardFee;
        public String lostFee;
        public String idPspInd;
        public String idPspNbr;
        public String cardTypInd;
    }
    
    public class Nbsapdpi {
        public String channel;
        public String trace;
    }
    
    public class Nbsmsgi {
        public String msgLanguage;
        public String msgTarget;
        public FinalMsgId finalMsgId;
    }
    
    
    public static CCIssueV2_Req_IB_v1 createDummyRequest() {
        
        CCIssueV2_Req_IB_v1 requestBean = new CCIssueV2_Req_IB_v1();
        requestBean.CCIssueV2 = new CCIssueV2_Req_IB_v1.CCIssueV2();
        requestBean.CCIssueV2.nbsapdpi = new CCIssueV2_Req_IB_v1.Nbsapdpi();
        requestBean.CCIssueV2.nbsmsgi = new CCIssueV2_Req_IB_v1.Nbsmsgi();
        requestBean.CCIssueV2.ccp311i = new CCIssueV2_Req_IB_v1.Ccp311i();
        CCIssueV2_Req_IB_v1.FinalMsgId finalMsgIdBean = new CCIssueV2_Req_IB_v1.FinalMsgId();
        
        requestBean.CCIssueV2.nbsapdpi.channel = 'I';
        requestBean.CCIssueV2.nbsapdpi.trace = 'Y';
        
        requestBean.CCIssueV2.nbsmsgi.msgLanguage = 'E';
        requestBean.CCIssueV2.nbsmsgi.msgTarget = 'ABI';
        requestBean.CCIssueV2.nbsmsgi.finalMsgId = finalMsgIdBean;

        requestBean.CCIssueV2.ccp311i.tellerCode = '11012';
        requestBean.CCIssueV2.ccp311i.supervisor = '11012';
        requestBean.CCIssueV2.ccp311i.branchCode = '8198';
        requestBean.CCIssueV2.ccp311i.agencyCode = '6003';
        requestBean.CCIssueV2.ccp311i.cardReqdInd = 'N';
        requestBean.CCIssueV2.ccp311i.persInd = 'N';
        requestBean.CCIssueV2.ccp311i.cardNbr = '0';
        requestBean.CCIssueV2.ccp311i.clientCode = 'WALINM 001';
        requestBean.CCIssueV2.ccp311i.brandNbr = '1565';
        requestBean.CCIssueV2.ccp311i.prodCode = '11032';
        requestBean.CCIssueV2.ccp311i.issueBranch = '8198';
        requestBean.CCIssueV2.ccp311i.autoLink = 'N';
        requestBean.CCIssueV2.ccp311i.nomCheq = '4048063812';
        requestBean.CCIssueV2.ccp311i.nomSavs = '9051159122';
        requestBean.CCIssueV2.ccp311i.nomCred = '0';
        requestBean.CCIssueV2.ccp311i.pinReqdInd = 'N';
        requestBean.CCIssueV2.ccp311i.cardFee = 'N';
        requestBean.CCIssueV2.ccp311i.lostFee = 'N';
        requestBean.CCIssueV2.ccp311i.idPspInd = 'P';
        requestBean.CCIssueV2.ccp311i.idPspNbr = 'sd45676';
        requestBean.CCIssueV2.ccp311i.cardTypInd = 'I';

        return requestBean;
    }
    
}