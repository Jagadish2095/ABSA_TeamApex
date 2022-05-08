/**
 * @description       : Integration Utility Bean for sMgetAsvCreditLifePolicyV1 Service
 * @author            : Prashant Jain
 * @last modified on  : 2021-06-10
 * @last modified by  : Prashant Jain
 * Modifications Log 
 * Ver   Date         Author          Modification
 * 1.0   2021-06-10   Prashant Jain   Initial Version
**/

public class sMgetAsvCreditLifePolicyV1_IU_v1 {

    /**
    * @description 
    * @author Prashant Jain | 2021-06-10 
    * @param clcd 
    * @return sMgetAsvCreditLifePolicyV1_Req_IB_v1 
    **/
    public static sMgetAsvCreditLifePolicyV1_Req_IB_v1 mapRequestFields(String clcd) {
		
        sMgetAsvCreditLifePolicyV1_Req_IB_v1 requestBean = new sMgetAsvCreditLifePolicyV1_Req_IB_v1();
        sMgetAsvCreditLifePolicyV1_Req_IB_v1.SMgetASVcreditLifePoliciesV1 sMgetASVcreditLifePoliciesV1 = new sMgetAsvCreditLifePolicyV1_Req_IB_v1.SMgetASVcreditLifePoliciesV1();
        sMgetAsvCreditLifePolicyV1_Req_IB_v1.Nbsapdpi nbsapdpi = new sMgetAsvCreditLifePolicyV1_Req_IB_v1.Nbsapdpi();
        nbsapdpi.channel = 'BDP';
        nbsapdpi.application = 'BDP';
        nbsapdpi.trace = 'Y';
        sMgetAsvCreditLifePolicyV1_Req_IB_v1.Nbsmsgi nbsmsgi = new sMgetAsvCreditLifePolicyV1_Req_IB_v1.Nbsmsgi();
        nbsmsgi.msgLanguage = 'E';
        nbsmsgi.msgTarget = 'STD';
        sMgetAsvCreditLifePolicyV1_Req_IB_v1.Smn151i smn151i = new sMgetAsvCreditLifePolicyV1_Req_IB_v1.Smn151i();
        smn151i.clcd = clcd;
        sMgetASVcreditLifePoliciesV1.nbsapdpi = nbsapdpi;
        sMgetASVcreditLifePoliciesV1.nbsmsgi = nbsmsgi;
        sMgetASVcreditLifePoliciesV1.smn151i = smn151i;
        requestBean.SMgetASVcreditLifePoliciesV1 = sMgetASVcreditLifePoliciesV1;
		//requestBean.smn151i.clcd = clcd;
		
        System.debug('sMgetAsvCreditLifePolicyV1 Request Bean: ' + requestBean);
        return requestBean;
    }

    /**
    * @description 
    * @author Prashant Jain | 2021-06-10 
    * @param responseP 
    * @return sMgetAsvCreditLifePolicyV1_Resp_IB_v1 
    **/
    public static sMgetAsvCreditLifePolicyV1_Resp_IB_v1 mapResponseFields(HttpResponse responseP) {
        sMgetAsvCreditLifePolicyV1_Resp_IB_v1 responseBeanContent;
        
        try {
            sMgetAsvCreditLifePolicyV1_Resp_IB_v1 responseBean = new sMgetAsvCreditLifePolicyV1_Resp_IB_v1();
            responseBeanContent = (sMgetAsvCreditLifePolicyV1_Resp_IB_v1)responseBean.deserialize(responseP.getBody(), sMgetAsvCreditLifePolicyV1_Resp_IB_v1.class);
            
            responseBeanContent.status = responseP.getStatus();
            responseBeanContent.statusCode = responseP.getStatusCode();
            //responseBeanContent.message = '';
        } catch (Exception e) {
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            responseBeanContent = mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, StringConstants.Sevice500InternalErrorMessage);
            System.debug(message);
        }

        System.debug('sMgetAsvCreditLifePolicyV1 Response bean: ' + responseBeanContent);
        return responseBeanContent;
    }

    /**
    * @description 
    * @author Prashant Jain | 2021-06-10 
    * @param statusCodeP 
    * @param statusP 
    * @param messageP 
    * @return sMgetAsvCreditLifePolicyV1_Resp_IB_v1 
    **/
    public static sMgetAsvCreditLifePolicyV1_Resp_IB_v1 mapFailedResponseFields(Integer statusCodeP, String statusP, String messageP) {
        sMgetAsvCreditLifePolicyV1_Resp_IB_v1 responseBean = new sMgetAsvCreditLifePolicyV1_Resp_IB_v1();
        responseBean.status = statusP;
        responseBean.statusCode = statusCodeP;
        responseBean.message = messageP;

        System.debug('sMgetAsvCreditLifePolicyV1 Failed Response bean: ' + responseBean);
        return responseBean;
    }
}