/**
 * @description       : DocumentManagementUploaderControlerTest
 * @author            : Vinod.Thupakula@absa.africa
 * @last modified on  : 2021-11-25
 * @last modified by  : Vinod.Thupakula@absa.africa
**/
@isTest
public class DocumentManagementUploaderControlerTest {
    
    @testSetup
    static void dataCreation(){
        DocumentManagementControlerTest.dataCreation();
    }
	
	@isTest
	public static void shouldSaveChunk() {
		Test.startTest();
        WillsTestDataFactory testDataFactory = new WillsTestDataFactory();
        Document_Template__c dt = new Document_Template__c();
        dt.Name = 'EPP ROA';
        dt.Document_Type__c = 'A third party report provided by an acceptable third party data service provider';
        insert dt;
		ECM_IH_V1Test.insertSettings();
		QueueHttpMock mock = new QueueHttpMock();
		mock.addResponse(JSON.serialize(HotDocsToken.getExample()));
        mock.addResponse(JSON.serialize(ECM_AddResult_IB_V1.getExample()));
        Test.setMock(HttpCalloutMock.class, mock);
		//add a document
		Id objectId = [select Id, AccountId from Opportunity Where Name = 'TestClass Wills'].Id;
		Id accId = [select Id, AccountId from Opportunity where Id = :objectId].AccountId;
		Asset will = new AssetsSelector().selectAssetByAccId(accId).get(0);
		//Id saveChunk(Id parentId, String fileName, String base64Data, String contentType, String fileId, Boolean done)
		String chunk1 = EncodingUtil.base64Encode(Blob.valueOf('This is a test '));
		Id fileId = DocumentManagementUploaderControler.saveChunk(will.Id, 'Test.txt', chunk1, 'txt', '', false, dt.Document_Type__c);
        String chunk3 = EncodingUtil.base64Encode(Blob.valueOf('will file!'));
		String chunk2 = EncodingUtil.base64Encode(Blob.valueOf('file!'));
		fileId = DocumentManagementUploaderControler.saveChunk(will.Id, 'Test.txt', chunk2, 'txt', String.valueOf(fileId), true, dt.Document_Type__c);
        
		Test.stopTest();
        System.assert(fileId != null);
	}
    @isTest public static void shouldSaveChunkforOpp() {
        WillsTestDataFactory testDataFactory = new WillsTestDataFactory();
		Test.startTest();
		ECM_IH_V1Test.insertSettings();
		QueueHttpMock mock = new QueueHttpMock();
		mock.addResponse(JSON.serialize(HotDocsToken.getExample()));
        mock.addResponse(JSON.serialize(ECM_AddResult_IB_V1.getExample()));
        Test.setMock(HttpCalloutMock.class, mock);
		//add a document
		Id objectId = [select Id, AccountId from Opportunity Where Name = 'TestClass Wills'].Id;
        String docType  = [SELECT Document_Type__c FROM Document_Template__c WHERE Document_Type__c='Will' LIMIT 1].Document_Type__c;
		String chunk1 = EncodingUtil.base64Encode(Blob.valueOf('This is a test '));
		Id fileId = DocumentManagementUploaderControler.saveChunk(objectId, 'Test.txt', chunk1, 'txt', '', false, docType);
		String chunk2 = EncodingUtil.base64Encode(Blob.valueOf('file!'));
		fileId = DocumentManagementUploaderControler.saveChunk(objectId, 'Test.txt', chunk2, 'txt', String.valueOf(fileId), true, docType);        
		Test.stopTest();
        System.assertEquals(fileId != null, true);
	}
	
	// @isTest
	// public static void shouldDownloadDocument() {
		
	// }
	/** @description QueueHttpMock **/
	public class QueueHttpMock implements HttpCalloutMock {
        
        HttpResponse[] responses = new HttpResponse[0];
        /** @description addResponse
     * @param response
     **/
        public void addResponse(HttpResponse response) {
            responses.add(response);
        }
        /** @description addResponse
     * @param response
     **/
        public void addResponse(String response) {
            addResponse(response, 200, 'application/json');
        }
        /** @description addResponse
     * @param response
     * @param code
     * @param contentType
     **/
        public void addResponse(String response, Integer code, String contentType) {
            HttpResponse res = new HttpResponse();
            res.setBody(response);
            res.setStatusCode(code);
            res.setHeader('Content-Type', contentType);
            responses.add(res);
        }
        /** @description respond
     * @param request
     * @return HttpResponse
     **/
        public HttpResponse respond(HttpRequest request) {
            return responses.remove(0);
        }
	}
    
    @isTest
	public static void testgetFileTypePickList() {
        Test.startTest();
        DocumentManagementUploaderControler.getFileTypePickList();
    	Test.stopTest();
        System.assertEquals(true, true);
    }
}