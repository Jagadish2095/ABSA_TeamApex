/*
* Integration Utility Bean for CIgetClientDetailsByNameV2 Service
* @author Rudolf Niehaus
* @created 2020-04-07
*/

public class CIgetClientDetailsByNameV2_IU_v1 { 
    
    /* Creates a request bean
    * @param: accountNumber
    * @param: siteCode
    * @param: maxRetrieve
    * @return: CIgetClientDetailsByNameV2_Req_IB_v1 bean object
    */
    public static CIgetClientDetailsByNameV2_Req_IB_v1 mapRequestFields(String cifSurname, String cifInitials, String clntGroup, 
                                                                    String clntGender, String clntBirthDate, String maxRecsToRtrv, 
                                                                    String startAfterSearchPos, String siteCode, String clntTitle) {
        
        CIgetClientDetailsByNameV2_Req_IB_v1 requestBean = new CIgetClientDetailsByNameV2_Req_IB_v1();
        requestBean.CIgetClientDetailsByNameV2 = new CIgetClientDetailsByNameV2_Req_IB_v1.CIgetClientDetailsByNameV2();
        requestBean.CIgetClientDetailsByNameV2.nbsapdpi = new CIgetClientDetailsByNameV2_Req_IB_v1.Nbsapdpi();
        requestBean.CIgetClientDetailsByNameV2.nbsmsgi = new CIgetClientDetailsByNameV2_Req_IB_v1.Nbsmsgi();
        requestBean.CIgetClientDetailsByNameV2.cip602i = new CIgetClientDetailsByNameV2_Req_IB_v1.Cip602i();
        requestBean.CIgetClientDetailsByNameV2.nbsmsgi.finalMsgId = new CIgetClientDetailsByNameV2_Req_IB_v1.FinalMsgId();
        
        requestBean.CIgetClientDetailsByNameV2.nbsapdpi.channel = 'BDP';
        requestBean.CIgetClientDetailsByNameV2.nbsapdpi.application = 'BDP';
        requestBean.CIgetClientDetailsByNameV2.nbsapdpi.trace = 'Y';

        requestBean.CIgetClientDetailsByNameV2.nbsmsgi.msgLanguage = 'E';
        requestBean.CIgetClientDetailsByNameV2.nbsmsgi.msgTarget = 'STD';
        requestBean.CIgetClientDetailsByNameV2.nbsmsgi.finalMsgId.finalMsgClass = '';
        requestBean.CIgetClientDetailsByNameV2.nbsmsgi.finalMsgId.finalMsgCode = '';
        
     
		requestBean.CIgetClientDetailsByNameV2.cip602i.cifSurname = cifSurname;
		requestBean.CIgetClientDetailsByNameV2.cip602i.cifInitials = cifInitials;
		requestBean.CIgetClientDetailsByNameV2.cip602i.clntGroup = clntGroup;
		requestBean.CIgetClientDetailsByNameV2.cip602i.clntGender = clntGender;
		requestBean.CIgetClientDetailsByNameV2.cip602i.clntBirthDate = clntBirthDate;
        requestBean.CIgetClientDetailsByNameV2.cip602i.maxRecsToRtrv = maxRecsToRtrv;
		requestBean.CIgetClientDetailsByNameV2.cip602i.startAfterSearchPos = startAfterSearchPos;
		requestBean.CIgetClientDetailsByNameV2.cip602i.siteCode = siteCode;
		requestBean.CIgetClientDetailsByNameV2.cip602i.clntTitle = clntTitle;

        
        System.debug('CIgetClientDetailsByNameV2 Request Bean: ' + requestBean);

        return requestBean;
    }
    
    /* Creates a bean from the response
    * @param: HTTP Response
    * @return: CIgetClientDetailsByNameV2_Resp_IB_v1 bean object
    */
    public static CIgetClientDetailsByNameV2_Resp_IB_v1 mapResponseFields(HttpResponse responseP) {
        CIgetClientDetailsByNameV2_Resp_IB_v1 responseBeanContent;
        
        try {
            CIgetClientDetailsByNameV2_Resp_IB_v1 responseBean = new CIgetClientDetailsByNameV2_Resp_IB_v1();
            responseBeanContent = (CIgetClientDetailsByNameV2_Resp_IB_v1)responseBean.deserialize(responseP.getBody(), CIgetClientDetailsByNameV2_Resp_IB_v1.class);
            
            responseBeanContent.status = responseP.getStatus();
            responseBeanContent.statusCode = responseP.getStatusCode();
            //responseBeanContent.message = '';
        } catch (Exception e) {
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            responseBeanContent = mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, StringConstants.Sevice500InternalErrorMessage);
            System.debug(message);
        }
        
        System.debug('CIgetClientDetailsByNameV2 Response bean: ' + responseBeanContent);
        return responseBeanContent;
    }
    
    /* Creates a custom bean with the parameters mapped to their respective fields (Used for creating failed response beans)
    * @param: Status Code
    * @param: Status
    * @param: message
    * @return: CIgetClientDetailsByNameV2_Resp_IB_v1 bean object
    * */
    
    public static CIgetClientDetailsByNameV2_Resp_IB_v1 mapFailedResponseFields(Integer statusCodeP, String statusP, String messageP) {
        CIgetClientDetailsByNameV2_Resp_IB_v1 responseBean = new CIgetClientDetailsByNameV2_Resp_IB_v1();
        responseBean.status = statusP;
        responseBean.statusCode = statusCodeP;
        responseBean.message = messageP;
        
        System.debug('CIgetClientDetailsByNameV2 Failed Response bean: ' + responseBean);
        return responseBean;
    }
}