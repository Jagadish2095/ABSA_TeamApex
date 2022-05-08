public class YYY_DummyIntegrationTestController{
    
    public Id opportunityId {get;set;}
    public String stageName {get;set;}
    public String externalId {get;set;}
    public String salesMethod {get;set;}
    
    public Integer updateLeadStatusSiebel_statusCode {get;set;}
    public String updateLeadStatusSiebel_status {get;set;}
    public String updateLeadStatusSiebel_message {get;set;}
    
    public Integer getClientRiskProfile_statusCode {get;set;}
    public String getClientRiskProfile_status {get;set;}
    public Integer getClientRiskProfile_msgNo {get;set;}
    public String getClientRiskProfile_msg {get;set;}
    public String getClientRiskProfile_riskRating {get;set;}
    
    public String createOpportunityIdNumber {get;set;}
    public String createOpportunityResponse {get;set;}
    
    public Integer getBankClearanceCodes_statusCode {get;set;}
    public String getBankClearanceCodes_status {get;set;}
    public String getBankClearanceCodes_errorMessage {get;set;}
    public List<getBankClearanceCodes_Resp_IB_v1.cls_bankBranch> getBankClearanceCodes_message {get;set;}
    public String getBankClearanceCodes_channel {get;set;}
    public String getBankClearanceCodes_application {get;set;}
    public String getBankClearanceCodes_trace {get;set;}
    public String getBankClearanceCodes_msgLanguage {get;set;}
    public String getBankClearanceCodes_msgTarget {get;set;}
    public String getBankClearanceCodes_ichannel {get;set;}
    public String getBankClearanceCodes_instNameLst {get;set;}
    public String getBankClearanceCodes_clrCodeLst {get;set;}
    
    public Integer checkDigitVerification_statusCode {get;set;}
    public String checkDigitVerification_status {get;set;}
    public String checkDigitVerification_message {get;set;}
    public String checkDigitVerification_rc {get;set;}
    public String checkDigitVerification_accountExceptionInd {get;set;}
    public String checkDigitVerification_bankCode {get;set;}
    
    public String checkDigitVerification_accountNumber {get;set;}
    public String checkDigitVerification_branchCode {get;set;}
    public String checkDigitVerification_accountType {get;set;}
    public String checkDigitVerification_channel {get;set;}
    public String checkDigitVerification_application {get;set;}
    public String checkDigitVerification_msgLanguage {get;set;}
    public String checkDigitVerification_msgTarget {get;set;}
    public String checkDigitVerification_trace {get;set;}
    
    public YYY_DummyIntegrationTestController(ApexPages.StandardController stdController){
        initValues();
    }
    
    public YYY_DummyIntegrationTestController(){
        initValues();
    }
    
    public void initValues(){
        
        salesMethod = 'Estate Provider Plan';
        
        getBankClearanceCodes_Req_IB_v1 bankClearanceCodesRequestBean = new getBankClearanceCodes_Req_IB_v1();
        //bankClearanceCodesRequestBean.createDummyRequest();
        getBankClearanceCodes_channel = bankClearanceCodesRequestBean.channel;
        getBankClearanceCodes_application = bankClearanceCodesRequestBean.application;
        getBankClearanceCodes_trace = bankClearanceCodesRequestBean.trace;
        getBankClearanceCodes_msgLanguage = bankClearanceCodesRequestBean.msgLanguage;
        getBankClearanceCodes_msgTarget = bankClearanceCodesRequestBean.msgTarget;
        getBankClearanceCodes_ichannel = bankClearanceCodesRequestBean.ichannel;
        getBankClearanceCodes_instNameLst = bankClearanceCodesRequestBean.instNameLst;
        getBankClearanceCodes_clrCodeLst = bankClearanceCodesRequestBean.clrCodeLst;
        
        checkDigitVerification_Req_IB_v1 checkDigetVerificationRequest = new checkDigitVerification_Req_IB_v1();
        checkDigetVerificationRequest.createDummyRequest();
        checkDigitVerification_accountNumber = checkDigetVerificationRequest.accountNumber;
        checkDigitVerification_branchCode = checkDigetVerificationRequest.branchCode;
        checkDigitVerification_accountType = checkDigetVerificationRequest.accountType;
        checkDigitVerification_channel = checkDigetVerificationRequest.channel;
        checkDigitVerification_application = checkDigetVerificationRequest.application;
        checkDigitVerification_msgLanguage = checkDigetVerificationRequest.msgLanguage;
        checkDigitVerification_msgTarget = checkDigetVerificationRequest.msgTarget;
        checkDigitVerification_trace = checkDigetVerificationRequest.trace;
    }
    public void excecuteMakePostCalloutToSiebel(){
        
        try{
            UpdateLeadStatusSiebel_Resp_IB_v1 makePostCalloutToSiebelResponse = UpdateLeadStatusSiebel_IH_v1.updateLeadStatusSiebel(opportunityId, stageName, externalId, salesMethod, 'Closed');
            updateLeadStatusSiebel_statusCode = makePostCalloutToSiebelResponse.statusCode;
            updateLeadStatusSiebel_status = makePostCalloutToSiebelResponse.status;
            updateLeadStatusSiebel_message = makePostCalloutToSiebelResponse.description;
        }catch(Exception e){
            updateLeadStatusSiebel_statusCode = 500;
            updateLeadStatusSiebel_status = StringConstants.INTEGRATION_STATUS_FAILED;
            updateLeadStatusSiebel_message = e.getMessage() + '. ' + e.getStackTraceString();
        }
        
    }
    
    public void excecuteCreateOpportunities(){
        
        try{
            RestRequest rest_request = new RestRequest();				
            rest_request.addHeader('Content-Type', 'application/json');
            rest_request.addHeader('transactionId', 'testTransactionId');
            rest_request.addHeader('initiator', 'testInitiator');
            rest_request.addHeader('sender', 'testSender');
            rest_request.requestURI = '/services/apexrest/createOpportunity/v01/*';
            rest_request.httpMethod = 'POST';
            RestContext.request = rest_request;
            
            RestResponse resp = new RestResponse();
            RestContext.response = resp;
            
            CreateOpportunity_Req_IB_v1 beanInstance = new CreateOpportunity_Req_IB_v1();
            beanInstance.createDummyRequest();
            beanInstance.clientIdNumber = createOpportunityIdNumber;
            beanInstance.adviserBRID = 'CLOUD014';
            createOpportunityResponse = CreateOpportunity_ApiRest_v1.createOpportunity(beanInstance);
        }catch(Exception e){
            createOpportunityResponse = e.getMessage() + '. ' + e.getStackTraceString();
        }
        
    }
    
    /*public void getClientRiskProfile(){
        
        try{
            getRiskProfileClient_Resp_IB_v1 riskProfileBean = getRiskProfileClient_IH_v1.getRiskProfileClient(null, null);
            getClientRiskProfile_statusCode = riskProfileBean.statusCode;
            getClientRiskProfile_status = riskProfileBean.status;
            getClientRiskProfile_msgNo = riskProfileBean.WQriskProfileClientV7Response.msgNo;
			getClientRiskProfile_msg = riskProfileBean.WQriskProfileClientV7Response.msg;
			getClientRiskProfile_riskRating = riskProfileBean.WQriskProfileClientV7Response.riskRating;
        }catch(Exception e){
            getClientRiskProfile_statusCode = 500;
            getClientRiskProfile_status = StringConstants.INTEGRATION_STATUS_FAILED;
            getClientRiskProfile_msg = e.getMessage() + '. ' + e.getStackTraceString();
        }
        
    }*/
    
    public void getBankClearanceCodes(){
        
        try{
            getBankClearanceCodes_Resp_IB_v1 bankClearanceCodesBean = getBankClearanceCodes_IH_v1.getBankClearanceCodes(getBankClearanceCodes_channel, getBankClearanceCodes_application, getBankClearanceCodes_trace, getBankClearanceCodes_msgLanguage, getBankClearanceCodes_msgTarget, getBankClearanceCodes_ichannel, getBankClearanceCodes_instNameLst, getBankClearanceCodes_clrCodeLst);
            System.debug('bankClearanceCodesBean: ' + bankClearanceCodesBean);
            getBankClearanceCodes_statusCode = bankClearanceCodesBean.statusCode;
            getBankClearanceCodes_status = bankClearanceCodesBean.status;
            getBankClearanceCodes_message = bankClearanceCodesBean.bankBranchList; 
        }catch(Exception e){
            getBankClearanceCodes_errorMessage = e.getMessage() + '. ' + e.getStackTraceString();
            getBankClearanceCodes_statusCode = 500;
        }
        
    }
    
    public void checkDigitVerification(){
        
        try{
            /*checkDigitVerification_Resp_IB_v1 checkDigitVerificationBean = checkDigitVerification_IH_v1.checkDigitVerification(checkDigitVerification_accountNumber, checkDigitVerification_branchCode, checkDigitVerification_accountType, checkDigitVerification_channel, checkDigitVerification_application, checkDigitVerification_msgLanguage, checkDigitVerification_msgTarget, checkDigitVerification_trace);
            System.debug('checkDigitVerificationBean: ' + checkDigitVerificationBean);
            checkDigitVerification_statusCode = checkDigitVerificationBean.statusCode;
            checkDigitVerification_status = checkDigitVerificationBean.status;
            checkDigitVerification_rc = checkDigitVerificationBean.rc;
            checkDigitVerification_accountExceptionInd = checkDigitVerificationBean.accountExceptionInd;
            checkDigitVerification_bankCode = checkDigitVerificationBean.bankCode;*/
        }catch(Exception e){
            checkDigitVerification_message = e.getMessage() + '. ' + e.getStackTraceString();
            checkDigitVerification_statusCode = 500;
        }
        
    }
    
    public List<SelectOption> getOpportunities(){
        
        List<SelectOption> options = new List<SelectOption>();
        List<Opportunity> opportunityList = [SELECT Id, Name FROM Opportunity ORDER BY Createddate Desc];
        for(Opportunity opp : opportunityList){
            options.add(new SelectOption(opp.Id, opp.Name));
        }
        return options;
    }
    
    public List<SelectOption> getStageNames(){
        
        List<SelectOption> options = new List<SelectOption>();
        for(Schema.PicklistEntry picklistOption : Opportunity.StageName.getDescribe().getPicklistValues()){
            options.add(new SelectOption(picklistOption.getLabel(), picklistOption.getValue()));
        }
        return options;
    }
    
    
}