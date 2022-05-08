/**
 * @description Test Class for AVAFAccountTypeClassification
 * @author  Koketso Mpshane
 * @date    16/03/2021
 */
@isTest
public class AVAFAccountTypeClassificationTest {
	/*
	 * @description Method to create test data
	 */
	@testSetup
	static void dataCreation() {
		Map<String, Schema.RecordTypeInfo> accountRecordTypeMap = Account.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();

		Account acc = new Account(Name = 'testAccount', RecordTypeId = accountRecordTypeMap.get('IndustriesIndividual').getRecordTypeId());
		insert acc;

		Contact con = new Contact(LastName = 'Test contact', AccountId = acc.Id, Email = 'con@test.com');
		insert con;

		BusinessHours businessHr = [SELECT Id FROM BusinessHours LIMIT 1];

		Service_Group__c serviceGr = new Service_Group__c();
		serviceGr.Name = 'Test1';
		serviceGr.Assign_Record_Type__c = 'Email';
		serviceGr.Response_Email_Address__c = 'evg@t.com';
		serviceGr.Open_New_Case__c = true;
		serviceGr.Queue__c = 'Email';
		serviceGr.Business_Hours__c = businessHr.Id;
		serviceGr.Internal_SLA_Time_Measure__c = 'Hour(s)';
		serviceGr.Internal_SLA_Units__c = '8';
		insert serviceGr;

		Map<String, Schema.RecordTypeInfo> caseRecordTypeMap = Case.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();

		Case caseRec = new Case();
		caseRec.RecordTypeId = caseRecordTypeMap.get('Service_Request').getRecordTypeId();
		caseRec.sd_Service_Group__c = serviceGr.Name;
		caseRec.sd_Service_Group_Id__c = serviceGr.Id;
		caseRec.Status = 'New';
		caseRec.Origin = 'Email';
		caseRec.AccountId = acc.Id;
		caseRec.ContactId = con.Id;
		insert caseRec;

		IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ BAPISFContrDetails_IH_v1.INTEGRATION_SERVICE_NAME });
	}
	/*
	 * @description Method to testGetContractDetailsCorpCodePositive
	 */
	@isTest
	static void testGetContractDetailsCorpCodePositive() {
		List<String> accList = new List<String>{ '00073552449' };

		Test.startTest();
		Test.setMock(
			HttpCalloutMock.class,
			Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(
				StringConstants.POSITIVE_STRING,
				BAPISFContrDetails_IH_v1_Test.STATIC_RESOURCE_NAME_MOCK_POSITIVE
			)
		);

		List<String> result = AVAFAccountTypeClassification.getContractDetailsCorpCode(accList);
		Test.stopTest();

		System.assert(!result[0].StartsWith('Error:'), 'Assert failed');
	}
	/*
	 * @description Method to testGetContractDetailsCorpCodeNegative
	 */
	@isTest
	static void testGetContractDetailsCorpCodeNegative() {
		List<String> accList = new List<String>{ '00073552449' };

		Test.startTest();
		Test.setMock(HttpCalloutMock.class, Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(StringConstants.POSITIVE_STRING, 'TEST'));

		List<String> result = AVAFAccountTypeClassification.getContractDetailsCorpCode(accList);
		Test.stopTest();

		System.assert(result[0].StartsWith('Error:'), 'Assert failed');
	}
	/*
	 * @description Method to testWithNullAccount
	 */
	@isTest
	static void testWithNullAccount() {
		List<String> accList = new List<String>();

		Test.startTest();
		Test.setMock(
			HttpCalloutMock.class,
			Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(
				StringConstants.POSITIVE_STRING,
				BAPISFContrDetails_IH_v1_Test.STATIC_RESOURCE_NAME_MOCK_POSITIVE
			)
		);
		List<String> result = AVAFAccountTypeClassification.getContractDetailsCorpCode(null);
		Test.stopTest();

		System.assert(result[0].StartsWith('Error:'), 'Assert failed');
	}
	/*
	 * @description Method to testWithBlankABnumber
	 */
	@isTest
	static void testWithBlankABnumber() {
		User usr = [SELECT Id FROM User WHERE AB_Number__c = :null AND IsActive = :true LIMIT 1];
		List<String> accList = new List<String>{ '00073552449' };

		System.runAs(usr) {
			Test.startTest();
			Test.setMock(
				HttpCalloutMock.class,
				Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(
					StringConstants.POSITIVE_STRING,
					BAPISFContrDetails_IH_v1_Test.STATIC_RESOURCE_NAME_MOCK_POSITIVE
				)
			);

			List<String> result = AVAFAccountTypeClassification.getContractDetailsCorpCode(accList);
			Test.stopTest();

			System.assert(result[0].StartsWith('Error:'), 'Assert failed');
		}
	}
	/*
	 * @description Method to testWithBlankAccount
	 */
	@isTest
	static void testWithBlankAccount() {
		List<String> accList = new List<String>();

		Test.startTest();
		Test.setMock(
			HttpCalloutMock.class,
			Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(
				StringConstants.POSITIVE_STRING,
				BAPISFContrDetails_IH_v1_Test.STATIC_RESOURCE_NAME_MOCK_POSITIVE
			)
		);

		List<String> result = AVAFAccountTypeClassification.getContractDetailsCorpCode(accList);
		Test.stopTest();

		System.assert(result[0].StartsWith('Error:'), 'Assert failed');
	}
}