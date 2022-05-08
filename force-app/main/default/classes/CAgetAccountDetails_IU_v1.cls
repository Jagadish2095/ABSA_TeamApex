/*
 * Integration Utility Bean for CAgetAccountDetails Service
 * @author Prashant Jain
 * @created 2019-09-27
 */

public class CAgetAccountDetails_IU_v1 {
    public static CAgetAccountDetails_Req_IB_v1 mapRequestFields(String accountNumber) {
        CAgetAccountDetails_Req_IB_v1 requestBean = new CAgetAccountDetails_Req_IB_v1();

        requestBean.channel = StringConstants.SALESFORCE_STRING;
        requestBean.application = StringConstants.SALESFORCE_STRING;
        requestBean.trace = 'Y';
        requestBean.msgLanguage = 'E';
        requestBean.msgTarget = 'STD';

        requestBean.accountNumber = accountNumber;

        System.debug('CAgetAccountDetails Request Bean: ' + requestBean);
        return requestBean;
    }

    /* Creates a bean from the response
     * @param: HTTP Response
     * @return: CAgetAccountDetails_Resp_IB_v1 bean object
     */
    public static CAgetAccountDetails_Resp_IB_v1 mapResponseFields(HttpResponse responseP) {
        CAgetAccountDetails_Resp_IB_v1 responseBean = new CAgetAccountDetails_Resp_IB_v1();
        CAgetAccountDetails_Resp_IB_v1 responseBeanContent = (CAgetAccountDetails_Resp_IB_v1)responseBean.deserialize(responseP.getBody(), CAgetAccountDetails_Resp_IB_v1.class);

        responseBeanContent.status = responseP.getStatus();
        responseBeanContent.statusCode = responseP.getStatusCode();
        responseBeanContent.message = '';

        System.debug('CAgetAccountDetails Response bean: ' + responseBeanContent);
        return responseBeanContent;
    }

    /* Creates a custom bean with the parameters mapped to their respective fields (Used for creating failed response beans)
     * @param: Status Code
     * @param: Status
     * @param: message
     * @return: CAgetAccountDetails_Resp_IB_v1 bean object
     * */

    public static CAgetAccountDetails_Resp_IB_v1 mapFailedResponseFields(Integer statusCodeP, String statusP, String messageP) {
        CAgetAccountDetails_Resp_IB_v1 responseBean = new CAgetAccountDetails_Resp_IB_v1();
        responseBean.status = statusP;
        responseBean.statusCode = statusCodeP;
        responseBean.message = messageP;

        System.debug('CAgetAccountDetails Failed Response bean: ' + responseBean);
        return responseBean;
    }
}