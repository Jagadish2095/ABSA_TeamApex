/*
 * Integration Utility Bean for ExperianBusinessDetailsGet Service
 * @author Prashant Jain
 * @created 2019-12-05
 */

public class ExperianBusinessDetailsGet_IU_v1 {

    /* Creates a bean from the response
     * @param: HTTP Response
     * @return: ExperianBusinessDetailsGet_Resp_IB_v1 bean object
     */
    public static ExperianBusinessDetailsGet_Resp_IB_v1 mapResponseFields(HttpResponse responseP) {
        ExperianBusinessDetailsGet_Resp_IB_v1 responseBeanContent;
        
        try {
            ExperianBusinessDetailsGet_Resp_IB_v1 responseBean = new ExperianBusinessDetailsGet_Resp_IB_v1();
            responseBeanContent = (ExperianBusinessDetailsGet_Resp_IB_v1)responseBean.deserialize(responseP.getBody(), ExperianBusinessDetailsGet_Resp_IB_v1.class);
            
            responseBeanContent.status = responseP.getStatus();
            responseBeanContent.statusCode = responseP.getStatusCode();
            //responseBeanContent.message = '';
        } catch (Exception e) {
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            responseBeanContent = mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, StringConstants.Sevice500InternalErrorMessage);
            System.debug(message);
        }

        System.debug('ExperianBusinessDetailsGet Response bean: ' + responseBeanContent);
        return responseBeanContent;
    }

    /* Creates a custom bean with the parameters mapped to their respective fields (Used for creating failed response beans)
     * @param: Status Code
     * @param: Status
     * @param: message
     * @return: ExperianBusinessDetailsGet_Resp_IB_v1 bean object
     * */

    public static ExperianBusinessDetailsGet_Resp_IB_v1 mapFailedResponseFields(Integer statusCodeP, String statusP, String messageP) {
        ExperianBusinessDetailsGet_Resp_IB_v1 responseBean = new ExperianBusinessDetailsGet_Resp_IB_v1();
        responseBean.status = statusP;
        responseBean.statusCode = statusCodeP;
        responseBean.message = messageP;

        System.debug('ExperianBusinessDetailsGet Failed Response bean: ' + responseBean);
        return responseBean;
    }
}