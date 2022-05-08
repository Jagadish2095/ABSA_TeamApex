public class SVgetAccountHoldsDetailV4_Req_IB_v1 extends Base_IB {
    
    public SVgetAccountHoldsDetailV4 SVgetAccountHoldsDetailV4{get;set;}
    
    public class SVgetAccountHoldsDetailV4 {
        public nbsapdpi nbsapdpi{get;set;}
        public nbsmsgi nbsmsgi{get;set;}
        public svsp40i svsp40i{get;set;} 
    }
    public class nbsapdpi{
        public String channel;
        public String application;
        public String trace;
    }
    
    public class nbsmsgi{
        public String msgTarget{get;set;}
        public String msgLanguage{get;set;}
        public finalMsgId finalMsgId{get;set;}
    }
    
    public class finalMsgId{
        public String finalMsgClass{get;set;}
        public String finalMsgCode{get;set;}
    }
    
    public class svsp40i{
        
        public String accountNbr;
        public String savingsDepositType;
        public String chargeInd;
        public String divisionCode;
        public String workStation;
        public String branchCode;
        public String agencyCode;
        public String agencySiteType;
        public String tellerCode;
        public String supervisorCode;
        public String branchSiteType;
        
    }
    
    public  SVgetAccountHoldsDetailV4_Req_IB_v1 createDummy(){
        
        
        SVgetAccountHoldsDetailV4_Req_IB_v1 requestBean = new SVgetAccountHoldsDetailV4_Req_IB_v1();

        SVgetAccountHoldsDetailV4_Req_IB_v1.nbsapdpi nbsapdpiRequest = new SVgetAccountHoldsDetailV4_Req_IB_v1.nbsapdpi ();
        nbsapdpiRequest.application = 'BDP';
        nbsapdpiRequest.channel = 'BDP';
        nbsapdpiRequest.trace = 'Y';
        
        SVgetAccountHoldsDetailV4_Req_IB_v1.nbsmsgi nbsmsgiRequest = new SVgetAccountHoldsDetailV4_Req_IB_v1.nbsmsgi ();
        nbsmsgiRequest.msgLanguage = 'E';
        nbsmsgiRequest.msgTarget = 'STD';
        
        SVgetAccountHoldsDetailV4_Req_IB_v1.finalMsgId finalMsgIdRequest = new SVgetAccountHoldsDetailV4_Req_IB_v1.finalMsgId();
        finalMsgIdRequest.finalMsgClass = '';
        finalMsgIdRequest.finalMsgCode = '';
        
        SVgetAccountHoldsDetailV4_Req_IB_v1.svsp40i svsp40iRequest = new SVgetAccountHoldsDetailV4_Req_IB_v1.svsp40i ();
        svsp40iRequest.accountNbr =  '9050986380'  ;
        svsp40iRequest.savingsDepositType =  'S'  ;
        svsp40iRequest.chargeInd =  'N'  ;
        svsp40iRequest.divisionCode =  'B'  ;
        svsp40iRequest.workStation =  '99'  ;
        svsp40iRequest.branchCode =  '8089'  ;
        svsp40iRequest.agencyCode =  '034'  ;
        svsp40iRequest.agencySiteType =  '034'  ;
        svsp40iRequest.tellerCode =  '25698'  ;
        svsp40iRequest.supervisorCode =  '25699'  ;
        svsp40iRequest.branchSiteType =  '034' ;
        
        SVgetAccountHoldsDetailV4_Req_IB_v1.SVgetAccountHoldsDetailV4 SVgetAccountHoldsDetailV4 = new SVgetAccountHoldsDetailV4_Req_IB_v1.SVgetAccountHoldsDetailV4();
        SVgetAccountHoldsDetailV4.nbsapdpi = nbsapdpiRequest;
        SVgetAccountHoldsDetailV4.nbsmsgi = nbsmsgiRequest;
        SVgetAccountHoldsDetailV4.svsp40i = svsp40iRequest;
        
        requestBean.SVgetAccountHoldsDetailV4 = SVgetAccountHoldsDetailV4;

        return requestBean;
    }
    
}