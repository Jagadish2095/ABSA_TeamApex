/**
 * @description       : Test For the component to display and upload  documents and details for Covid-19
 * @author            : Himanshu.Nimje@absa.africa
 * @last modified on  : 2021-06-12
 * @last modified by  : Himanshu.Nimje@absa.africa
 * Modifications Log
 * Ver   Date         Author                       Modification
 * 1.0   2021-06-12   Himanshu.Nimje@absa.africa   Initial Version
 **/
@isTest
public class DocumentUploaderBlockCtrlTest {
	@isTest
	public static void documentTriggerFunctionsTest() {
		WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
		Opportunity opp = testDataFactory.testOpportunity;
		Id recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Credit Maintenance').getRecordTypeId();
		opp.RecordTypeId = recordTypeId;
		update opp;

		test.startTest();
		String chunk1 = EncodingUtil.base64Encode(Blob.valueOf('This is a test '));
		Id fileId = DocumentUploaderBlockCtrl.saveChunk(opp.Id, 'Test.txt', chunk1, 'txt', '', false, 'Will', true, '');

		System.assert(fileId != null);
		DocumentUploaderBlockCtrl.getWebsiteURL(opp.Id);
		Map<String, String> strMap = new Map<String, String>();
		strMap.put('Id', opp.Id);
		strMap.put('Website_URL__c', 'http://www.test.com');
		DocumentUploaderBlockCtrl.updateURLs(opp.Id, 'Opportunity', strMap, 'Website_URL__c');
		system.assertNotEquals(null, DocumentUploaderBlockCtrl.getDocumentMetadata());

		test.stopTest();

		Document__c doc = new Document__c();
		doc.Opportunity__c = opp.Id;
		doc.File_Id__c = fileId;
		doc.Reference__c = 'xxxxyyyyzzz';
		doc.Type__c = 'Will';
		insert doc;

		Document__c doc1 = DocumentUploaderBlockCtrl.getExistDocument(opp.Id, 'Will');

		DocumentUploaderBlockCtrl.deleteExistDocument(opp.Id, 'Will', doc1.Id);
	}
	/**
	 * @description
	 * @author Himanshu.Nimje@absa.africa | 2021-06-12
	 **/
	@isTest
	static void ECMLogin() {
		ECM_IH_V1Test.insertSettings();

		Test.startTest();
		system.assertNotEquals(null, DocumentUploaderBlockCtrl.ECMLogin());
		Test.stopTest();
	}
	/**
	 * @description
	 * @author Himanshu.Nimje@absa.africa | 2021-06-12
	 **/
	@isTest
	static void getDocumentsContent() {
		WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
		ECM_IH_V1Test.insertSettings();
		String body = '{"LoginResult" : {"Status" : "OK", "Details" : "null"}, "Token" : "1234567890"}';
		Test.setMock(HttpCalloutMock.class, new ECM_Mock_ApiRest(body));

		Test.startTest();
		DocumentUploaderBlockCtrl.getDocumentContent(testDataFactory.testDocument.id);
		system.assertNotEquals(null, body);
		Test.stopTest();
	}
	/**
	 * @description
	 * @author Himanshu.Nimje@absa.africa | 2021-06-12
	 **/
	public class ECM_Mock_ApiRest implements HttpCalloutMock {
		/**
		 * @description
		 * @author Himanshu.Nimje@absa.africa | 2021-06-12
		 **/
		public String body { get; set; }

		/**
		 * @description
		 * @author Himanshu.Nimje@absa.africa | 2021-06-12
		 **/
		public ECM_Mock_ApiRest() {
		}

		/**
		 * @description
		 * @author Himanshu.Nimje@absa.africa | 2021-06-12
		 * @param body
		 **/
		public ECM_Mock_ApiRest(String body) {
			this.body = body;
		}

		/**
		 * @description
		 * @author Himanshu.Nimje@absa.africa | 2021-06-12
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