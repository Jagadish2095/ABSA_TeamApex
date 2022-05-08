/**
 * @description       : Integration Utility Bean for sMgetAsvCessionOfSchemesV1 Service
 * @author            : Prashant Jain
 * @last modified on  : 2021-06-11
 * @last modified by  : Prashant Jain
 * Modifications Log 
 * Ver   Date         Author          Modification
 * 1.0   2020-03-05   Prashant Jain   Initial Version
**/

public class sMgetAsvCessionOfSchemesV1_IU_v1 {

    /**
    * @description Creates a request bean
    * @author Prashant Jain | 2021-06-11 
    * @param clcdData 
    * @return sMgetAsvCessionOfSchemesV1_Req_IB_v1 
    **/
    public static sMgetAsvCessionOfSchemesV1_Req_IB_v1 mapRequestFields(String clcdData) {
		
        sMgetAsvCessionOfSchemesV1_Req_IB_v1 requestBean = new sMgetAsvCessionOfSchemesV1_Req_IB_v1();
        sMgetAsvCessionOfSchemesV1_Req_IB_v1.SMgetASVCessionOfSchemesV1 sMgetASVCessionOfSchemesV1 = new sMgetAsvCessionOfSchemesV1_Req_IB_v1.SMgetASVCessionOfSchemesV1();
        sMgetAsvCessionOfSchemesV1_Req_IB_v1.Nbsapdpi nbsapdpi = new sMgetAsvCessionOfSchemesV1_Req_IB_v1.Nbsapdpi();
        nbsapdpi.channel = 'BDP';
        nbsapdpi.application = 'BDP';
        nbsapdpi.trace = 'Y';
        sMgetAsvCessionOfSchemesV1_Req_IB_v1.Nbsmsgi nbsmsgi = new sMgetAsvCessionOfSchemesV1_Req_IB_v1.Nbsmsgi();
        nbsmsgi.msgLanguage = 'E';
        nbsmsgi.msgTarget = 'STD';
        sMgetAsvCessionOfSchemesV1_Req_IB_v1.Smp135ei smp135ei = new sMgetAsvCessionOfSchemesV1_Req_IB_v1.Smp135ei();
        smp135ei.clcdData = clcdData;
        sMgetASVCessionOfSchemesV1.nbsapdpi = nbsapdpi;
        sMgetASVCessionOfSchemesV1.nbsmsgi = nbsmsgi;
        sMgetASVCessionOfSchemesV1.smp135ei = smp135ei;
        requestBean.SMgetASVCessionOfSchemesV1 = sMgetASVCessionOfSchemesV1;
		
        System.debug('sMgetAsvCessionOfSchemesV1 Request Bean: ' + requestBean);
        return requestBean;
    }

    /**
    * @description Creates a bean from the response
    * @author Prashant Jain | 2021-06-11 
    * @param responseP 
    * @return sMgetAsvCessionOfSchemesV1_Resp_IB_v1 
    **/
    public static sMgetAsvCessionOfSchemesV1_Resp_IB_v1 mapResponseFields(HttpResponse responseP) {
        sMgetAsvCessionOfSchemesV1_Resp_IB_v1 responseBeanContent;
        
        try {
            sMgetAsvCessionOfSchemesV1_Resp_IB_v1 responseBean = new sMgetAsvCessionOfSchemesV1_Resp_IB_v1();
            responseBeanContent = (sMgetAsvCessionOfSchemesV1_Resp_IB_v1)responseBean.deserialize(responseP.getBody(), sMgetAsvCessionOfSchemesV1_Resp_IB_v1.class);
            
            responseBeanContent.status = responseP.getStatus();
            responseBeanContent.statusCode = responseP.getStatusCode();
            //responseBeanContent.message = '';
        } catch (Exception e) {
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            responseBeanContent = mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, StringConstants.Sevice500InternalErrorMessage);
            System.debug(message);
        }

        System.debug('sMgetAsvCessionOfSchemesV1 Response bean: ' + responseBeanContent);
        return responseBeanContent;
    }


    /**
    * @description Creates a custom bean with the parameters mapped to their respective fields (Used for creating failed response beans)
    * @author Prashant Jain | 2021-06-11 
    * @param statusCodeP 
    * @param statusP 
    * @param messageP 
    * @return sMgetAsvCessionOfSchemesV1_Resp_IB_v1 
    **/
    public static sMgetAsvCessionOfSchemesV1_Resp_IB_v1 mapFailedResponseFields(Integer statusCodeP, String statusP, String messageP) {
        sMgetAsvCessionOfSchemesV1_Resp_IB_v1 responseBean = new sMgetAsvCessionOfSchemesV1_Resp_IB_v1();
        responseBean.status = statusP;
        responseBean.statusCode = statusCodeP;
        responseBean.message = messageP;

        System.debug('sMgetAsvCessionOfSchemesV1 Failed Response bean: ' + responseBean);
        return responseBean;
    }
}