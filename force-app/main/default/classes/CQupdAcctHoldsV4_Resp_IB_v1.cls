public class CQupdAcctHoldsV4_Resp_IB_v1 {
    
    @auraEnabled public String status;
    @auraEnabled public Integer statusCode;
    @auraEnabled public String message;
    @AuraEnabled public CQupdAcctHoldsV4Response CQupdAcctHoldsV4Response{get;set;}
    
    public class CQupdAcctHoldsV4Response{
        @AuraEnabled public nbsapdpo nbsapdpo{get;set;}
        @AuraEnabled public nbsmsgo3 nbsmsgo3{get;set;}
        @AuraEnabled public cqh525o cqh525o{get;set;}
            
    }
    
    public class nbsapdpo{
        @AuraEnabled public String returnCode;
        @AuraEnabled public String reasonCode;
        @AuraEnabled public String serviceVersion;
        
    }
    
    public class nbsmsgo3{
        @AuraEnabled public String version;
        @AuraEnabled public String nbrUserMsgs;
        @AuraEnabled public String nbrUserErrs;
        @AuraEnabled public msgEntry msgEntry;
        
    }
    
    public class msgEntry{
        @AuraEnabled public String msgClass;
        @AuraEnabled public String msgCode;
        @AuraEnabled public String msgErrInd;
        @AuraEnabled public String msgTxt;
    }
    
    public class cqh525o{
        
        @AuraEnabled public String accountNbrOut;
        @AuraEnabled public confirmationDetails[] confirmationDetails{get;set;} 
    }
    
    public class confirmationDetails{
       @AuraEnabled public String details{get;set;}
    }
    
    public static CQupdAcctHoldsV4_Resp_IB_v1 dummyResponse(){
        
     CQupdAcctHoldsV4_Resp_IB_v1 responseBean = new CQupdAcctHoldsV4_Resp_IB_v1();
        responseBean.status='OK';
        responseBean.statusCode=200;
        responseBean.message='SUCCESS';
        
        CQupdAcctHoldsV4_Resp_IB_v1.nbsapdpo nbsapdpo = new CQupdAcctHoldsV4_Resp_IB_v1.nbsapdpo();
        nbsapdpo.reasonCode = '0';
        nbsapdpo.returnCode = '0';
        nbsapdpo.serviceVersion = 'BUSO003';
        
        CQupdAcctHoldsV4_Resp_IB_v1.nbsmsgo3 nbsmsgo3 = new CQupdAcctHoldsV4_Resp_IB_v1.nbsmsgo3();
        nbsmsgo3.version = 'MSG3001';
        nbsmsgo3.nbrUserErrs = '0';
        nbsmsgo3.nbrUserMsgs = '0';
        
        CQupdAcctHoldsV4_Resp_IB_v1.msgEntry msgEntry = new CQupdAcctHoldsV4_Resp_IB_v1.msgEntry();
        msgEntry.msgClass = 'CQSMGC01';
        msgEntry.msgCode = '12';
        msgEntry.msgErrInd = 'E';
        msgEntry.msgTxt = 'Data has not been changed';
        
        CQupdAcctHoldsV4_Resp_IB_v1.cqh525o cqh525o  = new CQupdAcctHoldsV4_Resp_IB_v1.cqh525o();
        cqh525o.accountNbrOut = '0';
        
        CQupdAcctHoldsV4_Resp_IB_v1.confirmationDetails confDetails = new CQupdAcctHoldsV4_Resp_IB_v1.confirmationDetails();
        confDetails.details = null;
        
       CQupdAcctHoldsV4_Resp_IB_v1.CQupdAcctHoldsV4Response CQupdAcctHoldsV4bean = new CQupdAcctHoldsV4_Resp_IB_v1.CQupdAcctHoldsV4Response();
         CQupdAcctHoldsV4bean.nbsapdpo = nbsapdpo;
         CQupdAcctHoldsV4bean.nbsmsgo3 = nbsmsgo3;
         CQupdAcctHoldsV4bean.cqh525o = cqh525o;
        
        responseBean.CQupdAcctHoldsV4Response = CQupdAcctHoldsV4bean;
        
        return responseBean;
        
    }

}