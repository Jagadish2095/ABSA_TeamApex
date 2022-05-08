public class dSaddStopPaymentV2_Resp_IB_v1 {

        public Integer statusCode{get;set;}
        public String StatusMessage {get;set;}
        public String status{get;set;}
    
        public DSaddStopPaymentV2Response DSaddStopPaymentV2Response{get;set;}
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
        public String msgClass{get;set;}
        public String msgTxt{get;set;}
        public String msgErrInd{get;set;}
        public String msgCode{get;set;}
    }
    public class dsc976oOutput{
        public String dsc976oStatus{get;set;}
        public String dsc976oTeller{get;set;}
        public String dsc976oBrnch{get;set;}
        public String dsc976oCaseNo{get;set;}
        public String dsc976oInstrNo{get;set;}
        public String dsc976oInstitution{get;set;}
        public String dsc976oAmount{get;set;}
        public String dsc976oEffDate{get;set;}
        public String dsc976oUserRef{get;set;}
        public String dsc976oUserCodeDesc{get;set;}
        public String dsc976oUserCode{get;set;}
        public String dsc976oDebtorName{get;set;}
        public String dsc976oActDate{get;set;}
        public String dsc976oRespCode{get;set;}
        public String dsc976oAccNo{get;set;}
        public String dsc976oRespDesc{get;set;}
    }
    public class DSaddStopPaymentV2Response{
        public nbsmsgo3 nbsmsgo3{get;set;}
        public dsc976oOutput dsc976oOutput{get;set;}
        public nbsapdpo nbsapdpo{get;set;}
    }
    
    public static dSaddStopPaymentV2_Resp_IB_v1 dummyResponse(){
                dSaddStopPaymentV2_Resp_IB_v1 responseBean = new dSaddStopPaymentV2_Resp_IB_v1();
                responseBean.status='OK';
                responseBean.statusCode=200;
                responseBean.StatusMessage='SUCCESS';
                dSaddStopPaymentV2_Resp_IB_v1.nbsmsgo3 nbsmsgo3bean = new dSaddStopPaymentV2_Resp_IB_v1.nbsmsgo3();
                nbsmsgo3bean.nbrUserMsgs = 'test';
                nbsmsgo3bean.nbrUserErrs = 'test';
        		nbsmsgo3bean.sysErrTxt = 'test';
               dSaddStopPaymentV2_Resp_IB_v1.nbsapdpo nbsapdpobean = new dSaddStopPaymentV2_Resp_IB_v1.nbsapdpo();
                nbsapdpobean.serviceVersion = 'test';
                nbsapdpobean.reasonCode = 'test';
                nbsapdpobean.returnCode = 'test';
                
                dSaddStopPaymentV2_Resp_IB_v1.dsc976oOutput dsc976oOutputbean=  new dSaddStopPaymentV2_Resp_IB_v1.dsc976oOutput();
                dsc976oOutputbean.dsc976oTeller = 'test';
                dsc976oOutputbean.dsc976oBrnch = 'test';
                dsc976oOutputbean.dsc976oCaseNo = 'test';
                dsc976oOutputbean.dsc976oInstrNo = 'test';
                dsc976oOutputbean.dsc976oInstitution = 'test';
                dsc976oOutputbean.dsc976oAmount = 'test';
                dsc976oOutputbean.dsc976oEffDate = 'test';
                dsc976oOutputbean.dsc976oUserRef = 'test';
                dsc976oOutputbean.dsc976oUserCodeDesc = 'test';
                dsc976oOutputbean.dsc976oUserCode = 'test';
                dsc976oOutputbean.dsc976oDebtorName = 'test';
                dsc976oOutputbean.dsc976oActDate = 'test';
                dsc976oOutputbean.dsc976oRespCode = 'test';
                dsc976oOutputbean.dsc976oAccNo = 'test';
                dsc976oOutputbean.dsc976oRespDesc = 'test';
        
        dSaddStopPaymentV2_Resp_IB_v1.msgEntry msgEntrybean=  new dSaddStopPaymentV2_Resp_IB_v1.msgEntry();
        		msgEntrybean.msgClass = 'test';
                msgEntrybean.msgTxt = 'test';
                msgEntrybean.msgErrInd = 'test';
                msgEntrybean.msgCode = 'test';
        
                dSaddStopPaymentV2_Resp_IB_v1.DSaddStopPaymentV2Response  DSaddStopPaymentV2Responsebean = new dSaddStopPaymentV2_Resp_IB_v1.DSaddStopPaymentV2Response();
                DSaddStopPaymentV2Responsebean.nbsmsgo3 = nbsmsgo3bean;
                DSaddStopPaymentV2Responsebean.dsc976oOutput = dsc976oOutputbean;
                DSaddStopPaymentV2Responsebean.nbsapdpo = nbsapdpobean;
                responsebean.DSaddStopPaymentV2Response = DSaddStopPaymentV2Responsebean;
             
                return responseBean;
        }
    
    
}