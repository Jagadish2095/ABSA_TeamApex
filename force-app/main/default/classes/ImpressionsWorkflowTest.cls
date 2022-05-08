@isTest(SeeAlldata=true)
public class ImpressionsWorkflowTest {
    private static testmethod void testAll2() {
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        Opportunity testOpportunity = testDataFactory.testOpportunity;
        Impressions_Model.Signatory signatory = new Impressions_Model.Signatory();
        signatory.title = 'Mr'; 
        signatory.surname = 'Shoko';
        signatory.email = 'tedst@123.com';
        signatory.mobile = '0110110101';
        Impressions_Model.CustomSignatoryOptions custom = new Impressions_Model.CustomSignatoryOptions();
        custom.challenge = 'Absa Merchant OnBoarding: You are responding to a merchant proposal/application. \n Please select \n1-Accept\n9-Reject';
        signatory.custom = custom;
        List<Impressions_Model.Signatory> signatories = new List<Impressions_Model.Signatory>();
        signatories.add(signatory);
        
        String[] signatureRequests = new String[]{'123465'};
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

        test.startTest();
        ImpressionRequest__c req = new ImpressionRequest__c(RequestId__c='12345', completed__c=false, Document__c=testDataFactory.testDocument.id);
        insert req;
        SignatureRequest__c src = new SignatureRequest__c(impressionRequestID__C='12345', step__c=1,signatureId__c='12345', Processed__c=false);
        insert src;
        SignatureRequest__c src2 = new SignatureRequest__c(impressionRequestID__C='12345', step__c=2,signatureId__c='12345', Processed__c=false);
        insert src2;
        ImpressionsWorkflow.start('12345');
        ImpressionsWorkflow.start('test@123.com', new Map<String, String>{'a' => 'b', 'c' => 'd'});
        ImpressionsWorkflow.updateWf(src.signatureId__c, testDataFactory.testDocument.id);
        ImpressionsWorkflow.sendEmail(new String[]{'123465'},  new Map<String, String>{'a' => 'b', 'c' => 'd'});
        ImpressionsWorkflow.refresh(req.RequestId__c);
        SignatureRequest__c req2 = [SELECT Id, impressionRequestID__C, signatureId__c, Processed__c FROM SignatureRequest__c WHERE signatureId__c = :src.signatureId__c LIMIT 1];
        System.assertEquals(true, req2.processed__c);
        test.stopTest();
    }

    private static testmethod void testAll() {
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        Opportunity testOpportunity = testDataFactory.testOpportunity;
        Impressions_Model.Signatory signatory = new Impressions_Model.Signatory();
        signatory.title = 'Mr';
        signatory.surname = 'Shoko';
        signatory.email = 'tedst@123.com';
        signatory.mobile = '0110110101';
        Impressions_Model.CustomSignatoryOptions custom = new Impressions_Model.CustomSignatoryOptions();
        custom.challenge = 'Absa Merchant OnBoarding: You are responding to a merchant proposal/application. \n Please select \n1-Accept\n9-Reject';
        signatory.custom = custom;
        List<Impressions_Model.Signatory> signatories = new List<Impressions_Model.Signatory>();
        signatories.add(signatory);
        
        String[] signatureRequests = new String[]{'123465'};
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

        test.startTest();
        ImpressionsController.createImpressionRequest('workflowId', testDataFactory.testDocument.id, testOpportunity.Id, signatureRequests, signatories);
        ImpressionRequest__c req = new ImpressionRequest__c(RequestId__c='12345', completed__c=false, Document__c=testDataFactory.testDocument.id);
        insert req;
        SignatureRequest__c src = new SignatureRequest__c(impressionRequestID__C='12345', step__c=1,signatureId__c='12345', Processed__c=false);
        insert src;
        testDataFactory.testDocument.Opportunity__c = testOpportunity.Id;
        update testDataFactory.testDocument;
        ImpressionsController.updateImpressionRequests(testOpportunity.Id);
        ImpressionsController.sendReminder('12345');
        List<ImpressionRequest__c> impressionRequests = [SELECT Id, RequestId__c, completed__c, Opportunity__c, Document__c FROM ImpressionRequest__c WHERE Opportunity__c = :testOpportunity.Id AND completed__c = true];
        system.assert(impressionRequests.size() > 0);
        test.stopTest();
    }

    private static testmethod void testSendForSigningSignatory() {
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        Opportunity testOpportunity = testDataFactory.testOpportunity;
        Impressions_Model.Signatory signatory = new Impressions_Model.Signatory();
        signatory.title = 'Mr';
        signatory.surname = 'Shoko';
        signatory.email = 'tedst@123.com';
        signatory.mobile = '0110110101';
        Impressions_Model.CustomSignatoryOptions custom = new Impressions_Model.CustomSignatoryOptions();
        custom.challenge = 'Absa Merchant OnBoarding: You are responding to a merchant proposal/application. \n Please select \n1-Accept\n9-Reject';
        signatory.custom = custom;
        List<Impressions_Model.Signatory> signatories = new List<Impressions_Model.Signatory>();
        signatories.add(signatory);
        
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
        
        test.startTest();
        String ss = ImpressionsController.sendForSigning(signatories, 'String document', testDataFactory.testDocument.id);
        test.stopTest();
    }
    
    private static testmethod void testSendForSigningWrapper() {
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        Opportunity testOpportunity = testDataFactory.testOpportunity;
        Impressions_Model.Signatory signatory = new Impressions_Model.Signatory();
        signatory.title = 'Mr';
        signatory.surname = 'Shoko';
        signatory.email = 'tedst@123.com';
        signatory.mobile = '0110110101';
        Impressions_Model.CustomSignatoryOptions custom = new Impressions_Model.CustomSignatoryOptions();
        custom.challenge = 'Absa Merchant OnBoarding: You are responding to a merchant proposal/application. \n Please select \n1-Accept\n9-Reject';
        signatory.custom = custom;
        List<Impressions_Model.Signatory> signatories = new List<Impressions_Model.Signatory>();
        signatories.add(signatory);
        
        Impressions_Model.SignatoryWrapper wrapper = new Impressions_Model.SignatoryWrapper();
        wrapper.title = signatory.title;
        wrapper.surname = signatory.surname;
        wrapper.mobile = signatory.mobile;
        wrapper.email = signatory.email;
        wrapper.method = 'Realtime';
        wrapper.index = 1;
        wrapper.signatory = signatory;
        List<Impressions_Model.SignatoryWrapper> wrappers = new List<Impressions_Model.SignatoryWrapper>();   
        wrappers.add(wrapper);
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
        
        test.startTest();
        String sss = ImpressionsController.sendForSigning(wrappers, 'String document', testDataFactory.testDocument.id);
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