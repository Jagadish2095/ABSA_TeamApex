/**
 * @description       : Integration Utility Bean for SMgetASVCessionOfUnitTrustsV1 Service
 * @author            : Prashant Jain
 * @last modified on  : 2021-06-11
 * @last modified by  : Prashant Jain
 * Modifications Log 
 * Ver   Date         Author          Modification
 * 1.0   2021-06-11   Prashant Jain   Initial Version
**/

public class SMgetASVCessionOfUnitTrustsV1_IU_v1 {

    /**
    * @description Creates a request bean
    * @author Prashant Jain | 2021-06-11 
    * @param clcd 
    * @return SMgetASVCessionOfUnitTrustsV1_Req_IB_v1 
    **/
    public static SMgetASVCessionOfUnitTrustsV1_Req_IB_v1 mapRequestFields(String clcd) {
		
        SMgetASVCessionOfUnitTrustsV1_Req_IB_v1 requestBean = new SMgetASVCessionOfUnitTrustsV1_Req_IB_v1();
        SMgetASVCessionOfUnitTrustsV1_Req_IB_v1.SMgetASVCessionOfUnitTrustsV1 SMgetASVCessionOfUnitTrustsV1 = new SMgetASVCessionOfUnitTrustsV1_Req_IB_v1.SMgetASVCessionOfUnitTrustsV1();
        
        SMgetASVCessionOfUnitTrustsV1_Req_IB_v1.Nbsapdpi nbsapdpi = new SMgetASVCessionOfUnitTrustsV1_Req_IB_v1.Nbsapdpi();
        nbsapdpi.channel = 'BDP';
        nbsapdpi.application = 'BDP';
        nbsapdpi.trace = 'Y';
        
        SMgetASVCessionOfUnitTrustsV1_Req_IB_v1.Nbsmsgi nbsmsgi = new SMgetASVCessionOfUnitTrustsV1_Req_IB_v1.Nbsmsgi();
        nbsmsgi.msgLanguage = 'E';
        nbsmsgi.msgTarget = 'STD';
        
        SMgetASVCessionOfUnitTrustsV1_Req_IB_v1.smn236i smn236i = new SMgetASVCessionOfUnitTrustsV1_Req_IB_v1.smn236i();
        smn236i.clcd = clcd;
        
        SMgetASVCessionOfUnitTrustsV1.nbsapdpi = nbsapdpi;
        SMgetASVCessionOfUnitTrustsV1.nbsmsgi = nbsmsgi;
        SMgetASVCessionOfUnitTrustsV1.smn236i = smn236i;
        requestBean.SMgetASVCessionOfUnitTrustsV1 = SMgetASVCessionOfUnitTrustsV1; 
		
        System.debug('SMgetASVCessionOfUnitTrustsV1 Request Bean: ' + requestBean);
        return requestBean;
    }

    /**
    * @description Creates a bean from the response
    * @author Prashant Jain | 2021-06-11 
    * @param responseP 
    * @return SMgetASVCessionOfUnitTrustsV1_Resp_IB_v1 
    **/
    public static SMgetASVCessionOfUnitTrustsV1_Resp_IB_v1 mapResponseFields(HttpResponse responseP) {
        SMgetASVCessionOfUnitTrustsV1_Resp_IB_v1 responseBeanContent;
        
        try {
            SMgetASVCessionOfUnitTrustsV1_Resp_IB_v1 responseBean = new SMgetASVCessionOfUnitTrustsV1_Resp_IB_v1();
            responseBeanContent = (SMgetASVCessionOfUnitTrustsV1_Resp_IB_v1)responseBean.deserialize(responseP.getBody(), SMgetASVCessionOfUnitTrustsV1_Resp_IB_v1.class);
            
            responseBeanContent.status = responseP.getStatus();
            responseBeanContent.statusCode = responseP.getStatusCode();
            //responseBeanContent.message = '';
        } catch (Exception e) {
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            responseBeanContent = mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, StringConstants.Sevice500InternalErrorMessage);
            System.debug(message);
        }

        System.debug('SMgetASVCessionOfUnitTrustsV1_Resp_IB_v1 Response bean: ' + responseBeanContent);
        return responseBeanContent;
    }

    /**
    * @description Creates a custom bean with the parameters mapped to their respective fields (Used for creating failed response beans)
    * @author Prashant Jain | 2021-06-11 
    * @param statusCodeP 
    * @param statusP 
    * @param messageP 
    * @return SMgetASVCessionOfUnitTrustsV1_Resp_IB_v1 
    **/
    public static SMgetASVCessionOfUnitTrustsV1_Resp_IB_v1 mapFailedResponseFields(Integer statusCodeP, String statusP, String messageP) {
        SMgetASVCessionOfUnitTrustsV1_Resp_IB_v1 responseBean = new SMgetASVCessionOfUnitTrustsV1_Resp_IB_v1();
        responseBean.status = statusP;
        responseBean.statusCode = statusCodeP;
        responseBean.message = messageP;

        System.debug('SMgetASVCessionOfUnitTrustsV1 Failed Response bean: ' + responseBean);
        return responseBean;
    }
}