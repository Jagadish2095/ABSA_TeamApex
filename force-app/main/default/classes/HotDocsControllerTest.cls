@isTest
public class HotDocsControllerTest {
    
    @isTest
    public static void shouldInitialiseHotdocsSession() {
        HotDocs_IH_v1Test.insertSettings();
        new WillsTestDataFactory();
        String client = 'Will';
        String answerSet = null;
        Map<String, Object> context = new Map<String, Object>();
        context.put('id', [select Id from Opportunity LIMIT 1].Id);
        context.put('title', 'Title of document');
		QueueHttpMock mock = new QueueHttpMock();
		mock.addResponse(JSON.serialize(HotDocsToken.getExample()));
        mock.addResponse('{"AnswerSheetXml": ""}');    
        mock.addResponse(JSON.serialize(HotDocsAnswerSet.getExample()));
        mock.addResponse('7681792-29392-2938923-283723');
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, mock);
        HotDocsInitResponse response = HotDocsController.init(client, answerSet, context);
        System.assert(response != null);
        Test.stopTest();
    }
    
    @isTest
    public static void shouldSaveDocuments() {
        HotDocs_IH_v1Test.insertSettings();
        new WillsTestDataFactory();
        String 	token = '', 
            	workItemId = '', 
            	answerSetId = '156251-182718'; 
        Id objectId = [select Id from Opportunity limit 1].Id;
        QueueHttpMock mock = new QueueHttpMock();
        mock.addResponse('<?xml version="1.1" encoding="UTF-8"?><AnswerSet></AnswerSet>');
        mock.addResponse(JSON.serialize(HotDocsWorkItem.getExample()));
        mock.addResponse(EncodingUtil.base64Encode(Blob.valueOf('test')));
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
        HotDocsWorkItem item = HotDocsController.saveDocuments(token, workItemId, answerSetId, objectId);
        Test.stopTest();
    }
    
    @isTest
    public static void shouldGetCheckExemptedReasons() {
        List<String> reasons = HotDocsController.getCheckExemptedReasons();
    }
    
    @isTest
    public static void shouldUpdateDrafting() {
        new WillsTestDataFactory();
        ECM_IH_V1Test.insertSettings();
		QueueHttpMock mock = new QueueHttpMock();
		mock.addResponse(JSON.serialize(HotDocsToken.getExample()));
		mock.addResponse(JSON.serialize(ECM_GetResult_IB_V1.getExample()));
		Test.setMock(HttpCalloutMock.class, mock);
        Id objectId = [select Id from Opportunity limit 1].Id;
        Document__c doc = new Document__c(Name = 'test.pdf', Reference__c = '12345', Opportunity__c = objectId);
        insert doc;
        //HotDocsController.updateDrafting(objectId, 'Yes', 'Yes');
    }
    
    @isTest
    public static void shouldSendEmail() {
    	Test.startTest();
    	new WillsTestDataFactory();
    	ECM_IH_V1Test.insertSettings();
		QueueHttpMock mock = new QueueHttpMock();
		mock.addResponse(JSON.serialize(ECM_LoginResult_IB_V1.getExample()));
		mock.addResponse(JSON.serialize(ECM_GetResult_IB_V1.getExample()));
		Test.setMock(HttpCalloutMock.class, mock);
    	Id objectId = [select Id from Opportunity limit 1].Id;
        Document__c doc = new Document__c(Name = 'test.pdf', Reference__c = '12345', Opportunity__c = objectId);
        insert doc;
        HotDocsController.sendEmail(objectId,'test@gmail.com');
        Test.stopTest();
    }
    
    @isTest
    public static void shouldUpdateApplicationDetails() {
    	Test.startTest();
    	new WillsTestDataFactory();
    	ECM_IH_V1Test.insertSettings();
    	QueueHttpMock mock = new QueueHttpMock();
		mock.addResponse(JSON.serialize('{}'));
		Test.setMock(HttpCalloutMock.class, mock);
		Id objectId = [select Id from Opportunity limit 1].Id;
		Application__c application = new Application__c();
		HotDocsController.updateApplicationDetails(objectId, application);
		Test.stopTest();
    }
    
    @isTest
    public static void shouldGetApplicationDetails() {
    	Test.startTest();
    	new WillsTestDataFactory();
    	Id objectId = [select Id from Opportunity limit 1].Id;
    	Application__c app = new Application__c( Opportunity__c = objectId);
    	insert app;
		String application = HotDocsController.getApplicationDetails(objectId);
		System.assert(application != null);
		Test.stopTest();
    }
    
    @isTest
    public static void shouldGetApplication() {
        Test.startTest();
    	new WillsTestDataFactory();
    	Id opportunityId = [select Id from Opportunity limit 1].Id;
    	Application__c app = new Application__c( Opportunity__c = opportunityId);
    	insert app;
        Application__c application = HotDocsController.getApplication(opportunityId);
        System.assert(application != null);
    }
    
     @isTest
    public static void shouldgetAdviserEmail() {
        Test.startTest();
        new WillsTestDataFactory();
        Id opportunityId = [select Id from Opportunity limit 1].Id;
        List<String> AdviserEmail = HotDocsController.getAdviserEmail(opportunityId); 
        System.assert(AdviserEmail != null);
        Test.stopTest();
    }
    
    @isTest
    public static void shoulddispatchWill() {
        Test.startTest();
         WillsTestDataFactory testDataFactory = new WillsTestDataFactory();
        HotDocsController.dispatchWill(testDataFactory.testOpportunity.Id,testDataFactory.testApplication,'test@gmail.com'); 
        Test.stopTest();
    }
    
    public class QueueHttpMock implements HttpCalloutMock {
        
        HttpResponse[] responses = new HttpResponse[0];
        
        public void addResponse(HttpResponse response) {
            responses.add(response);
        }
        
        public void addResponse(String response) {
            addResponse(response, 200, 'application/json');
        }
        
        public void addResponse(String response, Integer code, String contentType) {
            HttpResponse res = new HttpResponse();
            res.setBody(response);
            res.setStatusCode(code);
            res.setHeader('Content-Type', contentType);
            responses.add(res);
        }
        
        public HttpResponse respond(HttpRequest request) {
            return responses.remove(0);
        }
	}

}