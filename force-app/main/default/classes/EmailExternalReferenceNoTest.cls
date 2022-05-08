/**
 * @description Test class for ProfilesSelector
 * @since 2019-04-29
 **/
@isTest
public class EmailExternalReferenceNoTest {
	@isTest
	private static void testGetExternalReferenceNo() {
		Service_Type__c serviceType = new Service_Type__c(Name = 'Test1', Case_Record_Type__c = 'New', Subtype__c = 'Sample', Type__c = 'T01');
		insert serviceType;

		Service_Group__c serviceGr = new Service_Group__c(
			Name = 'Test',
			Assign_Record_Type__c = 'Email',
			Internal_SLA_Time_Measure__c = 'Hour(s)',
			Internal_SLA_Units__c = '5'
		);
		insert serviceGr;
		Shared_Email__c sharedEmail = new Shared_Email__c(
			Salesforce_Email_Address__c = 'Test@SalesForceTest.com',
			Inbox_Address__c = 'test@sf.com',
			Active__c = true,
			Verified__c = true
		);
		insert sharedEmail;

		Id recordTypeId = Schema.SObjectType.Email_Rule__c.getRecordTypeInfosByName().get('Routing Rule').getRecordTypeId();
		Email_Rule__c emailRule = new Email_Rule__c(
			Name = 'Test Regex Subject',
			Active__c = true,
			Service_Type__c = serviceType.Id,
			Detect_External_Case_Reference__c = true,
			Reference_Type__c = 'Ombudsman',
			Subject_Operator__c = 'regex',
			Subject_Criteria__c = '{2,10}',
			RecordTypeId = recordTypeId,
			Route_To_Queue__c = serviceGr.Id
		);
		insert emailRule;
		
        Messaging.InboundEmail email1 = new Messaging.InboundEmail();
		email1.subject = 'C-08675798';
		email1.fromAddress = 'test@gmail.com';
		email1.plainTextBody = 'test C-08675798';
        
		Messaging.InboundEmail email = new Messaging.InboundEmail();
		email.subject = 'Test External Ref - 01/12-0173';
		email.fromAddress = 'test@gmail.com';
		email.plainTextBody = 'test c-12345678';
        string casefound=EmailExternalReferenceNo.getCaseNumber(email);
		String externalRefNo = EmailExternalReferenceNo.getExternalReferenceNo(email);
		system.assertNotEquals(null, externalRefNo);
	}

	@isTest
	private static void testGetExternalReferenceNoEmailBody() {
		Service_Type__c serviceType = new Service_Type__c(Name = 'Test1', Case_Record_Type__c = 'New', Subtype__c = 'Sample', Type__c = 'T01');
		insert serviceType;

		Service_Group__c serviceGr = new Service_Group__c(
			Name = 'Test',
			Assign_Record_Type__c = 'Email',
			Internal_SLA_Time_Measure__c = 'Hour(s)',
			Internal_SLA_Units__c = '5'
		);
		insert serviceGr;

		Shared_Email__c sharedEmail = new Shared_Email__c(
			Salesforce_Email_Address__c = 'Test@SalesForceTest.com',
			Inbox_Address__c = 'test@sf.com',
			Active__c = true,
			Verified__c = true
		);
		insert sharedEmail;

		Id recordTypeId = Schema.SObjectType.Email_Rule__c.getRecordTypeInfosByName().get('Routing Rule').getRecordTypeId();

		Email_Rule__c emailRule2 = new Email_Rule__c(
			Name = 'Test Regex Description',
			Active__c = true,
			Service_Type__c = serviceType.Id,
			Detect_External_Case_Reference__c = true,
			Reference_Type__c = 'Ombudsman',
			Description_Operator__c = 'regex',
			Description_Criteria__c = '{2,10}',
			RecordTypeId = recordTypeId,
			Route_To_Queue__c = serviceGr.Id
		);
		insert emailRule2;

		Messaging.InboundEmail email = new Messaging.InboundEmail();
		email.subject = 'Test';
		email.fromAddress = 'test@gmail.com';
		email.htmlBody = ' External Ref - 01/12-0173';
        
         string casefound=EmailExternalReferenceNo.getCaseNumber(email);

		String externalRefNo = EmailExternalReferenceNo.getExternalReferenceNo(email);
		system.assertNotEquals(null, externalRefNo);
	}

	@isTest
	private static void testFindCaseByExternalReferenceNo() {
		Account account = new Account(Name = 'Test Account');
		insert account;

		Contact contact = new Contact(LastName = 'Test contact', AccountId = account.Id);
		insert contact;

		//Get Case record Type
		map<String, Schema.RecordTypeInfo> caseRecordTypeMap = Case.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
		Id caseComplaintsRecordTypeId = caseRecordTypeMap.get('Complaint').getRecordTypeId();
		Case caseRec = new Case(
			recordTypeId = caseComplaintsRecordTypeId,
			Incident_Date__c = System.Today(),
			Subject = 'Test 1 - 01/12-0173',
			Description = 'Test Conent',
			Expectation_of_the_Customer__c = 'Testing',
			Communication_Method__c = 'Email',
			Email__c = 'test@test.com',
			Origin = 'Email',
			Account = account,
			Type__c = 'abc',
			Subtype__c = 'xyz',
			Product__c = 'a product'
		);
		insert caseRec;

		String externalRefNo = '01/12-0173';

		Id result = EmailExternalReferenceNo.findCaseByExternalReferenceNo(externalRefNo, false);
		system.assertNotEquals(null, result);

	}

	@isTest
	private static void testFindClosedCaseByExternalReferenceNo() {
		map<String, Schema.RecordTypeInfo> accountRecordTypeMap = Account.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
		Id clientRecordTypeId = accountRecordTypeMap.get('Individual_Client').getRecordTypeId();
		Account account = new Account(RecordTypeId = clientRecordTypeId, FirstName = 'Test', LastName = 'Client');
		insert account;

		//Get Case record Type
		map<String, Schema.RecordTypeInfo> caseRecordTypeMap = Case.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
		Id caseComplaintsRecordTypeId = caseRecordTypeMap.get('Service_Request').getRecordTypeId();
		Case caseRec = new Case(
			Status = 'Resolved',
			sd_Service_Group__c = 'Test',
			recordTypeId = caseComplaintsRecordTypeId,
			Incident_Date__c = System.Today(),
			Subject = 'Test 1 - 01/12-0173',
			Description = 'Test Conent',
			Expectation_of_the_Customer__c = 'Testing',
			Communication_Method__c = 'Email',
			Email__c = 'test@test.com',
			Origin = 'Email',
			Account = account,
			Type__c = 'abc',
			Subtype__c = 'xyz',
			Product__c = 'a product'
		);
		insert caseRec;

		String externalRefNo = '01/12-0173';
		id res =EmailExternalReferenceNo.findCaseByCaseNo('C-08675798');
		Id result = EmailExternalReferenceNo.findCaseByExternalReferenceNo(externalRefNo, true);
		system.assertEquals(null, result);
	}

	@isTest
	private static void negTestGetThreadId() {
		Messaging.InboundEmail email = new Messaging.InboundEmail();
		email.subject = 'ref:';
		email.fromAddress = 'test@gmail.com';
		email.htmlBody = '';
		String treadId = EmailExternalReferenceNo.getExternalReferenceNo(email);
		system.assertEquals(null, treadId);
	}
}