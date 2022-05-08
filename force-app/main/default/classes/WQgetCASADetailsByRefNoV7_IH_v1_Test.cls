@isTest
public class WQgetCASADetailsByRefNoV7_IH_v1_Test {
    
    public static final String POSITIVE_RESPONSE_BODY = '{"WQgetCASADetailsByRefNoV7Response": {"approvedSts": null,"clientTypeGrp": "N","cntryOfRes": "SO003","countryOfBirth": null,"dateTime": null,"dob": 0,"documentSts": "C","firstName": null,"idRegNo": 200801284907,"idType": 5,"msg": null,"msgNo": 0,"nationality": "SOU01","noParticipants": 2,"pepSts": null,"primaryClient": 0,"relatedParties": [{"rApprovedSts": null,"rClientTypeGrp": "I","rCntryOfRes": "SO003","rCountryOfBirth": "SO003","rDob": 19911222,"rFirstName": "LEDIKE EPHRAIM","rIdRegNo": 9112225706088,"rIdType": 1,"rNationality": "SOU01","rPepSts": null,"rRefNo": 121116974,"rRelationship": 111222,"rStatus": "C","rSurnameComp": "MAHLARE"},{"rApprovedSts": null,"rClientTypeGrp": "I","rCntryOfRes": "SO003","rCountryOfBirth": "SO003","rDob": 19830525,"rFirstName": "QUINTIN","rIdRegNo": 8305255026085,"rIdType": 1,"rNationality": "SOU01","rPepSts": null,"rRefNo": 121116975,"rRelationship": 210305,"rStatus": "C","rSurnameComp": "STANDER" }],"riskRequired": "Y","sbu": "H","status": "C","surnameComp": "MAINSAIL TRADING 136 (PTY) LTD"}}';
    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{WQgetCASADetailsByRefNoV7_IH_v1.INTEGRATION_SERVICE_NAME});

        Contact testContact;
        testContact = new Contact();
        testContact.FirstName = 'Test';
        testContact.LastName = 'Contact';
        testContact.Title = 'Mr.';
        testContact.Salutation = 'Mr.';
        testContact.ID_Type__c = 'SA Identity Document';
        insert testContact;
    }

    @isTest static void testPositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));

        Test.startTest();

        WQgetCASADetailsByRefNoV7_Resp_IB_v1 responseBean = callHandlerMethod();
        System.assertEquals(200, responseBean.statusCode);

        Test.stopTest();
    }

    private static WQgetCASADetailsByRefNoV7_Resp_IB_v1 callHandlerMethod() {
        WQgetCASADetailsByRefNoV7_Req_IB_v1 dummyReqBean = WQgetCASADetailsByRefNoV7_Req_IB_v1.createDummyRequest();
        WQgetCASADetailsByRefNoV7_Resp_IB_v1 dummyBean = WQgetCASADetailsByRefNoV7_Resp_IB_v1.createDummyResponse();
        
        WQgetCASADetailsByRefNoV7_Resp_IB_v1 responseBean = WQgetCASADetailsByRefNoV7_IH_v1.getRelatedPartyListByPrimaryRefNo('11111');
        return responseBean;
    }

}