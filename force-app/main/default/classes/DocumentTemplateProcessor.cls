/**
 * @description A class to handle template generating of document generation process.
 *
 * @author
 * @version
 * @since
 * @updated Danie Booysen 2021-04-09
 */
public class DocumentTemplateProcessor {
	public final static String DOCUMENT_TEMPLATE_PROCESSOR = 'Document Template Processor';

	/**
	 * @description Inner class for context builder structure
	 */
	public class ContextBuilder {
		Request req = new Request();

		/**
		 * @author
		 * @description add a key-value pair to a map to replace the key with the value
		 * @param name - the key
		 * @param variable - the value to replace the key
		 */
		public void add(String name, Object variable) {
			if (req.context == null) {
				req.context = new Map<String, Object>();
			}
			req.context.put(name, variable);
		}

		/**
		 * @author
		 * @description Method processes a document template
		 * @param template - the request template
		 * @return String - the serialized request structure
		 */
		public String serialize(String template) {
			req.template = template;
			return JSON.serialize(req);
		}
	}

	/**
	 * @description Inner class to define the Request structure
	 */
	public class Request {
		String template;
		Map<String, Object> context;
		//Boolean encoded;
	}

	/**
	 * @description Inner class to define the Response structure
	 */
	public class Response {
		String text;
		Integer responseCode;
		String message;
	}

	/**
	 * @author
	 * @description Method processes a document template
	 * @param body - String of the template
	 * @return String - the processed document
	 */
	public String processTemplate(String body) {
		Map<String, String> headers = new Map<String, String>();
		headers.put('Content-Type', 'application/json;charset=UTF-8');
		Integration_API__c api = Sys_Utilities_Integration.getMultipleIntegrationSettings(
			StringConstants.JITTERBIT2,
			Sys_Utilities_General.getEnvironment(),
			DOCUMENT_TEMPLATE_PROCESSOR
		);
		System.debug('Integration_API__c : ' + api.Integration_Services__r.get(0));
		Integration_Service__c service = api.Integration_Services__r.get(0);
		return (String) RestClientUtils.builder() //
			.method(StringConstants.HTTP_POST_STRING) //
			.path(api.Base_URL__c + service.URL_Extension__c) //
			.body(body) //
			.headers(headers) //
			.returnType(String.class) //
			.log(true) //
			.invoke();
	}

	/**
	 * @author
	 * @description Method generating the document via a service call
	 * @param builder - instance of ContextBuilder
	 * @param t - the Document_Template__c record
	 * @param ecmFields - Map<String, String> ecm request fields param and value
	 * @return CC_GenerateContentResponse
	 */
	public CC_GenerateContentResponse generateDocument(ContextBuilder builder, Document_Template__c t, Map<String, String> ecmFields) {
		//Document_Template__c t = new DocumentTemplateSelector().selectTemplateByName(name);
		String serialized = builder.serialize(t.XML__c);
		System.debug('XML Logging --------->' + serialized);
		String processed = processTemplate(serialized);
		System.debug('XML Processed ----------------->' + processed);
		CC_GenerateContentRequest req = fromTemplate(t, ecmFields);
		System.debug('Request Logging --------->' + req);
		req.templateData = processed;
		System.debug('Request Logging After --------->' + req);
		System.debug('>>>>>>>>> After request & processing >>>>>>>>>>>>>>>>>>>>>>>>>>>>');
		System.debug(processed);
		if (!Test.isRunningTest()) {
			return CC_ContentService_IH_v1.generateContent(req);
		}
		return null;
	}

	/**
	 * @author
	 * @description Method generating formatting the request in a structure
	 * @param t - the Document_Template__c record
	 * @param contentStoreFields - Map<String, String> ecm request fields param and value
	 * @return CC_GenerateContentRequest
	 */
	private CC_GenerateContentRequest fromTemplate(Document_Template__c t, Map<String, String> contentStoreFields) {
		CC_GenerateContentRequest r = new CC_GenerateContentRequest();
		r.fileName = t.Name + '.pdf';
		r.returnEmptyContent = true;
		r.templateID = t.Template_Id__c;
		r.templateDataType = 'XML';
		r.recordSystemFeedbackID = '123';
		r.logLevel = 'Debug';
		r.encodingType = 'Base64';
		r.contentRequestType = 'PDF';
		r.contentStoreType = 'ECM';
		if (contentStoreFields == null) {
			contentStoreFields = new Map<String, String>();
		}
		for (String key : contentStoreFields.keySet()) {
			if (key != 'password') {
				r.addContentParam(key, contentStoreFields.get(key));
			}
		}
		if (contentStoreFields.containsKey('password')) {
			r.password = contentStoreFields.get('password');
		}
		return r;
	}
}