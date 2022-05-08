/**
 * @description       : Integration Utility Bean for sMgetAsvCessionOfPledgesV1 Service
 * @author            : Prashant Jain
 * @last modified on  : 2021-06-11
 * @last modified by  : Prashant Jain
 * Modifications Log 
 * Ver   Date         Author          Modification
 * 1.0   2021-06-11   Prashant Jain   Initial Version
**/

public class sMgetAsvCessionOfPledgesV1_IU_v1 {

    
    /**
    * @description Creates a request bean
    * @author Prashant Jain | 2021-06-11 
    * @param clcdData 
    * @return sMgetAsvCessionOfPledgesV1_Req_IB_v1 
    **/
    public static sMgetAsvCessionOfPledgesV1_Req_IB_v1 mapRequestFields(String clcdData) {
		
        sMgetAsvCessionOfPledgesV1_Req_IB_v1 requestBean = new sMgetAsvCessionOfPledgesV1_Req_IB_v1();
        
        sMgetAsvCessionOfPledgesV1_Req_IB_v1.SMgetASVCessionOfGeneralPledgesV1 sMgetASVCessionOfGeneralPledgesV1 = new sMgetAsvCessionOfPledgesV1_Req_IB_v1.SMgetASVCessionOfGeneralPledgesV1();
        
        sMgetAsvCessionOfPledgesV1_Req_IB_v1.Nbsapdpi nbsapdpi = new sMgetAsvCessionOfPledgesV1_Req_IB_v1.Nbsapdpi();
        nbsapdpi.channel = 'BDP';
        nbsapdpi.application = 'BDP';
        nbsapdpi.trace = 'Y';
        
        sMgetAsvCessionOfPledgesV1_Req_IB_v1.Nbsmsgi nbsmsgi = new sMgetAsvCessionOfPledgesV1_Req_IB_v1.Nbsmsgi();
        nbsmsgi.msgLanguage = 'E';
        nbsmsgi.msgTarget = 'STD';
        
        sMgetAsvCessionOfPledgesV1_Req_IB_v1.Smp149ei Smp149ei = new sMgetAsvCessionOfPledgesV1_Req_IB_v1.Smp149ei();
        Smp149ei.clcdData = clcdData;
        
        sMgetASVCessionOfGeneralPledgesV1.nbsapdpi = nbsapdpi;
        sMgetASVCessionOfGeneralPledgesV1.nbsmsgi = nbsmsgi;
        sMgetASVCessionOfGeneralPledgesV1.smp149ei = smp149ei;
        
        requestBean.SMgetASVCessionOfGeneralPledgesV1 = sMgetASVCessionOfGeneralPledgesV1;

		//requestBean.smp149ei = new sMgetAsvCessionOfPledgesV1_Req_IB_v1.Smp149ei();
		
		//requestBean.smp149ei.clcdData = clcdData;
		
        System.debug('sMgetAsvCessionOfPledgesV1 Request Bean: ' + requestBean);
        return requestBean;
    }

    /**
    * @description Creates a bean from the response
    * @author Prashant Jain | 2021-06-11 
    * @param responseP 
    * @return sMgetAsvCessionOfPledgesV1_Resp_IB_v1 
    **/
    public static sMgetAsvCessionOfPledgesV1_Resp_IB_v1 mapResponseFields(HttpResponse responseP) {
        sMgetAsvCessionOfPledgesV1_Resp_IB_v1 responseBeanContent;
        
        try {
            sMgetAsvCessionOfPledgesV1_Resp_IB_v1 responseBean = new sMgetAsvCessionOfPledgesV1_Resp_IB_v1();
            responseBeanContent = (sMgetAsvCessionOfPledgesV1_Resp_IB_v1)responseBean.deserialize(responseP.getBody(), sMgetAsvCessionOfPledgesV1_Resp_IB_v1.class);
            
            responseBeanContent.status = responseP.getStatus();
            responseBeanContent.statusCode = responseP.getStatusCode();
            //responseBeanContent.message = '';
        } catch (Exception e) {
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            responseBeanContent = mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, StringConstants.Sevice500InternalErrorMessage);
            System.debug(message);
        }

        System.debug('sMgetAsvCessionOfPledgesV1 Response bean: ' + responseBeanContent);
        return responseBeanContent;
    }

    /**
    * @description Creates a custom bean with the parameters mapped to their respective fields (Used for creating failed response beans)
    * @author Prashant Jain | 2021-06-11 
    * @param statusCodeP 
    * @param statusP 
    * @param messageP 
    * @return sMgetAsvCessionOfPledgesV1_Resp_IB_v1 
    **/
    public static sMgetAsvCessionOfPledgesV1_Resp_IB_v1 mapFailedResponseFields(Integer statusCodeP, String statusP, String messageP) {
        sMgetAsvCessionOfPledgesV1_Resp_IB_v1 responseBean = new sMgetAsvCessionOfPledgesV1_Resp_IB_v1();
        responseBean.status = statusP;
        responseBean.statusCode = statusCodeP;
        responseBean.message = messageP;

        System.debug('sMgetAsvCessionOfPledgesV1 Failed Response bean: ' + responseBean);
        return responseBean;
    }
}