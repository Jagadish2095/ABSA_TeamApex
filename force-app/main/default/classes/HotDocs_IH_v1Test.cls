@isTest
public class HotDocs_IH_v1Test {
    
    @isTest
    public static void shouldRetrieveAuthenticationToken() {
        String mockResponse = '{"access_token": "ajhskask127jha"}';
        insertSettings();
        Test.startTest();
        HotDocsToken example = HotDocsToken.getExample();
        Test.setMock(HttpCalloutMock.class, new HotDocs_Mock_ApiRest(mockResponse));
        HotDocsToken response = HotDocs_IH_v1.authenticate('clientId', 'clientSecret');
        System.assert(response != null);
        System.assertEquals('ajhskask127jha', response.accessToken);
        Test.stopTest();
    }
    
    @isTest
    public static void shouldGetInterviewSession() {
        insertSettings();
        Test.startTest();
        String token = 'ajhskask127jha';
        String templateId = '144262-29723-716171';
        String answerSetId = '726372638273';
        Test.setMock(HttpCalloutMock.class, new HotDocs_Mock_ApiRest('17628172981-9172918291'));
        String session = HotDocs_IH_v1.getInterviewSession(token, templateId, answerSetId);
        System.assert(session != null);
        System.assertEquals('17628172981-9172918291', session);
        Test.stopTest();
    }
    
    @isTest
    public static void shouldAddAnswerSet() {
        insertSettings();
        String mockResponse = '{"id" : "1726182812","href": "HotDocsAnswers/api/v1/answerSet/1726182812/versions/live/answerXml"}';
        Test.startTest();
        String token = 'ajhskask127jha';
        String answerSet = '<AnswerSet></AnswerSet>';
        Test.setMock(HttpCalloutMock.class, new HotDocs_Mock_ApiRest(mockResponse));
        HotDocsAnswerSet response = HotDocs_IH_v1.addAnswerSet(token, answerSet);
        System.assert(response != null);
        System.assertEquals('1726182812', response.id);
        Test.stopTest();
    }
    
    @isTest
    public static void shouldGetAnswerSet() {
        insertSettings();
        String token = '12452783';
        String answerSetId = '1234567890';
        String answerSet = '<AnswerSet></AnswerSet>';
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HotDocs_Mock_ApiRest(answerSet));
        String response = HotDocs_IH_v1.getAnswerSet(token, answerSetId);
        Test.stopTest();
    }
    
    @isTest
    public static void shouldGetWorkItem() {
        insertSettings();
        String mockResponse = '{"Id" : "12345", "Name": "14625625"}';
        String token = '123456';
        String workItemId = '1245637738';
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HotDocs_Mock_ApiRest(mockResponse));
        HotDocsWorkItem wi = HotDocs_IH_v1.getWorkItem(token, workItemId);
        Test.stopTest();
    }
    
    @isTest
    public static void shouldGetDocument() {
        insertSettings();
     	String mockResponse = 'Test string document ...';
        String token = '123456';
        String workItemId = '1245637738';
        String documentId = '1652612';
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HotDocs_Mock_ApiRest(mockResponse));
        Blob doc = HotDocs_IH_v1.getDocument(token, workItemId, documentId);
        
        Test.stopTest();   
    }
    
    @isTest
    public static void shouldGetDocumentMetadata() {
        insertSettings();
        String mockResponse = '{"id": "12345", "documentId": "1425267", "workItemId": "293892839"}';
        String token = '123456';
        String workItemId = '1245637738';
        String documentId = '1652612';
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HotDocs_Mock_ApiRest(mockResponse));
        String meta = HotDocs_IH_v1.getDocumentMetadata(token, workItemId, documentId);
        
        Test.stopTest();   
    }
    
    @isTest
    public static void shouldGetHotDocsConfigs() {
        insertSettings();
        HotDocs_IH_v1.getHotDocsConfigs('Will');
    }
    
    @isTest
    public static void shouldGetInterViewUrl() {
        insertSettings();
        HotDocs_IH_v1.getInterViewUrl('jhdakd-2983923-laslaks');
    }
    
    public class HotDocs_Mock_ApiRest implements HttpCalloutMock {
        
        public String body { get; set; }
        
        public HotDocs_Mock_ApiRest() {}
        
        public HotDocs_Mock_ApiRest(String body) {
            this.body = body;
        }
        
        public HTTPResponse respond(HTTPRequest request) {
            HTTPResponse response = new HTTPResponse();
            response.setStatusCode(200);
            response.setHeader('Content-Type', 'application/json');
            response.setBody(body);
            return response;
        }
    }
        
    public static void insertSettings() {
        List<String> endpoints = new List<String>();
        endpoints.add('HotDocs Interview Base Path');
        endpoints.add('HotDocs Get Document');
        endpoints.add('HotDocs Get Onpremise Interview');
        endpoints.add('HotDocs Interview Session');
        endpoints.add('HotDocs Create Answerset Path');
        endpoints.add('HotDocs Authentication');
        endpoints.add('HotDocs Get Work Item');
        endpoints.add('HotDocs Get Answerset Path');
        endpoints.add('HotDocs Get Document Metadata');
        endpoints.add('Get Xml Will Draft');
        IntegrationTestDataFactory.insertIntegrationSettings('API Manager', endpoints);
    }
    

}