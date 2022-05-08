/*
 * Developed by Tinashe Shoko
 */
@isTest(SeeAllData=true)
public class MerchantAppParentControllerShareTest {
    static testMethod void sendDocumentSharingEmail() {

        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        //ECM_IH_V1Test.insertSettings();
        List<String> endpoints = new List<String>();
        endpoints.add('Impressions Create AuthenticationIntent');
        endpoints.add('Impressions CreateInlineSignatureWorkflow');
        endpoints.add('Impressions CreatePDFSignatureRequestEvent');
        endpoints.add('Impressions CreateSignatureWorkflow');
        endpoints.add('Impressions GetViewLink');
        endpoints.add('Impressions SignatureAuditTrail RequestId');
        endpoints.add('Impressions SignatureAuditTrail Workflow');
        endpoints.add('Impressions SignatureAuditTrailAndDocumentByRequestId');
        IntegrationTestDataFactory.insertIntegrationSettings('Impressions', endpoints);

        String body = '{"LoginResult" : {"Status" : "OK", "Details" : "null"}, "Token" : "1234567890"}';
        Test.setMock(HttpCalloutMock.class, new ECM_Mock_ApiRest(body));
        set<id> ids = new set<id>();
        ids.add(testDataFactory.testDocument.id);
        String jsonString = JSON.serialize(ids);

        Test.startTest();
        Map <String, Schema.RecordTypeInfo> applicationRecordTypeMap = Application__c.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
        Application__c application = new Application__c();
        application.RecordTypeId = applicationRecordTypeMap.get('Wills').getRecordTypeId();
        application.Opportunity__c = testDataFactory.testOpportunity.Id;
        application.Preferred_Email__c = 'clientEmail@123.com';
        try {
            insert application;
        } catch(DmlException e) {
            System.debug('An unexpected error has occurred: ' + e.getMessage());
        }

        List<List<string>> testList = DocumentsShareControllerESign.getDocumentsContent(jsonString);
        MerchantApplicationParentController.sendDocumentSharingEmail(testDataFactory.testOpportunity.Id);
        system.assertNotEquals(0, testList.size());
        Test.stopTest();
    }


    public class ECM_Mock_ApiRest implements HttpCalloutMock {

        public String body { get; set; }

        public ECM_Mock_ApiRest() {}

        public ECM_Mock_ApiRest(String body) {
            this.body = body;
        }

        public HTTPResponse respond(HTTPRequest request) {
            HTTPResponse response = new HTTPResponse();
            response.setStatusCode(200);
            response.setBody(body);
            response.setHeader('Content-Type', 'application/json');
            return response;
        }
    }
}