/**
 * @description Test class for Notify Banker Controller Class
 * @author  Muvhuso Nekhubvi : Absa
 * @version v1.0
 * @date   2020-06-22
 * @updated koketso Mpshane 2021-07-01
 */
@isTest
public class NotifyBankerControllerTest {
	@testSetup
	static void dataCreation() {
		Account account = new Account(Name = 'Test Account', CIF__c = 'ATRUST1375');
		insert account;

		Contact contact = new Contact(LastName = 'Test contact', AccountId = account.Id, Email = 'agents@support.co.za');
		insert contact;

		Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Service Request').getRecordTypeId();

		Service_Group__c sGroup = new Service_Group__c(Name = 'Test');
		insert sGroup;

		Case caseRec = new Case(
			Status = 'New',
			Origin = 'Email',
			AccountId = account.Id,
			Risk_Management_Centre__c = 'Digital Fraud',
			Email_From_Address__c = 'test@ret.com',
			Email__c = 'test@ret.com',
			RecordTypeId = caseRecordTypeId,
			Subject = 'Test',
			Description = 'Test',
			Type__c = 'Test',
			sd_Service_Group_Id__c = sGroup.Id,
			sd_Service_Group__c = sGroup.Name,
			Out_Of_SLA_Reason__c = 'Feedback/Follow-Up',
			Out_Of_SLA_Comments__c = 'Test'
		);
		insert caseRec;

		IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new List<String>{ StringConstants.ITOUCH_SUBMIT });
	}

	@isTest
	public static void testGetBankerName() {
		Account acc = [SELECT Id FROM Account LIMIT 1];

		// Set mock callout class
		Test.setMock(HttpCalloutMock.class, new CMSServiceMock_ApiRest(StringConstants.NEGATIVE_STRING));
		IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new List<String>{ StringConstants.CMS_GET_ACCOUNTDEATILS });

		Test.startTest();
		String response = NotifyBankerController.getBankerName(acc.Id);
		Test.stopTest();

		system.assertEquals(null, response, 'Assert Failed');
	}

	@isTest
	public static void testSendBalanceEnquiryEmail() {
		Case caseRec = [SELECT Id FROM Case LIMIT 1];
		String emailAddress = 'test@absa.africa';

		Test.startTest();
		String response = NotifyBankerController.sendEmail(emailAddress, caseRec.Id, '', 'Account_Balance_Enquiry', '', '', '', '', '', '', null, '');
		Test.stopTest();

		system.assertNotEquals(null, response, 'Assert Failed');
	}

	@isTest
	public static void testSendBankerEmail() {
		Case caseRec = [SELECT Id FROM Case LIMIT 1];
		String emailAddress = 'test@test.com';

		Test.startTest();
		String response = NotifyBankerController.sendEmail(
			emailAddress,
			caseRec.Id,
			'muvhuso nekhubvi',
			'Notify_Banker',
			'muvhuso.nekhubvi@absa.africa',
			'',
			'',
			'',
			'',
			'',
			null,
			''
		);
		Test.stopTest();

		system.assertNotEquals(null, response, 'Assert Failed');
	}

	@isTest
	public static void testSendMinimumDueEmail() {
		Case caseRec = [SELECT Id FROM Case LIMIT 1];
		String emailAddress = 'test@test.com';

		Test.startTest();
		String response = NotifyBankerController.sendEmail(
			emailAddress,
			caseRec.Id,
			'muvhuso nekhubvi',
			'MinimumPaymentDue',
			'muvhuso.nekhubvi@absa.africa',
			'',
			'',
			'',
			'',
			'',
			null,
			''
		);
		Test.stopTest();

		system.assertNotEquals(null, response, 'Assert Failed');
	}

	@isTest
	public static void testSendPolicyBeneficiaryMaintenanceEmail() {
		Case caseRec = [SELECT Id FROM Case LIMIT 1];
		String emailAddress = 'test@test.com';

		Test.startTest();
		String response = NotifyBankerController.sendEmail(
			emailAddress,
			caseRec.Id,
			'muvhuso nekhubvi',
			'Policy_Beneficiary_Maintenance',
			'muvhuso.nekhubvi@absa.africa',
			'',
			'',
			'',
			'',
			'',
			null,
			''
		);
		Test.stopTest();

		system.assertNotEquals(null, response, 'Assert Failed');
	}

	@isTest
	public static void testSignitariesSendEmail() {
		Case caseRec = [SELECT Id FROM Case LIMIT 1];
		String emailAddress = 'test@test.com';

		Test.startTest();
		String response = NotifyBankerController.sendEmail(emailAddress, caseRec.Id, '', 'Signitaries', '', '', '', '', '', '', null, '');
		Test.stopTest();

		system.assertNotEquals(null, response, 'Assert Failed');
	}

	@isTest
	public static void testStopCardsSendEmail() {
		Case caseRec = [SELECT Id FROM Case LIMIT 1];
		String emailAddress = 'test@test.com';

		Test.startTest();
		String response = NotifyBankerController.sendEmail(
			emailAddress,
			caseRec.Id,
			'muvhuso nekhubvi',
			'StopCards',
			'muvhuso.nekhubvi@absa.africa',
			'',
			'',
			'',
			'',
			'',
			null,
			''
		);
		Test.stopTest();

		system.assertNotEquals(null, response, 'Assert Failed');
	}

	@isTest
	public static void testStopReplaceCreditCardSendEmail() {
		Case caseRec = [SELECT Id FROM Case LIMIT 1];
		String emailAddress = 'test@test.com';

		Test.startTest();
		String response = NotifyBankerController.sendEmail(
			emailAddress,
			caseRec.Id,
			'muvhuso nekhubvi',
			'StopReplaceCreditCard',
			'muvhuso.nekhubvi@absa.africa',
			'',
			'',
			'',
			'',
			'',
			null,
			''
		);
		Test.stopTest();

		system.assertNotEquals(null, response, 'Assert Failed');
	}

	@isTest
	public static void testABSAOnlineStatementsSendEmail() {
		Case caseRec = [SELECT Id FROM Case LIMIT 1];
		String emailAddress = 'test@test.com';

		Test.startTest();

		List<ABSAOnlineStatementDownload_Resp_IB_v1> reponseList = new List<ABSAOnlineStatementDownload_Resp_IB_v1>();
		ABSAOnlineStatementDownload_Resp_IB_v1 reponse1 = new ABSAOnlineStatementDownload_Resp_IB_v1();
		reponse1.timestamp = '20201020';
		reponse1.listRef = 'djfsakfskdf';
		reponse1.doc = 'testDocument Body';
		reponse1.pages = 2;
		reponse1.size = 1;
		reponseList.add(reponse1);
		String reponseString = JSON.serialize(reponseList);
		String response = NotifyBankerController.sendEmail(emailAddress, caseRec.Id, '', 'ABSAOnlineStatements', '', '', '', '', reponseString, '', null, '');
		Test.stopTest();

		system.assertNotEquals(null, response, 'Assert Failed');
	}

	@isTest
	public static void testSendGenericEmail() {
		Case caseRec = [SELECT Id FROM Case LIMIT 1];
		String emailAddress = 'test@test.com';
		List<String> excludedTemplateList = new List<String>{
			'Request_to_Cancel_Bond_Email',
			'AccountConfirmation',
			'AVAF_Monthly_Statement_Template',
			'Ford_Monthly_Statement_Template',
			'Home_Loans_Tax_Certificate',
			'ABSAOnlineStatements',
			'MinimumPaymentDue',
			'StopReplaceCreditCard'
		};

		EmailTemplate eTemp = [SELECT Id, DeveloperName FROM EmailTemplate WHERE DeveloperName NOT IN :excludedTemplateList LIMIT 1];

		Test.startTest();
		String response = NotifyBankerController.sendEmail(emailAddress, caseRec.Id, '', eTemp.DeveloperName, '', '', '', '', '', '', null, '');
		Test.stopTest();

		system.assertNotEquals(null, response, 'Assert Failed');
	}

	@isTest
	public static void testUpdateCase() {
		Case caseRec = [SELECT Id FROM Case LIMIT 1];

		Test.startTest();
		NotifyBankerController.updateCase(caseRec.Id, '', '', true);
		Test.stopTest();

		Case updatedCase = [SELECT Status FROM Case WHERE Id = :caseRec.Id];
		system.assertNotEquals('Closed', updatedCase.Status, 'Assert Failed');
	}

	@isTest
	public static void testUpdateCloseCase() {
		Case caseRec = [SELECT Id FROM Case LIMIT 1];

		Test.startTest();
		NotifyBankerController.updateCase(caseRec.Id, '', '', false);
		Test.stopTest();

		Case updatedCase = [SELECT Status FROM Case WHERE Id = :caseRec.Id];
		system.assertEquals('Closed', updatedCase.Status, 'Assert Failed');
	}

	@isTest
	public static void testNoEmail() {
		Case caseRec = [SELECT Id FROM Case LIMIT 1];

		Test.startTest();
		NotifyBankerController.noEmail(caseRec.Id);
		Test.stopTest();

		Case updatedCase = [SELECT Status FROM Case WHERE Id = :caseRec.Id];
		system.assertEquals('Closed', updatedCase.Status, 'Assert Failed');
	}

	@isTest
	public static void testGetOrgWideEmailAddressId() {
		Case caseRec = [SELECT Id FROM Case LIMIT 1];

		Test.startTest();
		Id response = NotifyBankerController.getOrgWideEmailAddressId(caseRec.Id);
		Test.stopTest();

		system.assertEquals(null, response, 'Assert Failed');
	}

	@isTest
	public static void testNotifyClientBySMS() {
		Case caseRec = [SELECT Id FROM Case LIMIT 1];

		Test.startTest();
		// Set mock callout class
		Test.setMock(HttpCalloutMock.class, new SMSGatewayMock_APIRest(StringConstants.POSITIVE_STRING, 'Success'));
		String response = NotifyBankerController.notifyClientBySMS(caseRec.Id, '0810000000', 'test sms body', StringConstants.ITOUCH_SUBMIT);
		Test.stopTest();

		Map<String, Object> responseObj = (Map<String, Object>) JSON.deserializeUntyped(response);
		System.assertEquals(200, responseObj.get('statusCode'), 'Assert Failed');
	}

	@isTest
	public static void testSendBondCancellationEmail() {
		List<Account> testAccountId = [SELECT Id, Name, AccountNumber FROM Account WHERE Name LIKE 'Test Account'];
		Case caseRec = [SELECT Id FROM Case LIMIT 1];
		String emailAddress = 'test@test.com';

		Test.startTest();
		String response = NotifyBankerController.sendEmail(emailAddress, caseRec.Id, '', 'Request_to_Cancel_Bond_Email', '', '', '', '', '', '', null, '');
		Test.stopTest();

		system.assertNotEquals(null, response, 'Assert Failed');
	}

	@isTest
	public static void testSendEmailWithMappedValues() {
		List<Account> testAccountId = [SELECT Id, Name, AccountNumber FROM Account WHERE Name LIKE 'Test Account'];
		Case caseRec = [SELECT Id FROM Case LIMIT 1];
		String emailAddress = 'test@test.com';

		Map<String, String> testMap = new Map<String, String>();
		testMap.put('[#Validity Period]', 'Test Period');

		Test.startTest();
		String response = NotifyBankerController.sendEmail(emailAddress, caseRec.Id, '', 'X90_Days_Notice_Email', '', '', '', '', '', '', testMap, '');
		Test.stopTest();

		system.assertNotEquals(null, response, 'Assert Failed');
	}
}