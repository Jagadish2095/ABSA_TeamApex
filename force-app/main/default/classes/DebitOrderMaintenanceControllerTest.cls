/*
 * DebitOrderMaintenanceControllerTest for testing DebitOrderMaintenanceController class
 *
 * @author  Chandra Bhushan Singh : ABSA
 * @version v1.0
 * @since   2020-07-10
 * @W-006725
 * Updated by Koketso Mpshane - 05-03-21 W-007780

 */
@isTest
public class DebitOrderMaintenanceControllerTest {
	@TestSetup
	static void makeData() {
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

		IntegrationTestDataFactory.insertIntegrationSettings(
			NHGetAccountDetailv3_IH_v1.INTEGRATION_API_NAME,
			new List<String>{ NHGetAccountDetailv3_IH_v1.INTEGRATION_SERVICE_NAME }
		);
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT2,
			new List<String>{ LAListPolicyDetailsByPolicyV7_IH_v1.INTEGRATION_SERVICE_NAME }
		);
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT2,
			new List<String>{ LAUpdateBankingDetailsV3_IH_v1.INTEGRATION_SERVICE_NAME }
		);
		IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ PolicyLoadByRefNo_IH_v1.INTEGRATION_SERVICE_NAME });
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT2,
			new List<String>{ ExergyChangeBankInformation_IH_v1.INTEGRATION_SERVICE_NAME }
		);
	}

	@IsTest
	static void getExergyAbsaLifeDataTest() {
		// Set mock callout class
		Test.setMock(
			HttpCalloutMock.class,
			Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(
				StringConstants.POSITIVE_STRING,
				PolicyLoadByRefNo_IH_v1_Test.STATIC_RESOURCE_NAME_MOCK_POSITIVE
			)
		);
		List<String> fieldList = new List<String>{ 'Payment_Plan__c.Debit_Order_Debit_Day__c' };

		Test.startTest();
		Map<String, Object> response = DebitOrderMaintenanceController.getExergyDataForAbsaLife('6633725447', fieldList);
		PolicyLoadByRefNo_Resp_IB_v1 responseBean = (PolicyLoadByRefNo_Resp_IB_v1) response.get('responseBean');
		Test.stopTest();
		System.assertEquals(200, responseBean.statusCode, 'Assert Failed');
		System.assertNotEquals(null, response.get('picklistValues'), 'Assert Failed');
	}

	@IsTest
	static void exergyBankAndContractInfoChangeTest() {
		Test.setMock(
			HttpCalloutMock.class,
			Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(
				StringConstants.POSITIVE_STRING,
				ExergyChangeBankInformation_IH_v1_Test.STATIC_RESOURCE_NAME_MOCK_POSITIVE
			)
		);

		Test.startTest();
		String response = DebitOrderMaintenanceController.exergyBankAndContractInfoChange(
			'6635635173',
			'Test',
			'75000000491',
			'Current',
			'0001',
			'Test Bank',
			'10',
			'1358',
			true
		);
		Test.stopTest();
		System.assert(response.StartsWith('{'), 'Assert Failed');
	}

	@IsTest
	static void getNHAccountInfoTest() {
		Test.setMock(
			HttpCalloutMock.class,
			new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, NHGetAccountDetailv3_IH_v1_Test.POSITIVE_RESPONSE_BODY)
		);

		Test.startTest();
		NHGetAccountDetailv3_Resp_IB_v1 responseBean = DebitOrderMaintenanceController.getHomeLoansData('04451430000038047', '00000008050453770');
		Test.stopTest();

		System.assertEquals(200, responseBean.statusCode, 'Assert Failed');
	}

	@IsTest
	static void getAbsaLifeDataTest() {
		Test.setMock(
			HttpCalloutMock.class,
			Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(
				StringConstants.POSITIVE_STRING,
				LAListPolicyDetailsByPolicyV7_IH_v1_Test.STATIC_RESOURCE_NAME_MOCK_POSITIVE
			)
		);
		List<String> fieldList = new List<String>{ 'Payment_Plan__c.Account_Type__c', 'Payment_Plan__c.Debit_Order_Debit_Day__c' };
		Test.startTest();
		Map<String, Object> response = DebitOrderMaintenanceController.getAbsaLifeData('6440952728', fieldList);
		LAListPolicyDetailsByPolicyV7_Resp_IB_v1 responseBean = (LAListPolicyDetailsByPolicyV7_Resp_IB_v1) response.get('responseBean');

		System.assertEquals(200, responseBean.statusCode, 'Assert Failed');
		System.assertNotEquals(null, response.get('picklistValues'), 'Assert Failed');
		Test.stopTest();
	}

	@IsTest
	static void updateLABankingDetailsTest() {
		Test.setMock(
			HttpCalloutMock.class,
			Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(
				StringConstants.POSITIVE_STRING,
				LAUpdateBankingDetailsV3_IH_v1_Test.STATIC_RESOURCE_NAME_MOCK_POSITIVE
			)
		);
		Test.startTest();
		LAUpdateBankingDetailsV3_Resp_IB_v1 responseBean = DebitOrderMaintenanceController.updateLABankingDetails(
			'1234',
			'6633725447',
			'ABSA',
			'20',
			'20',
			'7876554',
			'Susan',
			'28',
			'5',
			'Savings',
			'470098',
			'600'
		);

		System.assertEquals(200, responseBean.statusCode, 'Assert Failed');
		Test.stopTest();
	}

	static testMethod void testCheckBankAccount() {
		Boolean testResult = DebitOrderMaintenanceController.checkBankAccount('4048075451', '632005', 'Cheque');
		System.assertEquals(false, testResult, 'Assert Failed');
	}
}