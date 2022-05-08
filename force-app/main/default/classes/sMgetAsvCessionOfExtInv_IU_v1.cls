/**
 * @description       : Integration Utility Bean for SMgetASVCessionOfExternalInvestmentsV1 Service
 * @author            : Muvhuso Nekhubvi
 * @last modified on  : 2021-06-11
 * @last modified by  : Prashant Jain
 * Modifications Log 
 * Ver   Date         Author          Modification
 * 1.0   2020-03-21   Muvhuso Nekhubvi   Initial Version
**/

public class sMgetAsvCessionOfExtInv_IU_v1 {

    
    /**
    * @description Creates a request bean
    * @author Prashant Jain | 2021-06-11 
    * @param clcd 
    * @return sMgetAsvCessionOfExtInv_Req_IB_v1 
    **/
    public static sMgetAsvCessionOfExtInv_Req_IB_v1 mapRequestFields(String clcd) {
		
        sMgetAsvCessionOfExtInv_Req_IB_v1 requestBean = new sMgetAsvCessionOfExtInv_Req_IB_v1();
        sMgetAsvCessionOfExtInv_Req_IB_v1.SMgetASVCessionOfExternalInvestmentsV1 sMgetASVCessionOfExternalInvestmentsV1 = new sMgetAsvCessionOfExtInv_Req_IB_v1.SMgetASVCessionOfExternalInvestmentsV1();
        
        sMgetAsvCessionOfExtInv_Req_IB_v1.Nbsapdpi nbsapdpi = new sMgetAsvCessionOfExtInv_Req_IB_v1.Nbsapdpi();
        nbsapdpi.channel = 'BDP';
        nbsapdpi.application = 'BDP';
        nbsapdpi.trace = 'Y';
        
        sMgetAsvCessionOfExtInv_Req_IB_v1.FinalMsgId finalMsgId = new sMgetAsvCessionOfExtInv_Req_IB_v1.FinalMsgId(); 
        finalMsgId.finalMsgClass = '';
        finalMsgId.finalMsgCode = '';
        
        sMgetAsvCessionOfExtInv_Req_IB_v1.Nbsmsgi nbsmsgi = new sMgetAsvCessionOfExtInv_Req_IB_v1.Nbsmsgi();
        nbsmsgi.msgLanguage = 'E';
        nbsmsgi.msgTarget = 'STD';
        nbsmsgi.finalMsgId = finalMsgId;
        
        sMgetAsvCessionOfExtInv_Req_IB_v1.Smp147ei smp147ei = new sMgetAsvCessionOfExtInv_Req_IB_v1.Smp147ei();
        smp147ei.clcdData = clcd;
        
        sMgetASVCessionOfExternalInvestmentsV1.nbsapdpi = nbsapdpi;
        sMgetASVCessionOfExternalInvestmentsV1.nbsmsgi = nbsmsgi;
        sMgetASVCessionOfExternalInvestmentsV1.smp147ei = smp147ei;
        
        requestBean.SMgetASVCessionOfExternalInvestmentsV1 = sMgetASVCessionOfExternalInvestmentsV1;
        System.debug('SMgetASVCessionOfExternalInvestmentsV1 Request Bean: ' + requestBean);
        return requestBean;
    }
    
    /**
    * @description Creates a bean from the response
    * @author Prashant Jain | 2021-06-11 
    * @param responseP 
    * @return sMgetAsvCessionOfExtInv_Resp_IB_v1 
    **/
    public static sMgetAsvCessionOfExtInv_Resp_IB_v1 mapResponseFields(HttpResponse responseP) {
        sMgetAsvCessionOfExtInv_Resp_IB_v1 responseBeanContent;
        
        try {
            sMgetAsvCessionOfExtInv_Resp_IB_v1 responseBean = new sMgetAsvCessionOfExtInv_Resp_IB_v1();

            
            responseBeanContent = (sMgetAsvCessionOfExtInv_Resp_IB_v1)responseBean.deserialize(responseP.getBody(), sMgetAsvCessionOfExtInv_Resp_IB_v1.class);
            
            responseBeanContent.status = responseP.getStatus();
            responseBeanContent.statusCode = responseP.getStatusCode();
            //responseBeanContent.message = '';
        } catch (Exception e) {
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            responseBeanContent = mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, StringConstants.Sevice500InternalErrorMessage);
            System.debug(message);
        }

        System.debug('SMgetASVCessionOfExternalInvestmentsV1 Response bean: ' + responseBeanContent);
        return responseBeanContent;
    }


    /**
    * @description Creates a custom bean with the parameters mapped to their respective fields (Used for creating failed response beans)
    * @author Prashant Jain | 2021-06-11 
    * @param statusCodeP 
    * @param statusP 
    * @param messageP 
    * @return sMgetAsvCessionOfExtInv_Resp_IB_v1 
    **/
    public static sMgetAsvCessionOfExtInv_Resp_IB_v1 mapFailedResponseFields(Integer statusCodeP, String statusP, String messageP) {
        sMgetAsvCessionOfExtInv_Resp_IB_v1 responseBean = new sMgetAsvCessionOfExtInv_Resp_IB_v1();
        responseBean.status = statusP;
        responseBean.statusCode = statusCodeP;
        responseBean.message = messageP;

        System.debug('SMgetASVCessionOfExternalInvestmentsV1 Failed Response bean: ' + responseBean);
        return responseBean;
    }
}