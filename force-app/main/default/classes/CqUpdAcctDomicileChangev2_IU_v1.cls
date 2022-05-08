/*
 * Integration Utility Bean for CqUpdAcctDomicileChangev2 Service
 * @author Saurabh Pandey
 * @created 2020-04-07
 */


public class CqUpdAcctDomicileChangev2_IU_v1 {

    
    public static CqUpdAcctDomicileChangev2_Req_IB_v1 mapRequestFields(String accountNbr,String newBranch, String branchCode, String tellerCode, String supervisorCode){
           CqUpdAcctDomicileChangev2_Req_IB_v1 requestBean = new CqUpdAcctDomicileChangev2_Req_IB_v1();
           requestBean.CQupdAcctDomicileChangeV2 = new CqUpdAcctDomicileChangev2_Req_IB_v1.CQupdAcctDomicileChangeV2();
           requestBean.CQupdAcctDomicileChangeV2.Nbsapdpi  = new CqUpdAcctDomicileChangev2_Req_IB_v1.Nbsapdpi();
           requestBean.CQupdAcctDomicileChangeV2.Cqh538i  = new CqUpdAcctDomicileChangev2_Req_IB_v1.Cqh538i();
           requestBean.CQupdAcctDomicileChangeV2.Nbsmsgi = new CqUpdAcctDomicileChangev2_Req_IB_v1.Nbsmsgi();
        
        
           //requestBean.CQupdAcctDomicileChangeV2.FinalMsgId.finalMsgClass = '';
           //requestBean.CQupdAcctDomicileChangeV2.FinalMsgId.finalMsgCode = ''; 
           
           requestBean.CQupdAcctDomicileChangeV2.Nbsapdpi.channel = 'BDP';
           requestBean.CQupdAcctDomicileChangeV2.Nbsapdpi.application = 'BDP';
           requestBean.CQupdAcctDomicileChangeV2.Nbsapdpi.trace = 'Y';
           
           requestBean.CQupdAcctDomicileChangeV2.Cqh538i.accountNbr = accountNbr;
           requestBean.CQupdAcctDomicileChangeV2.Cqh538i.newBranch = newBranch;
           requestBean.CQupdAcctDomicileChangeV2.Cqh538i.branchCode = branchCode;
           requestBean.CQupdAcctDomicileChangeV2.Cqh538i.agencyCode = '034';
           requestBean.CQupdAcctDomicileChangeV2.Cqh538i.agencySiteType = '034';
           requestBean.CQupdAcctDomicileChangeV2.Cqh538i.tellerCode = tellerCode;
           requestBean.CQupdAcctDomicileChangeV2.Cqh538i.supervisorCode = supervisorCode;
           requestBean.CQupdAcctDomicileChangeV2.Cqh538i.corpCode = 'ABS';
           
           requestBean.CQupdAcctDomicileChangeV2.Nbsmsgi.msgLanguage = 'E';
           requestBean.CQupdAcctDomicileChangeV2.Nbsmsgi.msgTarget = 'STD';
           //requestBean.CQupdAcctDomicileChangeV2.Nbsmsgi.finalMsgId = FinalMsgIdRequest;  
           system.debug('CQupdAcctDomicileChangeV2 Request Bean: ' + requestBean);  
           return requestBean;    
    }
    
    
        /* Creates a bean from the response
     * @param: HTTP Response
     * @return: CqUpdAcctDomicileChangev2_Resp_IB_v1 bean object
     */
    public static CqUpdAcctDomicileChangev2_Resp_IB_v1 mapResponseFields(HttpResponse responseP) {
        CqUpdAcctDomicileChangev2_Resp_IB_v1 responseBeanContent;
        
        try {
            CqUpdAcctDomicileChangev2_Resp_IB_v1 responseBean = new CqUpdAcctDomicileChangev2_Resp_IB_v1();
            responseBeanContent = (CqUpdAcctDomicileChangev2_Resp_IB_v1)responseBean.deserialize(responseP.getBody(), CqUpdAcctDomicileChangev2_Resp_IB_v1.class);
            
            responseBeanContent.status = responseP.getStatus();
            responseBeanContent.statusCode = responseP.getStatusCode();
            //responseBeanContent.message = '';
        } catch (Exception e) {
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            responseBeanContent = mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, StringConstants.Sevice500InternalErrorMessage);
            System.debug(message);
        }

        System.debug('CqUpdAcctDomicileChangev2 Response bean: ' + responseBeanContent);
        return responseBeanContent;
    }
    
        /* Creates a custom bean with the parameters mapped to their respective fields (Used for creating failed response beans)
     * @param: Status Code
     * @param: Status
     * @param: message
     * @return: CqUpdAcctDomicileChangev2_Resp_IB_v1 bean object
     * */

    public static CqUpdAcctDomicileChangev2_Resp_IB_v1 mapFailedResponseFields(Integer statusCodeP, String statusP, String messageP) {
        CqUpdAcctDomicileChangev2_Resp_IB_v1 responseBean = new CqUpdAcctDomicileChangev2_Resp_IB_v1();
        responseBean.status = statusP;
        responseBean.statusCode = statusCodeP;
        responseBean.message = messageP;

        System.debug('CqUpdAcctDomicileChangev2 Failed Response bean: ' + responseBean);
        return responseBean;
    }
}