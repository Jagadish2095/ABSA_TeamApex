/**
 * @description Test class for DLCaseManagerController
 * @author Jason Quevauvilliers
 * @created 2021-03-31

 * @updated Jason Quevauvilliers

 */
@IsTest
public class DLCaseManagerControllerTest {
	@TestSetup
	static void makeData() {
		map<String, Schema.RecordTypeInfo> caseRecordTypeMap = Case.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
		Account account = new Account(Name = 'Test Account');
		insert account;

		Contact contact = new Contact(LastName = 'Test contact', AccountId = account.Id, Email = 'absa@absa.co.za');
		insert contact;

		Service_Group__c serviceGroupRecord = new Service_Group__c(
			Name = 'CurrentServiceGroup',
			Queue__c = 'Queue',
			Active__c = true,
			Assign_Record_Type__c = 'Complaint',
			Response_Email_Address__c = 'absa@absa.co.za'
		);
		insert serviceGroupRecord;

		Case caseRec = new Case(
			Communication_Method__c = 'Email',
			Status = 'New',
			Origin = 'Email',
			Account = account,
			Email__c = 'test@test.com',
			recordTypeId = caseRecordTypeMap.get('Complaint').getRecordTypeId(),
			Subject = 'test',
			Description = 'test',
			Expectation_of_the_Customer__c = 'test',
			Incident_Date__c = date.today(),
			Service_Group_Search__c = serviceGroupRecord.Id,
			sd_Service_Group_Id__c = serviceGroupRecord.Id,
			SLA_Extension_Approval__c = 'Pending'
		);
		insert caseRec;

		Service_Group__c newServiceGroupRecord = new Service_Group__c(
			Name = 'NewServiceGroup',
			Queue__c = 'Queue',
			Active__c = true,
			Assign_Record_Type__c = 'Complaint',
			Response_Email_Address__c = 'absa@absa.co.za'
		);
		insert newServiceGroupRecord;
		Service_Level__c sl = new Service_level__c(
			Name = 'SL',
			Default_Service_Level__c = true,
			External_SLA_Time_Measure__c = 'Day(s)',
			External_SLA_Units__c = '5'
		);
		insert sl;
		Service_Type__c st = new Service_Type__c(Name = 'Type Subtype', Type__c = 'Type', Subtype__c = 'Subtype');
		insert st;
		Service_Group_Type__c sgt = new Service_Group_Type__c(Service_Group__c = newServiceGroupRecord.Id, Service_Level__c = sl.id, Service_Type__c = st.Id);
		insert sgt;
		Voucher__c voucher = new Voucher__c(
			Case__c = caseRec.Id,
			Name = 'Spotify',
			Amount__c = 200,
			Date_of_Purchase__c = Date.valueOf('2020-09-30'),
			Voucher_Expiry_Date__c = Date.valueOf('2023-09-30'),
			Order_Number__c = '123414'
		);
		insert voucher;
		CaseComment comment = new CaseComment(ParentId = caseRec.Id, CommentBody = 'TestBody');
		insert comment;
	}

	@IsTest
	static void testGetData() {
		Case caseRec = [SELECT Id FROM Case LIMIT 1];

		Test.startTest();
		Map<String, String> responseMap = DLCaseManagerController.getData('Voucher Redemption', caseRec.Id);
		Test.stopTest();
		System.assertNotEquals(null, responseMap.get('voucherList'), 'Assert Failed');
		System.assertNotEquals(null, responseMap.get('commentList'), 'Assert Failed');
		System.assertNotEquals(null, responseMap.get('picklistOptions'), 'Assert Failed');
	}

	@IsTest
	static void testTransferCase() {
		Case caseRec = [SELECT Id, Transfer_Reason__c FROM Case LIMIT 1];
		caseRec.BusinessHoursId = [SELECT Id FROM BusinessHours WHERE isActive = TRUE LIMIT 1].Id;
		update caseRec;
		Service_Group__c serviceGroupRec = [SELECT Id, Name FROM Service_Group__c WHERE Name = 'NewServiceGroup' LIMIT 1];
		Service_Type__c serviceTypeRec = [SELECT Id, Name FROM Service_Type__c LIMIT 1];

		Test.startTest();
		DLCaseManagerController.transferCase(serviceGroupRec.Name, serviceTypeRec.Name, caseRec.Id);
		Test.stopTest();

		Case caseAfter = [SELECT Id, sd_Service_Group__c FROM Case LIMIT 1];
		System.assertEquals(caseAfter.sd_Service_Group__c, serviceGroupRec.Name, 'Assert Failed');
	}

	@IsTest
	static void testSendEmail() {
		Case caseRec = [SELECT Id, Transfer_Reason__c FROM Case LIMIT 1];
		List<Voucher__c> voucher = [SELECT Name, Amount__c, Date_of_Purchase__c, Voucher_Expiry_Date__c, Order_Number__c FROM Voucher__c LIMIT 1];
		List<CaseComment> comment = [SELECT ParentId, CommentBody FROM CaseComment LIMIT 1];

		Test.startTest();
		String response = DLCaseManagerController.sendEmail(
			caseRec.Id,
			'absa@absa.co.za',
			'Digital_Lifestyle_Escalate_to_Stellr',
			JSON.serialize(voucher),
			JSON.serialize(comment)
		);
		Test.stopTest();
		System.assertEquals('Email sent Successfully', response, 'Assert Failed');
	}
}