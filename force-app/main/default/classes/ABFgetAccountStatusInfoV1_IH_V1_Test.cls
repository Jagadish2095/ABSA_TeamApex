@isTest
public class ABFgetAccountStatusInfoV1_IH_V1_Test {

     public static final String POSITIVE_RESPONSE_BODY = '{"statusCode":200,"nbsapdpo": {"version": null,"returnCode": "0","reasonCode": "0","serviceVersion": "BUSO001","echoKey": null},"nbsmsgo": {"version": "MSG3001","sysErrTxt": null,"nbrUserMsgs": "1","nbrUserErrs": "1","msgEntry": [{"msgClass": "PLSMGC01","msgCode": "0020","msgErrInd": "E","msgTxt": "Account status is invalid"}]},"plpa18o": {"applicationNbr": "0","clientNameLine1": null,"clientNameLine2": null,"clientAddress": null,"originalLoanAmount": "0","contractTerm": "0","repaymentFrequency": "0","firstRepaymentAmt": "0","lastRepaymentAmt": "0","firstInstalmentDate": "0","accountStatus": "0","mandateNumber": "0"}}';

    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ABFgetAccountStatusInfoV1_IH_V1.INTEGRATION_SERVICE_NAME});
    }
 
     @isTest static void testPositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));

        Test.startTest();
       ABFgetAccountStatusInfoV1_Resp_IB_V1 responseBean = callHandlerMethod();
       // System.assertEquals(200, responseBean.statusCode);
        Test.stopTest();
    }
    
    private static ABFgetAccountStatusInfoV1_Resp_IB_V1 callHandlerMethod() {
        ABFgetAccountStatusInfoV1_Req_IB_V1 dummyBean = ABFgetAccountStatusInfoV1_Req_IB_V1.createDummyRequest();
        ABFgetAccountStatusInfoV1_Resp_IB_V1 responseBean = ABFgetAccountStatusInfoV1_IH_V1.ABFgetAccountStatusInfoV1(dummyBean);
        return responseBean;
    }
}