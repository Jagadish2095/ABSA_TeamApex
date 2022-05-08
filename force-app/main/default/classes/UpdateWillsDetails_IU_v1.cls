public class UpdateWillsDetails_IU_v1 {
    
      //Populates the Update Wills Details response bean from an http response
    public static UpdateWillsDetails_Resp_IB_v1 mapResponseFields(HttpResponse respP){
        
        UpdateWillsDetails_Resp_IB_v1 bean=new UpdateWillsDetails_Resp_IB_v1();
        
        UpdateWillsDetails_Resp_IB_v1 responseBean = (UpdateWillsDetails_Resp_IB_v1)JSON.deserialize( respP.getBody(), UpdateWillsDetails_Resp_IB_v1.class );
        System.debug('Update Wills Details  Response Bean: ' + responseBean);
        return responseBean;   
    } 
    
    
    //Populates the Update Wills Details response bean as failed with the necessary data
    public static UpdateWillsDetails_Resp_IB_v1 mapFailedResponseFields(Integer statusCodeP, String statusP, String messageP){
        
        UpdateWillsDetails_Resp_IB_v1 updateWillsDetailsResponse = new UpdateWillsDetails_Resp_IB_v1();
         
        System.debug('Update Wills Details  Failed Response Bean: ' + updateWillsDetailsResponse);
        return updateWillsDetailsResponse;
    }
    
    
    //Populates the Update Wills Details request bean from the parameters passed
    public static UpdateWillsDetails_Req_IB_v1 mapRequestFields(UpdateWillsDetails_Req_IB_v1 wrpValsP){
        
        UpdateWillsDetails_Req_IB_v1 updateWillsDetailstRequest = new UpdateWillsDetails_Req_IB_v1();
        
        
        updateWillsDetailstRequest.channel=wrpValsP.channel;
        updateWillsDetailstRequest.application=wrpValsP.application;
        updateWillsDetailstRequest.trace=wrpValsP.trace;
        updateWillsDetailstRequest.functioni=wrpValsP.functioni;
        updateWillsDetailstRequest.willNo=wrpValsP.willNo;
        updateWillsDetailstRequest.languageCode =wrpValsP.languageCode;
        updateWillsDetailstRequest.bigPrint = wrpValsP.bigPrint;
        updateWillsDetailstRequest.cifkey= wrpValsP.cifkey;
        updateWillsDetailstRequest.usrid =wrpValsP.usrid;
        updateWillsDetailstRequest.testator =wrpValsP.testator;
        updateWillsDetailstRequest.testatrix =wrpValsP.testatrix;
        updateWillsDetailstRequest.deliverMethod =wrpValsP.deliverMethod;
        updateWillsDetailstRequest.advisorCode = wrpValsP.advisorCode;
        updateWillsDetailstRequest.brokerCode = wrpValsP.brokerCode;
        updateWillsDetailstRequest.specialistCode = wrpValsP.specialistCode;
        updateWillsDetailstRequest.submittedBy = wrpValsP.submittedBy;
        updateWillsDetailstRequest.submitterTelno = wrpValsP.submitterTelno; 
        updateWillsDetailstRequest.oldWillNo = wrpValsP.oldWillNo;
        updateWillsDetailstRequest.oldFilingNumber=wrpValsP.oldFilingNumber;
        updateWillsDetailstRequest.willFiled=wrpValsP.willFiled;
        updateWillsDetailstRequest.willLegal=wrpValsP.willLegal;
        updateWillsDetailstRequest.fillNo=wrpValsP.fillNo;
        updateWillsDetailstRequest.dateSigned=wrpValsP.dateSigned;
        updateWillsDetailstRequest.dateFiled=wrpValsP.dateFiled;
        updateWillsDetailstRequest.dateWithdrawn =wrpValsP.dateWithdrawn;
        updateWillsDetailstRequest.timeWithdrawn =wrpValsP.timeWithdrawn;
        updateWillsDetailstRequest.reasonWithdrawn=wrpValsP.reasonWithdrawn;
        updateWillsDetailstRequest.withdrawnCode =wrpValsP.withdrawnCode;
        updateWillsDetailstRequest.withdrawUserId=wrpValsP.withdrawUserId;
        updateWillsDetailstRequest.referalReason =wrpValsP.referalReason;
        updateWillsDetailstRequest.whoDied=wrpValsP.whoDied;
        updateWillsDetailstRequest.domicileSite =wrpValsP.domicileSite;
        updateWillsDetailstRequest.corpCode =wrpValsP.corpCode;
        updateWillsDetailstRequest.transactionSite =wrpValsP.transactionSite;
        updateWillsDetailstRequest.tellerNo =wrpValsP.tellerNo;
        updateWillsDetailstRequest.effectiveDate =wrpValsP.effectiveDate;
        updateWillsDetailstRequest.currentBalance =wrpValsP.currentBalance;
        updateWillsDetailstRequest.productType=wrpValsP.productType;
        updateWillsDetailstRequest.productStatus =wrpValsP.productStatus;
        updateWillsDetailstRequest.branchCode =wrpValsP.branchCode;
        updateWillsDetailstRequest.deceasedDate=wrpValsP.deceasedDate;
        updateWillsDetailstRequest.registrationDate=wrpValsP.registrationDate;
        updateWillsDetailstRequest.willStatus =wrpValsP.willStatus;
        updateWillsDetailstRequest.willError =wrpValsP.willError;
        updateWillsDetailstRequest.newAmendRevise =wrpValsP.newAmendRevise;
        updateWillsDetailstRequest.willOrigin =wrpValsP.willOrigin;
        updateWillsDetailstRequest.acknowledgeLetter=wrpValsP.acknowledgeLetter;
        updateWillsDetailstRequest.trackerStatus=wrpValsP.trackerStatus;
        updateWillsDetailstRequest.pricingFlag =wrpValsP.pricingFlag;
        updateWillsDetailstRequest.advisorName=wrpValsP.advisorName;
        updateWillsDetailstRequest.brokerName =wrpValsP.brokerName;
        updateWillsDetailstRequest.specialistName =wrpValsP.specialistName;
        updateWillsDetailstRequest.caseNo =wrpValsP.caseNo;
        updateWillsDetailstRequest.salaryNo =wrpValsP.salaryNo;
        updateWillsDetailstRequest.dispatchDate =wrpValsP.dispatchDate;
        updateWillsDetailstRequest.draftingBranch =wrpValsP.draftingBranch;
        updateWillsDetailstRequest.correction=wrpValsP.correction;
        updateWillsDetailstRequest.revisionDate=wrpValsP.revisionDate;
        updateWillsDetailstRequest.executorFeePlan=wrpValsP.executorFeePlan;
        updateWillsDetailstRequest.firstFileDate=wrpValsP.firstFileDate;
        updateWillsDetailstRequest.safeCustodyFee=wrpValsP.safeCustodyFee;
        updateWillsDetailstRequest.emergencyWill=wrpValsP.emergencyWill;
        updateWillsDetailstRequest.dateReturned=wrpValsP.dateReturned;
        updateWillsDetailstRequest.standAlone=wrpValsP.standAlone;
        updateWillsDetailstRequest.date1stScfLetter=wrpValsP.date1stScfLetter;
        updateWillsDetailstRequest.eisDate=wrpValsP.eisDate;
        updateWillsDetailstRequest.leadCode=wrpValsP.leadCode;
        updateWillsDetailstRequest.leadName=wrpValsP.leadName;
        updateWillsDetailstRequest.csaSent=wrpValsP.csaSent;
        updateWillsDetailstRequest.trustIndicator=wrpValsP.trustIndicator;
        updateWillsDetailstRequest.specialBequestVal=wrpValsP.specialBequestVal;
        updateWillsDetailstRequest.casaNo=wrpValsP.casaNo;
        updateWillsDetailstRequest.casaDate=wrpValsP.casaDate;
        updateWillsDetailstRequest.casaIndicator=wrpValsP.casaIndicator;
        updateWillsDetailstRequest.feePaid=wrpValsP.feePaid;
        updateWillsDetailstRequest.amountDue=wrpValsP.amountDue;
        updateWillsDetailstRequest.payDate=wrpValsP.payDate;
        
        System.debug('Update Wills details Request Bean: ' + updateWillsDetailstRequest);
        return updateWillsDetailstRequest;
    }
    
}