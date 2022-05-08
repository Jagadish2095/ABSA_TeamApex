/*
 * Integration Utility Bean for MpsCreateMerchantPlanv1 Service
 * @author Prashant Jain
 * @created 2020-05-08
 */

public class MpsCreateMerchantPlanv1_IU_v1 {

    /* Creates a bean from the response
     * @param: HTTP Response
     * @return: MpsCreateMerchantPlanv1_Resp_IB_v1 bean object
     */
    public static MpsCreateMerchantPlanv1_Resp_IB_v1 mapResponseFields(HttpResponse responseP) {
        MpsCreateMerchantPlanv1_Resp_IB_v1 responseBeanContent;

        try {
            MpsCreateMerchantPlanv1_Resp_IB_v1 responseBean = new MpsCreateMerchantPlanv1_Resp_IB_v1();
            responseBeanContent = (MpsCreateMerchantPlanv1_Resp_IB_v1)responseBean.deserialize(responseP.getBody(), MpsCreateMerchantPlanv1_Resp_IB_v1.class);

            responseBeanContent.status = responseP.getStatus();
            responseBeanContent.statusCode = responseP.getStatusCode();
            //responseBeanContent.message = '';
        } catch (Exception e) {
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            responseBeanContent = mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
            System.debug(message);
        }

        System.debug('MpsCreateMerchantPlanv1 Response bean: ' + responseBeanContent);
        return responseBeanContent;
    }

    /* Creates a custom bean with the parameters mapped to their respective fields (Used for creating failed response beans)
     * @param: Status Code
     * @param: Status
     * @param: message
     * @return: MpsCreateMerchantPlanv1_Resp_IB_v1 bean object
     * */

    public static MpsCreateMerchantPlanv1_Resp_IB_v1 mapFailedResponseFields(Integer statusCodeP, String statusP, String messageP) {
        MpsCreateMerchantPlanv1_Resp_IB_v1 responseBean = new MpsCreateMerchantPlanv1_Resp_IB_v1();
        responseBean.status = statusP;
        responseBean.statusCode = statusCodeP;
        responseBean.message = messageP;

        System.debug('MpsCreateMerchantPlanv1 Failed Response bean: ' + responseBean);
        return responseBean;
    }
}