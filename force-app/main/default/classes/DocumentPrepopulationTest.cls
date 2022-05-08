/**
 * @description       :
 * @author            : anka.ganta
 * @group             :
 * @last modified on  : 2021-11-08
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log
 * Ver   Date         Author                         Modification
 * 1.0   07-17-2021      Initial Version
**/

@IsTest
public class DocumentPrepopulationTest{
	public static Map <String, Schema.RecordTypeInfo> TaskRecordTypeMap = Task.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();

	/**
	 * @description dataCreation description
	 *
	 */
	@testSetup
	public static void dataCreation(){
		Account account = new Account();
		account.Name = 'Test Account';
		account.Client_Type__c = 'Private Individual';
		account.CIF__c = 'Test+001';
		insert account;
		Contact contact = new Contact(LastName = 'Test contact', AccountId = account.Id, Email = 'agents@support.co.za');
		insert contact;

		Opportunity testOpp = new Opportunity();
		testOpp.Name = 'Test Opp Onboarding 1';
		testOpp.CloseDate = Date.today();
		testOpp.StageName = 'New';
		testOpp.AccountId = account.Id;
		insert testOpp;

		Product2 prod = new Product2(Name = 'Cheque Product', Family = 'Cheque');
		insert prod;

		Id pricebookId = Test.getStandardPricebookId();

		PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id, UnitPrice = 10000, IsActive = true);
		insert standardPrice;

		Pricebook2 customPB = new Pricebook2(Name = 'Standard Pricebook', isActive = true);
		insert customPB;

		PricebookEntry customPrice = new PricebookEntry(Pricebook2Id = customPB.Id, Product2Id = prod.Id, UnitPrice = 12000, IsActive = true);
		insert customPrice;

		OpportunityLineItem oppLineItem = new OpportunityLineItem();
		oppLineItem.OpportunityId = testOpp.id;
		oppLineItem.Product2Id = prod.id;
		oppLineItem.PricebookEntryId = customPrice.id;
		oppLineItem.Quantity = 1;
		oppLineItem.TotalPrice = 100;
		insert oppLineItem;

		Application__c app = new Application__c();
		app.Opportunity__c = testOpp.id;
		app.All_transaction_type__c = '';
		app.Payment__c = '';
		app.Withdrawal__c = '';
		app.Deposit__c = '';
		app.Returned_Transactions__c = '';
		app.Scheduled_transaction__c = '';
		app.Notification_time__c = Date.today();
		app.Minimum_amount__c = '';
		app.Account_to_be_debited_monthly_with_the_c__c = '';
		app.Number_of_authorisations_that_will_be_re__c = '';
		app.Number_of_main_users__c = '';
		app.Fee_Structure_code__c = '';
		app.Absa_online_for_business_BIB__c = '';
		app.Cell_phone_banking__c = '';
		app.Telephone_banking__c = '';
		app.Notifyme__c = '';
		app.Funds_transfer__c = '';
		app.Bill_payments__c = '';
		app.Own_defined_payments__c = '';
		app.Future_dated_payments__c = '';
		app.Stop_order_payments__c = '';
		app.Account_Access__c = 'Cellphone';
		app.Foreign_Services__c = 'Currency Swap (Hedging Instruments)';
		app.Surplus_Cash__c = 'Fixed Deposits';
		app.Borrowing_Requiment_General__c = 'Credit Card';
		app.Borrowing_requiment_Assest_Acquisition__c = 'Business-BACKED Property Finance';
		app.Protection_Of_Services__c = 'Retirement';
		app.Title__c = 'dd';
		app.FirstNameSignature__c = 'Litha';
		app.SurnameSignature__c = 'Nosekeleza';
		app.Signing_Date__c = System.today();
		insert app;

		Account testJointAccount = new Account();
		testJointAccount.Name = 'TEST MR JA & TEST MRS J';
		testJointAccount.Client_Type__c = 'Joint & Several';
		testJointAccount.CASA_Reference_Number__c = '1712994';
		testJointAccount.CASA_Risk_Status__c = 'Low';
		testJointAccount.CASA_Screening_Date__c = Date.valueOf('2018-06-30');
		testJointAccount.CASA_Screening_Status__c = 'Approved';
		testJointAccount.CASA_Analyst_Comments__c = '30406';
		testJointAccount.Country_of_Registration__c = 'South Africa';
		testJointAccount.CIF__c = 'NAIARA+001';
		insert testJointAccount;

		Contact testContact = new Contact();
		testContact.FirstName = 'Test';
		testContact.LastName = 'Contact';
		testContact.AccountId = account.Id;
		insert testContact;

		AccountContactRelation acr = new AccountContactRelation();
		acr.AccountId = testJointAccount.Id;
		acr.ContactId = testContact.Id;
		insert acr;

		Opportunity opp2 = new Opportunity();
		opp2.Name = 'Onboarding';
		opp2.CloseDate = Date.today();
		opp2.StageName = 'New';
		opp2.AccountId = account.Id;
		insert opp2;

		Opportunity opp3 = new Opportunity();
		opp3.Name = 'Sales';
		opp3.CloseDate = Date.today();
		opp3.StageName = 'New';
		opp3.AccountId = account.Id;
		insert opp3;

		Opportunity opp = new Opportunity(Name = 'my opportunity');
		opp.CloseDate = Date.today();
		opp.StageName = 'Drafting';
		insert opp;

		Document__c doc = new Document__c(Name = 'mydoc.pdf', Reference__c = '12345', Opportunity__c = opp.Id);
		insert doc;

		Document__c doc2 = new Document__c(Name = 'mydoc2.pdf', Reference__c = '123456', Opportunity__c = opp.Id);
		insert doc2;

		Document_Template__c dt = new Document_Template__c(Name = 'Absa 3741 Client Engagement', Client_Type__c = 'Private Individual', Document_Type__c = 'Absa 3741 Client Engagement', Parent_Document_Type__c = 'Business Client Agreement', Generate_Document__c = true);
		insert dt;

		Document_Template__c dts = new Document_Template__c(Name = 'Will', Client_Type__c = 'Private Individual', Document_Type__c = 'Will', Parent_Document_Type__c = 'Proof of Address', Generate_Document__c = true);
		insert dts;

		Covenant__c covenant = new Covenant__c();
		covenant.Covenant_Status__c = 'MET';
		covenant.Reason__c = 'reason';
		covenant.Status__c = 'ACTIVE';
		covenant.Covenant_Approved__c = false;
		covenant.Account_Number__c = 1234567890;
		covenant.CPF__c = 'No';
		covenant.Covenant_type__c = 'Debtor Covenant';
		covenant.Frequency__c = 'Monthly';
		covenant.Fromula__c = 'Total debtors, excluding the 120+ category, intercompany';
		covenant.Regions__c = 'CAPE';
		covenant.Required_level__c = 'level';
		insert covenant;
	}

	/**
	 * @description  testGetDocumentAuditEmail description
	 *
	 * testMethodvoid: Return description
	 */
	@IsTest
	public static void testGetDocumentAuditEmail(){
		Opportunity testOpportunity = [SELECT Id, Name
		                               FROM Opportunity
		                               Where Name = 'my opportunity'];

		Covenant__c covenant = [Select id, Covenant_Status__c, Status__c, Reason__c, Covenant_Approved__c
		                        from Covenant__c
		                        LIMIT 1];
		Document__c doc = [Select id, Deleted__c
		                   from Document__c
		                   LIMIT 1];
		Test.startTest();
		DocumentPrepopulation.getSelectedDocumentTemplate('Will');

		List<Document__c> documentAuditList = DocumentPrepopulation.getDocAuditHistoryEmail(testOpportunity.Id);
		Document_Template__c dt = DocumentPrepopulation.getSelectedDocumentTemplate('Will');
		//DocumentPrepopulation.updateDocumentContent(doc.Id);
		system.assert(dt.name != null, 'There must be a will');

		Test.stopTest();
	}

	@IsTest
	private static void ECMLogin(){
		ECM_IH_V1Test.insertSettings();
		Test.startTest();
		ECM_LoginResult_IB_V1 login = DocumentPrepopulation.ECMLogin();
		system.assert(login.token == null, 'login token');
		Test.stopTest();
	}

	@IsTest
	private	static void testGetDocumentsContent(){
		Document__c testDoc = [Select Id
		                       From Document__c
		                       Limit 1];
		ECM_IH_V1Test.insertSettings();
		String body = '{"LoginResult" : {"Status" : "OK", "Details" : "null"}, "Token" : "1234567890"}';
		Test.setMock(HttpCalloutMock.class, new ECM_Mock_ApiRest(body));

		Test.startTest();
		string ss = DocumentPrepopulation.getDocumentContent(testDoc.id);
		system.assert(ss != null, 'getDocumentContent');
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
		 * @description ECM_Mock_ApiRest
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
   /**
	 * @description testgetFileTypePickList
	 *
	 */
	@IsTest
	private static void testgetFileTypePickList(){
		Test.startTest();
		List<String> ss = DocumentPrepopulation.getFileTypePickList();
		system.assert(ss != null, 'Picklist');
		Test.stopTest();
	}
     /**
	 * @description testGetDocumentTemplatesNamePickListValid
	 *
	 */
	@IsTest
	private static void testGetDocumentTemplatesNamePickListValid(){
		Id oppId = [Select Id
		            from Opportunity
		            LIMIT 1].Id;
		Test.startTest();
		List<String> ss = DocumentPrepopulation.getDocumentTemplatesNamePickList(oppId);
		system.assert(ss != null, 'Picklist');
		Test.stopTest();
	}
     /**
	 * @description updateOpportunityAndApplicationTest
	 *
	 */
	@IsTest
	private static void updateOpportunityAndApplicationTest(){
		Opportunity newOppRecord = [SELECT Id, Name
		                            FROM Opportunity
		                            LIMIT 1];
		Application__c applicationRecord = [SELECT Id, CurrencyIsoCode, Fees_Waived__c, individual_s_is_are_authorised_to_act__c, Opportunity__c, Safe_Custody_Is_Required__c, Safe_Custody_Payment_Same_As_Drafting__c, StockServiceTrace__c, TrackerTrace__c, UpdateWillTrace__c
		                                    From Application__c
		                                    LIMIT 1];

		Test.startTest();
		applicationRecord.Signed_at__c = 'Sandton';
		applicationRecord.Signed_on__c = system.today();
		applicationRecord.global_application_form__c = 'YES';
		applicationRecord.Standard_Absa_resolution_for_you__c = 'NO';
		applicationRecord.Absa_mandate_and_indemnity__c = 'YES';
		applicationRecord.Standard_Absa_site_visit_for_you__c = 'NO';
		applicationRecord.Standard_Absa_power_of_attorney_for_you__c = 'YES';
		applicationRecord.Record_of_telephonic_engagement__c = 'NO';
		applicationRecord.Are_all_the_related_parties__c = 'YES';
		applicationRecord.Is_there_more_than_one_natural_person__c = 'NO';
		applicationRecord.Foreign_Exchange_Authority_Form_for_you__c = 'YES';
		applicationRecord.individual_s_is_are_authorised_to_act__c = '1';
		update applicationRecord;

		String applicationId = DocumentPrepopulation.getApplicationId(newOppRecord.id);
		DocumentPrepopulation.getApplicationRecordDetails(newOppRecord.id);
		String recType = DocumentPrepopulation.getApplicationrecordtypeId();
		DocumentPrepopulation.fetchPersonAccList(newOppRecord.id);
		DocumentPrepopulation.saveSiteVisitDetails('FORMAL SETTLEMENT', System.today(), 'BUSINESS', 'firstname', 'surname', UserInfo.getUserId(), applicationRecord.Id, 'Settlement Info');
		DocumentPrepopulation.saveResolutionDetails(applicationRecord.individual_s_is_are_authorised_to_act__c, applicationRecord.Id,'joburg',System.today());
		Application__c applicationRec = DocumentPrepopulation.saveAppDetails(applicationRecord.Signed_at__c, applicationRecord.Signed_on__c,  applicationRecord.Id, userInfo.getUserId());
		System.assert(applicationRecord != null, 'Not null');
		Test.stopTest();
	}
     /**
	 * @description testgetmandatorydocs
	 *
	 */
	@IsTest
	private static void testgetmandatorydocs(){
		string Entitytype = 'aa';
		Mandatory_Doc__mdt md1 = new Mandatory_Doc__mdt();
		md1.Entity_Type__c = 'Sole Trader';
		md1.ECM_Type__c = 'Ent_Declaration';
		Mandatory_Doc__mdt md2 = new Mandatory_Doc__mdt();
		md1.Entity_Type__c = 'aa';
		md1.ECM_Type__c = 'bb';
		Mandatory_Doc__mdt md3 = new Mandatory_Doc__mdt();
		md3.Entity_Type__c = 'Related Party Private Company';
		md3.ECM_Type__c = 'Ent_Declaration';

		Mandatory_Doc__mdt md4 = new Mandatory_Doc__mdt();
		md4.Entity_Type__c = 'UBO';
		md4.ECM_Type__c = 'Ent_Declaration';

		Account testAccount = new Account();
		testAccount.Name = 'Test Name';
		testAccount.Country_of_Registration__c = 'South Africa';
		testAccount.Client_Group__c = 'Non Individual';
		testAccount.Client_Type__c = 'Private Company';
		testAccount.CASA_Reference_Number__c = '12233';
		testAccount.CIF__c = '';
		testAccount.Countries_Traded_With__c = 'South Africa';
		testAccount.Country_of_Registration__c = 'South Africa';
		testAccount.Source_of_Income__c = 'Donation';
		insert testAccount;

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
		Account acc = [SELECT PersonContactId
		               FROM Account
		               WHERE Id = :acctSecondary.Id];
		Id personContactId = acc.PersonContactId;

		AccountContactRelation accConRel = new AccountContactRelation(AccountId = testAccount.Id, ContactId = personContactId, Roles = 'Shareholder/Controller', Primary_Entity_Id__c = testAccount.Id, Share_Percentage__c = 50);
		insert accConRel;

		FinServ__ReciprocalRole__c resRole = new FinServ__ReciprocalRole__c();
		resRole.FinServ__CreateInverseRole__c = true;
		resRole.FinServ__InverseRole__c = 'Director';
		insert resRole;

		FinServ__AccountAccountRelation__c accAccRel = new FinServ__AccountAccountRelation__c(FinServ__Account__c = testAccount.Id, FinServ__RelatedAccount__c = account.Id, Roles__c = 'Shareholder/Controller', FinServ__Role__c = resRole.id, Primary_Entity_Id__c = testAccount.Id, Shareholding_Percentage__c = 50);
		AccountAccountRelationController.calculateControllingPercentageVal(accAccRel);

		Opportunity testOpp = new Opportunity();
		testOpp.Name = 'Test Opp';
		testOpp.CloseDate = Date.today();

		testOpp.StageName = 'Drafting';
		testOpp.accountId = testAccount.Id;
		insert testOpp;
        
        Product2 prod = new Product2(Name = 'Cheque Product', Family = 'Savings');
		insert prod;

		Id pricebookId = Test.getStandardPricebookId();

		PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id, UnitPrice = 10000, IsActive = true);
		insert standardPrice;

		Pricebook2 customPB = new Pricebook2(Name = 'Standard Pricebook', isActive = true);
		insert customPB;

		PricebookEntry customPrice = new PricebookEntry(Pricebook2Id = customPB.Id, Product2Id = prod.Id, UnitPrice = 12000, IsActive = true);
		insert customPrice;

		OpportunityLineItem oppLineItem = new OpportunityLineItem();
		oppLineItem.OpportunityId = testOpp.id;
		oppLineItem.Product2Id = prod.id;
		oppLineItem.PricebookEntryId = customPrice.id;
		oppLineItem.Quantity = 1;
		oppLineItem.TotalPrice = 100;
		insert oppLineItem;

		Document_Template__c d1 = new Document_Template__c();
		d1.Name = 'ABSA 6280 - Tax Self- Certification and Declaration';
		d1.ECM_Item_Type__c = 'Ent_Declaration';
		d1.Parent_Document_Type__c = 'Business Client Agreement';
		insert d1;

		Document__c d = new Document__c();
		d.Name = 'aa';
		d.Type__c = 'ABSA 6280 - Tax Self- Certification and Declaration';
		d.Opportunity__c = testOpp.id;
		d.Account__c = testAccount.Id;
		d.ECM_Type__c = 'Ent_Declaration';
		d.Reference__c = '92 3 ICM7 UGOLSDB13 Ent_Quotation59 26 A1001001A20F08C10108B0752518 A20F08C10108B075251 14 1868';
		insert d;

		Document__c d2 = new Document__c();
		d2.Name = 'aa';
		d2.Type__c = 'ABSA 6280 - Tax Self- Certification and Declaration';
		d2.Opportunity__c = testOpp.id;
		d2.Contact__c = personContactId;
		d2.ECM_Type__c = 'Ent_Declaration';
		d2.Reference__c = '92 3 ICM7 UGOLSDB13 Ent_Quotation59 26 A1001001A20F08C10108B0752518 A20F08C10108B075251 14 1868';
		insert d2;

		List<Document__c> docList = new DocumentsSelector().selectDocumentsByOppId(testOpp.id);
		List<SignatureRequest__c> emptyList = new List<SignatureRequest__c>();
		Test.startTest();
		DocumentPrepopulation.getDocs(testOpp.id);
		DocumentPrepopulation.getAllMandatoryDocuments(testOpp.Entity_Type__c);
		
		DocumentPrepopulation.generateDocument(testOpp.id, d1.Name, emptyList);
		Map<String, String> ss = DocumentPrepopulation.generateNewDocument(testOpp.id, d1.Name, emptyList);
		DocumentPrepopulation.fetchPersonAccList(testOpp.id);
		system.assert(ss != null, 'Doc result');
		Test.stopTest();
	}
    /**
	 * @description testupdateopportunity
	 *
	 */
	@IsTest
	private static void testupdateopportunity(){
		Opportunity opp = [select id, CheckMandatoryDocuments__c, StageName
		                   from opportunity
		                   limit 1];
		Test.startTest();
		new MandatoryDocumentSelector().getSObjectType();
		new MandatoryDocumentSelector().getSObjectFieldList();
		List<String> ss = DocumentPrepopulation.updateOpportunity(String.valueOf(opp.Id), 'true');
		DocumentPrepopulation.updateOpportunity(String.valueOf(opp.Id), 'false');
		DocumentPrepopulation.updateOpportunity('null', 'null');
		system.assert(ss != null, 'updateOpportunity');
		Test.stopTest();
	}
    /**
	 * @description checkRelatedPartyDocStateTest
	 *
	 */
	@IsTest
	private static void checkRelatedPartyDocStateTest(){
		Opportunity newOppRecord = [SELECT Id, Name
		                            FROM Opportunity
		                            where Name = 'Onboarding'
		                            LIMIT 1];

		Test.startTest();
		List<Map<String, Object>> relatedParty = DocumentPrepopulation.getRelatedParties(newOppRecord.Id);
		system.assertNotEquals(null, DocumentPrepopulation.checkRelatedPartyDocState(relatedParty), 'msg');
		Test.stopTest();
	}
 /**
	 * @description TestGetRelatedPartiess
	 *
	 */
	@isTest
	static void TestGetRelatedPartiess(){

		Account account = new Account();
		account.Name = 'Test Account';
		account.Client_Group__c = 'SOLE TRADER CLIENT';
		insert account;

		Opportunity testOpp = new Opportunity();
		testOpp.Name = 'Test Opp Onboarding';
		testOpp.CloseDate = Date.today();
		testOpp.StageName = 'New';
		testOpp.AccountId = account.Id;
		insert testOpp;

		Test.startTest();
		Documentprepopulation.getAccountContactRelation(testOpp.Id);
		List<Map<String, Object>> ss = Documentprepopulation.getRelatedParties(testOpp.Id);
		system.assertNotEquals(null, ss, 'msg');
		test.stopTest();
	}
    /**
	 * @description addCallReportTest
	 *
	 */
	@IsTest
	private static void addCallReportTest(){
		Test.startTest();

		Account account = new Account();
		account.Name = 'Test TAccount2';
		account.Client_Type__c = 'Private Individual';
		account.CIF__c = 'Test+002';
		insert account;

		Contact contact = new Contact(LastName = 'Test contact', AccountId = account.Id, Email = 'agents12@support.co.za');
		insert contact;

		Contact newContactRecord = [SELECT Id, Name, Email, Phone
		                            FROM Contact
		                            Where Email = 'agents12@support.co.za'
		                            LIMIT 1];

		Opportunity testOpp = new Opportunity();
		testOpp.Name = 'Test Opp Onboarding 12';
		testOpp.CloseDate = Date.today();
		testOpp.StageName = 'New';
		testOpp.AccountId = account.Id;
		insert testOpp;

		Opportunity newOppRecord = [SELECT Id, Name
		                            FROM Opportunity
		                            Where Name = 'Test Opp Onboarding 12'
		                            LiMIT 1];
		Datetime now = Datetime.now();
		String oppId = newOppRecord.Id;
		String personSpokenTo = newContactRecord.Id;
		String numberDialled = '0116754220';
		Datetime callStart = now;
		Datetime callEnd = now;
		String extensionDailedFrom = 'test';
		String absaUserID = UserInfo.getUserId();
		String briefDescription = 'test test';
		String result = DocumentPrepopulation.addCallReport(oppId, personSpokenTo, numberDialled, callStart, callEnd, extensionDailedFrom, absaUserID, briefDescription);
		System.assert(result != null, 'Inserted the application record');
		Test.stopTest();
	}
   /**
	 * @description getActiveUserTest
	 *
	 */
    @isTest
    public static void getActiveUserTest(){
		Test.startTest();
		String result = DocumentManagementControler.getActiveUser();
		List<OpportunityLineItem> result1 = DocumentManagementControler.findOppData();
		system.assertNotEquals(null, result1, 'we should have a value');
		Test.stopTest();
	}
       /**
	 * @description getCallReportTest
	 *
	 */
	@IsTest
	private	static void getCallReportTest(){
		Test.startTest();
		Account account = new Account();
		account.Name = 'Test TAccount3';
		account.Client_Type__c = 'Private Individual';
		account.CIF__c = 'Test+002';
		insert account;

		Contact contact = new Contact(LastName = 'Test contact', AccountId = account.Id, Email = 'agents13@support.co.za');
		insert contact;

		Contact newContactRecord = [SELECT Id, Name, Email, Phone
		                            FROM Contact
		                            Where Email = 'agents13@support.co.za'
		                            LIMIT 1];

		Opportunity testOpp = new Opportunity();
		testOpp.Name = 'Test Opp Onboarding 13';
		testOpp.CloseDate = Date.today();
		testOpp.StageName = 'New';
		testOpp.AccountId = account.Id;
		insert testOpp;
		map<String, Schema.RecordTypeInfo> caseRecordTypeMap = Case.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
		Case caseRec = new Case(Communication_Method__c = 'Email', Status = 'New', Origin = 'Email', Account = account, Email__c = 'test@test.com', recordTypeId = caseRecordTypeMap.get('CAF_Application').getRecordTypeId(), Subject = 'test', Description = 'test', Expectation_of_the_Customer__c = 'test', Opportunity__c = testOpp.id, Incident_Date__c = date.today());
		insert caseRec;

		Opportunity newOppRecord = [SELECT Id, Name
		                            FROM Opportunity
		                            Where Name = 'Test Opp Onboarding 13'
		                            LiMIT 1];

		DocumentPrepopulation.getCallReport(newOppRecord.Id);
		boolean bool = DocumentPrepopulation.isItAnOpportunity(testOpp.id);
		List<AccountContactRelation> acr = DocumentPrepopulation.fetchPersonAccList(newOppRecord.id);
		List<Document__c> documentAuditList = DocumentPrepopulation.getDocAuditHistoryEmail(caseRec.Id);
		Boolean bolltest = DocumentPrepopulation.getRecordTypeName(newOppRecord.id);
		List<AccountContactRelation> fetchPAL = DocumentPrepopulation.fetchPersonAccList(newOppRecord.id);
		system.assertNotEquals(null, bolltest, 'test');
		Test.stopTest();
	}
    
       /**
	 * @description testfetchPersonAccList
	 *
	 */
	@isTest
	public static void testfetchPersonAccList(){
		Opportunity testOpportunity = [SELECT Id, Name
		                               FROM Opportunity
		                               Where Name = 'Test Opp Onboarding 1'];
		Application__c applicationRecord = [SELECT Id, CurrencyIsoCode, Fees_Waived__c, individual_s_is_are_authorised_to_act__c, Opportunity__c, Safe_Custody_Is_Required__c, Safe_Custody_Payment_Same_As_Drafting__c, StockServiceTrace__c, TrackerTrace__c, UpdateWillTrace__c
		                                    From Application__c
		                                    LIMIT 1];
		test.startTest();
		DocumentPrepopulation.fetchPersonAccList(testOpportunity.id);
		DocumentPrepopulation.saveIndemnityDetails('Email', 'Instruction Type', applicationRecord.id);
		string medium = [Select id, Medium__c
		                 from Application__c
		                 where id = :applicationRecord.id].Medium__c;
		system.assertEquals('Email', medium, 'test');
		test.stopTest();
	}
    
     /**
	 * @description documentprepopulationmethodsTest
	 *
	 */
    @IsTest
	private static void documentprepopulationmethodsTest(){
		Opportunity newOppRecord = [SELECT Id, Name
		                            FROM Opportunity
		                            LIMIT 1];
		Application__c applicationRecord = [SELECT Id, CurrencyIsoCode, Fees_Waived__c, individual_s_is_are_authorised_to_act__c, Opportunity__c, Safe_Custody_Is_Required__c, Safe_Custody_Payment_Same_As_Drafting__c, StockServiceTrace__c, TrackerTrace__c, UpdateWillTrace__c
		                                    From Application__c
		                                    LIMIT 1];

		Test.startTest();
		applicationRecord.Signed_at__c = 'Sandton';
		applicationRecord.Signed_on__c = system.today();
		applicationRecord.global_application_form__c = 'YES';
		applicationRecord.Standard_Absa_resolution_for_you__c = 'NO';
		applicationRecord.Absa_mandate_and_indemnity__c = 'YES';
		applicationRecord.Standard_Absa_site_visit_for_you__c = 'NO';
		applicationRecord.Standard_Absa_power_of_attorney_for_you__c = 'YES';
		applicationRecord.Record_of_telephonic_engagement__c = 'NO';
		applicationRecord.Are_all_the_related_parties__c = 'YES';
		applicationRecord.Is_there_more_than_one_natural_person__c = 'NO';
		applicationRecord.Foreign_Exchange_Authority_Form_for_you__c = 'YES';
		applicationRecord.individual_s_is_are_authorised_to_act__c = '1';
        applicationRecord.Instruction_Type__c = 'normal';
        applicationRecord.Medium__c = 'email';
        
		update applicationRecord;

		String applicationId = DocumentPrepopulation.getApplicationId(newOppRecord.id);
		DocumentPrepopulation.saveIndemnityDetails('Email','normal', applicationRecord.Id);
		DocumentPrepopulation.savepowerOfAttornyDetails(applicationRecord.Id,'General Power of Attorney','1234443');
        DocumentPrepopulation.saveElectronicBankingDetails(applicationRecord.Id,'123445', '1466666','3','2', 'yes');
        DocumentPrepopulation.saveSavingsInvestmentDetails(applicationRecord.Id,'2', 'Yes');
        DocumentPrepopulation.saveForeignNationalDetails(applicationRecord.Id,'south africa','gaureng', 'business',
                                                           system.today(),'123444',system.today() + 365);
        DocumentPrepopulation.saveMandateIndemnityDetails(applicationRecord.Id, 'Email/Scan');
        DocumentPrepopulation.saveBankingMandateDetails(applicationRecord.Id, '1233222');
        
		System.assert(applicationRecord != null, 'Not null');
		Test.stopTest();
	}

}