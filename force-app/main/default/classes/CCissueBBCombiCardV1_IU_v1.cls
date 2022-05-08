public class CCissueBBCombiCardV1_IU_v1 {

    public static CCissueBBCombiCardV1_Req_IB_v1 mapRequestFields(String consumerId,String clntCode,String acctNbr,String prodCode,String brandNbr,String sbuCode,
                                                                 String secClntCde,String persInd, String nameInd, String nomCheq, String nomSavs, String delvMethod,
                                                                 String blindInd){
                                                                     
        CCissueBBCombiCardV1_Req_IB_v1 requestBean = new CCissueBBCombiCardV1_Req_IB_v1();
        requestBean.CCissueBBCombiCardV1 = new CCissueBBCombiCardV1_Req_IB_v1.CCissueBBCombiCardV1();
        requestBean.CCissueBBCombiCardV1.nbsapdpi = new CCissueBBCombiCardV1_Req_IB_v1.Nbsapdpi();
        requestBean.CCissueBBCombiCardV1.nbsmsgi = new CCissueBBCombiCardV1_Req_IB_v1.Nbsmsgi();
        requestBean.CCissueBBCombiCardV1.ccp868i = new CCissueBBCombiCardV1_Req_IB_v1.Ccp868i();
        CCissueBBCombiCardV1_Req_IB_v1.FinalMsgId finalMsgIdBean = new CCissueBBCombiCardV1_Req_IB_v1.FinalMsgId();
        
        //get the current user
        User currentUser = new UsersSelector().selectById(Userinfo.getUserId());
        
        requestBean.CCissueBBCombiCardV1.nbsapdpi.channel = 'BDP';
        requestBean.CCissueBBCombiCardV1.nbsapdpi.application = 'BDP';
        requestBean.CCissueBBCombiCardV1.nbsapdpi.trace = 'Y';
        
        finalMsgIdBean.finalMsgClass = '';
        finalMsgIdBean.finalMsgCode = '';
        requestBean.CCissueBBCombiCardV1.nbsmsgi.msgLanguage = 'E';
        requestBean.CCissueBBCombiCardV1.nbsmsgi.msgTarget = 'STD';
        requestBean.CCissueBBCombiCardV1.nbsmsgi.finalMsgId = finalMsgIdBean; 
        
        requestBean.CCissueBBCombiCardV1.ccp868i.tellerCode = currentUser.Teller_Operator_Code__c;//'999999';
        requestBean.CCissueBBCombiCardV1.ccp868i.workStation = '99';
        requestBean.CCissueBBCombiCardV1.ccp868i.supervisor = currentUser.Supervisor__c;//'999999';
        requestBean.CCissueBBCombiCardV1.ccp868i.branchCode = currentUser.SiteCode__c;//'8913';
        requestBean.CCissueBBCombiCardV1.ccp868i.consumerId = 'ESP';
        requestBean.CCissueBBCombiCardV1.ccp868i.clntCode = 'BBBBDO 008';//CIF code
        requestBean.CCissueBBCombiCardV1.ccp868i.acctNbr = '1033081801';//policy Number from OpportunityLineItem
        requestBean.CCissueBBCombiCardV1.ccp868i.prodCode = '11016';
        requestBean.CCissueBBCombiCardV1.ccp868i.brandNbr = '231';
        requestBean.CCissueBBCombiCardV1.ccp868i.issueBranch = currentUser.SiteCode__c;//'8913';
        requestBean.CCissueBBCombiCardV1.ccp868i.sbuCode = 'H';
        requestBean.CCissueBBCombiCardV1.ccp868i.secClntCde = 'BBOYS  001';
        requestBean.CCissueBBCombiCardV1.ccp868i.persInd = 'Y';
        requestBean.CCissueBBCombiCardV1.ccp868i.nameInd = 'B';
        requestBean.CCissueBBCombiCardV1.ccp868i.nomCheq = '1033081801';
        requestBean.CCissueBBCombiCardV1.ccp868i.nomSavs = '0';
        requestBean.CCissueBBCombiCardV1.ccp868i.delvMethod = 'B';
        requestBean.CCissueBBCombiCardV1.ccp868i.delvBranch = currentUser.SiteCode__c;//'8913';
        requestBean.CCissueBBCombiCardV1.ccp868i.blindInd = '0';
        
        return requestBean;
        
    }
    
}