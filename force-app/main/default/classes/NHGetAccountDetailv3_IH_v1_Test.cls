/*
* Test Integration Handler for MBlistInstructionsPerSourceAccV1 service
* @author Mashudu Raidimi
* @created 2020-08-11
*/
@isTest
public class NHGetAccountDetailv3_IH_v1_Test {
    
    public static final String POSITIVE_RESPONSE_BODY = '{"NHgetAccountDetailV3Response":{"nbsapdpo":{"version":null,"returnCode":"0","reasonCode":"0","serviceVersion":"BUSO003","echoKey":"DP78004353758063071"},"nhc039o":{"rcde":"0","rcdeType":"0","rcdeSource":null,"rcdeReason":"0","rdesc":null,"productName":"MORTGAGE LOAN","productType":"MORTGAGE LOAN","productCode":"ML","tdAccountBalance":"0","tdAccountStatus":null,"tdAccruedBonus":"0","tdAccruedInterest":"0","tdAmountCeded":"0","tdAvailableAmount":"0","tdBonusRate":"0","tdCapFrequency":null,"tdDateOpened":"19960101","tdInterestRate":"0","tdMaturityDate":"0","tdNextCapDate":"0","tdPostDatedTrans":"0","tdSubaccountBalance":"0","camsStraightBalance":"0","camsArrearAmount":"0","camsAuthorisedAmount":"0","camsAvailableAmount":"0","camsBudgetBalance":"0","camsTotalAccountBal":"0","camsCreditIntRate":"0","camsCreditLimit":"0","camsDebitIntRate":"0","camsExpiryDate":"0","camsFullAmntPayable":"0","camsMinAmntPayable":"0","camsPaymentDueDate":"0","cqAccountBalance":"0","cqAuthAmount":"0","cqAuthHoldAmount":"0","cqAvailableAmount":"0","cqCrInterestDue":"0","cqDateOpened":"0","cqDrInterestDue":"0","cqExpiryDate":"0","cqMarkedChequeAmnt":"0","cqOverdraftLimit":"0","cqPostDatedTrans":"0","cqReturnedCheques":"0","cqUnclearedCheques":"0","cqCrInterestRate":"0","cqDrInterestRate":"0","mlAdvanceAmount":"0","mlArrearAmount":"-3017926.53","mlAvailableAmount":"0","mlInterestRate":"7","mlOutstandingBalance":"-3017926.53","mlPaymentDate":"20200901","mlPaymentDue":"272893.53","mlUnclearedEffects":"0","mlRemainingTerm":"0","svAccountBalance":"0","svAuthHoldAmount":"0","svAvailableAmount":"0","svBonusInterest":"0","svCrInterestDue":"0","svCrdInterestRate":"0","svDateOpened":"0","svPostDatedTrans":"0","svReturnedCheques":"0","svUnclearedCheques":"0","svPndngNoticeTot":"0","svCessionAmount":"0","pblOutstandingBal":"0","pblAvailableAmount":"0","pblUnclearedEffects":"0","pblArrearAmount":"0","pblAdvanceAmount":"0","pblPaymentDue":"272893.53","pblPaymentDate":"0","pblInterestRate":"0","pblTermOfLoan":"240","advAmount":"0","balOutstanding":"0","contractDate":"0","instalment":"0","interestRate":"0","repaymentDay":"0","unclearedCheques":"0","vfOutstandingBal":"0","vfArticleDescrip":null,"vfOriginalAmount":"0","vfOriginalTerm":"0","vfRemainingTerm":"0","vfPaymFrequency":null,"vfPaymMethod":null,"vfIslamIndicator":null,"vfInstalmentAmount":"0","vfNextInstalDate":"0","vfResidualValue":"0","vfEstiSettleValue":"0","vfContractStartDate":"0","vfContractEndDate":"0","vfIntRate":"0","vfIntRateDesc":null,"stpAmt":"0","stpExp":"0"}}}';

    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(NHGetAccountDetailv3_IH_v1.INTEGRATION_API_NAME, new List<String>{NHGetAccountDetailv3_IH_v1.INTEGRATION_SERVICE_NAME});
    }

    @isTest static void testPositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));

        Test.startTest();

       NHGetAccountDetailv3_Resp_IB_v1 responseBean = callHandlerMethod();
        System.assertEquals(200, responseBean.statusCode);

        Test.stopTest();
    }

    private static NHGetAccountDetailv3_Resp_IB_v1 callHandlerMethod() {
        NHGetAccountDetailv3_Req_IB_v1 dummyBean = NHGetAccountDetailv3_Req_IB_v1.dummyRequest();
        NHGetAccountDetailv3_Resp_IB_v1 responseBean = NHGetAccountDetailv3_IH_v1.nhgetaccountdetailv3(dummyBean.NHgetAccountDetailV3.nhp039i.combiNumber,dummyBean.NHgetAccountDetailV3.nhp039i.accountNumber);
        return responseBean;
    }

}