/**
 * @description Test Class for HLBondCancellationRequestController
 * @author  Koketso Mpshane
 * @date    04/06/2021
 */
@isTest
public class HLBondCancellationRequestControllerTest {
    /**
	 * @description Purpose : Method to create test data
	 */
	@testSetup
	static void dataCreation() {

        BusinessHours businessHr = [SELECT Id FROM BusinessHours LIMIT 1];

        Case testCase = new Case();
        testCase.Status = 'New';
        insert testCase;

		IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ MLgetAcctInfoCUS1V1_IH_v1.INTEGRATION_SERVICE_NAME });
		IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ MLupdAcctInfoCUS1V1_IH_v1.INTEGRATION_SERVICE_NAME });
	}

    @IsTest
	static void testGetAccountInformationNegative() {

        Test.setMock(HttpCalloutMock.class, new MLgetAcctInfoCUS1V1_Mock_ApiRest(StringConstants.NEGATIVE_STRING));

        Test.startTest();
		String response = HLBondCancellationRequestController.getAccountInformation('8050306640');
		Test.stopTest();

        System.assert(response.StartsWith('Error:'), 'Assert failed');

    }

    @IsTest
	static void testUpdateAccountInformation() {
        String STATIC_RESOURCE_NAME_MOCK_POSITIVE = 'Mock_Positive_MLupdAcctInfoforCUS1V1Service_v1';

        Test.setMock(
			HttpCalloutMock.class,
			Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(StringConstants.POSITIVE_STRING, STATIC_RESOURCE_NAME_MOCK_POSITIVE)
		);

        Test.startTest();
		String response = HLBondCancellationRequestController.updateAccountInformation('8050306640', 'P001', 11, double.valueOf(1.2));
		Test.stopTest();

		Map<String, Object> responseObj = (Map<String, Object>) JSON.deserializeUntyped(response);
		System.assertEquals(200, responseObj.get('statusCode'), 'Assert failed');
    }

    @IsTest
	static void testUpdateAccountNumberField() {

        Case tstCase = [Select Id, Account_Number__c From Case Limit 1];

        Test.startTest();
		HLBondCancellationRequestController.updateAccountNumberField(tstCase.Id, '8050306640');
		Test.stopTest();

        Case updatedCase = [Select Id, Account_Number__c From Case Limit 1];

        system.assertEquals('8050306640', updatedCase.Account_Number__c, 'Assert failed');
    }

    @IsTest
	static void testCreateServiceRequestCase() {

        Case tstCase = [Select Id, AccountId, Account_Number__c From Case Limit 1];

        Test.startTest();
		HLBondCancellationRequestController.createServiceRequestCase(tstCase.Id, tstCase.AccountId, 'Test', 'Test', 'Propertyhub', 'Propertyhub');
		Test.stopTest();

        Case createdCase = [Select Id, AccountId From Case Limit 1];

        system.assertEquals(tstCase.AccountId, createdCase.AccountId, 'Assert failed');
    }

}