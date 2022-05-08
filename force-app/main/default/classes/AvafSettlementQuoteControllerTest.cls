/**
 * @description Test class for AvafSettlementQuoteController controller
 * @author  Chandra Bhushan Singh : Absa
 * @version v2.0
 * @since   2020-11-04
 */
@IsTest
public class AvafSettlementQuoteControllerTest {
	/**
	 * @description Test Setup for a test class.
	 */
	@TestSetup
	static void makeData() {
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT2,
			new List<String>{ AvafSettlementQuote_IH_v1.INTEGRATION_SERVICE_NAME, AVAFCopyOfNatis_IH_v1.INTEGRATION_SERVICE_NAME }
		);
	}

	/**
	 * @description Test Method for a positive scenario
	 */
	@IsTest
	static void sendAvafSettlementQuoteTestPositive() {
		map<String, Schema.RecordTypeInfo> caseRecordTypeMap = Case.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();

		// Set mock callout class
		Test.setMock(
			HttpCalloutMock.class,
			Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(
				StringConstants.POSITIVE_STRING,
				AvafSettlementQuote_IH_v1_Test.STATIC_RESOURCE_NAME_MOCK_POSITIVE
			)
		);
		Account acc = new Account();
		acc.name = 'test acc';
		acc.CIF__c = 'HJKLL';
		insert acc;

		Test.startTest();
		String returnString = AvafSettlementQuoteController.sendAvafSettlementQuote(acc.Id, '12345678', 'test@absa.com');
		AvafSettlementQuoteController.sendPaidUpLetter(acc.Id, '12345678', 'test@absa.com');
		Test.stopTest();
		System.assertEquals('success', returnString, 'Assert Failed');
	}

	/**
	 * @description Test Method for a negative scenario
	 */
	@IsTest
	static void sendAvafSettlementQuoteTestNegative() {
		map<String, Schema.RecordTypeInfo> caseRecordTypeMap = Case.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();

		// Set mock callout class
		Test.setMock(
			HttpCalloutMock.class,
			Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(
				StringConstants.NEGATIVE_STRING,
				AvafSettlementQuote_IH_v1_Test.STATIC_RESOURCE_NAME_MOCK_POSITIVE
			)
		);
		Account acc = new Account();
		acc.name = 'test acc';
		acc.CIF__c = 'HJKLL';
		insert acc;

		Test.startTest();
		String returnString = AvafSettlementQuoteController.sendAvafSettlementQuote(acc.Id, '12345678', 'test@absa.com');
		Test.stopTest();
		System.assertEquals(null, returnString, 'Assert Failed');
	}

	/*
	 * @author  Bhanumurty Rayala : Absa
	 * @User Story	W-009261: Copy NATIS
	 * @created   2021-03-11
	 * @description Test Method for a positive scenario
	 */
	@IsTest
	static void sendCopyNatisLetterTestPositive() {
		map<String, Schema.RecordTypeInfo> caseRecordTypeMap = Case.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();

		// Set mock callout class
		Test.setMock(
			HttpCalloutMock.class,
			Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(
				StringConstants.POSITIVE_STRING,
				AVAFCopyOfNatis_IH_v1_Test.STATIC_RESOURCE_NAME_MOCK_POSITIVE
			)
		);
		Account acc = new Account();
		acc.name = 'test acc';
		acc.CIF__c = 'HJKLL';
		insert acc;

		Test.startTest();
		String returnString = AvafSettlementQuoteController.sendCopyNatisLetter(acc.Id, '12345678', 'test@absa.com');
		Test.stopTest();
		System.assertEquals('success', returnString, 'Assert Failed');
	}
}