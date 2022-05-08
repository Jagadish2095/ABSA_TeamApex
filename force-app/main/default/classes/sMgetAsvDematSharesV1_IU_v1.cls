/**
 * @description       : Integration Utility Bean for sMgetAsvDematSharesV1 Service
 * @author            : Prashant Jain
 * @last modified on  : 2021-06-11
 * @last modified by  : Prashant Jain
 * Modifications Log 
 * Ver   Date         Author          Modification
 * 1.0   2021-06-11   Prashant Jain   Initial Version
**/

public class sMgetAsvDematSharesV1_IU_v1 {


    /**
    * @description Creates a request bean
    * @author Prashant Jain | 2021-06-11 
    * @param clcd 
    * @return sMgetAsvDematSharesV1_Req_IB_v1 
    **/
    public static sMgetAsvDematSharesV1_Req_IB_v1 mapRequestFields(String clcd) {
		
        sMgetAsvDematSharesV1_Req_IB_v1 requestBean = new sMgetAsvDematSharesV1_Req_IB_v1();
        sMgetAsvDematSharesV1_Req_IB_v1.SMgetASVDematerializedSharesV1 sMgetASVDematerializedSharesV1 = new  sMgetAsvDematSharesV1_Req_IB_v1.SMgetASVDematerializedSharesV1();
		sMgetAsvDematSharesV1_Req_IB_v1.Nbsapdpi nbsapdpi = new sMgetAsvDematSharesV1_Req_IB_v1.Nbsapdpi();
        nbsapdpi.channel = 'BDP';
        nbsapdpi.application = 'BDP';
        nbsapdpi.trace = 'Y';
        
        sMgetAsvDematSharesV1_Req_IB_v1.Nbsmsgi nbsmsgi = new sMgetAsvDematSharesV1_Req_IB_v1.Nbsmsgi();
        nbsmsgi.msgLanguage = 'E';
        nbsmsgi.msgTarget = 'STD';
        
        sMgetAsvDematSharesV1_Req_IB_v1.Smn336i smn336i = new sMgetAsvDematSharesV1_Req_IB_v1.Smn336i();
        smn336i.clcd = clcd;
        
        sMgetASVDematerializedSharesV1.nbsapdpi = nbsapdpi;
        sMgetASVDematerializedSharesV1.nbsmsgi = nbsmsgi;
        sMgetASVDematerializedSharesV1.smn336i = smn336i;
        requestBean.SMgetASVDematerializedSharesV1 = SMgetASVDematerializedSharesV1;
       
        System.debug('sMgetAsvDematSharesV1 Request Bean: ' + requestBean);
        return requestBean;
    }

    /**
    * @description Creates a bean from the response
    * @author Prashant Jain | 2021-06-11 
    * @param responseP 
    * @return sMgetAsvDematSharesV1_Resp_IB_v1 
    **/
    public static sMgetAsvDematSharesV1_Resp_IB_v1 mapResponseFields(HttpResponse responseP) {
        sMgetAsvDematSharesV1_Resp_IB_v1 responseBeanContent;
        
        try {
            sMgetAsvDematSharesV1_Resp_IB_v1 responseBean = new sMgetAsvDematSharesV1_Resp_IB_v1();
            responseBeanContent = (sMgetAsvDematSharesV1_Resp_IB_v1)responseBean.deserialize(responseP.getBody(), sMgetAsvDematSharesV1_Resp_IB_v1.class);
            
            responseBeanContent.status = responseP.getStatus();
            responseBeanContent.statusCode = responseP.getStatusCode();
            //responseBeanContent.message = '';
        } catch (Exception e) {
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            responseBeanContent = mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, StringConstants.Sevice500InternalErrorMessage);
            System.debug(message);
        }

        System.debug('sMgetAsvDematSharesV1 Response bean: ' + responseBeanContent);
        return responseBeanContent;
    }

    /**
    * @description Creates a custom bean with the parameters mapped to their respective fields (Used for creating failed response beans)
    * @author Prashant Jain | 2021-06-11 
    * @param statusCodeP 
    * @param statusP 
    * @param messageP 
    * @return sMgetAsvDematSharesV1_Resp_IB_v1 
    **/
    public static sMgetAsvDematSharesV1_Resp_IB_v1 mapFailedResponseFields(Integer statusCodeP, String statusP, String messageP) {
        sMgetAsvDematSharesV1_Resp_IB_v1 responseBean = new sMgetAsvDematSharesV1_Resp_IB_v1();
        responseBean.status = statusP;
        responseBean.statusCode = statusCodeP;
        responseBean.message = messageP;

        System.debug('sMgetAsvDematSharesV1 Failed Response bean: ' + responseBean);
        return responseBean;
    }
}