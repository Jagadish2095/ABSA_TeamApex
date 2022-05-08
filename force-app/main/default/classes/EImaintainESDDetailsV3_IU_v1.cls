/*
* Integration utility for EImaintainESDDetailsV3 Service
* @author Muvhuso Nekhubvi
* @created 2020/04/07
*/
public class EImaintainESDDetailsV3_IU_v1 {
	
    public static EImaintainESDDetailsV3_Req_IB_v1 mapRequestFields(String request , String site , String teller, String accountNumber, String product , String email) {
		
        EImaintainESDDetailsV3_Req_IB_v1 requestBean = new EImaintainESDDetailsV3_Req_IB_v1();
        
        EImaintainESDDetailsV3_Req_IB_v1.EImaintainESDDetailsV3 eImaintainESDDetailsV3 = new EImaintainESDDetailsV3_Req_IB_v1.EImaintainESDDetailsV3();

        EImaintainESDDetailsV3_Req_IB_v1.Nbsapdpi nbsapdpi = new EImaintainESDDetailsV3_Req_IB_v1.Nbsapdpi();
        nbsapdpi.channel = 'BDP';
        nbsapdpi.application = 'BDP';
        nbsapdpi.trace = 'Y';
        
        EImaintainESDDetailsV3_Req_IB_v1.Nbsmsgi nbsmsgi = new EImaintainESDDetailsV3_Req_IB_v1.Nbsmsgi();
        EImaintainESDDetailsV3_Req_IB_v1.FinalMsgId finalMsgId = new EImaintainESDDetailsV3_Req_IB_v1.FinalMsgId();
        finalMsgId.finalMsgClass = '';
        finalMsgId.finalMsgCode = '';
        nbsmsgi.msgLanguage = 'E';
        nbsmsgi.msgTarget = 'STD';
        nbsmsgi.finalMsgId = finalMsgId;
        
        EImaintainESDDetailsV3_Req_IB_v1.Eip103i eip103i = new EImaintainESDDetailsV3_Req_IB_v1.Eip103i();
        
        List<EImaintainESDDetailsV3_Req_IB_v1.Entry> entryList = new List<EImaintainESDDetailsV3_Req_IB_v1.Entry>();
        
        EImaintainESDDetailsV3_Req_IB_v1.Entry entry = new EImaintainESDDetailsV3_Req_IB_v1.Entry();
        
        entry.wm = 'N';
        entry.email = email;
        entryList.add(entry); 

        eip103i.request = request;
        eip103i.ichannel = 'B';
        eip103i.site = site;
        eip103i.teller = teller;
        eip103i.acn = accountNumber;//'4051212002';
        eip103i.product = product;
        eip103i.prodCode = '0';
        eip103i.eCount = '1';
        eip103i.marketerCodeInit = '0';
        eip103i.marketerCodeAmend = '0';
        eip103i.entry = entryList;
        eip103i.prefInd = '';
        
        eImaintainESDDetailsV3.nbsapdpi = nbsapdpi;
        eImaintainESDDetailsV3.nbsmsgi = nbsmsgi;
        eImaintainESDDetailsV3.eip103i = eip103i;
        requestBean.EImaintainESDDetailsV3 = eImaintainESDDetailsV3;
        
        return requestBean;
    }

 
    public static EImaintainESDDetailsV3_Resp_IB_v1 mapResponseFields(HttpResponse responseP) {
        EImaintainESDDetailsV3_Resp_IB_v1 responseBeanContent;
        
        try {
            EImaintainESDDetailsV3_Resp_IB_v1 responseBean = new EImaintainESDDetailsV3_Resp_IB_v1();
            
            responseBeanContent = (EImaintainESDDetailsV3_Resp_IB_v1)responseBean.deserialize(responseP.getBody(), EImaintainESDDetailsV3_Resp_IB_v1.class);
            
            responseBeanContent.status = responseP.getStatus();
            responseBeanContent.statusCode = responseP.getStatusCode();
            //responseBeanContent.message = '';
        } catch (Exception e) {
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            responseBeanContent = mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, StringConstants.Sevice500InternalErrorMessage);
            System.debug(message);
        }

        System.debug('EImaintainESDDetailsV3 Response bean: ' + responseBeanContent);
        return responseBeanContent;
    }
     
   
    public static EImaintainESDDetailsV3_Resp_IB_v1 mapFailedResponseFields(Integer statusCodeP, String statusP, String messageP) {
        EImaintainESDDetailsV3_Resp_IB_v1 responseBean = new EImaintainESDDetailsV3_Resp_IB_v1();
        responseBean.status = statusP;
        responseBean.statusCode = statusCodeP;
        responseBean.message = messageP;

        System.debug('EImaintainESDDetailsV3 Failed Response bean: ' + responseBean);
        return responseBean;
    }
 
}