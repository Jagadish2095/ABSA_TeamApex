/**
 * @description       : 
 * @author            : poulami.banerjee@absa.africa
 * @last modified on  : 2021-11-23
 * @last modified by  : Sulochana.Desam@absa.africa
 * Modifications Log 
 * Ver   Date         Author                         Modification
 * 1.0   2021-06-09   poulami.banerjee@absa.africa   Initial Version
**/
@isTest
private class EmailCreateLeadTest {
	/*
	 * Purpose : Method to create test data
	 */
	@testSetup
	static void dataCreation() {
		Map<String, Schema.RecordTypeInfo> rtInfo = CommonUtils.getRecordTypesForsObject('Lead');
		Id retailSalesLead = rtInfo.get('Retail_Sales_Lead').getRecordTypeId();

		Financial_Product__c testFinancialProduct = new Financial_Product__c(Name = 'Test', Product_Type__c = '', Business_Unit__c = 'Business Banking');
		insert testFinancialProduct;
		
        Campaign camprec = new Campaign(
        Campaign_Code__c = 'VA Maturity',
        Name= 'VA Maturity',
        Description = 'Test'
        );
        insert camprec;
        
		Lead leadRec = new Lead(
			FirstName = 'Test1',
			LastName = 'Test2',
			Email = 'test@test.com',
			RecordTypeId = retailSalesLead,
			Response_Tracking_Code__c = 'Test',
            Campaign__c = camprec.Id,
            LeadSource = 'B2C',
            Campaign_Code__c = 'VA Maturity',
			Product_Interest_1__c = testFinancialProduct.Id
		);
		insert leadRec;
	}

	@isTest
	private static void testCreateRuleMatchingCase() {
		Lead leadRec = [SELECT Id FROM Lead LIMIT 1];

		//Create a new email
		Messaging.InboundEmail email = new Messaging.InboundEmail();
		email.subject = 'Test Email rule';
		//  email.fromAddress = 'test@test.com';
		email.htmlBody = '<b>hello world Test</b>';
		email.toAddresses = new List<String>{ 'test@sample.com', 'Test@SalesForceTest.com' };
		email.ccAddresses = new List<String>{ 'test1@sample.com', 'Test1@SalesForceTest.com' };

		Messaging.InboundEmail.BinaryAttachment attachment = new Messaging.InboundEmail.BinaryAttachment();
		attachment.body = blob.valueOf('my attachment text');
		attachment.fileName = 'Testfile.txt';
		attachment.mimeTypeSubType = 'text/plain';
		email.binaryAttachments = new List<Messaging.inboundEmail.BinaryAttachment>{ attachment };
		EmailCreateLead.createUnwantedEmailRecord(email, 75);
		Unwanted_Email__c unwantedEmail = [SELECT Id FROM Unwanted_Email__c LIMIT 1];
		System.assertNotEquals(null, unwantedEmail);
		string contentversion = leadRec.id;
		List<string> str = new List<string>();
		str.add(contentversion);
		Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
		EmailCreateLead.createContentLink(str, leadRec.id);
		EmailCreateLead.createEmailMessage(email, env, leadRec.Id, 'Lead');
		List<Messaging.InboundEmail.BinaryAttachment> lst = new List<Messaging.InboundEmail.BinaryAttachment>();
		lst.add(attachment);
		EmailCreateLead.createContent(lst, leadRec.Id);
	}

	@isTest
	private static void testCreateRuleMatchingCase2() {
		Lead leadRec = [SELECT Id FROM Lead LIMIT 1];

		Service_Type__c serviceType = new Service_Type__c(Name = 'Test1', Case_Record_Type__c = 'New', Subtype__c = 'Sample', Type__c = 'T01');
		insert serviceType;

		BusinessHours businessHr = [SELECT Id FROM BusinessHours LIMIT 1];

		Service_Group__c serviceGr = new Service_Group__c(
			Name = 'Extended Cover',
			Assign_Record_Type__c = 'Direct Delivery Sales Lead',
			Internal_SLA_Time_Measure__c = 'Hour(s)',
			Internal_SLA_Units__c = '5',
			Queue__c = 'Email',
			Pause_Statuses__c = 'Awaiting Customer Feedback',
			Business_Hours__c = businessHr.Id,
			Email_Template_Lead_Creation__c = 'Email template'
		);
		insert serviceGr;

		Service_Group_Type__c serviceGrType = new Service_Group_Type__c(Service_Group__c = serviceGr.Id, Service_Type__c = serviceType.Id);
		insert serviceGrType;

		List<Service_Group__c> serviceGrList = [
			SELECT
				Id,
				Name,
				Queue__c,
				Pause_Statuses__c,
				Assign_Record_Type__c,
				Business_Hours__c,
				Email_Template_Lead_Creation__c,
				Response_Email_Address__c,
				Internal_SLA_Time_Measure__c,
				Internal_SLA_Units__c,
				Internal_SLA_Notification_User__c,
				Manager__c
			FROM Service_Group__c
		];

		Service_Level__c testServT = new Service_Level__c(
			Name = 'Test1',
			External_SLA_Time_Measure__c = 'Hour(s)',
			External_SLA_Units__c = '8',
			Default_Service_Level__c = true
		);
		insert testServT;
		Financial_Product__c fps = new Financial_Product__c();
		fps.name = 'Extended Cover';
		fps.Business_Unit__c = 'WIMI';
		insert fps;
		system.assertEquals(fps.name, serviceGr.name);
		Financial_Product__c productRecord = [SELECT Id FROM Financial_Product__c LIMIT 1];
		//Create a new email
		Messaging.InboundEmail email = new Messaging.InboundEmail();
		email.subject = 'Customer name: Kyle Alexander"';
		//email.fromAddress = 'sipho@marketsa.co.za';
		email.fromAddress = 'sipho.mbulawa@absa.africa';
		email.plainTextBody =
			'hello world Test' +
			'\n' +
			'Customer Key: 12345' +
			'\n' +
			'Preferred Contact Number: 0609890056' +
			'\n' +
			'Additional Contact Number: 0609890053' +
			'\n' +
			'Product Interest: ' +
			productRecord.Id;
		email.messageId = '<JHHIUHIUHIUIUG657757657>';
		email.toAddresses = new List<String>{ 'test@sample.com', 'Test@SalesForceTest.com' };
		email.ccAddresses = new List<String>{ 'test1@sample.com', 'Test1@SalesForceTest.com' };
		List<Service_Group_Type__c> lstgt = new List<Service_Group_Type__c>{};

		String emailCaseId = EmailCreateLead.createRuleMatchingLead(
			email,
			serviceGrList,
			lstgt,
			testServT.Id,
			'Classify_Rule',
			'abs@xyz.com',
			false,
			'Test',
			'7812BE',
			null
		);

		email.subject = 'Hello';
		email.fromName = 'Test User';
		emailCaseId = EmailCreateLead.createRuleMatchingLead(
			email,
			serviceGrList,
			new List<Service_Group_Type__c>{ serviceGrType },
			testServT.Id,
			'Classify_Rule',
			'abs@xyz.com',
			false,
			'Test',
			'7812BE',
			null
		);
	}

	@isTest
	private static void testEmailCreateLead1() {
		Lead leadRec = [SELECT Id FROM Lead LIMIT 1];
		system.assertNotEquals(null, leadrec);
		//Create a new email
		Messaging.InboundEmail email = new Messaging.InboundEmail();
		email.subject = 'Test Email rule';
		// email.fromAddress = 'someaddress@email.com';
		email.plainTextBody = 'Test hello world';
		email.toAddresses = new List<String>{ 'test@sample.com', 'Test@SalesForceTest.com' };
		email.ccAddresses = new List<String>{ 'test1@sample.com', 'Test1@SalesForceTest.com' };
		Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();

		EmailCreateLead.createEmailMessage(email, env, leadRec.Id, 'Lead');
	}

	@isTest
	private static void testEmailCreateLeadLargeEmail() {
		Lead leadRec = [SELECT Id FROM Lead LIMIT 1];
		system.assertNotEquals(null, leadRec);
		//Create a new email
		Messaging.InboundEmail email = new Messaging.InboundEmail();
		email.subject = 'Test Email rule';
		//email.fromAddress = 'someaddress@email.com';

		String plainText = 'Test hello world Test hello worldTest hello worldTest hello worldTest hello worldTest hello worldTest hello worldTest hello worldTest hello world';
		for (Integer a = 0; a < 1000; a++) {
			plainText += 'Test hello world Test hello worldTest hello worldTest hello worldTest hello worldTest hello worldTest hello worldTest hello worldTest hello world';
		}
		email.plainTextBody = plainText;
		//system.debug('BODY_LENGTH:' + email.plainTextBody.length());
		email.toAddresses = new List<String>{ 'test@sample.com', 'Test@SalesForceTest.com' };
		email.ccAddresses = new List<String>{ 'test1@sample.com', 'Test1@SalesForceTest.com' };

		Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();

		EmailCreateLead.createEmailMessage(email, env, leadRec.Id, 'Lead');
		EmailCreateLead.createUnwantedEmailRecord(email, 1);
	}
	// Added by Chenna as part of DD Lead creation for Direct Delivery Sales Opportunity Record Type
	@isTest
	private static void testCreateRuleMatchingLead3() {
		Lead leadRec = [SELECT Id FROM Lead LIMIT 1];

		Service_Type__c serviceType = new Service_Type__c(Name = 'Test1', Case_Record_Type__c = 'New', Subtype__c = 'Sample', Type__c = 'T01');
		insert serviceType;

		BusinessHours businessHr = [SELECT Id FROM BusinessHours LIMIT 1];

		//added
		list<Service_Group__c> servlist = new List<Service_Group__c>();
		Service_Group__c serviceGr = new Service_Group__c(
			Name = 'AVAF CreditLife',
			Assign_Record_Type__c = 'Direct Delivery Sales Lead',
			Internal_SLA_Time_Measure__c = 'Hour(s)',
			Internal_SLA_Units__c = '5',
			Queue__c = 'Email',
			Pause_Statuses__c = 'Awaiting Customer Feedback',
			Business_Hours__c = businessHr.Id,
			Email_Template_Lead_Creation__c = 'Email template'
		);
		servlist.add(serviceGr);
		insert servlist;

		Service_Group_Type__c serviceGrType = new Service_Group_Type__c(Service_Group__c = servlist[0].Id, Service_Type__c = serviceType.Id);
		insert serviceGrType;

		List<Service_Group__c> serviceGrList = [
			SELECT
				Id,
				Name,
				Queue__c,
				Pause_Statuses__c,
				Assign_Record_Type__c,
				Business_Hours__c,
				Email_Template_Lead_Creation__c,
				Response_Email_Address__c,
				Internal_SLA_Time_Measure__c,
				Internal_SLA_Units__c,
				Internal_SLA_Notification_User__c,
				Manager__c
			FROM Service_Group__c
		];

		Service_Level__c testServT = new Service_Level__c(
			Name = 'Test1',
			External_SLA_Time_Measure__c = 'Hour(s)',
			External_SLA_Units__c = '8',
			Default_Service_Level__c = true
		);
		insert testServT;

		Financial_Product__c fps = new Financial_Product__c();
		fps.name = 'AVAF Credit Life';
		fps.Business_Unit__c = 'WIMI';
		insert fps;
		Financial_Product__c productRecord = [SELECT Id FROM Financial_Product__c LIMIT 1];
		//system.debug('>>>>>207>>>>>>>' + fps.name);
		//Create a new email
		Group gp = new Group();
		gp.name = 'DD-AVAF Credit Life';
		insert gp;

		//system.assertEquals(fps.name,serviceGr.name);
		system.assertNotEquals(gp.id, null);
		Messaging.InboundEmail email = new Messaging.InboundEmail();
		email.subject = 'Customer name: Kyle Alexander"';
		//email.fromAddress = 'sipho@marketsa.co.za';
		email.fromAddress = 'sipho.mbulawa@absa.africa';
		email.plainTextBody =
			'hello world Test' +
			'\n' +
			'Customer Key: 12345' +
			'\n' +
			'Preferred Contact Number: 0609890056' +
			'\n' +
			'Additional Contact Number: 0609890053' +
			'\n' +
			'Product Interest: ' +
			productRecord.Id;
		email.messageId = '<JHHIUHIUHIUIUG657757657>';
		email.toAddresses = new List<String>{ 'test@sample.com', 'Test@SalesForceTest.com' };
		email.ccAddresses = new List<String>{ 'test1@sample.com', 'Test1@SalesForceTest.com' };
		List<Service_Group_Type__c> lstgt = new List<Service_Group_Type__c>{};

		String emailCaseId = EmailCreateLead.createRuleMatchingLead(
			email,
			servlist,
			//serviceGrList,
			lstgt,
			testServT.Id,
			'Classify_Rule',
			'abs@xyz.com',
			false,
			'Test',
			'7812BE',
			null
		);

		email.subject = 'Hello';
		email.fromName = 'Test User';
		emailCaseId = EmailCreateLead.createRuleMatchingLead(
			email,
			serviceGrList,
			new List<Service_Group_Type__c>{ serviceGrType },
			testServT.Id,
			'Classify_Rule',
			'abs@xyz.com',
			false,
			'Test',
			'7812BE',
			null
		);
	}
	@isTest
	private static void testCreateRuleMatchingLead4() {
		Lead leadRec = [SELECT Id FROM Lead LIMIT 1];

		Service_Type__c serviceType = new Service_Type__c(Name = 'Test1', Case_Record_Type__c = 'New', Subtype__c = 'Sample', Type__c = 'T01');
		insert serviceType;

		BusinessHours businessHr = [SELECT Id FROM BusinessHours LIMIT 1];

		Service_Group__c serviceGr = new Service_Group__c(
			Name = 'AVAF CreditLife',
			Assign_Record_Type__c = 'Direct Delivery Sales Lead',
			Internal_SLA_Time_Measure__c = 'Hour(s)',
			Internal_SLA_Units__c = '5',
			Queue__c = 'Email',
			Pause_Statuses__c = 'Awaiting Customer Feedback',
			// Business_Hours__c = businessHr.Id,
			Email_Template_Lead_Creation__c = 'Email template'
		);
		insert serviceGr;

		Service_Group_Type__c serviceGrType = new Service_Group_Type__c(Service_Group__c = serviceGr.Id, Service_Type__c = serviceType.Id);
		insert serviceGrType;

		List<Service_Group__c> serviceGrList = [
			SELECT
				Id,
				Name,
				Queue__c,
				Pause_Statuses__c,
				Assign_Record_Type__c,
				Business_Hours__c,
				Email_Template_Lead_Creation__c,
				Response_Email_Address__c,
				Internal_SLA_Time_Measure__c,
				Internal_SLA_Units__c,
				Internal_SLA_Notification_User__c,
				Manager__c
			FROM Service_Group__c
		];

		Service_Level__c testServT = new Service_Level__c(
			Name = 'Test1',
			External_SLA_Time_Measure__c = 'Hour(s)',
			External_SLA_Units__c = '8',
			Default_Service_Level__c = true
		);
		insert testServT;

		Financial_Product__c fps = new Financial_Product__c();
		fps.name = 'AVAF CreditLife';
		fps.Business_Unit__c = 'WIMI';
		insert fps;
		Financial_Product__c productRecord = [SELECT Id FROM Financial_Product__c LIMIT 1];
		//Create a new email
		Group gp = new Group();
		gp.name = 'DD-AVAF Credit Life';
		insert gp;

		system.assertEquals(fps.name, serviceGr.name);
		system.assertNotEquals(gp.id, null);
		Messaging.InboundEmail email = new Messaging.InboundEmail();
		email.subject = 'Customer name: Kyle Alexander"';
		//email.fromAddress = 'sipho@marketsa.co.za';
		email.fromAddress = 'sipho.mbulawa@absa.africa';
		email.plainTextBody =
			'hello world Test' +
			'\n' +
			'Customer Key: 12345' +
			'\n' +
			'Preferred Contact Number: 0609890056' +
			'\n' +
			'Additional Contact Number: 0609890053' +
			'\n' +
			'Product Interest: ' +
			productRecord.Id;
		email.messageId = '<JHHIUHIUHIUIUG657757657>';
		email.toAddresses = new List<String>{ 'test@sample.com', 'Test@SalesForceTest.com' };
		email.ccAddresses = new List<String>{ 'test1@sample.com', 'Test1@SalesForceTest.com' };
		List<Service_Group_Type__c> lstgt = new List<Service_Group_Type__c>{};

		String emailCaseId = EmailCreateLead.createRuleMatchingLead(
			email,
			serviceGrList,
			lstgt,
			null,
			'Classify_Rule',
			'abs@xyz.com',
			false,
			'Test',
			'7812BE',
			null
		);

		email.subject = 'Hello';
		email.fromName = 'Test User';
		emailCaseId = EmailCreateLead.createRuleMatchingLead(
			email,
			serviceGrList,
			new List<Service_Group_Type__c>{ serviceGrType },
			testServT.Id,
			'Classify_Rule',
			'abs@xyz.com',
			false,
			'Test',
			'7812BE',
			null
		);
	}

	@isTest
	private static void testCreateRuleMatchingLead7() {
		Lead leadRec = [SELECT Id FROM Lead LIMIT 1];

		Service_Type__c serviceType = new Service_Type__c(Name = 'Test1', Case_Record_Type__c = 'New', Subtype__c = 'Sample', Type__c = 'T01');
		insert serviceType;

		Group gp = new Group();
		gp.name = 'DD Advice STI';
		insert gp;

		BusinessHours businessHr = [SELECT Id FROM BusinessHours LIMIT 1];

		list<Service_Group__c> servlist = new List<Service_Group__c>();
		Service_Group__c serviceGr = new Service_Group__c(
			Name = 'Direct Delivery STI',
			Assign_Record_Type__c = 'DD STI Lead',
			Internal_SLA_Time_Measure__c = 'Hour(s)',
			Internal_SLA_Units__c = '5',
			Queue__c = 'DD Advice STI',
			Pause_Statuses__c = 'Awaiting Customer Feedback',
			Business_Hours__c = businessHr.Id,
			Email_Template_Lead_Creation__c = 'Email template'
		);
		servlist.add(serviceGr);
		insert servlist;

		Service_Group_Type__c serviceGrType = new Service_Group_Type__c(Service_Group__c = servlist[0].Id, Service_Type__c = serviceType.Id);
		insert serviceGrType;

		List<Service_Group__c> serviceGrList = [
			SELECT
				Id,
				Name,
				Queue__c,
				Pause_Statuses__c,
				Assign_Record_Type__c,
				Business_Hours__c,
				Email_Template_Lead_Creation__c,
				Response_Email_Address__c,
				Internal_SLA_Time_Measure__c,
				Internal_SLA_Units__c,
				Internal_SLA_Notification_User__c,
				Manager__c
			FROM Service_Group__c
		];

		Service_Level__c testServT = new Service_Level__c(
			Name = 'Test1',
			External_SLA_Time_Measure__c = 'Hour(s)',
			External_SLA_Units__c = '8',
			Default_Service_Level__c = true
		);
		insert testServT;

		Financial_Product__c fps = new Financial_Product__c();
		fps.name = 'STI';
		fps.Business_Unit__c = 'WIMI';
		insert fps;

		Financial_Product__c productRecord = [SELECT Id FROM Financial_Product__c LIMIT 1];
		//system.debug('>>>>>207>>>>>>>' + fps.name);
		//Create a new email

		//system.assertEquals(fps.name,serviceGr.name);
		system.assertNotEquals(gp.id, null);
		Messaging.InboundEmail email = new Messaging.InboundEmail();
		email.subject = 'Customer name: Kyle Alexander';
		//email.fromAddress = 'sipho@marketsa.co.za';
		email.fromAddress = 'sipho.mbulawa@absa.africa';
		email.plainTextBody = 'hello world Test';
		email.messageId = '<JHHIUHIUHIUIUG657757657>';
		email.toAddresses = new List<String>{ 'test@sample.com', 'Test@SalesForceTest.com' };
		email.ccAddresses = new List<String>{ 'test1@sample.com', 'Test1@SalesForceTest.com' };
		List<Service_Group_Type__c> lstgt = new List<Service_Group_Type__c>{};

		String emailCaseId = EmailCreateLead.createRuleMatchingLead(
			email,
			servlist,
			//serviceGrList,
			lstgt,
			testServT.Id,
			'Classify_Rule',
			'abs@xyz.com',
			false,
			'Test',
			'7812BE',
			null
		);
	}
}