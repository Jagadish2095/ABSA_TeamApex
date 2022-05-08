/*
 * Integration Handler Test class for ContractCreateAdhocDO Service
 * @author Koketso Mpshane
 * @created 2021-02-19

 * @updated 2021-03-12
 *
 * @updated by Bhanumurty Rayala
 * @updated on 2021-09-13
 *
 */
@isTest
public class AdhocPaymentControllerTest {
	/*
	 * Purpose : Method to create test data
	 */
	@testSetup
	static void dataCreation() {
		List<Integration_Translation__c> intTransList = new List<Integration_Translation__c>();

		Integration_Translation__c intTrans1 = new Integration_Translation__c();
		intTrans1.Name = 'Exergy Account Type';
		intTrans1.Internal_Value__c = 'Current';
		intTrans1.External_Value__c = '1';
		intTrans1.System_Name__c = 'Exergy';
		intTrans1.Value_Type__c = 'Account Type';
		intTrans1.Direction__c = StringConstants.OUTBOUND_RECORD_TYPE;
		intTransList.add(intTrans1);

		Integration_Translation__c intTrans2 = new Integration_Translation__c();
		intTrans2.Name = 'Exergy Bank ID';
		intTrans2.Internal_Value__c = 'Test Bank';
		intTrans2.External_Value__c = '1';
		intTrans2.System_Name__c = 'Exergy';
		intTrans2.Value_Type__c = 'Bank Name';
		intTrans2.Direction__c = StringConstants.OUTBOUND_RECORD_TYPE;
		intTransList.add(intTrans2);

		Integration_Translation__c intTrans3 = new Integration_Translation__c();
		intTrans3.Name = 'Exergy Branch ID';
		intTrans3.Internal_Value__c = '0001';
		intTrans3.External_Value__c = '1';
		intTrans3.System_Name__c = 'Exergy';
		intTrans3.Value_Type__c = 'Branch ID';
		intTrans3.Direction__c = StringConstants.OUTBOUND_RECORD_TYPE;
		intTransList.add(intTrans3);

		insert intTransList;

		IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ PolicyLoadByRefNo_IH_v1.INTEGRATION_SERVICE_NAME });
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT2,
			new List<String>{ ContractCreateAdhocDO_IH_v1.INTEGRATION_SERVICE_NAME }
		);
	}

	@isTest
	static void testFetchPolicyDetailsPositive() {
		Test.startTest();
		Test.setMock(
			HttpCalloutMock.class,
			Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(
				StringConstants.POSITIVE_STRING,
				PolicyLoadByRefNo_IH_v1_Test.STATIC_RESOURCE_NAME_MOCK_POSITIVE
			)
		);
		String response = AdhocPaymentController.fetchPolicyDetails('6635633325');
		Test.stopTest();

		System.assert(response.StartsWith('{'), 'Assert failed');
	}

	@isTest
	static void testFetchPolicyDetailsNegative() {
		Test.startTest();
		Test.setMock(HttpCalloutMock.class, Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(StringConstants.POSITIVE_STRING, '{Test}'));
		String response = AdhocPaymentController.fetchPolicyDetails('');
		Test.stopTest();

		System.assert(response.StartsWith('Error:'), 'Assert failed');
	}

	@isTest
	static void testCreateAdhocDebitOrderPositive() {
		Map<String, String> debitOrderParamsMap = new Map<String, String>();
		debitOrderParamsMap.put('policyNumber', '6635633325');
		debitOrderParamsMap.put('collectionDate', '20210101');
		debitOrderParamsMap.put('accountName', 'TEST');
		debitOrderParamsMap.put('accountNo', '75000000491');
		debitOrderParamsMap.put('accountType', 'Current');
		debitOrderParamsMap.put('branchCode', '0001');
		debitOrderParamsMap.put('bankName', 'Test Bank');
		debitOrderParamsMap.put('externalBranchID', '34');
		debitOrderParamsMap.put('externalBankID', '34');
		debitOrderParamsMap.put('bankDetailsChanged', 'true');

		Test.startTest();
		Test.setMock(
			HttpCalloutMock.class,
			Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(
				StringConstants.POSITIVE_STRING,
				ContractCreateAdhocDO_IH_v1_Test.STATIC_RESOURCE_NAME_MOCK_POSITIVE
			)
		);
		String response = AdhocPaymentController.createAdhocDebitOrder(debitOrderParamsMap);
		Test.stopTest();

		Map<String, Object> responseObj = (Map<String, Object>) JSON.deserializeUntyped(response);
		System.assertEquals(200, responseObj.get('statusCode'), 'Assert failed');
	}

	@isTest
	static void testCreateAdhocDebitOrderNegative() {
		Map<String, String> debitOrderParamsMap = new Map<String, String>();
		debitOrderParamsMap.put('policyNumber', 'test');
		debitOrderParamsMap.put('collectionDate', 'test');
		debitOrderParamsMap.put('accountName', 'TEST');
		debitOrderParamsMap.put('accountNo', 'test');
		debitOrderParamsMap.put('accountType', 'Current');
		debitOrderParamsMap.put('branchCode', '0001');
		debitOrderParamsMap.put('bankName', 'Test Bank');
		debitOrderParamsMap.put('externalBranchID', '34');
		debitOrderParamsMap.put('externalBankID', '34');
		debitOrderParamsMap.put('bankDetailsChanged', 'false');

		Test.startTest();
		Test.setMock(HttpCalloutMock.class, Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(StringConstants.POSITIVE_STRING, '{Error}'));
		String response = AdhocPaymentController.createAdhocDebitOrder(debitOrderParamsMap);
		Test.stopTest();

		System.assert(response.StartsWith('Error:'), 'Assert failed');
	}

	@isTest
	static void getTransactionalHistoryTest() {
		String policyNumber = '6635806352';
		Test.startTest();
		Test.setMock(
			HttpCalloutMock.class,
			Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(
				StringConstants.POSITIVE_STRING,
				PolicyLoadByRefNo_IH_v1_Test.STATIC_RESOURCE_NAME_MOCK_POSITIVE
			)
		);
		String testData = AdhocPaymentController.getTransactionalHistory(policyNumber);
		Test.stopTest();

		System.assertEquals(false, String.isEmpty(testData), 'Assertion Failed');
	}
}