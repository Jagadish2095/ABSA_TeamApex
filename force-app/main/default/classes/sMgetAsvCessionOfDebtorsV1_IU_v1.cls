/**
 * @description       : Integration Utility Bean for sMgetAsvCessionOfDebtorsV1 Service
 * @author            : Prashant Jain
 * @last modified on  : 2021-06-11
 * @last modified by  : Prashant Jain
 * Modifications Log 
 * Ver   Date         Author          Modification
 * 1.0   2021-06-11   Prashant Jain   Initial Version
**/

public class sMgetAsvCessionOfDebtorsV1_IU_v1 {

    /**
    * @description Creates a request bean
    * @author Prashant Jain | 2021-06-11 
    * @param clcdData 
    * @return sMgetAsvCessionOfDebtorsV1_Req_IB_v1 
    **/
    public static sMgetAsvCessionOfDebtorsV1_Req_IB_v1 mapRequestFields(String clcdData) {
		
        sMgetAsvCessionOfDebtorsV1_Req_IB_v1 requestBean = new sMgetAsvCessionOfDebtorsV1_Req_IB_v1();
		
        sMgetAsvCessionOfDebtorsV1_Req_IB_v1.SMgetASVCessionOfDebtorsV1 requestMap = new sMgetAsvCessionOfDebtorsV1_Req_IB_v1.SMgetASVCessionOfDebtorsV1();
        
        sMgetAsvCessionOfDebtorsV1_Req_IB_v1.Nbsapdpi nbsapdpi = new sMgetAsvCessionOfDebtorsV1_Req_IB_v1.Nbsapdpi();
        
        nbsapdpi.channel = 'BDP';
        nbsapdpi.application = 'BDP';
        nbsapdpi.trace = 'Y';
        
        sMgetAsvCessionOfDebtorsV1_Req_IB_v1.Nbsmsgi  nbsmsgi = new sMgetAsvCessionOfDebtorsV1_Req_IB_v1.Nbsmsgi();
        nbsmsgi.msgLanguage = 'E';
        nbsmsgi.msgTarget = 'STD';
        
        sMgetAsvCessionOfDebtorsV1_Req_IB_v1.Smp170ei smp170ei = new sMgetAsvCessionOfDebtorsV1_Req_IB_v1.Smp170ei();
        smp170ei.clcdData = clcdData;
        
        requestMap.nbsapdpi = nbsapdpi;
        requestMap.nbsmsgi = nbsmsgi;
        requestMap.smp170ei = smp170ei;
		
        requestBean.sMgetASVCessionOfDebtorsV1 = requestMap;
		
        System.debug('sMgetAsvCessionOfDebtorsV1 Request Bean: ' + requestBean);
        return requestBean;
    }

    /**
    * @description Creates a bean from the response
    * @author Prashant Jain | 2021-06-11 
    * @param responseP 
    * @return sMgetAsvCessionOfDebtorsV1_Resp_IB_v1 
    **/
    public static sMgetAsvCessionOfDebtorsV1_Resp_IB_v1 mapResponseFields(HttpResponse responseP) {
        sMgetAsvCessionOfDebtorsV1_Resp_IB_v1 responseBeanContent;
        
        try {
            sMgetAsvCessionOfDebtorsV1_Resp_IB_v1 responseBean = new sMgetAsvCessionOfDebtorsV1_Resp_IB_v1();
            responseBeanContent = (sMgetAsvCessionOfDebtorsV1_Resp_IB_v1)responseBean.deserialize(responseP.getBody(), sMgetAsvCessionOfDebtorsV1_Resp_IB_v1.class);
            
            responseBeanContent.status = responseP.getStatus();
            responseBeanContent.statusCode = responseP.getStatusCode();
            //responseBeanContent.message = '';
        } catch (Exception e) {
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            responseBeanContent = mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, StringConstants.Sevice500InternalErrorMessage);
            System.debug(message);
        }

        System.debug('sMgetAsvCessionOfDebtorsV1 Response bean: ' + responseBeanContent);
        return responseBeanContent;
    }

    /**
    * @description Creates a custom bean with the parameters mapped to their respective fields (Used for creating failed response beans)
    * @author Prashant Jain | 2021-06-11 
    * @param statusCodeP 
    * @param statusP 
    * @param messageP 
    * @return sMgetAsvCessionOfDebtorsV1_Resp_IB_v1 
    **/
    public static sMgetAsvCessionOfDebtorsV1_Resp_IB_v1 mapFailedResponseFields(Integer statusCodeP, String statusP, String messageP) {
        sMgetAsvCessionOfDebtorsV1_Resp_IB_v1 responseBean = new sMgetAsvCessionOfDebtorsV1_Resp_IB_v1();
        responseBean.status = statusP;
        responseBean.statusCode = statusCodeP;
        responseBean.message = messageP;

        System.debug('sMgetAsvCessionOfDebtorsV1 Failed Response bean: ' + responseBean);
        return responseBean;
    }
}