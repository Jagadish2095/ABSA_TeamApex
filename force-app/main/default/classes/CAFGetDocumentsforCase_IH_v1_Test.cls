@isTest
public class CAFGetDocumentsforCase_IH_v1_Test {

    public static final String POSITIVE_RESPONSE_BODY = '{"GetDocumentsForCaseResponse":{"documents":[{"Id":"5c58409e-9a15-4a8e-a4b4-cb5b287cad40","DefinitionId":"3f59f8c8-e18c-48ef-95d4-61f2d8630d88","CaseId":"a69f6b31-3d17-40fd-9cd3-d1c279a1863b","ContentType":"Pdf","Name":"ESPpodium.pdf","Description":"Podium Document","Data":"","ArchiveType":"NotArchived","ArchiveId":null,"Status":"Saved","Created":"2021-01-26T16:51:50.147","Updated":"2021-01-26T16:51:50.14","DocumentReasonId":"00000000-0000-0000-0000-000000000000"}]}}';

    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{CAFGetDocumentsforCase_IH_v1.INTEGRATION_SERVICE_NAME});
    }

    @isTest static void testPositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));

        Test.startTest();

        CAFGetDocumentsforCase_Resp_IB_v1 responseBean = callHandlerMethod();
        System.assertEquals(200, responseBean.statusCode);

        Test.stopTest();
    }

    private static CAFGetDocumentsforCase_Resp_IB_v1 callHandlerMethod() {
        CAFGetDocumentsforCase_Req_IB_v1 dummyBean = CAFGetDocumentsforCase_Req_IB_v1.createDummyRequest();
        CAFGetDocumentsforCase_Resp_IB_v1 responseBean = CAFGetDocumentsforCase_IH_v1.bcmsGenerateDocumentforcasev1data(dummyBean.GetDocumentsForCase.id);
        return responseBean;
    }
}