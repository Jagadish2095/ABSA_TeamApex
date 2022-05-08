/**
* Apex Integration Utility Bean class for cigetgeneralpowerofattorneyv4 service
* @author  Srikanth N : Absa
* @since   2020-0-05
*
**/
public class cigetgeneralpowerofattorneyv4_IU_v1 {
    /* Creates a Request Bean from the Account 
* @param: List of Case objects
* @return: cigetgeneralpowerofattorneyv4_Req_IB_v1 bean object
* */
    public static cigetgeneralpowerofattorneyv4_Req_IB_v1 mapRequestFields(String accountNbr){
           User loggedinUser = [SELECT Id,SiteCode__c,Teller_Operator_Code__c,SiteType__c,Supervisor__c FROM User Where id=:userinfo.getUserId()];
        
        cigetgeneralpowerofattorneyv4_Req_IB_v1 requestBean = new cigetgeneralpowerofattorneyv4_Req_IB_v1();
        cigetgeneralpowerofattorneyv4_Req_IB_v1.nbsmsgi nbsmsgiBean = new cigetgeneralpowerofattorneyv4_Req_IB_v1.nbsmsgi();
        cigetgeneralpowerofattorneyv4_Req_IB_v1.nbsapdpi nbsapdpiBean = new cigetgeneralpowerofattorneyv4_Req_IB_v1.nbsapdpi();
        cigetgeneralpowerofattorneyv4_Req_IB_v1.finalMsgId finalMsgIdBean = new cigetgeneralpowerofattorneyv4_Req_IB_v1.finalMsgId();
        cigetgeneralpowerofattorneyv4_Req_IB_v1.cip081di cip081diBean = new cigetgeneralpowerofattorneyv4_Req_IB_v1.cip081di();
        
        nbsapdpiBean.application = 'BDP';
        nbsapdpiBean.channel = 'BDP';
        nbsapdpiBean.trace = 'Y';
        nbsmsgiBean.msgTarget = 'STD';
        nbsmsgiBean.msgLanguage = 'E';
        finalMsgIdbean.finalMsgClass = '';
        finalMsgIdbean.finalMsgCode = '';
        nbsmsgiBean.finalMsgId = finalMsgIdbean;
        cip081diBean.accountNumber =  accountNbr ;//'3501000021';
        cip081diBean.clientCode = '';
        cip081diBean.option = 'E';
        cip081diBean.siteCode = loggedinUser.SiteCode__c; // '8918';
        cip081diBean.maxRetrieve = '20';
        cip081diBean.restartKey = '0';
        
        cigetgeneralpowerofattorneyv4_Req_IB_v1.cigetgeneralpowerofattorneyv4 cigetgeneralpowerofattorneyv4Bean = new cigetgeneralpowerofattorneyv4_Req_IB_v1.cigetgeneralpowerofattorneyv4();
        cigetgeneralpowerofattorneyv4Bean.nbsapdpi = nbsapdpiBean;
        cigetgeneralpowerofattorneyv4Bean.nbsmsgi = nbsmsgiBean;
        cigetgeneralpowerofattorneyv4Bean.cip081di = cip081diBean;
        requestBean.cigetgeneralpowerofattorneyv4 = cigetgeneralpowerofattorneyv4Bean;        
        return requestBean;  
    }
    
    
    /* Creates a bean from the response 
* @param: HTTP Response
* @return: cigetgeneralpowerofattorneyv4_Resp_IB_v1 bean object
* */
    
    public static cigetgeneralpowerofattorneyv4_Resp_IB_v1 mapResponseFields(HttpResponse respP){
        System.debug('respP body'+respP.getBody());//To be removed
        cigetgeneralpowerofattorneyv4_Resp_IB_v1 responseBean = (cigetgeneralpowerofattorneyv4_Resp_IB_v1)JSON.deserialize(respP.getBody(),cigetgeneralpowerofattorneyv4_Resp_IB_v1.class);
        cigetgeneralpowerofattorneyv4_Resp_IB_v1.cigetgeneralpowerofattorneyv4Response WQgetAnalystCommentsresp = new cigetgeneralpowerofattorneyv4_Resp_IB_v1.cigetgeneralpowerofattorneyv4Response();
        responseBean.StatusMessage = respP.getStatus();
        responseBean.StatusCode = respP.getstatusCode();
        //responseBean.idType = respP.
            //= Sys_Utilities_Integration.getIntegrationTranslationInternalValue(StringConstants.ECASA_STRING, StringConstants.FIELD_IDENTITY_TYPE_STRING, respP.idType, StringConstants.OUTBOUND_RECORD_TYPE);
        System.debug('cigetgeneralpowerofattorneyv4 Service Success Response Bean after : ' + responseBean);//To be removed
        return responseBean;
    }
    
    /* Creates a custom bean with the parameters mapped to their respective fields (Used for creating failed response beans)
* @param: Status Code
* @param: Status
* @param: message
* @return: cigetgeneralpowerofattorneyv4_Resp_IB_v1 bean object
* */
    public static cigetgeneralpowerofattorneyv4_Resp_IB_v1 mapFailedResponseFields(Integer statusCodeP, String statusP, String messageP){
        cigetgeneralpowerofattorneyv4_Resp_IB_v1 responseBean = new cigetgeneralpowerofattorneyv4_Resp_IB_v1();
        responseBean.StatusCode = statusCodeP;
        responseBean.StatusMessage = statusP;
        System.debug('cigetgeneralpowerofattorneyv4 Service Failed Response Bean: ' + responseBean);//To be removed
        return responseBean;
    }
}