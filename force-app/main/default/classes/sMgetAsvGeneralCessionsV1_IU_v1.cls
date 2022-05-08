/**
 * @description       : Integration Utility Bean for sMgetAsvGeneralCessionsV1 Service
 * @author            : Prashant Jain
 * @last modified on  : 2021-06-11
 * @last modified by  : Prashant Jain
 * Modifications Log 
 * Ver   Date         Author          Modification
 * 1.0   2021-06-11   Prashant Jain   Initial Version
**/


public class sMgetAsvGeneralCessionsV1_IU_v1 {
 

    /**
    * @description Creates a request bean
    * @author Prashant Jain | 2021-06-11 
    * @param clcd 
    * @return sMgetAsvGeneralCessionsV1_Req_IB_v1 
    **/
    public static sMgetAsvGeneralCessionsV1_Req_IB_v1 mapRequestFields(String clcd) {
		
        sMgetAsvGeneralCessionsV1_Req_IB_v1 requestBean = new sMgetAsvGeneralCessionsV1_Req_IB_v1();
        sMgetAsvGeneralCessionsV1_Req_IB_v1.SMgetASVGeneralCessionsV1 sMgetASVGeneralCessionsV1 = new sMgetAsvGeneralCessionsV1_Req_IB_v1.SMgetASVGeneralCessionsV1();
        sMgetAsvGeneralCessionsV1_Req_IB_v1.Nbsapdpi nbsapdpi = new sMgetAsvGeneralCessionsV1_Req_IB_v1.Nbsapdpi();
        nbsapdpi.channel = 'BDP';
        nbsapdpi.application = 'BDP';
        nbsapdpi.trace = 'Y';
        
        sMgetAsvGeneralCessionsV1_Req_IB_v1.Nbsmsgi nbsmsgi = new sMgetAsvGeneralCessionsV1_Req_IB_v1.Nbsmsgi();
        sMgetAsvGeneralCessionsV1_Req_IB_v1.FinalMsgId FinalMsgId = new sMgetAsvGeneralCessionsV1_Req_IB_v1.FinalMsgId();
        FinalMsgId.finalMsgClass  = '';
        FinalMsgId.finalMsgCode = '';
        nbsmsgi.msgLanguage = 'E';
        nbsmsgi.msgTarget = 'STD';
        nbsmsgi.finalMsgId  = FinalMsgId;
        sMgetAsvGeneralCessionsV1_Req_IB_v1.Sms148i sms148i = new sMgetAsvGeneralCessionsV1_Req_IB_v1.Sms148i();
        sms148i.clcd = clcd;
        SMgetASVGeneralCessionsV1.nbsapdpi = nbsapdpi;
        SMgetASVGeneralCessionsV1.nbsmsgi = nbsmsgi;
        SMgetASVGeneralCessionsV1.sms148i = sms148i;
        requestBean.SMgetASVGeneralCessionsV1 =  SMgetASVGeneralCessionsV1;
        System.debug('sMgetAsvGeneralCessionsV1 Request Bean: ' + requestBean);
        return requestBean;
    }

    /**
    * @description Creates a bean from the response
    * @author Prashant Jain | 2021-06-11 
    * @param responseP 
    * @return sMgetAsvGeneralCessionsV1_Resp_IB_v1 
    **/
    public static sMgetAsvGeneralCessionsV1_Resp_IB_v1 mapResponseFields(HttpResponse responseP) {
        sMgetAsvGeneralCessionsV1_Resp_IB_v1 responseBeanContent;
        
        try {
            sMgetAsvGeneralCessionsV1_Resp_IB_v1 responseBean = new sMgetAsvGeneralCessionsV1_Resp_IB_v1();
            
            responseBeanContent = (sMgetAsvGeneralCessionsV1_Resp_IB_v1)responseBean.deserialize(responseP.getBody(), sMgetAsvGeneralCessionsV1_Resp_IB_v1.class);
            
            responseBeanContent.status = responseP.getStatus();
            responseBeanContent.statusCode = responseP.getStatusCode();
            //responseBeanContent.message = '';
        } catch (Exception e) {
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            responseBeanContent = mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, StringConstants.Sevice500InternalErrorMessage);
            System.debug(message);
        }

        System.debug('sMgetAsvGeneralCessionsV1 Response bean: ' + responseBeanContent);
        return responseBeanContent;
    }


    /**
    * @description Creates a custom bean with the parameters mapped to their respective fields (Used for creating failed response beans)
    * @author Prashant Jain | 2021-06-11 
    * @param statusCodeP 
    * @param statusP 
    * @param messageP 
    * @return sMgetAsvGeneralCessionsV1_Resp_IB_v1 
    **/
    public static sMgetAsvGeneralCessionsV1_Resp_IB_v1 mapFailedResponseFields(Integer statusCodeP, String statusP, String messageP) {
        sMgetAsvGeneralCessionsV1_Resp_IB_v1 responseBean = new sMgetAsvGeneralCessionsV1_Resp_IB_v1();
        responseBean.status = statusP;
        responseBean.statusCode = statusCodeP;
        responseBean.message = messageP;

        System.debug('sMgetAsvGeneralCessionsV1 Failed Response bean: ' + responseBean);
        return responseBean;
    }
}