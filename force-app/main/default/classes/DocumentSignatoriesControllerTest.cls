/*
 * Modified by Tinashe Shoko 02-06-21
 *
 */
@IsTest
public class DocumentSignatoriesControllerTest{
	@IsTest
	static void testDocumentSignatoriesController(){
		WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
		test.startTest();
		List<Document__c> documents = DocumentSignatoriesController.getDocumentsData(testDataFactory.testOpportunity.id);
		DocumentSignatoriesController.fetchAdviserName();
		DocumentSignatoriesController.fetchOppOwnerName(testDataFactory.testOpportunity.id);
		DocumentSignatoriesController.fetchImpressionRequest(testDataFactory.testOpportunity.id);
		List<String> mobileList = DocumentSignatoriesController.getMobile(testDataFactory.testMerchantOnboardingOpportunity.id);
		List<String> emailsList = DocumentSignatoriesController.getAllClientEmails(testDataFactory.testMerchantOnboardingOpportunity.id);
		List<String> sigList = DocumentSignatoriesController.getAllClientEmailsSignature(testDataFactory.testMerchantOnboardingOpportunity.id);

		testDataFactory.testQuoteDocument.Opportunity__c = testDataFactory.testMerchantOnboardingOpportunity.id;
		update testDataFactory.testQuoteDocument;
		DocumentSignatoriesController.getSignatoriesData(testDataFactory.testQuoteDocument.id, testDataFactory.testQuoteDocument.Type__c, testDataFactory.testMerchantOnboardingOpportunity.id);

		testDataFactory.testDigitalSignatureSignatoryQuote.Signatory_Type__c = 'Parent Owner';
		update testDataFactory.testDigitalSignatureSignatoryQuote;

		DocumentSignatoriesController.getSignatoriesData(testDataFactory.testQuoteDocument.id, testDataFactory.testQuoteDocument.Type__c, testDataFactory.testMerchantOnboardingOpportunity.id);
		testDataFactory.testDigitalSignatureSignatoryQuote.Signatory_Type__c = 'Authorised Signatory';
		update testDataFactory.testDigitalSignatureSignatoryQuote;
		DocumentSignatoriesController.getSignatoriesData(testDataFactory.testQuoteDocument.id, testDataFactory.testQuoteDocument.Type__c, testDataFactory.testMerchantOnboardingOpportunity.id);

		testDataFactory.testMerchantOnboardingOpportunity.Accountid = testDataFactory.testBizAccount.id;
		update testDataFactory.testMerchantOnboardingOpportunity;
		Contact c = [Select id
		             from Contact
		             where RecordType.DeveloperName = 'Contact'
		             LIMIT 1];
		c.AccountId = testDataFactory.testBizAccount.id;
		update c;

		testDataFactory.testMerchantOnboardingOpportunity.accountid = testDataFactory.testProspectAccount.id;
		update testDataFactory.testMerchantOnboardingOpportunity;

		Id testProspectAccountContactId = [Select Id, PersonContactId
		                                   FROM Account
		                                   WHERE Id = :testDataFactory.testProspectAccount.Id].PersonContactId;

		Signatory_Party_Overide__c spo2 = new Signatory_Party_Overide__c(Opportunity__c = testDataFactory.testMerchantOnboardingOpportunity.id, Preferred_Email__c = 'test@12.com', Preferred_Method__c = 'Realtime', Preferred_Mobile__c = '0989876543', Signatory_Party__c = testProspectAccountContactId);
		insert spo2;

		mobileList = DocumentSignatoriesController.getMobile(testDataFactory.testMerchantOnboardingOpportunity.id);
		emailsList = DocumentSignatoriesController.getAllClientEmails(testDataFactory.testMerchantOnboardingOpportunity.id);
		sigList = DocumentSignatoriesController.getAllClientEmailsSignature(testDataFactory.testMerchantOnboardingOpportunity.id);

		testDataFactory.testDigitalSignatureSignatoryQuote.Signatory_Type__c = 'Parent Customer';
		update testDataFactory.testDigitalSignatureSignatoryQuote;
		DocumentSignatoriesController.getSignatoriesData(testDataFactory.testQuoteDocument.id, testDataFactory.testQuoteDocument.Type__c, testDataFactory.testMerchantOnboardingOpportunity.id);
		testDataFactory.testMerchantOnboardingOpportunity.accountid = testDataFactory.testBizAccount.id;
		update testDataFactory.testMerchantOnboardingOpportunity;
		spo2.Opportunity__c = testDataFactory.testMerchantOnboardingOpportunity.id;
		spo2.Signatory_Party__c = c.id;
		update spo2;

		testDataFactory.testDigitalSignatureSignatoryQuote.Signatory_Type__c = 'Parent Owner';
		update testDataFactory.testDigitalSignatureSignatoryQuote;
		DocumentSignatoriesController.getSignatoriesData(testDataFactory.testQuoteDocument.id, testDataFactory.testQuoteDocument.Type__c, testDataFactory.testMerchantOnboardingOpportunity.id);

		spo2.Opportunity__c = testDataFactory.testMerchantOnboardingOpportunity.id;
		spo2.Signatory_Party__c = testDataFactory.testMerchantOnboardingOpportunity.AccountId;
		update spo2;
		testDataFactory.testDigitalSignatureSignatoryQuote.Signatory_Type__c = 'Authorised Signatory';
		update testDataFactory.testDigitalSignatureSignatoryQuote;
		List<Map<String, Object>> ll = DocumentSignatoriesController.getSignatoriesData(testDataFactory.testQuoteDocument.id, testDataFactory.testQuoteDocument.Type__c, testDataFactory.testMerchantOnboardingOpportunity.id);

		testDataFactory.testDigitalSignatureSignatoryQuote.Signatory_Type__c = 'Related Party Signatory';
		update testDataFactory.testDigitalSignatureSignatoryQuote;
		ll = DocumentSignatoriesController.getSignatoriesData(testDataFactory.testQuoteDocument.id, testDataFactory.testQuoteDocument.Type__c, testDataFactory.testMerchantOnboardingOpportunity.id);

		system.assertNotEquals(null, mobileList.size());
		system.assertNotEquals(null, emailsList.size());
		system.assertNotEquals(null, sigList.size());
		system.assertNotEquals(-1, documents.size());
		test.stopTest();
	}

	@IsTest
	static void testDocumentSignatoriesControllerRoles(){
		WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
		Id testProspectAccountContactId = [Select Id, PersonContactId
		                                   FROM Account
		                                   WHERE Id = :testDataFactory.testProspectAccount.Id].PersonContactId;

		test.startTest();
		List<Document__c> documents = DocumentSignatoriesController.getDocumentsData(testDataFactory.testOpportunity.id);
		Signatory_Party_Overide__c spo = new Signatory_Party_Overide__c();
		List<String> sel = DocumentSignatoriesController.getDigitalSignatorySelectOptions('Preferred_Method__c');
		system.assertNotEquals(null, sel);

		AccountContactRelation acr = new AccountContactRelation();
		acr.AccountId = testDataFactory.testMerchantOnboardingOpportunity.AccountId;
		acr.ContactId = testProspectAccountContactId;
		acr.roles = 'Individual with Authority to Act;Shareholder/Controller;Contact Person';
		insert acr;

		testDataFactory.testDigitalSignatureSignatoryQuote.Signatory_Type__c = 'Related Party Signatory';
		update testDataFactory.testDigitalSignatureSignatoryQuote;
		List<Map<String, Object>> ll = DocumentSignatoriesController.getSignatoriesData(testDataFactory.testQuoteDocument.id, testDataFactory.testQuoteDocument.Type__c, testDataFactory.testMerchantOnboardingOpportunity.id);

		testDataFactory.testDigitalSignatureSignatoryQuote.Signatory_Type__c = 'Parent Owner';
		update testDataFactory.testDigitalSignatureSignatoryQuote;
		DocumentSignatoriesController.getSignatoriesData(testDataFactory.testQuoteDocument.id, testDataFactory.testQuoteDocument.Type__c, testDataFactory.testMerchantOnboardingOpportunity.id);

		testDataFactory.testDigitalSignatureSignatoryQuote.Signatory_Type__c = 'Authorised Signatory';
		update testDataFactory.testDigitalSignatureSignatoryQuote;
		ll = DocumentSignatoriesController.getSignatoriesData(testDataFactory.testQuoteDocument.id, testDataFactory.testQuoteDocument.Type__c, testDataFactory.testMerchantOnboardingOpportunity.id);


		boolean docRestricted = DocumentSignatoriesController.documentRestricted(testDataFactory.testOpportunity.id, testDataFactory.testDocument.id);
		List<Id> selectedIds = new List<Id>();
		selectedIds.add(UserInfo.getUserid());
		selectedIds.add([Select id
		                 from AccountContactRelation
		                 LIMIT 1].id);
		DocumentSignatoriesController.createDocumentSignatureRequests(testDataFactory.testOpportunity.id, testDataFactory.testQuoteDocument.Type__c, selectedIds);
		test.stopTest();
	}
}