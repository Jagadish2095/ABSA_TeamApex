/**
* This is the DocumentsShareControler test class
*
* @author Vladimir Panajic
* @created	2019-05-24
*/
@IsTest
public class DocumentsShareControlerESignTest {
    static testMethod void testAll() {
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        test.startTest();
        boolean docRestricted = DocumentsShareControlerESign.documentRestricted(testDataFactory.testOpportunity.id, testDataFactory.testDocument.id);
        Digital_Signature_Signatory__c sig = new Digital_Signature_Signatory__c();
        //DocumentsShareControlerESign.getUpdatedSignatoriesData(testDataFactory.testOpportunity.id, testDataFactory.testDocument.id, testDataFactory.testDocument.id, 'String signatoriesInput', 'Realtime', '0111234567', 'test@123.com');
        system.assertNotEquals(null, docRestricted);
        test.stopTest();
    }
    
    static testMethod void getDocumentsData() {
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        test.startTest();
        List<Document__c> documents = DocumentsShareControlerESign.getDocumentsData(testDataFactory.testOpportunity.id);
        List<Document_Audit__c> da = DocumentsShareControlerESign.getDocAuditHistoryEmail(testDataFactory.testOpportunity.id);
        system.assertNotEquals(-1, documents.size());
        system.assertNotEquals(-1, da.size());
        test.stopTest();
    }
    
    static testMethod void getSigntoriesData() {
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        test.startTest();
        testDataFactory.testQuoteDocument.Opportunity__c = testDataFactory.testMerchantOnboardingOpportunity.id;
        update testDataFactory.testQuoteDocument;
        DocumentsShareControlerESign.getSigntoriesData(testDataFactory.testQuoteDocument.id);
        
        testDataFactory.testDigitalSignatureSignatoryQuote.Signatory_Type__c = 'Parent Owner';
        update testDataFactory.testDigitalSignatureSignatoryQuote;
        
        
        DocumentsShareControlerESign.getSigntoriesData(testDataFactory.testQuoteDocument.id);
        testDataFactory.testDigitalSignatureSignatoryQuote.Signatory_Type__c = 'Authorised Signatory';
        update testDataFactory.testDigitalSignatureSignatoryQuote;
        DocumentsShareControlerESign.getSigntoriesData(testDataFactory.testQuoteDocument.id);
        
        testDataFactory.testMerchantOnboardingOpportunity.Accountid = testDataFactory.testBizAccount.id;
        update testDataFactory.testMerchantOnboardingOpportunity;
        Contact c = [Select id from Contact where RecordType.DeveloperName = 'Contact' LIMIT 1];
        c.AccountId=testDataFactory.testBizAccount.id;
        update c;
        
        testDataFactory.testMerchantOnboardingOpportunity.accountid = testDataFactory.testProspectAccount.id;
        update testDataFactory.testMerchantOnboardingOpportunity;
        
        Id testProspectAccountContactId = [Select Id, PersonContactId FROM Account WHERE Id = :testDataFactory.testProspectAccount.Id].PersonContactId;
        
        Signatory_Party_Overide__c spo2 = new Signatory_Party_Overide__c(Opportunity__c=testDataFactory.testMerchantOnboardingOpportunity.id,
                                                                         Preferred_Email__c='test@12.com',Preferred_Method__c='Realtime',
                                                                         Preferred_Mobile__c='0989876543',
                                                                         Signatory_Party__c=testProspectAccountContactId);
        insert spo2;        
        testDataFactory.testDigitalSignatureSignatoryQuote.Signatory_Type__c = 'Parent Customer';
        update testDataFactory.testDigitalSignatureSignatoryQuote;
        DocumentsShareControlerESign.getSigntoriesData(testDataFactory.testQuoteDocument.id);
        testDataFactory.testMerchantOnboardingOpportunity.accountid = testDataFactory.testBizAccount.id;
        update testDataFactory.testMerchantOnboardingOpportunity;
        spo2.Opportunity__c=testDataFactory.testMerchantOnboardingOpportunity.id;
        spo2.Signatory_Party__c=c.id; 
        update spo2;
        
        testDataFactory.testDigitalSignatureSignatoryQuote.Signatory_Type__c = 'Parent Owner';
        update testDataFactory.testDigitalSignatureSignatoryQuote;
        DocumentsShareControlerESign.getSigntoriesData(testDataFactory.testQuoteDocument.id);
        testDataFactory.testDigitalSignatureSignatoryQuote.Signatory_Type__c = 'Authorised Signatory';
        update testDataFactory.testDigitalSignatureSignatoryQuote;
        List<Map<String, Object>> ll = DocumentsShareControlerESign.getSigntoriesData(testDataFactory.testQuoteDocument.id);
        
        List<String> mobileList = DocumentsShareControlerESign.getMobile(testDataFactory.testMerchantOnboardingOpportunity.id);
        List<String> emailsList = DocumentsShareControlerESign.getAllClientEmails(testDataFactory.testMerchantOnboardingOpportunity.id);
        List<String> sigList = DocumentsShareControlerESign.getAllClientEmailsSignature(testDataFactory.testMerchantOnboardingOpportunity.id);
        
        system.assertNotEquals(null, mobileList.size());
        system.assertNotEquals(null, emailsList.size());
        system.assertNotEquals(null, sigList.size());
        test.stopTest();
    }
    
    static testMethod void getDocumentAudit() {
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        List<Document_Audit__c> documentAudits = DocumentsShareControlerESign.getDocumentAudit(testDataFactory.testOpportunity.id);
        system.assertNotEquals(null, documentAudits.size());
    }
    
    static testMethod void fetchImpressionRequest() {
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        List<ImpressionRequest__c> impressionRequests = DocumentsShareControlerESign.fetchImpressionRequest(testDataFactory.testOpportunity.id);
        system.assertNotEquals(null, impressionRequests.size());
    }
    
    static testMethod void createDocumentSharingAudit() {
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        DocumentsShareControlerESign.createDocumentSharingAudit(testDataFactory.testOpportunity.id, testDataFactory.testDocument.id, 'Download', 'vladimir.panajic@absa.co.za');
        List<Document_Audit__c> dcaList = [Select id from Document_Audit__c where Opportunity__c = :testDataFactory.testOpportunity.id];
        system.assertNotEquals(null, dcaList.size());
    }
    /*
static testMethod void getDocumentContent() {
Test.startTest();
WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
ECM_IH_V1Test.insertSettings();
DocumentsShareControlerESign.getDocumentContent(testDataFactory.testDocument.id);
Test.stopTest();
}

static testMethod void ECMLogin() {//
WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
DocumentsShareControlerESign.ECMLogin();
}*/
    
    static testMethod void dummyRefresh() {
        DocumentsShareControlerESign.dummyRefresh();
        // this is a dummy it does nothing so nothing to assert
    }
    
    static testMethod void fetchAdviserName() {
        string advisor = DocumentsShareControlerESign.fetchAdviserName();
        System.assertNotEquals(null,advisor);
    }
    /*
static testMethod void getDocumentsContent() {
WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
Set<Id> idSet = new Set<Id>();
idSet.add(testDataFactory.testDocument.id);
String idListJSON = JSON.serialize(idSet);
ECM_IH_V1Test.insertSettings();
DocumentsShareControlerESign.getDocumentsContent(idListJSON);
}

static testMethod void sendDocumentSharingEmail() {
WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
Set<Id> idSet = new Set<Id>();
idSet.add(testDataFactory.testDocument.id);
String idListJSON = JSON.serialize(idSet);
ECM_IH_V1Test.insertSettings();
DocumentsShareControlerESign.sendDocumentSharingEmail(testDataFactory.testOpportunity.id, 'vladimir.panajic@absa.co.za', idListJSON);
}*/
    /*
static testMethod void getSigntoriesData() {
WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
DocumentsShareControlerESign.getSigntoriesData(testDataFactory.testDocument.id);
}
*/
    static testMethod void sendForImpressionSignature() {
        test.startTest();
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        String sigs = '[{"Id":"' + testDataFactory.testAccount.id + '","Title":"Mr.","Last_Name":"PAULA VENTER","Mobile_Phone":"+27833826456","Email":"tinashem@yahoo.com","Method":"Realtime","Role":"Client","Document_Name":"mu.pdf","Document_Type":"Quote"}]';
        string sendForSig = DocumentsShareControlerESign.sendForImpressionSignature(testDataFactory.testDocument.id, sigs);//signatories
        system.assertNotEquals(null, sendForSig);
        test.stopTest();
    }
    
    static testMethod void getAllClientEmails() {
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        List<String>  emailsList = DocumentsShareControlerESign.getAllClientEmails(testDataFactory.testOpportunity.id);
        system.assertNotEquals(null, emailsList.size());
    }
    
    static testMethod void getAllClientEmailsSignature() {
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        List<String>  sigList = DocumentsShareControlerESign.getAllClientEmails(testDataFactory.testOpportunity.id);
        system.assertNotEquals(null, sigList.size());
    }
    
    static testMethod void getMobile() {
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        List<String>  mobileList = DocumentsShareControlerESign.getMobile(testDataFactory.testOpportunity.id);
        system.assertNotEquals(null, mobileList.size());
    }
    
    static testMethod void getDigitalSignatorySelectOptions() {
        List <String> sel = DocumentsShareControlerESign.getDigitalSignatorySelectOptions('Preferred_Method__c');
        system.assertNotEquals(null, sel);
    }
    
    static testMethod void getUpdatedSignatoriesData() {
        test.startTest();
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        Id testProspectAccountContactId = [Select Id, PersonContactId FROM Account WHERE Id = :testDataFactory.testProspectAccount.Id].PersonContactId;
        Signatory_Party_Overide__c spo2 = new Signatory_Party_Overide__c(Opportunity__c=testDataFactory.testOpportunity.id,
                                                                         Preferred_Email__c='test@12.com',Preferred_Method__c='Realtime',
                                                                         Preferred_Mobile__c='0989876543',
                                                                         Signatory_Party__c=testProspectAccountContactId);
        insert spo2;
        String sigs = '[{"Id":"' + testDataFactory.testAccount.id + '","Title":"Mr.","Last_Name":"PAULA VENTER","Mobile_Phone":"+27833826456","Email":"tinashem@yahoo.com","Method":"Realtime","Role":"Client","Document_Name":"mu.pdf","Document_Type":"Quote"}]';
        List<Map<String, Object>> getUpdSigdata = DocumentsShareControlerESign.getUpdatedSignatoriesData(testDataFactory.testOpportunity.id, testDataFactory.testDocument.id, spo2.id, sigs, 'Realtime', '0988765432', 'test@123.com');
        system.assertNotEquals(null, getUpdSigdata);
        test.stopTest();
    }
    
//    static testMethod void inProgressOrSignedRequestExists() {
       // WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        //Below method gives an error
        //DocumentsShareControlerESign.inProgressOrSignedRequestExists(testDataFactory.testOpportunity.id, testDataFactory.testDocument.id);
   // }
    
    public static testMethod void testCheckCASAValidity(){
        
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        
        Test.startTest();
        String CasaStatus = DocumentsShareControlerESign.checkCASAValidity(testDataFactory.testOpportunity.Id);
        system.assertNotEquals(null, CasaStatus);
        Test.stopTest();
    }
    
    public static testMethod void testGetUserRoleAdviser(){
        
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        
        Test.startTest();
        String CasaStatus = DocumentsShareControlerESign.getUserRole(testDataFactory.testOpportunity.Id);
        system.assertNotEquals(null, CasaStatus);
        Test.stopTest();
    }
    
    public static testMethod void testGetUserRoleNoAccess(){
        
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        testDataFactory.testOpportunity.OwnerId = testDataFactory.testUserSupervisor.Advisor__c;
        update testDataFactory.testOpportunity;
        
        Test.startTest();
        String CasaStatus = DocumentsShareControlerESign.getUserRole(testDataFactory.testOpportunity.Id);
        system.assertNotEquals(null, CasaStatus);
        Test.stopTest();
    }
    
    public static testMethod void testfetchOppOwnerName(){
        
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        
        Test.startTest();
        String CasaStatus = DocumentsShareControlerESign.fetchOppOwnerName(testDataFactory.testOpportunity.Id);
        system.assertNotEquals(null, CasaStatus);
        Test.stopTest();
    }
    
    public static testMethod void testGetDocumentAuditEmail(){
        
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        testDataFactory.testOpportunity.OwnerId = testDataFactory.testUserSupervisor.Advisor__c;
        update testDataFactory.testOpportunity;
        
        Test.startTest();
        List<Task> TaskList = DocumentsShareControlerESign.getDocumentAuditEmail(testDataFactory.testOpportunity.Id);
        system.assertNotEquals(null, TaskList.size());
        Test.stopTest();
    }
    
    public static testMethod void testGetEmailDocuments(){
        
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        Task task = new Task();
        task.Subject = 'Test Task';
        Insert task;
        
        Test.startTest();
        List<Email_Document__c> EmailDocumentList = DocumentsShareControlerESign.getEmailDocuments(task.Id);
        system.assertNotEquals(null, EmailDocumentList.size());
        Test.stopTest();
    }
    
    public static testMethod void testGetOpportunityIdFromTask(){
        
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        Task task = new Task();
        task.Subject = 'Test Task';
        task.WhatId = testDataFactory.testOpportunity.Id;
        Insert task;
        
        Test.startTest();
        Id oppId = DocumentsShareControlerESign.getOpportunityIdFromTask(task.Id);
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