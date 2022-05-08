@isTest
public class AccountConfirmationTest {
	
    @isTest 
    public static void testgetDocuments(){
        
        List<Account> accountList = TestDataFactory.getPersonAccounts('lastName', 'Individual_Client', 1);
        accountList[0].LastName = 'ABSA TEST';
        accountList[0].ID_Type__pc ='SA Identity Document';
        accountList[0].ID_Number__pc='9302212347096';
        accountList[0].AccountNumber ='0000004048154875';
        accountList[0].Client_Since_Date__c = Date.today();
        insert accountList;
        
        Document_Template__c dt = new Document_Template__c();
        dt.Name = 'ABSA 6994 - Bank Account Signatories Confirmation';
        dt.Document_Type__c = 'ABSA 6994 - Bank Account Signatories Confirmation';
        dt.xml__C='<Schema><AISxMetaData><IsNCA>false</IsNCA><IsCPA>false</IsCPA><IsDigitalSignature>true</IsDigitalSignature><Language /></AISxMetaData><Main><entityName>ANDRE PETRUS</entityName><accountNumber>00000004048154875</accountNumber><fullNames>ANDRE PETRUS</fullNames><surname>BRINK</surname><IDNumber>-1443448119</IDNumber><consultantName>Himanshu Nimje</consultantName><consultantSurname>{{Account.Name}}</consultantSurname></Main></Schema>';
        insert dt;
        //new code 
        DocumentTemplateProcessor.ContextBuilder builder = new DocumentTemplateProcessor.ContextBuilder();
        Account acc = new Account();
        acc.Name = 'My Account';
        builder.add('Account', acc);
        String json = builder.serialize('{"var1" : true}');
        System.assert(json != null);
        DocumentTemplateProcessor dp = new DocumentTemplateProcessor();
        Document_Template__c d = new Document_Template__c();
        d.Template_Id__c = '12345';
        d.Name = 'Business - Client Agreement';
        d.Document_Type__c = 'Business - Client Agreement';
        insert d;
        Map<String, String> ecmFields = new Map<String, String>();
        ecmFields.put('Id', '984576564987');
        List<String> endpoints = new List<String>();
        endpoints.add(DocumentTemplateProcessor.DOCUMENT_TEMPLATE_PROCESSOR);
        IntegrationTestDataFactory.insertIntegrationSettings('Jitterbit2', endpoints);
        RestClientUtils.QueueHttpMock mock = new RestClientUtils.QueueHttpMock();
        //mock.addResponse(JSON.serialize(new CC_GenerateContentResponse()));
        mock.addResponse('{"ResponseStatus":"Success","ContentStatus":"ContentGenerated","ContentStoreToken":"101 3 ICM7 UGOLSDB22 Ent_AccountApplication59 26 A1001001A20H24B75539I7664718 A20H24B75539I766471 14 1730"}');
        Test.setMock(HttpCalloutMock.class, mock);
        
        
        List<Case> caseList = TestDataFactory.getCases('Service_Request', 1);
        caseList[0].Subject = 'TESTCASE123';
        
        Date sla = Date.today().addDays(15);
        caseList[0].External_SLA_End_Date__c = sla;
        caseList[0].AccountId = accountList[0].Id;
        insert caseList;
        
        //Rest Client Test Data 
        RestClientUtils.ApiException ex = new RestClientUtils.ApiException(
            500, 'Server error', null, 'There was a server error'
        );
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"test": ["test1", "test2", "test3", "test4", "test5"]}');
        res.setStatusCode(200);
        
        RestClientUtils.processResponse(res, null);
        System.assert(ex != null);
        System.assert(ex.getStatusCode() == 500);
        RestClientUtils.processResponse(res, String.class);
        RestClientUtils.processResponse(res, Blob.class);
        RestClientUtils.processResponse(res, HotDocsToken.class);
        List<String> endpoints0 = new List<String>();
        endpoints0.add('Impressions Create AuthenticationIntent');
        endpoints0.add('Impressions CreateInlineSignatureWorkflow');
        endpoints0.add('Impressions CreatePDFSignatureRequestEvent');
        endpoints0.add('Impressions CreateSignatureWorkflow');
        endpoints0.add('Impressions GetViewLink');
        endpoints0.add('Impressions SignatureAuditTrail RequestId');
        endpoints0.add('Impressions SignatureAuditTrail Workflow');
        endpoints0.add('Impressions SignatureAuditTrailAndDocumentByRequestId');
        IntegrationTestDataFactory.insertIntegrationSettings('Impressions', endpoints0);
        String body = '{"LoginResult" : {"Status" : "OK", "Details" : "null"}, "Token" : "1234567890"}';
        
        Integration_API__c api = Sys_Utilities_Integration.getMultipleIntegrationSettings('Impressions', Sys_Utilities_General.getEnvironment(), '');
        Integration_Service__c service = api.Integration_Services__r.get(0);
        Map<String, String> form = new Map<String, String>();
        form.put('client_id', 'clientId');
        form.put('client_secret', 'clientSecret');
        form.put('grant_type', 'client_credentials');
        form.put('scope', 'TemplateHubAPI TemplateHubPermissionsAPI AnswersHubAPI UserAdminAPI TemplateHubTenancyResolver');
        Map<String, String> headers = HotDocs_IH_v1.getDefaultAuthHeaders(api);
        List<String> contentTypes = new List<String>();
        contentTypes.add('application/x-www-form-urlencoded');
        RestClientUtils.createRequest(StringConstants.HTTP_POST_STRING, api.Base_URL__c + '/' + service.URL_Extension__c, null, null, form, null, headers, null, contentTypes);
        List<String> contentTypes2 = new List<String>();
        contentTypes2.add('application/json');
        RestClientUtils.createRequest(StringConstants.HTTP_POST_STRING, api.Base_URL__c + '/' + service.URL_Extension__c, null, null, form, null, headers, null, contentTypes2);
        RestClientUtils.ApiException ap = new RestClientUtils.ApiException();
        ap.getBody();
        ap.getStatusCode();
        ap.getStatus();
        ap.getHeaders();
        RestClientUtils.RequestBuilder rr = new RestClientUtils.RequestBuilder();
        rr.method(StringConstants.HTTP_POST_STRING);
        rr.path(StringConstants.HTTP_POST_STRING);
        rr.body(ap.getBody());
        rr.queryParams(null);
        rr.form(null);
        rr.pathParams(null);
        rr.headers(null) ;
        rr.accepts(null);
        rr.contentTypes(null);
        rr.returnType(null);
        rr.responseHandler(null);
        rr.log(true);
        rr.api('String api');
        rr.service('String service');
        rr.header('String header', 'String value');
        rr.pathParam('String pathParam', 'String value');
        RestClientUtils.QueueHttpMock q= new RestClientUtils.QueueHttpMock();
        q.addResponse(res);
        q.addResponse('String(res)');
        q.addResponse('response', 1, 'application/json');
        HttpRequest httpRequest = new httpRequest();
        q.respond(httpRequest);
        RestClientUtils.LoggingQueueable lq = new RestClientUtils.LoggingQueueable();
        RestClientUtils.LoggingQueueable lq2 = new RestClientUtils.LoggingQueueable('string');
        lq.log='a string';
        System.debug('Case Id --------> '+  caseList[0].Id);        
        Test.startTest();
        AccountConfirmation.getDocument(accountList[0].Id,'00000001234567892','ABSA 6994 - Bank Account Signatories Confirmation', caseList[0].Id , '1234' , 'CQ');
        Test.stopTest();
    } 
}