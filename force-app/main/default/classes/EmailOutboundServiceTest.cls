@isTest
public class EmailOutboundServiceTest {
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
        account.PersonEmail='testaccount@absa.africa';
        insert account;
        List<Opportunity> oppsList = TestDataFactory.getOpportunities(null, 'Investment_Opportunity', 1);
        oppsList[0].StageName = 'In Progress';
        oppsList[0].Sub_Status__c = 'Discovery Stage';
        oppsList[0].accountId = account.Id;
        insert oppsList;
        
    }
    @isTest private static void emailoutboundtest(){
        OrgWideEmailAddress owa = [SELECT Id FROM OrgWideEmailAddress WHERE DisplayName='SVC-Virtualadviser' LIMIT 1];
        Account a = [Select PersonContactId from Account where CIF__c='SNIFFEL001' limit 1];
        Opportunity opp = [SELECT Id,AccountId,Sys_ThreadId__c FROM Opportunity WHERE RecordType.Name='Investment Opportunity'LIMIT 1];
        List<String> address = new List<String>{'test@test.com'};
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
        Test.startTest();
        new EmailOutboundService()
            .setSubject(opp.Sys_ThreadId__c)
            .setToAddress('test@test.com')
            .setToAddress(address)
            .setemailHtmlBody('<p> test</p>')
            .setemailPlainTextBody('test')
            .getRelatedFileAttachments(new Set<Id>{contentVersion_2.ContentDocumentId})
            .setTargetId(a.PersonContactId)
            .setwhatId(opp.id)
            .setorgWideAddressId(owa.Id)
            .setReplyTo(System.label.Investment_EmailService)
            .build();
        EmailTemplate template = EmailOutboundService.getEmailTemplate('Investment_Opportunity_Recommendation_Branding');
        Messaging.SingleEmailMessage message = EmailOutboundService.processEmailTemplate(template.Id,opp.Id);
        Test.stopTest();
        System.assertEquals(message.getPlainTextBody() != null, true);
    }
}