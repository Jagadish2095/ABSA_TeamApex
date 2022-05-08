/**
 * @description       : AttachmentControllerTest
 * @author            : Vinod.Thupakula@absa.africa
 * @last modified on  : 2021-11-14
 * @last modified by  : Vinod.Thupakula@absa.africa
**/
@isTest
public class AttachmentControllerTest {
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
        List<Opportunity> oppsList = TestDataFactory.getOpportunities(null, 'Investment_Opportunity', 1);
        oppsList[0].StageName = 'In Progress';
        oppsList[0].Sub_Status__c = 'Discovery Stage';
        oppsList[0].accountId = account.Id;
        insert oppsList;
    }
    @isTest private static void getAttachmentsTest(){
        Opportunity opp = [SELECT Id FROM Opportunity WHERE RecordType.Name='Investment Opportunity'LIMIT 1];
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
        contentlink.LinkedEntityId = opp.Id;
        contentlink.contentdocumentid = contentVersion_2.contentdocumentid;
        contentlink.ShareType = 'V';
        insert contentlink;
        Test.startTest();
        List<ContentVersion> result = AttachmentController.getAttachments(opp.Id);
        Test.stopTest();
        System.assertEquals(result.isEmpty(), false);
    }
    @isTest private static void getNullAttachmentsTest(){
        Opportunity opp = [SELECT Id FROM Opportunity WHERE RecordType.Name='Investment Opportunity'LIMIT 1];
        Test.startTest();
        List<ContentVersion> result = AttachmentController.getAttachments('');
        Test.stopTest();
        System.assertEquals(result == null, true);
    }
}