/**
 * @description This is the DocumentsShareControler test class
 *
 * @author Vladimir Panajic
 * @created    2019-05-24
 */
@IsTest
public class DocumentsShareControllerESignTest{
	@isTest
	public static void testAll(){
		WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
		test.startTest();
		boolean docRestricted = DocumentsShareControllerESign.documentRestricted(testDataFactory.testOpportunity.id, testDataFactory.testDocument.id);
		Digital_Signature_Signatory__c sig = new Digital_Signature_Signatory__c();

		system.assertNotEquals(null, docRestricted);
		test.stopTest();
	}

	@isTest
	public static void getDocumentsData(){
		WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
		test.startTest();
		List<Document__c> documents = DocumentsShareControllerESign.getDocumentsData(testDataFactory.testOpportunity.id);
		List<Document_Audit__c> da = DocumentsShareControllerESign.getDocAuditHistoryEmail(testDataFactory.testOpportunity.id);
		system.assertNotEquals(-1, documents.size());
		system.assertNotEquals(-1, da.size());
		test.stopTest();
	}

	@isTest
	public static void getSignatoriesDataParentOwner(){
		WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
		test.startTest();
		User usr = new UsersSelector().selectById(UserInfo.getUserId());
		usr.Phone = '+27839289087';
		update usr;
		testDataFactory.testDigitalSignatureSignatoryQuote.Signatory_Type__c = 'Parent Owner';
		testDataFactory.testDigitalSignatureSignatoryQuote.Opportunity_Record_Types_Applicable_To__c = 'General;Merchant Onboarding;Product Onboarding';
		update testDataFactory.testDigitalSignatureSignatoryQuote;
		List<Map<String, Object>> zz = DocumentsShareControllerESign.getSignatoriesData(testDataFactory.testQuoteDocument.id);
		testDataFactory.testMerchantOnboardingOpportunity.Accountid = testDataFactory.testBizAccount.id;
		update testDataFactory.testMerchantOnboardingOpportunity;

		Id testProspectAccountContactId = [Select Id, PersonContactId
		                                   FROM Account
		                                   WHERE Id = :testDataFactory.testProspectAccount.Id].PersonContactId;
		Contact c = [Select id
		             from Contact
		             where RecordType.DeveloperName = 'Contact'
		             LIMIT 1];
		c.AccountId = testDataFactory.testBizAccount.id;
		update c;

		Account ac = [Select Id, Client_Type__c
		              from Account
		              where Id = :testDataFactory.testProspectAccount.id];
		ac.Client_Type__c = 'Sole Trader';
		update ac;

		Signatory_Party_Overide__c spo2 = new Signatory_Party_Overide__c(Opportunity__c = testDataFactory.testMerchantOnboardingOpportunity.id, Preferred_Email__c = 'test@12.com', Preferred_Method__c = 'Realtime', Preferred_Mobile__c = '0989876543', Signatory_Party__c = testDataFactory.testAccountContactRelation.id);
		insert spo2;

		testDataFactory.testQuoteDocument.Opportunity__c = testDataFactory.testMerchantOnboardingOpportunity.id;
		update testDataFactory.testQuoteDocument;

		List<Map<String, Object>> lll = DocumentsShareControllerESign.getSignatoriesData(testDataFactory.testQuoteDocument.id);

		List<String> mobileList = DocumentsShareControllerESign.getMobile(testDataFactory.testMerchantOnboardingOpportunity.id);
		List<String> emailsList = DocumentsShareControllerESign.getAllClientEmails(testDataFactory.testMerchantOnboardingOpportunity.id);
		List<String> sigList = DocumentsShareControllerESign.getAllClientEmailsSignature(testDataFactory.testMerchantOnboardingOpportunity.id);

		system.assertNotEquals(null, mobileList.size());
		system.assertNotEquals(null, emailsList.size());
		system.assertNotEquals(null, sigList.size());
		test.stopTest();
	}

	@isTest
	public static void getSignatoriesDataParentCustomer(){
		WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
		test.startTest();
		testDataFactory.testDigitalSignatureSignatoryQuote.Signatory_Type__c = 'Parent Customer';
		testDataFactory.testDigitalSignatureSignatoryQuote.Opportunity_Record_Types_Applicable_To__c = 'General;Merchant Onboarding;Product Onboarding';
		update testDataFactory.testDigitalSignatureSignatoryQuote;

		testDataFactory.testMerchantOnboardingOpportunity.Accountid = testDataFactory.testProspectAccount.id;
		update testDataFactory.testMerchantOnboardingOpportunity;
		List<Map<String, Object>> zz = DocumentsShareControllerESign.getSignatoriesData(testDataFactory.testQuoteDocument.id);
		Contact c = [Select id
		             from Contact
		             where RecordType.DeveloperName = 'Contact'
		             LIMIT 1];
		c.AccountId = testDataFactory.testBizAccount.id;
		update c;

		Account ac = [Select Id, Client_Type__c
		              from Account
		              where Id = :testDataFactory.testMerchantOnboardingOpportunity.Accountid];
		ac.Client_Type__c = 'Sole Trader';
		update ac;

		Id testProspectAccountContactId = [Select Id, PersonContactId
		                                   FROM Account
		                                   WHERE Id = :testDataFactory.testBizAccount.Id].PersonContactId;

		Signatory_Party_Overide__c spo2 = new Signatory_Party_Overide__c(Opportunity__c = testDataFactory.testMerchantOnboardingOpportunity.id, Preferred_Email__c = 'test@12.com', Preferred_Method__c = 'Realtime', Preferred_Mobile__c = '0989876543', Signatory_Party__c = testDataFactory.testAccountContactRelation.id);
		insert spo2;

		testDataFactory.testQuoteDocument.Opportunity__c = testDataFactory.testMerchantOnboardingOpportunity.Id;
		update testDataFactory.testQuoteDocument;

		List<Map<String, Object>> lll = DocumentsShareControllerESign.getSignatoriesData(testDataFactory.testQuoteDocument.id);

		system.assertNotEquals(null, lll.size());
		test.stopTest();
	}

	@isTest
	public static void getSignatoriesDataAuthSignatory(){
		WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
		test.startTest();

		testDataFactory.testDigitalSignatureSignatoryQuote.Signatory_Type__c = 'Authorised Signatory';
		testDataFactory.testDigitalSignatureSignatoryQuote.Opportunity_Record_Types_Applicable_To__c = 'General;Merchant Onboarding;Product Onboarding';
		update testDataFactory.testDigitalSignatureSignatoryQuote;
		List<Map<String, Object>> xxx = DocumentsShareControllerESign.getSignatoriesData(testDataFactory.testQuoteDocument.id);
		Contact c = [Select id
		             from Contact
		             where RecordType.DeveloperName = 'Contact'
		             LIMIT 1];
		c.AccountId = testDataFactory.testBizAccount.id;
		update c;

		Id testProspectAccountContactId = [Select Id, PersonContactId
		                                   FROM Account
		                                   WHERE Id = :testDataFactory.testProspectAccount.Id].PersonContactId;

		Signatory_Party_Overide__c spo2 = new Signatory_Party_Overide__c(Opportunity__c = testDataFactory.testMerchantOnboardingOpportunity.id, Preferred_Email__c = 'test@12.com', Preferred_Method__c = 'Realtime', Preferred_Mobile__c = '0989876543', Signatory_Party__c = testDataFactory.testAccountContactRelation.id);
		insert spo2;
		system.debug('testDataFactory.testAccountContactRelation.id ' + testDataFactory.testAccountContactRelation.id);

		testDataFactory.testMerchantOnboardingOpportunity.accountid = testDataFactory.testBizAccount.id;
		update testDataFactory.testMerchantOnboardingOpportunity;

		testDataFactory.testQuoteDocument.Opportunity__c = testDataFactory.testMerchantOnboardingOpportunity.id;
		update testDataFactory.testQuoteDocument;

		update testDataFactory.testDigitalSignatureSignatoryQuote;
		List<Map<String, Object>> lll = DocumentsShareControllerESign.getSignatoriesData(testDataFactory.testQuoteDocument.id);
		system.assertNotEquals(null, lll.size());
		test.stopTest();
	}

	@isTest
	public static void getSignatoriesDataRelatedSignatory(){
		WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
		test.startTest();


		Account account = new Account(Name = 'Test Account');
		account.RecordTypeId = schema.SObjectType.account.getRecordTypeInfosByName().get('Business Prospect').getRecordTypeId();
		account.Country_of_Incorporation__c = 'South Africa';
		account.Client_Group__c = 'Sole Trader Client';
		account.Client_Type__c = 'Sole Trader';
		account.CASA_Reference_Number__c = '12233';
		account.CASA_Screening_Status__c = 'Cancelled';
		account.CIF__c = '';
		account.Countries_Traded_With__c = 'South Africa';
		account.Source_of_Income__c = 'Donation';
		insert account;

		//insert related acct;
		List<AccountContactRelation> acrList = new List<AccountContactRelation>();
		List<Id> acrIds = new List<Id>();
		Account acctSecondary = new Account();
		acctSecondary.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual Prospect').getRecordTypeId();
		acctSecondary.ID_Number__pc = '6803037015089';
		acctSecondary.ID_Type__pc = 'SA Identity Document';
		acctSecondary.FirstName = 'First Name';
		acctSecondary.LastName = 'Test Last Name';
		acctSecondary.Initials__pc = 'I';
		acctSecondary.PersonTitle = 'Mr';
		acctSecondary.Client_Type__c = 'Individual Client';
		acctSecondary.CASA_Reference_Number__pc = '12454';
		acctSecondary.CASA_Screening_Status__pc = 'Matched';
		insert acctSecondary;
		Account acc = [SELECT PersonContactId
		               FROM Account
		               WHERE Id = :acctSecondary.Id];
		Id personContactId = acc.PersonContactId;
		AccountContactRelation accConRel = new AccountContactRelation(AccountId = account.Id, ContactId = personContactId);
		accConRel.roles = 'Individual with Authority to Act';
		accConRel.Designation__c = 'Manager';
		insert accConRel;
		acrIds.add(accConRel.Id);
		acrList.add(accConRel);
        
		testDataFactory.testMerchantOnboardingOpportunity.AccountId = account.id;
		update testDataFactory.testMerchantOnboardingOpportunity;


		Product2 prod = new Product2(Name = 'Cheque Product', Family = 'Cheque', ProductCode = '1234');

		insert prod;

		System.debug('prod' + prod.Id);

		Pricebook2 standardPriceBook = WillsTestDataFactory.getStandardPriceBook();
		PricebookEntry pricebookEntry = WillsTestDataFactory.createPriceBookEntry(standardPriceBook.Id, prod.Id);

		OpportunityLineItem oli = new OpportunityLineItem();
		oli.OpportunityId = testDataFactory.testMerchantOnboardingOpportunity.Id;
		if (prod.Id != null){
			oli.Product2Id = prod.Id;
		}
		oli.PriceBookEntryid = pricebookEntry.Id;
		oli.Quantity = 1;
		oli.TotalPrice = 100;
		insert oli;

		Document__c testDocument = new Document__c();
		testDocument.Name = 'ABSA 3741 - Client Engagement';
		testDocument.Type__c = 'ABSA 3741 - Client Engagement';
		testDocument.Opportunity__c = testDataFactory.testMerchantOnboardingOpportunity.id;
		//testDocument.Contact__c = testContact.id;
		testDocument.Reference__c = '82 3 ICM7 UGOLSDB4 Will59 26 A1001001A19F14B41357J5034318 A19F14B41357J503431 14 2364';

		insert testDocument;

		/* testDataFactory.testQuoteDocument.Opportunity__c = testDataFactory.testMerchantOnboardingOpportunity.id;
		 update testDataFactory.testQuoteDocument;*/

		Digital_Signature_Admin__c testDigitalSignatureAdmin1 = new Digital_Signature_Admin__c();
		testDigitalSignatureAdmin1.Document_Type__c = 'ABSA 3741 - Client Engagement';
		testDigitalSignatureAdmin1.Number_of_Required_Signatories__c = 1;
		testDigitalSignatureAdmin1.Expiry_Unit__c = 'Day';
		testDigitalSignatureAdmin1.Expiry_Period__c = 1;

		insert testDigitalSignatureAdmin1;

		//Test Digital_Signature_Signatory__c
		Digital_Signature_Signatory__c testDigitalSignatureSignatoryQuote1 = new Digital_Signature_Signatory__c();
		testDigitalSignatureSignatoryQuote1.Digital_Signature_Admin__c = testDigitalSignatureAdmin1.Id;
		testDigitalSignatureSignatoryQuote1.Preferred_Method__c = 'Realtime';
		testDigitalSignatureSignatoryQuote1.Signatory_Type__c = 'Related Party Signatory';
		testDigitalSignatureSignatoryQuote1.Opportunity_Record_Types_Applicable_To__c = 'General;Merchant Onboarding;Product Onboarding';
		testDigitalSignatureSignatoryQuote1.Signatory_Required__c = true;

		insert testDigitalSignatureSignatoryQuote1;
		// test digital signatory role
		Digital_Signatory_Role__c dsr = new Digital_Signatory_Role__c();
		dsr.Client_Type__c = 'Sole Trader';
		dsr.Roles__c = 'Individual with Authority to Act';
		dsr.Designation__c = 'Manager';
		dsr.Digital_Signature_Signatory__c = testDigitalSignatureSignatoryQuote1.Id;
		insert dsr;

		Digital_Signatory_Role__c dsr1 = new Digital_Signatory_Role__c();
		dsr1.Client_Type__c = 'Private Individual';
		dsr1.Roles__c = 'Operators on primary accounts ( Internet Main Users, Signatories, Card Users)';

		dsr1.Digital_Signature_Signatory__c = testDigitalSignatureSignatoryQuote1.Id;
		insert dsr1;

		Digital_Signatory_Role__c dsr2 = new Digital_Signatory_Role__c();
		dsr2.Client_Type__c = 'Private Company';
		dsr2.Roles__c = 'Chief Executive Officer;Director;Individual with Authority to Act;Managing Director';
		dsr2.Designation__c = 'Chairman;Chairperson;Director;Liquidator';
		dsr2.Digital_Signature_Signatory__c = testDigitalSignatureSignatoryQuote1.Id;
		insert dsr2;

		testDigitalSignatureSignatoryQuote1.Signatory_Type__c = 'Related Party Signatory';

		update testDigitalSignatureSignatoryQuote1;

		Contact c = [Select id
		             from Contact
		             where RecordType.DeveloperName = 'Contact'
		             LIMIT 1];
		c.AccountId = account.id;
		update c;
		Account ac = [Select Id, Client_Type__c
		              from Account
		              where Id = :testDataFactory.testMerchantOnboardingOpportunity.Accountid];
		ac.Client_Type__c = 'Sole Trader';
		update ac;

		Id testProspectAccountContactId = [Select Id, PersonContactId
		                                   FROM Account
		                                   WHERE Id = :account.id].PersonContactId;

		Signatory_Party_Overide__c spo2 = new Signatory_Party_Overide__c(Opportunity__c = testDataFactory.testMerchantOnboardingOpportunity.id, Preferred_Email__c = 'test@12.com', Preferred_Method__c = 'Realtime', Preferred_Mobile__c = '0989876543', Signatory_Party__c = testProspectAccountContactId);
		spo2.Signatory_Party__c = c.id;
		insert spo2;

		testDocument.Opportunity__c = testDataFactory.testMerchantOnboardingOpportunity.id;
		update testDocument;
		List<Map<String, Object>> lll = DocumentsShareControllerESign.getSignatoriesData(testDocument.id);
		system.assertNotEquals(null, lll.size());
		test.stopTest();
	}

	@isTest
	public static void getSignatoriesDataRelatedSignatoryNonSoleTrader(){
		WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
		test.startTest();

		Account account = new Account(Name = 'Test Account');
		account.RecordTypeId = schema.SObjectType.account.getRecordTypeInfosByName().get('Business Prospect').getRecordTypeId();
		account.Country_of_Incorporation__c = 'South Africa';
		account.Client_Group__c = 'Non Individual';
		account.Client_Type__c = 'Private Company';
		account.CASA_Reference_Number__c = '12233';
		account.CASA_Screening_Status__c = 'Cancelled';
		account.CIF__c = '';
		account.Countries_Traded_With__c = 'South Africa';
		account.Source_of_Income__c = 'Donation';
		insert account;

		//insert related acct;
		List<AccountContactRelation> acrList = new List<AccountContactRelation>();
		List<Id> acrIds = new List<Id>();
		Account acctSecondary = new Account();
		acctSecondary.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual Prospect').getRecordTypeId();
		acctSecondary.ID_Number__pc = '6803037015089';
		acctSecondary.ID_Type__pc = 'SA Identity Document';
		acctSecondary.FirstName = 'First Name';
		acctSecondary.LastName = 'Test Last Name';
		acctSecondary.Initials__pc = 'I';
		acctSecondary.PersonTitle = 'Mr';
		acctSecondary.Client_Type__c = 'Individual Client';
		acctSecondary.CASA_Reference_Number__pc = '12454';
		acctSecondary.CASA_Screening_Status__pc = 'Matched';
		insert acctSecondary;
		Account acc = [SELECT PersonContactId
		               FROM Account
		               WHERE Id = :acctSecondary.Id];
		Id personContactId = acc.PersonContactId;
		AccountContactRelation accConRel = new AccountContactRelation(AccountId = account.Id, ContactId = personContactId);
		accConRel.roles = 'Chief Executive Officer;Director;Individual with Authority to Act;Managing Director';
		accConRel.Designation__c = 'Director';

		insert accConRel;
		acrIds.add(accConRel.Id);
		acrList.add(accConRel);

		testDataFactory.testMerchantOnboardingOpportunity.AccountId = account.id;
		update testDataFactory.testMerchantOnboardingOpportunity;

		Product2 prod = new Product2(Name = 'Cheque Product', Family = 'Cheque', ProductCode = '1234');

		insert prod;

		System.debug('prod' + prod.Id);

		Pricebook2 standardPriceBook = WillsTestDataFactory.getStandardPriceBook();
		PricebookEntry pricebookEntry = WillsTestDataFactory.createPriceBookEntry(standardPriceBook.Id, prod.Id);

		OpportunityLineItem oli = new OpportunityLineItem();
		oli.OpportunityId = testDataFactory.testMerchantOnboardingOpportunity.Id;
		if (prod.Id != null){
			oli.Product2Id = prod.Id;
		}
		oli.PriceBookEntryid = pricebookEntry.Id;
		oli.Quantity = 1;
		oli.TotalPrice = 100;
		insert oli;

		Document__c testDocument = new Document__c();
		testDocument.Name = 'ABSA 3741 - Client Engagement';
		testDocument.Type__c = 'ABSA 3741 - Client Engagement';
		testDocument.Opportunity__c = testDataFactory.testMerchantOnboardingOpportunity.id;
		testDocument.Reference__c = '82 3 ICM7 UGOLSDB4 Will59 26 A1001001A19F14B41357J5034318 A19F14B41357J503431 14 2364';

		insert testDocument;

		Digital_Signature_Admin__c testDigitalSignatureAdmin1 = new Digital_Signature_Admin__c();
		testDigitalSignatureAdmin1.Document_Type__c = 'ABSA 3741 - Client Engagement';
		testDigitalSignatureAdmin1.Number_of_Required_Signatories__c = 1;
		testDigitalSignatureAdmin1.Expiry_Unit__c = 'Day';
		testDigitalSignatureAdmin1.Expiry_Period__c = 1;

		insert testDigitalSignatureAdmin1;

		//Test Digital_Signature_Signatory__c
		Digital_Signature_Signatory__c testDigitalSignatureSignatoryQuote1 = new Digital_Signature_Signatory__c();
		testDigitalSignatureSignatoryQuote1.Digital_Signature_Admin__c = testDigitalSignatureAdmin1.Id;
		testDigitalSignatureSignatoryQuote1.Preferred_Method__c = 'Realtime';
		testDigitalSignatureSignatoryQuote1.Signatory_Type__c = 'Related Party Signatory';
		testDigitalSignatureSignatoryQuote1.Opportunity_Record_Types_Applicable_To__c = 'General;Merchant Onboarding;Product Onboarding';
		testDigitalSignatureSignatoryQuote1.Signatory_Required__c = true;

		insert testDigitalSignatureSignatoryQuote1;
		// test digital signatory role
		Digital_Signatory_Role__c dsr = new Digital_Signatory_Role__c();
		dsr.Client_Type__c = 'Sole Trader';
		dsr.Roles__c = 'Individual with Authority to Act';
		dsr.Designation__c = 'Manager';
		dsr.Digital_Signature_Signatory__c = testDigitalSignatureSignatoryQuote1.Id;
		insert dsr;

		Digital_Signatory_Role__c dsr1 = new Digital_Signatory_Role__c();
		dsr1.Client_Type__c = 'Private Individual';
		dsr1.Roles__c = 'Operators on primary accounts ( Internet Main Users, Signatories, Card Users)';

		dsr1.Digital_Signature_Signatory__c = testDigitalSignatureSignatoryQuote1.Id;
		insert dsr1;

		Digital_Signatory_Role__c dsr2 = new Digital_Signatory_Role__c();
		dsr2.Client_Type__c = 'Private Company';
		dsr2.Roles__c = 'Chief Executive Officer;Director;Individual with Authority to Act;Managing Director';
		dsr2.Designation__c = 'Chairman;Chairperson;Director;Liquidator';
		dsr2.Digital_Signature_Signatory__c = testDigitalSignatureSignatoryQuote1.Id;
		insert dsr2;

		testDigitalSignatureSignatoryQuote1.Signatory_Type__c = 'Related Party Signatory';

		update testDigitalSignatureSignatoryQuote1;

		Contact c = [Select id
		             from Contact
		             where RecordType.DeveloperName = 'Contact'
		             LIMIT 1];

		Account ac = [Select Id, Client_Type__c
		              from Account
		              where Id = :testDataFactory.testMerchantOnboardingOpportunity.Accountid];
		ac.Client_Type__c = 'Private Company';
		update ac;

		Id testProspectAccountContactId = [Select Id, PersonContactId
		                                   FROM Account
		                                   WHERE Id = :testDataFactory.testProspectAccount.Id].PersonContactId;

		Signatory_Party_Overide__c spo2 = new Signatory_Party_Overide__c(Opportunity__c = testDataFactory.testMerchantOnboardingOpportunity.id, Preferred_Email__c = 'test@12.com', Preferred_Method__c = 'Realtime', Preferred_Mobile__c = '0989876543', Signatory_Party__c = testProspectAccountContactId);
		spo2.Signatory_Party__c = c.id;
		insert spo2;

		testDocument.Opportunity__c = testDataFactory.testMerchantOnboardingOpportunity.id;
		update testDocument;
		List<Map<String, Object>> lll = DocumentsShareControllerESign.getSignatoriesData(testDocument.id);
		system.assertNotEquals(null, lll.size());
		test.stopTest();
	}

	@isTest
	public static void getSignatoriesDataSelected(){
		Account account = new Account(Name = 'Test Account');
		account.RecordTypeId = schema.SObjectType.account.getRecordTypeInfosByName().get('Business Prospect').getRecordTypeId();
		//W-005355 : Anka Ganta : 2020-07-09
		account.Country_of_Incorporation__c = 'South Africa';
		account.Client_Group__c = 'Non Individual';
		account.CASA_Reference_Number__c = '12233';
		account.CASA_Screening_Status__c = 'Cancelled';
		account.CIF__c = '';
		account.Countries_Traded_With__c = 'South Africa';
		account.Source_of_Income__c = 'Donation';
		insert account;

		//insert related acct;
		List<AccountContactRelation> acrList = new List<AccountContactRelation>();
		List<Id> acrIds = new List<Id>();
		Account acctSecondary = new Account();
		acctSecondary.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual Prospect').getRecordTypeId();
		acctSecondary.ID_Number__pc = '6803037015089';
		acctSecondary.ID_Type__pc = 'SA Identity Document';
		acctSecondary.FirstName = 'First Name';
		acctSecondary.LastName = 'Test Last Name';
		acctSecondary.Initials__pc = 'I';
		acctSecondary.PersonTitle = 'Mr';
		acctSecondary.Client_Type__c = 'Individual Client';
		acctSecondary.CASA_Reference_Number__pc = '12454';
		acctSecondary.CASA_Screening_Status__pc = 'Matched';
		insert acctSecondary;
		Account acc = [SELECT PersonContactId
		               FROM Account
		               WHERE Id = :acctSecondary.Id];
		Id personContactId = acc.PersonContactId;
		AccountContactRelation accConRel = new AccountContactRelation(AccountId = account.Id, ContactId = personContactId);
		insert accConRel;
		acrIds.add(accConRel.Id);
		acrList.add(accConRel);

		System.debug('** acrList: ' + acrList.size());
		WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
		test.startTest();

		testDataFactory.testQuoteDocument.Opportunity__c = testDataFactory.testMerchantOnboardingOpportunity.id;
		update testDataFactory.testQuoteDocument;
		DocumentsShareControllerESign.getSignatoriesDataSelected(testDataFactory.testQuoteDocument.id, acrIds);

		testDataFactory.testDigitalSignatureSignatoryQuote.Signatory_Type__c = 'Parent Owner';
		update testDataFactory.testDigitalSignatureSignatoryQuote;

		DocumentsShareControllerESign.getSignatoriesDataSelected(testDataFactory.testQuoteDocument.id, acrIds);
		testDataFactory.testDigitalSignatureSignatoryQuote.Signatory_Type__c = 'Authorised Signatory';
		update testDataFactory.testDigitalSignatureSignatoryQuote;
		DocumentsShareControllerESign.getSignatoriesDataSelected(testDataFactory.testQuoteDocument.id, acrIds);

		DocumentsShareControllerESign.getSignatoriesDataSelected(testDataFactory.testQuoteDocument.id, acrIds);
		testDataFactory.testDigitalSignatureSignatoryQuote.Signatory_Type__c = 'Related Party Signatory';
		update testDataFactory.testDigitalSignatureSignatoryQuote;
		DocumentsShareControllerESign.getSignatoriesDataSelected(testDataFactory.testQuoteDocument.id, acrIds);

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
		testDataFactory.testDigitalSignatureSignatoryQuote.Signatory_Type__c = 'Parent Customer';
		update testDataFactory.testDigitalSignatureSignatoryQuote;
		DocumentsShareControllerESign.getSignatoriesDataSelected(testDataFactory.testQuoteDocument.id, acrIds);
		testDataFactory.testMerchantOnboardingOpportunity.accountid = testDataFactory.testBizAccount.id;
		update testDataFactory.testMerchantOnboardingOpportunity;
		spo2.Opportunity__c = testDataFactory.testMerchantOnboardingOpportunity.id;
		spo2.Signatory_Party__c = c.id;
		update spo2;

		testDataFactory.testDigitalSignatureSignatoryQuote.Signatory_Type__c = 'Parent Owner';
		update testDataFactory.testDigitalSignatureSignatoryQuote;
		DocumentsShareControllerESign.getSignatoriesDataSelected(testDataFactory.testQuoteDocument.id, acrIds);
		testDataFactory.testDigitalSignatureSignatoryQuote.Signatory_Type__c = 'Authorised Signatory';
		update testDataFactory.testDigitalSignatureSignatoryQuote;

		List<Map<String, Object>> ll = DocumentsShareControllerESign.getSignatoriesDataSelected(testDataFactory.testQuoteDocument.id, acrIds);

		testDataFactory.testDigitalSignatureSignatoryQuote.Signatory_Type__c = 'Related Party Signatory';
		update testDataFactory.testDigitalSignatureSignatoryQuote;
		List<Map<String, Object>> lll = DocumentsShareControllerESign.getSignatoriesDataSelected(testDataFactory.testQuoteDocument.id, acrIds);

		List<String> mobileList = DocumentsShareControllerESign.getMobile(testDataFactory.testMerchantOnboardingOpportunity.id);
		List<String> emailsList = DocumentsShareControllerESign.getAllClientEmails(testDataFactory.testMerchantOnboardingOpportunity.id);
		List<String> sigList = DocumentsShareControllerESign.getAllClientEmailsSignature(testDataFactory.testMerchantOnboardingOpportunity.id);

		system.assertNotEquals(null, mobileList.size());
		system.assertNotEquals(null, emailsList.size());
		system.assertNotEquals(null, sigList.size());
		test.stopTest();
	}

	@isTest
	public static void getDocumentAudit(){
		WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
		List<Document_Audit__c> documentAudits = DocumentsShareControllerESign.getDocumentAudit(testDataFactory.testOpportunity.id);
		system.assertNotEquals(null, documentAudits.size());
	}

	@isTest
	public static void fetchImpressionRequest(){
		WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
		List<ImpressionRequest__c> impressionRequests = DocumentsShareControllerESign.fetchImpressionRequest(testDataFactory.testOpportunity.id);
		system.assertNotEquals(null, impressionRequests.size());
	}

	@isTest
	public static void createDocumentSharingAudit(){
		WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
		DocumentsShareControllerESign.createDocumentSharingAudit(testDataFactory.testOpportunity.id, testDataFactory.testDocument.id, 'Download', 'vladimir.panajic@absa.co.za');
		List<Document_Audit__c> dcaList = [Select id
		                                   from Document_Audit__c
		                                   where Opportunity__c = :testDataFactory.testOpportunity.id];
		system.assertNotEquals(null, dcaList.size());
	}

	@IsTest
	private	static void testGetDocumentsContent(){
		WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
		Document__c d = new Document__c();
		d.Name = 'aa';
		d.Type__c = 'ABSA 6280 - Tax Self- Certification and Declaration';
		d.Opportunity__c = testDataFactory.testOpportunity.id;
		d.Reference__c = '92 3 ICM7 UGOLSDB13 Ent_Quotation59 26 A1001001A20F08C10108B0752518 A20F08C10108B075251 14 1868';
		insert d;
		ECM_IH_V1Test.insertSettings();
		String body = '{"LoginResult" : {"Status" : "OK", "Details" : "null"}, "Token" : "1234567890"}';
		Test.setMock(HttpCalloutMock.class, new ECM_Mock_ApiRest(body));

		Test.startTest();
		string ss = DocumentsShareControllerESign.getDocumentContent(testDataFactory.testOpportunity.id, d.id,'Email', 'test@gmail.com');
		system.assert(ss != null, 'getDocumentContent');
		Test.stopTest();
	}

	@isTest
	public static void fetchAdviserName(){
		string advisor = DocumentsShareControllerESign.fetchAdviserName();
		System.assertNotEquals(null, advisor);
		DocumentsShareControllerESign.dummyRefresh();
	}

	@isTest
	public static void getDocumentsContent(){
		WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
		Set<Id> idSet = new Set<Id>();
		idSet.add(testDataFactory.testDocument.id);
		String idListJSON = JSON.serialize(idSet);
		System.assertNotEquals(null, idListJSON);
		ECM_IH_V1Test.insertSettings();
		DocumentsShareControllerESign.getDocumentsContent(idListJSON);
	}

	@isTest
	public static void sendDocumentSharingEmail(){
		WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
		Set<Id> idSet = new Set<Id>();
		idSet.add(testDataFactory.testDocument.id);
		String idListJSON = JSON.serialize(idSet);
		System.assertNotEquals(null, idListJSON);
		ECM_IH_V1Test.insertSettings();
		Application__c applicationRecord = [SELECT Id, Name
		                                    FROM Application__c
		                                    LIMIT 1];

		applicationRecord.Opportunity__c = testDataFactory.testMerchantOnboardingOpportunity.id;
		update applicationRecord;
		//Id recordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName =: 'Merchant_Onboarding'].Id;
		DocumentsShareControllerESign.sendDocumentSharingEmail(testDataFactory.testMerchantOnboardingOpportunity.id, 'anka.gantac@absa.co.za', idListJSON);
	}

	@isTest
	public static void sendDocumentSharingEmailAlt(){
		WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
		Set<Id> idSet = new Set<Id>();
		idSet.add(testDataFactory.testDocument.id);
		String idListJSON = JSON.serialize(idSet);
		System.assertNotEquals(null, idListJSON);
		ECM_IH_V1Test.insertSettings();
		DocumentsShareControllerESign.sendDocumentSharingEmail(testDataFactory.willOpportunity.id, 'anka.gantac@absa.co.za', idListJSON);
	}

	/*
	 static testMethod void getSigntoriesData() {
	 WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
	 DocumentsShareControllerESign.getSigntoriesData(testDataFactory.testDocument.id);
	 }*/
	@isTest
	public static void sendForImpressionSignature(){
		test.startTest();
		WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
		String sigs = '[{"Id":"' + testDataFactory.testAccount.id + '","Title":"Mr.","Last_Name":"PAULA VENTER","Mobile_Phone":"+27833826456","Email":"tinashem@yahoo.com","Method":"Realtime","Role":"Client","Document_Name":"mu.pdf","Document_Type":"Quote"}]';
		string sendForSig = DocumentsShareControllerESign.sendForImpressionSignature(testDataFactory.testDocument.id, sigs);//signatories
		system.assertNotEquals(null, sendForSig);
		test.stopTest();
	}

	@isTest
	public static void getAllClientEmails(){
		WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
		List<String> emailsList = DocumentsShareControllerESign.getAllClientEmails(testDataFactory.testOpportunity.id);
		system.assertNotEquals(null, emailsList.size());
	}

	@isTest
	public static void getAllClientEmailsSignature(){
		WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
		List<String> sigList = DocumentsShareControllerESign.getAllClientEmails(testDataFactory.testOpportunity.id);
		system.assertNotEquals(null, sigList.size());
	}

	@isTest
	public static void getMobile(){
		WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
		List<String> mobileList = DocumentsShareControllerESign.getMobile(testDataFactory.testOpportunity.id);
		system.assertNotEquals(null, mobileList.size());
	}

	@isTest
	public static void getDigitalSignatorySelectOptions(){
		List<String> sel = DocumentsShareControllerESign.getDigitalSignatorySelectOptions('Preferred_Method__c');
		system.assertNotEquals(null, sel);
	}

	@isTest
	public static void getUpdatedSignatoriesData(){
		test.startTest();
		WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
		Id testProspectAccountContactId = [Select Id, PersonContactId
		                                   FROM Account
		                                   WHERE Id = :testDataFactory.testProspectAccount.Id].PersonContactId;
		Contact c = [Select id
		             from Contact
		             where RecordType.DeveloperName = 'Contact'
		             LIMIT 1];
		c.AccountId = testDataFactory.testBizAccount.id;
		update c;
		Signatory_Party_Overide__c spo2 = new Signatory_Party_Overide__c(Opportunity__c = testDataFactory.testOpportunity.id, Preferred_Email__c = 'test@12.com', Preferred_Method__c = 'Realtime', Preferred_Mobile__c = '0989876543', Signatory_Party__c = testProspectAccountContactId);
		insert spo2;

		String sigs = '[{"Id":"' + testDataFactory.testAccount.id + '","Title":"Mr.","Last_Name":"PAULA VENTER","Mobile_Phone":"+27833826456","Email":"tinashem@yahoo.com","Method":"Realtime","Role":"Client","Document_Name":"mu.pdf","Document_Type":"Quote"}]';
		List<Map<String, Object>> getUpdSigdata = DocumentsShareControllerESign.getUpdatedSignatoriesData(testDataFactory.testOpportunity.id, testDataFactory.testDocument.id, spo2.id, sigs, 'Realtime', '0988765432', 'test@123.com');
		system.assertNotEquals(null, getUpdSigdata);
		test.stopTest();
	}

	@isTest
	public static void signatoriesOverride(){
		test.startTest();
		WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
		Id testProspectAccountContactId = [Select Id, PersonContactId
		                                   FROM Account
		                                   WHERE Id = :testDataFactory.testProspectAccount.Id].PersonContactId;
		Contact c = [Select id
		             from Contact
		             where RecordType.DeveloperName = 'Contact'
		             LIMIT 1];
		c.AccountId = testDataFactory.testBizAccount.id;
		update c;
		Signatory_Party_Overide__c spo2 = new Signatory_Party_Overide__c(Opportunity__c = testDataFactory.testOpportunity.id, Preferred_Email__c = 'test@12.com', Preferred_Method__c = 'Realtime', Preferred_Mobile__c = '0989876543', Signatory_Party__c = testDataFactory.testAccountContactRelation.id);
		insert spo2;

		Document__c d = new Document__c();
		d.Name = 'aa';
		d.Type__c = 'ABSA 6280 - Tax Self- Certification and Declaration';
		d.Opportunity__c = testDataFactory.testOpportunity.id;
		d.Reference__c = '92 3 ICM7 UGOLSDB13 Ent_Quotation59 26 A1001001A20F08C10108B0752518 A20F08C10108B075251 14 1868';
		insert d;

		String sigs = '[{"Id":"' + testDataFactory.testAccount.id + '","Title":"Mr.","Last_Name":"PAULA VENTER","Mobile_Phone":"+27833826456","Email":"tinashem@yahoo.com","Method":"Realtime","Role":"Client","Document_Name":"mu.pdf","Document_Type":"Quote"}]';
		List<Map<String, Object>> getUpdSigdata = DocumentsShareControllerESign.getSignatoriesData(d.id);
		system.assertEquals(null, getUpdSigdata);
		test.stopTest();
	}

	@isTest
	public static void getUpdatedSignatoriesDataSelected(){
		test.startTest();
		WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
		Id testProspectAccountContactId = [Select Id, PersonContactId
		                                   FROM Account
		                                   WHERE Id = :testDataFactory.testProspectAccount.Id].PersonContactId;
		Contact c = [Select id
		             from Contact
		             where RecordType.DeveloperName = 'Contact'
		             LIMIT 1];
		c.AccountId = testDataFactory.testBizAccount.id;
		update c;
		Signatory_Party_Overide__c spo2 = new Signatory_Party_Overide__c(Opportunity__c = testDataFactory.testOpportunity.id, Preferred_Email__c = 'test@12.com', Preferred_Method__c = 'Realtime', Preferred_Mobile__c = '0989876543', Signatory_Party__c = testDataFactory.testAccountContactRelation.id);
		insert spo2;

		String sigs = '[{"Id":"' + testDataFactory.testAccount.id + '","Title":"Mr.","Last_Name":"PAULA VENTER","Mobile_Phone":"+27833826456","Email":"tinashem@yahoo.com","Method":"Realtime","Role":"Client","Document_Name":"mu.pdf","Document_Type":"Quote"}]';
		List<Map<String, Object>> getUpdSigdata = DocumentsShareControllerESign.getUpdatedSignatoriesDataSelected(testDataFactory.testOpportunity.id, testDataFactory.testDocument.id, spo2.id, sigs, 'Realtime', '0988765432', 'test@123.com', '1');
		system.assertNotEquals(null, getUpdSigdata);
		test.stopTest();
	}

	@isTest
	public static void testCheckCASAValidity(){
		WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
		Test.startTest();
		String CasaStatus = DocumentsShareControllerESign.checkCASAValidity(testDataFactory.testOpportunity.Id);
		system.assertNotEquals(null, CasaStatus);
		Test.stopTest();
	}

	@isTest
	public static void testGetUserRoleAdviser(){
		WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
		Test.startTest();
		String CasaStatus = DocumentsShareControllerESign.getUserRole(testDataFactory.testOpportunity.Id);
		system.assertNotEquals(null, CasaStatus);
		Test.stopTest();
	}

	@isTest
	public static void testGetUserRoleNoAccess(){
		WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
		testDataFactory.testOpportunity.OwnerId = testDataFactory.testUserSupervisor.Advisor__c;
		update testDataFactory.testOpportunity;

		Test.startTest();
		String CasaStatus = DocumentsShareControllerESign.getUserRole(testDataFactory.testOpportunity.Id);
		system.assertNotEquals(null, CasaStatus);
		Test.stopTest();
	}

	@isTest
	public static void testfetchOppOwnerName(){
		WimiTestDataFactory testDataFactory = new WimiTestDataFactory();

		Test.startTest();
		String CasaStatus = DocumentsShareControllerESign.fetchOppOwnerName(testDataFactory.testOpportunity.Id);
		system.assertNotEquals(null, CasaStatus);
		Test.stopTest();
	}

	@isTest
	public static void testGetDocumentAuditEmail(){
		WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
		testDataFactory.testOpportunity.OwnerId = testDataFactory.testUserSupervisor.Advisor__c;
		update testDataFactory.testOpportunity;

		Test.startTest();
		List<Task> TaskList = DocumentsShareControllerESign.getDocumentAuditEmail(testDataFactory.testOpportunity.Id);
		system.assertNotEquals(null, TaskList.size());
		Test.stopTest();
	}

	@isTest
	public static void testGetEmailDocuments(){
		WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
		Task task = new Task();
		task.Subject = 'Test Task';
		Insert task;

		Test.startTest();
		List<Email_Document__c> EmailDocumentList = DocumentsShareControllerESign.getEmailDocuments(task.Id);
		system.assertNotEquals(null, EmailDocumentList.size());
		Test.stopTest();
	}

	@isTest
	public static void testGetOpportunityIdFromTask(){
		WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
		Task task = new Task();
		task.Subject = 'Test Task';
		task.WhatId = testDataFactory.testOpportunity.Id;
		Insert task;

		Test.startTest();
		system.assertNotEquals(null, DocumentsShareControllerESign.getOpportunityIdFromTask(task.Id));
		Test.stopTest();
	}

	/**
	 * @description ECM_Mock_ApiRest Description
	 *
	 */
	public class ECM_Mock_ApiRest implements HttpCalloutMock{
		/**
		 * @description body
		 */
		public String body{ get; set; }

		/**
		 * @description ECM_Mock_ApiRest description
		 *
		 */
		public ECM_Mock_ApiRest(){
		}

		/**
		 * @description ECM_Mock_ApiRest description
		 *
		 * @param body (String): body
		 */
		public ECM_Mock_ApiRest(String body){
			this.body = body;
		}

		/**
		 * @description respond description
		 *
		 * @param request (HTTPRequest): request
		 * @return HTTPResponse: Return description
		 */
		public HTTPResponse respond(HTTPRequest request){
			HTTPResponse response = new HTTPResponse();
			response.setStatusCode(200);
			response.setBody(body);
			response.setHeader('Content-Type', 'application/json');
			return response;
		}
	}

	////Start changes for W-005270
	@isTest
	public static void testgetmandatorydocs(){
		string Entitytype = 'aa';
		Mandatory_Doc__mdt md1 = new Mandatory_Doc__mdt();
		md1.Entity_Type__c = 'Sole Trader';
		md1.ECM_Type__c = 'Ent_Declaration';
		//return md1;
		Mandatory_Doc__mdt md2 = new Mandatory_Doc__mdt();
		md1.Entity_Type__c = 'aa';
		md1.ECM_Type__c = 'bb';
		//md2.Type__c='bb';
		//return md2;

		//Opportunity opp=[select id,CheckMandatoryDocuments__c,StageName,Entity_Type__c from opportunity limit 1 ];
		Account testAccount = new Account();
		testAccount.Name = 'Test Name';
		testAccount.Country_of_Registration__c = 'South Africa';
		testAccount.Client_Group__c = 'Non Individual';
		testAccount.Client_Type__c = 'Sole Trader';
		testAccount.CASA_Reference_Number__c = '12233';
		testAccount.CIF__c = '';
		testAccount.Countries_Traded_With__c = 'South Africa';
		testAccount.Country_of_Registration__c = 'South Africa';
		testAccount.Source_of_Income__c = 'Donation';
		insert testAccount;
		Opportunity testOpp = new Opportunity();
		testOpp.Name = 'Test Opp';
		testOpp.CloseDate = Date.today();

		testOpp.StageName = 'Drafting';
		testOpp.accountId = testAccount.Id;
		insert testOpp;
		Document_Template__c d1 = new Document_Template__c();
		d1.Name = 'ABSA 6280 - Tax Self- Certification and Declaration';
		d1.ECM_Item_Type__c = 'Ent_Declaration';
		insert d1;
		Document__c d = new Document__c();
		d.Name = 'aa';
		d.Type__c = 'ABSA 6280 - Tax Self- Certification and Declaration';
		d.Opportunity__c = testOpp.id;
		d.Reference__c = '92 3 ICM7 UGOLSDB13 Ent_Quotation59 26 A1001001A20F08C10108B0752518 A20F08C10108B075251 14 1868';
		insert d;
		list<Mandatory_Doc__mdt> mandlist;
		Test.startTest();
		DocumentsShareControllerESign.getDocs(testOpp.id);
		mandlist = DocumentsShareControllerESign.getAllMandatoryDocuments(testOpp.Entity_Type__c);

		Test.stopTest();
		System.assertNotEquals(mandlist, null);
	}

	@isTest
	public static void testupdateopportunity(){
		//Opportunity opp=[select id,CheckMandatoryDocuments__c,StageName from opportunity limit 1 ];
		Account testAccount = new Account();
		testAccount.Name = 'Test Name';
		testAccount.Country_of_Registration__c = 'South Africa';
		testAccount.Client_Group__c = 'Non Individual';
		testAccount.Client_Type__c = 'Sole Trader';
		testAccount.CASA_Reference_Number__c = '12233';
		testAccount.CIF__c = '';
		testAccount.Countries_Traded_With__c = 'South Africa';
		testAccount.Country_of_Registration__c = 'South Africa';
		testAccount.Source_of_Income__c = 'Donation';
		insert testAccount;
		Opportunity testOpp = new Opportunity();
		testOpp.Name = 'Test Opp';
		testOpp.CloseDate = Date.today();

		testOpp.StageName = 'Drafting';
		testOpp.accountId = testAccount.Id;
		insert testOpp;
		Test.startTest();
		List<String> response;
		try{
			response = DocumentsShareControllerESign.updateOpportunity(String.valueOf(testOpp.Id), 'true');

			DocumentsShareControllerESign.updateOpportunity(String.valueOf(testOpp.Id), 'false');

		} catch (Exception e){
			System.debug('Exception::' + e.getMessage());
		}
		Test.stopTest();
		System.assertNotEquals(response, null);
	}

	@isTest
	public static void testgetPrimaryClientMandatoryDocuments(){
		WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
		Document__c d = new Document__c();
		d.Name = 'aa';
		d.Type__c = 'ABSA 6280 - Tax Self- Certification and Declaration';
		d.Opportunity__c = testDataFactory.testOpportunity.id;
		d.Reference__c = '92 3 ICM7 UGOLSDB13 Ent_Quotation59 26 A1001001A20F08C10108B0752518 A20F08C10108B075251 14 1868';
		insert d;

		User usr = new UsersSelector().selectById(UserInfo.getUserId());
		usr.Phone = '+27839289087';
		update usr;

		System.assertNotEquals(null,DocumentsShareControllerESign.getPrimaryClientMandatoryDocuments(testDataFactory.testOpportunity.Account.Client_Type__c, testDataFactory.testOpportunity.id));
	}
	//End changes for W-005270
}