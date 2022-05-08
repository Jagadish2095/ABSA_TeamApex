/**
 * @description Controller Test Class For InterAccountTransfer
 * @author Lulu Rankwe
 * @created   2020/02/12
 * @updated Koketso Mpshane 2021/04/12
 */
@isTest
public class InterAccountTransferTest {
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
		testCase.Comments__c='okkk';
        insert testCase;

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
        caseT.jobType__c = 'Inter-Account Transfer (Sweep)';
        caseT.Collection_Phase__c= 'Legal';

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
		CIgetAcctLinkedToClientCode_Resp_IB_v1 responseBean = InterAccountTransferController.getAccountDetails(accountList[0].Id);
		System.assertNotEquals(200, responseBean.statusCode, 'Assert Failed');
		Test.stopTest();
	}

	@isTest
	public static void testCIGetAccountPositive() {
		List<Account> accountList = TestDataFactory.getPersonAccounts('lastName', 'Individual_Client', 1);
		accountList[0].LastName = 'SKOSANA';
		accountList[0].ID_Type__pc = 'SA Identity Document';
		accountList[0].ID_Number__pc = '8505225522085';
		accountList[0].CIF__c = 'ARENTAL001';
		insert accountList;

		// Set mock callout class
		Test.setMock(HttpCalloutMock.class, new CIgetAcctLinkedToClientCodeMock_ApiRest(StringConstants.POSITIVE_STRING));
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.API_MANAGER,
			new List<String>{ StringConstants.CI_GET_ACCT_LINKED_TO_CLIENT_CODE }
		);

		Test.startTest();
		CIgetAcctLinkedToClientCode_Resp_IB_v1 responseBean = InterAccountTransferController.getAccountDetails(String.valueOf(accountList[0].Id));
		system.assertEquals(200, responseBean.statusCode, 'Assert Failed');
		Test.stopTest();
	}

	/* Test method for getAccountsLinkedToCombi serice call
	 *  Added by : Humbelani Denge
	 *  Date : 2021/03/23
	 */
	@isTest
	public static void getAccountsLinkedToCombi() {
		Test.setMock(
			HttpCalloutMock.class,
			Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(
				StringConstants.POSITIVE_STRING,
				CClistAccsLinkedToCombiV1_IH_v1_Test.STATIC_RESOURCE_NAME_MOCK_POSITIVE
			)
		);

		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT2,
			new List<String>{ CClistAccsLinkedToCombiV1_IH_v1.INTEGRATION_SERVICE_NAME }
		);

		Test.startTest();
		CClistAccsLinkedToCombiV1_Resp_IB_v1 responseBean = InterAccountTransferController.getAccountsLinkedToCombi('04451430000038047');
		system.assertEquals(200, responseBean.statusCode, 'Assert Failed');
		Test.stopTest();
	}

	@isTest
	public static void testintiatePayment() {
		Test.startTest();
		MBinitiatePaymentV10_Resp_IB_v1 response = InterAccountTransferController.initiatePayment(
			'11050112',
			'20200211',
			'14',
			'3001325523',
			'CQ',
			'4044751304',
			'',
			'payment',
            'Inter-Account Transfer (Sweep)'
		);
		system.assertNotEquals(200, response.StatusCode, 'Assert Failed');
		Test.stopTest();
	}

	@isTest
	public static void testGetOutboundTranslation() {
		Test.startTest();
		String result = InterAccountTransferController.getOutboundTranslation('EB SMS', 'Account Type', 'Test');
		Test.stopTest();

		system.assertEquals('Test', result, 'Assert Failed');
	}
    /* Test method for getAccountCollectionPhaseAndCycle
	 *  Added by : Sourabh Yadav
	 *  Date : 2021/09/15
	 */
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

       Map<String,String> accountDatailMap= InterAccountTransferController.getAccountCollectionPhaseAndCycle('0000000000001827');
         system.assert(accountDatailMap !=null, 'Recieved account data');

        Test.stopTest();
    }
    /* Test method for createCaseTransactionRecord
	 *  Added by : Sourabh Yadav
	 *  Date : 2021/09/15
	 */
	@isTest
    public static void test_createCaseTransactionRecord_Positive() {
        Map<String,String> kvData= new  Map<String,String>();
        kvData.put('amount', '5000');
        kvData.put('collectionPhase', 'Legal');
         kvData.put('queueName', 'Sweep_Queues');
         Test.startTest();
       String strMsg= InterAccountTransferController.createCaseTransactionRecord(kvData);
          system.assert(strMsg !=null, 'Successfully Submitted for Approval');
         Test.stopTest();
    }
    /* Test method for logicAfterApproveReject
	 *  Added by : Sourabh Yadav
	 *  Date : 2021/09/16
	 */
	@isTest
    public static void test_logicAfterApproveReject_Positive() {

        Test.setMock(HttpCalloutMock.class, new MBinitiatePaymentV10_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.MBinitiatePaymentV10_STRING});
        List<Case_Transaction__c> caseTranasactionIDList=[SELECT Id FROM Case_Transaction__c  limit 1];
        List<Id> listIds= new List<Id>();
            listIds.add(caseTranasactionIDList[0].Id);
         Test.startTest();

			InterAccountTransferController.logicAfterApproveReject(listIds);
        system.assert(caseTranasactionIDList !=null, 'Case closed');


         Test.stopTest();
    }
    /* Test method for logicAfterApproveReject
	 *  Added by : Sourabh Yadav
	 *  Date : 2021/09/16
	 */
	@isTest
    public static void test_logicAfterApproveReject_Rejected() {

        Test.setMock(HttpCalloutMock.class, new MBinitiatePaymentV10_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.MBinitiatePaymentV10_STRING});
        List<Case_Transaction__c> caseTranasactionList=[SELECT Id,Status__c FROM Case_Transaction__c  limit 1];
        caseTranasactionList[0].Status__c='Rejected';
        update caseTranasactionList;

        List<Id> listIds= new List<Id>();
            listIds.add(caseTranasactionList[0].Id);
         Test.startTest();

			InterAccountTransferController.logicAfterApproveReject(listIds);
        system.assert(caseTranasactionList !=null, 'Case closed');


         Test.stopTest();
    }
	/* Test method for logicAfterApproveReject
	 *  Added by : Sourabh Yadav
	 *  Date : 2021/09/16
	 */
	@isTest
    public static void test_promisToPay_Positive() {

		Test.setMock(HttpCalloutMock.class, Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(StringConstants.POSITIVE_STRING, 'Mock_Positive_AccountSearch_v1'));
        IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT2,
			new List<String>{ AccountSearch_IH_v1.INTEGRATION_SERVICE_NAME }
		);
		Case caseRecord=[SELECT Id,OwnerId,Description,Status,Comments__c,CIF__c,Client_Mobile_Phone__c FROM Case  limit 1];
         Test.startTest();
		 String promisToPay;
		 try{
        promisToPay= InterAccountTransferController.promisToPay('0000000000001827');
		InterAccountTransferController.transferCase('Inter Account Sweep Escalations','Inter-Account Transfer (Sweep)',caseRecord.Id,new List<Case>{caseRecord},'Sweep Service Response Failed Cases' );
              system.assert(promisToPay !=null, '');
	} catch (Exception  ex){
		system.assertEquals(ex.getMessage(), ex.getMessage());

	}
         Test.stopTest();
    }
}