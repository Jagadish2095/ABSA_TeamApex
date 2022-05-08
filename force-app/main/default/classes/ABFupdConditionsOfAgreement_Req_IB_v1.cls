/*
* Integration Request Bean for get conditions of agreement
* @author Almas Aleem:Absa  
* @created 2020-12-02
*/
public class ABFupdConditionsOfAgreement_Req_IB_v1 extends Base_IB{
    public MessageHeaders messageHeaders;
    public MessageIndicator messageIndicator;
    public ABFupdConditionsOfAgreementV2 ABFupdConditionsOfAgreementV2;
    
    public class MessageIndicator {
        public InputMessageIndicator inputMessageIndicator;
    }
    
    public class InputMessageIndicator {
        public String messageLanguage;
        public String messageTarget;
    }
    
    public class InputMessageHeaders {
        public String consumerChannel;
        public String providerApplication;
        public String traceIndicator;
    }
    
    public class MessageHeaders {
        public InputMessageHeaders inputMessageHeaders;
    }
    
    public class ABFupdConditionsOfAgreementV2 {
        public ABFupdConditionsOfAgreementV2Input ABFupdConditionsOfAgreementV2Input;
    }
    
    public class ABFupdConditionsOfAgreementV2Input {
        public String corpCode;
        public Integer branchCode;
        public String workstationID;
        public Integer agencyCode;
        public Integer tellerCode;
        public Integer supervisorCode;
        public String branchSiteType;
        public String siteTypeAgency;
        public Long accountNbr;
        public Integer mandateNbr;
        public String contractSignedInd;
        public String paymentMethodReqInd;
        public String cessionPledgeInd;
        public String autoSettlementInd;
        public String creditLifeInd;
        public String landlordWaiverInd;
        public String insuranceInd;
        public String elecTransferInd;
        public String acDebitOrder;
    }
    public static ABFupdConditionsOfAgreement_Req_IB_v1 createDummyRequest() {
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
        ABFupdConditionsOfAgreementV2.ABFupdConditionsOfAgreementV2Input.branchCode =6522;
        ABFupdConditionsOfAgreementV2.ABFupdConditionsOfAgreementV2Input.workstationID ='99';
        ABFupdConditionsOfAgreementV2.ABFupdConditionsOfAgreementV2Input.agencyCode =8198;
        ABFupdConditionsOfAgreementV2.ABFupdConditionsOfAgreementV2Input.tellerCode =1818;
        ABFupdConditionsOfAgreementV2.ABFupdConditionsOfAgreementV2Input.supervisorCode =1560;
        ABFupdConditionsOfAgreementV2.ABFupdConditionsOfAgreementV2Input.branchSiteType ='034';
        ABFupdConditionsOfAgreementV2.ABFupdConditionsOfAgreementV2Input.siteTypeAgency = '034'; 
        ABFupdConditionsOfAgreementV2.ABFupdConditionsOfAgreementV2Input.accountNbr= Long.valueOf('3001534477'); 
        ABFupdConditionsOfAgreementV2.ABFupdConditionsOfAgreementV2Input.mandateNbr= 21;
        ABFupdConditionsOfAgreementV2.ABFupdConditionsOfAgreementV2Input.contractSignedInd=  'F'; 
        ABFupdConditionsOfAgreementV2.ABFupdConditionsOfAgreementV2Input.paymentMethodReqInd = 'F'   ;  
        ABFupdConditionsOfAgreementV2.ABFupdConditionsOfAgreementV2Input.cessionPledgeInd = 'Y';
        ABFupdConditionsOfAgreementV2.ABFupdConditionsOfAgreementV2Input.autoSettlementInd = 'N';
        ABFupdConditionsOfAgreementV2.ABFupdConditionsOfAgreementV2Input.creditLifeInd = 'N';
        ABFupdConditionsOfAgreementV2.ABFupdConditionsOfAgreementV2Input.landlordWaiverInd = 'F';     
        ABFupdConditionsOfAgreementV2.ABFupdConditionsOfAgreementV2Input.insuranceInd = 'F';
        ABFupdConditionsOfAgreementV2.ABFupdConditionsOfAgreementV2Input.elecTransferInd ='F';
        ABFupdConditionsOfAgreementV2.ABFupdConditionsOfAgreementV2Input.acDebitOrder = 'N';
        
        requestBean.ABFupdConditionsOfAgreementV2 = ABFupdConditionsOfAgreementV2;
        system.debug('request bean--'+JSON.serializePretty(requestBean));
        
        return requestBean;
        
    }
}