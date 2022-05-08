/**
 * @description       : Integration Utility Bean for sMgetAsvCessionOfSharesV1 Service
 * @author            : Prashant Jain
 * @last modified on  : 2021-06-11
 * @last modified by  : Prashant Jain
 * Modifications Log 
 * Ver   Date         Author          Modification
 * 1.0   2021-06-11   Prashant Jain   Initial Version
**/

public class sMgetAsvCessionOfSharesV1_IU_v1 {

    /**
    * @description Creates a request bean
    * @author Prashant Jain | 2021-06-11 
    * @param clcd 
    * @return sMgetAsvCessionOfSharesV1_Req_IB_v1 
    **/
    public static sMgetAsvCessionOfSharesV1_Req_IB_v1 mapRequestFields(String clcd) {
		
        sMgetAsvCessionOfSharesV1_Req_IB_v1 requestBean = new sMgetAsvCessionOfSharesV1_Req_IB_v1();
      
        sMgetAsvCessionOfSharesV1_Req_IB_v1.SMgetASVCessionOfSharesV1 sMgetASVCessionOfSharesV1 = new sMgetAsvCessionOfSharesV1_Req_IB_v1.SMgetASVCessionOfSharesV1();
        
        sMgetAsvCessionOfSharesV1_Req_IB_v1.Nbsapdpi nbsapdpi = new sMgetAsvCessionOfSharesV1_Req_IB_v1.Nbsapdpi();
        nbsapdpi.channel = 'BDP';
        nbsapdpi.application = 'BDP';
        nbsapdpi.trace = 'Y';
        
        sMgetAsvCessionOfSharesV1_Req_IB_v1.Nbsmsgi nbsmsgi = new sMgetAsvCessionOfSharesV1_Req_IB_v1.Nbsmsgi();
        nbsmsgi.msgLanguage = 'E';
        nbsmsgi.msgTarget = 'STD';
        
        sMgetAsvCessionOfSharesV1_Req_IB_v1.Sms136i sms136i = new sMgetAsvCessionOfSharesV1_Req_IB_v1.Sms136i();
        sms136i.clcd = clcd;
        
        sMgetASVCessionOfSharesV1.nbsapdpi = nbsapdpi;
        sMgetASVCessionOfSharesV1.nbsmsgi = nbsmsgi;
        sMgetASVCessionOfSharesV1.sms136i = sms136i;
        
		requestBean.sMgetASVCessionOfSharesV1 = sMgetASVCessionOfSharesV1;
        System.debug('sMgetAsvCessionOfSharesV1 Request Bean: ' + requestBean);
        return requestBean;
    }


    /**
    * @description Creates a bean from the response
    * @author Prashant Jain | 2021-06-11 
    * @param responseP 
    * @return sMgetAsvCessionOfSharesV1_Resp_IB_v1 
    **/
    public static sMgetAsvCessionOfSharesV1_Resp_IB_v1 mapResponseFields(HttpResponse responseP) {
        sMgetAsvCessionOfSharesV1_Resp_IB_v1 responseBeanContent;
        
        try {
            sMgetAsvCessionOfSharesV1_Resp_IB_v1 responseBean = new sMgetAsvCessionOfSharesV1_Resp_IB_v1();
            responseBeanContent = (sMgetAsvCessionOfSharesV1_Resp_IB_v1)responseBean.deserialize(responseP.getBody(), sMgetAsvCessionOfSharesV1_Resp_IB_v1.class);
            
            responseBeanContent.status = responseP.getStatus();
            responseBeanContent.statusCode = responseP.getStatusCode();
            //responseBeanContent.message = '';
        } catch (Exception e) {
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            responseBeanContent = mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, StringConstants.Sevice500InternalErrorMessage);
            System.debug(message);
        }

        System.debug('sMgetAsvCessionOfSharesV1 Response bean: ' + responseBeanContent);
        return responseBeanContent;
    }

    /**
    * @description Creates a custom bean with the parameters mapped to their respective fields (Used for creating failed response beans)
    * @author Prashant Jain | 2021-06-11 
    * @param statusCodeP 
    * @param statusP 
    * @param messageP 
    * @return sMgetAsvCessionOfSharesV1_Resp_IB_v1 
    **/
    public static sMgetAsvCessionOfSharesV1_Resp_IB_v1 mapFailedResponseFields(Integer statusCodeP, String statusP, String messageP) {
        sMgetAsvCessionOfSharesV1_Resp_IB_v1 responseBean = new sMgetAsvCessionOfSharesV1_Resp_IB_v1();
        responseBean.status = statusP;
        responseBean.statusCode = statusCodeP;
        responseBean.message = messageP;

        System.debug('sMgetAsvCessionOfSharesV1 Failed Response bean: ' + responseBean);
        return responseBean;
    }
}