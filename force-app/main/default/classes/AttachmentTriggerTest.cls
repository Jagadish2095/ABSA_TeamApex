/**@description Test Class for AttachmentTrigger
* @author  Hari
* @since 2021-06-12
* **/
@isTest 
public class AttachmentTriggerTest {
    /*
    @testSetup static void testDataSetup() {
        String caserecordTypeId  = Schema.SObjectType.case.getRecordTypeInfosByName().get('FIC Case').getRecordTypeId();
        list<case> testcase=TestDataFactory.getTomCases('FIC_Case',1);        
        testcase[0].RecordtypeId=caserecordTypeId;
        insert testcase[0];                
    } */
    
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
    }
    
    @isTest private static void attachmentDeleteFromOppTest(){
        Opportunity opp = [SELECT Id FROM Opportunity WHERE RecordType.Name='Investment Opportunity'LIMIT 1];
        opp.Email_Status__c = 'Submitted';
        opp.Sys_BypassValidation__c = true;
        update opp;
        Attachment attach = createAttachment('Opp-attachment',opp.Id);
        Test.startTest();
        try{
            delete attach;
        }
        catch(Exception ex){
            System.assertEquals(ex.getMessage().contains('You cannot remove/delete this file because it has been shared to customer.'), true);
        }
        Test.stopTest();
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
    
     @isTest static void migrateTest() {
        //case caseRec=[select id,RecordType.name from Case Where Recordtype.DeveloperName='FIC_Case' LIMIT 1];
        //String caserecordTypeId  = Schema.SObjectType.case.getRecordTypeInfosByName().get('FIC Case').getRecordTypeId();
        list<case> caseRec=TestDataFactory.getTomCases('FIC_Case',1);
        insert caseRec[0];
        Attachment attachmentRec=new Attachment(Body=Blob.valueOf('test.pdf'),parentId=caseRec[0].id,
        				Name='Note_' + System.now().format('yyyy_MM_dd_hh_mm_ss') + '.txt');
        insert attachmentRec;
        System.assert(attachmentRec.id!= null,false);
        Test.startTest();
        	AttachmentTriggerHandler.migrateAttachmentsToFiles(new set<id>{attachmentRec.id},new set<id>{caseRec[0].id});
        Test.stopTest();
    }
    
    @isTest static void insertContentLinkTest() {
        //case caseRec=[select id,RecordType.name from Case Where Recordtype.DeveloperName='FIC_Case' LIMIT 1];
        //String caserecordTypeId  = Schema.SObjectType.case.getRecordTypeInfosByName().get('FIC Case').getRecordTypeId();
        list<case> caseRec=TestDataFactory.getTomCases('FIC_Case',1);
        insert caseRec[0];
        Attachment attachmentRec=new Attachment(Body=Blob.valueOf('test.pdf'),parentId=caseRec[0].id,
        				Name='Note_' + System.now().format('yyyy_MM_dd_hh_mm_ss') + '.txt');
        insert attachmentRec;
        System.assert(attachmentRec.id!= null,false);
        ContentVersion cVersion = new ContentVersion(ContentLocation = 'S',
						PathOnClient = attachmentRec.Name,Origin = 'C',
                        Title = attachmentRec.Name,VersionData = attachmentRec.Body,Comments__c=attachmentRec.id);
        insert cVersion;
        
        Test.startTest();
        AttachmentTriggerHandler.insertcontentDocumentLink(
            				new list<ContentVersion>{cVersion},
            				new map<id,Attachment>{attachmentRec.id=>attachmentRec},
        					new map<id,id>{attachmentRec.id=>caseRec[0].id});
        Test.stopTest();
    }
    
    @isTest static void deleteTest() {
        //case caseRec=[select id,RecordType.name from Case Where Recordtype.DeveloperName='FIC_Case' LIMIT 1];
        //String caserecordTypeId  = Schema.SObjectType.case.getRecordTypeInfosByName().get('FIC Case').getRecordTypeId();
        list<case> caseRec=TestDataFactory.getTomCases('FIC_Case',1);
        insert caseRec[0];
        Attachment attachmentRec=new Attachment(Body=Blob.valueOf('test.pdf'),parentId=caseRec[0].id,
        				Name='Note_' + System.now().format('yyyy_MM_dd_hh_mm_ss') + '.txt');
        insert attachmentRec;
        System.assert(attachmentRec.id!= null,false);
        Test.startTest();
        
        	AttachmentTriggerHandler.deleteAttachmentsMigratedToFiles(new list<Attachment>{attachmentRec});
        Test.stopTest();
    }
    
}