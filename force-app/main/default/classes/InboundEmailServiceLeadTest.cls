/**
	* @description       :
	* @author            : Sulochana.Desam@absa.africa
	* @last modified on  : 2021-11-24
	* @last modified by  : Sulochana.Desam@absa.africa
**/
@isTest
public class InboundEmailServiceLeadTest {
	@testSetup
	static void dataCreation() {
		Account account = new Account(Name = 'Test Account', CIF__c = '12345');
		insert account;

		Contact contact = new Contact(LastName = 'Test contact', AccountId = account.Id, Email = 'agents@support.co.za');
		insert contact;
	}

	//Method to test
	@isTest
	static void testInboundEmailService() {
		InboundEmailServiceLead instance = new InboundEmailServiceLead();

		// create a new email and envelope object
		Messaging.InboundEmail email = new Messaging.InboundEmail();
		Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();

		email.subject = 'aaref:test:ref';
		email.fromAddress = 'test@email.com';

		Messaging.InboundEmailResult result = instance.handleInboundEmail(email, env);
		system.assertNotEquals(null, result);
	}

	//Method to test
	@isTest
	static void negTestInboundEmailService() {
		Test.startTest();
		InboundEmailServiceLead instance = new InboundEmailServiceLead();

		// create a new email and envelope object
		Messaging.InboundEmail email = new Messaging.InboundEmail();
		Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();

		email.subject = 'aaref:test';
		email.fromAddress = 'test@email.com';
		email.toAddresses = new List<String>{ 'test@sample.com', 'Test@SalesForceTest.com' };
		Messaging.InboundEmailResult result = instance.handleInboundEmail(email, env);
		system.assertNotEquals(null, result);
		Test.stopTest();
	}

	//Method to test
	@isTest
	static void testInboundEmailService1() {
		Service_Type__c serviceType = new Service_Type__c(Name = 'Test1', Case_Record_Type__c = 'New', Subtype__c = 'Sample', Type__c = 'T01');
		insert serviceType;

		Service_Group__c serviceGr = new Service_Group__c(
			Name = 'Test',
			Assign_Record_Type__c = 'Email',
			Internal_SLA_Time_Measure__c = 'Hour(s)',
			Internal_SLA_Units__c = '5'
		);
		insert serviceGr;

		Service_Group_Type__c serviceGrType = new Service_Group_Type__c(Service_Group__c = serviceGr.Id, Service_Type__c = serviceType.Id);
		insert serviceGrType;

		Shared_Email__c sharedEmail = new Shared_Email__c(
			Salesforce_Email_Address__c = 'Test@SalesForceTest.com',
			Inbox_Address__c = 'test@sf.com',
			Active__c = true,
			Verified__c = true
		);
		insert sharedEmail;

		Id recordTypeId = Schema.SObjectType.Email_Rule__c.getRecordTypeInfosByName().get('Routing Rule').getRecordTypeId();
		system.assertNotEquals(null, recordTypeId);
		Email_Rule__c emailRule = new Email_Rule__c(
			Name = 'Test',
			Active__c = true,
			Service_Type__c = serviceType.Id,
			RecordTypeId = recordTypeId,
			Route_To_Queue__c = serviceGr.Id
		);
		insert emailRule;

		Shared_Email_Rule__c sharedEmailRule = new Shared_Email_Rule__c(Shared_Email__c = sharedEmail.Id, Email_Rule__c = emailRule.Id);
		insert sharedEmailRule;

		Test.startTest();
		InboundEmailServiceLead instance = new InboundEmailServiceLead();

		Messaging.InboundEmail email = new Messaging.InboundEmail();
		Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();

		email.subject = 'Test';
		email.fromAddress = 'test@email.com';
		email.plainTextBody = 'email body Test';
		email.toAddresses = new List<String>{ 'test@sample.com', 'Test@SalesForceTest.com' };
		Messaging.InboundEmailResult result = instance.handleInboundEmail(email, env);

		Test.stopTest();
	}
	//Method to test
	@isTest
	static void testInboundEmailServiceBlockingRule() {
		Service_Type__c serviceType = new Service_Type__c(Name = 'Test1', Case_Record_Type__c = 'New', Subtype__c = 'Sample', Type__c = 'T01');
		insert serviceType;

		Service_Group__c serviceGr = new Service_Group__c(
			Name = 'Test',
			Assign_Record_Type__c = 'Email',
			Internal_SLA_Time_Measure__c = 'Hour(s)',
			Internal_SLA_Units__c = '5'
		);
		insert serviceGr;

		Service_Group_Type__c serviceGrType = new Service_Group_Type__c(Service_Group__c = serviceGr.Id, Service_Type__c = serviceType.Id);
		insert serviceGrType;

		Shared_Email__c sharedEmail = new Shared_Email__c(
			Salesforce_Email_Address__c = 'Test@SalesForceTest.com',
			Inbox_Address__c = 'test@sf.com',
			Active__c = true,
			Verified__c = true
		);
		insert sharedEmail;

		Id recordTypeId = Schema.SObjectType.Email_Rule__c.getRecordTypeInfosByName().get('Classify Rule').getRecordTypeId();
		system.assertNotEquals(null, recordTypeId);
		Email_Rule__c emailRule = new Email_Rule__c(
			Name = 'Test',
			Active__c = true,
			Service_Type__c = serviceType.Id,
			RecordTypeId = recordTypeId,
			Route_To_Queue__c = serviceGr.Id,
			Default_Email_Rule__c = true
		);
		insert emailRule;

		Shared_Email_Rule__c sharedEmailRule = new Shared_Email_Rule__c(Shared_Email__c = sharedEmail.Id, Email_Rule__c = emailRule.Id);
		insert sharedEmailRule;

		Test.startTest();
		InboundEmailServiceLead instance = new InboundEmailServiceLead();

		Messaging.InboundEmail email = new Messaging.InboundEmail();
		Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();

		email.subject = 'ref:threadId:ref';
		email.fromAddress = 'test@email.com';
		email.plainTextBody = 'email body Test';
		email.toAddresses = new List<String>{ 'test@sample.com', 'Test@SalesForceTest.com' };
		Messaging.InboundEmailResult result = instance.handleInboundEmail(email, env);
		Test.stopTest();
	}
	//Method to test
	@isTest
	static void testInboundEmailServiceBlockEmail() {
		Service_Type__c serviceType = new Service_Type__c(Name = 'Test1', Case_Record_Type__c = 'New', Subtype__c = 'Sample', Type__c = 'T01');
		insert serviceType;

		Service_Group__c serviceGr = new Service_Group__c(
			Name = 'Test',
			Assign_Record_Type__c = 'Email',
			Internal_SLA_Time_Measure__c = 'Hour(s)',
			Internal_SLA_Units__c = '5'
		);
		insert serviceGr;

		Service_Group_Type__c serviceGrType = new Service_Group_Type__c(Service_Group__c = serviceGr.Id, Service_Type__c = serviceType.Id);
		insert serviceGrType;

		Shared_Email__c sharedEmail = new Shared_Email__c(
			Salesforce_Email_Address__c = 'Test@SalesForceTest.com',
			Inbox_Address__c = 'test@sf.com',
			Active__c = true,
			Verified__c = true
		);
		insert sharedEmail;

		Id recordTypeId = Schema.SObjectType.Email_Rule__c.getRecordTypeInfosByName().get('Routing Rule').getRecordTypeId();
		system.assertNotEquals(null, recordTypeId);
		Email_Rule__c emailRule = new Email_Rule__c(
			Name = 'Test',
			Active__c = true,
			Service_Type__c = serviceType.Id,
			RecordTypeId = recordTypeId,
			Route_To_Queue__c = serviceGr.Id,
			Default_Email_Rule__c = true,
			Org_Wide_Default_Rule__c = true
		);
		insert emailRule;
		//system.debug('emailRule' + emailRule.id);
		Shared_Email_Rule__c sharedEmailRule = new Shared_Email_Rule__c(Shared_Email__c = sharedEmail.Id, Email_Rule__c = emailRule.Id);
		insert sharedEmailRule;

		Test.startTest();
		InboundEmailServiceLead instance = new InboundEmailServiceLead();

		Messaging.InboundEmail email = new Messaging.InboundEmail();
		Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();

		email.subject = 'aaref:test';
		email.fromAddress = 'test@email.com';
		email.plainTextBody = 'email body Test';
		email.messageId = '<JHHIUHIUHIUIUG657757657>';
		email.toAddresses = new List<String>{ 'test@sf.com', 'Test@SalesForceTest.com' };
		Messaging.InboundEmailResult result = instance.handleInboundEmail(email, env);
		Test.stopTest();
	}

	//Method to test
	@isTest
	static void testInboundEmailServicePrioritySharedEmail() {
		Service_Type__c serviceType = new Service_Type__c(Name = 'Test1', Case_Record_Type__c = 'New', Subtype__c = 'Sample', Type__c = 'T01');
		insert serviceType;

		Service_Group__c serviceGr = new Service_Group__c(
			Name = 'Test',
			Assign_Record_Type__c = 'Email',
			Internal_SLA_Time_Measure__c = 'Hour(s)',
			Internal_SLA_Units__c = '5',
			Active__c = true
		);
		insert serviceGr;

		Service_Group_Type__c serviceGrType = new Service_Group_Type__c(Service_Group__c = serviceGr.Id, Service_Type__c = serviceType.Id);
		insert serviceGrType;

		Shared_Email__c sharedEmail = new Shared_Email__c(
			Name = 'ABC1',
			Salesforce_Email_Address__c = 'Test@SalesForceTest.com',
			Prioritise__c = true,
			Inbox_Address__c = 'test@sf.com',
			Active__c = true,
			Verified__c = true
		);
		insert sharedEmail;

		Id recordTypeId = Schema.SObjectType.Email_Rule__c.getRecordTypeInfosByName().get('Classify Rule').getRecordTypeId();
		system.assertNotEquals(null, recordTypeId);
		Email_Rule__c emailRule = new Email_Rule__c(
			Name = 'Test',
			Active__c = true,
			Service_Type__c = serviceType.Id,
			RecordTypeId = recordTypeId,
			Route_To_Queue__c = serviceGr.Id,
			Default_Email_Rule__c = true
		);
		insert emailRule;

		Shared_Email_Rule__c sharedEmailRule = new Shared_Email_Rule__c(Shared_Email__c = sharedEmail.Id, Email_Rule__c = emailRule.Id);
		insert sharedEmailRule;

		Shared_Email_Rule__c sharedEmailRule2 = new Shared_Email_Rule__c(Shared_Email__c = sharedEmail.Id, Email_Rule__c = emailRule.Id);
		insert sharedEmailRule2;

		Test.startTest();
		InboundEmailServiceLead instance = new InboundEmailServiceLead();

		Messaging.InboundEmail email = new Messaging.InboundEmail();
		Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();

		email.subject = 'ref:threadId:ref';
		email.fromAddress = 'test@email.com';
		email.plainTextBody = 'email body Test';
		email.toAddresses = new List<String>{ 'test@sample.com' };
		email.ccAddresses = new List<String>{ 'test@sf.com' };
		email.messageId = '<abcdef>';
		Messaging.InboundEmailResult result = instance.handleInboundEmail(email, env);
		Test.stopTest();
	}
}