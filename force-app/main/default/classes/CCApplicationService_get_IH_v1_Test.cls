/**
* @description Test Integration Handler for CCApplication get Service
* @author Aaron Castelyn (ABSA)
* @created 2021-04-09
*/
@isTest
public class CCApplicationService_get_IH_v1_Test {
    public static final String POSITIVE_RESPONSE_BODY = '{"applyResponse":{"return":{"application":{"annualCreditLimitIncreases":false,"applicationNumber":102010080131011579,"applicationType":"P","campaignId":0,"cardProdSubProdGroupId":0,"channelCode":"B","consents":{"deaConsent":false},"corpCode":"ABSA","creditLifeRequired":false,"creditLimitApproved":0,"creditLimitSelected":0,"creditStatus":{"description":"Pre-Scoring Approved","id":"08"},"dateCreated":"2020-10-08T01:31:01.999+02:00","debitOrderDetails":null,"externalConsumerData":{"customerId":9407229216088,"customerSourceCode":"ABSA","customerSourceReferenceNumber":"THIS IS A TEST3"},"hasAcceptedCourierCollectionFee":false,"hasAcceptedSpecifiedCreditLimit":false,"knockOutQuestions":{"absaRewards":false,"casaClauseRead":true,"creditBureauConsent":false,"creditLifeTermsAndConditionsRead":false,"curatorship":false,"currentlyUnderDebtCounselling":false,"debitOrderByPass":false,"declaredInsolvent":false,"monthlyGrossIncomeAboveMin":false,"olderThan18Years":false,"pendingDebtCounselling":false,"permanentSAResident":false,"registeredForeingTax":false,"rehabilitation":{"everBeenDeclaredInsolvent":false,"everUndergoneDebtCounselling":false},"spouseConsent":false,"termsAndConditionsRead":true},"linkedAccountSelected":null,"lockVersionId":43678,"lowValuePaymentRequired":false,"marketingSiteId":4592,"numberOfSecondaryApplicantsRequested":0,"packageId":null,"personWhoCreatedApplication":"ABAJ013","pinOptionSelected":null,"primaryApplicant":{"cardCollection":null,"cardProdSubProdGroupId":0,"casaInformation":{"referenceNumber":0,"versionNumber":0},"cellPhoneNumber":{"countryCode":null,"extension":null,"number":"0725845698"},"emailAddress":null,"employer":{"address":null,"name":null},"expense":null,"familyStatus":{"maritalStatus":0,"numberOfDependents":0},"financialInformationSuppliedCorrect":false,"firstNames":"FABIAN GERONE","hasSocialGrant":false,"homeFaxNumber":null,"homeTelephoneNumber":null,"idOrRegistrationNo":"9407229216088       ","identificationType":"01","income":{"disposableMonthlyIncome":0,"grossMonthlyIncome":0,"grossMonthlySalary":0,"nettMonthlyIncome":0,"otherIncome":{"amount":0}},"incomeTaxNumber":0,"initials":"FG        ","isInBusinessRescueAffectedParty":false,"marketingConsentGiven":false,"mayCheckCreditWorthiness":false,"mayReceiveMarketingViaEmail":false,"mayReceiveMarketingViaPost":false,"mayReceiveMarketingViaSMS":false,"mayReceiveMarketingViaTelephone":false,"nextOfKin":null,"postalAddress":null,"preAssessed":null,"qualification":{"hasPostMatricQualification":false},"residentialAddress":null,"shareInfoWithCreditProviders":false,"sourceOfIncome":0,"surname":"PALADI","tempPermitNumber":0,"titleType":"01","workFaxNumber":null,"workTelephoneNumber":null},"productGroupId":1,"quote":null,"statementDeliveryMethodSelected":null,"statusGroup":1},"responseCommons":{"messageTimeStamp":"2020-10-08T01:31:09.325+02:00","success":"TRUE"}}}}';

    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{CCApplicationService_get_IH_v1.INTEGRATION_SERVICE_NAME});
    }
    
    @isTest static void testPositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));

        Test.startTest();

        CCApplicationService_get_Resp_IB_v1 responseBean = callGetApplicationInformation();      
        
        system.assert(responseBean != null, 'Received application information');
        
        Test.stopTest();
    }

    private static CCApplicationService_get_Resp_IB_v1 callGetApplicationInformation() {
        CCApplicationService_get_Req_IB_v1 dummyBean = CCApplicationService_get_Req_IB_v1.createDummyRequest();
        CCApplicationService_get_Resp_IB_v1 responseBean = CCApplicationService_get_IH_v1.GetApplicationInformation(dummyBean);
        return responseBean;
    }
}