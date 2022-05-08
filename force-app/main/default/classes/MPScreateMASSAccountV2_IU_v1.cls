/*
 * Integration Utility Bean for MPScreateMASSAccountV2 Service
 * @author Prashant Jain
 * @created 2020-05-08
 */

public class MPScreateMASSAccountV2_IU_v1 {

    /* Creates a bean from the response
     * @param: HTTP Response
     * @return: MPScreateMASSAccountV2_Resp_IB_v1 bean object
     */
    public static MPScreateMASSAccountV2_Resp_IB_v1 mapResponseFields(HttpResponse responseP) {
        MPScreateMASSAccountV2_Resp_IB_v1 responseBeanContent;

        try {
            MPScreateMASSAccountV2_Resp_IB_v1 responseBean = new MPScreateMASSAccountV2_Resp_IB_v1();
            responseBeanContent = (MPScreateMASSAccountV2_Resp_IB_v1)responseBean.deserialize(responseP.getBody(), MPScreateMASSAccountV2_Resp_IB_v1.class);

            responseBeanContent.status = responseP.getStatus();
            responseBeanContent.statusCode = responseP.getStatusCode();
            //responseBeanContent.message = '';
        } catch (Exception e) {
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            responseBeanContent = mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
            System.debug(message);
        }

        System.debug('MPScreateMASSAccountV2 Response bean: ' + responseBeanContent);
        return responseBeanContent;
    }

    /* Creates a custom bean with the parameters mapped to their respective fields (Used for creating failed response beans)
     * @param: Status Code
     * @param: Status
     * @param: message
     * @return: MPScreateMASSAccountV2_Resp_IB_v1 bean object
     * */

    public static MPScreateMASSAccountV2_Resp_IB_v1 mapFailedResponseFields(Integer statusCodeP, String statusP, String messageP) {
        MPScreateMASSAccountV2_Resp_IB_v1 responseBean = new MPScreateMASSAccountV2_Resp_IB_v1();
        responseBean.status = statusP;
        responseBean.statusCode = statusCodeP;
        responseBean.message = messageP;

        System.debug('MPScreateMASSAccountV2 Failed Response bean: ' + responseBean);
        return responseBean;
    }
}