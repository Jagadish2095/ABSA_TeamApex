/*
* Integration Response  Bean for IBCancelServicev1 Service
* @author Lulu Rankwe
* @created 05-05-2020
*/

public class IBCancelServicev1_Req_IB_v1 extends Base_IB{
    
    public IBcancelServiceV1 IBcancelServiceV1{get;set;}
    
    public class nbsapdpi{
        public String trace{get;set;}
        public String application{get;set;}
        public String channel{get;set;}
    } 
    public class nbsmsgi{
        public finalMsgId finalMsgId{get;set;}
        public String msgLanguage{get;set;}
        public String msgTarget{get;set;}
    }
    public class finalMsgId{
        public String finalMsgCode{get;set;}
        public String finalMsgClass{get;set;}
    }
    
    public class nhp456i{
        public String agencyCode{get;set;}
        public String workstation{get;set;}
        public String manager{get;set;}
        public String supervisor{get;set;}
        public String teller{get;set;}
        public String accessAccount{get;set;}
        public String siteType{get;set;}
        public String cancellationReason{get;set;}
        public String subBranch{get;set;}
        public String cancellationDesc{get;set;}
        public String branch{get;set;}
        public String cancellationWhy{get;set;}
        public String replacedByTelBankin{get;set;}
        public String replacedByIbMobile{get;set;}
        public String replacedByAtm{get;set;}
        public String replacedByPicknpay{get;set;}
        public String replacedByDebitOrde{get;set;}
        public String replacedByNothing{get;set;}
        public String replacedByVendor{get;set;}
    }
    public class IBcancelServiceV1{
        public nbsmsgi nbsmsgi{get;set;}
        public nhp456i nhp456i{get;set;}
        public nbsapdpi nbsapdpi{get;set;}
    }
    
    public IBCancelServicev1_Req_IB_v1 createDummyRequest(){
        
        IBCancelServicev1_Req_IB_v1 reqBean = new IBCancelServicev1_Req_IB_v1();
        IBCancelServicev1_Req_IB_v1.nhp456i nhp456iBean  = new IBCancelServicev1_Req_IB_v1.nhp456i();
        IBCancelServicev1_Req_IB_v1.nbsapdpi nbsapdpiBean  = new IBCancelServicev1_Req_IB_v1.nbsapdpi();
        IBCancelServicev1_Req_IB_v1.nbsmsgi nbsmsgiBean  = new IBCancelServicev1_Req_IB_v1.nbsmsgi();
        IBCancelServicev1_Req_IB_v1.finalMsgId finalMsgIdBean = new IBCancelServicev1_Req_IB_v1.finalMsgId();
        
        nbsapdpiBean.channel = 'BDP';
        nbsapdpiBean.application = 'BDP';
        nbsapdpiBean.trace = 'Y';
        
        nbsmsgiBean.msgLanguage = 'E';
        nbsmsgiBean.msgTarget = 'STD';
        
        finalMsgIdBean.finalMsgClass = '';
        finalMsgIdBean.finalMsgCode = '';
        
        nhp456iBean.branch = '8193';
        nhp456iBean.subBranch = '';
        nhp456iBean.siteType = '034';
        nhp456iBean.teller = '999999';
        nhp456iBean.manager = '999999';
        nhp456iBean.agencyCode = '034';
        nhp456iBean.workstation = '99';
        nhp456iBean.supervisor = '999999';
        nhp456iBean.accessAccount = '4048276744';
        nhp456iBean.cancellationReason = '4';
        nhp456iBean.cancellationDesc = 'test';
        nhp456iBean.cancellationWhy = 'test';
        nhp456iBean.replacedByIbMobile = 'N';
        nhp456iBean.replacedByTelBankin = 'N';
        nhp456iBean.replacedByAtm = 'N';
        nhp456iBean.replacedByVendor = 'N';
        nhp456iBean.replacedByDebitOrde = 'N';
        nhp456iBean.replacedByPicknpay = 'N';
        nhp456iBean.replacedByNothing = 'Y';
        
        IBCancelServicev1_Req_IB_v1.IBcancelServiceV1 IBcancelServiceV1Bean = new IBCancelServicev1_Req_IB_v1.IBcancelServiceV1();
        IBcancelServiceV1Bean.nbsapdpi = nbsapdpiBean;
        IBcancelServiceV1Bean.nbsmsgi = nbsmsgiBean;
        IBcancelServiceV1Bean.nhp456i = nhp456iBean;
        
        nbsmsgiBean.finalMsgId = finalMsgIdBean;
        reqBean.IBcancelServiceV1 = IBcancelServiceV1Bean;
        
        return reqBean;
    }

}