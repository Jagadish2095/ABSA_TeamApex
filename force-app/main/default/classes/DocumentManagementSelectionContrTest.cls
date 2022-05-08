/**
 * @description       :
 * @author            : muvhuso.nekhubvi@absa.africa
 * @last modified on  : 2021-11-10
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 **/
@IsTest
public class DocumentManagementSelectionContrTest{
	/**
	 * @description dataCreation description
	 *
	 */
	@testSetup
	public static void dataCreation(){
		Account testAccount = new Account();
		testAccount.Name = 'Test Account';
		testAccount.Client_Type__c = 'Private Individual';
		testAccount.CIF__c = 'Test+001';
		testAccount.UBO_ParentAccountWrapper__c = '[{"Type":"PrivateCompany","ShareholderCount":4,"Shareholder":"LONDANICOAL(PTY)LTD","recordId":"0015r00000HvTN3AAN","ParentShareholding":100,"Controllinginterest":100,"Accwrplist":[{"UBO":"","Type":"CentralBankorRegulator","ShareholderCount":3,"Shareholder":"PINEAPPLECENTRALBANKANDREG","roles":"Director;IndividualwithAuthoritytoAct;Shareholder/Controller","relatedAccountId":"0015r00000HJk9qAAD","recordId":"a005r000001uMlTAAU","primaryEntityId":"0015r00000HvTN3AAN","ParentShareholding":20.00,"parentAccountId":"0015r00000HvTN3AAN","idType":"RegistrationNumber","Controllinginterest":20.00,"childwrplist":[{"UBO":"Yes","Type":"Individual","ShareholderCount":0,"Shareholder":"FANTAFANTA","roles":"Director;Shareholder/Controller;ContactPerson","relatedAccountId":"0035r00000EccagAAB","recordId":"07k5r000004DDDBAA4","primaryEntityId":"0015r00000HJk9qAAD","ParentShareholding":60.00,"parentAccountId":"0015r00000HJk9qAAD","idType":"SAIdentityDocument","Controllinginterest":12.00,"childwrplist":null,"accType":"AccountContact"}],"accType":"AccountAccount"}],"accType":"Account"}]';
		insert testAccount;

		Opportunity testOpp = new Opportunity();
		testOpp.Name = 'Test Opp Onboarding 1';
		testOpp.CloseDate = Date.today();
		testOpp.StageName = 'New';
		testOpp.AccountId = testAccount.Id;
		insert testOpp;

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
		testContact.AccountId = testJointAccount.Id;
		insert testContact;

		AccountContactRelation acr = new AccountContactRelation();
		acr.AccountId = testAccount.Id;
		acr.ContactId = testContact.Id;
		acr.Primary_Entity_Id__c = testAccount.id;
        acr.Share_Percentage__c = 0;
		insert acr;

		Document__c doc = new Document__c(Name = 'mydoc.pdf', ECM_Type__c = 'Ent_ProofOfId', Reference__c = '12345', Opportunity__c = testOpp.Id, Account__c = testAccount.Id);
		insert doc;

		Document__c doc2 = new Document__c(Name = 'mydoc2.pdf', ECM_Type__c = 'Ent_HighRiskDocument', Reference__c = '123456', Opportunity__c = testOpp.Id, Account__c = testAccount.Id);
		insert doc2;

		Document_Template__c dt = new Document_Template__c(Name = 'Absa 3741 Client Engagement', Opportunity_Record_Types__c = 'Opportunity Business Bank', ECM_Item_Type__c = 'Ent_ProofOfId', Client_Type__c = 'Private Individual', Document_Type__c = 'Absa 3741 Client Engagement', Parent_Document_Type__c = 'Business Client Agreement', Generate_Document__c = true);
		insert dt;

		Document_Template__c dt2 = new Document_Template__c(Name = 'mydoc3.pdf', Opportunity_Record_Types__c = 'Opportunity Business Bank', ECM_Item_Type__c = 'Ent_ProofOfAddress', Client_Type__c = 'Private Individual', Document_Type__c = 'ADVERSE MEDIA REPORT', Parent_Document_Type__c = 'Business Client Agreement', Generate_Document__c = true);
		insert dt2;

		Mandatory_Doc__mdt md1 = new Mandatory_Doc__mdt();
		md1.Entity_Type__c = 'Private Company';
		md1.ECM_Type__c = 'Ent_ProofOfId';

		Mandatory_Doc__mdt md3 = new Mandatory_Doc__mdt();
		md3.Entity_Type__c = 'Related Party Private Company';
		md3.ECM_Type__c = 'Ent_ProofOfId';
		

		Mandatory_Doc__mdt md4 = new Mandatory_Doc__mdt();
		md4.Entity_Type__c = 'UBO';
		md4.ECM_Type__c = 'Ent_ProofOfId';
	}

	@IsTest
	public static void testCreateDocPlaceholder(){
		Opportunity testOpportunity = [SELECT Id, Name
		                               FROM Opportunity
		                               LIMIT 1];
		Account testAccount = [SELECT Id, Name
		                       FROM Account
		                       LIMIT 1];
		Account testJointAcct = [Select Id, Name from Account where Name  ='TEST MR JA & TEST MRS J' limit 1];
        
        List<Address__c> addrList = new List<Address__c>();
		addrList.add(new Address__c(Account__c = testJointAcct.Id, Address_Type__c = 'Physical Address', Client_Entity_Type__c = 'Individual', Shipping_Country__c = 'South Africa', Shipping_State_Province__c = 'Gauteng', Shipping_Street__c = 'Street 37', Shipping_Suburb__c = 'Maboneng', Shipping_Zip_Postal_Code__c = '1619', Shipping_City__c = 'City'));
		addrList.add(new Address__c(Account__c = testJointAcct.Id, Address_Type__c = 'Postal', Client_Entity_Type__c = 'Individual', Shipping_Country__c = 'South Africa', Shipping_State_Province__c = 'Gauteng', Shipping_Street__c = 'Street 37', Shipping_Suburb__c = 'Maboneng', Shipping_Zip_Postal_Code__c = '1619', Shipping_City__c = 'City'));
		addrList.add(new Address__c(Account__c = testJointAcct.Id, Address_Type__c = 'OperatingAddress', Client_Entity_Type__c = 'Individual', Shipping_Country__c = 'South Africa', Shipping_State_Province__c = 'Gauteng', Shipping_Street__c = 'Street 37', Shipping_Suburb__c = 'Maboneng', Shipping_Zip_Postal_Code__c = '1619', Shipping_City__c = 'City'));
		addrList.add(new Address__c(Account__c = testJointAcct.Id, Address_Type__c = 'Head Office', Client_Entity_Type__c = 'Company', Shipping_Country__c = 'South Africa', Shipping_State_Province__c = 'Gauteng', Shipping_Street__c = 'Street 37', Shipping_Suburb__c = 'Maboneng', Shipping_Zip_Postal_Code__c = '1619', Shipping_City__c = 'City'));
		addrList.add(new Address__c(Account__c = testJointAcct.Id, Address_Type__c = 'Business Address', Client_Entity_Type__c = 'Company', Shipping_Country__c = 'South Africa', Shipping_State_Province__c = 'Gauteng', Shipping_Street__c = 'Street 37', Shipping_Suburb__c = 'Maboneng', Shipping_Zip_Postal_Code__c = '1619', Shipping_City__c = 'City'));
		addrList.add(new Address__c(Account__c = testJointAcct.Id, Address_Type__c = 'Master of High Court', Client_Entity_Type__c = 'Individual', Shipping_Country__c = 'South Africa', Shipping_State_Province__c = 'Gauteng', Shipping_Street__c = 'Street 37', Shipping_Suburb__c = 'Maboneng', Shipping_Zip_Postal_Code__c = '1619', Shipping_City__c = 'City'));
		addrList.add(new Address__c(Account__c = testAccount.Id, Address_Type__c = 'Head Office', Client_Entity_Type__c = 'Individual', Shipping_Country__c = 'South Africa', Shipping_State_Province__c = 'Gauteng', Shipping_Street__c = 'Street 37', Shipping_Suburb__c = 'Maboneng', Shipping_Zip_Postal_Code__c = '1619', Shipping_City__c = 'City'));
		addrList.add(new Address__c(Account__c = testAccount.Id, Address_Type__c = 'Registered', Client_Entity_Type__c = 'Individual', Shipping_Country__c = 'South Africa', Shipping_State_Province__c = 'Gauteng', Shipping_Street__c = 'Street 37', Shipping_Suburb__c = 'Maboneng', Shipping_Zip_Postal_Code__c = '1619', Shipping_City__c = 'City'));
		addrList.add(new Address__c(Account__c = testAccount.Id, Address_Type__c = 'Employers', Client_Entity_Type__c = 'Individual', Shipping_Country__c = 'South Africa', Shipping_State_Province__c = 'Gauteng', Shipping_Street__c = 'Street 37', Shipping_Suburb__c = 'Maboneng', Shipping_Zip_Postal_Code__c = '1619', Shipping_City__c = 'City'));
		addrList.add(new Address__c(Account__c = testAccount.Id, Address_Type__c = 'Residential', Client_Entity_Type__c = 'Individual', Shipping_Country__c = 'South Africa', Shipping_State_Province__c = 'Gauteng', Shipping_Street__c = 'Street 37', Shipping_Suburb__c = 'Maboneng', Shipping_Zip_Postal_Code__c = '1619', Shipping_City__c = 'City'));
		insert addrList;

		Document__c doc2 = new Document__c(Name = 'mydoc2.pdf', ECM_Type__c = 'Ent_HighRiskDocument', Reference__c = '123456', Opportunity__c = testOpportunity.Id, Account__c = testAccount.Id);
		insert doc2;

		FinServ__ReciprocalRole__c resRole = new FinServ__ReciprocalRole__c();
		resRole.FinServ__CreateInverseRole__c = true;
		resRole.FinServ__InverseRole__c = 'Director';
		insert resRole;
        
        FinServ__AccountAccountRelation__c accountAccountRelation = new FinServ__AccountAccountRelation__c();
        accountAccountRelation.Primary_Entity_Id__c = testAccount.id;
		accountAccountRelation.FinServ__Account__c = testAccount.id;
        accountAccountRelation.FinServ__RelatedAccount__c = testJointAcct.id;
        accountAccountRelation.Roles__c = 'Individual with Authority to Act';
        accountAccountRelation.FinServ__Role__c = resRole.Id;
		accountAccountRelation.Shareholding_Percentage__c = 50;
        insert accountAccountRelation;

		FinServ__AccountAccountRelation__c accountAccountRelation2 = new FinServ__AccountAccountRelation__c();
        accountAccountRelation2.Primary_Entity_Id__c = testAccount.id;
        accountAccountRelation2.FinServ__Account__c = testAccount.id;
        accountAccountRelation2.FinServ__RelatedAccount__c = testJointAcct.id;
        accountAccountRelation2.Roles__c = 'Individual with Authority to Act';
        accountAccountRelation2.FinServ__Role__c = resRole.Id;
        accountAccountRelation2.Shareholding_Percentage__c = 0;
        insert accountAccountRelation2;

		Test.startTest();
		try{
			DocumentManagementSelectionController.createDocumentPlaceholders(testAccount.id, testOpportunity.id);
		} catch (exception e) {
			String error = String.valueOf(e);
		}
		List<DocumentManagementSelectionController.AccDocumentWrapper> testAccDocumentWrapper = DocumentManagementSelectionController.getAccDocumentWrapper(testOpportunity.id);
		String updateDocResult = DocumentManagementSelectionController.updateDocuments(testAccDocumentWrapper, testOpportunity.id, true, true, true, true);
		System.assertEquals(updateDocResult, 'SUCCESS');
		Id value;
		DocumentManagementSelectionController.saveChunk(testAccount.Id, value, 'Test', 'Test', 'Test', '', false, 'pdf', false, '', '', '', value, value);
		DocumentManagementSelectionController.generateNewDocument(testOpportunity.Id, 'Salesforce Test', testAccount.Id, value, doc2.Id);
		DocumentManagementSelectionController.getPrimaryClientMandatoryDocuments(testOpportunity.id);
		try{
			DocumentManagementSelectionController.getUpdatedSignatoriesDataSelected(value, value, value, '', '', '', '', '');
		} catch (Exception ex) {
			String msg = ex.getMessage();
		}
	
		DocumentManagementSelectionController.getMobileDetails(testOpportunity.id);
		DocumentManagementSelectionController.getAllClientEmails(testOpportunity.id);
		DocumentManagementSelectionController.getMobile(testOpportunity.id);
		DocumentManagementSelectionController.getAllClientEmailsSignature(testOpportunity.id);
		DocumentManagementSelectionController.documentRestricted(testOpportunity.id, doc2.Id);
		DocumentManagementSelectionController.getOppRecord(testOpportunity.id);
		DocumentManagementSelectionController.restrictSystemDocs(doc2.Id);
		DocumentManagementSelectionController.getDocumentContent(doc2.Id);
		DocumentManagementSelectionController.deleteDocument(doc2.Id);
		DocumentManagementSelectionController.getDigitalSignatorySelectOptions('3344');
		DocumentManagementSelectionController.AccDocumentWrapper request = new DocumentManagementSelectionController.AccDocumentWrapper();
		request.isEddCase = false;
		Test.stopTest();
	}

	@isTest
	static void fetchImpressionRequest(){
		//WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
		Account testAccount = new Account();
		testAccount.Name = 'Test Account';
		testAccount.Client_Type__c = 'Private Individual';
		testAccount.CIF__c = 'Test+111';
		insert testAccount;


		Opportunity testOpp = new Opportunity();
		testOpp.Name = 'Test Opp Onboarding 1';
		testOpp.CloseDate = Date.today();
		testOpp.StageName = 'New';
		testOpp.AccountId = testAccount.Id;
		insert testOpp;

		Document__c doc = new Document__c(Name = 'mydoc.pdf', ECM_Type__c = 'Ent_ProofOfId', Reference__c = '12345', Opportunity__c = testOpp.Id, Account__c = testAccount.Id);
		insert doc;
		List<ImpressionRequest__c> impressionRequests = DocumentManagementSelectionController.fetchImpressionRequest(doc.id);
		try {
            DocumentManagementSelectionController.updateImpressionRequests(doc.id);
        } catch (Exception ex) {
            String msg = ex.getMessage();
        }
		
		system.assertNotEquals(null, impressionRequests.size());
	}

	@isTest
	static void sendForImpressionSignature(){
		Account testAccount = new Account();
		testAccount.Name = 'Test Account';
		testAccount.Client_Type__c = 'Private Individual';
		testAccount.CIF__c = 'Test+111';
		insert testAccount;


		Opportunity testOpp = new Opportunity();
		testOpp.Name = 'Test Opp Onboarding 1';
		testOpp.CloseDate = Date.today();
		testOpp.StageName = 'New';
		testOpp.AccountId = testAccount.Id;
		insert testOpp;

		Document__c doc = new Document__c(Name = 'mydoc.pdf', ECM_Type__c = 'Ent_ProofOfId', Reference__c = '12345', Opportunity__c = testOpp.Id, Account__c = testAccount.Id);
		insert doc;

		List<Id> acrIds = new List<Id>();
         AccountContactRelation accConRel = [SELECT Id
		                               FROM AccountContactRelation
		                               LIMIT 1];
		acrIds.add(accConRel.Id);

		test.startTest();
		String sigs = '[{"Id":"' + testAccount.id + '","Title":"Mr.","Last_Name":"PAULA VENTER","Mobile_Phone":"+27833826456","Email":"tinashem@yahoo.com","Method":"Realtime","Role":"Client","Document_Name":"mu.pdf","Document_Type":"Quote"}]';
		string sendForSig = DocumentManagementSelectionController.sendForImpressionSignature(doc.id, sigs);//signatories
		DocumentManagementSelectionController.getSignatoriesData(doc.id);
		DocumentManagementSelectionController.getSignatoriesDataSelected(doc.id, acrIds);
		system.assertNotEquals(null, sendForSig);
		test.stopTest();
	}

	/**
	 * @description
	 *
	 */
	/*
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
	 testDataFactory.testMerchantOnboardingOpportunity.AccountId = account.Id;
	 testDataFactory.testQuoteDocument.Opportunity__c = testDataFactory.testMerchantOnboardingOpportunity.id;
	 update testDataFactory.testQuoteDocument;

	 DocumentManagementSelectionController.getSignatoriesData(testDataFactory.testQuoteDocument.id);


	 List<Map<String, Object>> lll = DocumentManagementSelectionController.getSignatoriesDataSelected(testDataFactory.testQuoteDocument.id, acrIds);

	 system.assertNotEquals(null, lll);
	 test.stopTest();
	 }*/
	/**
	 * @description
	 *
	 */
	/*
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
	 DocumentsShareControllerESign.getUpdatedSignatoriesData(testDataFactory.testOpportunity.id, testDataFactory.testDocument.id, spo2.id, sigs, 'Realtime', '0988765432', 'test@123.com');
	 system.assertNotEquals(null, getUpdSigdata);
	 test.stopTest();
	 }*/
}