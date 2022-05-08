/*
* Integration Utility Bean for get conditions of agreement
* @author Almas Aleem:Absa  
* @created 2020-12-02
*/
public class ABFupdConditionsOfAgreement_IU_v1 {
    
    public static ABFupdConditionsOfAgreement_Req_IB_v1 mapRequestFields(User user,String acctNumber,ABFupdAccountStatusV1_Resp_IB_V1 ABFresponse,String landlordWaiverInd,String insuranceInd,String elecTransferInd,String contractSigned,
                                                    Integer mandateNum,Integer tellerNum){
        
        
        ABFupdConditionsOfAgreement_Req_IB_v1 requestBean = new ABFupdConditionsOfAgreement_Req_IB_v1();
        ABFupdConditionsOfAgreement_Req_IB_v1.MessageHeaders messageHeader = new  ABFupdConditionsOfAgreement_Req_IB_v1.MessageHeaders();
        messageHeader.inputMessageHeaders = new ABFupdConditionsOfAgreement_Req_IB_v1.InputMessageHeaders();
        messageHeader.inputMessageHeaders.consumerChannel ='SF';
        messageHeader.inputMessageHeaders.providerApplication ='SF';
        messageHeader.inputMessageHeaders.traceIndicator ='Y';
        requestBean.messageHeaders = messageHeader;
        
        ABFupdConditionsOfAgreement_Req_IB_v1.MessageIndicator messageIndicator = new  ABFupdConditionsOfAgreement_Req_IB_v1.MessageIndicator();
        messageIndicator.inputMessageIndicator = new ABFupdConditionsOfAgreement_Req_IB_v1.InputMessageIndicator();
        messageIndicator.inputMessageIndicator.messageLanguage ='E';
        messageIndicator.inputMessageIndicator.messageTarget ='STD';
        
        requestBean.messageIndicator = messageIndicator;
        
        ABFupdConditionsOfAgreement_Req_IB_v1.ABFupdConditionsOfAgreementV2 ABFupdConditionsOfAgreementV2 = new  ABFupdConditionsOfAgreement_Req_IB_v1.ABFupdConditionsOfAgreementV2();
        ABFupdConditionsOfAgreementV2.ABFupdConditionsOfAgreementV2Input = new ABFupdConditionsOfAgreement_Req_IB_v1.ABFupdConditionsOfAgreementV2Input();
        ABFupdConditionsOfAgreementV2.ABFupdConditionsOfAgreementV2Input.corpCode = 'ABS';
        ABFupdConditionsOfAgreementV2.ABFupdConditionsOfAgreementV2Input.branchCode = user.SiteCode__c==null ? 6522: Integer.valueOf(user.SiteCode__c);
        ABFupdConditionsOfAgreementV2.ABFupdConditionsOfAgreementV2Input.workstationID ='99';
        ABFupdConditionsOfAgreementV2.ABFupdConditionsOfAgreementV2Input.agencyCode = user.SiteType__c ==null? 8198 :Integer.valueOf(user.SiteType__c);
        ABFupdConditionsOfAgreementV2.ABFupdConditionsOfAgreementV2Input.tellerCode =tellerNum;
        ABFupdConditionsOfAgreementV2.ABFupdConditionsOfAgreementV2Input.supervisorCode =user.Supervisor__c ==null ? 1560 :Integer.valueOf(user.Supervisor__c);
        ABFupdConditionsOfAgreementV2.ABFupdConditionsOfAgreementV2Input.branchSiteType = user.SiteType__c ==null? '034':user.SiteType__c;
        ABFupdConditionsOfAgreementV2.ABFupdConditionsOfAgreementV2Input.siteTypeAgency = user.SiteType__c ==null? '034':user.SiteType__c; 
        ABFupdConditionsOfAgreementV2.ABFupdConditionsOfAgreementV2Input.accountNbr= Long.valueOf(acctNumber); 
        ABFupdConditionsOfAgreementV2.ABFupdConditionsOfAgreementV2Input.mandateNbr= mandateNum ;
        ABFupdConditionsOfAgreementV2.ABFupdConditionsOfAgreementV2Input.contractSignedInd=  contractSigned; 
        ABFupdConditionsOfAgreementV2.ABFupdConditionsOfAgreementV2Input.paymentMethodReqInd = ABFresponse.plpa03o.payMethodReqInd == null ? 'N': ABFresponse.plpa03o.payMethodReqInd  ;  
        ABFupdConditionsOfAgreementV2.ABFupdConditionsOfAgreementV2Input.cessionPledgeInd = ABFresponse.plpa03o.cessionPledgeInd == null ? 'N' :  ABFresponse.plpa03o.cessionPledgeInd;
        ABFupdConditionsOfAgreementV2.ABFupdConditionsOfAgreementV2Input.autoSettlementInd = ABFresponse.plpa03o.autoSettlementInd == null ? 'N': ABFresponse.plpa03o.autoSettlementInd;
        ABFupdConditionsOfAgreementV2.ABFupdConditionsOfAgreementV2Input.creditLifeInd = ABFresponse.plpa03o.creditLifeInd == null ?'N' :ABFresponse.plpa03o.creditLifeInd ;
        ABFupdConditionsOfAgreementV2.ABFupdConditionsOfAgreementV2Input.landlordWaiverInd = landlordWaiverInd;     
        ABFupdConditionsOfAgreementV2.ABFupdConditionsOfAgreementV2Input.insuranceInd = insuranceInd;
        ABFupdConditionsOfAgreementV2.ABFupdConditionsOfAgreementV2Input.elecTransferInd = elecTransferInd;
        ABFupdConditionsOfAgreementV2.ABFupdConditionsOfAgreementV2Input.acDebitOrder = 'N';
        
        requestBean.ABFupdConditionsOfAgreementV2 = ABFupdConditionsOfAgreementV2;
        system.debug('request bean--'+JSON.serializePretty(requestBean));
        return requestbean;
    }

}