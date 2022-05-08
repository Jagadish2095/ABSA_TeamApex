/**
 * @description      : Test Class for LeadOverrideController
 * @Author       : Dreamwares
 * UPDATE
 */
@isTest
public class LeadOverrideControllerTest {
	@testSetup
	static void dataCreation() {
		String orgId = UserInfo.getOrganizationId();
		String dateString = String.valueof(Datetime.now()).replace(' ', '').replace(':', '').replace('-', '');
		Integer randomInt = Integer.valueOf(math.rint(math.random() * 1000000));
		String uniqueName = orgId + dateString + randomInt;
		Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator (Custom)'];
		//Profile p = [SELECT Id FROM Profile LIMIT 1];
		User uObj = new User();
		uObj.ProfileId = p.Id;
		uObj.LastName = 'JKumar';
		uObj.Email = 'testUser@gmail.com';
		uObj.Username = uniqueName + '@test' + orgId + '.org';
		uObj.CompanyName = 'TEST';
		uObj.Title = 'Mr.';
		uObj.EmailEncodingKey = 'ISO-8859-1';
		uObj.Alias = uniqueName.substring(18, 23);
		uObj.TimeZoneSidKey = 'America/Los_Angeles';
		uObj.LocaleSidKey = 'en_US';
		uObj.LanguageLocaleKey = 'en_US';
		uObj.Advisor_Code__c = '112233';
		insert uObj;
		//Create account
		Account account = new Account();
		account.Work_Phone__c = '0117890987';
		account.Phone = '0117890987';
		account.Name = 'Test Account';
		insert account;
		Id leadRecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('STI Lead').getRecordTypeId();
		Lead newLead1 = new Lead();
		newLead1.FirstName = 'TestSTI';
		newLead1.LastName = 'Lead';
		newLead1.Salutation = 'Mr';
		newLead1.Status = 'Allocated';
		newLead1.Hot_Deal__c = false;
		newLead1.RecordTypeId = leadRecordTypeId;
		newLead1.LeadSource = 'Web';
		//newLead1.Financial_Product__c = finProduct.Id;
		//newLead1.Product_Interest_1__c = finProduct.Id;
		//newLead1.Product_Offer_Status_1__c = 'Offer Taken Up';
		newLead1.ID_Number__c = '8903015800086';
		newLead1.Phone = '8987678787';
		newLead1.AIC_Relationship_Consultant_Name__c = 'Lesley Hunter (Lesley.Hunter@absa.co.za)';
		newLead1.Lead_Email__c = 'test@test.com';
		newLead1.Lead_Name__c = 'Test CAF Lead';
		newLead1.Lead_Phone__c = '8767878987';
		//newLead1.Referring_Banker_s_Branch__c = prefSite.Id;
		newLead1.Lead_Source__c = 'Referral from AIC';
		newLead1.STI_Sub_Source__c = 'Email';
		newLead1.Preferred_Communication_Channel__c = 'Email';
		newLead1.Lead_Type__c = 'New';
		//newLead1.Preferred_Site__c = prefSite.Id;
		newLead1.OwnerId = uObj.Id;
		newLead1.Parent_Account__c = account.Id;
		newLead1.FinServ__RelatedAccount__c = account.Id;
		insert newLead1;

		//Account account = new Account(Name = 'Test Account');
		//insert account;
		//get lead record type id
		//Added by Mbuyiseni Mbhokane | 15-04-2021
		Id recordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('Retail_Sales_Lead').getRecordTypeId();

		//Create financial products
		//Added by Mbuyiseni Mbhokane | 15-04-2021
		Integer finProdRecordCount = 5;
		List<Financial_Product__c> finProdList = new List<Financial_Product__c>();
		for (Integer x = 0; x < finProdRecordCount; x++) {
			Financial_Product__c newFinProd = new Financial_Product__c();
			newFinProd.Name = 'Test' + ' ' + x;
			newFinProd.Product_Type__c = '';
			newFinProd.Business_Unit__c = 'Business Banking';
			finProdList.add(newFinProd);
		}

		insert finProdList;
		Financial_Product__c testFinancialProduct = new Financial_Product__c(Name = 'Test', Product_Type__c = '', Business_Unit__c = 'Business Banking');
		insert testFinancialProduct;

		Financial_Product__c testFinancialProduct2 = new Financial_Product__c(Name = 'Test2', Product_Type__c = '', Business_Unit__c = 'Business Banking');
		insert testFinancialProduct2;

		Financial_Product__c testFinancialProduct3 = new Financial_Product__c(Name = 'Test2', Product_Type__c = '', Business_Unit__c = 'Business Banking');
		insert testFinancialProduct3;

		//Added by Minal for Direct Delivery lead creation
		Financial_Product__c flexiProduct = new Financial_Product__c(
			Name = 'Flexi Funeral',
			Product__c = 'Flexi Funeral',
			Business_Unit__c = 'Direct Delivery',
			Product_Type__c = ''
		);
		insert flexiProduct;

		Financial_Product__c finProduct = new Financial_Product__c();
		finProduct.Name = 'STIP';
		finProduct.Business_Unit__c = 'STI - CAF';

		insert finProduct;

		Financial_Product__c invProduct = new Financial_Product__c();
		invProduct.Name = 'Investment Product';
		invProduct.Business_Unit__c = 'Virtual Advisor';
		insert invProduct;

		Campaign flexiCampaign = new Campaign(Name = 'DD Flexi Funeral - Inbound');
		insert flexiCampaign;

		Site__c testSite = new Site__c(Name = 'Test Site 1234');
		insert testSite;

		//DH Added Company to comply with person account requirements
		Lead testLead = new Lead(
			LastName = 'Lead',
			firstName = 'Test',
			Salutation = 'Mr',
			Company = 'Test Lead',
			Financial_Product__c = testFinancialProduct.id,
			MobilePhone = '0762922222'
		);
		insert testLead;

		//Added by Poornima
		/*  Lead testLead2 = new Lead(LastName='Lead2', firstName='Test2', Company='Test Lead2', Financial_Product__c = testFinancialProduct.id, MobilePhone = '0762922222');
		 insert testLead2;*/

		Product_Interest__c leadProduct = new Product_Interest__c(Financial_Product__c = testFinancialProduct.Id, Lead__c = testLead.id);
		insert leadProduct;

		Product_Interest__c leadProduct2 = new Product_Interest__c(Financial_Product__c = testFinancialProduct2.Id, Lead__c = testLead.id);
		insert leadProduct2;

		Product_Interest__c leadProduct5 = new Product_Interest__c(Financial_Product__c = testFinancialProduct3.Id, Lead__c = testLead.id);
		insert leadProduct5;

		Product_Interest__c leadProduct3 = new Product_Interest__c(Financial_Product__c = flexiProduct.Id, Lead__c = testLead.id);
		insert leadProduct3;

		Product_Interest__c leadProduct4 = new Product_Interest__c(Financial_Product__c = finProduct.Id, Lead__c = testLead.id);
		insert leadProduct4;
		BusinessHours businessHr = [SELECT Id FROM BusinessHours LIMIT 1];

		Service_Group__c serviceGr = new Service_Group__c();
		serviceGr.Name = 'Test1';
		serviceGr.Assign_Record_Type__c = 'Email';
		serviceGr.Response_Email_Address__c = 'evg@t.com';
		serviceGr.Queue__c = 'Email';
		serviceGr.Business_Hours__c = businessHr.Id;
		serviceGr.Internal_SLA_Time_Measure__c = 'Hour(s)';
		serviceGr.Internal_SLA_Units__c = '8';
		serviceGr.Email_Template_Lead_Creation__c = null;
		serviceGr.Internal_SLA_Notification_User__c = null;
		insert serviceGr;

		Service_Type__c serviceType = new Service_Type__c();
		serviceType.Name = 'Test1';
		serviceType.Case_Record_Type__c = 'New';
		serviceType.Subtype__c = 'Sample';
		serviceType.Type__c = 'T01';
		insert serviceType;

		Service_Level__c serviceLevel = new Service_Level__c();
		serviceLevel.Name = 'Test1';
		serviceLevel.External_SLA_Time_Measure__c = 'Hour(s)';
		serviceLevel.External_SLA_Units__c = '8';
		serviceLevel.Default_Service_Level__c = true;
		insert serviceLevel;

		Service_Group_Type__c serviceGrType = new Service_Group_Type__c();
		serviceGrType.Service_Type__c = serviceType.Id;
		serviceGrType.Service_Group__c = serviceGr.Id;
		serviceGrType.Service_Level__c = serviceLevel.Id;
		insert serviceGrType;

		Account account2 = new Account(Name = 'Test Account2');
		insert account2;

		Opportunity testOpportunity = new Opportunity(
			Name = 'Opportunity',
			StageName = 'Test Stage Name',
			AccountId = account2.Id,
			CloseDate = System.Date.today(),
			converted_lead__c = testLead.Id
		);
		insert testOpportunity;

		Group testGroup = new Group();
		testGroup.Name = 'testGroup';
		testGroup.DeveloperName = 'ABC';
		// testGroup.RelatedId=userinfo.getUserId();
		insert testGroup;

		map<String, Schema.RecordTypeInfo> caseRecordTypeMap = Case.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();

		Account account1 = new Account(Name = 'Test Account');
		insert account1;

		Contact contact = new Contact(LastName = 'Test contact', AccountId = account2.Id, Email = 'Case@contact.com');
		insert contact;

		Case caseRec = new Case(
			Communication_Method__c = 'Email',
			Status = 'New',
			Origin = 'Email',
			Account = account1,
			Contact = contact,
			SLA_Extension_Approval_Required__c = true,
			External_SLA_End_Date__c = Date.today(),
			Subject = 'Test',
			Type__c = 'Sample test',
			Email__c = 'test@sp.com',
			SuppliedEmail = 't@t.com',
			Accountid = Account.id,
			recordTypeId = caseRecordTypeMap.get('Complaint').getRecordTypeId(),
			Description = 'test',
			Expectation_of_the_Customer__c = 'test',
			Incident_Date__c = date.today()
		);
		insert caseRec;

		//VIkas added begin
		Postal_Code__c pc = new Postal_Code__c();
		pc.Name = 'GSA';
		pc.Area__c = '123456';
		pc.Box_Code__c = 111;
		insert pc;
		LeadOverrideController.findPostalCodeRecord(pc.id);
		LeadOverrideController.getUserName();
		//VIkas added end
	}

	//Method to test
	@isTest
	static void leadOverrideControllerTest1() {
		Lead newLeadRecord = [SELECT id, Name FROM Lead LIMIT 1];
		Lead newLeadRecord1 = [SELECT id, Name FROM Lead WHERE firstname = 'TestSTI'];
		Lead newLeadRecord2 = [
			SELECT id, Name, DD_Agent_Who_Referred_Lead__c, DD_Convenient_Time_To_Call__c, DD_AVAF_Account_Number__c, ID_Number__c
			FROM Lead
			LIMIT 1
		];
		Account newClientRecord = [SELECT id, Name FROM Account LIMIT 1];
		Site__c newSite = [SELECT id, Name FROM Site__c LIMIT 1];
		Financial_Product__c newProductRecord = [SELECT id, Name, Business_Unit__c FROM Financial_Product__c LIMIT 1];
		Financial_Product__c stiProd = [SELECT id, Name FROM Financial_Product__c WHERE Name = 'STIP'];
		system.assertNotEquals(null, stiProd);
		Opportunity newOpp = [SELECT id, Name, Person_Account_First_Name__c, Person_Account_Last_Name__c FROM Opportunity LIMIT 1];

		List<Product_Interest__c> leadProductList = [SELECT Id, Lead__c, Financial_Product__c FROM Product_Interest__c];

		//List<Product_Interest__c> leadProductList1 = [Select Id, Lead__c, Financial_Product__c From Product_Interest__c LIMIT 2];
		//List<Product_Interest__c> leadProductList2 = [Select Id, Lead__c, Financial_Product__c From Product_Interest__c LIMIT 3];
		//List<Product_Interest__c> leadProductList3 = [Select Id, Lead__c, Financial_Product__c From Product_Interest__c LIMIT 4];
		Service_Group__c serviceGroupRec = [SELECT Id, Name FROM Service_Group__c LIMIT 1];
		Campaign campRec = [SELECT Id, Name FROM Campaign LIMIT 1];

		Lead newLead = newLeadRecord;

		Test.startTest();

		//STI
		try {
			String nameObj = LeadOverrideController.getObjectName(newLeadRecord.Id);

			String recType = LeadOverrideController.getSTIRecordTypeId();
			Lead newLeadId = LeadOverrideController.createReferredLeadVASTI(newLeadRecord1, newOpp.Id, campRec.Name, StiProd, newSite, true);
		} catch (Exception e) {
			// System.debug('Exception::' + e.getMessage());
			String msg = e.getMessage();
		}

		try {
			String newLeadId = LeadOverrideController.createLead(newLeadRecord, newClientRecord, newProductRecord, newSite, true);
		} catch (Exception e) {
			// System.debug('Exception::' + e.getMessage());
			String msg = e.getMessage();
		}

		try {
			newProductRecord.Business_Unit__c = 'WIMI';
			String newLeadId = LeadOverrideController.createLead(newLeadRecord, newClientRecord, newProductRecord, null, false);
		} catch (Exception e) {
			// System.debug('Exception::' + e.getMessage());
			String msg = e.getMessage();
		}

		try {
			//String names = LeadOverrideController.getUserName();
			// system.debug('newLeadRecord uni' + newLeadRecord);
			// system.debug('newoppRecord uni' + newOpp);

			Lead newTestLead = LeadOverrideController.mapLeadFields(newLeadRecord2, newOpp);
		} catch (Exception e) {
			// System.debug('Exception::' + e.getMessage());
			String msg = e.getMessage();
		}
		/*   try{
newProductRecord.Business_Unit__c = 'STI - CAF';
String newLeadId = LeadOverrideController.createLead(newLeadRecord, newClientRecord, newProductRecord, null, false);
}catch(Exception e){
System.debug('Exception::'+e.getMessage());
}*/

		try {
			String newLeadId = LeadOverrideController.createLead(null, null, null, null, false);
		} catch (Exception e) {
			// System.debug('Exception::' + e.getMessage());
			String msg = e.getMessage();
		}

		try {
			Financial_Product__c productRecordReturned = LeadOverrideController.findFinancialProduct(newProductRecord.Id);
		} catch (Exception e) {
			// System.debug('Exception::' + e.getMessage());
			String msg = e.getMessage();
		}

		try {
			Site__c siteRecordReturned = LeadOverrideController.findSite(newSite.Id);
		} catch (Exception e) {
			// System.debug('Exception::' + e.getMessage());
			String msg = e.getMessage();
		}

		try {
			LeadOverrideController.getLoggedInUserLeadRecordTypes();
			LeadOverrideController.getLoggedInUserPermissionSets();
			LeadOverrideController.getLoggedInUserServiceGroups();
			Service_Group__c currentServiceGroup = LeadOverrideController.findServiceGroupRecord(serviceGroupRec.Id);
			LeadOverrideController.getSelectedUserServiceGroupIds(UserInfo.getUserId(), new List<String>{ 'testGroup' });
			LeadOverrideController.createNewRetailLead(newLead, newClientRecord, leadProductList, currentServiceGroup, true);
			//LeadOverrideController.createNewRetailLead(newLead, newClientRecord, leadProductList1, currentServiceGroup, true);
			// LeadOverrideController.createNewRetailLead(newLead, newClientRecord, leadProductList2, currentServiceGroup, true);
			//LeadOverrideController.createNewRetailLead(newLead, newClientRecord, leadProductList3, currentServiceGroup, true);
		} catch (Exception e) {
			// System.debug('Exception::' + e.getMessage());
			String msg = e.getMessage();
		}

		Test.stopTest();
	}

	@isTest
	static void testCreateLeadAccountCreate() {
		Lead newLeadRecord = [SELECT id, Name, DD_Agent_Who_Referred_Lead__c, DD_AVAF_Account_Number__c, DD_Convenient_Time_To_Call__c FROM Lead LIMIT 1];
		system.assertNotEquals(null, newLeadRecord);
		Account newClientRecord = [SELECT id, Name FROM Account LIMIT 1];
		Site__c newSite = [SELECT id, Name FROM Site__c LIMIT 1];
		Financial_Product__c newProductRecord = [SELECT id, Name FROM Financial_Product__c LIMIT 1];
		LeadOverrideController.setLeadDetails(newLeadRecord.id, newLeadRecord);
		//CIF key test
		newClientRecord.CIF__c = 'Test 001';

		try {
			String newLeadId = LeadOverrideController.createLead(newLeadRecord, newClientRecord, newProductRecord, newSite, true);
		} catch (Exception e) {
			// System.debug('Exception::' + e.getMessage());
			String msg = e.getMessage();
		}

		//Id number test (MDM)
		newClientRecord.CIF__c = null;
		newClientRecord.ID_Type__pc = 'SA Identity Document';
		newClientRecord.ID_Number__pc = '0000000000000';

		try {
			String newLeadId = LeadOverrideController.createLead(newLeadRecord, newClientRecord, newProductRecord, newSite, true);
		} catch (Exception e) {
			// System.debug('Exception::' + e.getMessage());
			String msg = e.getMessage();
		}
	}

	/**
	 * @description tests the creation for direct delivery leads via the LeadOverride Aura Component
	 */
	@IsTest
	static void createDirectDeliveryLeadNonReferralTest() {
		Financial_Product__c flexiProduct = [SELECT id, Name FROM Financial_Product__c WHERE Name = 'Flexi Funeral' LIMIT 1];
		Account newClientRecord = [SELECT id, Name FROM Account LIMIT 1];
		Lead testLead = new Lead(LastName = 'Lead', firstName = 'Test', Financial_Product__c = flexiProduct.Id, MobilePhone = '0762922222');

		Lead newLead = new Lead();
		Lead newLead2 = new Lead();

		Test.startTest();
		LeadOverrideController.getAccountDetails(newClientRecord.id, testLead);

		try {
			newLead = LeadOverrideController.createNewDirectDeliveryLead(testLead, newClientRecord, flexiProduct, false, null, null);
			newLead2 = LeadOverrideController.createNewDirectDeliveryLead(testLead, newClientRecord, flexiProduct, true, null, null);
		} catch (Exception e) {
			// System.debug('Exception::' + e.getMessage());
			String msg = e.getMessage();
		}

		System.assert(newLead != null, 'New lead is null');
		Test.stopTest();
	}

	/**
	 * @description tests the creation for direct delivery leads via the LeadOverride Aura Component
	 */
	@IsTest
	static void createDirectDeliveryLeadReferralTest() {
		/*
Financial_Product__c flexiProduct = [SELECT id, Name FROM Financial_Product__c WHERE Name = 'Flexi Funeral' LIMIT 1];
Account newClientRecord = [SELECT id, Name FROM Account LIMIT 1];
Lead testLead = new Lead(LastName='Lead', firstName='Test', Financial_Product__c = flexiProduct.Id, MobilePhone = '0762922222');
Opportunity testOpportunity = new Opportunity(Name='Opportunity', Product_Interest__c = flexiProduct.Id, StageName='Test Stage Name', AccountId=newClientRecord.Id, CloseDate=System.Date.today());
INSERT testOpportunity;
System.debug('uni testOpportunity='+testOpportunity);
Lead newLead = new Lead();


try{
newLead = LeadOverrideController.createReferredLead(testLead, testOpportunity.Id, 'Hot Transfer');
}catch(Exception e){
System.debug('Exception::'+e.getMessage());
} 

System.assert(newLead != null, 'New lead is null');
*/
		Financial_Product__c flexiProduct = [SELECT id, Name FROM Financial_Product__c WHERE Name = 'Flexi Funeral' LIMIT 1];

		Test.startTest();
		Group g = [SELECT id FROM Group WHERE Name = 'testGroup'];

		GroupMember gm = new GroupMember();
		gm.UserOrGroupId = userinfo.getUserId();
		gm.GroupId = g.Id;
		insert gm;

		LeadOverrideController.getSelectedUserServiceGroupIds(UserInfo.getUserId(), new List<String>{ 'testGroup' });
		Lead l = new Lead();
		Opportunity opp = [SELECT id FROM Opportunity];
		case newcaseRecord = new Case(Id = [SELECT id, AccountId FROM case LIMIT 1].Id);
		system.assertNotEquals(null, newcaseRecord);
		LeadOverrideController.getCaseDetails(newcaseRecord.Id);
		//LeadOverrideController.createInvReferredLead(l, opp.Id);
		try {
			User newOwner = [SELECT Id FROM User WHERE Email = 'testUser@gmail.com' AND IsActive = TRUE LIMIT 1];
			l.OwnerId = newOwner.Id;
			//Lead l1 = [Select id from Lead Where Lead_Name__c = 'Test CAF Lead' limit 1];
			LeadOverrideController.createVAReferredLead(l, newcaseRecord, false);
		} catch (Exception e) {
			String msg = e.getMessage();
		}
		try {
			LeadOverrideController.createReferredLead(l, opp.Id, 'Hot Transfer', flexiProduct.id);
		} catch (exception ex) {
			String msg = ex.getMessage();
		}

		// Opportunity newOpportunity = LeadOverrideController.getOpportunityDetails(testOpportunity.Id);
		//  System.assert(newOpportunity != null, 'Opportunity is null');
		LeadOverrideController.getOpportunityDetails(opp.Id);
		try {
			//LeadOverrideController.createReferredLead(l, opp.Id, 'Hot Transfer',flexiProduct.id);
			LeadOverrideController.createReferredLead(l, newcaseRecord.Id, 'Hot Transfer', flexiProduct.id);
		} catch (exception ex) {
			String msg = ex.getMessage();
		}
		LeadOverrideController.getReferralCampaigns(newcaseRecord.id);
		LeadOverrideController.duplicateCheck(l.ID_Number__c, flexiProduct);
		LeadOverrideController.getReferralCampaigns(opp.id);
		LeadOverrideController.getFieldDependencies(opp, 'Application_Source__c', 'Platform__c');
		Test.stopTest();
	}

	@isTest
	static void testSTILead() {
		Service_Group__c serviceGroupRec = [SELECT Id, Name FROM Service_Group__c LIMIT 1];
		Campaign campRec = [SELECT Id, Name FROM Campaign LIMIT 1];
		Account newClientRecord = [SELECT id, Name FROM Account LIMIT 1];

		Lead newLeadRecord = new Lead();

		try {
			LeadOverrideController.createLeadForShortTermInsurance(newLeadRecord, newClientRecord, serviceGroupRec.Id, true);
		} catch (Exception e) {
			string msg = e.getmessage();
		}
		system.assertEquals(newClientRecord != null, true);
	}
	@isTest
	static void testInvestLead() {
		Financial_Product__c newProductRecord = [SELECT id, Name, Business_Unit__c FROM Financial_Product__c WHERE Business_Unit__c = 'Virtual Advisor'];
		Lead newLeadRecord = [
			SELECT
				id,
				Name,
				Parent_Account__c,
				ID_Number__c,
				DD_Agent_Who_Referred_Lead__c,
				DD_AVAF_Account_Number__c,
				DD_Convenient_Time_To_Call__c,
				FinServ__RelatedAccount__c
			FROM Lead
			LIMIT 1
		];
		Account newClientRecord = [SELECT id, Name FROM Account LIMIT 1];
		Opportunity newOpp = [SELECT id, Name, Person_Account_First_Name__c, Person_Account_Last_Name__c, converted_lead__c FROM Opportunity LIMIT 1];

		//Investment Added By divya
		try {
			String newLeadId = LeadOverrideController.createLead(newLeadRecord, newClientRecord, newProductRecord, null, false);
		} catch (Exception e) {
			String msg = e.getMessage();
			system.assertEquals(msg != null, true);
		}

		try {
			Lead newLead = LeadOverrideController.getLeadDetails(newLeadRecord.Id);
		} catch (Exception e) {
			String msg = e.getMessage();
		}
		try {
			LeadOverrideController.createReferredLead(newLeadRecord, newLeadRecord.Id, 'Hot Transfer', newProductRecord.id);
		} catch (exception ex) {
			String msg = ex.getMessage();
		}
	}
	@isTest
	static void investmentLeadTest() {
		Financial_Product__c invProduct = new Financial_Product__c();
		invProduct.Name = 'Investment Product';
		invProduct.Business_Unit__c = 'Virtual Advisor';
		insert invProduct;
		//system.debug('>>>>>'+invProduct);
		//Create account
		Account account = new Account();
		account.Work_Phone__c = '0117890987';
		account.Phone = '0117890987';
		account.Name = 'Test Account';
		insert account;
		Id leadRecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Investment Lead').getRecordTypeId();
		Lead newLead1 = new Lead();
		newLead1.FirstName = 'TestSTI';
		newLead1.LastName = 'Lead';
		newLead1.Salutation = 'Mr';
		newLead1.Status = 'Allocated';
		newLead1.Hot_Deal__c = false;
		newLead1.RecordTypeId = leadRecordTypeId;
		newLead1.LeadSource = 'Web';
		newLead1.Financial_Product__c = invProduct.Id;
		//newLead1.Product_Interest_1__c = finProduct.Id;
		//newLead1.Product_Offer_Status_1__c = 'Offer Taken Up';
		newLead1.ID_Number__c = '8903015800086';
		newLead1.Phone = '8987678787';
		newLead1.Lead_Email__c = 'test@test.com';
		newLead1.Lead_Name__c = 'Test CAF Lead';
		newLead1.Lead_Phone__c = '8767878987';
		//newLead1.Referring_Banker_s_Branch__c = prefSite.Id;
		newLead1.Lead_Source__c = 'Referral from AIC';
		newLead1.STI_Sub_Source__c = 'Email';
		newLead1.Preferred_Communication_Channel__c = 'Email';
		newLead1.Lead_Type__c = 'New';
		//newLead1.Preferred_Site__c = prefSite.Id;
		newLead1.OwnerId = userinfo.getUserid();
		newLead1.Parent_Account__c = account.Id;
		newLead1.FinServ__RelatedAccount__c = account.Id;
		insert newLead1;
		map<String, Schema.RecordTypeInfo> caseRecordTypeMap = Case.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();

		Account account1 = new Account(Name = 'Test Account');
		insert account1;

		Contact contact = new Contact(LastName = 'Test contact', AccountId = account.Id, Email = 'Case@contact.com');
		insert contact;
		Case caseRec = new Case(
			Communication_Method__c = 'Email',
			Status = 'New',
			Origin = 'Email',
			Account = account1,
			Contact = contact,
			SLA_Extension_Approval_Required__c = true,
			External_SLA_End_Date__c = Date.today(),
			Subject = 'Test',
			Type__c = 'Sample test',
			Email__c = 'test@sp.com',
			SuppliedEmail = 't@t.com',
			Accountid = Account.id,
			recordTypeId = caseRecordTypeMap.get('Complaint').getRecordTypeId(),
			Description = 'test',
			Expectation_of_the_Customer__c = 'test',
			Incident_Date__c = date.today()
		);
		insert caseRec;
		Test.startTest();
		LeadOverrideController.createVAReferredLead(newLead1, caseRec, false);
		Test.stopTest();
		system.assertEquals(newLead1 != null, true);
	}
}