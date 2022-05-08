@isTest
public class Impressions_IH_v1Test {
    public static testMethod void testAll() {
        test.startTest();
        ImpressionToken__c cs = new ImpressionToken__c (Name='Test_CS');
        insert cs;
        Impressions_IH_v1 ih = new Impressions_IH_v1();

        List<String> endpoints = new List<String>();
        endpoints.add('Impressions Create AuthenticationIntent');
        endpoints.add('Impressions CreateInlineSignatureWorkflow');
        endpoints.add('Impressions CreatePDFSignatureRequestEvent');
        endpoints.add('Impressions CreateSignatureWorkflow');
        endpoints.add('Impressions GetViewLink');
        endpoints.add('Impressions SignatureAuditTrail RequestId');
        endpoints.add('Impressions SignatureAuditTrail Workflow');
        endpoints.add('Impressions SignatureAuditTrailAndDocumentByRequestId');
        IntegrationTestDataFactory.insertIntegrationSettings('API MAnager', endpoints);
        String body = '{"LoginResult" : {"Status" : "OK", "Details" : "null"}, "Token" : "1234567890"}';
        Test.setMock(HttpCalloutMock.class, new ECM_Mock_ApiRest(body));
        ih.createAuthenticationIntent ('signatureRequestId');
        ih.getSignatureAuditTrailByWorkflowId('wfid');
        ih.getSignatureAuditTrailByRequestId ( 'requestId');
        ih.getSignatureAuditTrailAndDocumentByRequestId ( 'requestId');
        ih.removePDFSignatureRequestEvent ( 'signaturerequestid');
        ih.createInlineSignatureWorkflow (new Impressions_Model.CreateInlinePDFSignatureRequestEventInput());
        test.stopTest();
    }
    
    public static testMethod void testAll2() {
        test.startTest();
        ImpressionToken__c cs = new ImpressionToken__c (Name='Test_CS');
        insert cs;
        Impressions_IH_v1 ih = new Impressions_IH_v1();
        List<String> endpoints = new List<String>();
        endpoints.add('Impressions Create AuthenticationIntent');
        endpoints.add('Impressions CreateInlineSignatureWorkflow');
        endpoints.add('Impressions CreatePDFSignatureRequestEvent');
        endpoints.add('Impressions CreateSignatureWorkflow');
        endpoints.add('Impressions GetViewLink');
        endpoints.add('Impressions SignatureAuditTrail RequestId');
        endpoints.add('Impressions SignatureAuditTrail Workflow');
        endpoints.add('Impressions SignatureAuditTrailAndDocumentByRequestId');
        IntegrationTestDataFactory.insertIntegrationSettings('API MAnager', endpoints);
        String body = '{"LoginResult" : {"Status" : "OK", "Details" : "null"}, "Token" : "1234567890"}';
        Test.setMock(HttpCalloutMock.class, new ECM_Mock_ApiRest(body));
        ih.getViewLink ('requestId');
        test.stopTest();
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