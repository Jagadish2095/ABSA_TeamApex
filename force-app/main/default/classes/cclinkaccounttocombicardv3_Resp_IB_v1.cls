public class cclinkaccounttocombicardv3_Resp_IB_v1 extends Base_IB {
    
    @AuraEnabled public Integer statusCode{get;set;}
    @AuraEnabled public String StatusMessage {get;set;}
    @AuraEnabled public String status{get;set;}
    
    public CClinkAccountToCombiCardV3Response CClinkAccountToCombiCardV3Response{get;set;}
    public class nbsmsgo{
        public String version{get;set;}
        public String sysErrTxt{get;set;}
        public String nbrUserErrs{get;set;}
        public msgEntry msgEntry{get;set;}
        public String nbrUserMsgs{get;set;}
    }
    public class nbsapdpo{
        public String serviceVersion{get;set;}
        public String returnCode{get;set;}
        public String reasonCode{get;set;}
        public String version{get;set;}
    }
    public class msgEntry{
        public String msgClass{get;set;}
        public String msgTxt{get;set;}
        public String msgErrInd{get;set;}
        public String msgCode{get;set;}
    }
    public class ccp303o{
        public String combiRetrvdInd{get;set;}
        public String accntLinked{get;set;}
    }
    public class CClinkAccountToCombiCardV3Response{
        public nbsmsgo nbsmsgo{get;set;}
        public ccp303o ccp303o{get;set;}
        public nbsapdpo nbsapdpo{get;set;}
    }
    
    public static cclinkaccounttocombicardv3_Resp_IB_v1 dummyResponse(){
        cclinkaccounttocombicardv3_Resp_IB_v1 responseBean = new cclinkaccounttocombicardv3_Resp_IB_v1();
        responseBean.status='OK';
        responseBean.statusCode=200;
        responseBean.StatusMessage='SUCCESS';
        
        cclinkaccounttocombicardv3_Resp_IB_v1.msgEntry msgEntrybean = new cclinkaccounttocombicardv3_Resp_IB_v1.msgEntry(); 
        msgEntrybean.msgTxt = 'test';
        msgEntrybean.msgErrInd = 'test';
        msgEntrybean.msgCode = 'test';
        msgEntrybean.msgClass = 'test';
        cclinkaccounttocombicardv3_Resp_IB_v1.nbsmsgo nbsmsgobean = new cclinkaccounttocombicardv3_Resp_IB_v1.nbsmsgo();
        nbsmsgobean.sysErrTxt = 'test';
        nbsmsgobean.version = 'test';
        nbsmsgobean.nbrUserMsgs = 'test';
        nbsmsgobean.msgEntry = msgEntrybean;
        nbsmsgobean.nbrUserErrs = 'test';
        cclinkaccounttocombicardv3_Resp_IB_v1.nbsapdpo nbsapdpobean = new cclinkaccounttocombicardv3_Resp_IB_v1.nbsapdpo();
        nbsapdpobean.serviceVersion = 'test';
        nbsapdpobean.reasonCode = 'test';
        nbsapdpobean.returnCode = 'test';
        cclinkaccounttocombicardv3_Resp_IB_v1.ccp303o ccp303obean = new cclinkaccounttocombicardv3_Resp_IB_v1.ccp303o(); 
        ccp303obean.combiRetrvdInd = 'test';
        ccp303obean.accntLinked = 'test';
        cclinkaccounttocombicardv3_Resp_IB_v1.cclinkaccounttocombicardv3Response cclinkaccounttocombicardv3Responsebean=  new cclinkaccounttocombicardv3_Resp_IB_v1.cclinkaccounttocombicardv3Response();
        cclinkaccounttocombicardv3Responsebean.nbsmsgo = nbsmsgobean;
        cclinkaccounttocombicardv3Responsebean.nbsapdpo = nbsapdpobean;
        cclinkaccounttocombicardv3Responsebean.ccp303o = ccp303obean;
        responsebean.cclinkaccounttocombicardv3Response = cclinkaccounttocombicardv3Responsebean;
        return responseBean;
    }
}