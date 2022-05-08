@isTest
public class ABFupdAccountStatusV1_IH_V1_Test {
	 public static final String POSITIVE_RESPONSE_BODY = '{"statusCode":200,"nbsapdpo": {"version": null,"returnCode": "0","reasonCode": "0","serviceVersion": "BUSO001","echoKey": null},"nbsmsgo3": {"version": "MSG3001","sysErrTxt": null,"nbrUserMsgs": "1","nbrUserErrs": "1","msgEntry": [{"msgClass": "PLSMGC01","msgCode": "0020","msgErrInd": "E","msgTxt": "Account status is invalid"}]},"plpa03o": {"mandateNbr": "0","contractSignedInd": null,"contractSignIndUpdbl": null,"payMethodReqInd": null,"cessionPledgeInd": null,"autoSettlementInd": null,"autoSettleIndUpdbl": null,"creditLifeInd": null,"creditLifeIndUpdbl": null,"landlordWaiverInd": null,"insuranceInd": null,"elecTransferInd": null,"elecTransferIndUpdbl": null}}';

    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ABFupdAccountStatusV1_IH_V1.INTEGRATION_SERVICE_NAME});
    }
 
     @isTest static void testPositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));

        Test.startTest();
        ABFupdAccountStatusV1_Resp_IB_V1 responseBean = callHandlerMethod();
        //System.assertEquals(200, responseBean.statusCode);
        Test.stopTest();
    }
    
    private static ABFupdAccountStatusV1_Resp_IB_V1 callHandlerMethod() {
        ABFupdAccountStatusV1_Req_IB_V1 dummyBean = ABFupdAccountStatusV1_Req_IB_V1.createDummyRequest();
        ABFupdAccountStatusV1_Resp_IB_V1 responseBean = ABFupdAccountStatusV1_IH_V1.ABFupdAccountStatusV1(dummyBean);
        return responseBean;
    }
}