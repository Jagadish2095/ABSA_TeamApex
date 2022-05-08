/*
 * Integration Utility Bean for MpsCreatePoshMerchantv3 Service
 * @author Prashant Jain
 * @created 2020-05-08
 */

public class MpsCreatePoshMerchantv3_IU_v1 {

    /* Creates a bean from the response
     * @param: HTTP Response
     * @return: MpsCreatePoshMerchantv3_Resp_IB_v1 bean object
     */
    public static MpsCreatePoshMerchantv3_Resp_IB_v1 mapResponseFields(HttpResponse responseP) {
        MpsCreatePoshMerchantv3_Resp_IB_v1 responseBeanContent;

        try {
            MpsCreatePoshMerchantv3_Resp_IB_v1 responseBean = new MpsCreatePoshMerchantv3_Resp_IB_v1();
            responseBeanContent = (MpsCreatePoshMerchantv3_Resp_IB_v1)responseBean.deserialize(responseP.getBody(), MpsCreatePoshMerchantv3_Resp_IB_v1.class);

            responseBeanContent.status = responseP.getStatus();
            responseBeanContent.statusCode = responseP.getStatusCode();
            //responseBeanContent.message = '';
        } catch (Exception e) {
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            responseBeanContent = mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
            System.debug(message);
        }

        System.debug('MpsCreatePoshMerchantv3 Response bean: ' + responseBeanContent);
        return responseBeanContent;
    }

    /* Creates a custom bean with the parameters mapped to their respective fields (Used for creating failed response beans)
     * @param: Status Code
     * @param: Status
     * @param: message
     * @return: MpsCreatePoshMerchantv3_Resp_IB_v1 bean object
     * */

    public static MpsCreatePoshMerchantv3_Resp_IB_v1 mapFailedResponseFields(Integer statusCodeP, String statusP, String messageP) {
        MpsCreatePoshMerchantv3_Resp_IB_v1 responseBean = new MpsCreatePoshMerchantv3_Resp_IB_v1();
        responseBean.status = statusP;
        responseBean.statusCode = statusCodeP;
        responseBean.message = messageP;

        System.debug('MpsCreatePoshMerchantv3 Failed Response bean: ' + responseBean);
        return responseBean;
    }
}