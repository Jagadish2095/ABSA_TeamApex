/**
 * @description       :
 * @author            : Taras Kuliievych
 * @last modified on  : 09-02-2021
 * @last modified by  : Taras Kuliievych
**/

public with sharing class DocFusionJSONProcessor {
    /**
    * @description
    * @author Taras Kuliievych | 08-23-2021
    * @param documentTemplate
    * @param reportData
    * @param ecmFields
    * @return CC_GenerateContentResponse
    **/
    public CC_GenerateContentResponse generateEnquiryReport(Document_Template__c documentTemplate, String reportData, Map<String, String> ecmFields) {
		CC_GenerateContentRequest request = createRquest(documentTemplate, ecmFields);
		request.templateData = reportData;

		return CC_ContentService_IH_v1.generateContent(request);
	}

    /**
    * @description
    * @author Taras Kuliievych | 08-23-2021
    * @param documentTemplate
    * @param contentStoreFields
    * @return CC_GenerateContentRequest
    **/
    private CC_GenerateContentRequest createRquest(Document_Template__c documentTemplate, Map<String, String> contentStoreFields) {
		CC_GenerateContentRequest request = new CC_GenerateContentRequest();
		request.fileName = documentTemplate.Name + '.pdf';
		request.returnEmptyContent = false;
		request.templateID = documentTemplate.Template_Id__c;
		request.templateDataType = 'JSON';
		request.recordSystemFeedbackID = '123';
		request.logLevel = 'Debug';
		request.encodingType = 'Base64';
		request.responseEncodingType = 'Base64';
		request.contentRequestType = 'PDF';
		request.contentStoreType = 'NA';

		if (contentStoreFields == null) {
			contentStoreFields = new Map<String, String>();
		}
		for (String key : contentStoreFields.keySet()) {
			if (key != 'password') {
				request.addContentParam(key, contentStoreFields.get(key));
			}
		}

		return request;
	}
}