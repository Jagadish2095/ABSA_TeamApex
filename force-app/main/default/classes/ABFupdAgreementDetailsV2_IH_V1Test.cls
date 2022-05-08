@isTest
public class ABFupdAgreementDetailsV2_IH_V1Test {
	 public static final String POSITIVE_RESPONSE_BODY = '{"nbsapdpo":{"version":"?","returnCode":"?","reasonCode":"?","serviceVersion":"?","echoKey":"?"},"nbsmsgo":{"version":"?","sysErrTxt":"?","nbrUserMsgs":"?","nbrUserErrs":"?","msgEntry":[{"msgClass":"?","msgCode":"?","msgErrInd":"?","msgTxt":"?"}]},"outputArea":{"creditLifePremium":"?","monthlyServiceFee":"?","repaymentCounter":"?","repaymentDetail":[{"supplementaryAmount":"?","supplementaryAmtInd":"?","instalmentDate":"?","instalmentAmount":"?","capitalBalance":"?","capitalAmount":"?","interestAmount":"?","instalmentPaidInd":"?","activityInd":"?","fixedLinkedInd":"?","rate":"?","rateDate":"?","rateEscalation":"?","rateId":"?","rateIdRate":"?","rateIdDate":"?","capitalisationAmount":"?","capitalisationDate":"?","capitalisationBalance":"?","repaymentNumber":"?"}],"applicationNbr":"?","clientNameLine1":"?","clientNameLine2":"?","clientAddress":"?","originalLoanAmount":"?","contractTerm":"?","repaymentFrequency":"?","firstRepaymentAmt":"?","lastRepaymentAmt":"?","firstInstalmentDate":"?","accountStatus":"?","mandateNumber":"?"}}';
    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ABFupdAgreementDetailsV2_IH_V1.INTEGRATION_SERVICE_NAME});
    }
 
     @isTest static void testPositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));

        Test.startTest();
        ABFupdAgreementDetailsV2_Resp_IB_V1 responseBean = callHandlerMethod();
        System.assertEquals(200, responseBean.statusCode);
        Test.stopTest();
    }
    
    private static ABFupdAgreementDetailsV2_Resp_IB_V1 callHandlerMethod() {
        ABFupdAgreementDetailsV2_Req_IB_V1 dummyBean = ABFupdAgreementDetailsV2_Req_IB_V1.createDummyRequest();
        ABFupdAgreementDetailsV2_Resp_IB_V1 responseBean = ABFupdAgreementDetailsV2_IH_V1.ABFupdAgreementDetailsV2(dummyBean);
        return responseBean;
    }

}