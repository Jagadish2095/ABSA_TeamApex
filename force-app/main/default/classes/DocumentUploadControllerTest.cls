/**
* @description - Test class for DocumentUploadController
* @author  Saiteja : ABSA
* @version v1.0
* @since   2021-04-09
**/
@isTest
public class DocumentUploadControllerTest {
   
    @isTest
    public static void shouldSaveChunk() {
        Test.startTest();
        insertSettings();
        QueueHttpMock mock = new QueueHttpMock();
        mock.addResponse(JSON.serialize(HotDocsToken.getExample()));
        mock.addResponse(JSON.serialize(ECM_AddResult_IB_V1.getExample()));
        Test.setMock(HttpCalloutMock.class, mock);
        new WillsTestDataFactory();
        //add a document
        Id objectId = [select Id, AccountId from Opportunity limit 1].Id;
        Id accId = [select Id, AccountId from Opportunity where Id = :objectId].AccountId;
        String chunk1 = EncodingUtil.base64Encode(Blob.valueOf('This is a test '));
        Id fileId = DocumentUploadController.saveChunk(accId, 'Test.txt', chunk1, 'txt', '', false, 'Attestation');
        System.assert(fileId != null);
        String chunk2 = EncodingUtil.base64Encode(Blob.valueOf('file!'));
        
        Attachment attach = [SELECT Id, Body, Name, ParentId FROM Attachment WHERE Id =: fileId];
        String fileName = attach.Name;
        Id parentId = attach.ParentId;
        ECM_AddRequest_IB_V1.AddRequest request = new ECM_AddRequest_IB_V1.AddRequest();
        request.Token='1234567890';
        
        Document_Template__c dt = new Document_Template__c();
        dt = new Document_Template__c();
        dt.Name = 'Attestation';
        dt.Document_Type__c = 'Attestation';
        dt.ECM_Item_Type__c = 'Ent_Agreement';
        dt.XML__c = '<Account><LastName>{Account.LastName}</LastName>';
        insert dt;
        
        DocumentUploadController.completeUpload(fileId, 'Attestation');
        DocumentUploadController.appendToFile(fileId, 'String base64Data');
       // DocumentUploadController.setDocumentECMInfo(request, parentId, acc, 'Attestation');
       // DocumentUploadController.addDocumentItem('test',accId,'1238','Attestation');
        
        Test.stopTest();
        
    }
    /**
* @description - Method to add endpoints
**/
    public static void insertSettings() {
        List<String> endpoints = new List<String>();
        endpoints.add('ECM Query Path');
        endpoints.add('ECM Authenication Path');
        endpoints.add('ECM Add Path');
        endpoints.add('ECM Logout Path');
        endpoints.add('ECM GetItemType Path');
        endpoints.add('ECM Get Path');
        endpoints.add('ECM GetItemTypes Path');
        IntegrationTestDataFactory.insertIntegrationSettings('API Manager', endpoints);
    }
    /**
    * @description -  class for ECM_Mock_ApiRest to implemets HttpcalloutMock
    **/
    public class ECM_Mock_ApiRest implements HttpCalloutMock {
        /**
    * @description -  
    **/
        public String body { get; set; }
        /**
    * @description -  
    **/
        public ECM_Mock_ApiRest() {}
        /**
    * @description -  
    * @param body
    **/
        public ECM_Mock_ApiRest(String body) {
            this.body = body;
        }
            /**
    * @description -  Method to get Response
    * @param request
    * @return response
    **/
        public HTTPResponse respond(HTTPRequest request) {
            HTTPResponse response = new HTTPResponse();
            response.setStatusCode(200);
            response.setBody(body);
            response.setHeader('Content-Type', 'application/json');
            return response;
        }
    }
    /**
    * @description -  class for QueueHttpMock to implemets HttpcalloutMock
    **/
    public class QueueHttpMock implements HttpCalloutMock {
        
        HttpResponse[] responses = new HttpResponse[0];
        /**
    * @description -  Method to add response
    * @param response
    **/
        public void addResponse(HttpResponse response) {
            responses.add(response);
        }
         /**
    * @description -  Method to add response
    * @param response
    **/
        public void addResponse(String response) {
            addResponse(response, 200, 'application/json');
        }
         /**
    * @description -  Method to add response
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
          /**
    * @description - 
    * @param request
    * @return responses
    **/
        public HttpResponse respond(HttpRequest request) {
            return responses.remove(0);
        }
    }

}