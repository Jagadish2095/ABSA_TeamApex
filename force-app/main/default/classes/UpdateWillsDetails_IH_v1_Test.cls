@isTest
public class UpdateWillsDetails_IH_v1_Test {
    
    @isTest 
    static void postUpdateWillDetailsPostive() {
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new UpdateWillsDetailsMock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.UPDATE_WILL_DETAIL});

        Test.startTest();
        UpdateWillsDetails_Req_IB_v1 wrp=new UpdateWillsDetails_Req_IB_v1();
        wrp.channel ='WILLS';
        wrp.application='WILLS';
        wrp.trace='Y';
        wrp.functioni='DRAFT';
        wrp.willNo='41000010670';
        wrp.languageCode='E';
        wrp.bigPrint='Y';
        wrp.cifkey='DOEJ   005';
        wrp.usrid='INTERNET';
        wrp.testator='JOHN DOE';
        wrp.testatrix='';
        wrp.deliverMethod='';
        wrp.advisorCode='0';
        wrp.brokerCode='420077';
        wrp.specialistCode='0';
        wrp.submittedBy='';
        wrp.submitterTelno='0112345678';
        wrp.oldWillNo='0000001747';
        wrp.oldFilingNumber='0000001747';
        wrp.willFiled='N';
        wrp.willLegal='';
        wrp.fillNo='80409WHITE   099';
        wrp.dateSigned='10082005';
        wrp.dateFiled='29082006';
        wrp.dateWithdrawn='0';
        wrp.timeWithdrawn='0';
        wrp.reasonWithdrawn='New will with another Company';
        wrp.withdrawnCode='';
        wrp.withdrawUserId='';
        wrp.referalReason='';
        wrp.whoDied='';
        wrp.domicileSite='3232';
        wrp.corpCode='ABS';
        wrp.transactionSite='27';
        wrp.tellerNo='747';
        wrp.effectiveDate='1012004';
        wrp.currentBalance='0';
        wrp.productType='WILL';
        wrp.productStatus='FILED';
        wrp.branchCode='8418';
        wrp.deceasedDate='0';
        wrp.registrationDate='16012008';
        wrp.willStatus='?';
        wrp.willError='?';
        wrp.newAmendRevise='N';
        wrp.willOrigin='';
        wrp.acknowledgeLetter='Y';
        wrp.trackerStatus='A';
        wrp.pricingFlag='Y';
        wrp.advisorName='Henry Cobb';
        wrp.brokerName='';
        wrp.specialistName='';
        wrp.caseNo='0';
        wrp.salaryNo='0';
        wrp.dispatchDate='10072003';
        wrp.draftingBranch='3232';
        wrp.correction='N';
        wrp.revisionDate='16012019';
        wrp.executorFeePlan='Y';
        wrp.firstFileDate='1122008';
        wrp.safeCustodyFee='Y';
        wrp.emergencyWill='N';
        wrp.dateReturned='0';
        wrp.standAlone='I';
        wrp.date1stScfLetter='31012007';
        wrp.eisDate='10072003';
        wrp.leadCode='0';
        wrp.leadName='';
        wrp.csaSent='N';
        wrp.trustIndicator='N';
        wrp.specialBequestVal='0';
        wrp.casaNo='';
        wrp.casaDate='0';
        wrp.casaIndicator='';
        wrp.feePaid='N';
        wrp.amountDue='60';
        wrp.payDate='20120307';
        
        UpdateWillsDetails_Resp_IB_v1 responseBean = UpdateWillsDetails_IH_v1.updateWillsDetails(wrp);
        System.debug('Update Wills Details response bean Test Positive: ' + responseBean);
        
        Test.stopTest();
    }
    
    @isTest 
    static void postUpdateWillDetailsNegative() {        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new UpdateWillsDetailsMock_ApiRest(StringConstants.NEGATIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.UPDATE_WILL_DETAIL});

        Test.startTest();
        UpdateWillsDetails_Req_IB_v1 wrp=new UpdateWillsDetails_Req_IB_v1();
        wrp.channel ='WILLS';
        wrp.application='WILLS';
        
        UpdateWillsDetails_Resp_IB_v1 responseBean = UpdateWillsDetails_IH_v1.updateWillsDetails(wrp);
        System.debug('Update Wills Details response bean Test Negative: ' + responseBean);
        //System.assertEquals(400, responseBean.statusCode);
        
        Test.stopTest();
    }
    
    @isTest 
    static void postUpdateWillDetailsException() {        
        // No mock callout class 
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.UPDATE_WILL_DETAIL});
        
        Test.startTest();
        UpdateWillsDetails_Req_IB_v1 wrp=new UpdateWillsDetails_Req_IB_v1();
        UpdateWillsDetails_Resp_IB_v1 responseBean = UpdateWillsDetails_IH_v1.updateWillsDetails(wrp);
        Test.stopTest();
    } 
    
    @isTest
    public static void shouldInitResponseBean() {
    	UpdateWillsDetails_Resp_IB_v1 responseBean = new UpdateWillsDetails_Resp_IB_v1();
        UpdateWillsDetails_Req_IB_v1 req = UpdateWillsDetails_Req_IB_v1.fromDetails(new GetWillDetails_Resp_IB_v1());
    }    
    
}