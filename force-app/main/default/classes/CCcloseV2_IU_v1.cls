/*
* Integration Utility  Bean for CCcloseV2 Service
* @author Lulu Rankwe
* @created 19-03-2020
*/
public class CCcloseV2_IU_v1 {
    
        
    public static CCcloseV2_Req_IB_v1 mapRequestFields(String combiNbr,String reasonTrans,String subReasonTrans){
        CCcloseV2_Req_IB_v1 reqBean = new CCcloseV2_Req_IB_v1();
        List<User> currentUser = [SELECT Id,SiteCode__c, Teller_Operator_Code__c,Supervisor__c FROM USER WHERE Id =: Userinfo.getUserId() limit 1]; 

        
        reqBean.channel = 'BDP';
        reqBean.application = 'BDP';
        reqBean.trace = 'Y';
        reqBean.msgLanguage = 'E';
        reqBean.msgTarget = 'STD';     
        reqBean.workStation = '99';
        reqBean.tellerCode = currentUser[0].Teller_Operator_Code__c;	//'25698';
        reqBean.supervisor = currentUser[0].Supervisor__c;		// '25699';
        reqBean.branchCode = '0';//currentUser[0].SiteCode__c;//'8198';
        reqBean.combiNbr = combiNbr;
        reqBean.reason = reasonTrans;//'CUSREQ';
        reqBean.subReason = subReasonTrans;//'RTNCRD';
        
       
        return reqBean;      
    }
    
    public static CCcloseV2_Resp_IB_v1 mapResponseFields(HttpResponse responseP){ 

        CCcloseV2_Resp_IB_v1 bean = new CCcloseV2_Resp_IB_v1();
        CCcloseV2_Resp_IB_v1 responseBean = (CCcloseV2_Resp_IB_v1)bean.deserialize(responseP.getBody(), CCcloseV2_Resp_IB_v1.class);
        responseBean.status = responseP.getStatus();
        responseBean.statusCode = responseP.getstatusCode();
        return responseBean;        
     }
    
    
    public static CCcloseV2_Resp_IB_v1 mapFailedResponseFields(String statusP, Integer statusCodeP, String messageP){
        
        CCcloseV2_Resp_IB_v1 responseBean = new CCcloseV2_Resp_IB_v1();
        responseBean.status = statusP;
        responseBean.statusCode = statusCodeP;
        responseBean.message = messageP;
        
        return responseBean;
    }
    

}