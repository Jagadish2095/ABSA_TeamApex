public class CCIssueV2_IU_v1 {
    
    public static CCIssueV2_Req_IB_v1 mapRequestFields(String agencyCode, String persInd, String cardNbr, String clientCode, String brandNbr, 
                                                      String prodCode, String autoLink, String nomCheq, String nomSavs, String nomCred, String pinReqdInd,
                                                      String cardFee, String lostFee, String idPspInd, String idPspNbr, String cardTypInd){
        
 CCIssueV2_Req_IB_v1 requestBean = new CCIssueV2_Req_IB_v1();
        
        requestBean.CCIssueV2 = new CCIssueV2_Req_IB_v1.CCIssueV2();
        requestBean.CCIssueV2.nbsapdpi = new CCIssueV2_Req_IB_v1.Nbsapdpi();
        requestBean.CCIssueV2.nbsmsgi = new CCIssueV2_Req_IB_v1.Nbsmsgi();
        requestBean.CCIssueV2.ccp311i = new CCIssueV2_Req_IB_v1.Ccp311i();
        CCIssueV2_Req_IB_v1.FinalMsgId finalMsgIdBean = new CCIssueV2_Req_IB_v1.FinalMsgId();
        
        //get the current user
        User currentUser = new UsersSelector().selectById(Userinfo.getUserId());
       
        
        requestBean.CCIssueV2.nbsapdpi.channel = 'I';
        requestBean.CCIssueV2.nbsapdpi.trace = 'Y';
        
        requestBean.CCIssueV2.nbsmsgi.msgLanguage = 'E';
        requestBean.CCIssueV2.nbsmsgi.msgTarget = 'ABI';
        requestBean.CCIssueV2.nbsmsgi.finalMsgId = finalMsgIdBean;

        requestBean.CCIssueV2.ccp311i.tellerCode = currentUser.Teller_Operator_Code__c;//'11012';
        requestBean.CCIssueV2.ccp311i.supervisor = currentUser.Supervisor__c;//'11012';
        requestBean.CCIssueV2.ccp311i.branchCode = currentUser.SiteCode__c;//'8198';
        requestBean.CCIssueV2.ccp311i.agencyCode = agencyCode;//'6003';
        requestBean.CCIssueV2.ccp311i.cardReqdInd = 'N';//Edmore advised that we can keep this as N
        requestBean.CCIssueV2.ccp311i.persInd = persInd;//'N';
        requestBean.CCIssueV2.ccp311i.cardNbr = cardNbr;//'0';
        requestBean.CCIssueV2.ccp311i.clientCode = clientCode;//'WALINM 001'; CIF Number
        requestBean.CCIssueV2.ccp311i.brandNbr = brandNbr;//'1565';Edmore to confirm the code related to values on the picklist
        requestBean.CCIssueV2.ccp311i.prodCode = prodCode;//'11032';
        requestBean.CCIssueV2.ccp311i.issueBranch = currentUser.SiteCode__c;//'8198';
        requestBean.CCIssueV2.ccp311i.autoLink = autoLink;//'N';
        requestBean.CCIssueV2.ccp311i.nomCheq = nomCheq;//'4048063812';
        requestBean.CCIssueV2.ccp311i.nomSavs = nomSavs;//'9051159122';
        requestBean.CCIssueV2.ccp311i.nomCred = nomCred;//'0';
        requestBean.CCIssueV2.ccp311i.pinReqdInd = pinReqdInd;//'N';
        requestBean.CCIssueV2.ccp311i.cardFee = cardFee;//'N'; Edmore asked that we should use checkbox to determine if we show or hide the field and this field should default to N
        requestBean.CCIssueV2.ccp311i.lostFee = lostFee;//'N';Edmore asked that we should use checkbox to determine if we show or hide the field and this field should default to N
        requestBean.CCIssueV2.ccp311i.idPspInd = idPspInd;//'P'; P = Passport and I = SA ID
        requestBean.CCIssueV2.ccp311i.idPspNbr = idPspNbr;//'sd45676'; Passport number/SA ID from selected related party.
        requestBean.CCIssueV2.ccp311i.cardTypInd = cardTypInd;//'I'; Based on the selected value on the Card Type field.

        return requestBean;

    }
    
}