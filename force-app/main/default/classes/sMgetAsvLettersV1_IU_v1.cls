/**
 * @description       : Integration Utility Bean for sMgetAsvLettersV1 Service
 * @author            : Prashant Jain
 * @last modified on  : 2021-06-11
 * @last modified by  : Prashant Jain
 * Modifications Log 
 * Ver   Date         Author          Modification
 * 1.0   2021-06-11   Prashant Jain   Initial Version
**/

public class sMgetAsvLettersV1_IU_v1 {

    /**
    * @description Creates a request bean
    * @author Prashant Jain | 2021-06-11 
    * @param clcd 
    * @return sMgetAsvLettersV1_Req_IB_v1 
    **/
    public static sMgetAsvLettersV1_Req_IB_v1 mapRequestFields(String clcd) {
		
        sMgetAsvLettersV1_Req_IB_v1 requestBean = new sMgetAsvLettersV1_Req_IB_v1();
        
        sMgetAsvLettersV1_Req_IB_v1.SMgetASVLettersV1 sMgetASVLettersV1 = new sMgetAsvLettersV1_Req_IB_v1.SMgetASVLettersV1();
        
        sMgetAsvLettersV1_Req_IB_v1.Nbsapdpi nbsapdpi = new sMgetAsvLettersV1_Req_IB_v1.Nbsapdpi();
        nbsapdpi.channel = 'BDP';
        nbsapdpi.application = 'BDP';
        nbsapdpi.trace = 'Y';
        
        sMgetAsvLettersV1_Req_IB_v1.Nbsmsgi nbsmsgi = new sMgetAsvLettersV1_Req_IB_v1.Nbsmsgi();
        nbsmsgi.msgLanguage = 'E';
        nbsmsgi.msgTarget = 'STD';
        
        sMgetAsvLettersV1_Req_IB_v1.Smn140i smn140i = new sMgetAsvLettersV1_Req_IB_v1.Smn140i();
        smn140i.clcd = clcd;
        
        sMgetASVLettersV1.nbsapdpi = nbsapdpi;
        sMgetASVLettersV1.nbsmsgi = nbsmsgi;
        sMgetASVLettersV1.smn140i = smn140i;
        
        requestBean.sMgetASVLettersV1 = sMgetASVLettersV1;
		//requestBean.smn140i = new sMgetAsvLettersV1_Req_IB_v1.Smn140i();
		
		//requestBean.smn140i.clcd = clcd;
		
        System.debug('sMgetAsvLettersV1 Request Bean: ' + requestBean);
        return requestBean;
    }

    /**
    * @description Creates a bean from the response
    * @author Prashant Jain | 2021-06-11 
    * @param responseP 
    * @return sMgetAsvLettersV1_Resp_IB_v1 
    **/
    public static sMgetAsvLettersV1_Resp_IB_v1 mapResponseFields(HttpResponse responseP) {
        sMgetAsvLettersV1_Resp_IB_v1 responseBeanContent;
        
        try {
            sMgetAsvLettersV1_Resp_IB_v1 responseBean = new sMgetAsvLettersV1_Resp_IB_v1();
            responseBeanContent = (sMgetAsvLettersV1_Resp_IB_v1)responseBean.deserialize(responseP.getBody(), sMgetAsvLettersV1_Resp_IB_v1.class);
            
            responseBeanContent.status = responseP.getStatus();
            responseBeanContent.statusCode = responseP.getStatusCode();
            //responseBeanContent.message = '';
        } catch (Exception e) {
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            responseBeanContent = mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, StringConstants.Sevice500InternalErrorMessage);
            System.debug(message);
        }

        System.debug('sMgetAsvLettersV1 Response bean: ' + responseBeanContent);
        return responseBeanContent;
    }


    /**
    * @description Creates a custom bean with the parameters mapped to their respective fields (Used for creating failed response beans)
    * @author Prashant Jain | 2021-06-11 
    * @param statusCodeP 
    * @param statusP 
    * @param messageP 
    * @return sMgetAsvLettersV1_Resp_IB_v1 
    **/
    public static sMgetAsvLettersV1_Resp_IB_v1 mapFailedResponseFields(Integer statusCodeP, String statusP, String messageP) {
        sMgetAsvLettersV1_Resp_IB_v1 responseBean = new sMgetAsvLettersV1_Resp_IB_v1();
        responseBean.status = statusP;
        responseBean.statusCode = statusCodeP;
        responseBean.message = messageP;

        System.debug('sMgetAsvLettersV1 Failed Response bean: ' + responseBean);
        return responseBean;
    }
}