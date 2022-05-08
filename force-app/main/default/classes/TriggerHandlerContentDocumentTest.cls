@isTest
public class TriggerHandlerContentDocumentTest {
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
    @isTest private static void testRemoveDocsFromOpp(){
        Opportunity opp = [SELECT Id FROM Opportunity WHERE RecordType.Name='Investment Opportunity'LIMIT 1];        
        ContentVersion contentVersion_2 = [SELECT Id, Title, ContentDocumentId 
                                           FROM ContentVersion WHERE Description = 'Application' LIMIT 1];
        
        ContentDocumentLink contentlink = insertContentDocumentLink(contentVersion_2.contentdocumentid,opp.Id);
        Test.startTest();
        delete contentlink;
        Test.stopTest();
        List<ContentDocumentLink> link = [SELECT Id FROM ContentDocumentLink WHERE LinkedEntityId=:opp.Id];
        System.assertEquals(link.isEmpty(), true);
    }
    @isTest private static void testRemoveDocsFromOppAfterSend(){
        Opportunity opp = [SELECT Id FROM Opportunity WHERE RecordType.Name='Investment Opportunity'LIMIT 1];
        opp.Email_Status__c = 'Submitted';
        opp.Sys_BypassValidation__c = true;
        update opp;
        ContentVersion contentVersion_2 = [SELECT Id, Title, ContentDocumentId 
                                           FROM ContentVersion WHERE Description = 'Application' LIMIT 1];
        
        ContentDocumentLink contentlink = insertContentDocumentLink(contentVersion_2.contentdocumentid,opp.Id);
        Test.startTest();
        try{
            delete contentlink;
        }
        catch(Exception ex){
            System.assertEquals(ex.getMessage().contains('You cannot remove/delete this file because it has been shared to customer.'), true);
        }
        Test.stopTest();
    }
    @isTest private static void testRemoveDocsFromEmailMessage(){
        Opportunity opp = [SELECT Id FROM Opportunity WHERE RecordType.Name='Investment Opportunity'LIMIT 1];
        EmailMessage eMessage = [SELECT Id FROM EmailMessage WHERE RelatedToId=:opp.Id LIMIT 1];        
        ContentVersion contentVersion_2 = [SELECT Id, Title, ContentDocumentId 
                                           FROM ContentVersion WHERE Description = 'Application' LIMIT 1];
        
        ContentDocumentLink contentlink = insertContentDocumentLink(contentVersion_2.contentdocumentid,eMessage.Id);
        Test.startTest();
        try{
            delete contentlink;
        }
        catch(Exception ex){
            System.assertEquals(ex.getMessage().contains('You cannot remove/delete this file because it has been shared to customer.'), true);
        }
        Test.stopTest();
    }
    private static ContentDocumentLink insertContentDocumentLink(Id DocId, Id LinkedId){
        ContentDocumentLink contentlink = new ContentDocumentLink();
        contentlink.LinkedEntityId = LinkedId;
        contentlink.contentdocumentid = DocId;
        contentlink.ShareType = 'V';
        insert contentlink;
        return contentlink;
    }
}