/**
 * @description This is the Test Class of the DataPrivacyController for Create and update Case on C1V apex class
 * @author  Santosh Kumar
 * @since   2021-06-17
 **/

@isTest
public class DataPrivacyControllerTest {
	@testSetup
	private static void setup() {
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT2,
			new List<String>{ 'Involved Parties Create', 'Involved Parties Update' }
		);

		Account acc = new Account();
		acc.Name = 'Testing Data Privacy';
		acc.Data_Privacy_Flag__c = 'Request of Personal Information';
		acc.CIF__c = 'JINPIX 001';
		insert acc;

		Case newCase = new Case();
		newCase.Status = 'New';
		newCase.AccountId = acc.Id;
		insert newCase;

		Attachment attach = new Attachment();
		attach.Name = 'Unit Test Attachment';
		Blob bodyBlob = Blob.valueOf('Unit Test Attachment Body');
		attach.body = bodyBlob;
		attach.parentId = newCase.id;
		insert attach;

		Contact contact = new Contact(LastName = 'Test contact', AccountId = acc.Id, Email = 'agents@support.co.za');
		insert contact;
	}

	@isTest
	private static void getPrivacyFieldValueTest() {
		List<Account> account = [SELECT Id, Data_Privacy_Flag__c FROM Account WHERE Name = :'Testing Data Privacy' LIMIT 1];
		Test.startTest();
		DataPrivacyController.getPrivacyFieldValue(account[0].Id);
		Test.stopTest();
		system.assertEquals('Request of Personal Information', account[0].Data_Privacy_Flag__c, 'Assertion Failed');
	}

	@isTest
	private static void getDataPrivacyFlagIndiatorValTest() {
		List<Account> account = [SELECT Id, Data_Privacy_Flag__c FROM Account WHERE Name = :'Testing Data Privacy' LIMIT 1];
		Test.startTest();
		String returnedString = DataPrivacyController.getDataPrivacyFlagIndiatorVal(account[0].id);
		Test.stopTest();
		system.assertEquals('Request of Personal Information', returnedString, 'Assertion Failed');
	}

	@isTest
	private static void resetDataPrivacyFlagTest() {
		List<String> privacyDataStringList = new List<String>();
		List<Account> account = [SELECT Id, Data_Privacy_Flag__c FROM Account WHERE Name = :'Testing Data Privacy' LIMIT 1];
		privacyDataStringList.add(account[0].Data_Privacy_Flag__c);
		Test.startTest();
		String returnMessage = DataPrivacyController.resetDataPrivacyFlag(account[0].id, privacyDataStringList);
		Test.stopTest();
		system.assertEquals('Success', returnMessage, 'Assertion Failed');
	}

	@isTest
	private static void resetDataPrivacyFlagTestNull() {
		List<String> privacyDataStringList;
		List<Account> account = [SELECT Id, Data_Privacy_Flag__c FROM Account WHERE Name = :'Testing Data Privacy' LIMIT 1];
		Test.startTest();
		DataPrivacyController.resetDataPrivacyFlag(account[0].id, privacyDataStringList);
		List<Account> accountList = [SELECT Id, Data_Privacy_Flag__c FROM Account WHERE Name = :'Testing Data Privacy' LIMIT 1];
		system.assertEquals(accountList.get(0).Data_Privacy_Flag__c, null, 'Assertion Failed');
		Test.stopTest();
	}

	@isTest
	private static void callC1VUpdateAPITest() {
		Test.setMock(
			HttpCalloutMock.class,
			Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(
				StringConstants.POSITIVE_STRING,
				InvolvedParties_IH_v1_Test.STATIC_RESOURCE_NAME_MOCK_POSITIVE
			)
		);
		List<String> privacyDataStringList = new List<String>();
		List<Account> account = [SELECT Id, Data_Privacy_Flag__c FROM Account WHERE Name = :'Testing Data Privacy' LIMIT 1];
		privacyDataStringList.add(account[0].Data_Privacy_Flag__c);
		Test.startTest();
		string apiRes = DataPrivacyController.callC1VUpdateAPI(account[0].id, privacyDataStringList);
		system.assertEquals('Success', apiRes, 'Assertion Failed');
		Test.stopTest();
	}

	@isTest
	private static void callC1VCreateAPITest() {
		Test.setMock(
			HttpCalloutMock.class,
			Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(
				StringConstants.POSITIVE_STRING,
				InvolvedParties_IH_v1_Test.STATIC_RESOURCE_NAME_MOCK_POSITIVE
			)
		);
		String privacyDataString;
		Case caseRecord = [SELECT Id, AccountId, Account.Name, Account.Data_Privacy_Flag__c FROM Case WHERE Status = :'New' LIMIT 1];
		privacyDataString = caseRecord.Account.Data_Privacy_Flag__c;
		Test.startTest();
		string apiRes = DataPrivacyController.callC1VCreateAPI(caseRecord.Id, privacyDataString);
		system.assertEquals('Success', apiRes, 'Assertion Failed');
		Test.stopTest();
	}

	@isTest
	private static void updateDataPrivacyFlagTest() {
		String privacyDataString;
		List<Account> account = new List<Account>([SELECT Id, Data_Privacy_Flag__c FROM Account WHERE Name = :'Testing Data Privacy' LIMIT 1]);
		List<Case> caseRecord = new List<Case>([SELECT Id, AccountId, Account.Name, Account.Data_Privacy_Flag__c FROM Case WHERE Status = :'New' LIMIT 1]);
		privacyDataString = caseRecord[0].Account.Data_Privacy_Flag__c;
		Test.startTest();
		String returnedString = DataPrivacyController.updateDataPrivacyFlag(caseRecord[0].Id, privacyDataString);
		Test.stopTest();
		system.assertEquals('Success', returnedString, 'Assertion Failed');
	}
}