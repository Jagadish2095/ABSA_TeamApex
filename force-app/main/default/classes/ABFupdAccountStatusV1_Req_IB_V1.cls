public class ABFupdAccountStatusV1_Req_IB_V1 extends Base_IB{
/*
* Integration Request Bean for ABFupdAccountStatusV1 Service 
* @author Gulafsha
* @created 2020-12-01
*/
//public  ABFupdAccountStatusV1 ABFupdAccountStatusV1;
//public class ABFupdAccountStatusV1{    
    
    public String channel;
    public String application;
    public String trace;
    public String msgLanguage;
    public String msgTarget;
    public String finalMsgClass;
    public String finalMsgCode;
    public String corpCode;
    public String branchCode;
    public String workstationId;
    public String agencyCode;
    public String tellerCode;
    public String supervisorCode;
    public String branchSiteType;
    public String siteTypeAgency;
    public String accountNbr;
    public String accountStatus;
    public String mandate;
//} 
   
    public static ABFupdAccountStatusV1_Req_IB_V1 createDummyRequest() {
        
        ABFupdAccountStatusV1_Req_IB_V1 requestBean = new ABFupdAccountStatusV1_Req_IB_V1();
       // ABFupdAccountStatusV1_Req_IB_V1.ABFupdAccountStatusV1 ABFupdAccountStatusV1  = new ABFupdAccountStatusV1_Req_IB_V1.ABFupdAccountStatusV1();
        ABFupdAccountStatusV1_Req_IB_V1 ABFupdAccountStatusV1  = new ABFupdAccountStatusV1_Req_IB_V1();
        ABFupdAccountStatusV1.channel = 'Salesforce';
        ABFupdAccountStatusV1.application = 'Salesforce';
        ABFupdAccountStatusV1.trace = 'Y';
        ABFupdAccountStatusV1.msgLanguage = 'E';
        ABFupdAccountStatusV1.msgTarget = 'STD';
        ABFupdAccountStatusV1.finalMsgClass = '?';
        ABFupdAccountStatusV1.finalMsgCode = '?';
        ABFupdAccountStatusV1.corpCode = 'ABS';
        ABFupdAccountStatusV1.branchCode = '4927';
        ABFupdAccountStatusV1.workstationId = '99';
        ABFupdAccountStatusV1.agencyCode = '034';
        ABFupdAccountStatusV1.tellerCode = '042028';
        ABFupdAccountStatusV1.supervisorCode = '042028';
        ABFupdAccountStatusV1.branchSiteType = '034';
        ABFupdAccountStatusV1.siteTypeAgency = '034';
        ABFupdAccountStatusV1.accountNbr = '3001535059';
        ABFupdAccountStatusV1.accountStatus = '003';
        ABFupdAccountStatusV1.mandate = '021';
        requestBean = ABFupdAccountStatusV1;
        
        return requestBean;
        
    }
    
}