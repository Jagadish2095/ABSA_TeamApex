/**
 * @description       :
 * @author            : Mradul Maheshwari
 * @last modified on  : 2021-09-08
 * @last modified by  : humbelani.denge@absa.africa
 * @Work Id           : W-013340
 **/
@isTest
public with sharing class StaticSMSControllerTest {
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

			String result = StaticSMSController.getAccountCategory(accList[0]);
			Test.stopTest();

			System.assert(result.StartsWith('Error:'), 'Assert failed');
		}
	}
	@isTest
	public static void testSendSms() {
		Case caseRec = [SELECT Id FROM Case LIMIT 1];

		Test.startTest();
		Test.setMock(HttpCalloutMock.class, new SMSGatewayMock_APIRest(StringConstants.POSITIVE_STRING, 'Success'));

		SMSGateway_Resp_IB_v1 responseBean = SMSGateway_IH_v1.submit('0000000000', 'test message', StringConstants.ITOUCH_SUBMIT);
		String response = StaticSMSController.sendSms(caseRec.Id, '+27714221249', 'test sms body', System.Label.smsIntegrationService);

		Test.stopTest();

		System.assertEquals(true, String.isNotBlank(response), 'Assert Failed');
	}
}