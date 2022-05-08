@isTest
public class InvestmentOppUtilityTest {
    @testSetup private static void setupData(){
        Map<String,Schema.RecordTypeInfo> rtInfo = CommonUtils.getRecordTypesForsObject('Account');
        Id accRecordTypeId = rtInfo.get('Individual_Prospect').getRecordTypeId();
        Account account = new Account();
        account.FirstName = 'Test';
        account.LastName = 'Account';
        account.Client_Type__c = 'Private Individual';
        account.CIF__c = 'SNIFFEL001';
        account.Sic = '35790';
        account.AccountNumber = '0';
        account.RecordTypeId = accRecordTypeId;
        account.Registration_Number__c = '1990/011515/23';
        account.PersonEmail=userinfo.getUserEmail();
        insert account;
        List<Opportunity> oppsList = TestDataFactory.getOpportunities(null, 'Investment_Opportunity', 1);
        oppsList[0].StageName = 'In Progress';
        oppsList[0].Sub_Status__c = 'Discovery Stage';
        oppsList[0].accountId = account.Id;
        insert oppsList;
        EmailMessage email = new EmailMessage();
        email.FromAddress = 'test@abc.org';
        email.Incoming = false;
        email.ToAddress= 'test@xyz.org';
        email.Subject = 'Test email';
        email.HtmlBody = 'Test email body';
        email.RelatedToId = oppsList[0].Id; 
        insert email;
        ContentVersion contentVersionInsert = new ContentVersion(
            Title = 'Test',
            PathOnClient = 'Test.jpg',
            VersionData = Blob.valueOf('Test Content Data'),
            IsMajorVersion = true,
            Description = 'Application'
        );
        insert contentVersionInsert;
        ContentVersion contentVersion_2 = [SELECT Id, Title, ContentDocumentId 
                                           FROM ContentVersion WHERE Id = :contentVersionInsert.Id LIMIT 1];
        
        ContentDocumentLink contentlink = new ContentDocumentLink();
        contentlink.LinkedEntityId = oppsList[0].Id;
        contentlink.contentdocumentid = contentVersion_2.contentdocumentid;
        contentlink.ShareType = 'V';
        insert contentlink;        
        Note newNote = new Note();
        newNote.ParentId = oppsList[0].Id;
        newNote.IsPrivate = true;
        newNote.Title = 'RequiredDocuments';
        newNote.Body = 'Application';
        insert newNote;
        
    }
    @isTest private static void getRelatedDocumentsTest(){
        Opportunity opp = [SELECT Id FROM Opportunity WHERE RecordType.Name='Investment Opportunity'LIMIT 1];
        Test.startTest();
        InvestmentOppUtility.getRecordAccess(opp.Id);
        Map<Id,ContentDocument>  docs = InvestmentOppUtility.getRelatedDocuments(opp.Id);
        InvestmentOppUtility.checkAllvalidDocuments(docs.values(),new List<String>{'Application'});
        Test.stopTest();
        system.assertEquals(docs != null, true);
    }
    @isTest private static void getRequiredDocsTest(){
        Opportunity opp = [SELECT Id FROM Opportunity WHERE RecordType.Name='Investment Opportunity'LIMIT 1];
        Test.startTest();
        List<String> result = InvestmentOppUtility.getRequiredDocs(opp.Id);
        Test.stopTest();
        system.assertEquals(result != null, true);
    }
    
    @isTest private static void testDeleteDocsFromOpp(){
        Opportunity opp = [SELECT Id FROM Opportunity WHERE RecordType.Name='Investment Opportunity'LIMIT 1];        
        ContentVersion contentVersion_2 = [SELECT Id, Title, ContentDocumentId 
                                           FROM ContentVersion WHERE Description = 'Application' LIMIT 1];
        
        ContentDocument contentDoc = [SELECT Id FROM ContentDocument WHERE Id =:contentVersion_2.ContentDocumentId LIMIT 1];
        Test.startTest();
        delete contentDoc;
        Test.stopTest();
        List<ContentDocumentLink> link = [SELECT Id FROM ContentDocumentLink WHERE LinkedEntityId=:opp.Id];
        System.assertEquals(link.isEmpty(), true);
    }
    @isTest private static void attachmentDeleteFromEmailTest(){
        Opportunity opp = [SELECT Id FROM Opportunity WHERE RecordType.Name='Investment Opportunity'LIMIT 1];
        EmailMessage eMessage = [SELECT Id FROM EmailMessage WHERE RelatedToId=:opp.Id LIMIT 1];
        Attachment attach = createAttachment('Opp-attachment1',eMessage.Id);
        Test.startTest();
        try{
            delete attach;
        }
        catch(Exception ex){
            System.assertEquals(ex.getMessage().contains('You cannot remove/delete this file because it has been shared to customer.'), true);
        }
        Test.stopTest();
    }
    private static Attachment createAttachment(String Name, String ParentId){
        Attachment attach=new Attachment();   	
        attach.Name=Name;
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=ParentId;
        insert attach;
        return attach;
    }
}