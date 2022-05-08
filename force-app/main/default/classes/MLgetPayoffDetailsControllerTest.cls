/*
 * @description MLgetPayoffDetailsControllerTest
 * @author  Srikanth : Absa
 * @version v2.0
 * @since   2020-10-20
 */
@isTest
private class MLgetPayoffDetailsControllerTest {
	public static final String STATIC_RESOURCE_NAME_MOCK_POSITIVE = 'Mock_Positive_MLgetPayoffDetailsV1_v1';
	@TestSetup
	static void makeData() {
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT2,
			new List<String>{ MLgetPayoffDetailsV1_IH_v1.INTEGRATION_SERVICE_NAME, DocumentTemplateProcessor.DOCUMENT_TEMPLATE_PROCESSOR }
		);
		List<String> endpoints = new List<String>();
		endpoints.add('ECM Query Path');
		endpoints.add('ECM Authenication Path');
		endpoints.add('ECM Add Path');
		endpoints.add('ECM Logout Path');
		endpoints.add('ECM GetItemType Path');
		endpoints.add('ECM Get Path');
		endpoints.add('ECM GetItemTypes Path');

		IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, endpoints);
	}

	@IsTest
	static void sendHLSettlementLetterTest() {
		map<String, Schema.RecordTypeInfo> caseRecordTypeMap = Case.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();

		// Set mock callout class
		Test.setMock(
			HttpCalloutMock.class,
			Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(StringConstants.POSITIVE_STRING, STATIC_RESOURCE_NAME_MOCK_POSITIVE)
		);
		Account acc = new Account();
		acc.name = 'test acc';
		acc.CIF__c = 'HJKLL';
		insert acc;

		Document_Template__c dt = new Document_Template__c();
		dt.Document_Type__c = 'Settlement_Letter_HL';
		dt.Name = 'Settlement_Letter_HL';
		insert dt;

		List<String> endpoints = new List<String>();
		endpoints.add(DocumentTemplateProcessor.DOCUMENT_TEMPLATE_PROCESSOR);

		Case cse = new Case(
			Communication_Method__c = 'Email',
			Status = 'New',
			Origin = 'Email',
			AccountId = acc.Id,
			Risk_Management_Centre__c = 'Digital Fraud',
			Email__c = 'test@test.com',
			recordTypeId = caseRecordTypeMap.get('Complaint').getRecordTypeId(),
			Subject = 'test',
			Description = 'test',
			Expectation_of_the_Customer__c = 'test',
			Incident_Date__c = date.today()
		);
		insert cse;
		Test.startTest();

		MLgetPayoffDetailsV1_Req_IB_v1 requestBean = MLgetPayoffDetailsV1_Req_IB_v1.createDummyRequest();
		String response = MLgetPayoffDetailsController.fetchHLSettlementLetter(
			acc.Id,
			requestBean.mLgetPayoffDetailsV1.mlp778i.mortgageLoanNo,
			requestBean.mLgetPayoffDetailsV1.mlp778i.payAllAcc,
			requestBean.mLgetPayoffDetailsV1.mlp778i.effectiveDate,
			requestBean.mLgetPayoffDetailsV1.mlp778i.includeCommit,
			'Settlement_Letter_HL'
		);

		Test.stopTest();
		System.assertNotEquals(null, response, 'Assert Failed');
	}

	@IsTest
	static void sendEmailTest() {
		Service_Group__c tstServQG = new Service_Group__c(
			Name = 'Test',
			Response_Email_Address__c = 'businessbanking@absa.africa',
			Assign_Record_Type__c = 'Service Request',
			Active__c = true
		);
		insert tstServQG;
		EmailTemplate eTemplate = [SELECT Id, Name, DeveloperName FROM EmailTemplate LIMIT 1];
		Test.startTest();
		map<String, Schema.RecordTypeInfo> caseRecordTypeMap = Case.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
		Account acc = new Account();
		acc.name = 'test acc';
		acc.CIF__c = 'HJKLL';
		insert acc;
		Contact testContact = new Contact(LastName = 'Test contact', Email = 'Test@test.com');
		insert testContact;
		Case cse = new Case(
			Communication_Method__c = 'Email',
			Status = 'New',
			Origin = 'Email',
			AccountId = acc.Id,
			Risk_Management_Centre__c = 'Digital Fraud',
			Email__c = 'test@test.com',
			recordTypeId = caseRecordTypeMap.get('Complaint').getRecordTypeId(),
			Subject = 'test',
			Description = 'test',
			Expectation_of_the_Customer__c = 'test',
			sd_Service_Group_Id__c = tstServQG.Id,
			Incident_Date__c = date.today()
		);
		insert cse;
		MLgetPayoffDetailsController.sendEmail(cse.Id, eTemplate.DeveloperName, 'test@test.com', 'Settlement_Letter_HL', 'this is test blob');
		String response = MLgetPayoffDetailsController.caseStatusUpdate(cse.Id);
		test.stopTest();

		System.assertNotEquals(null, response, 'Assert Failed');
	}
}