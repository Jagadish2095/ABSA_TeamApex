/**
 * @description Controller Test Class For EarlyRiskDetection
 * @author Kamil Rega
 * @created   2021/24/09

 */
@isTest
public with sharing class EarlyRiskDetectionController_Test {
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
         Service_Group__c serviceGroupRecord2 = new Service_Group__c(Name = 'Everyday Banking - Collections', Queue__c = 'Queue', Active__c = true, Assign_Record_Type__c = 'Complaint', Business_Hours__c = businessHr.Id);
        insert serviceGroupRecord2;
        Service_Level__c sl = new Service_level__c(Name = 'SL', Default_Service_Level__c = true, External_SLA_Time_Measure__c = 'Day(s)', External_SLA_Units__c = '5');
        insert sl;
        Service_Type__c st = new Service_Type__c(Name = '1st Party Fraud', Type__c = 'Type', Subtype__c = 'Subtype');
        insert st;
        Service_Type__c st1 = new Service_Type__c(Name = 'ERD- Runway And Highover Limit Awaiting Response', Type__c = 'ERD- Runway And Highover Limit Awaiting Response', Subtype__c = 'Subtype');
        insert st1;
        Service_Group_Type__c sgt2 = new Service_Group_Type__c(Service_Group__c = serviceGroupRecord2.Id, Service_Level__c = sl.id, Service_Type__c = st1.Id);
        insert sgt2;
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
    public static void test_createTask() {
        Case caseRecord = [SELECT Id,OwnerId,Description,Status,Comments__c,CIF__c,Client_Mobile_Phone__c, Bypass_Validation_Rules__c, ClientName__c FROM Case limit 1];
        Test.startTest();
        EarlyRiskDetectionController.createReminder(caseRecord.Id, System.today(), 'New Case');
        Test.stopTest();
        Task tsk = [SELECT Id FROM Task];
        System.assertEquals(false, String.isEmpty(tsk.id));
    }

    @isTest
    public static void CaseTransferTest() {
        BusinessHours businessHr = [SELECT Id FROM BusinessHours LIMIT 1];
        Service_Group__c serviceGroupRecord = new Service_Group__c(Name = 'Early Risk detection - PFD Case Escalated to Fraud', Queue__c = 'Queue', Active__c = true, Assign_Record_Type__c = 'Complaint', Business_Hours__c = businessHr.Id);
        insert serviceGroupRecord;
        Service_Level__c sl = new Service_level__c(Name = 'SL', Default_Service_Level__c = true, External_SLA_Time_Measure__c = 'Day(s)', External_SLA_Units__c = '5');
        insert sl;
        Service_Type__c st = new Service_Type__c(Name = 'Early Risk detection - PFD Case Escalated to Fraud', Type__c = 'Type', Subtype__c = 'Subtype');
        insert st;
        Service_Group_Type__c sgt = new Service_Group_Type__c(Service_Group__c = serviceGroupRecord.Id, Service_Level__c = sl.id, Service_Type__c = st.Id);
        insert sgt;
        Case caseRecord = [SELECT Id,OwnerId,Description,Status,Comments__c,CIF__c,Client_Mobile_Phone__c FROM Case limit 1];
        String previousOwnerCase = caseRecord.OwnerId;
        Test.startTest();

        EarlyRiskDetectionController.redirectCase(caseRecord.Id);

        Test.stopTest();


        Case caseRecordAfterChange = [SELECT Id,OwnerId,Description,Status,Comments__c,CIF__c,Client_Mobile_Phone__c FROM Case limit 1];
        System.assertNotEquals(caseRecordAfterChange.OwnerId, previousOwnerCase);

    }

    @isTest
    static void getECMDocuments_Test() {
        Case caseRecord = [SELECT Id,OwnerId,Description,Status,Comments__c,CIF__c,Client_Mobile_Phone__c, Extended_Request_Data__c FROM Case limit 1];
        new WillsTestDataFactory();
        ECM_IH_V1Test.insertSettings();
        DocumentControllerTest.QueueHttpMock mock = new DocumentControllerTest.QueueHttpMock();
        mock.addResponse(JSON.serialize(HotDocsToken.getExample()));
        mock.addResponse(JSON.serialize(ECM_QueryResult.getExample()));
        mock.addResponse(JSON.serialize(ECM_GetResult_IB_V1.getExample()));
        Test.setMock(HttpCalloutMock.class, mock);

        Test.startTest();
        List<ContentVersion> docs = EarlyRiskDetectionController.getECMDocuments(caseRecord.Id, 'Ent_ProofOfId', 'caseRecord');
        Test.stopTest();

        System.assertEquals(false, docs.isEmpty());
    }
   
    @isTest
    public static void test_notifyClient() {
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {'iTouch SMS Submit - Static Sms'});
        Test.setMock(HttpCalloutMock.class, new SMSGatewayMock_APIRest(StringConstants.POSITIVE_STRING, 'Success'));
        Case caseRecord = [SELECT Id,OwnerId,Description,Status,Comments__c,CIF__c,Client_Mobile_Phone__c FROM Case limit 1];
        Test.startTest();

          EarlyRiskDetectionController.notifyClient(caseRecord.Id,caseRecord.Client_Mobile_Phone__c);
          EarlyRiskDetectionController.sendSms(caseRecord.Id,caseRecord.Client_Mobile_Phone__c);
          EarlyRiskDetectionController.pauseAndAwaitResponse(caseRecord.Id,'404028483916');

        Test.stopTest();
       
         system.assert(caseRecord !=null, 'Recieved account data');
    }


}