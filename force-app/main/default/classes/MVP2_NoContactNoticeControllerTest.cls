/*
*  Test class for MVP2_NoContactNoticeController
*  @author  Vitthal Jivrag
*  @version v1.0
*  @since   2021-02-25
*  @lastModified  2021-11-12
*/
@isTest
public class MVP2_NoContactNoticeControllerTest {
    
    /*
* Method is created to create dummy records for test Cases.
*/
    @testSetup
    private static void setTestData(){
        Id leadRecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('STI Lead').getRecordTypeId();
        Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('STI').getRecordTypeId();
        Id qtRecordTypeId = Schema.SObjectType.Quote.getRecordTypeInfosByName().get('STI Quote').getRecordTypeId();
        
        
        
       /* Account acc=new Account();
        acc.Name='Test Acc';
        insert acc; */
        
        Account acc=new Account();
        Id accountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual Client').getRecordTypeId();
        acc.RecordTypeId=accountRecordTypeId;
        acc.FirstName = 'Test';
        acc.LastName = 'Test';
        //accObj2.Name='Test PersonAccount';
        acc.CIF__c = 'LOUWNJ 019';
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
        
        QuickText qt=new QuickText();
        qt.Name='MVP2_NoContactSMS';
        qt.Message='Test Message';
        insert qt;
        
    }
    
    /*
* Method is created to send SMS Test Case.
*/
    @isTest
    public static void testMsg(){
        String quickTextMessage = [select Message from QuickText where Name ='MVP2_NoContactSMS'].Message;
        Lead lobj=[select id from lead];
        test.startTest();
        list<string> ListOflead=new list<string>();
        ListOflead.add(lobj.id);
        System.assertEquals(false,string.isBlank(quickTextMessage),'Quick text massage in not null');
        MVP2_NoContactNoticeController.sendNoConnectSms(ListOflead);
        MVP2_NoContactNoticeController.dispatchSMS('1234567890', 'test', 'i Touch');
        test.stopTest();
    }
    
    /*
* Method is created to test Document upload Test Case for Opportunity.
*/
    @isTest
    public static void testOppEcmUpload(){
        Opportunity opp=[select id from Opportunity];
        String oid=userinfo.getuserId();
        ContentDocumentLink cdl=[SELECT id,ContentDocumentId, LinkedEntityId  FROM ContentDocumentLink where LinkedEntityId =:oid];
        String docID=cdl.ContentDocumentId;
        ContentDocumentLink cdlObj=new ContentDocumentLink();        
        cdlObj.LinkedEntityId=opp.Id;
        cdlObj.ContentDocumentId=docID;
        insert cdlObj;
        
        ContentDocument doc=[select id from ContentDocument];
        string did=doc.id;  
        test.startTest();
        system.assertEquals(false,string.isBlank(did),'Doc Id Is Not Null');
        MVP2_NoContactNoticeController.getUplodeEcm(did);        
        test.stopTest();
    }
    /*
* Method is created to test Document upload Test Case for Quote.
*/   
    @isTest
    public static void testQuoteEcmUpload(){
        String oid=userinfo.getuserId();
        Quote qt=[select id from Quote];
        ContentDocumentLink cdl=[SELECT ContentDocumentId, LinkedEntityId  FROM ContentDocumentLink where LinkedEntityId =:oid];
        String docID=cdl.ContentDocumentId;
        ContentDocumentLink cdlObj=new ContentDocumentLink();
        cdlObj.LinkedEntityId=qt.Id;
        cdlObj.ContentDocumentId=docID;
        insert cdlObj;
        
        ContentDocument doc=[select id from ContentDocument];
        string did=doc.id;  
        test.startTest();
        System.assertEquals(false,string.isBlank(did),'Doc Id Is Not Null');
        MVP2_NoContactNoticeController.getUplodeEcm(did);        
        test.stopTest();
    }
}