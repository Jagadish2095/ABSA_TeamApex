/**
 * @description       : Integration Utility Bean for sMgetAsvSuretyshipsV1 Service
 * @author            : Prashant Jain
 * @last modified on  : 2021-06-11
 * @last modified by  : Prashant Jain
 * Modifications Log 
 * Ver   Date         Author          Modification
 * 1.0   2021-06-11   Prashant Jain   Initial Version
**/


public class sMgetAsvSuretyshipsV1_IU_v1 {

    /**
    * @description Creates a request bean
    * @author Prashant Jain | 2021-06-11 
    * @param clcd 
    * @return sMgetAsvSuretyshipsV1_Req_IB_v1 
    **/
    public static sMgetAsvSuretyshipsV1_Req_IB_v1 mapRequestFields(String clcd) {
		
        sMgetAsvSuretyshipsV1_Req_IB_v1 requestBean = new sMgetAsvSuretyshipsV1_Req_IB_v1();
        
        sMgetAsvSuretyshipsV1_Req_IB_v1.SMgetASVSuretyshipsV1 sMgetASVSuretyshipsV1 = new sMgetAsvSuretyshipsV1_Req_IB_v1.SMgetASVSuretyshipsV1();
        
        sMgetAsvSuretyshipsV1_Req_IB_v1.Nbsapdpi nbsapdpi = new sMgetAsvSuretyshipsV1_Req_IB_v1.Nbsapdpi();
        nbsapdpi.channel = 'BDP';
        nbsapdpi.application = 'BDP';
        nbsapdpi.trace = 'Y';
        
        sMgetAsvSuretyshipsV1_Req_IB_v1.Nbsmsgi nbsmsgi = new sMgetAsvSuretyshipsV1_Req_IB_v1.Nbsmsgi();
        nbsmsgi.msgLanguage = 'E';
        nbsmsgi.msgTarget = 'STD';
        
        sMgetAsvSuretyshipsV1_Req_IB_v1.Smn152i smn152i = new sMgetAsvSuretyshipsV1_Req_IB_v1.Smn152i();
        
        smn152i.clcd = clcd;
        
        sMgetASVSuretyshipsV1.nbsapdpi = nbsapdpi;
        sMgetASVSuretyshipsV1.nbsmsgi = nbsmsgi;
        sMgetASVSuretyshipsV1.smn152i = smn152i;
        requestBean.SMgetASVSuretyshipsV1 = sMgetASVSuretyshipsV1;
		
        System.debug('sMgetAsvSuretyshipsV1 Request Bean: ' + requestBean);
        return requestBean;
    }

    /**
    * @description Creates a bean from the response
    * @author Prashant Jain | 2021-06-11 
    * @param responseP 
    * @return sMgetAsvSuretyshipsV1_Resp_IB_v1 
    **/
    public static sMgetAsvSuretyshipsV1_Resp_IB_v1 mapResponseFields(HttpResponse responseP) {
        sMgetAsvSuretyshipsV1_Resp_IB_v1 responseBeanContent;
        
        try {
            sMgetAsvSuretyshipsV1_Resp_IB_v1 responseBean = new sMgetAsvSuretyshipsV1_Resp_IB_v1();
            responseBeanContent = (sMgetAsvSuretyshipsV1_Resp_IB_v1)responseBean.deserialize(responseP.getBody(), sMgetAsvSuretyshipsV1_Resp_IB_v1.class);
            
            responseBeanContent.status = responseP.getStatus();
            responseBeanContent.statusCode = responseP.getStatusCode();
            //responseBeanContent.message = '';
        } catch (Exception e) {
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            responseBeanContent = mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, StringConstants.Sevice500InternalErrorMessage);
            System.debug(message);
        }

        System.debug('sMgetAsvSuretyshipsV1 Response bean: ' + responseBeanContent);
        return responseBeanContent;
    }

    /**
    * @description Creates a custom bean with the parameters mapped to their respective fields (Used for creating failed response beans)
    * @author Prashant Jain | 2021-06-11 
    * @param statusCodeP 
    * @param statusP 
    * @param messageP 
    * @return sMgetAsvSuretyshipsV1_Resp_IB_v1 
    **/
    public static sMgetAsvSuretyshipsV1_Resp_IB_v1 mapFailedResponseFields(Integer statusCodeP, String statusP, String messageP) {
        sMgetAsvSuretyshipsV1_Resp_IB_v1 responseBean = new sMgetAsvSuretyshipsV1_Resp_IB_v1();
        responseBean.status = statusP;
        responseBean.statusCode = statusCodeP;
        responseBean.message = messageP;

        System.debug('sMgetAsvSuretyshipsV1 Failed Response bean: ' + responseBean);
        return responseBean;
    }
}