@isTest
private class OnboardingRiskRatingControllerTest {
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

		//System.debug('** acrList: ' + acrList.size());
		System.assert(acrList.size() > 0);

		Set<Id> relatedPartIdSet = new Set<Id>();
		for (AccountContactRelation acr : acrList) {
			relatedPartIdSet.add(acr.ContactId);
		}
		List<Account> rpAccounts = new AccountsSelector().selectCasaFieldsByPersonContactSetId(relatedPartIdSet);

		//System.debug('rpAccounts++' + rpAccounts);

		Opportunity testOpp = new Opportunity();
		testOpp.Name = 'Test Opp';
		testOpp.CloseDate = Date.today();
		testOpp.StageName = 'Drafting';
		testOpp.accountId = account.Id;
		insert testOpp;

		Product2 prod = new Product2(Name = 'Cheque Product', Family = 'Cheque', ProductCode = '1234');

		insert prod;

		//System.debug('prod' + prod.Id);

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
		OnboardingRiskRatingController.saveRikInfo(testOpp.Id);
		OnboardingRiskRatingController.getAccountData(testOpp.Id);
		OnboardingRiskRatingController.getOpportunityData(testOpp.Id);
		OnboardingRiskRatingController.getAccountRecordType(testOpp.Id);
		OnboardingRiskRatingController.CheckRelatedPartyCasaStatus(testOpp.Id);
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
		insert account;

		Opportunity testOpp = new Opportunity();
		testOpp.Name = 'Test Opp';
		testOpp.CloseDate = Date.today();
		testOpp.StageName = 'Drafting';
		testOpp.accountId = account.Id;
		insert testOpp;

		Product2 prod = new Product2(Name = 'Cheque Product', Family = 'Cheque', ProductCode = '1234');

		insert prod;

		//System.debug('prod' + prod.Id);

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

		System.assert(testOpp != null);

		Test.startTest();
		OnboardingRiskRatingController.saveRikInfo(testOpp.Id);
		OnboardingRiskRatingController.getAccountData(testOpp.Id);
		OnboardingRiskRatingController.getAccountRecordType(testOpp.Id);
		OnboardingRiskRatingController.CheckRelatedPartyCasaStatus(testOpp.Id);
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

		System.assert(account != null);
		OnboardingRiskRatingController.createHighRiskCase(account.id, 'Test1', 'Onboarding', 'PEP');
	}

	@isTest
	public static void testCaseCreationNegative() {
		Account account = new Account(FirstName = 'Test Account', LastName = 'test');
		account.RecordTypeId = schema.SObjectType.account.getRecordTypeInfosByName().get('Individual Client').getRecordTypeId();
		insert account;

		System.assert(account != null);

		try {
			OnboardingRiskRatingController.createHighRiskCase(account.id, null, 'Onboarding', 'High');
		} catch (Exception ex) {
			String msg = ex.getMessage();
			//System.debug(ex);
		}
	}

	@isTest
	public static void testRiskRating() {
		//Test Data
		WimiTestDataFactory testDataFactory = new WimiTestDataFactory();

		// Set mock callout class
		Test.setMock(HttpCalloutMock.class, new GetRiskProfileClientMock_ApiRest(StringConstants.NEGATIVE_STRING));
		IntegrationTestDataFactory.insertIntegrationTranslations();
		IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new List<String>{ StringConstants.GET_RISK_PROFILE_CLIENT });

		System.assert(testDataFactory.testOpportunity != null);
		Test.startTest();

		try {
			OnboardingRiskRatingController.saveRikInfo(testDataFactory.testOpportunity.id);
			OnboardingRiskRatingController.saveCAFRikInfo(testDataFactory.testOpportunity.id);
			OnboardingRiskRatingController.saveRikInfoforSPM(testDataFactory.testOpportunity.id);
		} catch (Exception e) {
			String msg = e.getMessage();
			//System.debug(e.getMessage());
		}

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

		//System.debug('** acrList: ' + acrList.size());

		Set<Id> relatedPartIdSet = new Set<Id>();
		for (AccountContactRelation acr : acrList) {
			relatedPartIdSet.add(acr.ContactId);
		}
		List<Account> rpAccounts = new AccountsSelector().selectCasaFieldsByPersonContactSetId(relatedPartIdSet);

		//System.debug('rpAccounts++' + rpAccounts);

		Opportunity testOpp = new Opportunity();
		testOpp.Name = 'Test Opp';
		testOpp.CloseDate = Date.today();
		testOpp.StageName = 'Drafting';
		testOpp.accountId = account.Id;
		insert testOpp;

		Product2 prod = new Product2(Name = 'Cheque Product', Family = 'Cheque', ProductCode = '1234');

		insert prod;

		//System.debug('prod' + prod.Id);

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
		String productName = OnboardingRiskRatingController.getOpportunityProduct(testOpp.id);
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
		System.assert(testOpp.Id != null);
		Test.startTest();
		OnboardingRiskRatingController.getentitytype(testOpp.Id);
		OnboardingRiskRatingController.getDocs(testOpp.Id);
		OnboardingRiskRatingController.getAllMandatoryDocuments('Sole Trader');
		OnboardingRiskRatingController.getAllRelatedMandatoryDocuments(account.Client_Type__c, testOpp.Id);
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
		System.assert(testOpp.Id != null);
		Test.startTest();
		try {
			OnboardingRiskRatingController.updateOpportunity(testOpp.Id, 'true');
			OnboardingRiskRatingController.updateOpportunity(testOpp.Id, 'false');
			OnboardingRiskRatingController.updateOpportunity(null, null);
		} catch (Exception e) {
			string msg = e.getMessage();
			//System.debug('Exception::' + e.getMessage());
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

		System.assert(testOpp.Id != null);
		//WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
		Test.startTest();
		//List<Document__c> documentAuditList =
		OnboardingRiskRatingController.getDocs(testOpp.Id);
		OnboardingRiskRatingController.getentitytype(testOpp.Id);
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
		System.assert(testOpp.Id != null);
		Test.startTest();
		OnboardingRiskRatingController.getDocsByOppId(testOpp.Id);
		OnboardingRiskRatingController.getPartcicpantAccountData(testOpp.Id);
		Test.stopTest();
	}

	@isTest 
    public static void testEDDCaseCreation(){
        Account account = new Account(FirstName = 'Test Account',LastName = 'test');
        account.RecordTypeId = schema.SObjectType.account.getRecordTypeInfosByName().get('Individual Client').getRecordTypeId();
        insert account;
        Opportunity testOpp = new Opportunity();
        testOpp.Name = 'Test Opp';
        testOpp.CloseDate = Date.today();
        testOpp.StageName = 'Drafting';
        testOpp.accountId = account.Id;
        insert testOpp;
        Service_Type__c serviceType = new Service_Type__c(Name = 'Test1',
                                                          Case_Record_Type__c = 'New',
                                                          Subtype__c = 'Sample',
                                                          Type__c = 'T01');
        insert serviceType;
        
        BusinessHours businessHr = [SELECT Id FROM BusinessHours LIMIT 1];
        
        Service_Group__c serviceGr = new Service_Group__c(Name = 'Enhanced Due Diligence', Assign_Record_Type__c = 'Email',
                                                          Response_Email_Address__c = 'evg@t.com',
                                                          Queue__c = 'Email',
                                                          Business_Hours__c = businessHr.Id,
                                                          Internal_SLA_Time_Measure__c = 'Hour(s)',
                                                          Internal_SLA_Units__c = '8');
        insert serviceGr;
        
        Service_Level__c serviceLevel = new Service_Level__c(Name = 'Test1', 
                                                             External_SLA_Time_Measure__c = 'Hour(s)',
                                                             External_SLA_Units__c = '8',
                                                             Default_Service_Level__c = true);
        insert serviceLevel;
        
        Service_Group_Type__c serviceGrType = new Service_Group_Type__c(Service_Type__c = serviceType.Id,
                                                                        Service_Group__c = serviceGr.Id,
                                                                        Service_Level__c = serviceLevel.Id);
        insert serviceGrType;
		System.assert(testOpp.Id != null);
		
        OnboardingRiskRatingController.createEDDCaseReason(testOpp.id,'Test case');
                
    }
}