/*
* Integration utility for NQlistRecipientsRegisteredForCustV1 Service
* @author Muvhuso Nekhubvi
* @created 2020/05/18
*/
public class nQlistRecipientsRegisteredV1_IU_v1 {
	public static nQlistRecipientsRegisteredV1_Req_IB_v1 mapRequestFields(String clientCode,String registrationSite) {
        
        nQlistRecipientsRegisteredV1_Req_IB_v1 requestBean = new nQlistRecipientsRegisteredV1_Req_IB_v1();
        requestBean.NQlistRecipientsRegisteredForCustV1 = new nQlistRecipientsRegisteredV1_Req_IB_v1.NQlistRecipientsRegisteredForCustV1();
        requestBean.NQlistRecipientsRegisteredForCustV1.nbsapdpi = new nQlistRecipientsRegisteredV1_Req_IB_v1.Nbsapdpi();
        requestBean.NQlistRecipientsRegisteredForCustV1.nbsapdpi.application = 'BDP';
        requestBean.NQlistRecipientsRegisteredForCustV1.nbsapdpi.channel = 'BDP';
        requestBean.NQlistRecipientsRegisteredForCustV1.nbsapdpi.trace = 'Y';
        
        requestBean.NQlistRecipientsRegisteredForCustV1.nbsmsgi = new nQlistRecipientsRegisteredV1_Req_IB_v1.Nbsmsgi();
        requestBean.NQlistRecipientsRegisteredForCustV1.nbsmsgi.finalMsgId = new nQlistRecipientsRegisteredV1_Req_IB_v1.FinalMsgId();
        requestBean.NQlistRecipientsRegisteredForCustV1.nbsmsgi.finalMsgId.finalMsgClass = '';
        requestBean.NQlistRecipientsRegisteredForCustV1.nbsmsgi.finalMsgId.finalMsgCode = '';
        requestBean.NQlistRecipientsRegisteredForCustV1.nbsmsgi.msgLanguage = 'E';
        requestBean.NQlistRecipientsRegisteredForCustV1.nbsmsgi.msgTarget = 'STD';
        
        requestBean.NQlistRecipientsRegisteredForCustV1.nqp904i = new nQlistRecipientsRegisteredV1_Req_IB_v1.Nqp904i();
        requestBean.NQlistRecipientsRegisteredForCustV1.nqp904i.cif = clientCode;
        requestBean.NQlistRecipientsRegisteredForCustV1.nqp904i.registeringSite = registrationSite;
        
        return requestBean;
    }

 
    public static nQlistRecipientsRegisteredV1_Resp_IB_v1 mapResponseFields(HttpResponse responseP) {
        nQlistRecipientsRegisteredV1_Resp_IB_v1 responseBeanContent;
        
        try {
            nQlistRecipientsRegisteredV1_Resp_IB_v1 responseBean = new nQlistRecipientsRegisteredV1_Resp_IB_v1();
            
            responseBeanContent = (nQlistRecipientsRegisteredV1_Resp_IB_v1)responseBean.deserialize(responseP.getBody(), nQlistRecipientsRegisteredV1_Resp_IB_v1.class);
            
            responseBeanContent.status = responseP.getStatus();
            responseBeanContent.statusCode = responseP.getStatusCode();
           
        } catch (Exception e) {
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            responseBeanContent = mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, StringConstants.Sevice500InternalErrorMessage);
            System.debug(message);
        }

        System.debug('NQlistRecipientsRegisteredForCustV1 Response bean: ' + responseBeanContent);
        return responseBeanContent;
    }
     
   
    public static nQlistRecipientsRegisteredV1_Resp_IB_v1 mapFailedResponseFields(Integer statusCodeP, String statusP, String messageP) {
        nQlistRecipientsRegisteredV1_Resp_IB_v1 responseBean = new nQlistRecipientsRegisteredV1_Resp_IB_v1();
        responseBean.status = statusP;
        responseBean.statusCode = statusCodeP;
        responseBean.message = messageP;

        System.debug('NQlistRecipientsRegisteredForCustV1 Failed Response bean: ' + responseBean);
        return responseBean;
    }
}