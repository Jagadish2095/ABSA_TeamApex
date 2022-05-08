/**
 * @description       : Integration Utility Bean for sMgetAsvSecurityAndHoldsV1 Service
 * @author            : Prashant Jain
 * @last modified on  : 2021-06-10
 * @last modified by  : Prashant Jain
 * Modifications Log 
 * Ver   Date         Author     Modification
 * 1.0   2020-03-10   Prashant Jain   Initial Version
**/


public class sMgetAsvSecurityAndHoldsV1_IU_v1 {

    
    /**
    * @description 
    * @author Prashant Jain | 2021-06-10 
    * @param clcd 
    * @return sMgetAsvSecurityAndHoldsV1_Req_IB_v1 
    **/
    public static sMgetAsvSecurityAndHoldsV1_Req_IB_v1 mapRequestFields(String clcd) {
		
       sMgetAsvSecurityAndHoldsV1_Req_IB_v1 requestBean = new sMgetAsvSecurityAndHoldsV1_Req_IB_v1();
        
        sMgetAsvSecurityAndHoldsV1_Req_IB_v1.SMgetASVOutstandingSecurityAndHoldsV1 sMgetASVOutstandingSecurityAndHoldsV1 = new sMgetAsvSecurityAndHoldsV1_Req_IB_v1.SMgetASVOutstandingSecurityAndHoldsV1();
		
        sMgetAsvSecurityAndHoldsV1_Req_IB_v1.Nbsapdpi nbsapdpi = new sMgetAsvSecurityAndHoldsV1_Req_IB_v1.Nbsapdpi();
        nbsapdpi.channel = 'BDP';
        nbsapdpi.application = 'BDP';
        nbsapdpi.trace = 'Y';
        
        sMgetAsvSecurityAndHoldsV1_Req_IB_v1.Nbsmsgi nbsmsgi = new sMgetAsvSecurityAndHoldsV1_Req_IB_v1.Nbsmsgi();
        nbsmsgi.msgLanguage = 'E';
        nbsmsgi.msgTarget = 'STD';
        
        sMgetAsvSecurityAndHoldsV1_Req_IB_v1.Smp155ei smp155ei = new sMgetAsvSecurityAndHoldsV1_Req_IB_v1.Smp155ei();
        smp155ei.clcd = clcd;
        
        sMgetASVOutstandingSecurityAndHoldsV1.nbsapdpi = nbsapdpi;
        sMgetASVOutstandingSecurityAndHoldsV1.nbsmsgi = nbsmsgi;
        sMgetASVOutstandingSecurityAndHoldsV1.smp155ei = smp155ei;
        
        requestBean.sMgetASVOutstandingSecurityAndHoldsV1 = sMgetASVOutstandingSecurityAndHoldsV1;
        
        System.debug('sMgetAsvSecurityAndHoldsV1 Request Bean: ' + requestBean);
        return requestBean;
    }

    /**
    * @description 
    * @author Prashant Jain | 2021-06-10 
    * @param responseP 
    * @return sMgetAsvSecurityAndHoldsV1_Resp_IB_v1 
    **/
    public static sMgetAsvSecurityAndHoldsV1_Resp_IB_v1 mapResponseFields(HttpResponse responseP) {
        sMgetAsvSecurityAndHoldsV1_Resp_IB_v1 responseBeanContent;
        
        try {
            sMgetAsvSecurityAndHoldsV1_Resp_IB_v1 responseBean = new sMgetAsvSecurityAndHoldsV1_Resp_IB_v1();
            responseBeanContent = (sMgetAsvSecurityAndHoldsV1_Resp_IB_v1)responseBean.deserialize(responseP.getBody(), sMgetAsvSecurityAndHoldsV1_Resp_IB_v1.class);
            
            responseBeanContent.status = responseP.getStatus();
            responseBeanContent.statusCode = responseP.getStatusCode();
            //responseBeanContent.message = '';
        } catch (Exception e) {
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            responseBeanContent = mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, StringConstants.Sevice500InternalErrorMessage);
            System.debug(message);
        }

        System.debug('sMgetAsvSecurityAndHoldsV1 Response bean: ' + responseBeanContent);
        return responseBeanContent;
    }


    /**
    * @description Creates a custom bean with the parameters mapped to their respective fields (Used for creating failed response beans)
    * @author Prashant Jain | 2021-06-10 
    * @param statusCodeP 
    * @param statusP 
    * @param messageP 
    * @return sMgetAsvSecurityAndHoldsV1_Resp_IB_v1 
    **/
    public static sMgetAsvSecurityAndHoldsV1_Resp_IB_v1 mapFailedResponseFields(Integer statusCodeP, String statusP, String messageP) {
        sMgetAsvSecurityAndHoldsV1_Resp_IB_v1 responseBean = new sMgetAsvSecurityAndHoldsV1_Resp_IB_v1();
        responseBean.status = statusP;
        responseBean.statusCode = statusCodeP;
        responseBean.message = messageP;

        System.debug('sMgetAsvSecurityAndHoldsV1 Failed Response bean: ' + responseBean);
        return responseBean;
    }
}