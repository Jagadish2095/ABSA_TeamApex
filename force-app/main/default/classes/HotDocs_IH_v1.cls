/**
 * @description An integration handler for HotDocs services.
 */
public class HotDocs_IH_v1 {
	
	private static String AUTHENTICATION_SCOPE = 'TemplateHubAPI TemplateHubPermissionsAPI AnswersHubAPI UserAdminAPI TemplateHubTenancyResolver';
	private static final String AUTHENTICATION_GRANT_TYPE = 'client_credentials';
	private static final String AUTHENTICATION_PATH = 'HotDocs Authentication';
	private static final String CREATE_ANSWERSET_PATH = 'HotDocs Create Answerset Path';
	private static final String GET_ANSWERSET_PATH = 'HotDocs Get Answerset Path';
	private static final String SESSION_PATH = 'HotDocs Interview Session';
	//private static final String BASE_PATH = 'https://esb.ext.api.uat.absa.co.za/enterprise-ext-uat/ext/';
	private static final String ONPREMISE_INTERVIEW_PATH = 'HotDocs Get Onpremise Interview';
    private static final String INTERVIEW_BASE_PATH = 'HotDocs Interview Base Path';
    private static final String GET_WORK_ITEM = 'HotDocs Get Work Item';
    private static final String GET_DOCUMENT = 'HotDocs Get Document';
    private static final String GET_DOCUMENT_METADATA = 'HotDocs Get Document Metadata';
	
	//createRequest(method, path, body, query, form, pathParams, headers, accepts, contentTypes)
	public static HotDocsToken authenticate(String clientId, String clientSecret) {
        Integration_API__c api = Sys_Utilities_Integration.getMultipleIntegrationSettings(StringConstants.API_MANAGER, Sys_Utilities_General.getEnvironment(), AUTHENTICATION_PATH);
        Integration_Service__c service = api.Integration_Services__r.get(0);
		Map<String, String> form = new Map<String, String>();
		form.put('client_id', clientId);
		form.put('client_secret', clientSecret);
		form.put('grant_type', AUTHENTICATION_GRANT_TYPE);
		form.put('scope', AUTHENTICATION_SCOPE);
		Map<String, String> headers = getDefaultAuthHeaders(api);
		List<String> contentTypes = new List<String>();
		contentTypes.add('application/x-www-form-urlencoded');
		HttpRequest request = RestClientUtils.createRequest(StringConstants.HTTP_POST_STRING, api.Base_URL__c + '/' + service.URL_Extension__c, null, null, form, null, headers, null, contentTypes);
		HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);
		return (HotDocsToken) RestClientUtils.processResponse(response, HotDocsToken.class);
	}
	
	public static String getInterviewSession(String token, String templateId, String answerSetId) {
        Integration_API__c api = Sys_Utilities_Integration.getMultipleIntegrationSettings(StringConstants.API_MANAGER, Sys_Utilities_General.getEnvironment(), SESSION_PATH);
        Integration_Service__c service = api.Integration_Services__r.get(0);
		Map<String, String> params = new Map<String, String>();
		params.put('templateid', templateId);
		params.put('answersetid', answerSetId);
		Map<String, String> headers = new Map<String, String>();
		headers.putAll(getDefaultAuthHeaders(api));
		headers.put('Authorization', 'Bearer ' + token);
		HttpRequest request = RestClientUtils.createRequest(StringConstants.HTTP_POST_STRING, api.Base_URL__c + '/' + service.URL_Extension__c, null, params, null, null, headers, null, null);
		HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);
		return (String) RestClientUtils.processResponse(response, String.class);
	}
	
	public static HotDocsAnswerSet addAnswerSet(String token, String answerSet) {
        Integration_API__c api = Sys_Utilities_Integration.getMultipleIntegrationSettings(StringConstants.API_MANAGER, Sys_Utilities_General.getEnvironment(), CREATE_ANSWERSET_PATH);
        Integration_Service__c service = api.Integration_Services__r.get(0);
		Map<String, String> headers = new Map<String, String>();
		headers.putAll(getDefaultAuthHeaders(api));
		headers.put('Authorization', 'Bearer ' + token);
		HttpRequest request = RestClientUtils.createRequest(StringConstants.HTTP_POST_STRING, api.Base_URL__c + '/' + service.URL_Extension__c, answerSet, null, null, null, headers, null, null);
		HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);
		return (HotDocsAnswerSet) RestClientUtils.processResponse(response, HotDocsAnswerSet.class);
	}
	
	public static String getAnswerSet(String token, String answerSetId) {
        Integration_API__c api = Sys_Utilities_Integration.getMultipleIntegrationSettings(StringConstants.API_MANAGER, Sys_Utilities_General.getEnvironment(), GET_ANSWERSET_PATH);
        Integration_Service__c service = api.Integration_Services__r.get(0);
		Map<String, String> headers = new Map<String, String>();
		headers.putAll(getDefaultAuthHeaders(api));
		headers.put('Authorization', 'Bearer ' + token);
		Map<String, String> pathParams = new Map<String, String>();
		pathParams.put('answerSetId', answerSetId);
		HttpRequest request = RestClientUtils.createRequest(StringConstants.HTTP_GET_STRING, api.Base_URL__c + '/' + service.URL_Extension__c, '', null, null, pathParams, headers, null, null);
		HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);
		return (String) RestClientUtils.processResponse(response, String.class);
	}
	
	public static HotDocsWorkItem getWorkItem(String token, String workItemId) {
        Integration_API__c api = Sys_Utilities_Integration.getMultipleIntegrationSettings(StringConstants.API_MANAGER, Sys_Utilities_General.getEnvironment(), GET_WORK_ITEM);
        Integration_Service__c service = api.Integration_Services__r.get(0);
		Map<String, String> headers = new Map<String, String>();
		headers.putAll(getDefaultAuthHeaders(api));
		headers.put('Authorization', 'Bearer ' + token);
		Map<String, String> pathParams = new Map<String, String>();
		pathParams.put('workItemId', workItemId);
		HttpRequest request = RestClientUtils.createRequest(StringConstants.HTTP_GET_STRING, api.Base_URL__c + '/' + service.URL_Extension__c, '', null, null, pathParams, headers, null, null);
		HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);
		return (HotDocsWorkItem) RestClientUtils.processResponse(response, HotDocsWorkItem.class);
	}
	
	public static Blob getDocument(String token, String workItemId, String documentId) {
        Integration_API__c api = Sys_Utilities_Integration.getMultipleIntegrationSettings(StringConstants.API_MANAGER, Sys_Utilities_General.getEnvironment(), GET_DOCUMENT);
        Integration_Service__c service = api.Integration_Services__r.get(0);
		Map<String, String> headers = new Map<String, String>();
		headers.putAll(getDefaultAuthHeaders(api));
		headers.put('Authorization', 'Bearer ' + token);
		Map<String, String> pathParams = new Map<String, String>();
		pathParams.put('documentId', documentId);
		pathParams.put('workItemId', workItemId);
		HttpRequest request = RestClientUtils.createRequest(StringConstants.HTTP_GET_STRING, api.Base_URL__c + '/' + service.URL_Extension__c, '', null, null, pathParams, headers, null, null);
		HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);
		return (Blob) RestClientUtils.processResponse(response, Blob.class);
	}
	
	public static String getDocumentMetadata(String token, String workItemId, String documentId) {
        Integration_API__c api = Sys_Utilities_Integration.getMultipleIntegrationSettings(StringConstants.API_MANAGER, Sys_Utilities_General.getEnvironment(), GET_DOCUMENT_METADATA);
        Integration_Service__c service = api.Integration_Services__r.get(0);
		Map<String, String> headers = new Map<String, String>();
		headers.putAll(getDefaultAuthHeaders(api));
		headers.put('Authorization', 'Bearer ' + token);
		Map<String, String> pathParams = new Map<String, String>();
		pathParams.put('documentId', documentId);
		pathParams.put('workItemId', workItemId);
		HttpRequest request = RestClientUtils.createRequest(StringConstants.HTTP_GET_STRING, api.Base_URL__c + '/' + service.URL_Extension__c, '', null, null, pathParams, headers, null, null);
		HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);
		return (String) RestClientUtils.processResponse(response, String.class);
	}
	
	public static HotDocsConfig getHotDocsConfigs(String client) {
		Integration_API__c api = Sys_Utilities_Integration.getMultipleIntegrationSettings(StringConstants.API_MANAGER, Sys_Utilities_General.getEnvironment(), AUTHENTICATION_PATH);
        Integration_Service__c service = api.Integration_Services__r.get(0);
		System.debug('service: ' + service);
		HotDocsConfig configs = new HotDocsConfig();
		String[] usernameTemplate = service.Username__c.split('@');
		configs.clientId = usernameTemplate[0];
		configs.clientSecret = service.Password__c;
		configs.templateId = usernameTemplate[1]; //'6d6d5aaf-5b45-4da9-b3ba-16aff3f3b046';
		configs.answerSetGenerator = 'WillsHotDocsAnswerSetGenerator';
		configs.scope = 'TemplateHubAPI TemplateHubPermissionsAPI AnswersHubAPI UserAdminAPI TemplateHubTenancyResolver';		
		return configs;
	}
	
	public static Map<String, String> getDefaultAuthHeaders(Integration_API__c api) {
		Map<String, String> headers = new Map<String, String>();
		headers.put(StringConstants.X_IBM_CLIENT_ID_STRING, api.Client_ID__c);
        headers.put(StringConstants.X_IBM_CLIENT_SECRET_STRING, api.Client_Secret__c);
		return headers;
	}
	
	public static String getInterViewUrl(String session) {
		Integration_API__c api = Sys_Utilities_Integration.getMultipleIntegrationSettings(StringConstants.API_MANAGER, Sys_Utilities_General.getEnvironment(), INTERVIEW_BASE_PATH);
        Integration_Service__c service = api.Integration_Services__r.get(0);
        String basePath = service.URL_Extension__c;
        api = Sys_Utilities_Integration.getMultipleIntegrationSettings(StringConstants.API_MANAGER, Sys_Utilities_General.getEnvironment(), ONPREMISE_INTERVIEW_PATH);
        service = api.Integration_Services__r.get(0);
        session = session.replaceAll('"', '');
		return basePath + service.URL_Extension__c + session;
	}
	
	
}