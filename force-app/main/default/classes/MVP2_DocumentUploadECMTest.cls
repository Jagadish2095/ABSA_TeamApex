/*
*  Test class for MVP2_DocumentUploadECM
*  @author  Vitthal Jivrag
*  @version v1.0
*  @since   2021-02-11
*
*/
@isTest
public class MVP2_DocumentUploadECMTest {
    /** @description datasetup
     **/
    @TestSetup
    public static void datasetup(){
        Document_Template__c dtc=new Document_Template__c();
        dtc.Name='Test Doc Temp';
        dtc.Document_Type__c='STI Documents';
        insert dtc;
        Account acc=new Account();
        acc.Name='Test Acc';
        insert acc;
        
        String oid=userinfo.getuserId();
        List<Opportunity> oppsList = TestDataFactory.getOpportunities(null, 'Investment_Opportunity', 1);
        Opportunity opp = oppsList[0];
        opp.Name='test1';
        opp.Parent_Account__c=acc.id;
        opp.OwnerId=oid;
        opp.StageName='In Progress';
        opp.CloseDate=date.today()+2;
        insert opp;
        
        Attachment attach=new Attachment();
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=opp.Id;
        attach.ContentType = 'application/msword';
        attach.IsPrivate = false;
        attach.Description = 'Test';
        insert attach;
    }
    @isTest
    public static void validateDocumentUplode() {
        insertSettings();
        Document_Template__c temp = new Document_Template__c();
        temp.Name = 'Investment_Opportunity_Application';
        temp.Document_Type__c = 'Investment_Opportunity_Application';
        temp.ECM_Item_Type__c = 'Ent_Application';
        insert temp;
        String body = '{"LoginResult" : {"Status" : "OK", "Details" : "null"}, "Token" : "1234567890"}';
        Test.setMock(HttpCalloutMock.class, new ECM_Mock_ApiRest(body));
        Test.startTest();
        ECM_LoginResult_IB_V1 result = ECM_IH_V1.login('DGOLSDB', 'DEV_TestUser', 'D3vT#sting');
        System.assertNotEquals(null, result);
        System.assertEquals('OK', result.LoginResult.Status);
        System.assertEquals('1234567890', result.Token);
        Opportunity oppObj=[select id,ownerId,Parent_Account__c from Opportunity];
        String filedata='Test file data';
        Blob data=blob.valueOf(filedata);
        
        MVP2_DocumentUploadECM.uploadtoECM('Test.pdf#@#Application', data, oppObj.Id, oppObj.Parent_Account__c, oppObj.OwnerId);
        MVP2_DocumentUploadECM.uploadtoECM('Test.pdf#@#Application', data, oppObj.Id, oppObj.Parent_Account__c, oppObj.OwnerId);
        Test.stopTest();
    }
    @isTest
    public static void validateDocumentUplode2() {
        insertSettings();
        String body = '{"LoginResult" : {"Status" : "OK", "Details" : "null"}, "Token" : "1234567890"}';
        Test.setMock(HttpCalloutMock.class, new ECM_Mock_ApiRest(body));
        Test.startTest();
        ECM_LoginResult_IB_V1 result = ECM_IH_V1.login('DGOLSDB', 'DEV_TestUser', 'D3vT#sting');
        System.assertNotEquals(null, result);
        System.assertEquals('OK', result.LoginResult.Status);
        System.assertEquals('1234567890', result.Token);
        Opportunity oppObj=[select id,ownerId,Parent_Account__c from Opportunity];        
        String filedata='Test file data';
        Blob data=blob.valueOf(filedata);
        
        MVP2_DocumentUploadECM.uploadtoECM('Test.pdf', data, oppObj.Id, oppObj.Parent_Account__c, oppObj.OwnerId);
        Test.stopTest();
    }
    /** @description insertSettings
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
     /** @description ECM_Mock_ApiRest
     **/
    public class ECM_Mock_ApiRest implements HttpCalloutMock {
         /** @description body
     **/
        public String body { get; set; }
         /** @description ECM_Mock_ApiRest
     **/
        public ECM_Mock_ApiRest() {}
         /** @description ECM_Mock_ApiRest
          * @param body
     **/
        public ECM_Mock_ApiRest(String body) {
            this.body = body;
        }
        /** @description respond
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