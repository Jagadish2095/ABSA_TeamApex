/*
* Test Integration Handler for CCApplication apply Service
* @author Rajani Bommasani
* @created 2020-10-10
*/

@isTest
public class CCApplicationService_apply_IH_v1_Test {

    public static final String POSITIVE_RESPONSE_BODY = '{"applyResponse":{"return":{"application":{"annualCreditLimitIncreases":false,"applicationNumber":102010080131011579,"applicationType":"P","campaignId":0,"cardProdSubProdGroupId":0,"channelCode":"B","consents":{"deaConsent":false},"corpCode":"ABSA","creditLifeRequired":false,"creditLimitApproved":0,"creditLimitSelected":0,"creditStatus":{"description":"Pre-Scoring Approved","id":"08"},"dateCreated":"2020-10-08T01:31:01.999+02:00","debitOrderDetails":null,"externalConsumerData":{"customerId":9407229216088,"customerSourceCode":"ABSA","customerSourceReferenceNumber":"THIS IS A TEST3"},"hasAcceptedCourierCollectionFee":false,"hasAcceptedSpecifiedCreditLimit":false,"knockOutQuestions":{"absaRewards":false,"casaClauseRead":true,"creditBureauConsent":false,"creditLifeTermsAndConditionsRead":false,"curatorship":false,"currentlyUnderDebtCounselling":false,"debitOrderByPass":false,"declaredInsolvent":false,"monthlyGrossIncomeAboveMin":false,"olderThan18Years":false,"pendingDebtCounselling":false,"permanentSAResident":false,"registeredForeingTax":false,"rehabilitation":{"everBeenDeclaredInsolvent":false,"everUndergoneDebtCounselling":false},"spouseConsent":false,"termsAndConditionsRead":true},"linkedAccountSelected":null,"lockVersionId":43678,"lowValuePaymentRequired":false,"marketingSiteId":4592,"numberOfSecondaryApplicantsRequested":0,"packageId":null,"personWhoCreatedApplication":"ABAJ013","pinOptionSelected":null,"primaryApplicant":{"cardCollection":null,"cardProdSubProdGroupId":0,"casaInformation":{"referenceNumber":0,"versionNumber":0},"cellPhoneNumber":{"countryCode":null,"extension":null,"number":"0725845698"},"emailAddress":null,"employer":{"address":null,"name":null},"expense":null,"familyStatus":{"maritalStatus":0,"numberOfDependents":0},"financialInformationSuppliedCorrect":false,"firstNames":"FABIAN GERONE","hasSocialGrant":false,"homeFaxNumber":null,"homeTelephoneNumber":null,"idOrRegistrationNo":"9407229216088       ","identificationType":"01","income":{"disposableMonthlyIncome":0,"grossMonthlyIncome":0,"grossMonthlySalary":0,"nettMonthlyIncome":0,"otherIncome":{"amount":0}},"incomeTaxNumber":0,"initials":"FG        ","isInBusinessRescueAffectedParty":false,"marketingConsentGiven":false,"mayCheckCreditWorthiness":false,"mayReceiveMarketingViaEmail":false,"mayReceiveMarketingViaPost":false,"mayReceiveMarketingViaSMS":false,"mayReceiveMarketingViaTelephone":false,"nextOfKin":null,"postalAddress":null,"preAssessed":null,"qualification":{"hasPostMatricQualification":false},"residentialAddress":null,"shareInfoWithCreditProviders":false,"sourceOfIncome":0,"surname":"PALADI","tempPermitNumber":0,"titleType":"01","workFaxNumber":null,"workTelephoneNumber":null},"productGroupId":1,"quote":null,"statementDeliveryMethodSelected":null,"statusGroup":1},"responseCommons":{"messageTimeStamp":"2020-10-08T01:31:09.325+02:00","success":"TRUE"}}}}';

    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{CCApplicationService_apply_IH_v1.INTEGRATION_SERVICE_NAME});
    }

    @isTest static void testPositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));

        Test.startTest();

        CCApplicationService_apply_Resp_IB_v1 responseBean = callHandlerMethod();      
        CCApplicationService_apply_Resp_IB_v1 responsePreScreen = callPreScreen();      
        CCApplicationService_apply_Resp_IB_v1 responseClientUpdate = callClientUpdate();      
        CCApplicationService_apply_Resp_IB_v1 responseFinalScoring = callFinalScoring();      
        CCApplicationService_apply_Resp_IB_v1 responseComplete1 = callComplete1();      
        CCApplicationService_apply_Resp_IB_v1 responseComplete2 = callComplete2();      
        CCApplicationService_apply_Resp_IB_v1 responseQuoteAccept = callQuoteAccept();
        CCApplicationService_apply_Resp_IB_v1 responseInstantAccountOpening = callInstantAccountOpening();            
        CCApplicationService_apply_Resp_IB_v1 responseInitiateDebiCheck = callInitiateDebiCheck();            
        
        Test.stopTest();
    }

    private static CCApplicationService_apply_Resp_IB_v1 callHandlerMethod() {
        CCApplicationService_apply_Req_IB_v1 dummyBean = CCApplicationService_apply_Req_IB_v1.createDummyRequest();
        CCApplicationService_apply_Resp_IB_v1 responseBean = CCApplicationService_apply_IH_v1.CCApplicationService(dummyBean);
        return responseBean;
    }

    private static CCApplicationService_apply_Resp_IB_v1 callPreScreen() {
        CCApplicationService_PreScreen_Req_IB_v1 dummyBean = CCApplicationService_PreScreen_Req_IB_v1.createDummyRequest();
        CCApplicationService_apply_Resp_IB_v1 responseBean = CCApplicationService_apply_IH_v1.CCApplicationServicePreScreen(dummyBean);
        if(responseBean.statusCode != 200)
        {
        system.debug( 'TestFailrs' + responseBean.Fault);
        }
        return responseBean;
    }

    private static CCApplicationService_apply_Resp_IB_v1 callClientUpdate() {
        CCApplicationService_CltUpdate_Req_IB_v1 dummyBean = CCApplicationService_CltUpdate_Req_IB_v1.createDummyRequest();
        CCApplicationService_apply_Resp_IB_v1 responseBean = CCApplicationService_apply_IH_v1.CCApplicationServiceClientUpdate(dummyBean);
        return responseBean;
    }

    private static CCApplicationService_apply_Resp_IB_v1 callFinalScoring() {
        CCApplicationService_FnlScorng_Req_IB_v1 dummyBean = CCApplicationService_FnlScorng_Req_IB_v1.createDummyRequest();
        CCApplicationService_apply_Resp_IB_v1 responseBean = CCApplicationService_apply_IH_v1.CCApplicationServiceFinalScoring(dummyBean);
        return responseBean;
    }

    private static CCApplicationService_apply_Resp_IB_v1 callComplete1() {
        CCApplicationService_Complete1_Req_IB_v1 dummyBean = CCApplicationService_Complete1_Req_IB_v1.createDummyRequest();
        CCApplicationService_apply_Resp_IB_v1 responseBean = CCApplicationService_apply_IH_v1.CCApplicationServiceComplete1(dummyBean);
        return responseBean;
    }

    private static CCApplicationService_apply_Resp_IB_v1 callComplete2() {
        CCApplicationService_Complete2_Req_IB_v1 dummyBean = CCApplicationService_Complete2_Req_IB_v1.createDummyRequest();
        CCApplicationService_apply_Resp_IB_v1 responseBean = CCApplicationService_apply_IH_v1.CCApplicationServiceComplete2(dummyBean);
        return responseBean;
    }

    private static CCApplicationService_apply_Resp_IB_v1 callQuoteAccept() {
        CCApplicationService_QteAccept_Req_IB_v1 dummyBean = CCApplicationService_QteAccept_Req_IB_v1.createDummyRequest();
        CCApplicationService_apply_Resp_IB_v1 responseBean = CCApplicationService_apply_IH_v1.CCApplicationServiceQuoteAccept(dummyBean);
        return responseBean;
    }

    private static CCApplicationService_apply_Resp_IB_v1 callInstantAccountOpening() {
        CCApplicationService_InstAcc_Req_IB_v1 dummyBean = CCApplicationService_InstAcc_Req_IB_v1.createDummyRequest();
        CCApplicationService_apply_Resp_IB_v1 responseBean = CCApplicationService_apply_IH_v1.CCApplicationServiceInstantAccountOpening(dummyBean);
        return responseBean;
    }

    private static CCApplicationService_apply_Resp_IB_v1 callInitiateDebiCheck() {
        CCApplicationService_DebiCheck_Req_IB_v1 dummyBean = CCApplicationService_DebiCheck_Req_IB_v1.createDummyRequest();
        CCApplicationService_apply_Resp_IB_v1 responseBean = CCApplicationService_apply_IH_v1.CCApplicationServiceInitiateDebiCheck(dummyBean);
        return responseBean;
    }
}