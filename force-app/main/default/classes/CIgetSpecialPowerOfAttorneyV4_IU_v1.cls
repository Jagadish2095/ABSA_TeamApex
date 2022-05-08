public class CIgetSpecialPowerOfAttorneyV4_IU_v1 {
    /* Creates a Request Bean from the Account 
* @param: List of Case objects
* @return: CIgetSpecialPowerOfAttorneyV4_Req_IB_v1 bean object
* */
    public static CIgetSpecialPowerOfAttorneyV4_Req_IB_v1 mapRequestFields(String accountNbr){
           User loggedinUser = [SELECT Id,SiteCode__c,Teller_Operator_Code__c,SiteType__c,Supervisor__c FROM User Where id=:userinfo.getUserId()];
        
        CIgetSpecialPowerOfAttorneyV4_Req_IB_v1 requestBean = new CIgetSpecialPowerOfAttorneyV4_Req_IB_v1();
        CIgetSpecialPowerOfAttorneyV4_Req_IB_v1.nbsmsgi nbsmsgiBean = new CIgetSpecialPowerOfAttorneyV4_Req_IB_v1.nbsmsgi();
        CIgetSpecialPowerOfAttorneyV4_Req_IB_v1.nbsapdpi nbsapdpiBean = new CIgetSpecialPowerOfAttorneyV4_Req_IB_v1.nbsapdpi();
        CIgetSpecialPowerOfAttorneyV4_Req_IB_v1.finalMsgId finalMsgIdBean = new CIgetSpecialPowerOfAttorneyV4_Req_IB_v1.finalMsgId();
        CIgetSpecialPowerOfAttorneyV4_Req_IB_v1.cip080di cip080diBean = new CIgetSpecialPowerOfAttorneyV4_Req_IB_v1.cip080di();
        
        nbsapdpiBean.application = 'BDP';
        nbsapdpiBean.channel = 'BDP';
        nbsapdpiBean.trace = 'Y';
        nbsmsgiBean.msgTarget = 'STD';
        nbsmsgiBean.msgLanguage = 'E';
        finalMsgIdbean.finalMsgClass = '';
        finalMsgIdbean.finalMsgCode = '';
        nbsmsgiBean.finalMsgId = finalMsgIdbean;
        cip080diBean.accountNumber = accountNbr; //'4047414349';
        //cip080diBean.clientCode = '';
        cip080diBean.option = 'E';
        cip080diBean.siteCode = loggedinUser.SiteCode__c;//'8918';
        cip080diBean.maxRetrieve = '20';
        cip080diBean.restartKey = '0';
        
        CIgetSpecialPowerOfAttorneyV4_Req_IB_v1.CIgetSpecialPowerOfAttorneyV4 CIgetSpecialPowerOfAttorneyV4Bean = new CIgetSpecialPowerOfAttorneyV4_Req_IB_v1.CIgetSpecialPowerOfAttorneyV4();
        CIgetSpecialPowerOfAttorneyV4Bean.nbsapdpi = nbsapdpiBean;
        CIgetSpecialPowerOfAttorneyV4Bean.nbsmsgi = nbsmsgiBean;
        CIgetSpecialPowerOfAttorneyV4Bean.cip080di = cip080diBean;
        requestBean.CIgetSpecialPowerOfAttorneyV4 = CIgetSpecialPowerOfAttorneyV4Bean;        
        return requestBean;  
    }
    
    
    /* Creates a bean from the response 
* @param: HTTP Response
* @return: CIgetSpecialPowerOfAttorneyV4_Resp_IB_v1 bean object
* */
    
    public static CIgetSpecialPowerOfAttorneyV4_Resp_IB_v1 mapResponseFields(HttpResponse respP){
        System.debug('respP body'+respP.getBody());//To be removed
        CIgetSpecialPowerOfAttorneyV4_Resp_IB_v1 responseBean = (CIgetSpecialPowerOfAttorneyV4_Resp_IB_v1)JSON.deserialize(respP.getBody(),CIgetSpecialPowerOfAttorneyV4_Resp_IB_v1.class);
        CIgetSpecialPowerOfAttorneyV4_Resp_IB_v1.CIgetSpecialPowerOfAttorneyV4Response WQgetAnalystCommentsresp = new CIgetSpecialPowerOfAttorneyV4_Resp_IB_v1.CIgetSpecialPowerOfAttorneyV4Response();
        responseBean.StatusMessage = respP.getStatus();
        responseBean.StatusCode = respP.getstatusCode();
        System.debug('CIgetSpecialPowerOfAttorneyV4 Service Success Response Bean after : ' + responseBean);//To be removed
        return responseBean;
    }
    
    /* Creates a custom bean with the parameters mapped to their respective fields (Used for creating failed response beans)
* @param: Status Code
* @param: Status
* @param: message
* @return: CIgetSpecialPowerOfAttorneyV4_Resp_IB_v1 bean object
* */
    public static CIgetSpecialPowerOfAttorneyV4_Resp_IB_v1 mapFailedResponseFields(Integer statusCodeP, String statusP, String messageP){
        CIgetSpecialPowerOfAttorneyV4_Resp_IB_v1 responseBean = new CIgetSpecialPowerOfAttorneyV4_Resp_IB_v1();
        responseBean.StatusCode = statusCodeP;
        responseBean.StatusMessage = statusP;
        System.debug('CIgetSpecialPowerOfAttorneyV4 Service Failed Response Bean: ' + responseBean);//To be removed
        return responseBean;
    }
}