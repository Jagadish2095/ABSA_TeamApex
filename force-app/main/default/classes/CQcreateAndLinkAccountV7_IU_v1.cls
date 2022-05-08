/*
 * Integration Utility Bean for CQcreateAndLinkAccountV7 Service
 * @author Prashant Jain
 * @created 2020-02-21
 */

public class CQcreateAndLinkAccountV7_IU_v1 {

    /* Creates a request bean
     * @param: accountNbr
     * @param: openSite
     * @param: controlSite
     * @param: cifKey
     * @param: tellerNbr
     * @param: controllerNbr
     * @param: workstationNbr
     * @param: product
     * @param: applicationNbr
     * @param: controlSiteType
     * @param: openSiteType
     * @param: effectiveDate
     * @param: marketersCode
     * @param: provChqBookInd
     * @param: cbpSchemeCode
     * @param: cbpPrimaryAccount
     * @param: srcOfFnds1
     * @param: srcOfFnds2
     * @param: srcOfFnds3
     * @param: srcOfFnds4
     * @param: srcOfFnds5
     * @param: digitalChannel
     * @param: rbaEdd
     * @return: CQcreateAndLinkAccountV7_Req_IB_v1 bean object
     */
    public static CQcreateAndLinkAccountV7_Req_IB_v1 mapRequestFields(String accountNbr, String openSite, String controlSite, String cifKey, String tellerNbr, String controllerNbr, String workstationNbr, String product, String applicationNbr, String controlSiteType, String openSiteType, String effectiveDate, String marketersCode, String provChqBookInd, String cbpSchemeCode, String cbpPrimaryAccount, String srcOfFnds1, String srcOfFnds2, String srcOfFnds3, String srcOfFnds4, String srcOfFnds5, String digitalChannel, String rbaEdd) {
		
        CQcreateAndLinkAccountV7_Req_IB_v1 requestBean = new CQcreateAndLinkAccountV7_Req_IB_v1();
		requestBean.CQcreateAndLinkAccountV7 = new CQcreateAndLinkAccountV7_Req_IB_v1.CQcreateAndLinkAccountV7();
		requestBean.CQcreateAndLinkAccountV7.nbsapdpi = new CQcreateAndLinkAccountV7_Req_IB_v1.Nbsapdpi();
		requestBean.CQcreateAndLinkAccountV7.nbsmsgi = new CQcreateAndLinkAccountV7_Req_IB_v1.Nbsmsgi();
		requestBean.CQcreateAndLinkAccountV7.cqh411i = new CQcreateAndLinkAccountV7_Req_IB_v1.Cqh411i();
		
		requestBean.CQcreateAndLinkAccountV7.nbsapdpi.channel = StringConstants.SALESFORCE_STRING;
		requestBean.CQcreateAndLinkAccountV7.nbsapdpi.application = StringConstants.SALESFORCE_STRING;
		requestBean.CQcreateAndLinkAccountV7.nbsapdpi.trace = 'Y';
		
		requestBean.CQcreateAndLinkAccountV7.nbsmsgi.msgLanguage = 'E';
		requestBean.CQcreateAndLinkAccountV7.nbsmsgi.msgTarget = 'STD';
		
		requestBean.CQcreateAndLinkAccountV7.cqh411i.accountNbr = accountNbr;
		requestBean.CQcreateAndLinkAccountV7.cqh411i.openSite = openSite;
		requestBean.CQcreateAndLinkAccountV7.cqh411i.controlSite = controlSite;
		requestBean.CQcreateAndLinkAccountV7.cqh411i.cifKey = cifKey;
		requestBean.CQcreateAndLinkAccountV7.cqh411i.tellerNbr = tellerNbr;
		requestBean.CQcreateAndLinkAccountV7.cqh411i.controllerNbr = controllerNbr;
		requestBean.CQcreateAndLinkAccountV7.cqh411i.workstationNbr = workstationNbr;
		requestBean.CQcreateAndLinkAccountV7.cqh411i.product = product;
		requestBean.CQcreateAndLinkAccountV7.cqh411i.applicationNbr = applicationNbr;
		requestBean.CQcreateAndLinkAccountV7.cqh411i.controlSiteType = controlSiteType;
		requestBean.CQcreateAndLinkAccountV7.cqh411i.openSiteType = openSiteType;
		requestBean.CQcreateAndLinkAccountV7.cqh411i.effectiveDate = effectiveDate;
		requestBean.CQcreateAndLinkAccountV7.cqh411i.marketersCode = marketersCode;
		requestBean.CQcreateAndLinkAccountV7.cqh411i.provChqBookInd = provChqBookInd;
		requestBean.CQcreateAndLinkAccountV7.cqh411i.cbpSchemeCode = cbpSchemeCode;
		requestBean.CQcreateAndLinkAccountV7.cqh411i.cbpPrimaryAccount = cbpPrimaryAccount;
		requestBean.CQcreateAndLinkAccountV7.cqh411i.srcOfFnds1 = srcOfFnds1;
		requestBean.CQcreateAndLinkAccountV7.cqh411i.srcOfFnds2 = srcOfFnds2;
		requestBean.CQcreateAndLinkAccountV7.cqh411i.srcOfFnds3 = srcOfFnds3;
		requestBean.CQcreateAndLinkAccountV7.cqh411i.srcOfFnds4 = srcOfFnds4;
		requestBean.CQcreateAndLinkAccountV7.cqh411i.srcOfFnds5 = srcOfFnds5;
		requestBean.CQcreateAndLinkAccountV7.cqh411i.digitalChannel = digitalChannel;
		requestBean.CQcreateAndLinkAccountV7.cqh411i.rbaEdd = rbaEdd;

        System.debug('CQcreateAndLinkAccountV7 Request Bean: ' + requestBean);
        return requestBean;
    }

    /* Creates a bean from the response
     * @param: HTTP Response
     * @return: CQcreateAndLinkAccountV7_Resp_IB_v1 bean object
     */
    public static CQcreateAndLinkAccountV7_Resp_IB_v1 mapResponseFields(HttpResponse responseP) {
        CQcreateAndLinkAccountV7_Resp_IB_v1 responseBeanContent;
        
        try {
            CQcreateAndLinkAccountV7_Resp_IB_v1 responseBean = new CQcreateAndLinkAccountV7_Resp_IB_v1();
            responseBeanContent = (CQcreateAndLinkAccountV7_Resp_IB_v1)responseBean.deserialize(responseP.getBody(), CQcreateAndLinkAccountV7_Resp_IB_v1.class);
            
            responseBeanContent.status = responseP.getStatus();
            responseBeanContent.statusCode = responseP.getStatusCode();
            //responseBeanContent.message = '';
        } catch (Exception e) {
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            responseBeanContent = mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, StringConstants.Sevice500InternalErrorMessage);
            System.debug(message);
        }

        System.debug('CQcreateAndLinkAccountV7 Response bean: ' + responseBeanContent);
        return responseBeanContent;
    }

    /* Creates a custom bean with the parameters mapped to their respective fields (Used for creating failed response beans)
     * @param: Status Code
     * @param: Status
     * @param: message
     * @return: CQcreateAndLinkAccountV7_Resp_IB_v1 bean object
     * */

    public static CQcreateAndLinkAccountV7_Resp_IB_v1 mapFailedResponseFields(Integer statusCodeP, String statusP, String messageP) {
        CQcreateAndLinkAccountV7_Resp_IB_v1 responseBean = new CQcreateAndLinkAccountV7_Resp_IB_v1();
        responseBean.status = statusP;
        responseBean.statusCode = statusCodeP;
        responseBean.message = messageP;

        System.debug('CQcreateAndLinkAccountV7 Failed Response bean: ' + responseBean);
        return responseBean;
    }
}