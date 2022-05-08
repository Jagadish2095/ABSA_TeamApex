public class gPpaymReturnV1_Resp_IB_v1{
    
    public Integer statusCode{get;set;}
    public String StatusMessage {get;set;}
    public String status{get;set;}
  
    public GPpaymReturnV1Response GPpaymReturnV1Response{get;set;}
    public class nbsmsgo3{
        public String sysErrTxt{get;set;}
        public String nbrUserMsgs{get;set;}
        public msgEntry msgEntry{get;set;}
        public String nbrUserErrs{get;set;}
    }
    public class nbsapdpo{
        public String serviceVersion{get;set;}
        public String reasonCode{get;set;}
        public String returnCode{get;set;}
    }
    public class msgEntry{
        public String msgErrInd{get;set;}
        public String msgTxt{get;set;}
        public String msgCode{get;set;}
        public String msgClass{get;set;}
    }
    public class GPpaymReturnV1Response{
        public nbsmsgo3 nbsmsgo3{get;set;}
        public gpp506o gpp506o{get;set;}
        public nbsapdpo nbsapdpo{get;set;}
    }
    public class gpp506o{
        public String respDesc{get;set;}
        public String spare{get;set;}
        public String respCode{get;set;}
    }
    
    public static gPpaymReturnV1_Resp_IB_v1 dummyResponse(){
                gPpaymReturnV1_Resp_IB_v1 responseBean = new gPpaymReturnV1_Resp_IB_v1();
                responseBean.status='OK';
                responseBean.statusCode=200;
                responseBean.StatusMessage='SUCCESS';
                gPpaymReturnV1_Resp_IB_v1.nbsmsgo3 nbsmsgo3bean = new gPpaymReturnV1_Resp_IB_v1.nbsmsgo3();
                nbsmsgo3bean.nbrUserMsgs = 'test';
                 nbsmsgo3bean.nbrUserErrs = 'test';
        
               gPpaymReturnV1_Resp_IB_v1.nbsapdpo nbsapdpobean = new gPpaymReturnV1_Resp_IB_v1.nbsapdpo();
                nbsapdpobean.serviceVersion = 'test';
                nbsapdpobean.reasonCode = 'test';
                nbsapdpobean.returnCode = 'test';
                
                gPpaymReturnV1_Resp_IB_v1.gpp506o gpp506obean=  new gPpaymReturnV1_Resp_IB_v1.gpp506o();
                gpp506obean.respDesc = 'test';
                gpp506obean.spare = 'test';
                gpp506obean.respCode = 'test';
             gPpaymReturnV1_Resp_IB_v1.msgEntry msgEntrybean = new gPpaymReturnV1_Resp_IB_v1.msgEntry();
        		msgEntrybean.msgErrInd = 'test';
        		msgEntrybean.msgTxt = 'test';
                msgEntrybean.msgCode = 'test';    
                msgEntrybean.msgClass = 'test';    
                    
                gPpaymReturnV1_Resp_IB_v1.GPpaymReturnV1Response  GPpaymReturnV1Responsebean = new gPpaymReturnV1_Resp_IB_v1.GPpaymReturnV1Response();
                GPpaymReturnV1Responsebean.nbsmsgo3 = nbsmsgo3bean;
                GPpaymReturnV1Responsebean.gpp506o = gpp506obean;
                GPpaymReturnV1Responsebean.nbsapdpo = nbsapdpobean;
                
                responsebean.GPpaymReturnV1Response = GPpaymReturnV1Responsebean;
             
                return responseBean;
        }
}