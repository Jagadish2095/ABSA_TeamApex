/**
* @description ColletctionCycleCtlr_Test
* @author Kamil Rega
* @created 2020/02/05
*/
@isTest
public with sharing class ColletctionCycleCtlr_Test {
    @testSetup
    static void dataCreation() {
        Id rtId = [SELECT Id FROM RecordType WHERE IsPersonType = TRUE AND SObjectType='Account' LIMIT 1].Id;

        Account account = new Account( LastName='test', FirstName='test',RecordTypeId=rtId);
        insert account;
        
        Contact contact = new Contact(LastName = 'Test contact', Email = 'agents@support.co.za');
        insert contact;

        Integration_Translation__c intTrans = new Integration_Translation__c();
        intTrans.Name = 'AccountType';
        intTrans.Internal_Value__c = 'Test';
        intTrans.External_Value__c = 'Test';
        intTrans.System_Name__c = 'EB SMS';
        intTrans.Value_Type__c = 'Account Type';
        intTrans.Direction__c = StringConstants.OUTBOUND_RECORD_TYPE;
        insert intTrans;

        BusinessHours businessHr = [SELECT Id FROM BusinessHours LIMIT 1];

        Service_Group__c serviceGroupRecord = new Service_Group__c(Name = 'Early Risk Detection 1st Party Fraud', Queue__c = 'Queue', Active__c = true, Assign_Record_Type__c = 'Complaint', Business_Hours__c = businessHr.Id);
        insert serviceGroupRecord;
        Service_Level__c sl = new Service_level__c(Name = 'SL', Default_Service_Level__c = true, External_SLA_Time_Measure__c = 'Day(s)', External_SLA_Units__c = '5');
        insert sl;
        Service_Type__c st = new Service_Type__c(Name = '1st Party Fraud', Type__c = 'Type', Subtype__c = 'Subtype');
        insert st;
        Service_Group_Type__c sgt = new Service_Group_Type__c(Service_Group__c = serviceGroupRecord.Id, Service_Level__c = sl.id, Service_Type__c = st.Id);
        insert sgt;

        // Sweep
        Case testCase = new Case();
        testCase.Description = 'okkk';
        //testCase.CIF__c = 'ARENTAL001';
        testCase.Status = 'In Progress';
        testCase.Comments__c = 'okkk';
        testCase.Mobile__c = '13123123';
        testCase.Extended_Request_Data__c = 'test';
        testCase.Bypass_Validation_Rules__c = true;
        testCase.Account = account;
        insert testCase;

        Case_Transaction__c caseT = new Case_Transaction__c();
        caseT.Amount__c = 53000;
        caseT.Case__c = testCase.Id;
        caseT.Reason__c = 'Ok';
        caseT.Reason_Comments__c = 'otherReasonComment';
        caseT.Reference__c = 'reference';
        caseT.Service_Group__c = 'Everyday Banking - Collections';
        caseT.Source_Account__c = '459459595959';
        caseT.Target_Account__c = '474747474384';
        caseT.Source_Account_Type__c = 'CQ';
        caseT.Target_Account_Type__c = 'CQ';
        caseT.Status__c = 'Approved';
        caseT.Collection_Phase__c = 'Legal';

        insert caseT;
        Group grp = new Group();
        grp.Name = 'Sweep_Queues';
        grp.DeveloperName = 'Sweep_Queues';
        grp.Type = 'Queue';
        insert grp;
        Group grp1 = new Group();
        grp1.Name = 'Sweep Service Response Failed Cases';
        grp1.DeveloperName = 'SweepSweep_Service_Response_Failed_Cases';
        grp1.Type = 'Queue';
        insert grp1;

    }
    @isTest
    static void handleClientFinancialResponsesWhenAccountNumberIsValid() {
        Case caseRecord = [SELECT Id,OwnerId,Description,Status,Comments__c,CIF__c,Client_Mobile_Phone__c, Extended_Request_Data__c FROM Case limit 1];
        String exceptionMessage;

        Test.setMock(HttpCalloutMock.class, Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(StringConstants.POSITIVE_STRING, RetreiveTag_IH_v1_Test.STATIC_RESOURCE_NAME_MOCK_POSITIVE));
        IntegrationTestDataFactory.insertIntegrationSettings(
                StringConstants.JITTERBIT2,
                new List<String>{ RetreiveTag_IH_v1.INTEGRATION_SERVICE_NAME }
        );
        Test.setMock(HttpCalloutMock.class, Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(StringConstants.POSITIVE_STRING, RetreiveAccountPageList_IH_v1_Test.STATIC_RESOURCE_NAME_MOCK_POSITIVE));
        IntegrationTestDataFactory.insertIntegrationSettings(
                StringConstants.JITTERBIT2,
                new List<String>{ RetreiveAccountPageList_IH_v1.INTEGRATION_SERVICE_NAME }
        );
        Test.setMock(HttpCalloutMock.class, Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(StringConstants.POSITIVE_STRING, 'Mock_Positive_AccountSearch_v1'));
        IntegrationTestDataFactory.insertIntegrationSettings(
                StringConstants.JITTERBIT2,
                new List<String>{
                        AccountSearch_IH_v1.INTEGRATION_SERVICE_NAME
                }
        );
        Test.startTest();
        try {
            String jsomFromRespone = CollectionCycleController.handleClientFinancialResponses('0000000000001827', caseRecord.Id);
        } catch (Exception e)
        { 
            exceptionMessage = e.getMessage();
        }
        Test.stopTest();
        System.assertEquals(true, String.isEmpty(exceptionMessage));
    }
    @isTest
    public static void test_getCachedFinancialResponse() {
        Case caseRecord = [SELECT Id,OwnerId,Description,Status,Comments__c,CIF__c,Client_Mobile_Phone__c, Extended_Request_Data__c FROM Case limit 1];
        Test.startTest();
        String jSon = CollectionCycleController.getCachedFinancialResponse(caseRecord.Id);
        Test.stopTest();
        System.assertEquals('test', jSon);
    }
    @isTest
    public static void test_getClientPromiseToPayDetails_Positive() {

        Test.setMock(HttpCalloutMock.class, Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(StringConstants.POSITIVE_STRING, 'Mock_Positive_AccountSearch_v1'));
        IntegrationTestDataFactory.insertIntegrationSettings(
                StringConstants.JITTERBIT2,
                new List<String>{
                        AccountSearch_IH_v1.INTEGRATION_SERVICE_NAME
                }
        );
        Case caseRecord = [SELECT Id,OwnerId,Description,Status,Comments__c,CIF__c,Client_Mobile_Phone__c FROM Case limit 1];

        Test.startTest();
        String res =    CollectionCycleController.getClientPromiseToPayDetails('0000000000001827');
        Test.stopTest();

        System.assertEquals(false, String.isEmpty(res));
    }
    @isTest
    public static void getAccountCollectionPhaseAndCycle_Positive() {
        Test.setMock(HttpCalloutMock.class, Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(StringConstants.POSITIVE_STRING, AccountSearch_IH_v1_Test.STATIC_RESOURCE_NAME_MOCK_POSITIVE));
        IntegrationTestDataFactory.insertIntegrationSettings(
                StringConstants.JITTERBIT2,
                new List<String>{ AccountSearch_IH_v1.INTEGRATION_SERVICE_NAME }
        );

        Test.setMock(HttpCalloutMock.class, Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(StringConstants.POSITIVE_STRING, RetreiveTag_IH_v1_Test.STATIC_RESOURCE_NAME_MOCK_POSITIVE));
        IntegrationTestDataFactory.insertIntegrationSettings(
                StringConstants.JITTERBIT2,
                new List<String>{ RetreiveTag_IH_v1.INTEGRATION_SERVICE_NAME }
        );
        Test.setMock(HttpCalloutMock.class, Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(StringConstants.POSITIVE_STRING, RetreiveAccountPageList_IH_v1_Test.STATIC_RESOURCE_NAME_MOCK_POSITIVE));
        IntegrationTestDataFactory.insertIntegrationSettings(
                StringConstants.JITTERBIT2,
                new List<String>{ RetreiveAccountPageList_IH_v1.INTEGRATION_SERVICE_NAME }
        );
        Test.startTest();
        Map<String, String> accountDatailMap = CollectionCycleController.getAccountCollectionPhaseAndCycle('0000000000001827');
        Test.stopTest();
        System.assertEquals(false, accountDatailMap.isEmpty());
    }
}