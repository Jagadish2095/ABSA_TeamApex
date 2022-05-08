/**
 * @description       : 
 * @author            : Prashant Jain
 * @last modified on  : 2021-06-10
 * @last modified by  : Prashant Jain
 * Modifications Log 
 * Ver   Date         Author          Modification
 * 1.0   2021-06-10   Prashant Jain   Initial Version
**/


public class SMgetASVCessionOfFireShortV1_IU_v1 {
	/**
	* @description 
	* @author Prashant Jain | 2021-06-10 
	* @param clcd 
	* @return SMgetASVCessionOfFireShortV1_Req_IB_v1 
	**/
	public static SMgetASVCessionOfFireShortV1_Req_IB_v1 mapRequestFields(String clcd) {
		
        SMgetASVCessionOfFireShortV1_Req_IB_v1 requestBean = new SMgetASVCessionOfFireShortV1_Req_IB_v1();
        
        SMgetASVCessionOfFireShortV1_Req_IB_v1.SMgetASVCessionOfFireShortTermInsuranceV1 sMgetASVCessionOfFireShortTermInsuranceV1 = new SMgetASVCessionOfFireShortV1_Req_IB_v1.SMgetASVCessionOfFireShortTermInsuranceV1();
        
        SMgetASVCessionOfFireShortV1_Req_IB_v1.Nbsapdpi nbsapdpi = new SMgetASVCessionOfFireShortV1_Req_IB_v1.Nbsapdpi();
        nbsapdpi.channel = 'BDP';
        nbsapdpi.application = 'BDP';
        nbsapdpi.trace = 'Y';
        
        SMgetASVCessionOfFireShortV1_Req_IB_v1.Nbsmsgi nbsmsgi = new SMgetASVCessionOfFireShortV1_Req_IB_v1.Nbsmsgi();
        nbsmsgi.msgLanguage = 'E';
        nbsmsgi.msgTarget = 'STD';
        
        SMgetASVCessionOfFireShortV1_Req_IB_v1.FinalMsgId finalMsgId = new SMgetASVCessionOfFireShortV1_Req_IB_v1.FinalMsgId();
        finalMsgId.finalMsgClass = '';
        finalMsgId.finalMsgCode = '';
        
        SMgetASVCessionOfFireShortV1_Req_IB_v1.Smp132ei smp132ei = new SMgetASVCessionOfFireShortV1_Req_IB_v1.Smp132ei();
        smp132ei.clcdData = clcd;
        sMgetASVCessionOfFireShortTermInsuranceV1.nbsapdpi = nbsapdpi;
        sMgetASVCessionOfFireShortTermInsuranceV1.nbsmsgi = nbsmsgi;
        sMgetASVCessionOfFireShortTermInsuranceV1.smp132ei = smp132ei;
        requestBean.sMgetASVCessionOfFireShortTermInsuranceV1 = sMgetASVCessionOfFireShortTermInsuranceV1;
        
        System.debug('sMgetASVCessionOfFireShortTermInsuranceV1 Request Bean: ' + requestBean);
        return requestBean;
    }

    
    /**
    * @description 
    * @author Prashant Jain | 2021-06-10 
    * @param responseP 
    * @return SMgetASVCessionOfFireShortV1_Resp_IB_v1 
    **/
    public static SMgetASVCessionOfFireShortV1_Resp_IB_v1 mapResponseFields(HttpResponse responseP) {
        SMgetASVCessionOfFireShortV1_Resp_IB_v1 responseBeanContent;
        
        try {
            SMgetASVCessionOfFireShortV1_Resp_IB_v1 responseBean = new SMgetASVCessionOfFireShortV1_Resp_IB_v1();

            
            responseBeanContent = (SMgetASVCessionOfFireShortV1_Resp_IB_v1)responseBean.deserialize(responseP.getBody(), SMgetASVCessionOfFireShortV1_Resp_IB_v1.class);
            
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
    * @description 
    * @author Prashant Jain | 2021-06-10 
    * @param statusCodeP 
    * @param statusP 
    * @param messageP 
    * @return SMgetASVCessionOfFireShortV1_Resp_IB_v1 
    **/
    public static SMgetASVCessionOfFireShortV1_Resp_IB_v1 mapFailedResponseFields(Integer statusCodeP, String statusP, String messageP) {
        SMgetASVCessionOfFireShortV1_Resp_IB_v1 responseBean = new SMgetASVCessionOfFireShortV1_Resp_IB_v1();
        responseBean.status = statusP;
        responseBean.statusCode = statusCodeP;
        responseBean.message = messageP;

        System.debug('SMgetASVCessionOfExternalInvestmentsV1 Failed Response bean: ' + responseBean);
        return responseBean;
    }
}