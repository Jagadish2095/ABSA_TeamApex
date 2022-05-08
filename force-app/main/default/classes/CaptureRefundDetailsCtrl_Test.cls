@isTest
public with sharing class CaptureRefundDetailsCtrl_Test {
    @testSetup
    static void dataCreation() {
        Account account = new Account(Name = 'Test Account');
        insert account;

        Contact contact = new Contact(LastName = 'Test contact', AccountId = account.Id, Email = 'agents@support.co.za');
        insert contact;

        Integration_Translation__c intTrans = new Integration_Translation__c();
        intTrans.Name = 'AccountType';
        intTrans.Internal_Value__c = 'Test';
        intTrans.External_Value__c = 'Test';
        intTrans.System_Name__c = 'EB SMS';
        intTrans.Value_Type__c = 'Account Type';
        intTrans.Direction__c = StringConstants.OUTBOUND_RECORD_TYPE;
        insert intTrans;

        // Sweep
        Case testCase= new Case();
        testCase.Description='okkk';
        testCase.AccountId = account.id;
        testCase.Bypass_Validation_Rules__c = true;
        testCase.Out_Of_SLA_Comments__c = 'true';
        testCase.Out_Of_SLA_Reason__c = 'Investigation';
        testCase.Status='In Progress';
        testCase.Extended_Request_Data__c='';
        testCase.Comments__c='okkk';
        insert testCase;

        Case testCase2= new Case();
        testCase2.Description='No CaseTransaction';
        testCase2.AccountId = account.id;
        testCase2.Bypass_Validation_Rules__c = true;
        testCase2.Out_Of_SLA_Comments__c = 'true';
        testCase2.Out_Of_SLA_Reason__c = 'Investigation';
        testCase2.Status='In Progress';
        testCase2.Comments__c='No CaseTransaction';
        insert testCase2;

        Case_Transaction__c caseT = new Case_Transaction__c();
        caseT.Amount__c=53000;
        caseT.Case__c=testCase.Id;
        caseT.Reason__c='Ok';
        caseT.Reason_Comments__c='otherReasonComment';
        caseT.Reference__c='reference';
        caseT.Service_Group__c='Everyday Banking - Collections';
        caseT.Source_Account__c='459459595959';
        caseT.Target_Account__c='474747474384';
        caseT.Source_Account_Type__c='CQ';
        caseT.Target_Account_Type__c='CQ';
        caseT.Status__c='Approved';
        caseT.jobType__c = 'Request Refund';
        caseT.Collection_Phase__c= 'Legal';
        caseT.Transaction_Date__c= Date.today();

        insert caseT;
        Group grp= new Group();
        grp.Name='Sweep_Queues';
        grp.DeveloperName='Sweep_Queues';
        grp.Type='Queue';
        insert grp;
        Group grp1= new Group();
        grp1.Name='Sweep Service Response Failed Cases';
        grp1.DeveloperName='SweepSweep_Service_Response_Failed_Cases';
        grp1.Type='Queue';
        insert grp1;


    }
    @isTest
    public static void verifyAccount() {

        Test.setMock(HttpCalloutMock.class, Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(StringConstants.POSITIVE_STRING, dsCheckDigitVerificationV1_IH_v1_Test.STATIC_RESOURCE_NAME_MOCK_POSITIVE));
        IntegrationTestDataFactory.insertIntegrationSettings(
                StringConstants.JITTERBIT2,
                new List<String>{ dsCheckDigitVerificationV1_IH_v1.INTEGRATION_SERVICE_NAME }
        );
        Test.startTest();
        String responseBean = CaptureRefundDetailsCtrl.verifyAccount('1573017159','195705','01');

        Test.stopTest();
         System.assertEquals(responseBean, '0');

    }


    @isTest
    public static void checkIfIsCaseTransaction() {
        Case caseRecord=[SELECT Id FROM Case  limit 1];
        Case_Transaction__c case_transaction = new Case_Transaction__c();
        test.startTest();
        try {
            case_transaction=  CaptureRefundDetailsCtrl.getClientRefundRequest(caseRecord.Id);

        }catch(Exception e){
            e.getMessage();
        }
        Test.stopTest();
        system.assert(case_transaction !=null, true);
    }


    @isTest
    public static void testCIGetAccountNoIntegrationService() {
        List<Account> accountList = TestDataFactory.getPersonAccounts('lastName', 'Individual_Client', 1);
        accountList[0].LastName = 'SKOSANA';
        accountList[0].ID_Type__pc = 'SA Identity Document';
        accountList[0].ID_Number__pc = '8505225522085';
        accountList[0].CIF__c = 'ARENTAL001';
        insert accountList;

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new CIgetAcctLinkedToClientCodeMock_ApiRest(StringConstants.POSITIVE_STRING));
        Test.startTest();
        CIgetAcctLinkedToClientCode_Resp_IB_v1 responseBean = CaptureRefundDetailsCtrl.getAccountDetails(accountList[0].Id);
        System.assertNotEquals(200, responseBean.statusCode, 'Assert Failed');
        Test.stopTest();
    }
    @isTest
    public static void test_logicAfterApproveReject_Positive() {

        Test.setMock(HttpCalloutMock.class, new MBinitiatePaymentV10_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.MBinitiatePaymentV10_STRING});
        List<Case_Transaction__c> caseTranasactionIDList=[SELECT Id FROM Case_Transaction__c  limit 1];
        List<Id> listIds= new List<Id>();
        listIds.add(caseTranasactionIDList[0].Id);
        Test.startTest();

        CaptureRefundDetailsCtrl.approveReject(listIds);
        system.assert(caseTranasactionIDList !=null, 'Case closed');


        Test.stopTest();
    }



    @isTest
    public static void testGetOutboundTranslation() {
        Test.startTest();
        String result = CaptureRefundDetailsCtrl.getOutboundTranslation('EB SMS', 'Account Type', 'Test');
        Test.stopTest();

        system.assertEquals('Test', result, 'Assert Failed');
    }


    @isTest
    public static void saveJson_test() {

        Case caseRecord=[SELECT Id, Extended_Request_Data__c  FROM Case WHERE Comments__c ='okkk' limit 1];
        Test.startTest();
        CaptureRefundDetailsCtrl.saveNewJson(caseRecord.Id, 'newjson');
        Test.stopTest();
        Case caseRecord2=[SELECT Id, Extended_Request_Data__c  FROM Case  WHERE Comments__c ='okkk'limit 1];
        system.assertEquals('newjson', caseRecord2.Extended_Request_Data__c);
    }
}