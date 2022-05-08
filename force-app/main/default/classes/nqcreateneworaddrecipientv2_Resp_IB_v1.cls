public class nqcreateneworaddrecipientv2_Resp_IB_v1{

    public Integer statusCode{get;set;}
    public String StatusMessage {get;set;}
    public String status{get;set;}

    public NQcreateNewOrAddRecipientV2Response NQcreateNewOrAddRecipientV2Response{get;set;}
    public class nqp906o{
        public String rcode{get;set;}
        public String pnsRecipientIdO{get;set;}
    }
    public class NQcreateNewOrAddRecipientV2Response{
        public nbsmsgo nbsmsgo{get;set;}
        public nqp906o nqp906o{get;set;}
        public nbsapdpo nbsapdpo{get;set;}
    }
    public class nbsmsgo{
        public String nbrUserErrs{get;set;}
        public String version{get;set;}
        public msgEntry msgEntry{get;set;}
        public String nbrUserMsgs{get;set;}
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
    
     public static nqcreateneworaddrecipientv2_Resp_IB_v1 dummyResponse(){
          nqcreateneworaddrecipientv2_Resp_IB_v1 responsebean = new nqcreateneworaddrecipientv2_Resp_IB_v1();
          nqcreateneworaddrecipientv2_Resp_IB_v1.NQcreateNewOrAddRecipientV2Response NQcreateNewOrAddRecipientV2Responsebean = new nqcreateneworaddrecipientv2_Resp_IB_v1.NQcreateNewOrAddRecipientV2Response();
          nqcreateneworaddrecipientv2_Resp_IB_v1.nbsmsgo nbsmsgobean  = new nqcreateneworaddrecipientv2_Resp_IB_v1.nbsmsgo();
          nqcreateneworaddrecipientv2_Resp_IB_v1.nqp906o nqp906obean  = new nqcreateneworaddrecipientv2_Resp_IB_v1.nqp906o();
          nqcreateneworaddrecipientv2_Resp_IB_v1.nbsapdpo nbsapdpobean  = new nqcreateneworaddrecipientv2_Resp_IB_v1.nbsapdpo();
          nqcreateneworaddrecipientv2_Resp_IB_v1.msgEntry msgEntrybean  = new nqcreateneworaddrecipientv2_Resp_IB_v1.msgEntry();
       
          msgEntrybean.msgCode = 'BDP';
          msgEntrybean.msgTxt = 'E';
          msgEntrybean.msgErrInd = 'test';
          msgEntrybean.msgClass = 'test';
         
          nbsmsgobean.nbrUserErrs = 'test';
       	  nbsmsgobean.version = 'test';
          nbsmsgobean.nbrUserMsgs = 'test';
          nbsmsgobean.msgEntry = msgEntrybean;
                  
         
          nqp906obean.rcode = '4048154875';
          nqp906obean.pnsRecipientIdO = 'test';//
         
          nbsapdpobean.serviceVersion = 'test';
          nbsapdpobean.reasonCode = '03';
          nbsapdpobean.returnCode = 'test';//
          
         
          NQcreateNewOrAddRecipientV2Responsebean.nbsmsgo = nbsmsgobean;
          NQcreateNewOrAddRecipientV2Responsebean.nqp906o = nqp906obean;
          NQcreateNewOrAddRecipientV2Responsebean.nbsapdpo = nbsapdpobean; 
          responsebean.NQcreateNewOrAddRecipientV2Response = NQcreateNewOrAddRecipientV2Responsebean;
          return responsebean;
    
    }
}