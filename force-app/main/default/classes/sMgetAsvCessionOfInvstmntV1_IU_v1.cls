/**
 * @description       : Integration Utility Bean for sMgetAsvCessionOfInvstmntV1 Service
 * @author            : Prashant Jain
 * @last modified on  : 2021-06-11
 * @last modified by  : Prashant Jain
 * Modifications Log 
 * Ver   Date         Author          Modification
 * 1.0   2020-03-03   Prashant Jain   Initial Version
**/

public class sMgetAsvCessionOfInvstmntV1_IU_v1 {

    /**
    * @description Creates a request bean
    * @author Prashant Jain | 2021-06-11 
    * @param clcdData 
    * @return sMgetAsvCessionOfInvstmntV1_Req_IB_v1 
    **/
    public static sMgetAsvCessionOfInvstmntV1_Req_IB_v1 mapRequestFields(String clcdData) {
		
        sMgetAsvCessionOfInvstmntV1_Req_IB_v1 requestBean = new sMgetAsvCessionOfInvstmntV1_Req_IB_v1();
        sMgetAsvCessionOfInvstmntV1_Req_IB_v1.SMgetASVCessionOfInternalInvestmentsV1 sMgetASVCessionOfInternalInvestmentsV1 = new sMgetAsvCessionOfInvstmntV1_Req_IB_v1.SMgetASVCessionOfInternalInvestmentsV1();
		
        sMgetAsvCessionOfInvstmntV1_Req_IB_v1.Nbsapdpi nbsapdpi = new sMgetAsvCessionOfInvstmntV1_Req_IB_v1.Nbsapdpi();
        nbsapdpi.application = 'BDP';
        nbsapdpi.channel = 'BDP';
        nbsapdpi.trace = 'Y';
        
        sMgetAsvCessionOfInvstmntV1_Req_IB_v1.Nbsmsgi nbsmsgi = new sMgetAsvCessionOfInvstmntV1_Req_IB_v1.Nbsmsgi();
        nbsmsgi.msgLanguage = 'E';
        nbsmsgi.msgTarget = 'STD';
        
        
        sMgetAsvCessionOfInvstmntV1_Req_IB_v1.Smn146i smn146i = new sMgetAsvCessionOfInvstmntV1_Req_IB_v1.Smn146i();
        smn146i.clcdData = clcdData;
        
        sMgetASVCessionOfInternalInvestmentsV1.nbsapdpi =  nbsapdpi;
        sMgetASVCessionOfInternalInvestmentsV1.nbsmsgi =  nbsmsgi;
        sMgetASVCessionOfInternalInvestmentsV1.smn146i = smn146i;
        
        requestBean.sMgetASVCessionOfInternalInvestmentsV1 = sMgetASVCessionOfInternalInvestmentsV1;
        
        System.debug('sMgetAsvCessionOfInvstmntV1 Request Bean: ' + requestBean);
        return requestBean;
    }

    

    /**
    * @description Creates a bean from the response
    * @author Prashant Jain | 2021-06-11 
    * @param responseP 
    * @return sMgetAsvCessionOfInvstmntV1_Resp_IB_v1 
    **/
    public static sMgetAsvCessionOfInvstmntV1_Resp_IB_v1 mapResponseFields(HttpResponse responseP) {
        sMgetAsvCessionOfInvstmntV1_Resp_IB_v1 responseBeanContent;
        
        try {
            sMgetAsvCessionOfInvstmntV1_Resp_IB_v1 responseBean = new sMgetAsvCessionOfInvstmntV1_Resp_IB_v1();
            responseBeanContent = (sMgetAsvCessionOfInvstmntV1_Resp_IB_v1)responseBean.deserialize(responseP.getBody(), sMgetAsvCessionOfInvstmntV1_Resp_IB_v1.class);
            
            responseBeanContent.status = responseP.getStatus();
            responseBeanContent.statusCode = responseP.getStatusCode();
            //responseBeanContent.message = '';
        } catch (Exception e) {
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            responseBeanContent = mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, StringConstants.Sevice500InternalErrorMessage);
            System.debug(message);
        }

        System.debug('sMgetAsvCessionOfInvstmntV1 Response bean: ' + responseBeanContent);
        return responseBeanContent;
    }

    /**
    * @description Creates a custom bean with the parameters mapped to their respective fields (Used for creating failed response beans)
    * @author Prashant Jain | 2021-06-11 
    * @param statusCodeP 
    * @param statusP 
    * @param messageP 
    * @return sMgetAsvCessionOfInvstmntV1_Resp_IB_v1 
    **/
    public static sMgetAsvCessionOfInvstmntV1_Resp_IB_v1 mapFailedResponseFields(Integer statusCodeP, String statusP, String messageP) {
        sMgetAsvCessionOfInvstmntV1_Resp_IB_v1 responseBean = new sMgetAsvCessionOfInvstmntV1_Resp_IB_v1();
        responseBean.status = statusP;
        responseBean.statusCode = statusCodeP;
        responseBean.message = messageP;

        System.debug('sMgetAsvCessionOfInvstmntV1 Failed Response bean: ' + responseBean);
        return responseBean;
    }
}