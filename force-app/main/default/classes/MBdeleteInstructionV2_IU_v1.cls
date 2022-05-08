/*
* Integration Utility Bean for MBdeleteInstructionV2 Service
* @author Rudolf Niehaus
* @created 2020-03-21
*/

public class MBdeleteInstructionV2_IU_v1 {
    
    /* Creates a request bean
* @param: accountNumber
* @param: siteCode
* @param: maxRetrieve
* @return: MBdeleteInstructionV2_Req_IB_v1 bean object
*/
    public static MBdeleteInstructionV2_Req_IB_v1 mapRequestFields(String cif, String instrNo, String siteCode, String teller, String tieb) {
        
        MBdeleteInstructionV2_Req_IB_v1 requestBean = new MBdeleteInstructionV2_Req_IB_v1();
        requestBean.MBdeleteInstructionV2 = new MBdeleteInstructionV2_Req_IB_v1.MBdeleteInstructionV2();
        requestBean.MBdeleteInstructionV2.nbsapdpi = new MBdeleteInstructionV2_Req_IB_v1.Nbsapdpi();
        requestBean.MBdeleteInstructionV2.nbsmsgi = new MBdeleteInstructionV2_Req_IB_v1.Nbsmsgi();
        requestBean.MBdeleteInstructionV2.mbs306i = new MBdeleteInstructionV2_Req_IB_v1.Mbs306i();
        requestBean.MBdeleteInstructionV2.nbsmsgi.finalMsgId = new MBdeleteInstructionV2_Req_IB_v1.FinalMsgId();
        
        requestBean.MBdeleteInstructionV2.nbsapdpi.channel = 'SALESFOR';
        requestBean.MBdeleteInstructionV2.nbsapdpi.application = 'SALESFOR';
        requestBean.MBdeleteInstructionV2.nbsapdpi.trace = 'Y';

        requestBean.MBdeleteInstructionV2.nbsmsgi.msgLanguage = 'E';
        requestBean.MBdeleteInstructionV2.nbsmsgi.msgTarget = 'STD';
        requestBean.MBdeleteInstructionV2.nbsmsgi.finalMsgId.finalMsgClass = '';
        requestBean.MBdeleteInstructionV2.nbsmsgi.finalMsgId.finalMsgCode = '';
        
        requestBean.MBdeleteInstructionV2.mbs306i.channel = 'SALESFOR';
        requestBean.MBdeleteInstructionV2.mbs306i.tieb = tieb;
        requestBean.MBdeleteInstructionV2.mbs306i.instrType = 'VP';
        requestBean.MBdeleteInstructionV2.mbs306i.multiNo = '0';
     
		requestBean.MBdeleteInstructionV2.mbs306i.cifKey = cif;
		requestBean.MBdeleteInstructionV2.mbs306i.instrNo = instrNo;
		requestBean.MBdeleteInstructionV2.mbs306i.lastMaintBrnch = siteCode;
		requestBean.MBdeleteInstructionV2.mbs306i.lastMaintTell = teller;
        
        System.debug('MBdeleteInstructionV2 Request Bean: ' + requestBean);

        return requestBean;
    }
    
    
        /* Creates a request bean
* @param: accountNumber
* @param: siteCode
* @param: maxRetrieve
* @return: MBdeleteInstructionV2_Req_IB_v1 bean object
*/
    public static MBdeleteInstructionV2_Req_IB_v1 mapRequestForPayment(String cif, String instrNo, String siteCode, String teller) {
        
        MBdeleteInstructionV2_Req_IB_v1 requestBean = new MBdeleteInstructionV2_Req_IB_v1();
        requestBean.MBdeleteInstructionV2 = new MBdeleteInstructionV2_Req_IB_v1.MBdeleteInstructionV2();
        requestBean.MBdeleteInstructionV2.nbsapdpi = new MBdeleteInstructionV2_Req_IB_v1.Nbsapdpi();
        requestBean.MBdeleteInstructionV2.nbsmsgi = new MBdeleteInstructionV2_Req_IB_v1.Nbsmsgi();
        requestBean.MBdeleteInstructionV2.mbs306i = new MBdeleteInstructionV2_Req_IB_v1.Mbs306i();
        requestBean.MBdeleteInstructionV2.nbsmsgi.finalMsgId = new MBdeleteInstructionV2_Req_IB_v1.FinalMsgId();
        
        requestBean.MBdeleteInstructionV2.nbsapdpi.channel = 'SALESFOR';
        requestBean.MBdeleteInstructionV2.nbsapdpi.application = 'SALESFOR';
        requestBean.MBdeleteInstructionV2.nbsapdpi.trace = 'Y';

        requestBean.MBdeleteInstructionV2.nbsmsgi.msgLanguage = 'E';
        requestBean.MBdeleteInstructionV2.nbsmsgi.msgTarget = 'STD';
        requestBean.MBdeleteInstructionV2.nbsmsgi.finalMsgId.finalMsgClass = '';
        requestBean.MBdeleteInstructionV2.nbsmsgi.finalMsgId.finalMsgCode = '';
        
        requestBean.MBdeleteInstructionV2.mbs306i.channel = 'SALESFOR';
        requestBean.MBdeleteInstructionV2.mbs306i.tieb = '0';
        requestBean.MBdeleteInstructionV2.mbs306i.instrType = 'OOP';
        requestBean.MBdeleteInstructionV2.mbs306i.multiNo = '0';
     
		requestBean.MBdeleteInstructionV2.mbs306i.cifKey = cif;
		requestBean.MBdeleteInstructionV2.mbs306i.instrNo = instrNo;
		requestBean.MBdeleteInstructionV2.mbs306i.lastMaintBrnch = siteCode;
		requestBean.MBdeleteInstructionV2.mbs306i.lastMaintTell = teller;
        
        System.debug('MBdeleteInstructionV2 Request Bean: ' + requestBean);

        return requestBean;
    }
    
    public static MBdeleteInstructionV2_Req_IB_v1 mapRequestFieldsIVR(String cif, String tieb, String instrNo) {
        
        List<User> currentUser = [SELECT Id,SiteCode__c, Teller_Operator_Code__c,Supervisor__c FROM USER WHERE Id =: Userinfo.getUserId() limit 1]; 
        
        MBdeleteInstructionV2_Req_IB_v1 requestBean = new MBdeleteInstructionV2_Req_IB_v1();
        requestBean.MBdeleteInstructionV2 = new MBdeleteInstructionV2_Req_IB_v1.MBdeleteInstructionV2();
        requestBean.MBdeleteInstructionV2.nbsapdpi = new MBdeleteInstructionV2_Req_IB_v1.Nbsapdpi();
        requestBean.MBdeleteInstructionV2.nbsmsgi = new MBdeleteInstructionV2_Req_IB_v1.Nbsmsgi();
        requestBean.MBdeleteInstructionV2.mbs306i = new MBdeleteInstructionV2_Req_IB_v1.Mbs306i();
        requestBean.MBdeleteInstructionV2.nbsmsgi.finalMsgId = new MBdeleteInstructionV2_Req_IB_v1.FinalMsgId();
        
        requestBean.MBdeleteInstructionV2.nbsapdpi.channel = 'SALESFOR';
        requestBean.MBdeleteInstructionV2.nbsapdpi.application = 'SALESFOR';
        requestBean.MBdeleteInstructionV2.nbsapdpi.trace = 'Y';

        requestBean.MBdeleteInstructionV2.nbsmsgi.msgLanguage = 'E';
        requestBean.MBdeleteInstructionV2.nbsmsgi.msgTarget = 'STD';
        requestBean.MBdeleteInstructionV2.nbsmsgi.finalMsgId.finalMsgClass = '';
        requestBean.MBdeleteInstructionV2.nbsmsgi.finalMsgId.finalMsgCode = '';
        
        requestBean.MBdeleteInstructionV2.mbs306i.channel = 'SALESFOR';
        requestBean.MBdeleteInstructionV2.mbs306i.tieb = tieb;
        requestBean.MBdeleteInstructionV2.mbs306i.instrType = 'VP';
        requestBean.MBdeleteInstructionV2.mbs306i.multiNo = '0';
     
		requestBean.MBdeleteInstructionV2.mbs306i.cifKey = cif;
		requestBean.MBdeleteInstructionV2.mbs306i.instrNo = instrNo;
		requestBean.MBdeleteInstructionV2.mbs306i.lastMaintBrnch = currentUser[0].SiteCode__c;
		requestBean.MBdeleteInstructionV2.mbs306i.lastMaintTell = currentUser[0].Teller_Operator_Code__c;
        
        System.debug('MBdeleteInstructionV2 Request Bean: ' + requestBean);

        return requestBean;
    }
    
        /* Creates a request bean
* @param: accountNumber
* @param: siteCode
* @param: maxRetrieve
* @return: MBdeleteInstructionV2_Req_IB_v1 bean object
*/
    public static MBdeleteInstructionV2_Req_IB_v1 mapRequestStopOrder(String cif, String instrNo, String siteCode, String teller) {
        
        MBdeleteInstructionV2_Req_IB_v1 requestBean = new MBdeleteInstructionV2_Req_IB_v1();
        requestBean.MBdeleteInstructionV2 = new MBdeleteInstructionV2_Req_IB_v1.MBdeleteInstructionV2();
        requestBean.MBdeleteInstructionV2.nbsapdpi = new MBdeleteInstructionV2_Req_IB_v1.Nbsapdpi();
        requestBean.MBdeleteInstructionV2.nbsmsgi = new MBdeleteInstructionV2_Req_IB_v1.Nbsmsgi();
        requestBean.MBdeleteInstructionV2.mbs306i = new MBdeleteInstructionV2_Req_IB_v1.Mbs306i();
        requestBean.MBdeleteInstructionV2.nbsmsgi.finalMsgId = new MBdeleteInstructionV2_Req_IB_v1.FinalMsgId();
        
        requestBean.MBdeleteInstructionV2.nbsapdpi.channel = 'SALESFOR';
        requestBean.MBdeleteInstructionV2.nbsapdpi.application = 'SALESFOR';
        requestBean.MBdeleteInstructionV2.nbsapdpi.trace = 'Y';

        requestBean.MBdeleteInstructionV2.nbsmsgi.msgLanguage = 'E';
        requestBean.MBdeleteInstructionV2.nbsmsgi.msgTarget = 'STD';
        requestBean.MBdeleteInstructionV2.nbsmsgi.finalMsgId.finalMsgClass = '';
        requestBean.MBdeleteInstructionV2.nbsmsgi.finalMsgId.finalMsgCode = '';
        
        requestBean.MBdeleteInstructionV2.mbs306i.channel = 'SALESFOR';
        requestBean.MBdeleteInstructionV2.mbs306i.tieb = '0';
        requestBean.MBdeleteInstructionV2.mbs306i.instrType = 'SO';
        requestBean.MBdeleteInstructionV2.mbs306i.multiNo = '0';
     
		requestBean.MBdeleteInstructionV2.mbs306i.cifKey = cif;
		requestBean.MBdeleteInstructionV2.mbs306i.instrNo = instrNo;
		requestBean.MBdeleteInstructionV2.mbs306i.lastMaintBrnch = siteCode;
		requestBean.MBdeleteInstructionV2.mbs306i.lastMaintTell = teller;
        
        System.debug('MBdeleteInstructionV2 Request Bean: ' + requestBean);

        return requestBean;
    }
    
 
    
    /* Creates a bean from the response
* @param: HTTP Response
* @return: MBdeleteInstructionV2_Resp_IB_v1 bean object
*/
    public static MBdeleteInstructionV2_Resp_IB_v1 mapResponseFields(HttpResponse responseP) {
        MBdeleteInstructionV2_Resp_IB_v1 responseBeanContent;
        
        try {
            MBdeleteInstructionV2_Resp_IB_v1 responseBean = new MBdeleteInstructionV2_Resp_IB_v1();
            responseBeanContent = (MBdeleteInstructionV2_Resp_IB_v1)responseBean.deserialize(responseP.getBody(), MBdeleteInstructionV2_Resp_IB_v1.class);
            
            responseBeanContent.status = responseP.getStatus();
            responseBeanContent.statusCode = responseP.getStatusCode();
            //responseBeanContent.message = '';
        } catch (Exception e) {
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            responseBeanContent = mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, StringConstants.Sevice500InternalErrorMessage);
            System.debug(message);
        }
        
        System.debug('MBdeleteInstructionV2 Response bean: ' + responseBeanContent);
        return responseBeanContent;
    }
    
    /* Creates a custom bean with the parameters mapped to their respective fields (Used for creating failed response beans)
* @param: Status Code
* @param: Status
* @param: message
* @return: MBdeleteInstructionV2_Resp_IB_v1 bean object
* */
    
    public static MBdeleteInstructionV2_Resp_IB_v1 mapFailedResponseFields(Integer statusCodeP, String statusP, String messageP) {
        MBdeleteInstructionV2_Resp_IB_v1 responseBean = new MBdeleteInstructionV2_Resp_IB_v1();
        responseBean.status = statusP;
        responseBean.statusCode = statusCodeP;
        responseBean.message = messageP;
        
        System.debug('MBdeleteInstructionV2 Failed Response bean: ' + responseBean);
        return responseBean;
    }
}