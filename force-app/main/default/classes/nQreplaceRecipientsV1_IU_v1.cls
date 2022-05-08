/*
* Integration utility for NQreplaceRecipientsAcrossAllAcntsV1 Service
* @author Muvhuso Nekhubvi
* @created 2020/05/18
*/
public class nQreplaceRecipientsV1_IU_v1 {
    public static nQreplaceRecipientsV1_Req_v1 mapRequestFields(String clientCode,String registrationSite ,String recipNm, String contactPref, String language, String email , String cellphone){
        nQreplaceRecipientsV1_Req_v1 requestBean = new nQreplaceRecipientsV1_Req_v1();
        requestBean.NQreplaceRecipientsAcrossAllAcntsV1 = new nQreplaceRecipientsV1_Req_v1.NQreplaceRecipientsAcrossAllAcntsV1();
		requestBean.NQreplaceRecipientsAcrossAllAcntsV1.nbsapdpi =  new nQreplaceRecipientsV1_Req_v1.Nbsapdpi();
        requestBean.NQreplaceRecipientsAcrossAllAcntsV1.nbsapdpi.application = 'BDP';
        requestBean.NQreplaceRecipientsAcrossAllAcntsV1.nbsapdpi.channel = 'BDP';
        requestBean.NQreplaceRecipientsAcrossAllAcntsV1.nbsapdpi.trace = 'Y';
        
        requestBean.NQreplaceRecipientsAcrossAllAcntsV1.nbsmsgi = new nQreplaceRecipientsV1_Req_v1.Nbsmsgi();
        requestBean.NQreplaceRecipientsAcrossAllAcntsV1.nbsmsgi.msgLanguage = 'E';
        requestBean.NQreplaceRecipientsAcrossAllAcntsV1.nbsmsgi.msgTarget = 'STD';
        requestBean.NQreplaceRecipientsAcrossAllAcntsV1.nbsmsgi.finalMsgId = new nQreplaceRecipientsV1_Req_v1.FinalMsgId();
        requestBean.NQreplaceRecipientsAcrossAllAcntsV1.nbsmsgi.finalMsgId.finalMsgClass = '';
        requestBean.NQreplaceRecipientsAcrossAllAcntsV1.nbsmsgi.finalMsgId.finalMsgCode = '';
        requestBean.NQreplaceRecipientsAcrossAllAcntsV1.nqp096i = new nQreplaceRecipientsV1_Req_v1.Nqp096i();
        requestBean.NQreplaceRecipientsAcrossAllAcntsV1.nqp096i.registeringSite = registrationSite;
        requestBean.NQreplaceRecipientsAcrossAllAcntsV1.nqp096i.cif = clientCode;
        requestBean.NQreplaceRecipientsAcrossAllAcntsV1.nqp096i.recipNm = recipNm;
        requestBean.NQreplaceRecipientsAcrossAllAcntsV1.nqp096i.pnsRecipientId = '1';
        requestBean.NQreplaceRecipientsAcrossAllAcntsV1.nqp096i.contactPref = contactPref;
        requestBean.NQreplaceRecipientsAcrossAllAcntsV1.nqp096i.lng = language;
        requestBean.NQreplaceRecipientsAcrossAllAcntsV1.nqp096i.email = email;
        requestBean.NQreplaceRecipientsAcrossAllAcntsV1.nqp096i.cellPhone = cellphone;
        return requestBean;
    }
    
    public static nQreplaceRecipientsV1_Resp_v1 mapResponseFields(HttpResponse responseP) {
        nQreplaceRecipientsV1_Resp_v1 responseBeanContent;
        
        try {
            nQreplaceRecipientsV1_Resp_v1 responseBean = new nQreplaceRecipientsV1_Resp_v1();
            
            responseBeanContent = (nQreplaceRecipientsV1_Resp_v1)responseBean.deserialize(responseP.getBody(), nQreplaceRecipientsV1_Resp_v1.class);
            
            responseBeanContent.status = responseP.getStatus();
            responseBeanContent.statusCode = responseP.getStatusCode();
           
        } catch (Exception e) {
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            responseBeanContent = mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, StringConstants.Sevice500InternalErrorMessage);
            System.debug(message);
        }

        System.debug('NQreplaceRecipientsAcrossAllAcntsV1 Response bean: ' + responseBeanContent);
        return responseBeanContent;
    }
     
   
    public static nQreplaceRecipientsV1_Resp_v1 mapFailedResponseFields(Integer statusCodeP, String statusP, String messageP) {
        nQreplaceRecipientsV1_Resp_v1 responseBean = new nQreplaceRecipientsV1_Resp_v1();
        responseBean.status = statusP;
        responseBean.statusCode = statusCodeP;
        responseBean.message = messageP;

        System.debug('NQreplaceRecipientsAcrossAllAcntsV1 Failed Response bean: ' + responseBean);
        return responseBean;
    }
}