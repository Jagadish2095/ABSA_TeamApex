/*
 * Request Integration Bean for IBgetClientDetails Service
 * @author Khaliq Abdul
 * @created 2020-09-22
 */

public class IBgetClientDetailsV1_Req_IB_v1 extends Base_IB {
    
    
    public IBgetClientDetailsV1 IBgetClientDetailsV1{get;set;}
    
    public class IBgetClientDetailsV1 {
        public nbsapdpi nbsapdpi{get;set;}
        public nbsmsgi nbsmsgi{get;set;}
        public nhs293i nhs293i{get;set;} 
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
    
    public class nhs293i{
        
        public String branch;
        public String subBranch;
        public String siteType;
        public String teller;
        public String manager;
        public String agencyCode;
        public String workstation;        
        public String supervisor;
        public String accessAccount;        
        
    }    
    
    public static IBgetClientDetailsV1_Req_IB_v1 createDummyRequest(){
        
        
        IBgetClientDetailsV1_Req_IB_v1 requestBean = new IBgetClientDetailsV1_Req_IB_v1();

        IBgetClientDetailsV1_Req_IB_v1.nbsapdpi nbsapdpiRequest = new IBgetClientDetailsV1_Req_IB_v1.nbsapdpi ();
        nbsapdpiRequest.application = 'BDP';
        nbsapdpiRequest.channel = 'BDP';
        nbsapdpiRequest.trace = 'Y';
        
        IBgetClientDetailsV1_Req_IB_v1.nbsmsgi nbsmsgiRequest = new IBgetClientDetailsV1_Req_IB_v1.nbsmsgi ();
        nbsmsgiRequest.msgLanguage = 'E';
        nbsmsgiRequest.msgTarget = 'STD';

        IBgetClientDetailsV1_Req_IB_v1.finalMsgId finalMsgIdRequest = new IBgetClientDetailsV1_Req_IB_v1.finalMsgId();
        finalMsgIdRequest.finalMsgClass = '';
        finalMsgIdRequest.finalMsgCode = '';
        
        IBgetClientDetailsV1_Req_IB_v1.nhs293i nhs293iRequest = new IBgetClientDetailsV1_Req_IB_v1.nhs293i();
        nhs293iRequest.accessAccount =  '4047920380'  ;
        nhs293iRequest.branch =  '8198'  ;
        nhs293iRequest.subBranch =  '0'  ;
        nhs293iRequest.siteType =  '034'  ;
        nhs293iRequest.teller =  '1469'  ;
        nhs293iRequest.manager =  '0'  ;
        nhs293iRequest.agencyCode =  '0'  ;
        nhs293iRequest.workstation =  'WS'  ;
        nhs293iRequest.supervisor =  '0'  ;
        
        
        IBgetClientDetailsV1_Req_IB_v1.IBgetClientDetailsV1 IBgetClientDetailsV1bean = new IBgetClientDetailsV1_Req_IB_v1.IBgetClientDetailsV1();
        IBgetClientDetailsV1bean.nbsapdpi = nbsapdpiRequest;
        IBgetClientDetailsV1bean.nbsmsgi = nbsmsgiRequest;
        IBgetClientDetailsV1bean.nhs293i = nhs293iRequest;
        
        requestBean.IBgetClientDetailsV1 = IBgetClientDetailsV1bean;

        return requestBean;
    }

}