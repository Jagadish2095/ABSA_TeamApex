/*
* Integration Utility Bean for CreateInstruction v2 Service
* @author Rudolf Niehaus
* @created 2020-05-16
*/
public class CreateInstruction_IU_v2 {

    public static CreateInstruction_Req_IB_v2 mapRequestFields(String accessAcc, String beneficiaryName,
                                                                String trigDate, String endDate, String payDay, String freq, String amount,
                                                                String srcAccNumber,String srcAccType, String srcBranchCode, String srcRef, 
                                                                String trgAccNumber,String trgAccType, String trgBranchCode,String trgRef,
                                                                String siteCode, String teller){
        
        CreateInstruction_Req_IB_v2 requestBean = new CreateInstruction_Req_IB_v2();

        DateTime todaysDate = System.now();
        String formattedDate = todaysDate.format('YYYYMMdd');
        
        /*** Constant Values **/
        requestBean.channel = 'SALESFOR';
        requestBean.function = 'CREATE';
        requestBean.maxRetrieve = '1';
        requestBean.confirmInd = 'C';
        requestBean.instrType = 'SO';
        requestBean.accessAcc = accessAcc;
        
        requestBean.actDate = trigDate;
        requestBean.startDate = trigDate;
        requestBean.instrRefName = beneficiaryName;
        requestBean.endDate = endDate;
        requestBean.freq = freq;
        requestBean.amount = amount;
        requestBean.srcAcc = srcAccNumber;
        requestBean.srcAccType = srcAccType;
        requestBean.srcClrCode = srcBranchCode;
        requestBean.srcStmtRef = srcRef;
        requestBean.trgAcc = trgAccNumber;
        requestBean.trgAccType = trgAccType;
        requestBean.trgClrCode = trgBranchCode;                                                                
        requestBean.trgStmtRef = trgRef;
        requestBean.payDay = payDay;
        requestBean.lastMaintBrnch = siteCode;
        requestBean.lastMaintTell = teller;
        
       return requestBean;
    }
    
    public static CreateInstruction_Resp_IB_v2 mapResponseFields(HttpResponse respP){
        
        System.debug('Create Instruction Response body: ' + respP.getBody());
        CreateInstruction_Resp_IB_v2 responseBean = (CreateInstruction_Resp_IB_v2)JSON.deserialize( respP.getBody(), CreateInstruction_Resp_IB_v2.class);
        responseBean.Status = respP.getStatus();
        responseBean.statusCode = respP.getStatusCode();
        
        System.debug('Create Instruction Response bean: ' + responseBean);
        return responseBean;
    }
    
    public static CreateInstruction_Resp_IB_v2 mapFailedResponseFields(String statusP, Integer statusCodeP, String messageP){
        
        CreateInstruction_Resp_IB_v2 responseBean = new CreateInstruction_Resp_IB_v2();
        responseBean.status = statusP;
        responseBean.statusCode = statusCodeP;
        responseBean.message = messageP;
        
        return responseBean;
    }
}