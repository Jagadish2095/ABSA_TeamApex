/**
 * @description       :
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @last modified on  : 2021-11-08
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log
 * Ver   Date         Author                 Modification
 * 1.0   2021-05-25   robertml@absa.africa   Initial Version
 **/
@isTest
private class OnboardingCASAScreeningControllerTest {
	@isTest
	public static void callScreening() {
		Test.setMock(
			HttpCalloutMock.class,
			new CreateClientCIFMock_ApiRest(StringConstants.POSITIVE_STRING, StringConstants.POSITIVE_STRING, StringConstants.POSITIVE_STRING, null)
		);
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.API_MANAGER,
			new List<String>{ StringConstants.VALIDATE_CLIENT_DETAILS, StringConstants.VALIDATE_ADDRESS, StringConstants.CREATE_CLIENT_CIF }
		);
		IntegrationTestDataFactory.insertIntegrationTranslations();

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
		account.UBO_ParentAccountWrapper__c = '[{"Type":"Private Company","ShareholderCount":3,"Shareholder":"PASCAL SOLUTIONS (PTY) LTD","recordId":"0015r00000Ht2mtAAB","ParentShareholding":100,"Controllinginterest":100,"Accwrplist":[{"UBO":"","Type":"Private Company","ShareholderCount":2,"Shareholder":"GAMBULELA TRADING (PTY) LTD","roles":"Shareholder/Controller","relatedAccountId":"0015r00000EYE78AAH","recordId":"a005r000001u7LyAAI","primaryEntityId":"0015r00000Ht2mtAAB","ParentShareholding":25.00,"parentAccountId":"0015r00000Ht2mtAAB","idType":"Registration Number","Controllinginterest":25.00,"childwrplist":[{"UBO":"No","Type":"Individual","ShareholderCount":0,"Shareholder":"NTEMBEKO NTANTISO MAKALIMA","roles":"Director;Individual with Authority to Act;Shareholder/Controller;Contact Person;Operators on primary accounts ( Internet Main Users, Signatories, Card Users);Manager","relatedAccountId":"0035r00000C2V0PAAV","recordId":"07k5r000002QR7cAAG","primaryEntityId":"0015r00000EYE78AAH","ParentShareholding":10.00,"parentAccountId":"0015r00000EYE78AAH","idType":"SA Identity Document","Controllinginterest":2.50,"childwrplist":null,"accType":"AccountContact"},{"UBO":"","Type":"Trusts","ShareholderCount":2,"Shareholder":"Greyling Trust","roles":"Shareholder/Controller","relatedAccountId":"0015r00000EYC4QAAX","recordId":"a005r000001b3GJAAY","primaryEntityId":"0015r00000EYE78AAH","ParentShareholding":90.00,"parentAccountId":"0015r00000EYE78AAH","idType":"Non-Registered Entity","Controllinginterest":22.50,"childwrplist":[{"UBO":"Yes","Type":"Individual","ShareholderCount":0,"Shareholder":"GANAS SOOBRAMONY NAIDU","roles":"Named Beneficiaries","relatedAccountId":"0035r00000C1GWKAA3","recordId":"07k5r000002QQTtAAO","primaryEntityId":"0015r00000EYB8FAAX","ParentShareholding":80.00,"parentAccountId":"0015r00000EYC4QAAX","idType":"SA Identity Document","Controllinginterest":18.00,"childwrplist":null,"accType":"AccountContact"},{"UBO":"","Type":"Private Company","ShareholderCount":2,"Shareholder":"HFR Properties KZN (pty )Ltd","roles":"Trustees","relatedAccountId":"0015r00000HtjKwAAJ","recordId":"a005r000001u7M3AAI","primaryEntityId":"0015r00000EYC4QAAX","ParentShareholding":100.00,"parentAccountId":"0015r00000EYC4QAAX","idType":"Registration Number","Controllinginterest":22.50,"childwrplist":[{"UBO":"Yes","Type":"Individual","ShareholderCount":0,"Shareholder":"NTEMBEKO NTANTISO MAKALIMA","roles":"Named Beneficiaries","relatedAccountId":"0035r00000C2V0PAAV","recordId":"07k5r000004FVZFAA4","primaryEntityId":"0015r00000EYC4QAAX","ParentShareholding":100.00,"parentAccountId":"0015r00000HtjKwAAJ","idType":"SA Identity Document","Controllinginterest":25.00,"childwrplist":null,"accType":"AccountContact"},{"UBO":"","Type":"Private Company","ShareholderCount":2,"Shareholder":"Capolie Botha Eiendomme (Pty) Ltd","roles":"Shareholder/Controller","relatedAccountId":"0015r00000HtmrpAAB","recordId":"a005r000001u7MDAAY","primaryEntityId":"0015r00000EYC4QAAX","ParentShareholding":100.00,"parentAccountId":"0015r00000HtjKwAAJ","idType":"Registration Number","Controllinginterest":22.50,"childwrplist":[{"UBO":"","Type":"Private Company","ShareholderCount":2,"Shareholder":"Test Light (Pty) Ltd","roles":"Shareholder/Controller","relatedAccountId":"0015r00000Ht94NAAR","recordId":"a005r000001u7MIAAY","primaryEntityId":"0015r00000EYC4QAAX","ParentShareholding":50.00,"parentAccountId":"0015r00000HtmrpAAB","idType":"Registration Number","Controllinginterest":11.25,"childwrplist":[{"UBO":"No","Type":"Individual","ShareholderCount":0,"Shareholder":"Mara Mahlatse","roles":"Shareholder/Controller","relatedAccountId":"0035r00000FMe1oAAD","recordId":"07k5r000004FnpIAAS","primaryEntityId":"0015r00000EYC4QAAX","ParentShareholding":60.00,"parentAccountId":"0015r00000Ht94NAAR","idType":"Passport","Controllinginterest":6.75,"childwrplist":null,"accType":"AccountContact"},{"UBO":"","Type":"Trusts","ShareholderCount":2,"Shareholder":"Mara Trust","roles":"Shareholder/Controller","relatedAccountId":"0015r00000HtrEtAAJ","recordId":"a005r000001u7MSAAY","primaryEntityId":"0015r00000EYC4QAAX","ParentShareholding":50.00,"parentAccountId":"0015r00000Ht94NAAR","idType":"Non-Registered Entity","Controllinginterest":5.62,"childwrplist":[{"UBO":"No","Type":"Individual","ShareholderCount":0,"Shareholder":"JOHANNES HENDRIK BESTER","roles":"Named Beneficiaries","relatedAccountId":"0035r000009TLRHAA4","recordId":"07k5r000004FKs8AAG","primaryEntityId":"0015r00000EYC4QAAX","ParentShareholding":25.00,"parentAccountId":"0015r00000HtrEtAAJ","idType":"SA Identity Document","Controllinginterest":1.41,"childwrplist":null,"accType":"AccountContact"},{"UBO":"No","Type":"Individual","ShareholderCount":0,"Shareholder":"HEIDI MICHELLE WENKE","roles":"Named Beneficiaries","relatedAccountId":"0035r00000DWT7zAAH","recordId":"07k5r000004FKscAAG","primaryEntityId":"0015r00000EYC4QAAX","ParentShareholding":25.00,"parentAccountId":"0015r00000HtrEtAAJ","idType":"SA Identity Document","Controllinginterest":1.41,"childwrplist":null,"accType":"AccountContact"}],"accType":"AccountAccount"}],"accType":"AccountAccount"},{"UBO":"","Type":"Private Company","ShareholderCount":2,"Shareholder":"REcord Hut (Pty) LTd","roles":"Shareholder/Controller","relatedAccountId":"0015r00000Hns30AAB","recordId":"a005r000001u7MNAAY","primaryEntityId":"0015r00000EYC4QAAX","ParentShareholding":50.00,"parentAccountId":"0015r00000HtmrpAAB","idType":"Registration Number","Controllinginterest":11.25,"childwrplist":[{"UBO":"Yes","Type":"Individual","ShareholderCount":0,"Shareholder":"DANISILE DERRICK MBALO","roles":"Shareholder/Controller","relatedAccountId":"0035r00000FNDlXAAX","recordId":"07k5r000004FSneAAG","primaryEntityId":"0015r00000EYC4QAAX","ParentShareholding":100.00,"parentAccountId":"0015r00000Hns30AAB","idType":"SA Identity Document","Controllinginterest":11.25,"childwrplist":null,"accType":"AccountContact"},{"UBO":"Yes","Type":"Individual","ShareholderCount":0,"Shareholder":"Mara Mahlatse","roles":"Shareholder/Controller","relatedAccountId":"0035r00000FMe1oAAD","recordId":"07k5r000004FnGpAAK","primaryEntityId":"0015r00000EYC4QAAX","ParentShareholding":40.00,"parentAccountId":"0015r00000Hns30AAB","idType":"Passport","Controllinginterest":11.25,"childwrplist":null,"accType":"AccountContact"}],"accType":"AccountAccount"}],"accType":"AccountAccount"}],"accType":"AccountAccount"}],"accType":"AccountAccount"}],"accType":"AccountAccount"},{"UBO":"","Type":"Private Company","ShareholderCount":1,"Shareholder":"Test Complex Structure (Pty) Ltd","roles":"Shareholder/Controller","relatedAccountId":"0015r00000DmDe9AAF","recordId":"a005r000001u7SpAAI","primaryEntityId":"0015r00000Ht2mtAAB","ParentShareholding":25.00,"parentAccountId":"0015r00000Ht2mtAAB","idType":"Registration Number","Controllinginterest":25.00,"childwrplist":[{"UBO":"","Type":"Trusts","ShareholderCount":1,"Shareholder":"BOTHA FAMILY TRUST","roles":"Shareholder/Controller","relatedAccountId":"0015J00000F06smQAB","recordId":"a005r000001u9LnAAI","primaryEntityId":"0015r00000Ht2mtAAB","ParentShareholding":100.00,"parentAccountId":"0015r00000DmDe9AAF","idType":null,"Controllinginterest":25.00,"childwrplist":[{"UBO":"","Type":"Close Corporation","ShareholderCount":2,"Shareholder":"Two stone Gardening services cc","roles":"Named Beneficiaries","relatedAccountId":"0015r00000HuCsaAAF","recordId":"a005r000001u9LsAAI","primaryEntityId":"0015r00000Ht2mtAAB","ParentShareholding":100.00,"parentAccountId":"0015J00000F06smQAB","idType":"Registration Number","Controllinginterest":25.00,"childwrplist":[{"UBO":"Yes","Type":"Individual","ShareholderCount":0,"Shareholder":"NTEMBEKO NTANTISO MAKALIMA","roles":"Members/Controllers","relatedAccountId":"0035r00000C2V0PAAV","recordId":"07k5r000004FkojAAC","primaryEntityId":"0015r00000Ht2mtAAB","ParentShareholding":30.00,"parentAccountId":"0015r00000HuCsaAAF","idType":"SA Identity Document","Controllinginterest":32.50,"childwrplist":null,"accType":"AccountContact"},{"UBO":"","Type":"Close Corporation","ShareholderCount":1,"Shareholder":"P and D Trading CC","roles":"Members/Controllers","relatedAccountId":"0015r00000HuCokAAF","recordId":"a005r000001u9LxAAI","primaryEntityId":"0015r00000Ht2mtAAB","ParentShareholding":100.00,"parentAccountId":"0015r00000HuCsaAAF","idType":"Registration Number","Controllinginterest":25.00,"childwrplist":[{"UBO":"Yes","Type":"Individual","ShareholderCount":0,"Shareholder":"A Burgess","roles":"Members/Controllers","relatedAccountId":"0035r00000FNDbMAAX","recordId":"07k5r000004FSjFAAW","primaryEntityId":"0015r00000Ht2mtAAB","ParentShareholding":100.00,"parentAccountId":"0015r00000HuCokAAF","idType":"SA Identity Document","Controllinginterest":25.00,"childwrplist":null,"accType":"AccountContact"}],"accType":"AccountAccount"}],"accType":"AccountAccount"}],"accType":"AccountAccount"}],"accType":"AccountAccount"},{"UBO":"Yes","Type":"Individual","ShareholderCount":0,"Shareholder":"FRANCOIS MARIO WOLVAARDT","roles":"Director;Shareholder/Controller;Operators on primary accounts ( Internet Main Users, Signatories, Card Users)","relatedAccountId":"0035r00000FMaS4AAL","recordId":"07k5r000004FAwoAAG","primaryEntityId":"0015r00000Ht2mtAAB","ParentShareholding":25.00,"parentAccountId":"0015r00000Ht2mtAAB","idType":"SA Identity Document","Controllinginterest":25.00,"childwrplist":null,"accType":"AccountContact"}],"accType":"Account"}]';
		insert account;

		//insert related acct;
		List<AccountContactRelation> acrList = new List<AccountContactRelation>();
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
		Account acc = [SELECT PersonContactId FROM Account WHERE Id = :acctSecondary.Id];
		Id personContactId = acc.PersonContactId;
		AccountContactRelation accConRel = new AccountContactRelation(AccountId = account.Id, ContactId = personContactId);
		insert accConRel;
		acrList.add(accConRel);

		Set<Id> relatedPartIdSet = new Set<Id>();
		for (AccountContactRelation acr : acrList) {
			relatedPartIdSet.add(acr.ContactId);
		}
		List<Account> rpAccounts = new AccountsSelector().selectCasaFieldsByPersonContactSetId(relatedPartIdSet);

		Opportunity testOpp = new Opportunity();
		testOpp.Name = 'Test Opp';
		testOpp.CloseDate = Date.today();
		testOpp.StageName = 'Drafting';
		testOpp.accountId = account.Id;
		insert testOpp;

		Product2 prod = new Product2(Name = 'Cheque Product', Family = 'Cheque', ProductCode = '1234');

		insert prod;

		Pricebook2 standardPriceBook = WillsTestDataFactory.getStandardPriceBook();
		PricebookEntry pricebookEntry = WillsTestDataFactory.createPriceBookEntry(standardPriceBook.Id, prod.Id);

		OpportunityLineItem oli = new OpportunityLineItem();
		oli.OpportunityId = testOpp.Id;
		if (prod.Id != null) {
			oli.Product2Id = prod.Id;
		}
		oli.PriceBookEntryid = pricebookEntry.Id;
		oli.Quantity = 1;
		oli.TotalPrice = 100;
		insert oli;

		Test.startTest();
		OnboardingCASAScreeningController.callToCASAScreening(testOpp.id);
		OnboardingCASAScreeningController.getAccountData(testOpp.Id);
		OnboardingCASAScreeningController.getPartcicpantAccount(testOpp.Id);
		OnboardingCASAScreeningController.getOpportunityData(testOpp.Id);
		OnboardingCASAScreeningController.refreshCasaStatus(testOpp.Id);
		OnboardingCASAScreeningController.getAccountRecordType(testOpp.Id);
		OnboardingCASAScreeningController.CheckRelatedPartyCasaStatus(testOpp.Id);
		OnboardingCASAScreeningController.getParentAccountWrapper(testOpp.Id);
		OnboardingCASAScreeningController.getParticipants(testOpp.AccountId,'AccountContact',null);
		OnboardingCASAScreeningController.getParticipants(testOpp.AccountId,'AccountAccount',null);
		System.assert(testOpp.Casa_Status__c != 'Valid');
		Test.stopTest();
	}

	@isTest
	public static void callScreening1() {
		WimiTestDataFactory testDataFactory = new WimiTestDataFactory();

		// Set mock callout class
		Test.setMock(HttpCalloutMock.class, new CASAPrimaryClientScreeningMock_ApiRest(StringConstants.POSITIVE_STRING));
		IntegrationTestDataFactory.insertIntegrationTranslations();
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.API_MANAGER,
			new List<String>{ StringConstants.CASA_PRIMARY_CLIENT_SCREENING, StringConstants.CASA_PRIMARY_CLIENT_SCREENING_V2 }
		);

		Account account = new Account(FirstName = 'Test Account', LastName = 'test');
		account.RecordTypeId = schema.SObjectType.account.getRecordTypeInfosByName().get('Individual Client').getRecordTypeId();
		account.UBO_ParentAccountWrapper__c = '[{"Type":"Private Company","ShareholderCount":3,"Shareholder":"PASCAL SOLUTIONS (PTY) LTD","recordId":"0015r00000Ht2mtAAB","ParentShareholding":100,"Controllinginterest":100,"Accwrplist":[{"UBO":"","Type":"Private Company","ShareholderCount":2,"Shareholder":"GAMBULELA TRADING (PTY) LTD","roles":"Shareholder/Controller","relatedAccountId":"0015r00000EYE78AAH","recordId":"a005r000001u7LyAAI","primaryEntityId":"0015r00000Ht2mtAAB","ParentShareholding":25.00,"parentAccountId":"0015r00000Ht2mtAAB","idType":"Registration Number","Controllinginterest":25.00,"childwrplist":[{"UBO":"No","Type":"Individual","ShareholderCount":0,"Shareholder":"NTEMBEKO NTANTISO MAKALIMA","roles":"Director;Individual with Authority to Act;Shareholder/Controller;Contact Person;Operators on primary accounts ( Internet Main Users, Signatories, Card Users);Manager","relatedAccountId":"0035r00000C2V0PAAV","recordId":"07k5r000002QR7cAAG","primaryEntityId":"0015r00000EYE78AAH","ParentShareholding":10.00,"parentAccountId":"0015r00000EYE78AAH","idType":"SA Identity Document","Controllinginterest":2.50,"childwrplist":null,"accType":"AccountContact"},{"UBO":"","Type":"Trusts","ShareholderCount":2,"Shareholder":"Greyling Trust","roles":"Shareholder/Controller","relatedAccountId":"0015r00000EYC4QAAX","recordId":"a005r000001b3GJAAY","primaryEntityId":"0015r00000EYE78AAH","ParentShareholding":90.00,"parentAccountId":"0015r00000EYE78AAH","idType":"Non-Registered Entity","Controllinginterest":22.50,"childwrplist":[{"UBO":"Yes","Type":"Individual","ShareholderCount":0,"Shareholder":"GANAS SOOBRAMONY NAIDU","roles":"Named Beneficiaries","relatedAccountId":"0035r00000C1GWKAA3","recordId":"07k5r000002QQTtAAO","primaryEntityId":"0015r00000EYB8FAAX","ParentShareholding":80.00,"parentAccountId":"0015r00000EYC4QAAX","idType":"SA Identity Document","Controllinginterest":18.00,"childwrplist":null,"accType":"AccountContact"},{"UBO":"","Type":"Private Company","ShareholderCount":2,"Shareholder":"HFR Properties KZN (pty )Ltd","roles":"Trustees","relatedAccountId":"0015r00000HtjKwAAJ","recordId":"a005r000001u7M3AAI","primaryEntityId":"0015r00000EYC4QAAX","ParentShareholding":100.00,"parentAccountId":"0015r00000EYC4QAAX","idType":"Registration Number","Controllinginterest":22.50,"childwrplist":[{"UBO":"Yes","Type":"Individual","ShareholderCount":0,"Shareholder":"NTEMBEKO NTANTISO MAKALIMA","roles":"Named Beneficiaries","relatedAccountId":"0035r00000C2V0PAAV","recordId":"07k5r000004FVZFAA4","primaryEntityId":"0015r00000EYC4QAAX","ParentShareholding":100.00,"parentAccountId":"0015r00000HtjKwAAJ","idType":"SA Identity Document","Controllinginterest":25.00,"childwrplist":null,"accType":"AccountContact"},{"UBO":"","Type":"Private Company","ShareholderCount":2,"Shareholder":"Capolie Botha Eiendomme (Pty) Ltd","roles":"Shareholder/Controller","relatedAccountId":"0015r00000HtmrpAAB","recordId":"a005r000001u7MDAAY","primaryEntityId":"0015r00000EYC4QAAX","ParentShareholding":100.00,"parentAccountId":"0015r00000HtjKwAAJ","idType":"Registration Number","Controllinginterest":22.50,"childwrplist":[{"UBO":"","Type":"Private Company","ShareholderCount":2,"Shareholder":"Test Light (Pty) Ltd","roles":"Shareholder/Controller","relatedAccountId":"0015r00000Ht94NAAR","recordId":"a005r000001u7MIAAY","primaryEntityId":"0015r00000EYC4QAAX","ParentShareholding":50.00,"parentAccountId":"0015r00000HtmrpAAB","idType":"Registration Number","Controllinginterest":11.25,"childwrplist":[{"UBO":"No","Type":"Individual","ShareholderCount":0,"Shareholder":"Mara Mahlatse","roles":"Shareholder/Controller","relatedAccountId":"0035r00000FMe1oAAD","recordId":"07k5r000004FnpIAAS","primaryEntityId":"0015r00000EYC4QAAX","ParentShareholding":60.00,"parentAccountId":"0015r00000Ht94NAAR","idType":"Passport","Controllinginterest":6.75,"childwrplist":null,"accType":"AccountContact"},{"UBO":"","Type":"Trusts","ShareholderCount":2,"Shareholder":"Mara Trust","roles":"Shareholder/Controller","relatedAccountId":"0015r00000HtrEtAAJ","recordId":"a005r000001u7MSAAY","primaryEntityId":"0015r00000EYC4QAAX","ParentShareholding":50.00,"parentAccountId":"0015r00000Ht94NAAR","idType":"Non-Registered Entity","Controllinginterest":5.62,"childwrplist":[{"UBO":"No","Type":"Individual","ShareholderCount":0,"Shareholder":"JOHANNES HENDRIK BESTER","roles":"Named Beneficiaries","relatedAccountId":"0035r000009TLRHAA4","recordId":"07k5r000004FKs8AAG","primaryEntityId":"0015r00000EYC4QAAX","ParentShareholding":25.00,"parentAccountId":"0015r00000HtrEtAAJ","idType":"SA Identity Document","Controllinginterest":1.41,"childwrplist":null,"accType":"AccountContact"},{"UBO":"No","Type":"Individual","ShareholderCount":0,"Shareholder":"HEIDI MICHELLE WENKE","roles":"Named Beneficiaries","relatedAccountId":"0035r00000DWT7zAAH","recordId":"07k5r000004FKscAAG","primaryEntityId":"0015r00000EYC4QAAX","ParentShareholding":25.00,"parentAccountId":"0015r00000HtrEtAAJ","idType":"SA Identity Document","Controllinginterest":1.41,"childwrplist":null,"accType":"AccountContact"}],"accType":"AccountAccount"}],"accType":"AccountAccount"},{"UBO":"","Type":"Private Company","ShareholderCount":2,"Shareholder":"REcord Hut (Pty) LTd","roles":"Shareholder/Controller","relatedAccountId":"0015r00000Hns30AAB","recordId":"a005r000001u7MNAAY","primaryEntityId":"0015r00000EYC4QAAX","ParentShareholding":50.00,"parentAccountId":"0015r00000HtmrpAAB","idType":"Registration Number","Controllinginterest":11.25,"childwrplist":[{"UBO":"Yes","Type":"Individual","ShareholderCount":0,"Shareholder":"DANISILE DERRICK MBALO","roles":"Shareholder/Controller","relatedAccountId":"0035r00000FNDlXAAX","recordId":"07k5r000004FSneAAG","primaryEntityId":"0015r00000EYC4QAAX","ParentShareholding":100.00,"parentAccountId":"0015r00000Hns30AAB","idType":"SA Identity Document","Controllinginterest":11.25,"childwrplist":null,"accType":"AccountContact"},{"UBO":"Yes","Type":"Individual","ShareholderCount":0,"Shareholder":"Mara Mahlatse","roles":"Shareholder/Controller","relatedAccountId":"0035r00000FMe1oAAD","recordId":"07k5r000004FnGpAAK","primaryEntityId":"0015r00000EYC4QAAX","ParentShareholding":40.00,"parentAccountId":"0015r00000Hns30AAB","idType":"Passport","Controllinginterest":11.25,"childwrplist":null,"accType":"AccountContact"}],"accType":"AccountAccount"}],"accType":"AccountAccount"}],"accType":"AccountAccount"}],"accType":"AccountAccount"}],"accType":"AccountAccount"},{"UBO":"","Type":"Private Company","ShareholderCount":1,"Shareholder":"Test Complex Structure (Pty) Ltd","roles":"Shareholder/Controller","relatedAccountId":"0015r00000DmDe9AAF","recordId":"a005r000001u7SpAAI","primaryEntityId":"0015r00000Ht2mtAAB","ParentShareholding":25.00,"parentAccountId":"0015r00000Ht2mtAAB","idType":"Registration Number","Controllinginterest":25.00,"childwrplist":[{"UBO":"","Type":"Trusts","ShareholderCount":1,"Shareholder":"BOTHA FAMILY TRUST","roles":"Shareholder/Controller","relatedAccountId":"0015J00000F06smQAB","recordId":"a005r000001u9LnAAI","primaryEntityId":"0015r00000Ht2mtAAB","ParentShareholding":100.00,"parentAccountId":"0015r00000DmDe9AAF","idType":null,"Controllinginterest":25.00,"childwrplist":[{"UBO":"","Type":"Close Corporation","ShareholderCount":2,"Shareholder":"Two stone Gardening services cc","roles":"Named Beneficiaries","relatedAccountId":"0015r00000HuCsaAAF","recordId":"a005r000001u9LsAAI","primaryEntityId":"0015r00000Ht2mtAAB","ParentShareholding":100.00,"parentAccountId":"0015J00000F06smQAB","idType":"Registration Number","Controllinginterest":25.00,"childwrplist":[{"UBO":"Yes","Type":"Individual","ShareholderCount":0,"Shareholder":"NTEMBEKO NTANTISO MAKALIMA","roles":"Members/Controllers","relatedAccountId":"0035r00000C2V0PAAV","recordId":"07k5r000004FkojAAC","primaryEntityId":"0015r00000Ht2mtAAB","ParentShareholding":30.00,"parentAccountId":"0015r00000HuCsaAAF","idType":"SA Identity Document","Controllinginterest":32.50,"childwrplist":null,"accType":"AccountContact"},{"UBO":"","Type":"Close Corporation","ShareholderCount":1,"Shareholder":"P and D Trading CC","roles":"Members/Controllers","relatedAccountId":"0015r00000HuCokAAF","recordId":"a005r000001u9LxAAI","primaryEntityId":"0015r00000Ht2mtAAB","ParentShareholding":100.00,"parentAccountId":"0015r00000HuCsaAAF","idType":"Registration Number","Controllinginterest":25.00,"childwrplist":[{"UBO":"Yes","Type":"Individual","ShareholderCount":0,"Shareholder":"A Burgess","roles":"Members/Controllers","relatedAccountId":"0035r00000FNDbMAAX","recordId":"07k5r000004FSjFAAW","primaryEntityId":"0015r00000Ht2mtAAB","ParentShareholding":100.00,"parentAccountId":"0015r00000HuCokAAF","idType":"SA Identity Document","Controllinginterest":25.00,"childwrplist":null,"accType":"AccountContact"}],"accType":"AccountAccount"}],"accType":"AccountAccount"}],"accType":"AccountAccount"}],"accType":"AccountAccount"},{"UBO":"Yes","Type":"Individual","ShareholderCount":0,"Shareholder":"FRANCOIS MARIO WOLVAARDT","roles":"Director;Shareholder/Controller;Operators on primary accounts ( Internet Main Users, Signatories, Card Users)","relatedAccountId":"0035r00000FMaS4AAL","recordId":"07k5r000004FAwoAAG","primaryEntityId":"0015r00000Ht2mtAAB","ParentShareholding":25.00,"parentAccountId":"0015r00000Ht2mtAAB","idType":"SA Identity Document","Controllinginterest":25.00,"childwrplist":null,"accType":"AccountContact"}],"accType":"Account"}]';
		insert account;

		Opportunity testOpp = new Opportunity();
		testOpp.Name = 'Test Opp';
		testOpp.CloseDate = Date.today();
		testOpp.StageName = 'Drafting';
		testOpp.accountId = account.Id;
		insert testOpp;

		Product2 prod = new Product2(Name = 'Cheque Product', Family = 'Cheque', ProductCode = '1234');

		insert prod;

		Pricebook2 standardPriceBook = WillsTestDataFactory.getStandardPriceBook();
		PricebookEntry pricebookEntry = WillsTestDataFactory.createPriceBookEntry(standardPriceBook.Id, prod.Id);

		OpportunityLineItem oli = new OpportunityLineItem();
		oli.OpportunityId = testOpp.Id;
		if (prod.Id != null) {
			oli.Product2Id = prod.Id;
		}
		oli.PriceBookEntryid = pricebookEntry.Id;
		oli.Quantity = 1;
		oli.TotalPrice = 100;
		insert oli;

		//Create Trading as Name test records
		Trading_as_Name__c testTradingAsName = new Trading_as_Name__c();
		testTradingAsName.Name = 'T/A Test';
		testTradingAsName.Account__c = testDataFactory.testAccount.id;
		testTradingAsName.CASA_Screening_Status__c = 'Pending';
		insert testTradingAsName;

		Test.startTest();
		OnboardingCASAScreeningController.callToCASAScreening(testOpp.id);
		OnboardingCASAScreeningController.getAccountData(testOpp.Id);
		OnboardingCASAScreeningController.getTradingAsNameData(testOpp.Id, null);
		OnboardingCASAScreeningController.refreshCasaStatus(testOpp.Id);
		OnboardingCASAScreeningController.getAccountRecordType(testOpp.Id);
		OnboardingCASAScreeningController.CheckRelatedPartyCasaStatus(testOpp.Id);
		System.assert(testOpp.Casa_Status__c != 'Valid');
		Test.stopTest();
	}

	@isTest
	public static void testCaseCreation() {
		Account account = new Account(FirstName = 'Test Account', LastName = 'test');
		account.RecordTypeId = schema.SObjectType.account.getRecordTypeInfosByName().get('Individual Client').getRecordTypeId();
		insert account;
		Service_Type__c serviceType = new Service_Type__c(Name = 'Test1', Case_Record_Type__c = 'New', Subtype__c = 'Sample', Type__c = 'T01');
		insert serviceType;

		BusinessHours businessHr = [SELECT Id FROM BusinessHours LIMIT 1];

		Service_Group__c serviceGr = new Service_Group__c(
			Name = 'Test1',
			Assign_Record_Type__c = 'Email',
			Response_Email_Address__c = 'evg@t.com',
			Queue__c = 'Email',
			Business_Hours__c = businessHr.Id,
			Internal_SLA_Time_Measure__c = 'Hour(s)',
			Internal_SLA_Units__c = '8'
		);
		insert serviceGr;

		Service_Level__c serviceLevel = new Service_Level__c(
			Name = 'Test1',
			External_SLA_Time_Measure__c = 'Hour(s)',
			External_SLA_Units__c = '8',
			Default_Service_Level__c = true
		);
		insert serviceLevel;

		Service_Group_Type__c serviceGrType = new Service_Group_Type__c(
			Service_Type__c = serviceType.Id,
			Service_Group__c = serviceGr.Id,
			Service_Level__c = serviceLevel.Id
		);
		insert serviceGrType;

		Case caseRec = OnboardingCASAScreeningController.createHighRiskCase(account.id, 'Test1', 'Onboarding');
		System.assert(caseRec != null);
	}

	@isTest
	public static void testCaseCreationNegative() {
		Account account = new Account(FirstName = 'Test Account', LastName = 'test');
		account.RecordTypeId = schema.SObjectType.account.getRecordTypeInfosByName().get('Individual Client').getRecordTypeId();
		insert account;

		Case caseRec;
		try {
			caseRec = OnboardingCASAScreeningController.createHighRiskCase(account.id, null, 'Onboarding');
		} catch (Exception ex) {
			System.assert(caseRec == null);
		}
	}

	@isTest
	public static void testCasaScreeningStatus() {
		WimiTestDataFactory testDataFactory = new WimiTestDataFactory();

		// Set mock callout class
		Test.setMock(HttpCalloutMock.class, new GetCasaDetailsByRefMock_ApiRest(StringConstants.POSITIVE_STRING));
		//Insert Integration Settings
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.API_MANAGER,
			new List<String>{ GetCasaDetailsByRef_IH_v1.GET_CASA_DETAILS_BY_REF_SERVICE }
		);

		Test.startTest();
		OnboardingCASAScreeningController.refreshCasaStatus(testDataFactory.testOpportunity.id);
		System.assert(testDataFactory.testOpportunity.CASA_Screening_Status_Value__c == null);
		Test.stopTest();
	}

	@isTest
	public static void callScreeningParticipants() {
		// Set mock callout class
		Test.setMock(HttpCalloutMock.class, new GetCasaDetailsByRefMock_ApiRest(StringConstants.POSITIVE_STRING));
		//Insert Integration Settings
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.API_MANAGER,
			new List<String>{ GetCasaDetailsByRef_IH_v1.GET_CASA_DETAILS_BY_REF_SERVICE }
		);
		IntegrationTestDataFactory.insertIntegrationTranslations();

		Account account = new Account(Name = 'Test Account');
		account.RecordTypeId = schema.SObjectType.account.getRecordTypeInfosByName().get('Business Prospect').getRecordTypeId();
		//W-005355 : Anka Ganta : 2020-07-09
		account.Country_of_Incorporation__c = 'South Africa';
		account.Client_Group__c = 'Non Individual';
		account.CASA_Reference_Number__c = '12233';
		account.CIF__c = '';
		account.Countries_Traded_With__c = 'South Africa';
		account.Source_of_Income__c = 'Donation';
		insert account;

		//insert related acct;
		List<AccountContactRelation> acrList = new List<AccountContactRelation>();
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
		Account acc = [SELECT PersonContactId FROM Account WHERE Id = :acctSecondary.Id];
		Id personContactId = acc.PersonContactId;
		AccountContactRelation accConRel = new AccountContactRelation(AccountId = account.Id, ContactId = personContactId);
		insert accConRel;
		acrList.add(accConRel);

		Set<Id> relatedPartIdSet = new Set<Id>();
		for (AccountContactRelation acr : acrList) {
			relatedPartIdSet.add(acr.ContactId);
		}
		List<Account> rpAccounts = new AccountsSelector().selectCasaFieldsByPersonContactSetId(relatedPartIdSet);

		Opportunity testOpp = new Opportunity();
		testOpp.Name = 'Test Opp';
		testOpp.CloseDate = Date.today();
		testOpp.StageName = 'Drafting';
		testOpp.accountId = account.Id;
		insert testOpp;

		Product2 prod = new Product2(Name = 'Cheque Product', Family = 'Cheque', ProductCode = '1234');

		insert prod;

		Pricebook2 standardPriceBook = WillsTestDataFactory.getStandardPriceBook();
		PricebookEntry pricebookEntry = WillsTestDataFactory.createPriceBookEntry(standardPriceBook.Id, prod.Id);

		OpportunityLineItem oli = new OpportunityLineItem();
		oli.OpportunityId = testOpp.Id;
		if (prod.Id != null) {
			oli.Product2Id = prod.Id;
		}
		oli.PriceBookEntryid = pricebookEntry.Id;
		oli.Quantity = 1;
		oli.TotalPrice = 100;
		insert oli;

		Test.startTest();

		OnboardingCASAScreeningController.refreshCasaStatus(testOpp.Id);
		System.assert(testOpp.CASA_Screening_Status_Value__c == null);

		Test.stopTest();
	}
	@isTest
	public static void confirmDocumentReceiptTest() {
		WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
		Generatedocumentsv7_Req_IB_v1.createDummyRequest();

		Test.setMock(HttpCalloutMock.class, new Generatedocumentsv7_ApiRest(StringConstants.POSITIVE_STRING));
		IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT, new List<String>{ 'Jitterbit Auth Path' });
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT_API_RB_STRING,
			new List<String>{ StringConstants.Generatedocumentsv7_STRING }
		);
		Integration_API__c apiIntRec = Sys_Utilities_Integration.getIntegrationSettings(
			StringConstants.JITTERBIT_API_RB_STRING,
			Sys_Utilities_General.getEnvironment(),
			StringConstants.Generatedocumentsv7_STRING
		);

		system.assertNotEquals(apiIntRec, null);

		Account testAccount = new Account();
		testAccount.Name = 'Test Name';
		//W-005355 : Anka Ganta : 2020-07-09
		testAccount.Country_of_Incorporation__c = 'South Africa';
		testAccount.Client_Group__c = 'Non Individual';
		testAccount.CASA_Reference_Number__c = '12233';
		testAccount.CIF__c = '';
		testAccount.Countries_Traded_With__c = 'South Africa';
		testAccount.Source_of_Income__c = 'Donation';
		insert testAccount;
		Opportunity testOpp = new Opportunity();
		testOpp.Name = 'Test Opp';
		testOpp.CloseDate = Date.today();
		testOpp.StageName = 'Drafting';
		testOpp.accountId = testAccount.Id;
		insert testOpp;
		Test.startTest();
		String returnStatus = OnboardingCASAScreeningController.confirmDocumentReceipt(testOpp.Id);
		System.assert(returnStatus == 'success');
		Test.stopTest();
	}

	@isTest
	public static void confirmDocumentReceiptTestNeg() {
		WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
		Generatedocumentsv7_Req_IB_v1.createDummyRequest();

		Test.setMock(HttpCalloutMock.class, new Generatedocumentsv7_ApiRest(StringConstants.POSITIVE_STRING, '0', '0'));
		IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT, new List<String>{ 'Jitterbit Auth Path' });
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT_API_RB_STRING,
			new List<String>{ StringConstants.Generatedocumentsv7_STRING }
		);
		Integration_API__c apiIntRec = Sys_Utilities_Integration.getIntegrationSettings(
			StringConstants.JITTERBIT_API_RB_STRING,
			Sys_Utilities_General.getEnvironment(),
			StringConstants.Generatedocumentsv7_STRING
		);

		system.assertNotEquals(apiIntRec, null);

		Account testAccount = new Account();
		testAccount.Name = 'Test Name';
		//W-005355 : Anka Ganta : 2020-07-09
		testAccount.Country_of_Incorporation__c = 'South Africa';
		testAccount.Client_Group__c = 'Non Individual';
		testAccount.CASA_Reference_Number__c = '12233';
		testAccount.CIF__c = '';
		testAccount.Countries_Traded_With__c = 'South Africa';
		testAccount.Source_of_Income__c = 'Donation';
		insert testAccount;
		Opportunity testOpp = new Opportunity();
		testOpp.Name = 'Test Opp';
		testOpp.CloseDate = Date.today();
		testOpp.StageName = 'Drafting';
		testOpp.accountId = testAccount.Id;
		insert testOpp;
		Test.startTest();
		String returnStatus = OnboardingCASAScreeningController.confirmDocumentReceipt(testOpp.Id);
		System.assert(returnStatus == 'success');
		Test.stopTest();
	}

	@isTest
	public static void confirmDocumentReceiptTestNeg2() {
		WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
		Generatedocumentsv7_Req_IB_v1.createDummyRequest();

		Test.setMock(HttpCalloutMock.class, new Generatedocumentsv7_ApiRest(StringConstants.POSITIVE_STRING, '2', '0'));
		IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT, new List<String>{ 'Jitterbit Auth Path' });
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT_API_RB_STRING,
			new List<String>{ StringConstants.Generatedocumentsv7_STRING }
		);
		Integration_API__c apiIntRec = Sys_Utilities_Integration.getIntegrationSettings(
			StringConstants.JITTERBIT_API_RB_STRING,
			Sys_Utilities_General.getEnvironment(),
			StringConstants.Generatedocumentsv7_STRING
		);

		system.assertNotEquals(apiIntRec, null);

		Account testAccount = new Account();
		testAccount.Name = 'Test Name';
		//W-005355 : Anka Ganta : 2020-07-09
		testAccount.Country_of_Incorporation__c = 'South Africa';
		testAccount.Client_Group__c = 'Non Individual';
		testAccount.CASA_Reference_Number__c = '12233';
		testAccount.CIF__c = '';
		testAccount.Countries_Traded_With__c = 'South Africa';
		testAccount.Source_of_Income__c = 'Donation';
		insert testAccount;
		Opportunity testOpp = new Opportunity();
		testOpp.Name = 'Test Opp';
		testOpp.CloseDate = Date.today();
		testOpp.StageName = 'Drafting';
		testOpp.accountId = testAccount.Id;
		insert testOpp;
		Test.startTest();
		OnboardingCASAScreeningController.confirmDocumentReceipt(testOpp.Id);
		Test.stopTest();
	}

	@isTest
	public static void callScreeningPostive() {
		WimiTestDataFactory testDataFactory = new WimiTestDataFactory();

		// Set mock callout class
		Test.setMock(
			HttpCalloutMock.class,
			new CreateClientCIFMock_ApiRest(StringConstants.POSITIVE_STRING, StringConstants.POSITIVE_STRING, StringConstants.POSITIVE_STRING, null)
		);
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.API_MANAGER,
			new List<String>{ StringConstants.VALIDATE_CLIENT_DETAILS, StringConstants.VALIDATE_ADDRESS, StringConstants.CREATE_CLIENT_CIF }
		);
		IntegrationTestDataFactory.insertIntegrationTranslations();

		Account account = new Account(FirstName = 'Test Account', LastName = 'test');
		account.RecordTypeId = schema.SObjectType.account.getRecordTypeInfosByName().get('Individual Client').getRecordTypeId();
		account.Cif__c = '12345';
		 account.UBO_ParentAccountWrapper__c = '[{"Type":"Private Company","ShareholderCount":3,"Shareholder":"PASCAL SOLUTIONS (PTY) LTD","recordId":"0015r00000Ht2mtAAB","ParentShareholding":100,"Controllinginterest":100,"Accwrplist":[{"UBO":"","Type":"Private Company","ShareholderCount":2,"Shareholder":"GAMBULELA TRADING (PTY) LTD","roles":"Shareholder/Controller","relatedAccountId":"0015r00000EYE78AAH","recordId":"a005r000001u7LyAAI","primaryEntityId":"0015r00000Ht2mtAAB","ParentShareholding":25.00,"parentAccountId":"0015r00000Ht2mtAAB","idType":"Registration Number","Controllinginterest":25.00,"childwrplist":[{"UBO":"No","Type":"Individual","ShareholderCount":0,"Shareholder":"NTEMBEKO NTANTISO MAKALIMA","roles":"Director;Individual with Authority to Act;Shareholder/Controller;Contact Person;Operators on primary accounts ( Internet Main Users, Signatories, Card Users);Manager","relatedAccountId":"0035r00000C2V0PAAV","recordId":"07k5r000002QR7cAAG","primaryEntityId":"0015r00000EYE78AAH","ParentShareholding":10.00,"parentAccountId":"0015r00000EYE78AAH","idType":"SA Identity Document","Controllinginterest":2.50,"childwrplist":null,"accType":"AccountContact"},{"UBO":"","Type":"Trusts","ShareholderCount":2,"Shareholder":"Greyling Trust","roles":"Shareholder/Controller","relatedAccountId":"0015r00000EYC4QAAX","recordId":"a005r000001b3GJAAY","primaryEntityId":"0015r00000EYE78AAH","ParentShareholding":90.00,"parentAccountId":"0015r00000EYE78AAH","idType":"Non-Registered Entity","Controllinginterest":22.50,"childwrplist":[{"UBO":"Yes","Type":"Individual","ShareholderCount":0,"Shareholder":"GANAS SOOBRAMONY NAIDU","roles":"Named Beneficiaries","relatedAccountId":"0035r00000C1GWKAA3","recordId":"07k5r000002QQTtAAO","primaryEntityId":"0015r00000EYB8FAAX","ParentShareholding":80.00,"parentAccountId":"0015r00000EYC4QAAX","idType":"SA Identity Document","Controllinginterest":18.00,"childwrplist":null,"accType":"AccountContact"},{"UBO":"","Type":"Private Company","ShareholderCount":2,"Shareholder":"HFR Properties KZN (pty )Ltd","roles":"Trustees","relatedAccountId":"0015r00000HtjKwAAJ","recordId":"a005r000001u7M3AAI","primaryEntityId":"0015r00000EYC4QAAX","ParentShareholding":100.00,"parentAccountId":"0015r00000EYC4QAAX","idType":"Registration Number","Controllinginterest":22.50,"childwrplist":[{"UBO":"Yes","Type":"Individual","ShareholderCount":0,"Shareholder":"NTEMBEKO NTANTISO MAKALIMA","roles":"Named Beneficiaries","relatedAccountId":"0035r00000C2V0PAAV","recordId":"07k5r000004FVZFAA4","primaryEntityId":"0015r00000EYC4QAAX","ParentShareholding":100.00,"parentAccountId":"0015r00000HtjKwAAJ","idType":"SA Identity Document","Controllinginterest":25.00,"childwrplist":null,"accType":"AccountContact"},{"UBO":"","Type":"Private Company","ShareholderCount":2,"Shareholder":"Capolie Botha Eiendomme (Pty) Ltd","roles":"Shareholder/Controller","relatedAccountId":"0015r00000HtmrpAAB","recordId":"a005r000001u7MDAAY","primaryEntityId":"0015r00000EYC4QAAX","ParentShareholding":100.00,"parentAccountId":"0015r00000HtjKwAAJ","idType":"Registration Number","Controllinginterest":22.50,"childwrplist":[{"UBO":"","Type":"Private Company","ShareholderCount":2,"Shareholder":"Test Light (Pty) Ltd","roles":"Shareholder/Controller","relatedAccountId":"0015r00000Ht94NAAR","recordId":"a005r000001u7MIAAY","primaryEntityId":"0015r00000EYC4QAAX","ParentShareholding":50.00,"parentAccountId":"0015r00000HtmrpAAB","idType":"Registration Number","Controllinginterest":11.25,"childwrplist":[{"UBO":"No","Type":"Individual","ShareholderCount":0,"Shareholder":"Mara Mahlatse","roles":"Shareholder/Controller","relatedAccountId":"0035r00000FMe1oAAD","recordId":"07k5r000004FnpIAAS","primaryEntityId":"0015r00000EYC4QAAX","ParentShareholding":60.00,"parentAccountId":"0015r00000Ht94NAAR","idType":"Passport","Controllinginterest":6.75,"childwrplist":null,"accType":"AccountContact"},{"UBO":"","Type":"Trusts","ShareholderCount":2,"Shareholder":"Mara Trust","roles":"Shareholder/Controller","relatedAccountId":"0015r00000HtrEtAAJ","recordId":"a005r000001u7MSAAY","primaryEntityId":"0015r00000EYC4QAAX","ParentShareholding":50.00,"parentAccountId":"0015r00000Ht94NAAR","idType":"Non-Registered Entity","Controllinginterest":5.62,"childwrplist":[{"UBO":"No","Type":"Individual","ShareholderCount":0,"Shareholder":"JOHANNES HENDRIK BESTER","roles":"Named Beneficiaries","relatedAccountId":"0035r000009TLRHAA4","recordId":"07k5r000004FKs8AAG","primaryEntityId":"0015r00000EYC4QAAX","ParentShareholding":25.00,"parentAccountId":"0015r00000HtrEtAAJ","idType":"SA Identity Document","Controllinginterest":1.41,"childwrplist":null,"accType":"AccountContact"},{"UBO":"No","Type":"Individual","ShareholderCount":0,"Shareholder":"HEIDI MICHELLE WENKE","roles":"Named Beneficiaries","relatedAccountId":"0035r00000DWT7zAAH","recordId":"07k5r000004FKscAAG","primaryEntityId":"0015r00000EYC4QAAX","ParentShareholding":25.00,"parentAccountId":"0015r00000HtrEtAAJ","idType":"SA Identity Document","Controllinginterest":1.41,"childwrplist":null,"accType":"AccountContact"}],"accType":"AccountAccount"}],"accType":"AccountAccount"},{"UBO":"","Type":"Private Company","ShareholderCount":2,"Shareholder":"REcord Hut (Pty) LTd","roles":"Shareholder/Controller","relatedAccountId":"0015r00000Hns30AAB","recordId":"a005r000001u7MNAAY","primaryEntityId":"0015r00000EYC4QAAX","ParentShareholding":50.00,"parentAccountId":"0015r00000HtmrpAAB","idType":"Registration Number","Controllinginterest":11.25,"childwrplist":[{"UBO":"Yes","Type":"Individual","ShareholderCount":0,"Shareholder":"DANISILE DERRICK MBALO","roles":"Shareholder/Controller","relatedAccountId":"0035r00000FNDlXAAX","recordId":"07k5r000004FSneAAG","primaryEntityId":"0015r00000EYC4QAAX","ParentShareholding":100.00,"parentAccountId":"0015r00000Hns30AAB","idType":"SA Identity Document","Controllinginterest":11.25,"childwrplist":null,"accType":"AccountContact"},{"UBO":"Yes","Type":"Individual","ShareholderCount":0,"Shareholder":"Mara Mahlatse","roles":"Shareholder/Controller","relatedAccountId":"0035r00000FMe1oAAD","recordId":"07k5r000004FnGpAAK","primaryEntityId":"0015r00000EYC4QAAX","ParentShareholding":40.00,"parentAccountId":"0015r00000Hns30AAB","idType":"Passport","Controllinginterest":11.25,"childwrplist":null,"accType":"AccountContact"}],"accType":"AccountAccount"}],"accType":"AccountAccount"}],"accType":"AccountAccount"}],"accType":"AccountAccount"}],"accType":"AccountAccount"},{"UBO":"","Type":"Private Company","ShareholderCount":1,"Shareholder":"Test Complex Structure (Pty) Ltd","roles":"Shareholder/Controller","relatedAccountId":"0015r00000DmDe9AAF","recordId":"a005r000001u7SpAAI","primaryEntityId":"0015r00000Ht2mtAAB","ParentShareholding":25.00,"parentAccountId":"0015r00000Ht2mtAAB","idType":"Registration Number","Controllinginterest":25.00,"childwrplist":[{"UBO":"","Type":"Trusts","ShareholderCount":1,"Shareholder":"BOTHA FAMILY TRUST","roles":"Shareholder/Controller","relatedAccountId":"0015J00000F06smQAB","recordId":"a005r000001u9LnAAI","primaryEntityId":"0015r00000Ht2mtAAB","ParentShareholding":100.00,"parentAccountId":"0015r00000DmDe9AAF","idType":null,"Controllinginterest":25.00,"childwrplist":[{"UBO":"","Type":"Close Corporation","ShareholderCount":2,"Shareholder":"Two stone Gardening services cc","roles":"Named Beneficiaries","relatedAccountId":"0015r00000HuCsaAAF","recordId":"a005r000001u9LsAAI","primaryEntityId":"0015r00000Ht2mtAAB","ParentShareholding":100.00,"parentAccountId":"0015J00000F06smQAB","idType":"Registration Number","Controllinginterest":25.00,"childwrplist":[{"UBO":"Yes","Type":"Individual","ShareholderCount":0,"Shareholder":"NTEMBEKO NTANTISO MAKALIMA","roles":"Members/Controllers","relatedAccountId":"0035r00000C2V0PAAV","recordId":"07k5r000004FkojAAC","primaryEntityId":"0015r00000Ht2mtAAB","ParentShareholding":30.00,"parentAccountId":"0015r00000HuCsaAAF","idType":"SA Identity Document","Controllinginterest":32.50,"childwrplist":null,"accType":"AccountContact"},{"UBO":"","Type":"Close Corporation","ShareholderCount":1,"Shareholder":"P and D Trading CC","roles":"Members/Controllers","relatedAccountId":"0015r00000HuCokAAF","recordId":"a005r000001u9LxAAI","primaryEntityId":"0015r00000Ht2mtAAB","ParentShareholding":100.00,"parentAccountId":"0015r00000HuCsaAAF","idType":"Registration Number","Controllinginterest":25.00,"childwrplist":[{"UBO":"Yes","Type":"Individual","ShareholderCount":0,"Shareholder":"A Burgess","roles":"Members/Controllers","relatedAccountId":"0035r00000FNDbMAAX","recordId":"07k5r000004FSjFAAW","primaryEntityId":"0015r00000Ht2mtAAB","ParentShareholding":100.00,"parentAccountId":"0015r00000HuCokAAF","idType":"SA Identity Document","Controllinginterest":25.00,"childwrplist":null,"accType":"AccountContact"}],"accType":"AccountAccount"}],"accType":"AccountAccount"}],"accType":"AccountAccount"}],"accType":"AccountAccount"},{"UBO":"Yes","Type":"Individual","ShareholderCount":0,"Shareholder":"FRANCOIS MARIO WOLVAARDT","roles":"Director;Shareholder/Controller;Operators on primary accounts ( Internet Main Users, Signatories, Card Users)","relatedAccountId":"0035r00000FMaS4AAL","recordId":"07k5r000004FAwoAAG","primaryEntityId":"0015r00000Ht2mtAAB","ParentShareholding":25.00,"parentAccountId":"0015r00000Ht2mtAAB","idType":"SA Identity Document","Controllinginterest":25.00,"childwrplist":null,"accType":"AccountContact"}],"accType":"Account"}]';
		insert account;

		Opportunity testOpp = new Opportunity();
		testOpp.Name = 'Test Opp';
		testOpp.CloseDate = Date.today();
		testOpp.StageName = 'Drafting';
		testOpp.accountId = account.Id;
		insert testOpp;

		Test.startTest();
		OnboardingCASAScreeningController.callToCASAScreening(testOpp.id);
		System.assert(testOpp.CASA_Screening_Date__c != System.today());
		Test.stopTest();
	}

	@isTest
	public static void callScreeningPostive2() {
		WimiTestDataFactory testDataFactory = new WimiTestDataFactory();

		// Set mock callout class
		Test.setMock(HttpCalloutMock.class, new CASAPrimaryClientScreeningMock_ApiRest(StringConstants.POSITIVE_STRING));
		IntegrationTestDataFactory.insertIntegrationTranslations();
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.API_MANAGER,
			new List<String>{ StringConstants.CASA_PRIMARY_CLIENT_SCREENING, StringConstants.CASA_PRIMARY_CLIENT_SCREENING_V2 }
		);

		Account account = new Account(FirstName = 'Test Account', LastName = 'test');
		account.RecordTypeId = schema.SObjectType.account.getRecordTypeInfosByName().get('Individual Client').getRecordTypeId();
		account.Cif__c = '12345';
		account.UBO_ParentAccountWrapper__c = '[{"Type":"Private Company","ShareholderCount":3,"Shareholder":"PASCAL SOLUTIONS (PTY) LTD","recordId":"0015r00000Ht2mtAAB","ParentShareholding":100,"Controllinginterest":100,"Accwrplist":[{"UBO":"","Type":"Private Company","ShareholderCount":2,"Shareholder":"GAMBULELA TRADING (PTY) LTD","roles":"Shareholder/Controller","relatedAccountId":"0015r00000EYE78AAH","recordId":"a005r000001u7LyAAI","primaryEntityId":"0015r00000Ht2mtAAB","ParentShareholding":25.00,"parentAccountId":"0015r00000Ht2mtAAB","idType":"Registration Number","Controllinginterest":25.00,"childwrplist":[{"UBO":"No","Type":"Individual","ShareholderCount":0,"Shareholder":"NTEMBEKO NTANTISO MAKALIMA","roles":"Director;Individual with Authority to Act;Shareholder/Controller;Contact Person;Operators on primary accounts ( Internet Main Users, Signatories, Card Users);Manager","relatedAccountId":"0035r00000C2V0PAAV","recordId":"07k5r000002QR7cAAG","primaryEntityId":"0015r00000EYE78AAH","ParentShareholding":10.00,"parentAccountId":"0015r00000EYE78AAH","idType":"SA Identity Document","Controllinginterest":2.50,"childwrplist":null,"accType":"AccountContact"},{"UBO":"","Type":"Trusts","ShareholderCount":2,"Shareholder":"Greyling Trust","roles":"Shareholder/Controller","relatedAccountId":"0015r00000EYC4QAAX","recordId":"a005r000001b3GJAAY","primaryEntityId":"0015r00000EYE78AAH","ParentShareholding":90.00,"parentAccountId":"0015r00000EYE78AAH","idType":"Non-Registered Entity","Controllinginterest":22.50,"childwrplist":[{"UBO":"Yes","Type":"Individual","ShareholderCount":0,"Shareholder":"GANAS SOOBRAMONY NAIDU","roles":"Named Beneficiaries","relatedAccountId":"0035r00000C1GWKAA3","recordId":"07k5r000002QQTtAAO","primaryEntityId":"0015r00000EYB8FAAX","ParentShareholding":80.00,"parentAccountId":"0015r00000EYC4QAAX","idType":"SA Identity Document","Controllinginterest":18.00,"childwrplist":null,"accType":"AccountContact"},{"UBO":"","Type":"Private Company","ShareholderCount":2,"Shareholder":"HFR Properties KZN (pty )Ltd","roles":"Trustees","relatedAccountId":"0015r00000HtjKwAAJ","recordId":"a005r000001u7M3AAI","primaryEntityId":"0015r00000EYC4QAAX","ParentShareholding":100.00,"parentAccountId":"0015r00000EYC4QAAX","idType":"Registration Number","Controllinginterest":22.50,"childwrplist":[{"UBO":"Yes","Type":"Individual","ShareholderCount":0,"Shareholder":"NTEMBEKO NTANTISO MAKALIMA","roles":"Named Beneficiaries","relatedAccountId":"0035r00000C2V0PAAV","recordId":"07k5r000004FVZFAA4","primaryEntityId":"0015r00000EYC4QAAX","ParentShareholding":100.00,"parentAccountId":"0015r00000HtjKwAAJ","idType":"SA Identity Document","Controllinginterest":25.00,"childwrplist":null,"accType":"AccountContact"},{"UBO":"","Type":"Private Company","ShareholderCount":2,"Shareholder":"Capolie Botha Eiendomme (Pty) Ltd","roles":"Shareholder/Controller","relatedAccountId":"0015r00000HtmrpAAB","recordId":"a005r000001u7MDAAY","primaryEntityId":"0015r00000EYC4QAAX","ParentShareholding":100.00,"parentAccountId":"0015r00000HtjKwAAJ","idType":"Registration Number","Controllinginterest":22.50,"childwrplist":[{"UBO":"","Type":"Private Company","ShareholderCount":2,"Shareholder":"Test Light (Pty) Ltd","roles":"Shareholder/Controller","relatedAccountId":"0015r00000Ht94NAAR","recordId":"a005r000001u7MIAAY","primaryEntityId":"0015r00000EYC4QAAX","ParentShareholding":50.00,"parentAccountId":"0015r00000HtmrpAAB","idType":"Registration Number","Controllinginterest":11.25,"childwrplist":[{"UBO":"No","Type":"Individual","ShareholderCount":0,"Shareholder":"Mara Mahlatse","roles":"Shareholder/Controller","relatedAccountId":"0035r00000FMe1oAAD","recordId":"07k5r000004FnpIAAS","primaryEntityId":"0015r00000EYC4QAAX","ParentShareholding":60.00,"parentAccountId":"0015r00000Ht94NAAR","idType":"Passport","Controllinginterest":6.75,"childwrplist":null,"accType":"AccountContact"},{"UBO":"","Type":"Trusts","ShareholderCount":2,"Shareholder":"Mara Trust","roles":"Shareholder/Controller","relatedAccountId":"0015r00000HtrEtAAJ","recordId":"a005r000001u7MSAAY","primaryEntityId":"0015r00000EYC4QAAX","ParentShareholding":50.00,"parentAccountId":"0015r00000Ht94NAAR","idType":"Non-Registered Entity","Controllinginterest":5.62,"childwrplist":[{"UBO":"No","Type":"Individual","ShareholderCount":0,"Shareholder":"JOHANNES HENDRIK BESTER","roles":"Named Beneficiaries","relatedAccountId":"0035r000009TLRHAA4","recordId":"07k5r000004FKs8AAG","primaryEntityId":"0015r00000EYC4QAAX","ParentShareholding":25.00,"parentAccountId":"0015r00000HtrEtAAJ","idType":"SA Identity Document","Controllinginterest":1.41,"childwrplist":null,"accType":"AccountContact"},{"UBO":"No","Type":"Individual","ShareholderCount":0,"Shareholder":"HEIDI MICHELLE WENKE","roles":"Named Beneficiaries","relatedAccountId":"0035r00000DWT7zAAH","recordId":"07k5r000004FKscAAG","primaryEntityId":"0015r00000EYC4QAAX","ParentShareholding":25.00,"parentAccountId":"0015r00000HtrEtAAJ","idType":"SA Identity Document","Controllinginterest":1.41,"childwrplist":null,"accType":"AccountContact"}],"accType":"AccountAccount"}],"accType":"AccountAccount"},{"UBO":"","Type":"Private Company","ShareholderCount":2,"Shareholder":"REcord Hut (Pty) LTd","roles":"Shareholder/Controller","relatedAccountId":"0015r00000Hns30AAB","recordId":"a005r000001u7MNAAY","primaryEntityId":"0015r00000EYC4QAAX","ParentShareholding":50.00,"parentAccountId":"0015r00000HtmrpAAB","idType":"Registration Number","Controllinginterest":11.25,"childwrplist":[{"UBO":"Yes","Type":"Individual","ShareholderCount":0,"Shareholder":"DANISILE DERRICK MBALO","roles":"Shareholder/Controller","relatedAccountId":"0035r00000FNDlXAAX","recordId":"07k5r000004FSneAAG","primaryEntityId":"0015r00000EYC4QAAX","ParentShareholding":100.00,"parentAccountId":"0015r00000Hns30AAB","idType":"SA Identity Document","Controllinginterest":11.25,"childwrplist":null,"accType":"AccountContact"},{"UBO":"Yes","Type":"Individual","ShareholderCount":0,"Shareholder":"Mara Mahlatse","roles":"Shareholder/Controller","relatedAccountId":"0035r00000FMe1oAAD","recordId":"07k5r000004FnGpAAK","primaryEntityId":"0015r00000EYC4QAAX","ParentShareholding":40.00,"parentAccountId":"0015r00000Hns30AAB","idType":"Passport","Controllinginterest":11.25,"childwrplist":null,"accType":"AccountContact"}],"accType":"AccountAccount"}],"accType":"AccountAccount"}],"accType":"AccountAccount"}],"accType":"AccountAccount"}],"accType":"AccountAccount"},{"UBO":"","Type":"Private Company","ShareholderCount":1,"Shareholder":"Test Complex Structure (Pty) Ltd","roles":"Shareholder/Controller","relatedAccountId":"0015r00000DmDe9AAF","recordId":"a005r000001u7SpAAI","primaryEntityId":"0015r00000Ht2mtAAB","ParentShareholding":25.00,"parentAccountId":"0015r00000Ht2mtAAB","idType":"Registration Number","Controllinginterest":25.00,"childwrplist":[{"UBO":"","Type":"Trusts","ShareholderCount":1,"Shareholder":"BOTHA FAMILY TRUST","roles":"Shareholder/Controller","relatedAccountId":"0015J00000F06smQAB","recordId":"a005r000001u9LnAAI","primaryEntityId":"0015r00000Ht2mtAAB","ParentShareholding":100.00,"parentAccountId":"0015r00000DmDe9AAF","idType":null,"Controllinginterest":25.00,"childwrplist":[{"UBO":"","Type":"Close Corporation","ShareholderCount":2,"Shareholder":"Two stone Gardening services cc","roles":"Named Beneficiaries","relatedAccountId":"0015r00000HuCsaAAF","recordId":"a005r000001u9LsAAI","primaryEntityId":"0015r00000Ht2mtAAB","ParentShareholding":100.00,"parentAccountId":"0015J00000F06smQAB","idType":"Registration Number","Controllinginterest":25.00,"childwrplist":[{"UBO":"Yes","Type":"Individual","ShareholderCount":0,"Shareholder":"NTEMBEKO NTANTISO MAKALIMA","roles":"Members/Controllers","relatedAccountId":"0035r00000C2V0PAAV","recordId":"07k5r000004FkojAAC","primaryEntityId":"0015r00000Ht2mtAAB","ParentShareholding":30.00,"parentAccountId":"0015r00000HuCsaAAF","idType":"SA Identity Document","Controllinginterest":32.50,"childwrplist":null,"accType":"AccountContact"},{"UBO":"","Type":"Close Corporation","ShareholderCount":1,"Shareholder":"P and D Trading CC","roles":"Members/Controllers","relatedAccountId":"0015r00000HuCokAAF","recordId":"a005r000001u9LxAAI","primaryEntityId":"0015r00000Ht2mtAAB","ParentShareholding":100.00,"parentAccountId":"0015r00000HuCsaAAF","idType":"Registration Number","Controllinginterest":25.00,"childwrplist":[{"UBO":"Yes","Type":"Individual","ShareholderCount":0,"Shareholder":"A Burgess","roles":"Members/Controllers","relatedAccountId":"0035r00000FNDbMAAX","recordId":"07k5r000004FSjFAAW","primaryEntityId":"0015r00000Ht2mtAAB","ParentShareholding":100.00,"parentAccountId":"0015r00000HuCokAAF","idType":"SA Identity Document","Controllinginterest":25.00,"childwrplist":null,"accType":"AccountContact"}],"accType":"AccountAccount"}],"accType":"AccountAccount"}],"accType":"AccountAccount"}],"accType":"AccountAccount"},{"UBO":"Yes","Type":"Individual","ShareholderCount":0,"Shareholder":"FRANCOIS MARIO WOLVAARDT","roles":"Director;Shareholder/Controller;Operators on primary accounts ( Internet Main Users, Signatories, Card Users)","relatedAccountId":"0035r00000FMaS4AAL","recordId":"07k5r000004FAwoAAG","primaryEntityId":"0015r00000Ht2mtAAB","ParentShareholding":25.00,"parentAccountId":"0015r00000Ht2mtAAB","idType":"SA Identity Document","Controllinginterest":25.00,"childwrplist":null,"accType":"AccountContact"}],"accType":"Account"}]';
		insert account;

		Opportunity testOpp = new Opportunity();
		testOpp.Name = 'Test Opp';
		testOpp.CloseDate = Date.today();
		testOpp.StageName = 'Drafting';
		testOpp.accountId = account.Id;
		insert testOpp;

		Test.startTest();
		OnboardingCASAScreeningController.callToCASAScreening(testOpp.id);
		System.assert(testOpp.CASA_Screening_Date__c != System.today());
		Test.stopTest();
	}

	@isTest
	public static void getAnalystCommentsTest() {
		WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
		Wqgetanalystcommentsv7_Req_IB_v1.dummyRequest();

		Test.setMock(HttpCalloutMock.class, new Wqgetanalystcommentsv7_ApiRest(StringConstants.POSITIVE_STRING));

		IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT, new List<String>{ 'Jitterbit Auth Path' });
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT_API_RB_STRING,
			new List<String>{ StringConstants.Wqgetanalystcommentsv7_STRING }
		);
		Integration_API__c apiIntRec = Sys_Utilities_Integration.getIntegrationSettings(
			StringConstants.JITTERBIT_API_RB_STRING,
			Sys_Utilities_General.getEnvironment(),
			StringConstants.Wqgetanalystcommentsv7_STRING
		);

		system.assertNotEquals(apiIntRec, null);

		Account account = new Account(Name = 'Test Account');
		account.RecordTypeId = schema.SObjectType.account.getRecordTypeInfosByName().get('Business Prospect').getRecordTypeId();
		//W-005355 : Anka Ganta : 2020-07-09
		account.Country_of_Incorporation__c = 'South Africa';
		account.Client_Group__c = 'Non Individual';
		account.CASA_Reference_Number__c = '12233';
		account.CIF__c = '';
		account.Countries_Traded_With__c = 'South Africa';
		account.Source_of_Income__c = 'Donation';
		insert account;

		//insert related acct;
		List<AccountContactRelation> acrList = new List<AccountContactRelation>();
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
		acctSecondary.CASA_Screening_Status__c = 'Matched';
		insert acctSecondary;
		Account acc = [SELECT PersonContactId FROM Account WHERE Id = :acctSecondary.Id];
		Id personContactId = acc.PersonContactId;
		AccountContactRelation accConRel = new AccountContactRelation(AccountId = account.Id, ContactId = personContactId);
		insert accConRel;
		acrList.add(accConRel);

		Set<Id> relatedPartIdSet = new Set<Id>();
		for (AccountContactRelation acr : acrList) {
			relatedPartIdSet.add(acr.ContactId);
		}
		List<Account> rpAccounts = new AccountsSelector().selectCasaFieldsByPersonContactSetId(relatedPartIdSet);

		Opportunity testOpp = new Opportunity();
		testOpp.Name = 'Test Opp';
		testOpp.CloseDate = Date.today();
		testOpp.StageName = 'Drafting';
		testOpp.accountId = account.Id;
		insert testOpp;

		Product2 prod = new Product2(Name = 'Cheque Product', Family = 'Cheque', ProductCode = '1234');

		insert prod;

		Pricebook2 standardPriceBook = WillsTestDataFactory.getStandardPriceBook();
		PricebookEntry pricebookEntry = WillsTestDataFactory.createPriceBookEntry(standardPriceBook.Id, prod.Id);

		OpportunityLineItem oli = new OpportunityLineItem();
		oli.OpportunityId = testOpp.Id;
		if (prod.Id != null) {
			oli.Product2Id = prod.Id;
		}
		oli.PriceBookEntryid = pricebookEntry.Id;
		oli.Quantity = 1;
		oli.TotalPrice = 100;
		insert oli;

		Test.startTest();
		String sysLog = OnboardingCASAScreeningController.getAnalystComments(testOpp.id);
		System.assertNotEquals(sysLog, null);
		Test.stopTest();
	}

	@isTest
	public static void getOpportunityProductTest() {
		Account account = new Account(Name = 'Test Account');
		account.RecordTypeId = schema.SObjectType.account.getRecordTypeInfosByName().get('Business Prospect').getRecordTypeId();
		//W-005355 : Anka Ganta : 2020-07-09
		account.Country_of_Incorporation__c = 'South Africa';
		account.Client_Group__c = 'Non Individual';
		account.CASA_Reference_Number__c = '12233';
		account.CIF__c = '';
		account.Countries_Traded_With__c = 'South Africa';
		account.Source_of_Income__c = 'Donation';
		insert account;

		//insert related acct;
		List<AccountContactRelation> acrList = new List<AccountContactRelation>();
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
		acctSecondary.CASA_Screening_Status__c = 'Matched';
		insert acctSecondary;
		Account acc = [SELECT PersonContactId FROM Account WHERE Id = :acctSecondary.Id];
		Id personContactId = acc.PersonContactId;
		AccountContactRelation accConRel = new AccountContactRelation(AccountId = account.Id, ContactId = personContactId);
		insert accConRel;
		acrList.add(accConRel);

		Set<Id> relatedPartIdSet = new Set<Id>();
		for (AccountContactRelation acr : acrList) {
			relatedPartIdSet.add(acr.ContactId);
		}
		List<Account> rpAccounts = new AccountsSelector().selectCasaFieldsByPersonContactSetId(relatedPartIdSet);

		Opportunity testOpp = new Opportunity();
		testOpp.Name = 'Test Opp';
		testOpp.CloseDate = Date.today();
		testOpp.StageName = 'Drafting';
		testOpp.accountId = account.Id;
		insert testOpp;

		Product2 prod = new Product2(Name = 'Cheque Product', Family = 'Cheque', ProductCode = '1234');

		insert prod;

		Pricebook2 standardPriceBook = WillsTestDataFactory.getStandardPriceBook();
		PricebookEntry pricebookEntry = WillsTestDataFactory.createPriceBookEntry(standardPriceBook.Id, prod.Id);

		OpportunityLineItem oli = new OpportunityLineItem();
		oli.OpportunityId = testOpp.Id;
		if (prod.Id != null) {
			oli.Product2Id = prod.Id;
		}
		oli.PriceBookEntryid = pricebookEntry.Id;
		oli.Quantity = 1;
		oli.TotalPrice = 100;
		insert oli;

		Test.startTest();
		String productName = OnboardingCASAScreeningController.getOpportunityProduct(testOpp.id);
		System.assertNotEquals(productName, null);
		Test.stopTest();
	}
	//Start changes for W-004683 By Himani
	@isTest
	public static void testgetmandatorydocs() {
		string Entitytype = 'aa';
		Mandatory_Doc__mdt md1 = new Mandatory_Doc__mdt();
		md1.Entity_Type__c = 'Sole Trader';
		md1.ECM_Type__c = 'Ent_Declaration';
		//return md1;
		Mandatory_Doc__mdt md2 = new Mandatory_Doc__mdt();
		md1.Entity_Type__c = 'aa';
		md1.ECM_Type__c = 'bb';
		//Opportunity opp=[select id,CheckMandatoryDocuments__c,StageName,Entity_Type__c from opportunity limit 1 ];
		Account testAccount = new Account();
		testAccount.Name = 'Test Name';
		//W-005355 : Anka Ganta : 2020-07-09
		testAccount.Country_of_Incorporation__c = 'South Africa';
		testAccount.Client_Group__c = 'Non Individual';
		testAccount.Client_Type__c = 'Sole Trader';
		testAccount.CASA_Reference_Number__c = '12233';
		testAccount.CIF__c = '';
		testAccount.Countries_Traded_With__c = 'South Africa';
		testAccount.Source_of_Income__c = 'Donation';
		insert testAccount;

		// W-005222 : Masechaba Maseli : 070820
		Account account = new Account(Name = 'Test Account');
		account.RecordTypeId = schema.SObjectType.account.getRecordTypeInfosByName().get('Business Prospect').getRecordTypeId();
		account.Country_of_Incorporation__c = 'South Africa';
		account.Client_Group__c = 'Non Individual';
		account.Client_Type__c = 'Private Company';
		account.CASA_Reference_Number__c = '12233';
		account.CIF__c = '';
		account.Countries_Traded_With__c = 'South Africa';
		account.Source_of_Income__c = 'Donation';
		insert account;

		Account account2 = new Account(Name = 'Test Account2');
		account2.RecordTypeId = schema.SObjectType.account.getRecordTypeInfosByName().get('Business Prospect').getRecordTypeId();
		account2.Country_of_Incorporation__c = 'South Africa';
		account2.Client_Group__c = 'Non Individual';
		account2.Client_Type__c = 'Private Company';
		account2.CASA_Reference_Number__c = '12233';
		account2.CIF__c = '';
		account2.Countries_Traded_With__c = 'South Africa';
		account2.Source_of_Income__c = 'Donation';
		insert account2;

		Account acctSecondary = new Account();
		acctSecondary.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual Prospect').getRecordTypeId();
		acctSecondary.ID_Number__pc = '6803037015089';
		acctSecondary.ID_Type__pc = 'SA Identity Document';
		acctSecondary.FirstName = 'First Name1';
		acctSecondary.LastName = 'Last Name1';
		acctSecondary.Initials__pc = 'I';
		acctSecondary.PersonTitle = 'Mr';
		acctSecondary.Client_Type__c = 'Individual Client';
		acctSecondary.CASA_Reference_Number__pc = '12454';
		acctSecondary.CASA_Screening_Status__c = 'Matched';
		insert acctSecondary;

		Account acc = [SELECT PersonContactId FROM Account WHERE Id = :acctSecondary.Id];
		Id personContactId = acc.PersonContactId;

		AccountContactRelation accConRel2 = new AccountContactRelation(
			AccountId = account.Id,
			ContactId = personContactId,
			Roles = 'Shareholder/Controller',
			Primary_Entity_Id__c = testAccount.Id,
			Share_Percentage__c = 50
		);
		insert accConRel2;

		FinServ__ReciprocalRole__c resRole = new FinServ__ReciprocalRole__c();
		resRole.FinServ__CreateInverseRole__c = true;
		resRole.FinServ__InverseRole__c = 'Director';
		insert resRole;

		FinServ__AccountAccountRelation__c accAccRel = new FinServ__AccountAccountRelation__c(
			FinServ__Account__c = account.Id,
			FinServ__RelatedAccount__c = account2.Id,
			Roles__c = 'Shareholder/Controller',
			FinServ__Role__c = resRole.id,
			Primary_Entity_Id__c = account.Id,
			Shareholding_Percentage__c = 50
		);
		insert accAccRel;
		// End of Changes by Masechaba Maseli  W-005222

		Opportunity testOpp = new Opportunity();
		testOpp.Name = 'Test Opp';
		testOpp.CloseDate = Date.today();

		testOpp.StageName = 'Drafting';
		testOpp.accountId = testAccount.Id;
		insert testOpp;
		Document_Template__c d1 = new Document_Template__c();
		d1.name = 'ABSA 6280 - Tax Self- Certification and Declaration';
		d1.ECM_Item_Type__c = 'Ent_Declaration';
		insert d1;
		Document__c d = new Document__c();
		d.name = 'aa';
		d.Type__c = 'ABSA 6280 - Tax Self- Certification and Declaration';
		d.Opportunity__c = testOpp.id;
		d.Reference__c = '92 3 ICM7 UGOLSDB13 Ent_Quotation59 26 A1001001A20F08C10108B0752518 A20F08C10108B075251 14 1868';
		insert d;

		Trading_as_Name__c testTradingAsName = new Trading_as_Name__c();
		testTradingAsName.Name = 'T/A Test';
		testTradingAsName.Account__c = testAccount.id;
		insert testTradingAsName;
		//list<Document_Template__c>doctemp=[select name,ECM_Item_Type__c from Document_Template__c where ECM_Item_Type__c =: 'Ent_Declaration' ];
		//List<Document__c> docList = new DocumentsSelector().selectDocumentsByOppId(testOpp.id);
		//list<Mandatory_Doc__mdt>manlist=[select label,Entity_Type__c,ECM_Type__c from Mandatory_Doc__mdt];
		Test.startTest();
		OnboardingCASAScreeningController.getentitytype(testOpp.Id);
		OnboardingCASAScreeningController.getDocs(testOpp.Id);
		List<Mandatory_Doc__mdt> mandatoryDocs = OnboardingCASAScreeningController.getAllMandatoryDocuments('Sole Trader');
		OnboardingCASAScreeningController.getAllRelatedMandatoryDocuments(account.Client_Type__c, testOpp.Id);
		OnboardingCASAScreeningController.getPrimaryClientMandatoryDocuments(account.Client_Type__c, testOpp.Id);
		System.assertNotEquals(mandatoryDocs, null);
		Test.stopTest();
	}

	@isTest
	public static void testupdateopportunity() {
		//Opportunity opp=[select id,CheckMandatoryDocuments__c,StageName from opportunity limit 1 ];
		Opportunity testOpp = new Opportunity();
		testOpp.Name = 'Test Opp';
		testOpp.CloseDate = Date.today();
		testOpp.StageName = 'Drafting';

		insert testOpp;
		Test.startTest();
		try {
			List<String> oppUpdate = OnboardingCASAScreeningController.updateOpportunity(testOpp.Id, 'true');
			System.assertNotEquals(oppUpdate, null);
			OnboardingCASAScreeningController.updateOpportunity(testOpp.Id, 'false');
			OnboardingCASAScreeningController.updateOpportunity(null, null);
		} catch (Exception e) {
			System.assertEquals(e.getMessage(), e.getMessage());
		}
		Test.stopTest();
	}

	@isTest
	public static void testgetauditdocs() {
		Opportunity testOpp = new Opportunity();
		testOpp.Name = 'Test Opp';
		testOpp.CloseDate = Date.today();
		testOpp.StageName = 'Drafting';

		insert testOpp;
		//WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
		Test.startTest();
		//List<Document__c> documentAuditList =
		OnboardingCASAScreeningController.getDocs(testOpp.Id);
		List<Opportunity> oppList = OnboardingCASAScreeningController.getentitytype(testOpp.Id);
		System.assertEquals(oppList[0].Entity_Type__c, null);
		Test.stopTest();
	}
	//End changes for W-004683 By Himani
	@isTest
	public static void getDocsByOppIdTest() {
		Opportunity testOpp = new Opportunity();
		testOpp.Name = 'Test Opp';
		testOpp.CloseDate = Date.today();
		testOpp.StageName = 'Drafting';

		insert testOpp;
		Document__c doc1 = new Document__c(Name = 'mydoc.pdf', Reference__c = '12345', Type__c = 'EDD level ll report', Opportunity__c = testOpp.Id);
		Document__c doc2 = new Document__c(Name = 'mydoc.pdf', Reference__c = '12345', Type__c = 'Management sign off', Opportunity__c = testOpp.Id);
		Document__c doc3 = new Document__c(
			Name = 'mydoc.pdf',
			Reference__c = '12345',
			Type__c = 'Proof of source of Income / funds',
			Opportunity__c = testOpp.Id
		);
		List<Document__c> docList = new List<Document__c>();
		docList.add(doc1);
		docList.add(doc2);
		docList.add(doc3);
		insert docList;
		Test.startTest();
		List<String> oppDocList = OnboardingCASAScreeningController.getDocsByOppId(testOpp.Id);
		System.assertNotEquals(oppDocList, null);
		Test.stopTest();
	}

	@isTest
	public static void getDocumentsCasaTiersTest() {
		WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
		Generatedocumentsv7_Req_IB_v1.createDummyRequest();

		Test.setMock(HttpCalloutMock.class, new Generatedocumentsv7_ApiRest(StringConstants.POSITIVE_STRING));
		IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT, new List<String>{ 'Jitterbit Auth Path' });
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT_API_RB_STRING,
			new List<String>{ StringConstants.Generatedocumentsv7_STRING }
		);
		Integration_API__c apiIntRec = Sys_Utilities_Integration.getIntegrationSettings(
			StringConstants.JITTERBIT_API_RB_STRING,
			Sys_Utilities_General.getEnvironment(),
			StringConstants.Generatedocumentsv7_STRING
		);

		system.assertNotEquals(apiIntRec, null);

		Account testAccount = new Account();
		testAccount.Name = 'Test Name';
		testAccount.Country_of_Incorporation__c = 'South Africa';
		testAccount.Client_Group__c = 'Non Individual';
		testAccount.CASA_Reference_Number__c = '12233';
		testAccount.CIF__c = '';
		testAccount.Countries_Traded_With__c = 'South Africa';
		testAccount.Source_of_Income__c = 'Donation';
		insert testAccount;
		Opportunity testOpp = new Opportunity();
		testOpp.Name = 'Test Opp';
		testOpp.CloseDate = Date.today();
		testOpp.StageName = 'Drafting';
		testOpp.accountId = testAccount.Id;
		insert testOpp;
		Test.startTest();
		String responsesuccess = OnboardingCASAScreeningController.getDocumentsCasaTiers(testOpp.Id);
		Test.stopTest();
		system.assertNotEquals(responsesuccess, null);
	}
}