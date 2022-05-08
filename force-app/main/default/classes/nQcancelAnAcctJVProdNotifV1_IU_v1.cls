/**
* Descripton: Apex Integration Utility Bean class for NQcancelAnAcctJVProdNotificationV1 service
* Test Class Name: nQupdateNotificationsV1_IU_V2
* @author  Muvhuso Nekhubvi : Absa
* @since   2020-16-04
*
**/
public class nQcancelAnAcctJVProdNotifV1_IU_v1 {
	public static nQcancelAnAcctJVProdNotifV1_Req_IB_v1 mapRequestdFields(String CIF , String accountNumber,String siteCode){    
    
        nQcancelAnAcctJVProdNotifV1_Req_IB_v1 requestBean = new nQcancelAnAcctJVProdNotifV1_Req_IB_v1();
              
        nQcancelAnAcctJVProdNotifV1_Req_IB_v1.Nbsapdpi nbsapdpi = new nQcancelAnAcctJVProdNotifV1_Req_IB_v1.Nbsapdpi();
        
        nQcancelAnAcctJVProdNotifV1_Req_IB_v1.NQcancelAnAcctJVProdNotificationV1 nQcancelAnAcctJVProdNotificationV1  = new nQcancelAnAcctJVProdNotifV1_Req_IB_v1.NQcancelAnAcctJVProdNotificationV1();
        nbsapdpi.channel = 'SALESFORCE';
        nbsapdpi.application = 'SALESFORCE';
        nbsapdpi.trace = 'Y';
        
        nQcancelAnAcctJVProdNotifV1_Req_IB_v1.Nbsmsgi nbsmsgi = new nQcancelAnAcctJVProdNotifV1_Req_IB_v1.Nbsmsgi();
        nbsmsgi.msgLanguage = 'E';
        nbsmsgi.msgTarget = 'STD';
         
        nQcancelAnAcctJVProdNotifV1_Req_IB_v1.FinalMsgId finalMsgId = new nQcancelAnAcctJVProdNotifV1_Req_IB_v1.FinalMsgId();
        finalMsgId.finalMsgClass = '';
        finalMsgId.finalMsgCode = '';
        nbsmsgi.finalMsgId = finalMsgId;
        
        nQcancelAnAcctJVProdNotifV1_Req_IB_v1.Nqp207i nqp207i = new nQcancelAnAcctJVProdNotifV1_Req_IB_v1.Nqp207i();
        nqp207i.registeringSite = siteCode;
        nqp207i.jvName = 'ABSA';
        nqp207i.jvRefNo = 'ABSA';
        nqp207i.cif = CIF;
        nqp207i.accountNumber = accountNumber;
        nqp207i.pnsRecipientId = '1';
        nqp207i.clientNotif = '901';
        
        nQcancelAnAcctJVProdNotificationV1.nbsapdpi = nbsapdpi;
        nQcancelAnAcctJVProdNotificationV1.nbsmsgi = nbsmsgi;
        nQcancelAnAcctJVProdNotificationV1.nqp207i = nqp207i;
        
       
        requestBean.NQcancelAnAcctJVProdNotificationV1 = nQcancelAnAcctJVProdNotificationV1;
       
        return requestBean;
    }
    
     /* Creates a bean from the response
     * @param: HTTP Response
     * @return: nQupdateNotificationsV1_Resp_IB_v2 bean object
     */
    public static nQcancelAnAcctJVProdNotifV1_Resp_IB_v1 mapResponseFields(HttpResponse responseP) {
        nQcancelAnAcctJVProdNotifV1_Resp_IB_v1 responseBeanContent;
        
        try {
            nQcancelAnAcctJVProdNotifV1_Resp_IB_v1 responseBean = new nQcancelAnAcctJVProdNotifV1_Resp_IB_v1();
            responseBeanContent = (nQcancelAnAcctJVProdNotifV1_Resp_IB_v1)responseBean.deserialize(responseP.getBody(), nQcancelAnAcctJVProdNotifV1_Resp_IB_v1.class);
            
            responseBeanContent.status = responseP.getStatus();
            responseBeanContent.statusCode = responseP.getStatusCode();
            //responseBeanContent.message = '';
        } catch (Exception e) {
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            responseBeanContent = mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, StringConstants.Sevice500InternalErrorMessage);
            System.debug(message);
        }

        System.debug('nQcreateNewOrAddRecipientV2 Response bean: ' + responseBeanContent);
        return responseBeanContent;
    }
    
    /* Creates a custom bean with the parameters mapped to their respective fields (Used for creating failed response beans)
     * @param: Status Code
     * @param: Status
     * @param: message
     * @return: nQupdateNotificationsV1_Resp_IB_v2 bean object
     * */

    public static nQcancelAnAcctJVProdNotifV1_Resp_IB_v1 mapFailedResponseFields(Integer statusCodeP, String statusP, String messageP) {
        nQcancelAnAcctJVProdNotifV1_Resp_IB_v1 responseBean = new nQcancelAnAcctJVProdNotifV1_Resp_IB_v1();
        responseBean.status = statusP;
        responseBean.statusCode = statusCodeP;
        responseBean.message = messageP;

        System.debug('nQupdateNotificationsV1 Failed Response bean: ' + responseBean);
        return responseBean;
    }
    
}