/**
* Apex Integration Utility Bean class for cclinkaccounttocombicardv3 service
* @author  Srikanth N : Absa
* @since   2020-05-05
*
**/
public class cclinkaccounttocombicardv3_IU_v1 {
    /* Creates a Request Bean from the Account 
* @param: List of Case objects
* @return: cclinkaccounttocombicardv3_Req_IB_v1 bean object
* */
    public static cclinkaccounttocombicardv3_Req_IB_v1 mapRequestFields(String cbNumber, String accountNumber,String cifKey){
        cclinkaccounttocombicardv3_Req_IB_v1 requestBean = new cclinkaccounttocombicardv3_Req_IB_v1();
        cclinkaccounttocombicardv3_Req_IB_v1.nbsmsgi nbsmsgiBean = new cclinkaccounttocombicardv3_Req_IB_v1.nbsmsgi();
        cclinkaccounttocombicardv3_Req_IB_v1.nbsapdpi nbsapdpiBean = new cclinkaccounttocombicardv3_Req_IB_v1.nbsapdpi();
        cclinkaccounttocombicardv3_Req_IB_v1.finalMsgId finalMsgIdBean = new cclinkaccounttocombicardv3_Req_IB_v1.finalMsgId();
        cclinkaccounttocombicardv3_Req_IB_v1.ccp303i ccp303iBean = new cclinkaccounttocombicardv3_Req_IB_v1.ccp303i();
        User loggedinUser = [SELECT Id,SiteCode__c,Teller_Operator_Code__c,SiteType__c,Supervisor__c FROM User Where id=:userinfo.getUserId()];
        nbsapdpiBean.application = 'BDP';
        nbsapdpiBean.channel = 'BDP';
        nbsapdpiBean.trace = 'Y';
        nbsmsgiBean.msgTarget = 'STD';
        nbsmsgiBean.msgLanguage = 'E';
        finalMsgIdbean.finalMsgClass = '';
        finalMsgIdbean.finalMsgCode = '';
        nbsmsgiBean.finalMsgId = finalMsgIdbean;
        ccp303iBean.tellerCode = loggedinUser.Teller_Operator_Code__c; //'999999';
        ccp303iBean.workStation = '99';
        ccp303iBean.supervisor = loggedinUser.Supervisor__c;//'999999';
        ccp303iBean.branchCode = loggedinUser.SiteCode__c;//'8193';
        ccp303iBean.combiNbr = cbNumber;//'04483850000284469';
        ccp303iBean.inpAccntNbr = accountNumber; //'4048276744';
        ccp303iBean.autoLinkInd = 'Y';
        ccp303iBean.ownCifInd = '';
        ccp303iBean.poaInd = '';
        ccp303iBean.jointAccInd = '';
        ccp303iBean.soleTraderInd = '';
        ccp303iBean.bankInterInd = '';
        ccp303iBean.clientCode = cifKey;//'COMBIK 002';
        cclinkaccounttocombicardv3_Req_IB_v1.CClinkAccountToCombiCardV3 CClinkAccountToCombiCardV3Bean = new cclinkaccounttocombicardv3_Req_IB_v1.CClinkAccountToCombiCardV3();
        CClinkAccountToCombiCardV3Bean.nbsapdpi = nbsapdpiBean;
        CClinkAccountToCombiCardV3Bean.nbsmsgi = nbsmsgiBean;
        CClinkAccountToCombiCardV3Bean.ccp303i = ccp303iBean;
        requestBean.CClinkAccountToCombiCardV3 = CClinkAccountToCombiCardV3Bean;        
        return requestBean;  
    }
    
    
    /* Creates a bean from the response 
* @param: HTTP Response
* @return: cclinkaccounttocombicardv3_Resp_IB_v1 bean object
* */
    
    public static cclinkaccounttocombicardv3_Resp_IB_v1 mapResponseFields(HttpResponse respP){
        System.debug('respP body'+respP.getBody());//To be removed
        cclinkaccounttocombicardv3_Resp_IB_v1 responseBean = (cclinkaccounttocombicardv3_Resp_IB_v1)JSON.deserialize(respP.getBody(),cclinkaccounttocombicardv3_Resp_IB_v1.class);
        cclinkaccounttocombicardv3_Resp_IB_v1.cclinkaccounttocombicardv3Response WQgetAnalystCommentsresp = new cclinkaccounttocombicardv3_Resp_IB_v1.cclinkaccounttocombicardv3Response();
        responseBean.StatusMessage = respP.getStatus();
        responseBean.StatusCode = respP.getstatusCode();
        System.debug('cclinkaccounttocombicardv3 Service Success Response Bean after : ' + responseBean);//To be removed
        return responseBean;
    }
    
    /* Creates a custom bean with the parameters mapped to their respective fields (Used for creating failed response beans)
* @param: Status Code
* @param: Status
* @param: message
* @return: cclinkaccounttocombicardv3_Resp_IB_v1 bean object
* */
    public static cclinkaccounttocombicardv3_Resp_IB_v1 mapFailedResponseFields(Integer statusCodeP, String statusP, String messageP){
        cclinkaccounttocombicardv3_Resp_IB_v1 responseBean = new cclinkaccounttocombicardv3_Resp_IB_v1();
        responseBean.StatusCode = statusCodeP;
        responseBean.StatusMessage = statusP;
        System.debug('cclinkaccounttocombicardv3 Service Failed Response Bean: ' + responseBean);//To be removed
        return responseBean;
    }
}