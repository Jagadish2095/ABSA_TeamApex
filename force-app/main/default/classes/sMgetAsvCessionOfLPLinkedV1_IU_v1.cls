/**
 * @description       : Integration Utility Bean for sMgetAsvCessionOfLPLinkedV1 Service
 * @author            : Prashant Jain
 * @last modified on  : 2021-06-11
 * @last modified by  : Prashant Jain
 * Modifications Log 
 * Ver   Date         Author          Modification
 * 1.0   2021-06-11   Prashant Jain   Initial Version
**/

public class sMgetAsvCessionOfLPLinkedV1_IU_v1 {

   

    /**
    * @description Creates a request bean
    * @author Prashant Jain | 2021-06-11 
    * @param clcdData 
    * @return sMgetAsvCessionOfLPLinkedV1_Req_IB_v1 
    **/
    public static sMgetAsvCessionOfLPLinkedV1_Req_IB_v1 mapRequestFields(String clcdData) {
		
        sMgetAsvCessionOfLPLinkedV1_Req_IB_v1 requestBean = new sMgetAsvCessionOfLPLinkedV1_Req_IB_v1();
		//requestBean.smp332ei = new sMgetAsvCessionOfLPLinkedV1_Req_IB_v1.Smp332ei();
		
		//requestBean.smp332ei.clcdData = clcdData;
		requestBean.SMgetASVCessionOfLifePoliciesLinkedV1=new sMgetAsvCessionOfLPLinkedV1_Req_IB_v1.SMgetASVCessionOfLifePoliciesLinkedV1();
        requestBean.SMgetASVCessionOfLifePoliciesLinkedV1.Smp332ei=new sMgetAsvCessionOfLPLinkedV1_Req_IB_v1.Smp332ei();
		requestBean.SMgetASVCessionOfLifePoliciesLinkedV1.Smp332ei.clcdData=clcdData;
		
        System.debug('sMgetAsvCessionOfLPLinkedV1 Request Bean: ' + json.serializePretty(requestBean));
        return requestBean;
    }

    /**
    * @description Creates a bean from the response
    * @author Prashant Jain | 2021-06-11 
    * @param responseP 
    * @return sMgetAsvCessionOfLPLinkedV1_Resp_IB_v1 
    **/
    public static sMgetAsvCessionOfLPLinkedV1_Resp_IB_v1 mapResponseFields(HttpResponse responseP) {
        sMgetAsvCessionOfLPLinkedV1_Resp_IB_v1 responseBeanContent;
        
        try {
            sMgetAsvCessionOfLPLinkedV1_Resp_IB_v1 responseBean = new sMgetAsvCessionOfLPLinkedV1_Resp_IB_v1();
            responseBeanContent = (sMgetAsvCessionOfLPLinkedV1_Resp_IB_v1)responseBean.deserialize(responseP.getBody(), sMgetAsvCessionOfLPLinkedV1_Resp_IB_v1.class);
            
            responseBeanContent.status = responseP.getStatus();
            responseBeanContent.statusCode = responseP.getStatusCode();
            //responseBeanContent.message = '';
        } catch (Exception e) {
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            responseBeanContent = mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, StringConstants.Sevice500InternalErrorMessage);
            System.debug(message);
        }

        System.debug('sMgetAsvCessionOfLPLinkedV1 Response bean: ' + responseBeanContent);
        return responseBeanContent;
    }


    /**
    * @description Creates a custom bean with the parameters mapped to their respective fields (Used for creating failed response beans)
    * @author Prashant Jain | 2021-06-11 
    * @param statusCodeP 
    * @param statusP 
    * @param messageP 
    * @return sMgetAsvCessionOfLPLinkedV1_Resp_IB_v1 
    **/
    public static sMgetAsvCessionOfLPLinkedV1_Resp_IB_v1 mapFailedResponseFields(Integer statusCodeP, String statusP, String messageP) {
        sMgetAsvCessionOfLPLinkedV1_Resp_IB_v1 responseBean = new sMgetAsvCessionOfLPLinkedV1_Resp_IB_v1();
        responseBean.status = statusP;
        responseBean.statusCode = statusCodeP;
        responseBean.message = messageP;

        System.debug('sMgetAsvCessionOfLPLinkedV1 Failed Response bean: ' + responseBean);
        return responseBean;
    }
}