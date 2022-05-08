/**
 * @description       : 
 * @author            : muvhuso.nekhubvi@absa.africa
 * @last modified on  : 2021-08-23
 * @last modified by  : muvhuso.nekhubvi@absa.africa
**/
@isTest(SeeAllData = true)
public class DocumentsShareControllerESignTestEmail{
	@isTest
	static void sendDocumentSharingEmail(){

		WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
		//ECM_IH_V1Test.insertSettings();
		//
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
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new sMgetAsVbondsV1_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API, new list < String > {
        StringConstants.SM_GET_ASV_BONDS_V1
        });
		Test.startTest();
		Map<String, Schema.RecordTypeInfo> applicationRecordTypeMap = Application__c.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
		Application__c application = new Application__c();
		application.RecordTypeId = applicationRecordTypeMap.get('Wills').getRecordTypeId();
		application.Opportunity__c = testDataFactory.testOpportunity.Id;
		application.Preferred_Email__c = 'clientEmail@123.com';
		
	    insert application;

		List<List<string>> testList = DocumentsShareControllerESign.getDocumentsContent(jsonString);
		DocumentsShareControllerESign.sendDocumentSharingEmail(testDataFactory.testOpportunity.Id, 'test@123.com', jsonString);
		system.assertNotEquals(0, testList.size());
		Test.stopTest();
	}

    /**
     * @description ECM_Mock_ApiRest Description
     *
     */
	public class ECM_Mock_ApiRest implements HttpCalloutMock{
/**
 * @description
 */
        public String body{ get; set; }
/**
 * @description ECM_Mock_ApiRest description
 *
 */
		public ECM_Mock_ApiRest(){
		}
/**
 * @description ECM_Mock_ApiRest description
 *
 * @param body (String): body
 */
		public ECM_Mock_ApiRest(String body){
			this.body = body;
		}
/**
 * @description respond description
 *
 * @param request (HTTPRequest): request
 * @return HTTPResponse: Return description
 */
		public HTTPResponse respond(HTTPRequest request){
			HTTPResponse response = new HTTPResponse();
			response.setStatusCode(200);
			response.setBody(body);
			response.setHeader('Content-Type', 'application/json');
			return response;
		}
	}
}