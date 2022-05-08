/*
 * Integration Utility Bean for CCGetPortfolioDetailV1 Service
 * @author Prashant Jain
 * @created 2020-03-16
 */

public class CCGetPortfolioDetailV1_IU_v1 {

    /* Creates a request bean
     * @param: clcd
     * @return: CCGetPortfolioDetailV1_Req_IB_v1 bean object
     */
    public static CCGetPortfolioDetailV1_Req_IB_v1 mapRequestFields(String combiNbr) {
        
        CCGetPortfolioDetailV1_Req_IB_v1 requestBean = new CCGetPortfolioDetailV1_Req_IB_v1();
        requestBean.CCgetPortfolioDetailV1 = new CCGetPortfolioDetailV1_Req_IB_v1.CCgetPortfolioDetailV1();
        requestBean.CCgetPortfolioDetailV1.nbsapdpi = new CCGetPortfolioDetailV1_Req_IB_v1.Nbsapdpi();
        requestBean.CCgetPortfolioDetailV1.nbsmsgi = new CCGetPortfolioDetailV1_Req_IB_v1.Nbsmsgi();
        requestBean.CCgetPortfolioDetailV1.ccp301i = new CCGetPortfolioDetailV1_Req_IB_v1.Ccp301i();
        
        requestBean.CCgetPortfolioDetailV1.nbsapdpi.channel = 'BPD';
        requestBean.CCgetPortfolioDetailV1.nbsapdpi.application = 'BPD';
        requestBean.CCgetPortfolioDetailV1.nbsapdpi.trace = 'Y';
        requestBean.CCgetPortfolioDetailV1.nbsmsgi.msgLanguage = 'E';
        requestBean.CCgetPortfolioDetailV1.nbsmsgi.msgTarget = 'STD';
        
        requestBean.CCgetPortfolioDetailV1.ccp301i.combiNbr = combiNbr;
		
        System.debug('CCGetPortfolioDetailV1 Request Bean: ' + requestBean);
        return requestBean;
    }

    /* Creates a bean from the response
     * @param: HTTP Response
     * @return: CCGetPortfolioDetailV1_Resp_IB_v1 bean object
     */
    public static CCGetPortfolioDetailV1_Resp_IB_v1 mapResponseFields(HttpResponse responseP) {
        CCGetPortfolioDetailV1_Resp_IB_v1 responseBeanContent;
        
        try {
            CCGetPortfolioDetailV1_Resp_IB_v1 responseBean = new CCGetPortfolioDetailV1_Resp_IB_v1();
            responseBeanContent = (CCGetPortfolioDetailV1_Resp_IB_v1)responseBean.deserialize(responseP.getBody(), CCGetPortfolioDetailV1_Resp_IB_v1.class);
            
            responseBeanContent.status = responseP.getStatus();
            responseBeanContent.statusCode = responseP.getStatusCode();
            //responseBeanContent.message = '';
        } catch (Exception e) {
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            responseBeanContent = mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, StringConstants.Sevice500InternalErrorMessage);
            System.debug(message);
        }

        System.debug('CCGetPortfolioDetailV1 Response bean: ' + responseBeanContent);
        return responseBeanContent;
    }

    /* Creates a custom bean with the parameters mapped to their respective fields (Used for creating failed response beans)
     * @param: Status Code
     * @param: Status
     * @param: message
     * @return: CCGetPortfolioDetailV1_Resp_IB_v1 bean object
     * */

    public static CCGetPortfolioDetailV1_Resp_IB_v1 mapFailedResponseFields(Integer statusCodeP, String statusP, String messageP) {
        CCGetPortfolioDetailV1_Resp_IB_v1 responseBean = new CCGetPortfolioDetailV1_Resp_IB_v1();
        responseBean.status = statusP;
        responseBean.statusCode = statusCodeP;
        responseBean.message = messageP;

        System.debug('CCGetPortfolioDetailV1 Failed Response bean: ' + responseBean);
        return responseBean;
    }
}