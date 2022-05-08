/**
 * @description EmailRuleEngineTest description
 * @Author       : Dreamwares
 * @Created Date : 06/09/2018
 */
@isTest
public class EmailRuleEngineTest {
	/*
	 * Purpose : Method to create test data
	 */
	@testSetup
	static void dataCreation() {
		Account account = new Account(Name = 'Test Account');
		insert account;

		Contact contact = new Contact(LastName = 'Test contact', AccountId = account.Id);
		insert contact;

		map<String, Schema.RecordTypeInfo> caseRecordTypeMap = Case.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
		Id caseServiceRequestRecordTypeId = caseRecordTypeMap.get('Service_Request').getRecordTypeId();

		Case caseRec = new Case(
			RecordTypeId = caseServiceRequestRecordTypeId,
			Communication_Method__c = 'Email',
			Status = 'New',
			Origin = 'Email',
			AccountId = account.Id,
			Risk_Management_Centre__c = 'Digital Fraud'
		);
		insert caseRec;
	}

	//Method to test
	static testMethod void testEmailRuleEngine1() {
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
		//EmailRuleEngine.isSenderOrgWideEmailAddress('complaintstest@absa.co.za');

		//Create a new email
		Messaging.InboundEmail email = new Messaging.InboundEmail();
		email.subject = 'Test Email rule';
		email.fromAddress = 'someaddress@email.com';
		email.plainTextBody = 'email body\n2225256325\nTitle';
		Boolean result = EmailRuleEngine.emailBodyCheck(email);
		System.assertEquals(result, true);

		email = new Messaging.InboundEmail();
		email.subject = 'Test Email';
		email.fromAddress = 'someaddress1@email.com';
		email.toAddresses = new List<String>{ 'test@sample.com', 'Test@SalesForceTest.com' };
		email.htmlBody = '<b>hello world Test</b>';
		result = EmailRuleEngine.emailBodyCheck(email);
		System.assertEquals(result, true);

		String plainText = EmailRuleEngine.HtmlToText('<html><body><div>Sample Test</div><b>Case</b></body></html>');
		System.assertEquals(plainText, 'Sample TestCase');

		EmailRuleEngine.RuleData ruleWrapper = EmailRuleEngine.findMatchingRule(email, false, 'Case');

		Test.stopTest();
	}

	//Method to test
	static testMethod void testEmailRuleEngine2() {
		Shared_Email__c sharedEmail = new Shared_Email__c(
			Salesforce_Email_Address__c = 'Test@SalesForceTest.com',
			Inbox_Address__c = 'test@sf.com',
			Active__c = true,
			Verified__c = true
		);
		insert sharedEmail;

		Email_Rule__c emailRule = new Email_Rule__c(
			Name = 'Test',
			Active__c = true, //Service_Type__c = serviceType.Id,
			From_Criteria__c = 'Test',
			From_Operator__c = 'equals',
			Subject_Criteria__c = 'Test Email',
			Subject_Operator__c = 'equals',
			Description_Criteria__c = 'Check',
			Description_Operator__c = 'equals'
		);
		insert emailRule;

		Shared_Email_Rule__c sharedEmailRule = new Shared_Email_Rule__c(Shared_Email__c = sharedEmail.Id, Email_Rule__c = emailRule.Id);
		insert sharedEmailRule;

		Messaging.InboundEmail email = new Messaging.InboundEmail();
		email = new Messaging.InboundEmail();
		email.subject = 'Test Email';
		email.fromAddress = 'someaddress1@email.com';
		email.toAddresses = new List<String>{ 'test@sample.com', 'Test@SalesForceTest.com' };
		email.htmlBody = '<b>hello world Test</b>';

		Test.startTest();

		EmailRuleEngine.RuleData ruleWrapper = EmailRuleEngine.findMatchingRule(email, false, 'Case');
		System.assertEquals(ruleWrapper.hasMathingRule, false);

		Test.stopTest();
	}

	//Method to test
	static testMethod void testEmailRuleEngine3() {
		Shared_Email__c sharedEmail = new Shared_Email__c(
			Salesforce_Email_Address__c = 'Test@SalesForceTest.com',
			Inbox_Address__c = 'test@sf.com',
			Active__c = true,
			Verified__c = true
		);
		insert sharedEmail;

		Email_Rule__c emailRule = new Email_Rule__c(
			Name = 'Test',
			Active__c = true, //Service_Type__c = serviceType.Id,
			From_Criteria__c = 'someaddress1@email.com',
			From_Operator__c = 'starts with',
			Subject_Criteria__c = 'Test Email',
			Subject_Operator__c = 'starts with',
			Description_Criteria__c = '<b>hello world Test</b>',
			Description_Operator__c = 'starts with'
		);
		insert emailRule;

		Shared_Email_Rule__c sharedEmailRule = new Shared_Email_Rule__c(Shared_Email__c = sharedEmail.Id, Email_Rule__c = emailRule.Id);
		insert sharedEmailRule;

		Messaging.InboundEmail email = new Messaging.InboundEmail();
		email = new Messaging.InboundEmail();
		email.subject = 'Test Email';
		email.fromAddress = 'someaddress1@email.com';
		email.toAddresses = new List<String>{ 'test@sample.com', 'Test@SalesForceTest.com' };
		email.htmlBody = '<b>hello world Test</b>';

		Test.startTest();

		EmailRuleEngine.RuleData ruleWrapper = EmailRuleEngine.findMatchingRule(email, false, 'Case');
		EmailRuleEngine.updateTriggerCount(emailRule.Id);
		System.assertEquals(ruleWrapper.hasMathingRule, true);

		Test.stopTest();
	}

	//Method to test
	static testMethod void testEmailRuleEngine4() {
		Shared_Email__c sharedEmail = new Shared_Email__c(
			Salesforce_Email_Address__c = 'Test@SalesForceTest.com',
			Inbox_Address__c = 'test@sf.com',
			Active__c = true,
			Verified__c = true
		);
		insert sharedEmail;

		Email_Rule__c emailRule = new Email_Rule__c(
			Name = 'Test',
			Active__c = true, //Service_Type__c = serviceType.Id,
			From_Criteria__c = 'someaddress1@email.com',
			From_Operator__c = 'starts with',
			Subject_Criteria__c = 'Test Email',
			Subject_Operator__c = 'starts with',
			Description_Criteria__c = '<b>hello world Test</b>',
			Description_Operator__c = 'starts with'
		);
		insert emailRule;

		Shared_Email_Rule__c sharedEmailRule = new Shared_Email_Rule__c(Shared_Email__c = sharedEmail.Id, Email_Rule__c = emailRule.Id);
		insert sharedEmailRule;

		Messaging.InboundEmail email = new Messaging.InboundEmail();
		email = new Messaging.InboundEmail();
		email.subject = 'Test Email';
		email.fromAddress = 'someaddress1@email.com';
		email.toAddresses = new List<String>{ 'test@sample.com', 'Test@SalesForceTest.com' };
		email.htmlBody = '<b>hello world Test</b>';

		Test.startTest();

		EmailRuleEngine.RuleData ruleWrapper = EmailRuleEngine.findMatchingRule(email, false, 'Case');
		System.assertEquals(ruleWrapper.hasMathingRule, true);

		Test.stopTest();
	}
	//Method to test
	static testMethod void testEmailRuleEngine5() {
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

		Id recordTypeId = Schema.SObjectType.Email_Rule__c.getRecordTypeInfosByName().get('Classify Rule').getRecordTypeId();

		Email_Rule__c emailRule = new Email_Rule__c(
			Name = 'Test',
			Active__c = true,
			Service_Type__c = serviceType.Id,
			RecordTypeId = recordTypeId,
			Route_To_Queue__c = serviceGr.Id,
			Org_Wide_Default_Rule__c = true
		);
		insert emailRule;

		Shared_Email_Rule__c sharedEmailRule = new Shared_Email_Rule__c(Shared_Email__c = sharedEmail.Id, Email_Rule__c = emailRule.Id);
		insert sharedEmailRule;

		Test.startTest();
		//EmailRuleEngine.isSenderOrgWideEmailAddress('complaintstest@absa.co.za');

		//Create a new email
		Messaging.InboundEmail email = new Messaging.InboundEmail();
		email.subject = 'Test Email rule';
		email.fromAddress = 'someaddress@email.com';
		email.plainTextBody = 'email body\n2225256325\nTitle';
		Boolean result = EmailRuleEngine.emailBodyCheck(email);
		System.assertEquals(result, true);

		email = new Messaging.InboundEmail();
		email.subject = 'Test Email';
		email.messageId = '123456';
		email.fromAddress = 'someaddress1@email.com';
		email.toAddresses = new List<String>{ 'test@sample.com', 'Test@SalesForceTest.com' };
		email.htmlBody = '<b>hello world Test</b>';
		result = EmailRuleEngine.emailBodyCheck(email);
		System.assertEquals(result, true);

		String plainText = EmailRuleEngine.HtmlToText('<html><body><div>Sample Test</div><b>Case</b></body></html>');
		System.assertEquals(plainText, 'Sample TestCase');

		EmailRuleEngine.RuleData ruleWrapper = EmailRuleEngine.findMatchingRule(email, false, 'Case');

		Test.stopTest();
	}

	static testMethod void testEmailRuleEngine6() {
		Service_Type__c serviceType = new Service_Type__c(Name = 'Test1', Case_Record_Type__c = 'New', Subtype__c = 'Sample', Type__c = 'T01');
		insert serviceType;

		Service_Group__c serviceGr = new Service_Group__c(
			Name = 'Direct Delivery STI',
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

		Id recordTypeId = Schema.SObjectType.Email_Rule__c.getRecordTypeInfosByName().get('Classify Rule').getRecordTypeId();

		Email_Rule__c emailRule = new Email_Rule__c(
			Name = 'Test',
			Active__c = true,
			Service_Type__c = serviceType.Id,
			Subject_Operator__c = 'equals',
			Subject_Criteria__c = 'New Life Advisor Referral Lead',
			RecordTypeId = recordTypeId,
			Route_To_Queue__c = serviceGr.Id,
			Org_Wide_Default_Rule__c = false
		);
		insert emailRule;

		Shared_Email_Rule__c sharedEmailRule = new Shared_Email_Rule__c(Shared_Email__c = sharedEmail.Id, Email_Rule__c = emailRule.Id);
		insert sharedEmailRule;

		Test.startTest();
		//EmailRuleEngine.isSenderOrgWideEmailAddress('complaintstest@absa.co.za');

		//Create a new email
		Messaging.InboundEmail email = new Messaging.InboundEmail();
		email.subject = 'Test Email rule';
		email.fromAddress = 'someaddress@email.com';
		email.plainTextBody = 'email body\n2225256325\nTitle';
		Boolean result = EmailRuleEngine.emailBodyCheck(email);
		System.assertEquals(result, true);

		email = new Messaging.InboundEmail();
		email.subject = 'Test Email';
		email.messageId = '123456';
		email.fromAddress = 'someaddress1@email.com';
		email.toAddresses = new List<String>{ 'test@sample.com', 'Test@SalesForceTest.com' };
		email.htmlBody = '<b>hello world Test</b>';
		result = EmailRuleEngine.emailBodyCheck(email);
		System.assertEquals(result, true);

		String plainText = EmailRuleEngine.HtmlToText('<html><body><div>Sample Test</div><b>Case</b></body></html>');
		System.assertEquals(plainText, 'Sample TestCase');

		EmailRuleEngine.RuleData ruleWrapper = EmailRuleEngine.findMatchingRule(email, false, 'Lead');

		Test.stopTest();
	}

	//Method to test
	static testMethod void testAutoBlockSpamJunkEmails() {
		Shared_Email__c sharedEmail = new Shared_Email__c();
		sharedEmail.Salesforce_Email_Address__c = 'Test@SalesForceTest.com';
		sharedEmail.Inbox_Address__c = 'test@sf.com';
		sharedEmail.Active__c = true;
		sharedEmail.Verified__c = true;
		sharedEmail.Auto_Block_Spam_Junk_Emails__c = true;
		insert sharedEmail;

		RecordType rType = [SELECT Id, DeveloperName FROM RecordType WHERE DeveloperName = :'Blocking_Rule' AND sObjectType = :'Email_Rule__c'];
		System.assertNotEquals(null, rType);
		Email_Rule__c emailRule = new Email_Rule__c();
		emailRule.RecordTypeId = rType.Id;
		emailRule.Name = 'Test';
		emailRule.Active__c = false;
		emailRule.From_Criteria__c = 'someaddress1@email.com';
		emailRule.From_Operator__c = 'starts with';
		emailRule.Subject_Criteria__c = 'Test Email';
		emailRule.Subject_Operator__c = 'starts with';
		emailRule.Description_Criteria__c = '<b>hello world Test</b>';
		emailRule.Description_Operator__c = 'starts with';
		insert emailRule;

		Shared_Email_Rule__c sharedEmailRule = new Shared_Email_Rule__c();
		sharedEmailRule.Shared_Email__c = sharedEmail.Id;
		sharedEmailRule.Email_Rule__c = emailRule.Id;
		insert sharedEmailRule;

		BusinessHours businessHr = [SELECT Id FROM BusinessHours LIMIT 1];
		Service_Group__c serviceGr = new Service_Group__c();
		serviceGr.Name = 'Test SF Group';
		serviceGr.Assign_Record_Type__c = 'Email';
		serviceGr.Response_Email_Address__c = 'test@sf.com';
		serviceGr.Queue__c = 'Email';
		serviceGr.Business_Hours__c = businessHr.Id;
		serviceGr.Internal_SLA_Time_Measure__c = 'Hour(s)';
		serviceGr.Internal_SLA_Units__c = '8';
		serviceGr.Manager__c = UserInfo.getUserId();
		insert serviceGr;

		Set<String> fromAddresses = new Set<String>{ 'someaddress1@email.com' };
		Set<String> toAddresses = new Set<String>{ 'test@sf.com' };
		Map<String, String> inboxAddressesMap = new Map<String, String>{ 'someaddress1@email.com' => 'test@sf.com' };
		Map<String, String> serviceGroupIdMap = new Map<String, String>{ 'someaddress1@email.com' => serviceGr.Id };
		Map<String, String> serviceGroupManagerMap = new Map<String, String>{ serviceGr.Id => serviceGr.Manager__c };

		Test.startTest();

		EmailRuleEngine.autoBlockSpamJunkEmails(fromAddresses, toAddresses, inboxAddressesMap, serviceGroupIdMap, serviceGroupManagerMap);

		Test.stopTest();
	}
}