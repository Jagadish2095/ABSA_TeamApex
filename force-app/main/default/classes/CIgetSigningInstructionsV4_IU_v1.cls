/*
* Integration Utility Bean for CIgetSigningInstructionsV4 Service
* @author Prashant Jain
* @created 2020-03-05
*/

public class CIgetSigningInstructionsV4_IU_v1 {
    
    /* Creates a request bean
* @param: accountNumber
* @param: siteCode
* @param: maxRetrieve
* @return: CIgetSigningInstructionsV4_Req_IB_v1 bean object
*/
    public static CIgetSigningInstructionsV4_Req_IB_v1 mapRequestFields(String accountNumber, String siteCode, String maxRetrieve) {
        
        CIgetSigningInstructionsV4_Req_IB_v1 requestBean = new CIgetSigningInstructionsV4_Req_IB_v1();
        requestBean.CIgetSigningInstructionsV4 = new CIgetSigningInstructionsV4_Req_IB_v1.CIgetSigningInstructionsV4();
        requestBean.CIgetSigningInstructionsV4.nbsapdpi = new CIgetSigningInstructionsV4_Req_IB_v1.Nbsapdpi();
        requestBean.CIgetSigningInstructionsV4.nbsmsgi = new CIgetSigningInstructionsV4_Req_IB_v1.Nbsmsgi();
        requestBean.CIgetSigningInstructionsV4.cip082di = new CIgetSigningInstructionsV4_Req_IB_v1.Cip082di();
        
        requestBean.CIgetSigningInstructionsV4.nbsapdpi.channel = 'BPD';
        requestBean.CIgetSigningInstructionsV4.nbsapdpi.application = 'BPD';
        requestBean.CIgetSigningInstructionsV4.nbsapdpi.trace = 'Y';
        requestBean.CIgetSigningInstructionsV4.nbsmsgi.msgLanguage = 'E';
        requestBean.CIgetSigningInstructionsV4.nbsmsgi.msgTarget = 'STD';
        
        requestBean.CIgetSigningInstructionsV4.cip082di.option = 'E';
        requestBean.CIgetSigningInstructionsV4.cip082di.restartKey = 'Y';
        
        requestBean.CIgetSigningInstructionsV4.cip082di.accountNumber = accountNumber;
        requestBean.CIgetSigningInstructionsV4.cip082di.siteCode = siteCode;
        requestBean.CIgetSigningInstructionsV4.cip082di.maxRetrieve = maxRetrieve;
        
        System.debug('CIgetSigningInstructionsV4 Request Bean: ' + requestBean);
        return requestBean;
    }
    
    /* Creates a bean from the response
* @param: HTTP Response
* @return: CIgetSigningInstructionsV4_Resp_IB_v1 bean object
*/
    public static CIgetSigningInstructionsV4_Resp_IB_v1 mapResponseFields(HttpResponse responseP) {
        CIgetSigningInstructionsV4_Resp_IB_v1 responseBeanContent;
        
        try {
            CIgetSigningInstructionsV4_Resp_IB_v1 responseBean = new CIgetSigningInstructionsV4_Resp_IB_v1();
            responseBeanContent = (CIgetSigningInstructionsV4_Resp_IB_v1)responseBean.deserialize(responseP.getBody(), CIgetSigningInstructionsV4_Resp_IB_v1.class);
            
            responseBeanContent.status = responseP.getStatus();
            responseBeanContent.statusCode = responseP.getStatusCode();
            //responseBeanContent.message = '';
        } catch (Exception e) {
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            responseBeanContent = mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, StringConstants.Sevice500InternalErrorMessage);
            System.debug(message);
        }
        
        System.debug('CIgetSigningInstructionsV4 Response bean: ' + responseBeanContent);
        return responseBeanContent;
    }
    
    /* Creates a custom bean with the parameters mapped to their respective fields (Used for creating failed response beans)
* @param: Status Code
* @param: Status
* @param: message
* @return: CIgetSigningInstructionsV4_Resp_IB_v1 bean object
* */
    
    public static CIgetSigningInstructionsV4_Resp_IB_v1 mapFailedResponseFields(Integer statusCodeP, String statusP, String messageP) {
        CIgetSigningInstructionsV4_Resp_IB_v1 responseBean = new CIgetSigningInstructionsV4_Resp_IB_v1();
        responseBean.status = statusP;
        responseBean.statusCode = statusCodeP;
        responseBean.message = messageP;
        
        System.debug('CIgetSigningInstructionsV4 Failed Response bean: ' + responseBean);
        return responseBean;
    }
}