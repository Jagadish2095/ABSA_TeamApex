public class GetBankClearanceCodes_IU_v1 {

    //Populates the bank clearance codes response bean from an http response
    public static GetBankClearanceCodes_Resp_IB_v1 mapResponseFields(HttpResponse respP){
        
        GetBankClearanceCodes_Resp_IB_v1 responseBean = (GetBankClearanceCodes_Resp_IB_v1)JSON.deserialize( respP.getBody(), GetBankClearanceCodes_Resp_IB_v1.class );
        responseBean.status = respP.getStatus();
        responseBean.statusCode = respP.getStatusCode();
        System.debug('Get Bank Clearance Codes Response Bean: ' + responseBean);
        return responseBean;
    }
    
    //Populates the bank clearance codes response bean as failed with the necessary data
    public static GetBankClearanceCodes_Resp_IB_v1 mapFailedResponseFields(Integer statusCodeP, String statusP, String messageP){
        
        GetBankClearanceCodes_Resp_IB_v1 bankClearanceCodesResponse = new GetBankClearanceCodes_Resp_IB_v1();
        bankClearanceCodesResponse.message = messageP;
        bankClearanceCodesResponse.status = statusP;
        bankClearanceCodesResponse.statusCode = statusCodeP;
        
        System.debug('Get Bank Clearance Codes Failed Response Bean: ' + bankClearanceCodesResponse);
        return bankClearanceCodesResponse;
    }
    
    //Populates the bank clearance codes request bean from the parameters passed
    public static GetBankClearanceCodes_Req_IB_v1 mapRequestFields(String channelP, String applicationP, String traceP, String msgLanguageP, String msgTargetP, String ichannelP, String instNameLstP, String clrCodeLstP){
        
        GetBankClearanceCodes_Req_IB_v1 bankClearanceCodesRequest = new GetBankClearanceCodes_Req_IB_v1();
        bankClearanceCodesRequest.channel = channelP;
        bankClearanceCodesRequest.application = applicationP;
        bankClearanceCodesRequest.trace = traceP;
        bankClearanceCodesRequest.msgLanguage = msgLanguageP;
        bankClearanceCodesRequest.msgTarget = msgTargetP;
        bankClearanceCodesRequest.ichannel = ichannelP;
        bankClearanceCodesRequest.instNameLst = instNameLstP;
        bankClearanceCodesRequest.clrCodeLst = clrCodeLstP;
        
        System.debug('Get Bank Clearance Codes Request Bean: ' + bankClearanceCodesRequest);
        return bankClearanceCodesRequest;
    }
}