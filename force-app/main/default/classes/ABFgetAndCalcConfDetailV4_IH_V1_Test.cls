/*
* Test Integration Handler for ABFgetBasicDetailsV2 Service 
* @author Himanshu Nimje
* @created 2020-11-24
*/

@isTest
public class ABFgetAndCalcConfDetailV4_IH_V1_Test {

    
      public static final String POSITIVE_RESPONSE_BODY = '{"NBSAPDPO":{"outputErrorHeaders":{"returnCode":0,"outputServiceVersion":"BUSO004","reasonCode":0}},"PLPA01O":{"outputErrorMessages":{"totalDebtAmount":0.00,"assuranceCompany":"","rateFixedLinkedInd":"","ceilingRate":0.0000,"totalRepaymentAmt":0.00,"clSchemeCode":0,"paymentType":"","totalLoanAmount":0.00,"initFeePayMethod":"","firstRepaymentAmt":0.00,"repaymentFrequency":0,"monthlyServiceFee":0.00,"skipMonthIndicator":"","usuaryActIndicator":"","debitValType":"","siteCode":0,"residualAmount":0.00,"firstCollectionDate":0,"originalLoanAmount":0.00,"initiationFeeAmount":0.00,"baseRate":0.0000,"interestRateAdj":0,"maxCollectionAmount":0.00,"principleDebtAmount":0.00,"regularRepaymentAmt":0.00,"effectiveRate":0.0000,"contractTerm":0,"initialAmount":0.00,"financeType":0,"interestRateTypeID":0,"lastRepaymentAmt":0.00,"totalSettlementAmount":0.00,"regInstallAmount":0.00,"financeCharges":0.00}},"MSGO":{"NBSMSGO3":{"NBNMSGO3_NBR_USER_ERRS":1,"NBSMSGO3_VERSION":"","NBNMSGO3_SYS_ERR_TXT":"","NBNMSGO3_NBR_USER_MSGS":1,"NBNMSGO3_MSG_ENTRY":[{"NBNMSGO3_MSG_ERR_IND":"E","NBNMSGO3_MSG_TXT":"Only account status 000, 002, 003, 004 and 008 allowed","NBNMSGO3_MSG_CLASS":"PLSMGC01","NBNMSGO3_MSG_CODE":"0001"},{"NBNMSGO3_MSG_ERR_IND":"","NBNMSGO3_MSG_TXT":"","NBNMSGO3_MSG_CLASS":"","NBNMSGO3_MSG_CODE":""},{"NBNMSGO3_MSG_ERR_IND":"","NBNMSGO3_MSG_TXT":"","NBNMSGO3_MSG_CLASS":"","NBNMSGO3_MSG_CODE":""},{"NBNMSGO3_MSG_ERR_IND":"","NBNMSGO3_MSG_TXT":"","NBNMSGO3_MSG_CLASS":"","NBNMSGO3_MSG_CODE":""},{"NBNMSGO3_MSG_ERR_IND":"","NBNMSGO3_MSG_TXT":"","NBNMSGO3_MSG_CLASS":"","NBNMSGO3_MSG_CODE":""}]}}}';

 @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ABFgetAndCalcConfDetailV4_IH_V1.INTEGRATION_SERVICE_NAME});
    }
 
     @isTest static void testPositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));

        Test.startTest();
        ABFgetAndCalcConfDetailV4_Resp_IB_V1 responseBean = callHandlerMethod();
        System.assertEquals(200, responseBean.statusCode);
        Test.stopTest();
    }
    
    private static ABFgetAndCalcConfDetailV4_Resp_IB_V1 callHandlerMethod() {
        ABFgetAndCalcConfDetailV4_Req_IB_V1 dummyBean = ABFgetAndCalcConfDetailV4_Req_IB_V1.createDummyRequest();
        ABFgetAndCalcConfDetailV4_Resp_IB_V1 responseBean = ABFgetAndCalcConfDetailV4_IH_V1.ABFgetAndCalcConfDetailV4(dummyBean);
        return responseBean;
    }

    
    
}