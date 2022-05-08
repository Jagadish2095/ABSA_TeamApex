/**
 * @description       :
 * @author            : muvhuso.nekhubvi@absa.africa
 * @last modified on  : 2021-11-29
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest(SeeAllData=true)
public class ImpressionsControllerTest {
    @isTest 
    static void testAll2() {
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
         // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new sMgetAsVbondsV1_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API, new list < String > {
        StringConstants.SM_GET_ASV_BONDS_V1}); 
        test.startTest();
        ImpressionRequest__c req = new ImpressionRequest__c(RequestId__c='12345', completed__c=false, Document__c=testDataFactory.testDocument.id);
        insert req;
        System.assertNotEquals(req, null,'Impression  should not be null');
 
        SignatureRequest__c src = new SignatureRequest__c(impressionRequestID__C='12345', step__c=1,signatureId__c='12345', Processed__c=false);
        insert src;
        SignatureRequest__c src2 = new SignatureRequest__c(impressionRequestID__C='12345', step__c=2,signatureId__c='12345', Processed__c=false);
        insert src2;
        ImpressionsWorkflow.start('12345');
        ImpressionsWorkflow.start('test@123.com', new Map<String, String>{'a' => 'b', 'c' => 'd'});
        ImpressionsWorkflow.updateWf(src.signatureId__c, testDataFactory.testDocument.id);
        ImpressionsWorkflow.sendEmail(new String[]{'123465'},  new Map<String, String>{'a' => 'b', 'c' => 'd'});
        ImpressionsWorkflow.refresh(req.RequestId__c);
        test.stopTest();
    }
    @isTest 
    static void testAll() {
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
         // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new sMgetAsVbondsV1_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API, new list < String > {
        StringConstants.SM_GET_ASV_BONDS_V1}); 
        test.startTest(); 
        ImpressionsController.createImpressionRequest('workflowId', testDataFactory.testDocument.id, testOpportunity.Id, signatureRequests, signatories);
        ImpressionRequest__c req = new ImpressionRequest__c(RequestId__c='12345', completed__c=false, Document__c=testDataFactory.testDocument.id);
        insert req;
        SignatureRequest__c src = new SignatureRequest__c(impressionRequestID__C='12345', step__c=1,signatureId__c='12345', Processed__c=false);
        insert src;
        System.assertNotEquals(src, null,'Signature  should not be null');

        testDataFactory.testDocument.Opportunity__c = testOpportunity.Id;
        update testDataFactory.testDocument;
        ImpressionsController.updateImpressionRequests(testOpportunity.Id);
        ImpressionsController.sendReminder('12345');
        test.stopTest();
    }

    @isTest 
    static void testSendForSigningSignatory() {
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
        System.assertNotEquals(signatories, null,'Signature  should not be null');

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
         // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new sMgetAsVbondsV1_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API, new list < String > {
        StringConstants.SM_GET_ASV_BONDS_V1}); 
        test.startTest();
        String tt = ImpressionsController.sendForSigningById(signatories, testDataFactory.testDocument.id);
        //String ss = ImpressionsController.sendForSigning(signatories, 'String document', testDataFactory.testDocument.id);
        ImpressionsController.RefreshWorkflow(tt);
        test.stopTest();
    }
    
    @isTest 
    static void testSendForSigningWrapper() {
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
        System.assertNotEquals(signatories, null,'Signature  should not be null');

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
         // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new sMgetAsVbondsV1_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API, new list < String > {
        StringConstants.SM_GET_ASV_BONDS_V1}); 
        test.startTest();
        String sss = ImpressionsController.sendForSigning(wrappers, 'String document', testDataFactory.testDocument.id);
        test.stopTest();
    }
    
    /**
     * @description 
     */
     
    public class ECM_Mock_ApiRest implements HttpCalloutMock {
    /**
     * @description 
     */
     
        public String body { get; set; }
        
    /**
     * @description 
     */
     
        public ECM_Mock_ApiRest() {}
        
        /**
        * @description 
        * @author
        * @param body 
        **/
        public ECM_Mock_ApiRest(String body) {
            this.body = body;
        }
        
        /**
        * @description 
        * @author 
        * @param request 
        * @return HTTPResponse 
        **/
        public HTTPResponse respond(HTTPRequest request) {
            HTTPResponse response = new HTTPResponse();
            response.setStatusCode(200);
            response.setBody(body);
            response.setHeader('Content-Type', 'application/json');
            return response;
        }
    }

}