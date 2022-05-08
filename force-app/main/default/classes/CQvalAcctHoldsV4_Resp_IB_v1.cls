public class CQvalAcctHoldsV4_Resp_IB_v1 {
    
    @auraEnabled public String status;
    @auraEnabled public Integer statusCode;
    @auraEnabled public String message;
    @AuraEnabled public CQvalAcctHoldsV4Response CQvalAcctHoldsV4Response{get;set;}
    
    public class CQvalAcctHoldsV4Response{
        @AuraEnabled public nbsapdpo nbsapdpo{get;set;}
        @AuraEnabled public nbsmsgo3 nbsmsgo3{get;set;}
            
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
    
    public static CQvalAcctHoldsV4_Resp_IB_v1 dummyResponse(){
        CQvalAcctHoldsV4_Resp_IB_v1 responseBean = new CQvalAcctHoldsV4_Resp_IB_v1();
        responseBean.status='OK';
        responseBean.statusCode=200;
        responseBean.message='SUCCESS';
        
        CQvalAcctHoldsV4_Resp_IB_v1.nbsapdpo nbsapdpo = new CQvalAcctHoldsV4_Resp_IB_v1.nbsapdpo();
        nbsapdpo.reasonCode = '0';
        nbsapdpo.returnCode = '0';
        nbsapdpo.serviceVersion = 'BUSO003';
        
        CQvalAcctHoldsV4_Resp_IB_v1.nbsmsgo3 nbsmsgo3 = new CQvalAcctHoldsV4_Resp_IB_v1.nbsmsgo3();
        nbsmsgo3.version = 'MSG3001';
        nbsmsgo3.nbrUserErrs = '0';
        nbsmsgo3.nbrUserMsgs = '0';
        
        CQvalAcctHoldsV4_Resp_IB_v1.msgEntry msgEntry = new CQvalAcctHoldsV4_Resp_IB_v1.msgEntry();
        msgEntry.msgClass = null;
        msgEntry.msgCode = null;
        msgEntry.msgErrInd = null;
        msgEntry.msgTxt = null;
        
        CQvalAcctHoldsV4_Resp_IB_v1.CQvalAcctHoldsV4Response CQvalAcctHoldsV4bean = new CQvalAcctHoldsV4_Resp_IB_v1.CQvalAcctHoldsV4Response();
         CQvalAcctHoldsV4bean.nbsapdpo = nbsapdpo;
         CQvalAcctHoldsV4bean.nbsmsgo3 = nbsmsgo3;
        
        responseBean.CQvalAcctHoldsV4Response = CQvalAcctHoldsV4bean;
        return responseBean;
        
    }
    

}