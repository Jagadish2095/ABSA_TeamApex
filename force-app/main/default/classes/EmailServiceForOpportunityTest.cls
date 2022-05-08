/**
 * @description       : EmailServiceForOpportunityTest
 * @author            : Vinod.Thupakula@absa.africa
 * @last modified on  : 2021-11-14
 * @last modified by  : Vinod.Thupakula@absa.africa
**/
@isTest
public class EmailServiceForOpportunityTest {
    @testSetup static void dataSetup(){
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
        Account acc = new Account();
        acc.Name = 'Test Service';
        acc.Type = 'Service';
        insert acc;
        List<Opportunity> oppsList = TestDataFactory.getOpportunities(null, 'Investment_Opportunity', 1);
        oppsList[0].StageName = 'In Progress';
        oppsList[0].Sub_Status__c = 'Discovery Stage';
        oppsList[0].accountId = account.Id;
        insert oppsList;
    }
    @isTest private static void handleInboundEmailTese(){
        Opportunity opp = [SELECT Id, Sys_ThreadId__c FROM Opportunity WHERE RecordType.Name='Investment Opportunity'LIMIT 1];
        String threadSubject = opp.Sys_ThreadId__c;
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
        email.subject = threadSubject;
        email.fromName = 'test test';
        email.plainTextBody = 'Hello, this a test email body. for testing purposes only';
        Messaging.InboundEmail.BinaryAttachment[] binaryAttachments = new Messaging.InboundEmail.BinaryAttachment[1];
        Messaging.InboundEmail.BinaryAttachment binaryAttachment = new Messaging.InboundEmail.BinaryAttachment();
        binaryAttachment.Filename = 'test.txt';
        String algorithmName = 'HMacSHA1';
        Blob b = Crypto.generateMac(algorithmName, Blob.valueOf('test'), Blob.valueOf('test_key'));
        binaryAttachment.Body = b;
        binaryAttachments[0] = binaryAttachment;
        email.binaryAttachments = binaryAttachments;
        envelope.fromAddress = 'user@absa.com';
        EmailServiceForOpportunity service = new EmailServiceForOpportunity();
        Messaging.InboundEmailResult result = service.handleInboundEmail(email, envelope);
        System.assertEquals(result.success, true);
    }
}