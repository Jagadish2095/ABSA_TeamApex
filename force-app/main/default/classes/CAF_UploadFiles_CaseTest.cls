/** 
    * @description get cafApplication
    
    */
@isTest
public class CAF_UploadFiles_CaseTest {
    /** 
    * @description get cafApplication
    
    */
    @isTest
    static void testCaseUploadFiles() {
        Account Acc = new Account(Name='test Acc',CIF__c ='EAINDUS003');
        insert Acc;
        Acc = [SELECT Id, Name, CIF__c FROM Account WHERE Id = :Acc.Id];
        
        System.assertNotEquals(null, Acc.CIF__c);
        System.assert(Acc.CIF__c.length() > 0); 
        Case testCase = new Case();
        testCase.AccountId = Acc.Id;
        testCase.Subject = 'CAF Case';
        testCase.Origin = 'Email';
        testCase.Status = 'New';
        testCase.Priority = 'High';  
        //testCase.Client_CIF_Number__c = Acc.CIF__c;
        testCase.External_Reference_Number__c = 'e3e99bcd-9945-4d4b-859d-d05aa1c27d03';
        
        
        insert testCase;
        testCase = [SELECT id,Client_CIF_Number__c FROM Case WHERE Id = :testCase.Id];
        System.assertEquals(Acc.CIF__c, testCase.Client_CIF_Number__c);


        
        ContentVersion cv = new ContentVersion();
        cv.Title = 'Test Document';
        cv.PathOnClient = 'TestDocument.pdf';
        cv.VersionData = Blob.valueOf('Test Content');
        cv.IsMajorVersion = true;
        Insert cv;
        
        //Get Content Documents
        Id conDocId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cv.Id].ContentDocumentId;
        
        //Create ContentDocumentLink 
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = testCase.Id;
        cdl.ContentDocumentId = conDocId;
        cdl.shareType = 'V';
        Insert cdl;
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/UploadFiles'; 
        req.httpMethod = 'Post';
        req.addHeader('Content-Type', 'application/json'); 
        RestContext.request = req;
        RestContext.response = res; 
        Test.startTest();
        CAF_UploadFiles_Case.uploadFiles('e3e99bcd-9945-4d4b-859d-d05aa1c27d03', 'fileData', 'EAINDUS003');
        Test.stopTest();  
    }
}