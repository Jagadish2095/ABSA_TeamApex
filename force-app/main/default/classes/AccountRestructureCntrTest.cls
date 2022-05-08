/*
 * AccountRestructureCntrTest for testing AccountRestructureCntr class
 *
 * @author  Humbelani Denge : ABSA
 * @version v1.0
 * @Date   2021-01-27
 * @W-008832 & W-005674
 *
 * @last modified by  : humbelani.denge@absa.africa
 * @Work Id           : W-005674
 * @last modified on  : 2021-09-08
 */

@isTest
public class AccountRestructureCntrTest {
	/**
	 * @description Test Setup
	 * @author Mradul Maheshwari | 01-09-2021
	 **/
	@TestSetup
	static void makeData() {
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT2,
			new List<String>{ AccountRestructureRequest_IH_v1.INTEGRATION_SERVICE_NAME }
		);
		IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ BAPISFContrDetails_IH_v1.INTEGRATION_SERVICE_NAME });
		IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ CalculatorRequest_IH_v1.INTEGRATION_SERVICE_NAME });
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT2,
			new List<String>{ AccountPreValidationRequest_IH_v1.INTEGRATION_SERVICE_NAME }
		);

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
	}

	/**
	 * @description assert and cover positive scenario to get contract details
	 * @author Mradul Maheshwari | 01-09-2021
	 **/
	@IsTest
	static void getContractDetails() {
		Test.setMock(
			HttpCalloutMock.class,
			Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(
				StringConstants.POSITIVE_STRING,
				BAPISFContrDetails_IH_v1_Test.STATIC_RESOURCE_NAME_MOCK_POSITIVE
			)
		);

		Test.startTest();
		String response = AccountRestructureCntr.getContractDetailsfromServer('00073552449');
		System.assert(response.StartsWith('['), 'Assert Failed');
		Test.stopTest();
	}

	/**
	 * @description assert and cover negative scenario to get contract details
	 * @author Mradul Maheshwari | 01-09-2021
	 **/
	@IsTest
	static void getContractDetailsNegative() {
		Test.setMock(
			HttpCalloutMock.class,
			Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(
				StringConstants.POSITIVE_STRING,
				BAPISFContrDetails_IH_v1_Test.STATIC_RESOURCE_NAME_MOCK_POSITIVE
			)
		);
		User u3 = [SELECT Id FROM User LIMIT 1];

		Test.startTest();
		List<Account> accountList = TestDataFactory.getPersonAccounts('lastName', 'Individual_Client', 1);
		accountList[0].LastName = 'SKOSANA';
		accountList[0].ID_Type__pc = 'SA Identity Document';
		accountList[0].ID_Number__pc = '8505225522085';
		insert accountList;
		String response = AccountRestructureCntr.getContractDetailsfromServer(null);
		System.assert(response.StartsWith('Error'), 'Assert Failed');
		Test.stopTest();
	}

	/**
	 * @description assert and cover positive scenario to get prea validation details
	 * @author Mradul Maheshwari | 01-09-2021
	 **/
	@IsTest
	static void getPrevalidationInfo() {
		Test.setMock(
			HttpCalloutMock.class,
			Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(
				StringConstants.POSITIVE_STRING,
				AccountPreValidationRequest_IH_v1_Test.STATIC_RESOURCE_NAME_MOCK_POSITIVE
			)
		);

		Test.startTest();
		String response = AccountRestructureCntr.getPrevalidationInfo('00073552449');
		System.assert(response.StartsWith('['), 'Assert Failed');
		Test.stopTest();
	}

	/**
	 * @description assert and cover loading options
	 * @author Mradul Maheshwari | 01-09-2021
	 **/
	@IsTest
	static void loadTermOptionsfromServer() {
		Test.setMock(
			HttpCalloutMock.class,
			Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(
				StringConstants.POSITIVE_STRING,
				CalculatorRequest_IH_v1_Test.STATIC_RESOURCE_NAME_MOCK_POSITIVE
			)
		);

		Test.startTest();
		String response = AccountRestructureCntr.loadTermOptionsfromServer('00073552449', '10000');

		System.assert(response.StartsWith('['), 'Assert Failed');
		Test.stopTest();
	}

	/**
	 * @description assert and cover account restructure
	 * @author Mradul Maheshwari | 01-09-2021
	 **/
	@IsTest
	static void confirmAdjustment() {
		Test.setMock(
			HttpCalloutMock.class,
			Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(
				StringConstants.POSITIVE_STRING,
				AccountRestructureRequest_IH_v1_Test.STATIC_RESOURCE_NAME_MOCK_POSITIVE
			)
		);

		AccountRestructureRequest_Req_IB_v1 dummyBean = AccountRestructureRequest_Req_IB_v1.createDummyRequest();

		Test.startTest();
		String response = AccountRestructureCntr.confirmAdjustment(
			dummyBean.accountNumber,
			dummyBean.advanceAmount,
			dummyBean.restructureOption,
			dummyBean.email,
			dummyBean.consent,
			dummyBean.newInstallment,
			dummyBean.newCalculatedInstallmentsNo,
			dummyBean.newTerm,
			dummyBean.newContractEndDate,
			dummyBean.newResidualAmount
		);

		System.assert(response.StartsWith('{'), 'Assert Failed');
		Test.stopTest();
	}

	/**
	 * @description assert and cover negative scenario to get prea validation details
	 * @author Mradul Maheshwari | 01-09-2021
	 **/
	@IsTest
	static void getPrevalidationInfoNegative() {
		Test.setMock(
			HttpCalloutMock.class,
			Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(
				StringConstants.POSITIVE_STRING,
				AccountPreValidationRequest_IH_v1_Test.STATIC_RESOURCE_NAME_MOCK_POSITIVE
			)
		);

		Test.startTest();
		String response = AccountRestructureCntr.getPrevalidationInfo(null);
		System.assert(response.StartsWith('Error'), 'Assert Failed');
		Test.stopTest();
	}

	/**
	 * @description assert and cover loading options
	 * @author Mradul Maheshwari | 01-09-2021
	 **/
	@IsTest
	static void loadTermOptionsfromServerNegative() {
		Test.setMock(
			HttpCalloutMock.class,
			Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(
				StringConstants.POSITIVE_STRING,
				CalculatorRequest_IH_v1_Test.STATIC_RESOURCE_NAME_MOCK_POSITIVE
			)
		);

		Test.startTest();
		String response = AccountRestructureCntr.loadTermOptionsfromServer(null, '10000');

		System.assert(response.StartsWith('Error'), 'Assert Failed');
		Test.stopTest();
	}

	/**
	 * @description assert and cover account restructure
	 * @description
	 * @author Mradul Maheshwari | 01-09-2021
	 **/
	@IsTest
	static void confirmAdjustmentNegative() {
		Test.setMock(
			HttpCalloutMock.class,
			Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(
				StringConstants.POSITIVE_STRING,
				AccountRestructureRequest_IH_v1_Test.STATIC_RESOURCE_NAME_MOCK_POSITIVE
			)
		);
		Test.startTest();
		AccountRestructureRequest_Req_IB_v1 dummyBean = AccountRestructureRequest_Req_IB_v1.createDummyRequest();

		String response = AccountRestructureCntr.confirmAdjustment(
			null,
			dummyBean.advanceAmount,
			dummyBean.restructureOption,
			dummyBean.email,
			dummyBean.consent,
			dummyBean.newInstallment,
			dummyBean.newCalculatedInstallmentsNo,
			dummyBean.newTerm,
			dummyBean.newContractEndDate,
			dummyBean.newResidualAmount
		);

		System.assert(response.StartsWith('Error'), 'Assert Failed');
		Test.stopTest();
	}

	/**
	 * @description cover send email
	 * @author Mradul Maheshwari | 01-09-2021
	 **/
	@IsTest
	static void sendEmail() {
		Case caseRec = [SELECT Id FROM Case LIMIT 1];
		String emailAddress = 'test@test.com';
		EmailTemplate eTemp = [SELECT Id, DeveloperName FROM EmailTemplate LIMIT 1];

		Test.startTest();
		String response = AccountRestructureCntr.sendEmail(emailAddress, caseRec.Id, 'Remove Balloon and Reduce Term', 'Absa Vehicle Finance');
		Test.stopTest();
		System.assert(String.isNotBlank(response), 'Assert Failed');
	}
}