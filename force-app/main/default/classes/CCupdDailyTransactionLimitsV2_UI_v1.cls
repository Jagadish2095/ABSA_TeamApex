/*
 * Integration Utility Bean for CCupdDailyTransactionLimitsV2 Service
 * @author Muvhuso Nekhubvi
 * @created 2019-10-09
 */
public class CCupdDailyTransactionLimitsV2_UI_v1 {
    public static CCupdDailyTransactionLimitsV2_Req_IB_v1 mapRequestFields(String telerCode , String workStation, String supervisor , String branchCode, String combiNbr, String cardCshLim, String cardTrfLim, String cardPosLim, String cardCntLim, String cheqNomAcc, String cheqApplNo, String cheqCshLim, String cheqTrfLim, String cheqPosLim,String savsNomAcc,String savsApplNo, String savsCshLim, String savsTrfLim, String savsPosLim) {
        CCupdDailyTransactionLimitsV2_Req_IB_v1 requestBean = new CCupdDailyTransactionLimitsV2_Req_IB_v1();
        requestBean.channel = StringConstants.SALESFORCE_STRING;
        requestBean.application = StringConstants.SALESFORCE_STRING;
        requestBean.trace = 'Y';
        requestBean.msgLanguage = 'E';
        requestBean.msgTarget = 'STD';
        requestBean.tellerCode = '1';
        requestBean.workStation = '1';
        requestBean.supervisor = '1';
        requestBean.branchCode = '1';
        requestBean.combiNbr = combiNbr;//'04451470000037318';//combiNbr;
        requestBean.cardCshLim = cardCshLim;//'10';//cardCshLim;
        requestBean.cardTrfLim = cardTrfLim;//'10';//cardTrfLim;
		requestBean.cardPosLim = cardPosLim;//10';//cardTrfLim;
		requestBean.cardCntLim = cardCntLim;//'10';//cardCntLim;
        requestBean.cheqNomAcc = '0';
        requestBean.cheqApplNo = '0';
        requestBean.cheqCshLim = '0';
        requestBean.cheqTrfLim = '0';
        requestBean.cheqPosLim = '0';
        requestBean.savsNomAcc = '0';
        requestBean.savsApplNo = '0';
        requestBean.savsCshLim = '0';
        requestBean.savsTrfLim = '0';
        requestBean.savsPosLim = '0';
        System.debug('CCupdDailyTransactionLimitsV2 Request Bean: ' + requestBean);
        return requestBean;
    }
    
     /* Creates a bean from the response
     * @param: HTTP Response
     * @return: CCupdDailyTransactionLimitsV2 bean object
     */
    public static CCupdDailyTransactionLimitsV2_Resp_IB_v1 mapResponseFields(HttpResponse responseP) {
        CCupdDailyTransactionLimitsV2_Resp_IB_v1 responseBean = new CCupdDailyTransactionLimitsV2_Resp_IB_v1();
        CCupdDailyTransactionLimitsV2_Resp_IB_v1 responseBeanContent = (CCupdDailyTransactionLimitsV2_Resp_IB_v1)responseBean.deserialize(responseP.getBody(), CCupdDailyTransactionLimitsV2_Resp_IB_v1.class);

        responseBeanContent.status = responseP.getStatus();
        responseBeanContent.statusCode = responseP.getStatusCode();
        responseBeanContent.message = '';

        System.debug('CCupdDailyTransactionLimitsV2_Resp_IB_v1 Response bean: ' + responseBeanContent);
        return responseBeanContent;
    }
    
    /* Creates a custom bean with the parameters mapped to their respective fields (Used for creating failed response beans)
     * @param: Status Code
     * @param: Status
     * @param: message
     * @return: CCupdDailyTransactionLimitsV2_Resp_IB_v1 bean object
     * */

    public static CCupdDailyTransactionLimitsV2_Resp_IB_v1 mapFailedResponseFields(Integer statusCodeP, String statusP, String messageP) {
        CCupdDailyTransactionLimitsV2_Resp_IB_v1 responseBean = new CCupdDailyTransactionLimitsV2_Resp_IB_v1();
        responseBean.status = statusP;
        responseBean.statusCode = statusCodeP;
        responseBean.message = messageP;

        System.debug('CCupdDailyTransactionLimitsV2 Failed Response bean: ' + responseBean);
        return responseBean;
    }
}