/*
* Integration utility for NHenquiryPauseCardV1 Service
* @author Muvhuso Nekhubvi
* @created 2020/05/23
*/
public class nHenquiryPauseCardV1_IU_v1 {
    public static nHenquiryPauseCardV1_Req_IB_v1 mapRequestFields(String accessNumber,String language , String action , String cardNbr) {
    	
        nHenquiryPauseCardV1_Req_IB_v1 requestBean = new nHenquiryPauseCardV1_Req_IB_v1();
        requestBean.NHenquiryPauseCardV1 = new nHenquiryPauseCardV1_Req_IB_v1.NHenquiryPauseCardV1();
        requestBean.NHenquiryPauseCardV1.nbsapdpi = new nHenquiryPauseCardV1_Req_IB_v1.Nbsapdpi();
        requestBean.NHenquiryPauseCardV1.nbsapdpi.application = 'BDP';
        requestBean.NHenquiryPauseCardV1.nbsapdpi.channel = 'BDP';
        requestBean.NHenquiryPauseCardV1.nbsapdpi.trace = 'Y';
        
        requestBean.NHenquiryPauseCardV1.nhs142i = new nHenquiryPauseCardV1_Req_IB_v1.Nhs142i();
        requestBean.NHenquiryPauseCardV1.nhs142i.log = 'N';
        requestBean.NHenquiryPauseCardV1.nhs142i.authenticate = 'N';
        requestBean.NHenquiryPauseCardV1.nhs142i.accessNumber = accessNumber;
        requestBean.NHenquiryPauseCardV1.nhs142i.user = '1';
        requestBean.NHenquiryPauseCardV1.nhs142i.division = 'ABSA';
        requestBean.NHenquiryPauseCardV1.nhs142i.device = 'W';
        requestBean.NHenquiryPauseCardV1.nhs142i.origAddress = '0';
        requestBean.NHenquiryPauseCardV1.nhs142i.language = language;
        requestBean.NHenquiryPauseCardV1.nhs142i.action = action;
        requestBean.NHenquiryPauseCardV1.nhs142i.cardNbr = cardNbr;
        
        return requestBean;
    }
    
    public static nHenquiryPauseCardV1_Resp_IB_v1 mapResponseFields(HttpResponse responseP) {
        nHenquiryPauseCardV1_Resp_IB_v1 responseBeanContent;
        
        try {
            nHenquiryPauseCardV1_Resp_IB_v1 responseBean = new nHenquiryPauseCardV1_Resp_IB_v1();
            
            responseBeanContent = (nHenquiryPauseCardV1_Resp_IB_v1)responseBean.deserialize(responseP.getBody(), nHenquiryPauseCardV1_Resp_IB_v1.class);
            
            responseBeanContent.status = responseP.getStatus();
            responseBeanContent.statusCode = responseP.getStatusCode();
            //responseBeanContent.message = '';
        } catch (Exception e) {
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            responseBeanContent = mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, StringConstants.Sevice500InternalErrorMessage);
            System.debug(message);
        }

        System.debug('NHenquiryPauseCardV1 Response bean: ' + responseBeanContent);
        return responseBeanContent;
    }
     
   
    public static nHenquiryPauseCardV1_Resp_IB_v1 mapFailedResponseFields(Integer statusCodeP, String statusP, String messageP) {
        nHenquiryPauseCardV1_Resp_IB_v1 responseBean = new nHenquiryPauseCardV1_Resp_IB_v1();
        responseBean.status = statusP;
        responseBean.statusCode = statusCodeP;
        responseBean.message = messageP;

        System.debug('NHenquiryPauseCardV1 Failed Response bean: ' + responseBean);
        return responseBean;
    }

}