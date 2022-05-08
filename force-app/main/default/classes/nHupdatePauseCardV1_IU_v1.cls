/*
* Integration utility for NHupdatePauseCardV1 Service
* @author Muvhuso Nekhubvi
* @created 2020/05/23
*/
public class nHupdatePauseCardV1_IU_v1 {
    public static nHupdatePauseCardV1_Req_IB_v1 mapRequestFields(String accessNumber ,String tellerCode, String supervisor, String branchCode, String pauseHold,String iatmHold, String iposHold, String latmHold,String lposHold, String cnpHold, String digwHold, String pauseDate, String language , String action , String cardNbr) {
	    nHupdatePauseCardV1_Req_IB_v1 requestBean = new nHupdatePauseCardV1_Req_IB_v1();
		requestBean.NHupdatePauseCardV1 = new nHupdatePauseCardV1_Req_IB_v1.NHupdatePauseCardV1();
        
        requestBean.NHupdatePauseCardV1.nbsapdpi = new nHupdatePauseCardV1_Req_IB_v1.Nbsapdpi();
        requestBean.NHupdatePauseCardV1.nbsapdpi.application = 'BDP';
        requestBean.NHupdatePauseCardV1.nbsapdpi.channel = 'BDP';
        requestBean.NHupdatePauseCardV1.nbsapdpi.trace = 'Y';
        
        requestBean.NHupdatePauseCardV1.nhs141i = new nHupdatePauseCardV1_Req_IB_v1.Nhs141i();
        requestBean.NHupdatePauseCardV1.nhs141i.log = 'N';
        requestBean.NHupdatePauseCardV1.nhs141i.authenticate = 'N';
        requestBean.NHupdatePauseCardV1.nhs141i.accessNumber = accessNumber;
        requestBean.NHupdatePauseCardV1.nhs141i.user = '1';
        requestBean.NHupdatePauseCardV1.nhs141i.division = 'ABSA';
        requestBean.NHupdatePauseCardV1.nhs141i.device = 'W';
        requestBean.NHupdatePauseCardV1.nhs141i.origAddress = '0';
        requestBean.NHupdatePauseCardV1.nhs141i.language = language;
        requestBean.NHupdatePauseCardV1.nhs141i.action = action;
        requestBean.NHupdatePauseCardV1.nhs141i.cardNbr =  cardNbr;
        requestBean.NHupdatePauseCardV1.nhs141i.tellerCode = tellerCode; 
        requestBean.NHupdatePauseCardV1.nhs141i.workStation = '99';
        requestBean.NHupdatePauseCardV1.nhs141i.supervisor = supervisor;
        requestBean.NHupdatePauseCardV1.nhs141i.branchCode = branchCode;
        requestBean.NHupdatePauseCardV1.nhs141i.pauseHold = pauseHold;
        requestBean.NHupdatePauseCardV1.nhs141i.iatmHold = iatmHold;
        requestBean.NHupdatePauseCardV1.nhs141i.iposHold = iposHold;
     	requestBean.NHupdatePauseCardV1.nhs141i.latmHold = latmHold;
        requestBean.NHupdatePauseCardV1.nhs141i.lposHold = lposHold;
     	requestBean.NHupdatePauseCardV1.nhs141i.cnpHold = cnpHold;
     	requestBean.NHupdatePauseCardV1.nhs141i.digwHold = digwHold;
        requestBean.NHupdatePauseCardV1.nhs141i.pauseDate = pauseDate;
        return requestBean;
    }
    
    public static nHupdatePauseCardV1_Resp_IB_v1 mapResponseFields(HttpResponse responseP) {
        nHupdatePauseCardV1_Resp_IB_v1 responseBeanContent;
        
        try {
            nHupdatePauseCardV1_Resp_IB_v1 responseBean = new nHupdatePauseCardV1_Resp_IB_v1();
            
            responseBeanContent = (nHupdatePauseCardV1_Resp_IB_v1)responseBean.deserialize(responseP.getBody(), nHupdatePauseCardV1_Resp_IB_v1.class);
            
            responseBeanContent.status = responseP.getStatus();
            responseBeanContent.statusCode = responseP.getStatusCode();
            //responseBeanContent.message = '';
        } catch (Exception e) {
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            responseBeanContent = mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, StringConstants.Sevice500InternalErrorMessage);
            System.debug(message);
        }

        System.debug('NHupdatePauseCardV1 Response bean: ' + responseBeanContent);
        return responseBeanContent;
    }
     
   
    public static nHupdatePauseCardV1_Resp_IB_v1 mapFailedResponseFields(Integer statusCodeP, String statusP, String messageP) {
        nHupdatePauseCardV1_Resp_IB_v1 responseBean = new nHupdatePauseCardV1_Resp_IB_v1();
        responseBean.status = statusP;
        responseBean.statusCode = statusCodeP;
        responseBean.message = messageP;

        System.debug('NHupdatePauseCardV1 Failed Response bean: ' + responseBean);
        return responseBean;
    }
}