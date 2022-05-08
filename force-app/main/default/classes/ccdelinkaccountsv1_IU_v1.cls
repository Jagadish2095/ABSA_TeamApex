/**
* Apex Integration Utility Bean class for ccdelinkaccountsv1 service
* @author  Srikanth N : Absa
* @since   2020-05-05
*
**/
public class ccdelinkaccountsv1_IU_v1 {
    /* Creates a Request Bean from the Account 
* @param: List of Case objects
* @return: ccdelinkaccountsv1_Req_IB_v1 bean object
* */
    public static ccdelinkaccountsv1_Req_IB_v1 mapRequestFields(String cbNumber, List<String> accountNumberList){
        ccdelinkaccountsv1_Req_IB_v1 requestBean = new ccdelinkaccountsv1_Req_IB_v1();
        ccdelinkaccountsv1_Req_IB_v1.nbsmsgi nbsmsgiBean = new ccdelinkaccountsv1_Req_IB_v1.nbsmsgi();
        ccdelinkaccountsv1_Req_IB_v1.nbsapdpi nbsapdpiBean = new ccdelinkaccountsv1_Req_IB_v1.nbsapdpi();
        ccdelinkaccountsv1_Req_IB_v1.finalMsgId finalMsgIdBean = new ccdelinkaccountsv1_Req_IB_v1.finalMsgId();
        
        List<ccdelinkaccountsv1_Req_IB_v1.delinkAccntLst> delinkAccntLstBeanList = new List<ccdelinkaccountsv1_Req_IB_v1.delinkAccntLst>();
        ccdelinkaccountsv1_Req_IB_v1.ccp309i ccp309iBean = new ccdelinkaccountsv1_Req_IB_v1.ccp309i();
         User loggedinUser = [SELECT Id,SiteCode__c,Teller_Operator_Code__c,SiteType__c,Supervisor__c FROM User Where id=:userinfo.getUserId()];
         
        nbsapdpiBean.application = 'BDP';
        nbsapdpiBean.channel = 'BDP';
        nbsapdpiBean.trace = 'Y';
        
        nbsmsgiBean.msgTarget = 'STD';
        nbsmsgiBean.msgLanguage = 'E';
        nbsmsgiBean.finalMsgId = finalMsgIdbean;
        
        finalMsgIdbean.finalMsgClass = '';
        finalMsgIdbean.finalMsgCode = '';
        
        ccp309iBean.tellerCode = loggedinUser.Teller_Operator_Code__c;//'999999';
        ccp309iBean.workStation = '9';
        ccp309iBean.supervisor = loggedinUser.Supervisor__c;//'999999';
        ccp309iBean.branchCode = loggedinUser.SiteCode__c;//'8193';
        ccp309iBean.combiNbr = cbNumber;//'04483850000284469';
        ccp309iBean.inpAccntNbr = '0'; 
        ccp309iBean.nbrAccntReq = ''+accountNumberList.size(); //'0';
        
        for(String accountNumber : accountNumberList){
            ccdelinkaccountsv1_Req_IB_v1.delinkAccntLst delinkAccntLstBean = new ccdelinkaccountsv1_Req_IB_v1.delinkAccntLst();
            if(accountNumber != null && accountNumber != '' && accountNumber != 'undefined'){
                delinkAccntLstBean.accntNbr = accountNumber;
                delinkAccntLstBean.delinkInd = 'Y';
                delinkAccntLstBeanList.add(delinkAccntLstBean);
            }
        }
        
        ccp309iBean.delinkAccntLst = delinkAccntLstBeanList;
        
        ccdelinkaccountsv1_Req_IB_v1.CCdelinkAccountsV1 CCdelinkAccountsV1Bean = new ccdelinkaccountsv1_Req_IB_v1.CCdelinkAccountsV1();
        CCdelinkAccountsV1Bean.nbsapdpi = nbsapdpiBean;
        CCdelinkAccountsV1Bean.nbsmsgi = nbsmsgiBean;
        CCdelinkAccountsV1Bean.ccp309i = ccp309iBean;
        
        requestBean.CCdelinkAccountsV1 = CCdelinkAccountsV1Bean;
        
        return requestBean;  
    }
    
    
    /* Creates a bean from the response 
* @param: HTTP Response
* @return: ccdelinkaccountsv1_Resp_IB_v1 bean object
* */
    
    public static ccdelinkaccountsv1_Resp_IB_v1 mapResponseFields(HttpResponse respP){
        System.debug('respP body'+respP.getBody());//To be removed
        
        ccdelinkaccountsv1_Resp_IB_v1 responseBean = (ccdelinkaccountsv1_Resp_IB_v1)JSON.deserialize(respP.getBody(),ccdelinkaccountsv1_Resp_IB_v1.class);
        ccdelinkaccountsv1_Resp_IB_v1.ccdelinkaccountsv1Response WQgetAnalystCommentsresp = new ccdelinkaccountsv1_Resp_IB_v1.ccdelinkaccountsv1Response();
        responseBean.StatusMessage = respP.getStatus();
        responseBean.StatusCode = respP.getstatusCode();
        System.debug('ccdelinkaccountsv1 Service Success Response Bean after : ' + responseBean);//To be removed
        return responseBean;
    }
    
    /* Creates a custom bean with the parameters mapped to their respective fields (Used for creating failed response beans)
* @param: Status Code
* @param: Status
* @param: message
* @return: ccdelinkaccountsv1_Resp_IB_v1 bean object
* */
    public static ccdelinkaccountsv1_Resp_IB_v1 mapFailedResponseFields(Integer statusCodeP, String statusP, String messageP){
        ccdelinkaccountsv1_Resp_IB_v1 responseBean = new ccdelinkaccountsv1_Resp_IB_v1();
        responseBean.StatusCode = statusCodeP;
        responseBean.StatusMessage = statusP;
        System.debug('ccdelinkaccountsv1 Service Failed Response Bean: ' + responseBean);//To be removed
        return responseBean;
    }
}