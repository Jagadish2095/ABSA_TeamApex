/**
 * @description Test class for ServiceAccountAdjustment Service
 * @author  Koketso Mpshane
 * @date    16/04/2021
 * @updated 08/07/2021 - Koketso Mpshane
 */
@isTest
public class MobileTopUpControllerTest {
	/**
	 * @description Method to create test data
	 */
	@testSetup
	static void dataCreation() {
		Account account = new Account(Name = 'Test Account', CIF__c = 'test');
		insert account;

		List<Integration_Translation__c> intTransList = new List<Integration_Translation__c>();

		Integration_Translation__c intTrans1 = new Integration_Translation__c();
		intTrans1.Name = 'TB Account Type';
		intTrans1.Internal_Value__c = 'CQ';
		intTrans1.External_Value__c = '20';
		intTrans1.System_Name__c = 'TB Mobile Services';
		intTrans1.Value_Type__c = 'Account Type';
		intTrans1.Direction__c = StringConstants.OUTBOUND_RECORD_TYPE;
		intTransList.add(intTrans1);

		Integration_Translation__c intTrans2 = new Integration_Translation__c();
		intTrans2.Name = 'TB Account Type';
		intTrans2.Internal_Value__c = 'SA';
		intTrans2.External_Value__c = '10';
		intTrans2.System_Name__c = 'TB Mobile Services';
		intTrans2.Value_Type__c = 'Account Type';
		intTrans2.Direction__c = StringConstants.INBOUND_RECORD_TYPE;
		intTransList.add(intTrans2);

		Integration_Translation__c intTrans3 = new Integration_Translation__c();
		intTrans3.Name = 'TB Action Code';
		intTrans3.Internal_Value__c = 'Test error code';
		intTrans3.External_Value__c = '100';
		intTrans3.System_Name__c = 'TB Mobile Services';
		intTrans3.Value_Type__c = 'Action Code';
		intTrans3.Direction__c = StringConstants.INBOUND_RECORD_TYPE;
		intTransList.add(intTrans3);

		Integration_Translation__c intTrans4 = new Integration_Translation__c();
		intTrans4.Name = 'TB Service Provider';
		intTrans4.Internal_Value__c = 'Tele';
		intTrans4.External_Value__c = 'T';
		intTrans4.System_Name__c = 'TB Mobile Services';
		intTrans4.Value_Type__c = 'Action Code';
		intTrans4.Direction__c = StringConstants.OUTBOUND_RECORD_TYPE;
		intTransList.add(intTrans4);

		insert intTransList;

		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT2,
			new List<String>{ ServiceProvidersDataEnquiry_IH_v1.INTEGRATION_SERVICE_NAME }
		);
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT2,
			new List<String>{ ServiceCustomerEligibility_IH_V1.INTEGRATION_SERVICE_NAME }
		);
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT2,
			new List<String>{ ServiceAccountAdjustment_IH_V1.INTEGRATION_SERVICE_NAME }
		);
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT2,
			new List<String>{ getMobileBeneficiaries_IH_v1.INTEGRATION_SERVICE_NAME }
		);
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT2,
			new List<String>{ addTBMobileBeneficiaries_IH_v1.INTEGRATION_SERVICE_NAME }
		);
	}
	/**
	 * @description Method to testGetServiceProvidersData
	 */
	@isTest
	static void testGetServiceProvidersData() {
		Test.startTest();
		Test.setMock(
			HttpCalloutMock.class,
			Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(
				StringConstants.POSITIVE_STRING,
				ServiceProvidersDataEnquiry_IH_v1_Test.STATIC_RESOURCE_NAME_MOCK_POSITIVE
			)
		);
		String response = MobileTopUpController.getServiceProvidersData();
		Test.stopTest();

		System.assert(response.StartsWith('{'), 'Assert failed');
	}
	/**
	 * @description Method to testProcessMobileTopUpPositive
	 */
	@isTest
	static void testProcessMobileTopUpPositive() {
		Map<String, String> mobileTopUpParamsMap = new Map<String, String>();
		mobileTopUpParamsMap.put('spid', '8805');
		mobileTopUpParamsMap.put('phoneNumber', '0746004196');
		mobileTopUpParamsMap.put('accType', '00');
		mobileTopUpParamsMap.put('accNumber', '0000000004048195352');
		mobileTopUpParamsMap.put('amount', '20');
		mobileTopUpParamsMap.put('retrievalRefNumber', 'Test12345');

		Test.startTest();
		Test.setMock(
			HttpCalloutMock.class,
			Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(
				StringConstants.POSITIVE_STRING,
				ServiceCustomerEligibility_IH_v1_Test.STATIC_RESOURCE_NAME_MOCK_POSITIVE
			)
		);
		String response = MobileTopUpController.processMobileTopUp(mobileTopUpParamsMap);
		Test.stopTest();

		Map<String, Object> responseObj = (Map<String, Object>) JSON.deserializeUntyped(response);
		System.assertEquals(200, responseObj.get('statusCode'), 'Assert failed');
	}
	/**
	 * @description Method to testProcessMobileTopUpNegative
	 */
	@isTest
	static void testProcessMobileTopUpNegative() {
		Map<String, String> mobileTopUpParamsMap = new Map<String, String>();
		mobileTopUpParamsMap.put('spid', '8805');
		mobileTopUpParamsMap.put('phoneNumber', '0746004196');
		mobileTopUpParamsMap.put('accType', '00');
		mobileTopUpParamsMap.put('accNumber', '0000000004048195352');
		mobileTopUpParamsMap.put('amount', '20');
		mobileTopUpParamsMap.put('retrievalRefNumber', 'Test12345');

		Test.startTest();
		Test.setMock(
			HttpCalloutMock.class,
			Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(
				StringConstants.POSITIVE_STRING,
				ServiceCustomerEligibility_IH_v1_Test.STATIC_RESOURCE_NAME_MOCK_NEGATIVE
			)
		);
		String response = MobileTopUpController.processMobileTopUp(mobileTopUpParamsMap);
		Test.stopTest();

		System.assert(response.startsWith('Error:'), 'Assert failed');
	}
	/**
	 * @description Method to testGetMobileBeneficiaries
	 */
	@isTest
	static void testGetMobileBeneficiaries() {
		Test.startTest();
		Test.setMock(
			HttpCalloutMock.class,
			new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, getMobileBeneficiaries_IH_v1_Test.POSITIVE_RESPONSE_BODY)
		);
		String response = MobileTopUpController.getMobileBeneficiaries('PIERIDO001');
		Test.stopTest();

		System.assert(response.startsWith('['), 'Assert failed');
	}
	/**
	 * @description Method to testAddMobileBeneficiaries
	 */
	@isTest
	static void testAddMobileBeneficiaries() {
		Test.startTest();
		Test.setMock(
			HttpCalloutMock.class,
			new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, addTBMobileBeneficiaries_IH_v1_Test.POSITIVE_RESPONSE_BODY)
		);
		String response = MobileTopUpController.addMobileBeneficiaries('PIERIDO001', '2', 'Tele', '0723935028', 'Test New Ben');
		Test.stopTest();

		System.assert(response.contains('successfully'), 'Assert failed');
	}
}