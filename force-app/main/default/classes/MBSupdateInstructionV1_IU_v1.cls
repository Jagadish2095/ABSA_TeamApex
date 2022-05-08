/*
* Integration Utility Bean for MBupdateInstructionV1 Service
* @author Rudolf Niehaus
* @created 2020-05-16
*/

public class MBSupdateInstructionV1_IU_v1 {
    
    /* Creates a request bean
    * @param: accountNumber
    * @param: siteCode
    * @param: maxRetrieve
    * @return: MBSupdateInstructionV1_Req_IB_v1 bean object
    */
    public static MBSupdateInstructionV1_Req_IB_v1 mapRequestFields(String cif, String instrNo, String beneficiaryName, 
                                                                    String trigDate, String endDate, String payDay, String freq, String amount,
                                                                    String srcAccNumber,String srcAccType, String srcBranchCode, String srcRef, 
                                                                    String trgAccNumber,String trgAccType, String trgBranchCode,String trgRef,
                                                                    String siteCode, String teller) {
        
        MBSupdateInstructionV1_Req_IB_v1 requestBean = new MBSupdateInstructionV1_Req_IB_v1();
        requestBean.MBupdateInstructionV1 = new MBSupdateInstructionV1_Req_IB_v1.MBupdateInstructionV1();
        requestBean.MBupdateInstructionV1.nbsapdpi = new MBSupdateInstructionV1_Req_IB_v1.Nbsapdpi();
        requestBean.MBupdateInstructionV1.nbsmsgi = new MBSupdateInstructionV1_Req_IB_v1.Nbsmsgi();
        requestBean.MBupdateInstructionV1.mbp300i = new MBSupdateInstructionV1_Req_IB_v1.Mbp300i();
        requestBean.MBupdateInstructionV1.nbsmsgi.finalMsgId = new MBSupdateInstructionV1_Req_IB_v1.FinalMsgId();
                                                                        
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
        requestBean.MBupdateInstructionV1.mbp300i.instrType = 'SO';
		requestBean.MBupdateInstructionV1.mbp300i.actDate = trigDate;
		requestBean.MBupdateInstructionV1.mbp300i.startDate = trigDate;                                                                     
        
		requestBean.MBupdateInstructionV1.mbp300i.cifKey = cif;
		requestBean.MBupdateInstructionV1.mbp300i.instrNo = instrNo;
        requestBean.MBupdateInstructionV1.mbp300i.instrRefName = beneficiaryName;
        requestBean.MBupdateInstructionV1.mbp300i.trigDate = trigDate;
        requestBean.MBupdateInstructionV1.mbp300i.endDate = endDate;
        requestBean.MBupdateInstructionV1.mbp300i.payDay = payDay;
        requestBean.MBupdateInstructionV1.mbp300i.freq = freq;
		requestBean.MBupdateInstructionV1.mbp300i.amount = amount;
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
    

        //HARDCODE FOR TESTING
        /**
        requestBean.MBupdateInstructionV1.mbp300i.actDate = '20200601';
		requestBean.MBupdateInstructionV1.mbp300i.startDate = '20200601';                                                                     
        
		requestBean.MBupdateInstructionV1.mbp300i.cifKey = 'ZUMAD  001';
		requestBean.MBupdateInstructionV1.mbp300i.instrNo = '3';
        requestBean.MBupdateInstructionV1.mbp300i.instrRefName = '2021';
        requestBean.MBupdateInstructionV1.mbp300i.trigDate = '20200601';
        requestBean.MBupdateInstructionV1.mbp300i.endDate = '20200706';
        requestBean.MBupdateInstructionV1.mbp300i.payDay = '1';
        requestBean.MBupdateInstructionV1.mbp300i.freq = '1Y';
		requestBean.MBupdateInstructionV1.mbp300i.amount = '199';
		requestBean.MBupdateInstructionV1.mbp300i.srcAcc = '4048017641';
		requestBean.MBupdateInstructionV1.mbp300i.srcAccType = '02';
        requestBean.MBupdateInstructionV1.mbp300i.srcClrCode = '632005';
		requestBean.MBupdateInstructionV1.mbp300i.srcStmtRef = '2021';
		requestBean.MBupdateInstructionV1.mbp300i.trgAcc = '62001847237';
		requestBean.MBupdateInstructionV1.mbp300i.trgAccType = '02';
        requestBean.MBupdateInstructionV1.mbp300i.trgClrCode = '250655';                                                                
		requestBean.MBupdateInstructionV1.mbp300i.trgStmtRef = '2021';
		requestBean.MBupdateInstructionV1.mbp300i.lastMaintBrnch = '8089';
        requestBean.MBupdateInstructionV1.mbp300i.lastMaintTell = '11332';                                                                    
        **/

        return requestBean;
    }
    
    /* Creates a bean from the response
* @param: HTTP Response
* @return: MBSupdateInstructionV1_Resp_IB_v1 bean object
*/
    public static MBSupdateInstructionV1_Resp_IB_v1 mapResponseFields(HttpResponse responseP) {
        MBSupdateInstructionV1_Resp_IB_v1 responseBeanContent;
        
        try {
            MBSupdateInstructionV1_Resp_IB_v1 responseBean = new MBSupdateInstructionV1_Resp_IB_v1();
            responseBeanContent = (MBSupdateInstructionV1_Resp_IB_v1)responseBean.deserialize(responseP.getBody(), MBSupdateInstructionV1_Resp_IB_v1.class);
            
            responseBeanContent.status = responseP.getStatus();
            responseBeanContent.statusCode = responseP.getStatusCode();
            //responseBeanContent.message = '';
        } catch (Exception e) {
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            responseBeanContent = mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, StringConstants.Sevice500InternalErrorMessage);
            System.debug(message);
        }
        
        return responseBeanContent;
    }
    
    /* Creates a custom bean with the parameters mapped to their respective fields (Used for creating failed response beans)
* @param: Status Code
* @param: Status
* @param: message
* @return: MBSupdateInstructionV1_Resp_IB_v1 bean object
* */
    
    public static MBSupdateInstructionV1_Resp_IB_v1 mapFailedResponseFields(Integer statusCodeP, String statusP, String messageP) {
        MBSupdateInstructionV1_Resp_IB_v1 responseBean = new MBSupdateInstructionV1_Resp_IB_v1();
        responseBean.status = statusP;
        responseBean.statusCode = statusCodeP;
        responseBean.message = messageP;
        
        return responseBean;
    }
}