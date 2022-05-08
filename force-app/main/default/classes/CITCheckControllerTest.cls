/**
 * @description       : 
 * @author            : muvhuso.nekhubvi@absa.africa
 * @last modified on  : 2021-08-10
 * @last modified by  : muvhuso.nekhubvi@absa.africa
**/
@isTest
public class CITCheckControllerTest {

    public static final String POSITIVE_RESPONSE_BODY = '{"userId": "abmnabd","agentId": "7073","payloadObj": {"id":"7073","agentId":"7073","agentStatus":"AGENT_NOT_READY","auxCode":"100","eventType":"connectionEstablished","disconnectConn":"","activeConnections":[{"connectionId":"9737","ucId":"00001097371603886266","ans":"1001035","dnIs":"0714476653","connectionStatus":"connectionEstablished","attachedData":"","customerName":"UNKNOWN","customerId":"UNKNOWN","cellNumber":"UNKNOWN","sbuSegment":"UNKNOWN","methodLastUsed":null,"sessionId":"6121f088-888a-461d-ab9e-eec4b2c9e1bf","transferReason":"","freespeech":{"description":"CALLER_NOT_ENROLLED","progression":"0.0","segmentId":"","responseDTO":null,"verifyResponseDTO":null},"sureCheck":{"status":"","description":""},"progression":null,"originator":"1001035","servicingCif":"NA","currentEvent":true,"authentication":{"identified":false,"verified":false,"authenticationType":[]},"cifs":[]}]},"errors": false,"errorList": []}rcStmtRef":null,"trgAcc":null,"trgAccType":null,"trgClrCode":"0","trgInstCode":null,"trgStmtRef":null,"trgBusinessCode":null,"clientType":null,"payDay":"0","doType":null,"freeBankInd":null,"priNo":"0","mandNo":"0","timeRange":null,"creditTrack":null,"iipAllowInd":null,"lastMaintDate":"0","lastMaintTell":null},{"cifKey":null,"tieb":"0","instrType":null,"instrNo":"0","multiNo":"0","uniqueEft":null,"instrStatus":null,"ivrNominate":"0","intExtBenInd":null,"actDate":"0","startDate":"0","endDate":"0","freq":null,"amount":"0","instrRefName":null,"srcAcc":null,"srcAccType":null,"srcClrCode":"0","srcInstCode":null,"srcStmtRef":null,"trgAcc":null,"trgAccType":null,"trgClrCode":"0","trgInstCode":null,"trgStmtRef":null,"trgBusinessCode":null,"clientType":null,"payDay":"0","doType":null,"freeBankInd":null,"priNo":"0","mandNo":"0","timeRange":null,"creditTrack":null,"iipAllowInd":null,"lastMaintDate":"0","lastMaintTell":null}],"tacAccCount":"0"}}}}';

    @TestSetup
    static void makeData(){

     }

    @isTest 
    public static void testPositiveCTI(){
        IntegrationTestDataFactory.insertIntegrationSettings(ChewyAgentStatus_IH_v1.INTEGRATION_SERVICE_NAME, new List<String>{ChewyAgentStatus_IH_v1.INTEGRATION_SERVICE_NAME});

        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));

        Test.startTest();

        String results = CITCheckController.verificationCheck();
        System.assertNotEquals(results, null,'Results should not be null');
 
        Test.stopTest();  
    }
    
    @isTest 
    public static void testCTI(){
        final String POSITIVE_LOOKUP_RESPONSE_BODY = '{"abNumber":"EXTC150","name":"","agentId":"7072","pin":"1234","initState":"MANUAL_IN"}';

        IntegrationTestDataFactory.insertIntegrationSettings(ChewyAgentLookup_IH_v1.INTEGRATION_API_NAME, new List<String>{ChewyAgentLookup_IH_v1.INTEGRATION_SERVICE_NAME});

        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_LOOKUP_RESPONSE_BODY));

        Test.startTest();

        String results = CITCheckController.verificationCheck();
        System.assertEquals(results, null);

        Test.stopTest();
    }
}