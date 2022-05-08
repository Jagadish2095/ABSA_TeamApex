public class CreateInstruction_IU_v1 {

    public static CreateInstruction_Req_IB_v1 mapRequestFields(String  accountNumberP, String branchCodeP, String amountP, User userP, String lastMaintBrnchP, String targetAccP, String accTypeTranslatedP){
        
        CreateInstruction_Req_IB_v1 requestBean = new CreateInstruction_Req_IB_v1();
        
        /*** Constant Values **/
        requestBean.channel = 'WILLSFEE';
        requestBean.application = 'EPS';
        requestBean.function = 'CREATE';
        requestBean.maxRetrieve = '1';
        requestBean.confirmInd = 'N';
        requestBean.instrType = 'DOF';
        requestBean.freq = '1M';
        //requestBean.freq = paymentPlanP.Frequency__c;
        requestBean.srcStmtRef = 'Absa Wills';
        requestBean.trgStmtRef = 'Absa Trust Limited';
        requestBean.trgAcc = targetAccP;
        //requestBean.trgAccType = 'WIMI Wills account/ GL account';//	N/A
        requestBean.trgClrCode = '632005';
        requestBean.doType = 'FA';
        requestBean.lastMaintBrnch = lastMaintBrnchP;
        requestBean.lastMaintTell = userP.AB_Number__c;
        requestBean.srcAcc = accountNumberP;
        requestBean.srcAccType = accTypeTranslatedP;
        
        DateTime datePlus7Days = system.now().addDays(7);
        requestBean.actDate = datePlus7Days.format('yyyyMMdd');
        requestBean.startDate = datePlus7Days.format('yyyyMMdd');
        requestBean.instrRefName = 'Absa Wills';
        requestBean.SDTARREF = 'Absa Wills';
        requestBean.srcClrCode = branchCodeP;
        requestBean.amount = amountP;
        //requestBean.accessAcc = '';//	N/A
        requestBean.payDay = '1';
        
        return requestBean;
    }
    
    public static CreateInstruction_Req_IB_v1 MBmapRequestFields(String  productTypeP, String beneficiaryNameP ,String targetAccP, String branchCodeP, String accountNumberP,String accountTypeP,String accessAccountP,String beneficiaryReferenceP,String ownReferenceP){
        
        CreateInstruction_Req_IB_v1 requestBean = new CreateInstruction_Req_IB_v1();
        
        /*** Constant Values **/
        requestBean.confirmInd = 'A';
        requestBean.channel = 'SALESFOR';
        requestBean.application = 'SALESFOR';
        requestBean.trace = 'Y';
        requestBean.msgLanguage = 'E';
        requestBean.msgTarget = 'STD';
        requestBean.channel = 'SALESFOR';
        requestBean.function = 'CREATE';
        requestBean.maxRetrieve = '1';
        requestBean.accessAcc = accessAccountP;
        requestBean.instrType = 'VP';
        requestBean.instrRefName = beneficiaryNameP;
        requestBean.srcAcc = accountNumberP;
        requestBean.srcAccType = accountTypeP;
        requestBean.srcClrCode = '632005' ;
        requestBean.srcStmtRef = ownReferenceP;
        requestBean.trgAcc = targetAccP;
        requestBean.trgAccType = productTypeP;
        requestBean.trgClrCode = branchCodeP;
        requestBean.trgStmtRef = beneficiaryReferenceP;
        requestBean.lastMaintBrnch = '8089';
        requestBean.lastMaintTell = '11332';
        
        return requestBean;
    }
    
    //Future Payments 
    public static CreateInstruction_Req_IB_v1 MBFutureMapRequestFields(String  srcAccountNumber,String srcAccountType, String amount, String trgAccNumberP, String trgBranchCodeP, String trgAccReferenceP,String trgAccTypeP,String futureDateP,String futureSourceRef,String accessAcc){
        List<User> currentUser = [SELECT Id,SiteCode__c, Teller_Operator_Code__c FROM USER WHERE Id =: Userinfo.getUserId() limit 1];
        CreateInstruction_Req_IB_v1 requestBean = new CreateInstruction_Req_IB_v1();
        
        /*** Constant Values **/
        requestBean.actDate=futureDateP;
        requestBean.channel = 'SALESFOR';
        requestBean.application = 'SALESFOR';
        requestBean.trace = 'Y';
        requestBean.msgLanguage = 'E';
        requestBean.msgTarget = 'STD';
        requestBean.channel = 'SALESFOR';
        requestBean.function = 'CREATE';
        requestBean.futureInd = 'F';
        requestBean.maxRetrieve = '1';
        requestBean.confirmInd = 'A';
        requestBean.instrRefName = futureSourceRef;
        requestBean.accessAcc = accessAcc; 
        requestBean.startDate = futureDateP;
        requestBean.endDate = futureDateP;      
        requestBean.accessAcc = srcAccountNumber; 
        requestBean.instrType = 'OOP';
        requestBean.srcAcc = srcAccountNumber;   
        requestBean.srcAccType = srcAccountType; 
        requestBean.amount=amount;
        requestBean.srcClrCode = '632005' ; 
        requestBean.srcStmtRef = futureSourceRef;
        requestBean.trgAcc = trgAccNumberP;
        requestBean.trgAccType = trgAccTypeP;
        requestBean.trgClrCode = trgBranchCodeP;
        requestBean.trgStmtRef = trgAccReferenceP;
        requestBean.lastMaintBrnch = currentUser[0].SiteCode__c; 
        requestBean.lastMaintTell = currentUser[0].Teller_Operator_Code__c; 
        
        return requestBean;
    }
   
    
    
    public static CreateInstruction_Resp_IB_v1 mapResponseFields(HttpResponse respP){
        
        System.debug('Create Instruction Response body: ' + respP.getBody());
        CreateInstruction_Resp_IB_v1 responseBean = (CreateInstruction_Resp_IB_v1)JSON.deserialize( respP.getBody(), CreateInstruction_Resp_IB_v1.class);
        responseBean.Status = respP.getStatus();
        responseBean.statusCode = respP.getStatusCode();
        
        System.debug('Create Instruction Response bean: ' + responseBean);
        return responseBean;
    }
    
    public static CreateInstruction_Resp_IB_v1 mapFailedResponseFields(String statusP, Integer statusCodeP, String messageP){
        
        CreateInstruction_Resp_IB_v1 responseBean = new CreateInstruction_Resp_IB_v1();
        responseBean.status = statusP;
        responseBean.statusCode = statusCodeP;
        responseBean.message = messageP;
        
        
        return responseBean;
    }
}