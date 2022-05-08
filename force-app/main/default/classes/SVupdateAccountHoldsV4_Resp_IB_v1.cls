public class SVupdateAccountHoldsV4_Resp_IB_v1 {
    
    @auraEnabled public String status;
    @auraEnabled public Integer statusCode;
    @auraEnabled public String message;
    @AuraEnabled public SVupdateAccountHoldsV4Response SVupdateAccountHoldsV4Response{get;set;}
    
    public class SVupdateAccountHoldsV4Response{
        @AuraEnabled public nbsapdpo nbsapdpo{get;set;}
        @AuraEnabled public nbsmsgo3 nbsmsgo3{get;set;}
        @AuraEnabled public svsp42o svsp42o{get;set;}
            
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
    
    public class svsp42o{
        @AuraEnabled public String amountCharged;
        @AuraEnabled public String eventNbr;
        @AuraEnabled public String overrideInd;
        @AuraEnabled public String holdNbr;
        @AuraEnabled public List<holdTbl> holdTbl{get;set;}
        
        
    }
    
    public class holdTbl{
        
        @AuraEnabled public String holdDesc;
        @AuraEnabled public String holdStat;
        @AuraEnabled public String holdSecurityNbr;
        @AuraEnabled public String holdOfflineDate;
        @AuraEnabled public String holdWtlCountry;
        
    }
    
    public static SVupdateAccountHoldsV4_Resp_IB_v1 dummyResponse(){
    SVupdateAccountHoldsV4_Resp_IB_v1 responseBean = new SVupdateAccountHoldsV4_Resp_IB_v1();
        responseBean.status='OK';
        responseBean.statusCode=200;
        responseBean.message='SUCCESS';
        
        SVupdateAccountHoldsV4_Resp_IB_v1.nbsapdpo nbsapdpo = new SVupdateAccountHoldsV4_Resp_IB_v1.nbsapdpo();
        nbsapdpo.reasonCode = '0';
        nbsapdpo.returnCode = '0';
        nbsapdpo.serviceVersion = 'BUSO003';
        
        SVupdateAccountHoldsV4_Resp_IB_v1.nbsmsgo3 nbsmsgo3 = new SVupdateAccountHoldsV4_Resp_IB_v1.nbsmsgo3();
        nbsmsgo3.version = 'MSG3001';
        nbsmsgo3.nbrUserErrs = '0';
        nbsmsgo3.nbrUserMsgs = '0';
        
        SVupdateAccountHoldsV4_Resp_IB_v1.msgEntry msgEntry = new SVupdateAccountHoldsV4_Resp_IB_v1.msgEntry();
        msgEntry.msgClass = '';
        msgEntry.msgCode = '';
        msgEntry.msgErrInd = '';
        msgEntry.msgTxt = '';
        
        SVupdateAccountHoldsV4_Resp_IB_v1.svsp42o svsp42o = new SVupdateAccountHoldsV4_Resp_IB_v1.svsp42o();
        svsp42o.amountCharged = '0';
        svsp42o.eventNbr = '0';
        svsp42o.overrideInd = '0';
        svsp42o.holdNbr = 'nan';
        svsp42o.holdTbl = null;
        
        return responseBean;
    }

}