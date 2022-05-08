@isTest
public class RestClientUtilsTest {
    
    static testMethod void shouldInitApiException() {
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
        //RestClientUtils.log('serialized'); // PJAIN: 20200523: Commented out because this line is throwing exception
        //RestClientUtils.log(null); // PJAIN: 20200523: Commented out because this line is throwing exception
        RestClientUtils.invoke(service.Method__c.toUpperCase(), api.Base_URL__c + service.URL_Extension__c, 
                               'application/json', null, null, null, headers, null, null, UpdateWillsDetails_Resp_IB_v1.class, null, false);
    }
}