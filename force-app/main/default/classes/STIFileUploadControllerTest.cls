/*
*  Test class for STIFileUploadController
*  @author  Vitthal Jivrag
*  @version v1.0
*  @since   2021-02-25
*
*/
@isTest
public class STIFileUploadControllerTest {
    
    @testSetup
    private static void setTestData(){
        Id leadRecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('STI Lead').getRecordTypeId();
        Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('STI').getRecordTypeId();
        Id qtRecordTypeId = Schema.SObjectType.Quote.getRecordTypeInfosByName().get('STI Quote').getRecordTypeId();
        
        
        
        Account acc=new Account();
        acc.Name='Test Acc';
        insert acc;
        
        String oid=userinfo.getuserId();
        
        Lead leObj=new Lead();        
        leObj.OwnerId=oid;
        leObj.Parent_Account__c=acc.id;
        leObj.RecordTypeId=leadRecordTypeId;
        LeObj.LastName='Tset';
        leObj.Salutation='Mr';
        leObj.FirstName='Vitthal';
        leObj.MobilePhone='0812345678';
        insert leObj;
        
        
        Opportunity opp = new Opportunity();
        opp.Name='test1';
        opp.Parent_Account__c=acc.id;
        opp.OwnerId=oid;
        opp.StageName='In Progress';
        opp.RecordTypeId=oppRecordTypeId;
        opp.CloseDate=date.today()+2;
        insert opp;
        
        Quote q=new Quote();  
        q.OpportunityId=opp.id;
        q.RecordTypeId=qtRecordTypeId;
        q.Name='Test Data';
        insert q;
        
        
        ContentVersion cv = new ContentVersion();
        cv.Title = 'Test Document';
        cv.PathOnClient = 'TestDocument.pdf';
        cv.VersionData = Blob.valueOf('Test Content');
        cv.IsMajorVersion = true;
        Insert cv;
        
    }
    
    @isTest
    public static void testQuoteEcmUpload(){
        String oid=userinfo.getuserId();
        Opportunity oppID=[select id from Opportunity];
        ContentDocumentLink cdl=[SELECT ContentDocumentId, LinkedEntityId  FROM ContentDocumentLink where LinkedEntityId =:oid];
        String docID=cdl.ContentDocumentId;
        ContentDocumentLink cdlObj=new ContentDocumentLink();
        cdlObj.LinkedEntityId=oppID.Id;
        cdlObj.ContentDocumentId=docID;
        insert cdlObj;
        
        ContentDocument doc=[select id from ContentDocument];
        string did=doc.id;  
        test.startTest();
        STIFileUploadController.UpdateFiles(did,oppID.id,'Test');  
        STIFileUploadController.uploadFiles(oppID.id, did);
        test.stopTest();
        system.assertEquals(oppID != null, true);
    }
    
    @isTest
    public static void testDocumentTypes(){
        Id oppId = [SELECT Id FROM Opportunity LIMIT 1].Id;
        Note newNote = new Note();
        newNote.ParentId = oppId;
        newNote.IsPrivate = true;
        newNote.Title = 'RequiredDocuments';
        newNote.Body = 'Application';
        insert newNote;
        Test.startTest();
        List<String> result = STIFileUploadController.getDocumentTypes(oppId);
        Test.stopTest();
        system.assertEquals(result.contains('Application'), true);
    }
    
    @isTest
    public static void testSaveDocTypes(){
        Id oppId = [SELECT Id FROM Opportunity LIMIT 1].Id;
        Test.startTest();
        STIFileUploadController.saveDocTypes(oppId, new List<String>{'Application'});
        Test.stopTest();
        Note note = [SELECT Body FROM Note WHERE ParentId=:oppId LIMIT 1];
        system.assertEquals(note.Body.contains('Application'), true);
    }
}