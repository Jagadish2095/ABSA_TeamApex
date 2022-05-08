/**
 * @description       : Integration Utility Bean for sMgetAsvCessionOfLPNoLinkV1 Service
 * @author            : Prashant Jain
 * @last modified on  : 2021-06-11
 * @last modified by  : Prashant Jain
 * Modifications Log 
 * Ver   Date         Author          Modification
 * 1.0   2021-06-11   Prashant Jain   Initial Version
**/


public class sMgetAsvCessionOfLPNoLinkV1_IU_v1 {

    /**
    * @description Creates a request bean
    * @author Prashant Jain | 2021-06-11 
    * @param clcdData 
    * @return sMgetAsvCessionOfLPNoLinkV1_Req_IB_v1 
    **/
    public static sMgetAsvCessionOfLPNoLinkV1_Req_IB_v1 mapRequestFields(String clcdData) {
		
        sMgetAsvCessionOfLPNoLinkV1_Req_IB_v1 requestBean = new sMgetAsvCessionOfLPNoLinkV1_Req_IB_v1();
            
        sMgetAsvCessionOfLPNoLinkV1_Req_IB_v1.SMgetASVCessionOfLifePoliciesNonLinkV1  SMgetASVCessionOfLifePoliciesNonLinkV1 = new sMgetAsvCessionOfLPNoLinkV1_Req_IB_v1.SMgetASVCessionOfLifePoliciesNonLinkV1();
		
        sMgetAsvCessionOfLPNoLinkV1_Req_IB_v1.Nbsapdpi nbsapdpi = new sMgetAsvCessionOfLPNoLinkV1_Req_IB_v1.Nbsapdpi();
        nbsapdpi.channel = 'BDP';
        nbsapdpi.application = 'BDP';
        nbsapdpi.trace = 'Y';
        
        sMgetAsvCessionOfLPNoLinkV1_Req_IB_v1.Nbsmsgi nbsmsgi = new sMgetAsvCessionOfLPNoLinkV1_Req_IB_v1.Nbsmsgi();
        nbsmsgi.msgLanguage = 'E';
        nbsmsgi.msgTarget = 'STD';
        
        sMgetAsvCessionOfLPNoLinkV1_Req_IB_v1.Smp232ei smp232ei = new sMgetAsvCessionOfLPNoLinkV1_Req_IB_v1.Smp232ei();
        
        smp232ei.clcdData = clcdData;
        
        SMgetASVCessionOfLifePoliciesNonLinkV1.Nbsapdpi = nbsapdpi;
        SMgetASVCessionOfLifePoliciesNonLinkV1.Nbsmsgi = nbsmsgi;
        SMgetASVCessionOfLifePoliciesNonLinkV1.Smp232ei = smp232ei;
        requestBean.SMgetASVCessionOfLifePoliciesNonLinkV1 = SMgetASVCessionOfLifePoliciesNonLinkV1;
      
        System.debug('sMgetAsvCessionOfLPNoLinkV1 Request Bean: ' + requestBean);
        return requestBean;
    }

    /**
    * @description Creates a bean from the response
    * @author Prashant Jain | 2021-06-11 
    * @param responseP 
    * @return sMgetAsvCessionOfLPNoLinkV1_Resp_IB_v1 
    **/
    public static sMgetAsvCessionOfLPNoLinkV1_Resp_IB_v1 mapResponseFields(HttpResponse responseP) {
        sMgetAsvCessionOfLPNoLinkV1_Resp_IB_v1 responseBeanContent;
        
        try {
            sMgetAsvCessionOfLPNoLinkV1_Resp_IB_v1 responseBean = new sMgetAsvCessionOfLPNoLinkV1_Resp_IB_v1();
            responseBeanContent = (sMgetAsvCessionOfLPNoLinkV1_Resp_IB_v1)responseBean.deserialize(responseP.getBody(), sMgetAsvCessionOfLPNoLinkV1_Resp_IB_v1.class);
            
            responseBeanContent.status = responseP.getStatus();
            responseBeanContent.statusCode = responseP.getStatusCode();
            //responseBeanContent.message = '';
        } catch (Exception e) {
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            responseBeanContent = mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, StringConstants.Sevice500InternalErrorMessage);
            System.debug(message);
        }

        System.debug('sMgetAsvCessionOfLPNoLinkV1 Response bean: ' + responseBeanContent);
        return responseBeanContent;
    }


    /**
    * @description Creates a custom bean with the parameters mapped to their respective fields (Used for creating failed response beans)
    * @author Prashant Jain | 2021-06-11 
    * @param statusCodeP 
    * @param statusP 
    * @param messageP 
    * @return sMgetAsvCessionOfLPNoLinkV1_Resp_IB_v1 
    **/
    public static sMgetAsvCessionOfLPNoLinkV1_Resp_IB_v1 mapFailedResponseFields(Integer statusCodeP, String statusP, String messageP) {
        sMgetAsvCessionOfLPNoLinkV1_Resp_IB_v1 responseBean = new sMgetAsvCessionOfLPNoLinkV1_Resp_IB_v1();
        responseBean.status = statusP;
        responseBean.statusCode = statusCodeP;
        responseBean.message = messageP;

        System.debug('sMgetAsvCessionOfLPNoLinkV1 Failed Response bean: ' + responseBean);
        return responseBean;
    }
}