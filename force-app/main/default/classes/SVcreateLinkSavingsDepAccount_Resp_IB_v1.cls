public class SVcreateLinkSavingsDepAccount_Resp_IB_v1{

    Public List<SVcreateLinkSavingsNoticeDepAccountV6Response> responseList{set;get;}
    public Integer statusCode{get;set;}
    public String StatusMessage {get;set;}
    public String status{get;set;}
    public String RequesterReference{get;set;}
 
    public SVcreateLinkSavingsNoticeDepAccountV6Response SVcreateLinkSavingsNoticeDepAccountV6Response{get;set;}
    public class svpp15o{
        public String accountNumber{get;set;}
    }
    public class SVcreateLinkSavingsNoticeDepAccountV6Response{
        public svpp15o svpp15o{get;set;}
        public nbsmsgo3 nbsmsgo3{get;set;}
        public nbsapdpo nbsapdpo{get;set;}
    }
    public class nbsmsgo3{
        public String nbrUserErrs{get;set;}
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
    public static SVcreateLinkSavingsDepAccount_Resp_IB_v1 dummyResponse(){
                SVcreateLinkSavingsDepAccount_Resp_IB_v1 responseBean = new SVcreateLinkSavingsDepAccount_Resp_IB_v1();
                responseBean.status='OK';
                responseBean.statusCode=200;
                responseBean.StatusMessage='SUCCESS';
                SVcreateLinkSavingsDepAccount_Resp_IB_v1.svpp15o svpp15obean = new SVcreateLinkSavingsDepAccount_Resp_IB_v1.svpp15o();
                svpp15obean.accountNumber = 'test';
               
               SVcreateLinkSavingsDepAccount_Resp_IB_v1.msgEntry msgEntrybean = new SVcreateLinkSavingsDepAccount_Resp_IB_v1.msgEntry();
                msgEntrybean.msgCode = 'test';
                msgEntrybean.msgTxt = 'test';
                msgEntrybean.msgErrInd = 'test';
                msgEntrybean.msgClass = 'test';
                SVcreateLinkSavingsDepAccount_Resp_IB_v1.nbsmsgo3 nbsmsgo3bean=  new SVcreateLinkSavingsDepAccount_Resp_IB_v1.nbsmsgo3();
                nbsmsgo3bean.nbrUserErrs = 'test';
                nbsmsgo3bean.msgEntry = msgEntrybean;
                nbsmsgo3bean.nbrUserMsgs = 'test';
                SVcreateLinkSavingsDepAccount_Resp_IB_v1.nbsapdpo  nbsapdpobean = new SVcreateLinkSavingsDepAccount_Resp_IB_v1.nbsapdpo();
                nbsapdpobean.serviceVersion = 'test';
                nbsapdpobean.reasonCode = 'test';
                nbsapdpobean.returnCode = 'test';
                SVcreateLinkSavingsDepAccount_Resp_IB_v1.SVcreateLinkSavingsNoticeDepAccountV6Response SVcreateLinkSavings = new SVcreateLinkSavingsDepAccount_Resp_IB_v1.SVcreateLinkSavingsNoticeDepAccountV6Response();
                SVcreateLinkSavings.svpp15o = svpp15obean;
                SVcreateLinkSavings.nbsmsgo3 = nbsmsgo3bean;
                SVcreateLinkSavings.nbsapdpo = nbsapdpobean;
                //SVcreateLinkSavingsDepAccount_Resp_IB_v1.SVcreateLinkSavingsNoticeDepAccountV6Response = SVcreateLinkSavings;
                list<SVcreateLinkSavingsDepAccount_Resp_IB_v1.svpp15o> listdsresponse  = new list<SVcreateLinkSavingsDepAccount_Resp_IB_v1.svpp15o>();
               
                
                
                return responseBean;
        }
}