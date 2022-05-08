/**
* This is the DocumentsShareControler test class
*
* @author Danie Booysen
* @created	2020-01-13
*/
@IsTest
public class DocumentsShareControlerTest {
    
    public static testMethod void testGetDocumentAuditEmail(){
        
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        
        Test.startTest();
        List<Document__c> documentAuditList = DocumentsShareControler.getDocAuditHistoryEmail(testDataFactory.testOpportunity.Id);
        Test.stopTest();
    }
    
    static testMethod void ECMLogin() {
        
        ECM_IH_V1Test.insertSettings();
        
        Test.startTest();
        DocumentsShareControler.ECMLogin();
        Test.stopTest();
    }
    
    static testMethod void getDocumentsContent() {
        
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        ECM_IH_V1Test.insertSettings();
        String body = '{"LoginResult" : {"Status" : "OK", "Details" : "null"}, "Token" : "1234567890"}';
        Test.setMock(HttpCalloutMock.class, new ECM_Mock_ApiRest(body));
        
        Test.startTest();
        DocumentsShareControler.getDocumentContent(testDataFactory.testDocument.id);
        Test.stopTest();
    }
    
    public class ECM_Mock_ApiRest implements HttpCalloutMock {
        
        public String body { get; set; }
        
        public ECM_Mock_ApiRest() {}
        
        public ECM_Mock_ApiRest(String body) {
            this.body = body;
        }
        
        public HTTPResponse respond(HTTPRequest request) {
            HTTPResponse response = new HTTPResponse();
            response.setStatusCode(200);
            response.setBody(body);
            response.setHeader('Content-Type', 'application/json');
            return response;
        }
    }
    
}