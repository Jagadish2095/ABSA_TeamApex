/*
* Integration Req for IBgetRegistrationDetailsV1 Service
* @author Srinivas
* @created 2020-10-07
*/

public class IBgetRegistrationDetailsV1_Req_v1 extends Base_IB {
    public IBgetRegistrationDetailsV1 IBgetRegistrationDetailsV1;
    public class nhp292i{
        public String subBranch;
        public String branch;
        public String siteType;
        public String manager;
        public String teller;
        public String agencyCode;
        public String accessAccount;
        public String supervisor;
        public String serviceType;
        public String workstation;
    }
    public class nbsmsgi{
        public finalMsgId finalMsgId;
        public String msgLanguage;
        public String msgTarget;
    }
    public class nbsapdpi{
        public String trace;
        public String application;
        public String channel;
    }
    public class IBgetRegistrationDetailsV1{
        public nbsmsgi nbsmsgi;
        public nhp292i nhp292i;
        public nbsapdpi nbsapdpi;
    }
    public class finalMsgId{
        public String finalMsgCode;
        public String finalMsgClass;
    }
    public static IBgetRegistrationDetailsV1_Req_v1 createDummyBean(){
        IBgetRegistrationDetailsV1_Req_v1 requestbean = new IBgetRegistrationDetailsV1_Req_v1();
        IBgetRegistrationDetailsV1_Req_v1.IBgetRegistrationDetailsV1 IBgetRegistrationDetailsV1bean = new IBgetRegistrationDetailsV1_Req_v1.IBgetRegistrationDetailsV1();
        IBgetRegistrationDetailsV1_Req_v1.finalMsgId finalMsgIdbean  = new IBgetRegistrationDetailsV1_Req_v1.finalMsgId();
        IBgetRegistrationDetailsV1_Req_v1.nbsapdpi nbsapdpibean  = new IBgetRegistrationDetailsV1_Req_v1.nbsapdpi();
        IBgetRegistrationDetailsV1_Req_v1.nbsmsgi nbsmsgibean  = new IBgetRegistrationDetailsV1_Req_v1.nbsmsgi();
        IBgetRegistrationDetailsV1_Req_v1.nhp292i nhp292iBean = new IBgetRegistrationDetailsV1_Req_v1.nhp292i();
        
        nhp292iBean.subBranch = 'F';
        nhp292iBean.branch = '8392';
        nhp292iBean.siteType = 'ABS';
        nhp292iBean.manager = '';
        nhp292iBean.teller = '000878';
        nhp292iBean.agencyCode = '0';
        nhp292iBean.accessAccount = '9051337380';
        nhp292iBean.supervisor = '';
        nhp292iBean.serviceType = 'I';
        nhp292iBean.workstation = '';
        
        finalMsgIdbean.finalMsgClass = 'test';
        finalMsgIdbean.finalMsgCode = 'test';
        
        nbsmsgibean.msgTarget = 'BDP';
        nbsmsgibean.msgLanguage = 'E';
        nbsmsgibean.finalMsgId = finalMsgIdbean;
        
        nbsapdpibean.trace = 'test';
        nbsapdpibean.application = 'test';
        nbsapdpibean.channel = 'test';
        IBgetRegistrationDetailsV1bean.nbsapdpi = nbsapdpiBean;
        IBgetRegistrationDetailsV1bean.nbsmsgi = nbsmsgiBean;
        IBgetRegistrationDetailsV1bean.nhp292i = nhp292iBean;
        requestBean.IBgetRegistrationDetailsV1 = IBgetRegistrationDetailsV1bean;
        
        return requestbean;
        
    }
    
}