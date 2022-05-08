/**
 * @description       : Integration Utility Bean for sMgetAsVbondsV1 Service
 * @author            : Prashant Jain
 * @last modified on  : 2021-06-10
 * @last modified by  : Prashant Jain
 * Modifications Log 
 * Ver   Date         Author          Modification
 * 1.0   2021-06-10   Prashant Jain   Initial Version
**/

public class sMgetAsVbondsV1_IU_v1 {


    /**
    * @description Creates a request bean
    * @author Prashant Jain | 2021-06-10 
    * @param clcd 
    * @return sMgetAsVbondsV1_Req_IB_v1 
    **/
    public static sMgetAsVbondsV1_Req_IB_v1 mapRequestFields(String clcd) {
		
        sMgetAsVbondsV1_Req_IB_v1 requestBean = new sMgetAsVbondsV1_Req_IB_v1();
        sMgetAsVbondsV1_Req_IB_v1.SMgetASVbondsV1 sMgetASVbondsV1 = new sMgetAsVbondsV1_Req_IB_v1.SMgetASVbondsV1();
        
        sMgetAsVbondsV1_Req_IB_v1.Nbsapdpi nbsapdpi = new sMgetAsVbondsV1_Req_IB_v1.Nbsapdpi();
        nbsapdpi.channel = 'BDP';
        nbsapdpi.application = 'BDP';
        nbsapdpi.trace = 'Y';
        
        sMgetAsVbondsV1_Req_IB_v1.Nbsmsgi nbsmsgi = new sMgetAsVbondsV1_Req_IB_v1.Nbsmsgi();
        nbsmsgi.msgLanguage = 'E';
        nbsmsgi.msgTarget = 'STD';
        
        sMgetAsVbondsV1_Req_IB_v1.Smn145i smn145i = new sMgetAsVbondsV1_Req_IB_v1.Smn145i();
        smn145i.clcd = clcd;
        
        sMgetASVbondsV1.nbsapdpi = nbsapdpi;
        sMgetASVbondsV1.nbsmsgi = nbsmsgi;
        sMgetASVbondsV1.smn145i = smn145i;
        requestBean.SMgetASVbondsV1 = sMgetASVbondsV1; 
		
        System.debug('sMgetAsVbondsV1 Request Bean: ' + requestBean);
        return requestBean;
    }

   
    /**
    * @description Creates a bean from the response
    * @author Prashant Jain | 2021-06-10 
    * @param responseP 
    * @return sMgetAsVbondsV1_Resp_IB_v1 
    **/
    public static sMgetAsVbondsV1_Resp_IB_v1 mapResponseFields(HttpResponse responseP) {
        sMgetAsVbondsV1_Resp_IB_v1 responseBeanContent;
        
        try {
            sMgetAsVbondsV1_Resp_IB_v1 responseBean = new sMgetAsVbondsV1_Resp_IB_v1();
            responseBeanContent = (sMgetAsVbondsV1_Resp_IB_v1)responseBean.deserialize(responseP.getBody(), sMgetAsVbondsV1_Resp_IB_v1.class);
            
            responseBeanContent.status = responseP.getStatus();
            responseBeanContent.statusCode = responseP.getStatusCode();
            //responseBeanContent.message = '';
        } catch (Exception e) {
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            responseBeanContent = mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, StringConstants.Sevice500InternalErrorMessage);
            System.debug(message);
        }

        System.debug('sMgetAsVbondsV1 Response bean: ' + responseBeanContent);
        return responseBeanContent;
    }


    /**
    * @description Creates a custom bean with the parameters mapped to their respective fields (Used for creating failed response beans)
    * @author Prashant Jain | 2021-06-10 
    * @param statusCodeP 
    * @param statusP 
    * @param messageP 
    * @return sMgetAsVbondsV1_Resp_IB_v1 
    **/
    public static sMgetAsVbondsV1_Resp_IB_v1 mapFailedResponseFields(Integer statusCodeP, String statusP, String messageP) {
        sMgetAsVbondsV1_Resp_IB_v1 responseBean = new sMgetAsVbondsV1_Resp_IB_v1();
        responseBean.status = statusP;
        responseBean.statusCode = statusCodeP;
        responseBean.message = messageP;

        System.debug('sMgetAsVbondsV1 Failed Response bean: ' + responseBean);
        return responseBean;
    }
}