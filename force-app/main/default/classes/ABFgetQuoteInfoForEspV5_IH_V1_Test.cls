/*
* Test Integration Handler for ABFgetQuoteInfoForEspV5 Service to Calculate the Quotes for Term Loan
* @author Himanshu Nimje
* @created 2020-12-02
*/

@isTest
public class ABFgetQuoteInfoForEspV5_IH_V1_Test {

    public static final String POSITIVE_RESPONSE_BODY = '{"NBSAPDPO":{"outputHeaders":{"serviceVersion":"","returnCode":0,"echoKey":"","reasonCode":0,"version":""}},"PLSA71O":{"outputCopybookLayout":{"outputCreditlifeBenefitDetails":"","outputDateLastInstalment":20260530,"outputRegularCapitalAndInterestInstalmentAmount":0.00,"outputDateLastCapitalAndInterestInstalment":0,"outputTermLoanType":"","outputCreditlifeNetPremium":0.00,"outputNumberOfCapitalAndInterestInstalments":0,"outputSuretyInfo":"","outputInterestAndFeesCreditlife":225211.55,"outputCreditlifePolicyFee":0.00,"outputOtherConditions":"","outputHighestInterestOnlyInstamentAmount":0.00,"outputSchemeType":"","outputTotalInstalmentAmount":19694.06,"outputSettlementIndicator":"","outputTotalCostOfCredit":1122561.55,"outputProductCode":"LOAN","outputPaymentMethodDescription":"DEBIT ORDER","outputNCAIndicator":"","outputCreditLife":0.00,"outputEmpowermentCode":"","outputDateFirstInterestOnlyInstalment":0,"outputCreditlifePremium":0.00,"outputMaxRateType":60,"outputTotalAmountRepay":1299808.09,"outpuComplexStructureIndicator":"N","outputSMSInfoRequiredIndicator":"","outputVersionNumber":0,"outputTotalCreditLife":0.00,"outputRateFactorSign":"+","outputApplicationNbr":100,"outputCreditlifeSchemeCode":0,"outputCreditlifeCommission":0.00,"outputVisibleCreditLimitIndicator":"","outputInitiationFee":42350.00,"outputSecurityRequestIndicator":"N","outputTotalAllInstalmentAmount":0.00,"outputSkipPaymentsAmount":0.00,"outputAgreementType":"L","outputSettlementAmount":0.00,"outputBrokenPeriodIndicator":"","outputNLRReferenceNbr":0,"outputLoanAmount":855000.00,"outputNumberOfInstalments":66,"outputEffectiveInterestRate":7.2500,"outputNumberOfInterestOnlyInstalments":0,"outputFinalInstalmentAmount":19694.19,"outputCreditlifeBusnessIndicator":"","outputRateFactorValue":1.7500,"outputTotalServiceFee":0.00,"outputServiceFee":0.00,"outputRegularInstalmentAmount":19694.06,"outputBrokenPeriodInstalmentAmount":0.00,"outputQuoteNbr":848160,"outputSchemeCode":0,"outputContractDate":20201130,"outputTotalInterestOnlyInstalmentAmount":0.00,"outputChannelQuoteCreated":"","outputRateType":"P","outputTotalSettlementAmount":0.00,"outputTotalInterestAndCapitalInstalmentAmount":0.00,"outputPurposeOfLoanCode":2,"outputNumberOfSkipPayments":9,"outputSkipMonths":9,"outputInitiationFeePaymentMethod":"P","outputDateLastInterestOnlyInstalment":0,"outputTotalFinanceCharges":225211.55,"outputInstalmentIncludingCreditlife":19694.06,"outputAccountType":1,"outputInstalmentFrequencyDescription":"MONTHLY","outputDateFirstInstalment":20201230,"outputCostOfCreditMultiple":1.31,"outputDateFirstCapitalAndInterestInstalment":0,"outputPaymentMethod":"Y","outputTotalAmountDeferred":897350.00,"outputInstalmentFrequency":1,"outputCreditlifeRequestIndicator":"N","outpuCreditlifeSchemeNbr":0,"outputNumberOfRegularInstalments":65}},"NBSMSGO3":{"outputErrorMessage":{"errorMessageVersion":"","outputErrorMessageTable":[{"errorMessageCode":"","errorMessageIndicator":"","errorMessageText":"                         000000","errorMessageClass":""},{"errorMessageCode":"","errorMessageIndicator":"","errorMessageText":"","errorMessageClass":""},{"errorMessageCode":"","errorMessageIndicator":"","errorMessageText":"","errorMessageClass":""},{"errorMessageCode":"","errorMessageIndicator":"","errorMessageText":"","errorMessageClass":""},{"errorMessageCode":"","errorMessageIndicator":"","errorMessageText":"","errorMessageClass":""}],"systemErrorTxt":"0000000000BUSO006","numberUserErrors":0,"numberUserMessages":0}}}';

 @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ABFgetQuoteInfoForEspV5_IH_V1.INTEGRATION_SERVICE_NAME});
    }
 
     @isTest static void testPositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));

        Test.startTest();
        ABFgetQuoteInfoForEspV5_Resp_IB_V1 responseBean = callHandlerMethod();
        System.assertEquals(200, responseBean.statusCode);
        Test.stopTest();
    }
    
    private static ABFgetQuoteInfoForEspV5_Resp_IB_V1 callHandlerMethod() {
        ABFgetQuoteInfoForEspV5_Req_IB_V1 dummyBean = ABFgetQuoteInfoForEspV5_Req_IB_V1.createDummyRequest();
        ABFgetQuoteInfoForEspV5_Resp_IB_V1 responseBean = ABFgetQuoteInfoForEspV5_IH_V1.ABFgetQuoteInfoForEspV5(dummyBean);
        return responseBean;
    }

}