/*
 * Integration Utility Bean for CCgetDailyLimits Service
 * @author Prashant Jain
 * @created 2019-09-11
 */

public class CCgetDailyLimits_IU_v1 {
    public static CCgetDailyLimits_Req_IB_v1 mapRequestFields(String combiNbr) {
        CCgetDailyLimits_Req_IB_v1 requestBean = new CCgetDailyLimits_Req_IB_v1();

        requestBean.channel = StringConstants.SALESFORCE_STRING;
        requestBean.application = StringConstants.SALESFORCE_STRING;
        requestBean.trace = 'Y';
        requestBean.msgLanguage = 'E';
        requestBean.msgTarget = 'STD';

        requestBean.combiNbr = combiNbr;

        System.debug('CCgetDailyLimits Request Bean: ' + requestBean);
        return requestBean;
    }

    /* Creates a bean from the response
     * @param: HTTP Response
     * @return: CCgetDailyLimits_Resp_IB_v1 bean object
     */
    public static CCgetDailyLimits_Resp_IB_v1 mapResponseFields(HttpResponse responseP) {
        CCgetDailyLimits_Resp_IB_v1 responseBean = new CCgetDailyLimits_Resp_IB_v1();
        CCgetDailyLimits_Resp_IB_v1 responseBeanContent = (CCgetDailyLimits_Resp_IB_v1)responseBean.deserialize(responseP.getBody(), CCgetDailyLimits_Resp_IB_v1.class);

        responseBeanContent.status = responseP.getStatus();
        responseBeanContent.statusCode = responseP.getStatusCode();
        responseBeanContent.message = '';

        System.debug('CCgetDailyLimits Response bean: ' + responseBeanContent);
        return responseBeanContent;
    }

    /* Creates a custom bean with the parameters mapped to their respective fields (Used for creating failed response beans)
     * @param: Status Code
     * @param: Status
     * @param: message
     * @return: CCgetDailyLimits_Resp_IB_v1 bean object
     * */

    public static CCgetDailyLimits_Resp_IB_v1 mapFailedResponseFields(Integer statusCodeP, String statusP, String messageP) {
        CCgetDailyLimits_Resp_IB_v1 responseBean = new CCgetDailyLimits_Resp_IB_v1();
        responseBean.status = statusP;
        responseBean.statusCode = statusCodeP;
        responseBean.message = messageP;

        System.debug('CCgetDailyLimits Failed Response bean: ' + responseBean);
        return responseBean;
    }
}