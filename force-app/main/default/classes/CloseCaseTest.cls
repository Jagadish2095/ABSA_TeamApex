@isTest
public class CloseCaseTest {
	@testSetup
	static void dataCreation() {
		Account account = new Account(Name = 'Test Account');
		insert account;

		Contact contact = new Contact(LastName = 'Test contact', AccountId = account.Id, Email = 'agents@support.co.za');
		insert contact;

		Service_Group__c serviceGroupRecord = new Service_Group__c(
			Name = 'AVAF Queries',
			Queue__c = 'Queue',
			Active__c = true,
			Assign_Record_Type__c = 'Complaint',
			Response_Email_Address__c = 'avafcancellation1@absa.co.za'
		);
		insert serviceGroupRecord;

		Case caseRec = new Case(
			Communication_Method__c = 'Email',
			Status = 'New',
			Origin = 'Email',
			Account = account,
			Email__c = 'test@test.com',
			recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Complaint').getRecordTypeId(),
			Subject = 'test',
			Description = 'test',
			Expectation_of_the_Customer__c = 'test',
			sd_Service_Group_Id__c = serviceGroupRecord.Id,
			Incident_Date__c = date.today()
		);
		insert caseRec;
	}

	@isTest
	public static void testSendEmail() {
		Case caseRec = [SELECT Id FROM Case LIMIT 1];

		Test.startTest();
		String response = CloseCase.sendEmail(caseRec.Id, 'test@absa.africa', 'AVAF_Policy_Successful_Cancellation', 'avafcancellation1@absa.co.za');
		System.debug('response: ' + response);
		Test.stopTest();

		System.assertEquals(false, response.contains('Error'), 'Assert Failed');
	}

	@isTest
	public static void testSendEmailNegativeNoOrgWideEmail() {
		Case caseRec = [SELECT Id FROM Case LIMIT 1];
		Service_Group__c serviceGroupRecord = [SELECT Id, Response_Email_Address__c FROM Service_Group__c LIMIT 1];
		serviceGroupRecord.Response_Email_Address__c = 'badEmail@absa.africa';
		update serviceGroupRecord;

		Test.startTest();
		String response = CloseCase.sendEmail(caseRec.Id, 'test@absa.africa', 'AVAF_Policy_Successful_Cancellation', '');
		Test.stopTest();

		System.assertEquals(true, response.contains('Error'), 'Assert Failed');
	}
}