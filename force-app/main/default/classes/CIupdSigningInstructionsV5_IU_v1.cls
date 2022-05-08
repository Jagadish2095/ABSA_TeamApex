/*
 * Integration Utility Bean for CIupdSigningInstructionsV5 Service
 * @author Prashant Jain
 * @created 2020-02-25
 */

public class CIupdSigningInstructionsV5_IU_v1 {

    /* Creates a bean from the response
     * @param: HTTP Response
     * @return: CIupdSigningInstructionsV5_Resp_IB_v1 bean object
     */
    public static CIupdSigningInstructionsV5_Resp_IB_v1 mapResponseFields(HttpResponse responseP) {
        CIupdSigningInstructionsV5_Resp_IB_v1 responseBeanContent;
        
        try {
            CIupdSigningInstructionsV5_Resp_IB_v1 responseBean = new CIupdSigningInstructionsV5_Resp_IB_v1();
            responseBeanContent = (CIupdSigningInstructionsV5_Resp_IB_v1)responseBean.deserialize(responseP.getBody(), CIupdSigningInstructionsV5_Resp_IB_v1.class);
            
            responseBeanContent.status = responseP.getStatus();
            responseBeanContent.statusCode = responseP.getStatusCode();
            //responseBeanContent.message = '';
        } catch (Exception e) {
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            responseBeanContent = mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, StringConstants.Sevice500InternalErrorMessage);
            System.debug(message);
        }

        System.debug('CIupdSigningInstructionsV5 Response bean: ' + responseBeanContent);
        return responseBeanContent;
    }

    /* Creates a custom bean with the parameters mapped to their respective fields (Used for creating failed response beans)
     * @param: Status Code
     * @param: Status
     * @param: message
     * @return: CIupdSigningInstructionsV5_Resp_IB_v1 bean object
     * */

    public static CIupdSigningInstructionsV5_Resp_IB_v1 mapFailedResponseFields(Integer statusCodeP, String statusP, String messageP) {
        CIupdSigningInstructionsV5_Resp_IB_v1 responseBean = new CIupdSigningInstructionsV5_Resp_IB_v1();
        responseBean.status = statusP;
        responseBean.statusCode = statusCodeP;
        responseBean.message = messageP;

        System.debug('CIupdSigningInstructionsV5 Failed Response bean: ' + responseBean);
        return responseBean;
    }
}