/*
* Integration Utility Bean for MBupdateInstructionV1 Service
* @author Rudolf Niehaus
* @created 2020-03-20
*/

public class MBupdateInstructionV1_IU_v1 {
    
    /* Creates a request bean
* @param: accountNumber
* @param: siteCode
* @param: maxRetrieve
* @return: MBupdateInstructionV1_Req_IB_v1 bean object
*/
    public static MBupdateInstructionV1_Req_IB_v1 mapRequestFields(String cif, String instrNo, String beneficiaryName, 
                                                                    String srcAccNumber,String srcAccType, String srcBranchCode, String srcRef, 
                                                                    String trgAccNumber,String trgAccType, String trgBranchCode,String trgRef,
                                                                    String siteCode, String teller, String tieb) { 
        
        MBupdateInstructionV1_Req_IB_v1 requestBean = new MBupdateInstructionV1_Req_IB_v1();
        requestBean.MBupdateInstructionV1 = new MBupdateInstructionV1_Req_IB_v1.MBupdateInstructionV1();
        requestBean.MBupdateInstructionV1.nbsapdpi = new MBupdateInstructionV1_Req_IB_v1.Nbsapdpi();
        requestBean.MBupdateInstructionV1.nbsmsgi = new MBupdateInstructionV1_Req_IB_v1.Nbsmsgi();
        requestBean.MBupdateInstructionV1.mbp300i = new MBupdateInstructionV1_Req_IB_v1.Mbp300i();
        requestBean.MBupdateInstructionV1.nbsmsgi.finalMsgId = new MBupdateInstructionV1_Req_IB_v1.FinalMsgId();
                                                                        
        DateTime todaysDate = System.now();
        String formattedDate = todaysDate.format('YYYYMMdd');
        
        requestBean.MBupdateInstructionV1.nbsapdpi.channel = 'SALESFOR';
        requestBean.MBupdateInstructionV1.nbsapdpi.application = 'SALESFOR';
        requestBean.MBupdateInstructionV1.nbsapdpi.trace = 'Y';

        requestBean.MBupdateInstructionV1.nbsmsgi.msgLanguage = 'E';
        requestBean.MBupdateInstructionV1.nbsmsgi.msgTarget = 'STD';
        requestBean.MBupdateInstructionV1.nbsmsgi.finalMsgId.finalMsgClass = '';
        requestBean.MBupdateInstructionV1.nbsmsgi.finalMsgId.finalMsgCode = '';
        
        requestBean.MBupdateInstructionV1.mbp300i.channel = 'SALESFOR';
		requestBean.MBupdateInstructionV1.mbp300i.maxRetrieve = '1';
		requestBean.MBupdateInstructionV1.mbp300i.confirmInd = 'C';
		requestBean.MBupdateInstructionV1.mbp300i.updateLevel = 'F';
        requestBean.MBupdateInstructionV1.mbp300i.ivrCustNo = '0';
        requestBean.MBupdateInstructionV1.mbp300i.tieb = tieb;
        requestBean.MBupdateInstructionV1.mbp300i.instrType = 'VP';
        requestBean.MBupdateInstructionV1.mbp300i.multiNo = '0';
        requestBean.MBupdateInstructionV1.mbp300i.instrStatus = 'CURRENT';
        requestBean.MBupdateInstructionV1.mbp300i.actDate = formattedDate;
        requestBean.MBupdateInstructionV1.mbp300i.startDate = formattedDate;
        requestBean.MBupdateInstructionV1.mbp300i.lastMaintFunc = '';
		requestBean.MBupdateInstructionV1.mbp300i.lastMaintDate = '0';
		requestBean.MBupdateInstructionV1.mbp300i.lastMaintTime = '0';                                                                                
        
		requestBean.MBupdateInstructionV1.mbp300i.cifKey = cif;
		requestBean.MBupdateInstructionV1.mbp300i.instrNo = instrNo;
		requestBean.MBupdateInstructionV1.mbp300i.instrRefName = beneficiaryName;
		requestBean.MBupdateInstructionV1.mbp300i.srcAcc = srcAccNumber;
		requestBean.MBupdateInstructionV1.mbp300i.srcAccType = srcAccType;
        requestBean.MBupdateInstructionV1.mbp300i.srcClrCode = srcBranchCode;
		requestBean.MBupdateInstructionV1.mbp300i.srcStmtRef = srcRef;
		requestBean.MBupdateInstructionV1.mbp300i.trgAcc = trgAccNumber;
		requestBean.MBupdateInstructionV1.mbp300i.trgAccType = trgAccType;
        requestBean.MBupdateInstructionV1.mbp300i.trgClrCode = trgBranchCode;                                                                
		requestBean.MBupdateInstructionV1.mbp300i.trgStmtRef = trgRef;
		requestBean.MBupdateInstructionV1.mbp300i.lastMaintBrnch = siteCode;
		requestBean.MBupdateInstructionV1.mbp300i.lastMaintTell = teller;
        
        System.debug('MBupdateInstructionV1 Request Bean: ' + requestBean);

        return requestBean;
    }
    
    /* Creates a request bean
	* @param: accountNumber
	* @param: siteCode
	* @param: maxRetrieve
	* @return: MBupdateInstructionV1_Req_IB_v1 bean object
	*/
    public static MBupdateInstructionV1_Req_IB_v1 mapRequest(String cif, String instrNo ,String amount, String instrRefName, 
                                                                    String srcAccNumber,String srcAccType, String srcBranchCode, String srcRef, 
                                                                    String trgAccNumber,String trgAccType, String trgBranchCode,String trgRef,
                                                                    String siteCode, String teller,String actDate) {
                                                                        
        MBupdateInstructionV1_Req_IB_v1 requestBean = new MBupdateInstructionV1_Req_IB_v1();
        requestBean.MBupdateInstructionV1 = new MBupdateInstructionV1_Req_IB_v1.MBupdateInstructionV1();
        requestBean.MBupdateInstructionV1.nbsapdpi = new MBupdateInstructionV1_Req_IB_v1.Nbsapdpi();
        requestBean.MBupdateInstructionV1.nbsmsgi = new MBupdateInstructionV1_Req_IB_v1.Nbsmsgi();
        requestBean.MBupdateInstructionV1.mbp300i = new MBupdateInstructionV1_Req_IB_v1.Mbp300i();
        requestBean.MBupdateInstructionV1.nbsmsgi.finalMsgId = new MBupdateInstructionV1_Req_IB_v1.FinalMsgId();

        
        requestBean.MBupdateInstructionV1.nbsapdpi.channel = 'SALESFOR';
        requestBean.MBupdateInstructionV1.nbsapdpi.application = 'SALESFOR';
        requestBean.MBupdateInstructionV1.nbsapdpi.trace = 'Y';

        requestBean.MBupdateInstructionV1.nbsmsgi.msgLanguage = 'E';
        requestBean.MBupdateInstructionV1.nbsmsgi.msgTarget = 'STD';
        requestBean.MBupdateInstructionV1.nbsmsgi.finalMsgId.finalMsgClass = '';
        requestBean.MBupdateInstructionV1.nbsmsgi.finalMsgId.finalMsgCode = '';

        requestBean.MBupdateInstructionV1.mbp300i.channel = 'SALESFOR';
		requestBean.MBupdateInstructionV1.mbp300i.maxRetrieve = '1';
		requestBean.MBupdateInstructionV1.mbp300i.confirmInd = 'C';
		requestBean.MBupdateInstructionV1.mbp300i.updateLevel = 'F';
        requestBean.MBupdateInstructionV1.mbp300i.instrType = 'OOP';
        requestBean.MBupdateInstructionV1.mbp300i.instrStatus = 'CURRENT';
        requestBean.MBupdateInstructionV1.mbp300i.actDate = actDate;
        requestBean.MBupdateInstructionV1.mbp300i.startDate = actDate;                                                                              
        requestBean.MBupdateInstructionV1.mbp300i.amount = amount; 
                                                                        
		requestBean.MBupdateInstructionV1.mbp300i.cifKey = cif;
		requestBean.MBupdateInstructionV1.mbp300i.instrNo = instrNo;
		requestBean.MBupdateInstructionV1.mbp300i.instrRefName = instrRefName;
		requestBean.MBupdateInstructionV1.mbp300i.srcAcc = srcAccNumber;
		requestBean.MBupdateInstructionV1.mbp300i.srcAccType = srcAccType;
        requestBean.MBupdateInstructionV1.mbp300i.srcClrCode = srcBranchCode;
		requestBean.MBupdateInstructionV1.mbp300i.srcStmtRef = srcRef;
		requestBean.MBupdateInstructionV1.mbp300i.trgAcc = trgAccNumber;
		requestBean.MBupdateInstructionV1.mbp300i.trgAccType = trgAccType;
        requestBean.MBupdateInstructionV1.mbp300i.trgClrCode = trgBranchCode;                                                                
		requestBean.MBupdateInstructionV1.mbp300i.trgStmtRef = trgRef;
		requestBean.MBupdateInstructionV1.mbp300i.lastMaintBrnch = siteCode;
		requestBean.MBupdateInstructionV1.mbp300i.lastMaintTell = teller;
       
        System.debug('MBupdateInstructionV1 Request Bean: ' + requestBean);

        return requestBean;
    }
    
   public static MBupdateInstructionV1_Req_IB_v1 mapRequestFieldsIVR(String beneficiaryName,String trgAccNumber,String trgAccType, 
                                                                     String trgBranchCode,String ivrCustNo,String cif,String srcAcc,String tieb,
                                                                     String instrNo,String srcAccType,String srcStmtRef, String trgStmtRef) {
        List<User> currentUser = [SELECT Id,SiteCode__c, Teller_Operator_Code__c,Supervisor__c FROM USER WHERE Id =: Userinfo.getUserId() limit 1]; 
                                                                         
        MBupdateInstructionV1_Req_IB_v1 requestBean = new MBupdateInstructionV1_Req_IB_v1();
        requestBean.MBupdateInstructionV1 = new MBupdateInstructionV1_Req_IB_v1.MBupdateInstructionV1();
        requestBean.MBupdateInstructionV1.nbsapdpi = new MBupdateInstructionV1_Req_IB_v1.Nbsapdpi();
        requestBean.MBupdateInstructionV1.nbsmsgi = new MBupdateInstructionV1_Req_IB_v1.Nbsmsgi();
        requestBean.MBupdateInstructionV1.mbp300i = new MBupdateInstructionV1_Req_IB_v1.Mbp300i();
        requestBean.MBupdateInstructionV1.nbsmsgi.finalMsgId = new MBupdateInstructionV1_Req_IB_v1.FinalMsgId();
                                                                        
        DateTime todaysDate = System.now();
        String formattedDate = todaysDate.format('YYYYMMdd');
        
        requestBean.MBupdateInstructionV1.nbsapdpi.channel = 'SALESFOR';
        requestBean.MBupdateInstructionV1.nbsapdpi.application = 'SALESFOR';
        requestBean.MBupdateInstructionV1.nbsapdpi.trace = 'Y';

        requestBean.MBupdateInstructionV1.nbsmsgi.msgLanguage = 'E';
        requestBean.MBupdateInstructionV1.nbsmsgi.msgTarget = 'STD';
        requestBean.MBupdateInstructionV1.nbsmsgi.finalMsgId.finalMsgClass = '';
        requestBean.MBupdateInstructionV1.nbsmsgi.finalMsgId.finalMsgCode = '';
        
        requestBean.MBupdateInstructionV1.mbp300i.channel = 'SALESFOR';
		requestBean.MBupdateInstructionV1.mbp300i.maxRetrieve = '1';
		requestBean.MBupdateInstructionV1.mbp300i.confirmInd = 'C';
		requestBean.MBupdateInstructionV1.mbp300i.updateLevel = 'F';
        requestBean.MBupdateInstructionV1.mbp300i.ivrCustNo = '';
        requestBean.MBupdateInstructionV1.mbp300i.tieb = tieb;
        requestBean.MBupdateInstructionV1.mbp300i.instrType = 'VP';
        requestBean.MBupdateInstructionV1.mbp300i.multiNo = '0';
        requestBean.MBupdateInstructionV1.mbp300i.instrStatus = 'CURRENT';
        requestBean.MBupdateInstructionV1.mbp300i.actDate = formattedDate;
        requestBean.MBupdateInstructionV1.mbp300i.startDate = formattedDate;
        requestBean.MBupdateInstructionV1.mbp300i.lastMaintFunc = '';
		requestBean.MBupdateInstructionV1.mbp300i.lastMaintDate = '0';
		requestBean.MBupdateInstructionV1.mbp300i.lastMaintTime = '0';                                                                                
        
		requestBean.MBupdateInstructionV1.mbp300i.cifKey = cif;
		requestBean.MBupdateInstructionV1.mbp300i.instrNo = instrNo;
        requestBean.MBupdateInstructionV1.mbp300i.ivrNominate = ivrCustNo;
		requestBean.MBupdateInstructionV1.mbp300i.instrRefName = beneficiaryName;
		requestBean.MBupdateInstructionV1.mbp300i.srcAcc = srcAcc;
		requestBean.MBupdateInstructionV1.mbp300i.srcAccType = srcAccType;
        requestBean.MBupdateInstructionV1.mbp300i.srcClrCode = '632005';
		requestBean.MBupdateInstructionV1.mbp300i.srcStmtRef = srcStmtRef;
		requestBean.MBupdateInstructionV1.mbp300i.trgAcc = trgAccNumber;
		requestBean.MBupdateInstructionV1.mbp300i.trgAccType = trgAccType;
        requestBean.MBupdateInstructionV1.mbp300i.trgClrCode = trgBranchCode;                                                                
		requestBean.MBupdateInstructionV1.mbp300i.trgStmtRef = trgStmtRef;
		requestBean.MBupdateInstructionV1.mbp300i.lastMaintBrnch = currentUser[0].SiteCode__c;
		requestBean.MBupdateInstructionV1.mbp300i.lastMaintTell = currentUser[0].Teller_Operator_Code__c;
        
        System.debug('MBupdateInstructionV1 Request Bean: ' + requestBean);

        return requestBean;
    }
    
    
    /* Creates a bean from the response
* @param: HTTP Response
* @return: MBupdateInstructionV1_Resp_IB_v1 bean object
*/
    public static MBupdateInstructionV1_Resp_IB_v1 mapResponseFields(HttpResponse responseP) {
        MBupdateInstructionV1_Resp_IB_v1 responseBeanContent;
        
        try {
            MBupdateInstructionV1_Resp_IB_v1 responseBean = new MBupdateInstructionV1_Resp_IB_v1();
            responseBeanContent = (MBupdateInstructionV1_Resp_IB_v1)responseBean.deserialize(responseP.getBody(), MBupdateInstructionV1_Resp_IB_v1.class);
            
            responseBeanContent.status = responseP.getStatus();
            responseBeanContent.statusCode = responseP.getStatusCode();
            //responseBeanContent.message = '';
        } catch (Exception e) {
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            responseBeanContent = mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, StringConstants.Sevice500InternalErrorMessage);
            System.debug(message);
        }
        
        System.debug('MBupdateInstructionV1 Response bean: ' + responseBeanContent);
        return responseBeanContent;
    }
    
    /* Creates a custom bean with the parameters mapped to their respective fields (Used for creating failed response beans)
* @param: Status Code
* @param: Status
* @param: message
* @return: MBupdateInstructionV1_Resp_IB_v1 bean object
* */
    
    public static MBupdateInstructionV1_Resp_IB_v1 mapFailedResponseFields(Integer statusCodeP, String statusP, String messageP) {
        MBupdateInstructionV1_Resp_IB_v1 responseBean = new MBupdateInstructionV1_Resp_IB_v1();
        responseBean.status = statusP;
        responseBean.statusCode = statusCodeP;
        responseBean.message = messageP;
        
        System.debug('MBupdateInstructionV1 Failed Response bean: ' + responseBean);
        return responseBean;
    }
}