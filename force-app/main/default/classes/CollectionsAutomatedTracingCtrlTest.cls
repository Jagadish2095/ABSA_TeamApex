/**
 * @description Test class for CollectionsAutomatedTracing component
 * @author Jason Quevauvilliers
 * @created 2021-04-14
 */
@IsTest
public class CollectionsAutomatedTracingCtrlTest {
	@isTest
	static void testGetContactDetailsFromCPB() {
		// Set mock callout class
		Test.setMock(HttpCalloutMock.class, new CPBValidate_Mock_ApiRest(StringConstants.POSITIVE_STRING));
		IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new List<String>{ StringConstants.CPB_VALIDATE });
		Id recordTypeId = Schema.SObjectType.Site__c.getRecordTypeInfosByName().get('Branch Site').getRecordTypeId();
		Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User (Business Banker)'];
		User testUser = new User(
			Alias = 'standt',
			Email = 'standarduser@testorg.com',
			EmailEncodingKey = 'UTF-8',
			LastName = 'Testing',
			LanguageLocaleKey = 'en_US',
			LocaleSidKey = 'en_US',
			ProfileId = p.Id,
			SiteCode__c = 'test code',
			AB_Number__c = 'Test AB number',
			Teller_Operator_Code__c = '8764',
			TimeZoneSidKey = 'America/Los_Angeles',
			UserName = '1user@testorg.com'
		);
		insert testUser;
		Site__c testSiteRecord = new Site__c(Name = 'Test site', Site_Code__c = 'test code', RecordTypeId = recordTypeId);
		insert testSiteRecord;
		Test.startTest();
		System.runAs(testUser) {
			CPBValidate_Resp_IB_v1 responseBean = CollectionsAutomatedTracingController.getContactDetailsFromCPB('7707077777087', 'Burger');
			System.assertEquals(200, responseBean.statusCode, 'Assert Failed');
		}
		Test.stopTest();
	}

	@isTest
	static void testABNumberAuraException() {
		// Set mock callout class
		Test.setMock(HttpCalloutMock.class, new CPBValidate_Mock_ApiRest(StringConstants.POSITIVE_STRING));
		IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new List<String>{ StringConstants.CPB_VALIDATE });
		Id recordTypeId = Schema.SObjectType.Site__c.getRecordTypeInfosByName().get('Branch Site').getRecordTypeId();
		Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User (Business Banker)'];
		User testUser = new User(
			Alias = 'standt',
			Email = 'standarduser@testorg.com',
			EmailEncodingKey = 'UTF-8',
			LastName = 'Testing',
			LanguageLocaleKey = 'en_US',
			LocaleSidKey = 'en_US',
			ProfileId = p.Id,
			SiteCode__c = 'test code',
			Teller_Operator_Code__c = '8764',
			TimeZoneSidKey = 'America/Los_Angeles',
			UserName = '2user@testorg.com'
		);
		insert testUser;
		Site__c testSiteRecord = new Site__c(Name = 'Test site', Site_Code__c = 'test code', RecordTypeId = recordTypeId);
		insert testSiteRecord;
		Test.startTest();
		try {
			System.runAs(testUser) {
				CPBValidate_Resp_IB_v1 responseBean = CollectionsAutomatedTracingController.getContactDetailsFromCPB('7707077777087', 'Burger');
			}
		} catch (AuraHandledException e) {
			System.assert(e.getMessage().containsIgnoreCase('User ab number missing'), 'Assert Failed');
		}
		Test.stopTest();
	}
}