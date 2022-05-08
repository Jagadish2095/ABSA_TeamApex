/**
 * @description Controller Test Class For CardTransactionHistoryController
 * @author Manideep kenche
 * @created   2021/09/28
 *
 */
@isTest
public class CardTransactionHistoryControllerTest {
    @TestSetup
    static void makeData() {
        Account account = new Account(Name = 'Test Account', CIF__c = 'ATRUST1375');
        insert account;
        Contact contact = new Contact(
            LastName = 'Test contact',
            AccountId = account.Id,
            Email = 'agents@support.co.za'
        );
        insert contact;
        Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName()
            .get('Service Request')
            .getRecordTypeId();
        Service_Group__c sGroup = new Service_Group__c(Name = 'Test');
        insert sGroup;
        
        BusinessHours businessHr = [SELECT Id FROM BusinessHours LIMIT 1];
       
        Service_Group__c serviceGroupRecord = new Service_Group__c(Name='Early Risk Detection 1st Party Fraud',Queue__c='Queue',Active__c=true, Assign_Record_Type__c = 'Complaint',Business_Hours__c=businessHr.Id);
        insert serviceGroupRecord;
        Service_Level__c sl = new Service_level__c(Name='SL', Default_Service_Level__c = true, External_SLA_Time_Measure__c = 'Day(s)', External_SLA_Units__c = '5');
        insert sl;
        Service_Type__c st = new Service_Type__c(Name='1st Party Fraud', Type__c='Type', Subtype__c='Subtype');
        insert st;
        Service_Group_Type__c sgt = new Service_Group_Type__c(Service_Group__c=serviceGroupRecord.Id, Service_Level__c=sl.id, Service_Type__c=st.Id);
        insert sgt;
        
         Case caseRec = new Case(
            Status = 'New',
            Origin = 'Email',
            AccountId = account.Id,
            Risk_Management_Centre__c = 'Digital Fraud',
            Email_From_Address__c = 'test@ret.com',
            Email__c = 'test@ret.com',
            RecordTypeId = caseRecordTypeId,
            Subject = 'Test',
            Description = 'Test',
            Type__c = 'Test',
            sd_Service_Group_Id__c = serviceGroupRecord.Id,
            sd_Service_Group__c = 'Everyday Banking - Collections',
            Out_Of_SLA_Reason__c = 'Feedback/Follow-Up',
            Out_Of_SLA_Comments__c = 'Test'
        );
        insert caseRec;
    }
    
    @isTest
    static void getTransactionalHistoryTestPositive() {
        String policyNumber = '6635806352';
        Case caseRecord=[SELECT Id FROM Case  limit 1];
        
        IntegrationTestDataFactory.insertIntegrationSettings(
            StringConstants.JITTERBIT2,
            new List<String>{ PolicyLoadByRefNo_IH_v1.INTEGRATION_SERVICE_NAME }
        );
        Test.setMock(
            HttpCalloutMock.class,
            Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(
                StringConstants.POSITIVE_STRING,
                PolicyLoadByRefNo_IH_v1_Test.STATIC_RESOURCE_NAME_MOCK_POSITIVE
            )
        );
        Test.startTest();
        
        String testData = CardTransactionHistoryController.getTransactionalHistory(policyNumber,caseRecord.Id);
        
        caseRecord.sd_Service_Group__c = 'Early Risk detection - PFD Case Escalated to Fraud';
        update caseRecord;
        String testData2 = CardTransactionHistoryController.getTransactionalHistory(policyNumber,caseRecord.Id);
        
        Test.stopTest();
        
        System.assertEquals(false, String.isEmpty(testData), 'Assertion Failed');
    }
    @isTest
    static void getTransactionalHistoryTestResponseNull() {
        String policyNumber = '';
       
         Exception capturedException;
        Case caseRecord=[SELECT Id FROM Case  limit 1];
        
        Test.startTest();
        Test.setMock(
            HttpCalloutMock.class,
            Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(
                StringConstants.POSITIVE_STRING,
                PolicyLoadByRefNo_IH_v1_Test.STATIC_RESOURCE_NAME_MOCK_POSITIVE
            )
        );
        try{
        CardTransactionHistoryController.getTransactionalHistory('',caseRecord.Id);
        }
        catch (Exception e)
        {
           capturedException = e ;
        }
        Test.stopTest();
        
       System.assertNotEquals(null, capturedException, 'Exception should be thrown');
    }
    @isTest
    static void getTransactionalHistoryTestNoResponse() {
       String policyNumber = '663580635';
         Exception capturedException;
        Case caseRecord=[SELECT Id FROM Case  limit 1];
        
        Test.startTest();
        Test.setMock(
            HttpCalloutMock.class,
            Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(
                StringConstants.POSITIVE_STRING,
                PolicyLoadByRefNo_IH_v1_Test.STATIC_RESOURCE_NAME_MOCK_POSITIVE
            )
        );
        try{
        CardTransactionHistoryController.getTransactionalHistory(policyNumber,caseRecord.Id);
        }
        catch (Exception e)
        {
           capturedException = e ;
        }
        Test.stopTest();
        
       System.assertNotEquals('Unexpected response from service.Please contact your administrator', capturedException.getMessage(), 'Exception should be thrown');
    }
}