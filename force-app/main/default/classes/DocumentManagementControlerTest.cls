/**
 * @description       : 
 * @author            : muvhuso.nekhubvi@absa.africa
 * @group             :
 * @last modified on  : 2021-11-25
 * @last modified by  : luluwitney.rankwe@absa.africa
 * Modifications Log
 * Ver   Date         Author                         Modification
 * 1.0   05-17-2021   muvhuso.nekhubvi@absa.africa   Initial Version
**/
@IsTest 
public class DocumentManagementControlerTest{
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
		DocumentManagementControler.getSelectedDocumentTemplate('Will');
		DocumentManagementControler.invokeApprovalProcess(covenant.Id, covenant.Covenant_Status__c, 'String reason', userInfo.getUserId());
		DocumentManagementControler.updateDocumentContent(doc.Id);

		List<Document__c> documentAuditList = DocumentManagementControler.getDocAuditHistoryEmail(testOpportunity.Id);
		Document_Template__c dt = DocumentManagementControler.getSelectedDocumentTemplate('Will');
		DocumentManagementControler.updateDocumentContent(doc.Id);
		system.assert(dt.name != null, 'There must be a will');

		Test.stopTest();
	}

	@IsTest
	private static void ECMLogin(){
		ECM_IH_V1Test.insertSettings();
		Test.startTest();
		ECM_LoginResult_IB_V1 login = DocumentManagementControler.ECMLogin();
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
		string ss = DocumentManagementControler.getDocumentContent(testDoc.id);
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

	@IsTest
	private static void testgetFileTypePickList(){
		Test.startTest();
		List<String> ss = DocumentManagementControler.getFileTypePickList();
		system.assert(ss != null, 'Picklist');
		Test.stopTest();
	}

	@IsTest
	private static void testGetDocumentTemplatesNamePickListValid(){
		Id oppId = [Select Id
		            from Opportunity
		            LIMIT 1].Id;
		Test.startTest();
		List<String> ss = DocumentManagementControler.getDocumentTemplatesNamePickList(oppId);
		system.assert(ss != null, 'Picklist');
		Test.stopTest();
	}

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

		String applicationId = DocumentManagementControler.getApplicationId(newOppRecord.id);
		DocumentManagementControler.getApplicationRecordDetails(newOppRecord.id);
		String recType = DocumentManagementControler.getApplicationrecordtypeId();
		DocumentManagementControler.fetchPersonAccList(newOppRecord.id);
		DocumentManagementControler.saveSiteVisitDetails('FORMAL SETTLEMENT', System.today(), 'BUSINESS', 'firstname', 'surname', UserInfo.getUserId(), applicationRecord.Id, 'Settlement Info');
		DocumentManagementControler.saveResolutionDetails(applicationRecord.individual_s_is_are_authorised_to_act__c, applicationRecord.Id);
		Application__c applicationRec = DocumentManagementControler.saveAppDetails(applicationRecord.Signed_at__c, applicationRecord.Signed_on__c, applicationRecord.global_application_form__c, applicationRecord.Standard_Absa_resolution_for_you__c, applicationRecord.Absa_mandate_and_indemnity__c, applicationRecord.Standard_Absa_site_visit_for_you__c, applicationRecord.Standard_Absa_power_of_attorney_for_you__c, applicationRecord.Record_of_telephonic_engagement__c, applicationRecord.Are_all_the_related_parties__c, applicationRecord.Is_there_more_than_one_natural_person__c, applicationRecord.Foreign_Exchange_Authority_Form_for_you__c, applicationRecord.Id, userInfo.getUserId());
		System.assert(applicationRecord != null, 'Not null');
		Test.stopTest();
	}

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
		testAccount.UBO_ParentAccountWrapper__c = '[{"Type":"Private Company","ShareholderCount":3,"Shareholder":"PASCAL SOLUTIONS (PTY) LTD","recordId":"0015r00000Ht2mtAAB","ParentShareholding":100,"Controllinginterest":100,"Accwrplist":[{"UBO":"","Type":"Private Company","ShareholderCount":2,"Shareholder":"GAMBULELA TRADING (PTY) LTD","roles":"Shareholder/Controller","relatedAccountId":"0015r00000EYE78AAH","recordId":"a005r000001u7LyAAI","primaryEntityId":"0015r00000Ht2mtAAB","ParentShareholding":25.00,"parentAccountId":"0015r00000Ht2mtAAB","idType":"Registration Number","Controllinginterest":25.00,"childwrplist":[{"UBO":"No","Type":"Individual","ShareholderCount":0,"Shareholder":"NTEMBEKO NTANTISO MAKALIMA","roles":"Director;Individual with Authority to Act;Shareholder/Controller;Contact Person;Operators on primary accounts ( Internet Main Users, Signatories, Card Users);Manager","relatedAccountId":"0035r00000C2V0PAAV","recordId":"07k5r000002QR7cAAG","primaryEntityId":"0015r00000EYE78AAH","ParentShareholding":10.00,"parentAccountId":"0015r00000EYE78AAH","idType":"SA Identity Document","Controllinginterest":2.50,"childwrplist":null,"accType":"AccountContact"},{"UBO":"","Type":"Trusts","ShareholderCount":2,"Shareholder":"Greyling Trust","roles":"Shareholder/Controller","relatedAccountId":"0015r00000EYC4QAAX","recordId":"a005r000001b3GJAAY","primaryEntityId":"0015r00000EYE78AAH","ParentShareholding":90.00,"parentAccountId":"0015r00000EYE78AAH","idType":"Non-Registered Entity","Controllinginterest":22.50,"childwrplist":[{"UBO":"Yes","Type":"Individual","ShareholderCount":0,"Shareholder":"GANAS SOOBRAMONY NAIDU","roles":"Named Beneficiaries","relatedAccountId":"0035r00000C1GWKAA3","recordId":"07k5r000002QQTtAAO","primaryEntityId":"0015r00000EYB8FAAX","ParentShareholding":80.00,"parentAccountId":"0015r00000EYC4QAAX","idType":"SA Identity Document","Controllinginterest":18.00,"childwrplist":null,"accType":"AccountContact"},{"UBO":"","Type":"Private Company","ShareholderCount":2,"Shareholder":"HFR Properties KZN (pty )Ltd","roles":"Trustees","relatedAccountId":"0015r00000HtjKwAAJ","recordId":"a005r000001u7M3AAI","primaryEntityId":"0015r00000EYC4QAAX","ParentShareholding":100.00,"parentAccountId":"0015r00000EYC4QAAX","idType":"Registration Number","Controllinginterest":22.50,"childwrplist":[{"UBO":"Yes","Type":"Individual","ShareholderCount":0,"Shareholder":"NTEMBEKO NTANTISO MAKALIMA","roles":"Named Beneficiaries","relatedAccountId":"0035r00000C2V0PAAV","recordId":"07k5r000004FVZFAA4","primaryEntityId":"0015r00000EYC4QAAX","ParentShareholding":100.00,"parentAccountId":"0015r00000HtjKwAAJ","idType":"SA Identity Document","Controllinginterest":25.00,"childwrplist":null,"accType":"AccountContact"},{"UBO":"","Type":"Private Company","ShareholderCount":2,"Shareholder":"Capolie Botha Eiendomme (Pty) Ltd","roles":"Shareholder/Controller","relatedAccountId":"0015r00000HtmrpAAB","recordId":"a005r000001u7MDAAY","primaryEntityId":"0015r00000EYC4QAAX","ParentShareholding":100.00,"parentAccountId":"0015r00000HtjKwAAJ","idType":"Registration Number","Controllinginterest":22.50,"childwrplist":[{"UBO":"","Type":"Private Company","ShareholderCount":2,"Shareholder":"Test Light (Pty) Ltd","roles":"Shareholder/Controller","relatedAccountId":"0015r00000Ht94NAAR","recordId":"a005r000001u7MIAAY","primaryEntityId":"0015r00000EYC4QAAX","ParentShareholding":50.00,"parentAccountId":"0015r00000HtmrpAAB","idType":"Registration Number","Controllinginterest":11.25,"childwrplist":[{"UBO":"No","Type":"Individual","ShareholderCount":0,"Shareholder":"Mara Mahlatse","roles":"Shareholder/Controller","relatedAccountId":"0035r00000FMe1oAAD","recordId":"07k5r000004FnpIAAS","primaryEntityId":"0015r00000EYC4QAAX","ParentShareholding":60.00,"parentAccountId":"0015r00000Ht94NAAR","idType":"Passport","Controllinginterest":6.75,"childwrplist":null,"accType":"AccountContact"},{"UBO":"","Type":"Trusts","ShareholderCount":2,"Shareholder":"Mara Trust","roles":"Shareholder/Controller","relatedAccountId":"0015r00000HtrEtAAJ","recordId":"a005r000001u7MSAAY","primaryEntityId":"0015r00000EYC4QAAX","ParentShareholding":50.00,"parentAccountId":"0015r00000Ht94NAAR","idType":"Non-Registered Entity","Controllinginterest":5.62,"childwrplist":[{"UBO":"No","Type":"Individual","ShareholderCount":0,"Shareholder":"JOHANNES HENDRIK BESTER","roles":"Named Beneficiaries","relatedAccountId":"0035r000009TLRHAA4","recordId":"07k5r000004FKs8AAG","primaryEntityId":"0015r00000EYC4QAAX","ParentShareholding":25.00,"parentAccountId":"0015r00000HtrEtAAJ","idType":"SA Identity Document","Controllinginterest":1.41,"childwrplist":null,"accType":"AccountContact"},{"UBO":"No","Type":"Individual","ShareholderCount":0,"Shareholder":"HEIDI MICHELLE WENKE","roles":"Named Beneficiaries","relatedAccountId":"0035r00000DWT7zAAH","recordId":"07k5r000004FKscAAG","primaryEntityId":"0015r00000EYC4QAAX","ParentShareholding":25.00,"parentAccountId":"0015r00000HtrEtAAJ","idType":"SA Identity Document","Controllinginterest":1.41,"childwrplist":null,"accType":"AccountContact"}],"accType":"AccountAccount"}],"accType":"AccountAccount"},{"UBO":"","Type":"Private Company","ShareholderCount":2,"Shareholder":"REcord Hut (Pty) LTd","roles":"Shareholder/Controller","relatedAccountId":"0015r00000Hns30AAB","recordId":"a005r000001u7MNAAY","primaryEntityId":"0015r00000EYC4QAAX","ParentShareholding":50.00,"parentAccountId":"0015r00000HtmrpAAB","idType":"Registration Number","Controllinginterest":11.25,"childwrplist":[{"UBO":"Yes","Type":"Individual","ShareholderCount":0,"Shareholder":"DANISILE DERRICK MBALO","roles":"Shareholder/Controller","relatedAccountId":"0035r00000FNDlXAAX","recordId":"07k5r000004FSneAAG","primaryEntityId":"0015r00000EYC4QAAX","ParentShareholding":100.00,"parentAccountId":"0015r00000Hns30AAB","idType":"SA Identity Document","Controllinginterest":11.25,"childwrplist":null,"accType":"AccountContact"},{"UBO":"Yes","Type":"Individual","ShareholderCount":0,"Shareholder":"Mara Mahlatse","roles":"Shareholder/Controller","relatedAccountId":"0035r00000FMe1oAAD","recordId":"07k5r000004FnGpAAK","primaryEntityId":"0015r00000EYC4QAAX","ParentShareholding":40.00,"parentAccountId":"0015r00000Hns30AAB","idType":"Passport","Controllinginterest":11.25,"childwrplist":null,"accType":"AccountContact"}],"accType":"AccountAccount"}],"accType":"AccountAccount"}],"accType":"AccountAccount"}],"accType":"AccountAccount"}],"accType":"AccountAccount"},{"UBO":"","Type":"Private Company","ShareholderCount":1,"Shareholder":"Test Complex Structure (Pty) Ltd","roles":"Shareholder/Controller","relatedAccountId":"0015r00000DmDe9AAF","recordId":"a005r000001u7SpAAI","primaryEntityId":"0015r00000Ht2mtAAB","ParentShareholding":25.00,"parentAccountId":"0015r00000Ht2mtAAB","idType":"Registration Number","Controllinginterest":25.00,"childwrplist":[{"UBO":"","Type":"Trusts","ShareholderCount":1,"Shareholder":"BOTHA FAMILY TRUST","roles":"Shareholder/Controller","relatedAccountId":"0015J00000F06smQAB","recordId":"a005r000001u9LnAAI","primaryEntityId":"0015r00000Ht2mtAAB","ParentShareholding":100.00,"parentAccountId":"0015r00000DmDe9AAF","idType":null,"Controllinginterest":25.00,"childwrplist":[{"UBO":"","Type":"Close Corporation","ShareholderCount":2,"Shareholder":"Two stone Gardening services cc","roles":"Named Beneficiaries","relatedAccountId":"0015r00000HuCsaAAF","recordId":"a005r000001u9LsAAI","primaryEntityId":"0015r00000Ht2mtAAB","ParentShareholding":100.00,"parentAccountId":"0015J00000F06smQAB","idType":"Registration Number","Controllinginterest":25.00,"childwrplist":[{"UBO":"Yes","Type":"Individual","ShareholderCount":0,"Shareholder":"NTEMBEKO NTANTISO MAKALIMA","roles":"Members/Controllers","relatedAccountId":"0035r00000C2V0PAAV","recordId":"07k5r000004FkojAAC","primaryEntityId":"0015r00000Ht2mtAAB","ParentShareholding":30.00,"parentAccountId":"0015r00000HuCsaAAF","idType":"SA Identity Document","Controllinginterest":32.50,"childwrplist":null,"accType":"AccountContact"},{"UBO":"","Type":"Close Corporation","ShareholderCount":1,"Shareholder":"P and D Trading CC","roles":"Members/Controllers","relatedAccountId":"0015r00000HuCokAAF","recordId":"a005r000001u9LxAAI","primaryEntityId":"0015r00000Ht2mtAAB","ParentShareholding":100.00,"parentAccountId":"0015r00000HuCsaAAF","idType":"Registration Number","Controllinginterest":25.00,"childwrplist":[{"UBO":"Yes","Type":"Individual","ShareholderCount":0,"Shareholder":"A Burgess","roles":"Members/Controllers","relatedAccountId":"0035r00000FNDbMAAX","recordId":"07k5r000004FSjFAAW","primaryEntityId":"0015r00000Ht2mtAAB","ParentShareholding":100.00,"parentAccountId":"0015r00000HuCokAAF","idType":"SA Identity Document","Controllinginterest":25.00,"childwrplist":null,"accType":"AccountContact"}],"accType":"AccountAccount"}],"accType":"AccountAccount"}],"accType":"AccountAccount"}],"accType":"AccountAccount"},{"UBO":"Yes","Type":"Individual","ShareholderCount":0,"Shareholder":"FRANCOIS MARIO WOLVAARDT","roles":"Director;Shareholder/Controller;Operators on primary accounts ( Internet Main Users, Signatories, Card Users)","relatedAccountId":"0035r00000FMaS4AAL","recordId":"07k5r000004FAwoAAG","primaryEntityId":"0015r00000Ht2mtAAB","ParentShareholding":25.00,"parentAccountId":"0015r00000Ht2mtAAB","idType":"SA Identity Document","Controllinginterest":25.00,"childwrplist":null,"accType":"AccountContact"}],"accType":"Account"}]';
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
		testAccount.UBO_ParentAccountWrapper__c = '[{"Type":"Private Company","ShareholderCount":3,"Shareholder":"PASCAL SOLUTIONS (PTY) LTD","recordId":"0015r00000Ht2mtAAB","ParentShareholding":100,"Controllinginterest":100,"Accwrplist":[{"UBO":"","Type":"Private Company","ShareholderCount":2,"Shareholder":"GAMBULELA TRADING (PTY) LTD","roles":"Shareholder/Controller","relatedAccountId":"0015r00000EYE78AAH","recordId":"a005r000001u7LyAAI","primaryEntityId":"0015r00000Ht2mtAAB","ParentShareholding":25.00,"parentAccountId":"0015r00000Ht2mtAAB","idType":"Registration Number","Controllinginterest":25.00,"childwrplist":[{"UBO":"No","Type":"Individual","ShareholderCount":0,"Shareholder":"NTEMBEKO NTANTISO MAKALIMA","roles":"Director;Individual with Authority to Act;Shareholder/Controller;Contact Person;Operators on primary accounts ( Internet Main Users, Signatories, Card Users);Manager","relatedAccountId":"0035r00000C2V0PAAV","recordId":"07k5r000002QR7cAAG","primaryEntityId":"0015r00000EYE78AAH","ParentShareholding":10.00,"parentAccountId":"0015r00000EYE78AAH","idType":"SA Identity Document","Controllinginterest":2.50,"childwrplist":null,"accType":"AccountContact"},{"UBO":"","Type":"Trusts","ShareholderCount":2,"Shareholder":"Greyling Trust","roles":"Shareholder/Controller","relatedAccountId":"0015r00000EYC4QAAX","recordId":"a005r000001b3GJAAY","primaryEntityId":"0015r00000EYE78AAH","ParentShareholding":90.00,"parentAccountId":"0015r00000EYE78AAH","idType":"Non-Registered Entity","Controllinginterest":22.50,"childwrplist":[{"UBO":"Yes","Type":"Individual","ShareholderCount":0,"Shareholder":"GANAS SOOBRAMONY NAIDU","roles":"Named Beneficiaries","relatedAccountId":"0035r00000C1GWKAA3","recordId":"07k5r000002QQTtAAO","primaryEntityId":"0015r00000EYB8FAAX","ParentShareholding":80.00,"parentAccountId":"0015r00000EYC4QAAX","idType":"SA Identity Document","Controllinginterest":18.00,"childwrplist":null,"accType":"AccountContact"},{"UBO":"","Type":"Private Company","ShareholderCount":2,"Shareholder":"HFR Properties KZN (pty )Ltd","roles":"Trustees","relatedAccountId":"0015r00000HtjKwAAJ","recordId":"a005r000001u7M3AAI","primaryEntityId":"0015r00000EYC4QAAX","ParentShareholding":100.00,"parentAccountId":"0015r00000EYC4QAAX","idType":"Registration Number","Controllinginterest":22.50,"childwrplist":[{"UBO":"Yes","Type":"Individual","ShareholderCount":0,"Shareholder":"NTEMBEKO NTANTISO MAKALIMA","roles":"Named Beneficiaries","relatedAccountId":"0035r00000C2V0PAAV","recordId":"07k5r000004FVZFAA4","primaryEntityId":"0015r00000EYC4QAAX","ParentShareholding":100.00,"parentAccountId":"0015r00000HtjKwAAJ","idType":"SA Identity Document","Controllinginterest":25.00,"childwrplist":null,"accType":"AccountContact"},{"UBO":"","Type":"Private Company","ShareholderCount":2,"Shareholder":"Capolie Botha Eiendomme (Pty) Ltd","roles":"Shareholder/Controller","relatedAccountId":"0015r00000HtmrpAAB","recordId":"a005r000001u7MDAAY","primaryEntityId":"0015r00000EYC4QAAX","ParentShareholding":100.00,"parentAccountId":"0015r00000HtjKwAAJ","idType":"Registration Number","Controllinginterest":22.50,"childwrplist":[{"UBO":"","Type":"Private Company","ShareholderCount":2,"Shareholder":"Test Light (Pty) Ltd","roles":"Shareholder/Controller","relatedAccountId":"0015r00000Ht94NAAR","recordId":"a005r000001u7MIAAY","primaryEntityId":"0015r00000EYC4QAAX","ParentShareholding":50.00,"parentAccountId":"0015r00000HtmrpAAB","idType":"Registration Number","Controllinginterest":11.25,"childwrplist":[{"UBO":"No","Type":"Individual","ShareholderCount":0,"Shareholder":"Mara Mahlatse","roles":"Shareholder/Controller","relatedAccountId":"0035r00000FMe1oAAD","recordId":"07k5r000004FnpIAAS","primaryEntityId":"0015r00000EYC4QAAX","ParentShareholding":60.00,"parentAccountId":"0015r00000Ht94NAAR","idType":"Passport","Controllinginterest":6.75,"childwrplist":null,"accType":"AccountContact"},{"UBO":"","Type":"Trusts","ShareholderCount":2,"Shareholder":"Mara Trust","roles":"Shareholder/Controller","relatedAccountId":"0015r00000HtrEtAAJ","recordId":"a005r000001u7MSAAY","primaryEntityId":"0015r00000EYC4QAAX","ParentShareholding":50.00,"parentAccountId":"0015r00000Ht94NAAR","idType":"Non-Registered Entity","Controllinginterest":5.62,"childwrplist":[{"UBO":"No","Type":"Individual","ShareholderCount":0,"Shareholder":"JOHANNES HENDRIK BESTER","roles":"Named Beneficiaries","relatedAccountId":"0035r000009TLRHAA4","recordId":"07k5r000004FKs8AAG","primaryEntityId":"0015r00000EYC4QAAX","ParentShareholding":25.00,"parentAccountId":"0015r00000HtrEtAAJ","idType":"SA Identity Document","Controllinginterest":1.41,"childwrplist":null,"accType":"AccountContact"},{"UBO":"No","Type":"Individual","ShareholderCount":0,"Shareholder":"HEIDI MICHELLE WENKE","roles":"Named Beneficiaries","relatedAccountId":"0035r00000DWT7zAAH","recordId":"07k5r000004FKscAAG","primaryEntityId":"0015r00000EYC4QAAX","ParentShareholding":25.00,"parentAccountId":"0015r00000HtrEtAAJ","idType":"SA Identity Document","Controllinginterest":1.41,"childwrplist":null,"accType":"AccountContact"}],"accType":"AccountAccount"}],"accType":"AccountAccount"},{"UBO":"","Type":"Private Company","ShareholderCount":2,"Shareholder":"REcord Hut (Pty) LTd","roles":"Shareholder/Controller","relatedAccountId":"0015r00000Hns30AAB","recordId":"a005r000001u7MNAAY","primaryEntityId":"0015r00000EYC4QAAX","ParentShareholding":50.00,"parentAccountId":"0015r00000HtmrpAAB","idType":"Registration Number","Controllinginterest":11.25,"childwrplist":[{"UBO":"Yes","Type":"Individual","ShareholderCount":0,"Shareholder":"DANISILE DERRICK MBALO","roles":"Shareholder/Controller","relatedAccountId":"0035r00000FNDlXAAX","recordId":"07k5r000004FSneAAG","primaryEntityId":"0015r00000EYC4QAAX","ParentShareholding":100.00,"parentAccountId":"0015r00000Hns30AAB","idType":"SA Identity Document","Controllinginterest":11.25,"childwrplist":null,"accType":"AccountContact"},{"UBO":"Yes","Type":"Individual","ShareholderCount":0,"Shareholder":"Mara Mahlatse","roles":"Shareholder/Controller","relatedAccountId":"0035r00000FMe1oAAD","recordId":"07k5r000004FnGpAAK","primaryEntityId":"0015r00000EYC4QAAX","ParentShareholding":40.00,"parentAccountId":"0015r00000Hns30AAB","idType":"Passport","Controllinginterest":11.25,"childwrplist":null,"accType":"AccountContact"}],"accType":"AccountAccount"}],"accType":"AccountAccount"}],"accType":"AccountAccount"}],"accType":"AccountAccount"}],"accType":"AccountAccount"},{"UBO":"","Type":"Private Company","ShareholderCount":1,"Shareholder":"Test Complex Structure (Pty) Ltd","roles":"Shareholder/Controller","relatedAccountId":"0015r00000DmDe9AAF","recordId":"a005r000001u7SpAAI","primaryEntityId":"0015r00000Ht2mtAAB","ParentShareholding":25.00,"parentAccountId":"0015r00000Ht2mtAAB","idType":"Registration Number","Controllinginterest":25.00,"childwrplist":[{"UBO":"","Type":"Trusts","ShareholderCount":1,"Shareholder":"BOTHA FAMILY TRUST","roles":"Shareholder/Controller","relatedAccountId":"0015J00000F06smQAB","recordId":"a005r000001u9LnAAI","primaryEntityId":"0015r00000Ht2mtAAB","ParentShareholding":100.00,"parentAccountId":"0015r00000DmDe9AAF","idType":null,"Controllinginterest":25.00,"childwrplist":[{"UBO":"","Type":"Close Corporation","ShareholderCount":2,"Shareholder":"Two stone Gardening services cc","roles":"Named Beneficiaries","relatedAccountId":"0015r00000HuCsaAAF","recordId":"a005r000001u9LsAAI","primaryEntityId":"0015r00000Ht2mtAAB","ParentShareholding":100.00,"parentAccountId":"0015J00000F06smQAB","idType":"Registration Number","Controllinginterest":25.00,"childwrplist":[{"UBO":"Yes","Type":"Individual","ShareholderCount":0,"Shareholder":"NTEMBEKO NTANTISO MAKALIMA","roles":"Members/Controllers","relatedAccountId":"0035r00000C2V0PAAV","recordId":"07k5r000004FkojAAC","primaryEntityId":"0015r00000Ht2mtAAB","ParentShareholding":30.00,"parentAccountId":"0015r00000HuCsaAAF","idType":"SA Identity Document","Controllinginterest":32.50,"childwrplist":null,"accType":"AccountContact"},{"UBO":"","Type":"Close Corporation","ShareholderCount":1,"Shareholder":"P and D Trading CC","roles":"Members/Controllers","relatedAccountId":"0015r00000HuCokAAF","recordId":"a005r000001u9LxAAI","primaryEntityId":"0015r00000Ht2mtAAB","ParentShareholding":100.00,"parentAccountId":"0015r00000HuCsaAAF","idType":"Registration Number","Controllinginterest":25.00,"childwrplist":[{"UBO":"Yes","Type":"Individual","ShareholderCount":0,"Shareholder":"A Burgess","roles":"Members/Controllers","relatedAccountId":"0035r00000FNDbMAAX","recordId":"07k5r000004FSjFAAW","primaryEntityId":"0015r00000Ht2mtAAB","ParentShareholding":100.00,"parentAccountId":"0015r00000HuCokAAF","idType":"SA Identity Document","Controllinginterest":25.00,"childwrplist":null,"accType":"AccountContact"}],"accType":"AccountAccount"}],"accType":"AccountAccount"}],"accType":"AccountAccount"}],"accType":"AccountAccount"},{"UBO":"Yes","Type":"Individual","ShareholderCount":0,"Shareholder":"FRANCOIS MARIO WOLVAARDT","roles":"Director;Shareholder/Controller;Operators on primary accounts ( Internet Main Users, Signatories, Card Users)","relatedAccountId":"0035r00000FMaS4AAL","recordId":"07k5r000004FAwoAAG","primaryEntityId":"0015r00000Ht2mtAAB","ParentShareholding":25.00,"parentAccountId":"0015r00000Ht2mtAAB","idType":"SA Identity Document","Controllinginterest":25.00,"childwrplist":null,"accType":"AccountContact"}],"accType":"Account"}]';
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
		DocumentManagementControler.getDocs(testOpp.id);
		DocumentManagementControler.getAllMandatoryDocuments(testOpp.Entity_Type__c);
		DocumentManagementControler.getAllRelMandatoryDocuments(testAccount.Client_Type__c, testOpp.id, docList);
		DocumentManagementControler.getPrimaryClientMandatoryDocuments(testAccount.Client_Type__c, testOpp.id);
		DocumentManagementControler.generateDocument(testOpp.id, d1.Name, emptyList);
		Map<String, String> ss = DocumentManagementControler.generateNewDocument(testOpp.id, d1.Name, emptyList);
		DocumentManagementControler.fetchPersonAccList(testOpp.id);
		system.assert(ss != null, 'Doc result');
		Test.stopTest();
	}

	@IsTest
	private static void testupdateopportunity(){
		Opportunity opp = [select id, CheckMandatoryDocuments__c, StageName
		                   from opportunity
		                   limit 1];
		Test.startTest();
		new MandatoryDocumentSelector().getSObjectType();
		new MandatoryDocumentSelector().getSObjectFieldList();
		List<String> ss = DocumentManagementControler.updateOpportunity(String.valueOf(opp.Id), 'true');
		DocumentManagementControler.updateOpportunity(String.valueOf(opp.Id), 'false');
		DocumentManagementControler.updateOpportunity('null', 'null');
		opp.process_type__c = 'Voice Sales Product Onboarding';//Added by chandra dated 06/09/2021
        DocumentManagementControler.opportunityStatusUpdate(String.valueOf(opp.Id));//Added by chandra dated 06/09/2021
		system.assert(ss != null, 'updateOpportunity');
		Test.stopTest();
	}

	@IsTest
	private static void checkRelatedPartyDocStateTest(){
		Opportunity newOppRecord = [SELECT Id, Name
		                            FROM Opportunity
		                            where Name = 'Onboarding'
		                            LIMIT 1];

		Test.startTest();
		List<Map<String, Object>> relatedParty = productOnboardingController.getRelatedParties(newOppRecord.Id, false);
		system.assertNotEquals(null, DocumentManagementControler.checkRelatedPartyDocState(relatedParty), 'msg');
		Test.stopTest();
	}

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
		DocumentManagementControler.getAccountContactRelation(testOpp.Id);
		List<Map<String, Object>> ss = DocumentManagementControler.getRelatedParties(testOpp.Id);
		system.assertNotEquals(null, ss, 'msg');
		test.stopTest();
	}

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
		String result = DocumentManagementControler.addCallReport(oppId, personSpokenTo, numberDialled, callStart, callEnd, extensionDailedFrom, absaUserID, briefDescription);
		DocumentManagementControler.fetchPersonAccList(String.valueOf(testOpp.Id));//Added by chandra dated 06/09/2021
		System.assert(result != null, 'Inserted the application record');
		Test.stopTest();
	}
	@IsTest
		static void getActiveUserTest(){
		Test.startTest();
		String result = DocumentManagementControler.getActiveUser();
		List<OpportunityLineItem> result1 = DocumentManagementControler.findOppData();
		system.assertNotEquals(null, result1, 'we should have a value');
		Test.stopTest();
	}

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

		DocumentManagementControler.getCallReport(newOppRecord.Id);
		boolean bool = DocumentManagementControler.isItAnOpportunity(testOpp.id);
		List<AccountContactRelation> acr = DocumentManagementControler.fetchPersonAccList(newOppRecord.id);
		List<Document__c> documentAuditList = DocumentManagementControler.getDocAuditHistoryEmail(caseRec.Id);
		Boolean bolltest = DocumentManagementControler.getRecordTypeName(newOppRecord.id);
		List<AccountContactRelation> fetchPAL = DocumentManagementControler.fetchPersonAccList(newOppRecord.id);
		system.assertNotEquals(null, bolltest, 'test');
		Test.stopTest();
	}

	@isTest
	public static void testfetchPersonAccList(){
		Opportunity testOpportunity = [SELECT Id, Name
		                               FROM Opportunity
		                               Where Name = 'Test Opp Onboarding 1'];
		Application__c applicationRecord = [SELECT Id, CurrencyIsoCode, Fees_Waived__c, individual_s_is_are_authorised_to_act__c, Opportunity__c, Safe_Custody_Is_Required__c, Safe_Custody_Payment_Same_As_Drafting__c, StockServiceTrace__c, TrackerTrace__c, UpdateWillTrace__c
		                                    From Application__c
		                                    LIMIT 1];
		test.startTest();
		DocumentManagementControler.fetchPersonAccList(testOpportunity.id);
		DocumentManagementControler.saveIndemnityDetails('Email', 'Instruction Type', applicationRecord.id);
		string medium = [Select id, Medium__c
		                 from Application__c
		                 where id = :applicationRecord.id].Medium__c;
		system.assertEquals('Email', medium, 'test');
		test.stopTest();
	}

	//Added by chandra dated 06/09/2021
    @isTest
    static void testSendEmail() {
        Opportunity testOpportunity = [SELECT Id,Name FROM Opportunity Where Name = 'Test Opp Onboarding 1'];
        String emailAddress = 'test@test.com';
        
        Test.startTest();
        DocumentManagementControler.sendEmail(testOpportunity.Id,'VoiceContract',emailAddress,'VoiceContract','this is test blob');
        List<EmailMessage> email= [SELECT Id FROM EmailMessage];
        system.assertEquals(2, email.size(), 'test');
        Test.stopTest();
        
    }
}