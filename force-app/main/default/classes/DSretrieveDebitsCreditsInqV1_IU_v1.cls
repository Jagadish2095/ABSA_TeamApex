/*
 * Integration Utility Bean for DSretrieveDebitsCreditsInq Service
 * @author Prasanna Patwardhan
 * @created 2019-10-30
 */

public class DSretrieveDebitsCreditsInqV1_IU_v1 {
     public static DSretrieveDebitsCreditsInqV1_Req_IB_v1 mapRequestFields(String acctNo, String frmDate) {
        DSretrieveDebitsCreditsInqV1_Req_IB_v1 requestBean = new DSretrieveDebitsCreditsInqV1_Req_IB_v1();
        requestBean.channel= StringConstants.SALESFORCE_STRING;
        requestBean.application= StringConstants.SALESFORCE_STRING;
        requestBean.trace= 'Y';
        requestBean.msgLanguage = 'E';
        requestBean.msgTarget= 'STD';
        requestBean.channelI = 'BDP';
        requestBean.versionI = '0';
        requestBean.branch = '9713';
        requestBean.functionI = 'SPID';
        requestBean.acno = acctNo;
        requestBean.effFromDate = frmDate;
        requestBean.nxtTieb = '';
        return requestBean;
         
    }
    
    /* Creates a bean from the response
     * @param: HTTP Response
     * @return: DSretrieveDebitsCreditsInqV1_Resp_IB_v1 bean object
     */
    public static DSretrieveDebitsCreditsInqV1_Resp_IB_v1 mapResponseFields(HttpResponse responseP) {
        DSretrieveDebitsCreditsInqV1_Resp_IB_v1 responseBean = new DSretrieveDebitsCreditsInqV1_Resp_IB_v1();
        DSretrieveDebitsCreditsInqV1_Resp_IB_v1 responseBeanContent = (DSretrieveDebitsCreditsInqV1_Resp_IB_v1)responseBean.deserialize(responseP.getBody(), DSretrieveDebitsCreditsInqV1_Resp_IB_v1.class);

        responseBeanContent.status = responseP.getStatus();
        responseBeanContent.statusCode = responseP.getStatusCode();
        responseBeanContent.message = '';

        System.debug('DSretrieveDebitsCreditsInq Response bean: ' + responseBeanContent);
        return responseBeanContent;
               
    }
    
    /* Creates a custom bean with the parameters mapped to their respective fields (Used for creating failed response beans)
     * @param: Status Code
     * @param: Status
     * @param: message
     * @return: DSretrieveDebitsCreditsInqV1_Resp_IB_v1 bean object
     * */
    
    public static DSretrieveDebitsCreditsInqV1_Resp_IB_v1 mapFailedResponseFields(Integer statusCodeP, String statusP, String messageP) {
        DSretrieveDebitsCreditsInqV1_Resp_IB_v1 responseBean = new DSretrieveDebitsCreditsInqV1_Resp_IB_v1();
        responseBean.status = statusP;
        responseBean.statusCode = statusCodeP;
        responseBean.message = messageP;

        System.debug('DSretrieveDebitsCreditsInq Failed Response bean: ' + responseBean);
        return responseBean;
    }

}