public class ccdelinkaccountsv1_Resp_IB_v1 extends Base_IB {
    
    @AuraEnabled public Integer statusCode{get;set;}
    @AuraEnabled public String StatusMessage {get;set;}
    @AuraEnabled public String status{get;set;}
    
    public CCdelinkAccountsV1Response CCdelinkAccountsV1Response{get;set;}
    public class nbsmsgo{
        public String sysErrTxt{get;set;}
        public String version{get;set;}
        public String nbrUserMsgs{get;set;}
        //public msgEntry msgEntry{get;set;} 
        public list<msgEntry> msgEntry{get;set;}
        public String nbrUserErrs{get;set;}
    }
    public class nbsapdpo{
        public String serviceVersion{get;set;}
        public String reasonCode{get;set;}
        public String returnCode{get;set;}
    }
    public class msgEntry{
        public String msgCode{get;set;}
        public String msgTxt{get;set;}
        public String msgErrInd{get;set;}
        public String msgClass{get;set;}
    }
    public class ccp309o{
        public String combiRetrvdInd{get;set;}
        public String lstAccntNbr{get;set;}
    }
    public class CCdelinkAccountsV1Response{
        public nbsmsgo nbsmsgo{get;set;}
        public ccp309o ccp309o{get;set;}
        public nbsapdpo nbsapdpo{get;set;}
    }
    
    public static ccdelinkaccountsv1_Resp_IB_v1 dummyResponse(){
        ccdelinkaccountsv1_Resp_IB_v1 responseBean = new ccdelinkaccountsv1_Resp_IB_v1();
        responseBean.status='OK';
        responseBean.statusCode=200;
        responseBean.StatusMessage='SUCCESS';
        ccdelinkaccountsv1_Resp_IB_v1.msgEntry msgEntrybean = new ccdelinkaccountsv1_Resp_IB_v1.msgEntry(); 
        List<ccdelinkaccountsv1_Resp_IB_v1.msgEntry> msgEntrybeanList = new List<ccdelinkaccountsv1_Resp_IB_v1.msgEntry>(); 
        msgEntrybean.msgTxt = 'test';
        msgEntrybean.msgErrInd = 'test';
        msgEntrybean.msgCode = 'test';
        msgEntrybean.msgClass = 'test';
        ccdelinkaccountsv1_Resp_IB_v1.nbsmsgo nbsmsgobean = new ccdelinkaccountsv1_Resp_IB_v1.nbsmsgo();
        nbsmsgobean.sysErrTxt = 'test';
        nbsmsgobean.version = 'test';
        nbsmsgobean.nbrUserMsgs = 'test';
        
        msgEntrybeanList.add(msgEntrybean);
        nbsmsgobean.msgEntry = msgEntrybeanList;
        
        nbsmsgobean.nbrUserErrs = 'test';
        ccdelinkaccountsv1_Resp_IB_v1.nbsapdpo nbsapdpobean = new ccdelinkaccountsv1_Resp_IB_v1.nbsapdpo();
        nbsapdpobean.serviceVersion = 'test';
        nbsapdpobean.reasonCode = 'test';
        nbsapdpobean.returnCode = 'test';
        ccdelinkaccountsv1_Resp_IB_v1.ccp309o ccp309obean = new ccdelinkaccountsv1_Resp_IB_v1.ccp309o(); 
        ccp309obean.combiRetrvdInd = 'test';
        ccp309obean.lstAccntNbr = 'test';
        ccdelinkaccountsv1_Resp_IB_v1.CCdelinkAccountsV1Response CCdelinkAccountsV1Responsebean=  new ccdelinkaccountsv1_Resp_IB_v1.CCdelinkAccountsV1Response();
        CCdelinkAccountsV1Responsebean.nbsmsgo = nbsmsgobean;
        CCdelinkAccountsV1Responsebean.nbsapdpo = nbsapdpobean; 
        CCdelinkAccountsV1Responsebean.ccp309o = ccp309obean;
        responsebean.CCdelinkAccountsV1Response = CCdelinkAccountsV1Responsebean;
        return responseBean;
    }
}