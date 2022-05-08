/**
 * @description GenerateDocumentTest Description
 * This is a test class for Generate Document
 * Removed the bit about generating data in this class to rather use WimiTestDataFactory
 * merged with a2qa
 * UAT defects 31-08-2021
 */

@isTest
public class GenerateDocumentTest{
	@TestSetup
	static void makeData(){
		//WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
		Map<String, Schema.RecordTypeInfo> AccountRecordTypeMap = Account.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
		Map<String, Schema.RecordTypeInfo> OpportunityRecordTypeMap = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
		Map<String, Schema.RecordTypeInfo> LookupRecordTypeMap = Lookup__c.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
		Map<String, Schema.RecordTypeInfo> AssetRecordTypeMap = Asset.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
		Map<String, Schema.RecordTypeInfo> AplicationRecordTypeMap = Application__c.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();

		//Site
		Site__c testSite = new Site__c(Active__c = true, Branch_Site_Name__c = 'Aberdeen', Site_Code__c = '1010');
		insert testSite;

		//Products
		Id pricebookId = Test.getStandardPricebookId();

		//For Policy without Spouse
		Product2 product1 = new Product2();
		product1.name = 'EPP Executor Fees Policy';
		product1.IsActive = true;
		insert product1;
		PricebookEntry pricebookEntry1 = new PricebookEntry();
		pricebookEntry1.UnitPrice = 0;
		pricebookEntry1.Product2Id = product1.id;
		pricebookEntry1.Pricebook2Id = pricebookId;
		pricebookEntry1.IsActive = true;
		insert pricebookEntry1;

		//Contact
		Contact testContact = new Contact();
		testContact.FirstName = 'Test';
		testContact.LastName = 'Contact';
		testContact.Title = 'Mr.';
		testContact.Salutation = 'Mr.';
		testContact.CASA_Reference_Number__c = '1712994';
		testContact.CASA_Risk_Status__c = 'Low';
		testContact.CASA_Screening_Date__c = Date.valueOf('2018-06-30');
		testContact.CASA_Screening_Status__c = 'Approved';
		testContact.CASA_Analyst_Comments__c = '30406';
		testContact.Occupation__c = 'South Africa';
		testContact.Income_Source__c = 'Bonus';
		testContact.Occupation_Status__c = 'Full Time Employed';
		testContact.Income_Bracket__c = 'R20;000 - R75;000 pm';
		testContact.Occupation_Category__c = 'Advertising';
		testContact.Communication_Language__c = 'Afrikaans';
		testContact.ID_Type__c = 'SA Identity Document';
		testContact.Nationality__c = 'South Africa';
		testContact.Country_of_Origin__c = 'South Africa';
		testContact.Country_of_Residence__c = 'South Africa';
		testContact.Country_of_Birth__c = 'South Africa';
		testContact.MobilePhone = '0747003747';
		testContact.AssistantPhone = '0112232233';
		testContact.Fax = '0112232233';
		testContact.HomePhone = '0112232233';
		testContact.OtherPhone = '0112232233';
		testContact.Phone = '0112232233';
		testContact.AssistantName = 'Test Assistant';
		testContact.Email = 'test123@test.com';
		testContact.FinServ__CurrentEmployer__c = 'Current Employer';
		testContact.Initials__c = 'JJ';
		testContact.Maiden_Name__c = 'Monroe';
		testContact.MailingStreet = 'Test Mailing';
		testContact.OtherStreet = 'Test Other';
		insert testContact;

		//Account
		Account testAccount = new Account();
		testAccount.RecordTypeId = AccountRecordTypeMap.get('Individual_Client').getRecordTypeId();
		testAccount.CASA_Reference_Number__c = '1712994';
		testAccount.CASA_Risk_Status__c = 'Low';
		testAccount.CASA_Screening_Date__c = Date.valueOf('2018-06-30');
		testAccount.CASA_Screening_Status__c = 'Approved';
		testAccount.CASA_Analyst_Comments__c = '30406';
		testAccount.PersonMobilePhone = '0747003747';
		testAccount.Country_of_Residence__pc = 'South Africa';
		testAccount.PersonBirthdate = Date.valueOf('1981-07-11');
		testAccount.PersonEmail = 'test@test.co.za';
		testAccount.FirstName = 'Tony';
		testAccount.External_Siebel_ID__c = '1-1IV9MC';
		testAccount.ID_Number__pc = '8107115017084';
		testAccount.ID_Type__pc = 'SA Identity Document';
		testAccount.LastName = 'Stark';
		testAccount.Nationality__pc = 'South Africa';
		testAccount.Occupation__pc = 'Engineer';
		testAccount.Onboarding_Channel__c = 'Test';
		testAccount.Communication_Language__pc = 'Afrikaans';
		testAccount.PersonTitle = 'Mr.';
		testAccount.Client_Type__c = 'Individual Client';
		testAccount.Phone = '0114453322';
		testAccount.Gender__pc = 'Male';
		testAccount.Initials__pc = 'T';
		testAccount.Country_of_Birth__pc = 'South Africa';
		testAccount.Marital_Status__pc = 'Married';
		testAccount.Marital_Contract_Type__pc = 'Community of Property';
		testAccount.Income_Source__pc = 'Bonus';
		testAccount.Occupation_Status__pc = 'Full Time Employed';
		testAccount.Income_Bracket__pc = 'R20;000 - R75;000 pm';
		testAccount.Occupation_Category__pc = 'Advertising';
		testAccount.ShippingCity = 'CAPE TOWN';
		testAccount.ShippingCountry = 'South Africa';
		testAccount.ShippingStreet = '01 PUERTA DEL SOL';
		testAccount.ShippingPostalCode = '8001';
		testAccount.BillingCity = 'GROBLERSDAL';
		testAccount.BillingCountry = 'South Africa';
		testAccount.BillingStreet = '01 MABOPANE SECTION';
		testAccount.BillingPostalCode = '1060';
		testAccount.CIF__c = 'AFIFTAP001';
		testAccount.Alternative_Email__c = 'test@test.com';
		testAccount.Alternative_Email_1__c = 'test@test.com';
		testAccount.Alternative_Email_2__c = 'test@test.com';
		testAccount.Alternative_Email_3__c = 'test@test.com';
		testAccount.Alternative_Email_4__c = 'test@test.com';
		testAccount.PersonAssistantPhone = '0114453322';
		testAccount.PersonAssistantName = 'Test Name';
		testAccount.PersonHomePhone = '0114453322';
		testAccount.PersonOtherPhone = '0114453322';
		testAccount.Phone = '0114453322';
		testAccount.Fax = '0114453322';
		testAccount.FinServ__CurrentEmployer__pc = 'Current Employer';
		//testAccount.AccountNumber = '009091209090';
		testAccount.Identify_the_account_holder_type__c = 'Active Non Financial  Entity (ANFE)';
		testAccount.Date_Established__c = system.today();
		testAccount.registration_number__c = '123456789';
		testAccount.Is_Marketing_Consent_voice_rec__c = true;
		testAccount.Is_Marketing_Consent_Email__c = true;
		testAccount.Is_Marketing_Consent_SMS__c = true;
		testAccount.Reason_For_Not_Providing_SA_Tax_Number__c = 'CUSTOMER UNABLE OR UNWILLING TO PROVIDE';
		testAccount.share_information_to_third_party__c = true;
		testAccount.Industry = 'Agriculture, Hunting, Forestry And Fishing';
		testAccount.Post_Matric_Qualification__pc = 'Masters';
		insert testAccount;

		//Joint Account
		Account testJointAccount = new Account();
		testJointAccount.RecordTypeId = AccountRecordTypeMap.get('Client').getRecordTypeId();
		testJointAccount.Name = 'TEST MR JA & TEST MRS J';
		testJointAccount.Client_Type__c = 'Joint & Several';
		testJointAccount.CASA_Reference_Number__c = '1712994';
		testJointAccount.CASA_Risk_Status__c = 'Low';
		testJointAccount.CASA_Screening_Date__c = Date.valueOf('2018-06-30');
		testJointAccount.CASA_Screening_Status__c = 'Approved';
		testJointAccount.CASA_Analyst_Comments__c = '30406';
		testJointAccount.Country_of_Registration__c = 'South Africa';
		testJointAccount.CIF__c = 'NAIARA+001';
		testJointAccount.Is_Marketing_Consent_voice_rec__c = true;
		testJointAccount.Is_Marketing_Consent_Email__c = true;
		testJointAccount.Is_Marketing_Consent_SMS__c = true;
		insert testJointAccount;

		//Prospect Account
		Account testProspectAccount = new Account();
		testProspectAccount.FirstName = 'Test';
		testProspectAccount.LastName = 'Contact';
		testProspectAccount.PersonTitle = 'Mr.';
		testProspectAccount.CASA_Reference_Number__pc = '1712994';
		testProspectAccount.CASA_Risk_Status__pc = 'Low';
		testProspectAccount.CASA_Screening_Date__pc = Date.valueOf('2018-06-30');
		testProspectAccount.CASA_Screening_Status__pc = 'Approved';
		testProspectAccount.CASA_Analyst_Comments__pc = '30406';
		testProspectAccount.Occupation__pc = 'South Africa';
		testProspectAccount.Income_Source__pc = 'Bonus';
		testProspectAccount.Occupation_Status__pc = 'Full Time Employed';
		testProspectAccount.Income_Bracket__pc = 'R20;000 - R75;000 pm';
		testProspectAccount.Occupation_Category__pc = 'Advertising';
		testProspectAccount.Communication_Language__pc = 'Afrikaans';
		testProspectAccount.ID_Type__pc = 'SA Identity Document';
		testProspectAccount.Nationality__pc = 'South Africa';
		testProspectAccount.Country_of_Origin__pc = 'South Africa';
		testProspectAccount.Country_of_Residence__pc = 'South Africa';
		testProspectAccount.Country_of_Birth__pc = 'South Africa';
		testProspectAccount.PersonMobilePhone = '0747003747';
		testProspectAccount.RecordTypeId = AccountRecordTypeMap.get('Individual_Client').getRecordTypeId();
		testProspectAccount.ShippingCity = 'CAPE TOWN';
		testProspectAccount.ShippingCountry = 'South Africa';
		testProspectAccount.ShippingStreet = '01 PUERTA DEL SOL';
		testProspectAccount.ShippingPostalCode = '8001';
		testProspectAccount.BillingCity = 'GROBLERSDAL';
		testProspectAccount.BillingCountry = 'South Africa';
		testProspectAccount.BillingStreet = '01 MABOPANE SECTION';
		testProspectAccount.BillingPostalCode = '1060';
		testProspectAccount.Is_Marketing_Consent_voice_rec__c = true;
		testProspectAccount.Is_Marketing_Consent_Email__c = true;
		testProspectAccount.Is_Marketing_Consent_SMS__c = true;
		insert testProspectAccount;

		Id testProspectAccountContactId = [Select Id, PersonContactId
		                                   FROM Account
		                                   WHERE Id = :testProspectAccount.Id].PersonContactId;

		AccountContactRelation testAccountContactRelation = new AccountContactRelation();
		testAccountContactRelation.AccountId = testJointAccount.id;
        testAccountContactRelation.Primary_Entity_Id__c = testJointAccount.id;
		testAccountContactRelation.ContactId = testProspectAccountContactId;
		testAccountContactRelation.UBO__c = 'Yes';
		testAccountContactRelation.roles = 'Director;Individual with Authority to Act;Managing Director/Chief Executive Officer;Shareholder/Controller;Contact Person;Operators on primary accounts ( Internet Main Users, Signatories, Card Users)';
		insert testAccountContactRelation;

		FinServ__ReciprocalRole__c resRole = new FinServ__ReciprocalRole__c();
		resRole.FinServ__CreateInverseRole__c = true;
		resRole.FinServ__InverseRole__c = 'Director';
		insert resRole;
        
        FinServ__AccountAccountRelation__c accountAccountRelation = new FinServ__AccountAccountRelation__c();
        accountAccountRelation.Primary_Entity_Id__c = testAccount.id;
        accountAccountRelation.FinServ__RelatedAccount__c = testJointAccount.id;
        accountAccountRelation.Roles__c = 'Individual with Authority to Act';
        accountAccountRelation.FinServ__Role__c = resRole.Id;
        insert accountAccountRelation;
		//Merchant Onboarding Opportunity
		Opportunity testMerchantOnboardingOpportunity = new Opportunity();
		testMerchantOnboardingOpportunity.AccountId = testAccount.id;
		testMerchantOnboardingOpportunity.RecordTypeId = OpportunityRecordTypeMap.get('Merchant_Onboarding').getRecordTypeId();
		testMerchantOnboardingOpportunity.Adviser_AB_Number__c = 'TEST001';
		testMerchantOnboardingOpportunity.Name = 'EPP';
		testMerchantOnboardingOpportunity.Product__c = 'Estate Provider Plan';
		testMerchantOnboardingOpportunity.LeadSource = 'Siebel Campaign';
		testMerchantOnboardingOpportunity.Sub_Product__c = 'Estate Provider Plan';
		testMerchantOnboardingOpportunity.Type = 'Cross Sell';
		testMerchantOnboardingOpportunity.Originating_Adviser_AB_Number__c = 'EXTC150';
		testMerchantOnboardingOpportunity.External_Siebel_ID__c = '1-BSGP6F';
		testMerchantOnboardingOpportunity.StageName = 'Not Interested';
		testMerchantOnboardingOpportunity.CloseDate = Date.today()+10;
		testMerchantOnboardingOpportunity.Will_Number__c = '12345678923';
		testMerchantOnboardingOpportunity.Commission_1st_Year__c = 2000;
		testMerchantOnboardingOpportunity.Commission_2nd_Year__c = 590;
		testMerchantOnboardingOpportunity.Debit_Order_Debit_Day__c = '30';
		testMerchantOnboardingOpportunity.Debit_Order_Salary_Day__c = '10';
		testMerchantOnboardingOpportunity.DebitOrderThirdParty__c = true;
		testMerchantOnboardingOpportunity.Commencement_Date__c = Date.today();
		testMerchantOnboardingOpportunity.Debit_Order_Date__c = Date.today();
		testMerchantOnboardingOpportunity.Debit_Order_Account_Number__c = '1234567890';
		testMerchantOnboardingOpportunity.Selected_Email__c = 'test@test.com';
		testMerchantOnboardingOpportunity.Form_Status__c = 'Credit Approved';
		insert testMerchantOnboardingOpportunity;

		OpportunityLineItem testOppLineItemQuote = new OpportunityLineItem();
		testOppLineItemQuote.OpportunityId = testMerchantOnboardingOpportunity.Id;
		testOppLineItemQuote.Product2Id = product1.Id;
		testOppLineItemQuote.PricebookEntryId = pricebookEntry1.Id;
		testOppLineItemQuote.Quantity = 1;
		testOppLineItemQuote.TotalPrice = 100;
		testOppLineItemQuote.Signing_Purpose__c = 'AccountMaintenance';
		testOppLineItemQuote.Signing_Instructions__c = 'Anyone to sign alone';
		testOppLineItemQuote.Contact_Person__c = testAccountContactRelation.id;
		Insert testOppLineItemQuote;

		Application_Product_Merchant__c testAppProdMerchQuote = new Application_Product_Merchant__c();
		testAppProdMerchQuote.Opportunity_Product_Id__c = testOppLineItemQuote.Id;
		testAppProdMerchQuote.Selected_Cards__c = 'Cash Send;Electron (Visa Debit cards);Fleet;Garage Card and Petrol;Mastercard Debit;Mastercard Maestro;Mastercard Pre-paid;Pure Cash;Visa Debit Card;Visa pre-paid';
		Insert testAppProdMerchQuote;

		//Application__c
		Application__c testApplication = new Application__c();
		testApplication.Opportunity__c = testMerchantOnboardingOpportunity.Id;
		testApplication.Preferred_Communication_Method__c = 'himanshu.nimje@absa.africa';
		testApplication.Preferred_SMS__c = '065892600';
		testApplication.Preferred_Communication_Method__c = 'Email';
		testApplication.Fees_Waived__c = true;
		testApplication.Application_Status__c = 'Pending'; // Tinashe W-004373
		testApplication.Products_And_Services__c = 'NotifyMe';
		testApplication.Date_of_Completion__c = Date.today();
		testApplication.For_whom_are_you_generating_the_document__c = UserInfo.getUserId();
		testApplication.Medium__c = 'Email';
		insert testApplication;

		//Payment_Plan__c
		Payment_Plan__c testPaymentPlan = new Payment_Plan__c();
		testPaymentPlan.Application__c = testApplication.Id;
		testPaymentPlan.Account_Number__c = '1573017159';
		testPaymentPlan.Account_Type__c = 'Cheque';
		testPaymentPlan.Bank_Name__c = 'NEDBANK';
		testPaymentPlan.Branch_Code__c = Integer.valueOf('157342');
		testPaymentPlan.Branch_Name__c = 'PHUMULANI MALL TEMBIS (157342)';
		testPaymentPlan.Debit_Order_Commencement_Date__c = Date.valueOf('1970-01-01T00:00:00.000Z');
		testPaymentPlan.Debit_Order_Salary_Day__c = '1';
		testPaymentPlan.Debit_Order_Debit_Day__c = '01';
		testPaymentPlan.Name = 'Cheque - 1573017159';
		testPaymentPlan.Frequency__c = 'Monthly';
		testPaymentPlan.Amount__c = 100.00;
		testPaymentPlan.Reference__c = '12345';
		testPaymentPlan.Method__c = 'Debit Order';
		testPaymentPlan.Status__c = 'New';
		testPaymentPlan.Type__c = 'Will Safe Custody Fee';
		testPaymentPlan.Type_of_Details__c = 'Business Bank';
		insert testPaymentPlan;

		Date todaysDate = System.today();

		Contact con = new Contact(FirstName = 'Test', Lastname = 'Test');
		insert con;

		Account acc = new Account(Name = 'Test New Bus Client', Client_Type__C = 'Private Company');
		insert acc;

		List<Address__c> addrList = new List<Address__c>();
		addrList.add(new Address__c(Account__c = acc.Id, Address_Type__c = 'Physical Address', Client_Entity_Type__c = 'Individual', Shipping_Country__c = 'South Africa', Shipping_State_Province__c = 'Gauteng', Shipping_Street__c = 'Street 37', Shipping_Suburb__c = 'Maboneng', Shipping_Zip_Postal_Code__c = '1619', Shipping_City__c = 'City'));
		addrList.add(new Address__c(Account__c = acc.Id, Address_Type__c = 'Postal', Client_Entity_Type__c = 'Individual', Shipping_Country__c = 'South Africa', Shipping_State_Province__c = 'Gauteng', Shipping_Street__c = 'Street 37', Shipping_Suburb__c = 'Maboneng', Shipping_Zip_Postal_Code__c = '1619', Shipping_City__c = 'City'));
		addrList.add(new Address__c(Account__c = acc.Id, Address_Type__c = 'OperatingAddress', Client_Entity_Type__c = 'Individual', Shipping_Country__c = 'South Africa', Shipping_State_Province__c = 'Gauteng', Shipping_Street__c = 'Street 37', Shipping_Suburb__c = 'Maboneng', Shipping_Zip_Postal_Code__c = '1619', Shipping_City__c = 'City'));
		addrList.add(new Address__c(Account__c = acc.Id, Address_Type__c = 'Head Office', Client_Entity_Type__c = 'Company', Shipping_Country__c = 'South Africa', Shipping_State_Province__c = 'Gauteng', Shipping_Street__c = 'Street 37', Shipping_Suburb__c = 'Maboneng', Shipping_Zip_Postal_Code__c = '1619', Shipping_City__c = 'City'));
		addrList.add(new Address__c(Account__c = acc.Id, Address_Type__c = 'Business Address', Client_Entity_Type__c = 'Company', Shipping_Country__c = 'South Africa', Shipping_State_Province__c = 'Gauteng', Shipping_Street__c = 'Street 37', Shipping_Suburb__c = 'Maboneng', Shipping_Zip_Postal_Code__c = '1619', Shipping_City__c = 'City'));
		addrList.add(new Address__c(Account__c = acc.Id, Address_Type__c = 'Master of High Court', Client_Entity_Type__c = 'Individual', Shipping_Country__c = 'South Africa', Shipping_State_Province__c = 'Gauteng', Shipping_Street__c = 'Street 37', Shipping_Suburb__c = 'Maboneng', Shipping_Zip_Postal_Code__c = '1619', Shipping_City__c = 'City'));
		addrList.add(new Address__c(Account__c = acc.Id, Address_Type__c = 'Head Office', Client_Entity_Type__c = 'Individual', Shipping_Country__c = 'South Africa', Shipping_State_Province__c = 'Gauteng', Shipping_Street__c = 'Street 37', Shipping_Suburb__c = 'Maboneng', Shipping_Zip_Postal_Code__c = '1619', Shipping_City__c = 'City'));
		addrList.add(new Address__c(Account__c = acc.Id, Address_Type__c = 'Registered', Client_Entity_Type__c = 'Individual', Shipping_Country__c = 'South Africa', Shipping_State_Province__c = 'Gauteng', Shipping_Street__c = 'Street 37', Shipping_Suburb__c = 'Maboneng', Shipping_Zip_Postal_Code__c = '1619', Shipping_City__c = 'City'));
		addrList.add(new Address__c(Account__c = acc.Id, Address_Type__c = 'Employers', Client_Entity_Type__c = 'Individual', Shipping_Country__c = 'South Africa', Shipping_State_Province__c = 'Gauteng', Shipping_Street__c = 'Street 37', Shipping_Suburb__c = 'Maboneng', Shipping_Zip_Postal_Code__c = '1619', Shipping_City__c = 'City'));
		addrList.add(new Address__c(Account__c = acc.Id, Address_Type__c = 'Residential', Client_Entity_Type__c = 'Individual', Shipping_Country__c = 'South Africa', Shipping_State_Province__c = 'Gauteng', Shipping_Street__c = 'Street 37', Shipping_Suburb__c = 'Maboneng', Shipping_Zip_Postal_Code__c = '1619', Shipping_City__c = 'City'));
		insert addrList;

		User userRec = new UsersSelector().selectById(UserInfo.getUserId());
		List<Site__c> sitecodes;
		if (userRec.SiteCode__c != null){
			sitecodes = new SitesSelector().selectBySiteCode(userRec.SiteCode__c);
		} else{
			sitecodes = new List<Site__c>();
		}

		//Get Standard Pricebook Id
		PriceBook2 priceBookItem = new Pricebook2(Name = 'Standard Price Book 2009', Description = 'Price Book 2009 Products', IsActive = true);
		insert priceBookItem;

		Opportunity cpfOpp = new Opportunity();
		cpfOpp.Name = 'CPF Onboarding';
		cpfOpp.RecordTypeId = opportunityRecordTypeMap.get('CPF_Onboarding').getRecordTypeId();
		cpfOpp.AccountId = acc.id;
		cpfOpp.StageName = 'Confirm Client Eligibility';
		cpfOpp.closeDate = todaysDate.addDays(7);
		cpfOpp.priceBook2Id = priceBookItem.id;

		//Capturing Sitecode of loggedin User while creating opportunity if user has site code
		if (!sitecodes.isEmpty()){
			cpfOpp.Site__c = sitecodes[0].Id;
		}

		// Added by Masechaba Maseli W-005224 get the ABSA region
		If (userRec.SiteCode__c != Null){
			Map<String, ABSASiteRegionMap__c> regionMapping = ABSASiteRegionMap__c.getAll();
			cpfOpp.ABSA_Region__c = regionMapping.get(userRec.SiteCode__c) != null ? regionMapping.get(userRec.SiteCode__c).ABSA_Region__c : Null;
		}
		cpfOpp.Form_Status__c = 'Credit Approved';
		insert cpfOpp;

		Application__c cpfApp = new Application__c();
		cpfApp.Opportunity__c = cpfOpp.Id;
		cpfApp.Preferred_Communication_Method__c = 'himanshu.nimje@absa.africa';
		cpfApp.Preferred_SMS__c = '065892600';
		cpfApp.Preferred_Communication_Method__c = 'Email';
		cpfApp.Fees_Waived__c = true;
		cpfApp.Application_Status__c = 'Pending'; // Tinashe W-004373
		cpfApp.Products_And_Services__c = 'NotifyMe';
		insert cpfApp;

		Application_Product__c appPrdct = new Application_Product__c();
		appPrdct.Application__c = cpfApp.Id;
		appPrdct.Opportunity__c = cpfOpp.Id;
		appPrdct.Agreement_Category__c = 'M';
		appPrdct.Opportunity_Product_Id__c = '001';
		appPrdct.Product_Facility_Json__c = '{"Unutilisedfacilityfee":0,"totalamount":1000,"targetamount":1200,"Surname":"NA","specialConditionsSelected":"Subordination Agreement in terms of which all claims by your shareholder(s)/director(s) [INSERT NAME OF SHAREHOLDER OR DIRECTOR(S)] are subordinated in favour of any claims by us.,Negative Pledge: You shall not create or agree to create or permit to subsist (other than in our favour) any Security over assets that have been secured to us.","siteCode":"6953","ReviewType":null,"Reviewfees":1290,"ReviewDate":"2021-03-23","RegularpaymentDate":null,"RegistrationNumber":"1998/016806/23","quoteDate":"2021-03-15","productName":"Cheque","Primeinterestrate":6.00,"penaltyinterest":null,"otherConditions":"Other Conditions","ODLimitType":"Reducing - Once Off Only","Monthlyadministrationfee":69.00,"isGeneralFacilitySelected":"Yes","InterestrateType":"Variable","Interestrate":12.00,"interestMargin":2.15,"instructionId":null,"Initiationfees":0.00,"fullname":"CPS SEEDLINGS CC","facilityTypeSelected":"Overdraft Facility, Local Guarantees Facility, Foreign Guarantees Facility, Revolving Loan Facility, Overnight Facility, Letters of Credit Facility (sight or usance), Business Credit Card Facility, Offshore Loans, Fleet Card Facility, Daylight Limit, ACB Facility, Forward Exchange Contracts Facility, Customer Foreign Currency Account","facilityreduced":"Monthly","facilityAmount":100000.00,"facilitiesSelected":"This Agreement signed by both parties., A copy of your board resolution and constitutional documents., A signed copy of the electronic communication indemnity., In a form acceptable to us, the Security., Certified copies of any resolutions required in terms of applicable laws to make the Security effective., Any information or documentation as required by us, including any Financial Intelligence Centre Act, 2001 (FICA) information.","decreasemap":[{"DecreaseDate1":"2021-06-30","DecreaseAmount1":10000.00}],"creditLimitAvail":100000.00,"creditApplicationReference":"None","classificationSelected":"None","AnnualInterestRate":13,"Addresseetitle":"Dear Sir(s) / Madam(s)","AddresseeOther":"Drs","Addressee":"The Partner(s)","accountNumber":"4048457031"}';
		appPrdct.Product_Quote_Json__c = '{"QuoteNumber":"123456", "Initiationfees":1234, "IntetrestAggre": 10, "ServicefeeAggre": 12, "CreditInsurAggre": 120 ,"creditcostmultiple": 32, "creditInsurMonth": 251.23, "ODLedgerFee": 1200, "ExODLedgerFee": 500, "AnnualInterestRate": 12.5 , "AnnualInterestRateDiscount": 2.12,"discountedIntersetRate": 5.43, "UpfrontInitiationfees": 900, "monthlyinstalment": 457.90, "totalinterest": 27.5, "totalinterestandfees": 1221, "totaltoberepaid": 12000, "additionalCharges": "123", "creditinsurancemonthly":124.3, "Commision": "120", "creditLimit": 20000, "creditLimitAvail": 20000}';
		insert appPrdct;

		Application_Product_CPF__c appPrdctcpf = new Application_Product_CPF__c();
		appPrdctcpf.Application__c = cpfApp.Id;
		appPrdctcpf.Name = 'Test CPF Docs';
		appPrdctcpf.Parent_to_provide_the_bank_with_financia__c = 'Yes';
		appPrdctcpf.Guarantor_s_has_have_subsidiaries__c = 'yes';
		appPrdctcpf.Guarantor_s_to_provide_the_bank_with_fi__c = 'yes';
		appPrdctcpf.Borrower_has_subsidiaries__c = 'yes';
		appPrdctcpf.Available__c = 1;
		appPrdctcpf.Period__c = 'monthly';
		appPrdctcpf.Financial_statements_available_no_later__c = 'test';
		appPrdctcpf.Include_balance_sheet_profit_loss_acc__c = 'yes';
		appPrdctcpf.Other_financial_information__c = 'test';
		appPrdctCpf.Facility_purpose__c = 'PURPOSE AS APPROVED BY CREDIT';
		appPrdctCpf.Late_bond_registration_penalty__c = 'Yes';
		appPrdctCpf.Include_guarantor_s__c = 'Yes';
		appPrdctCpf.Including_financial_statements_of_guaran__c = 'Yes';
		appPrdctCpf.Measurement_period__c = 'each consecutive period';
		appPrdctCpf.Loan_To_Value_Covenant__c = 'Ratcheting';
		appPrdctCpf.Debt_service_cover_ratio__c = 'Ratcheting';
		appPrdctCpf.Final_repayment_date__c = 'Date';
		appPrdctCpf.Notarially_Tied_Consolidation__c = 'Notarially Tied';
		appPrdctCpf.Secondary_Account_Applicable__c = 'YES';
		insert appPrdctcpf;

		List<Document_Template__c> docTempList = new List<Document_Template__c>();
		Document_Template__c test6171DocumentTemplate = new Document_Template__c();
		test6171DocumentTemplate.Name = 'ABSA 6171 EX - Commercial Property Finance Loan';
		test6171DocumentTemplate.XML__c = '<Schema>  <ABSA3121_SiteVerificationDetails>    <SiteVerificationDetails></SiteVerificationDetails>    <Id>4074</Id>  </ABSA3121_SiteVerificationDetails>  {{#AccountList}}  <ABSA3121_AccountNumbers>    <AccountNumber>{{AccountNumber}}</AccountNumber>    <ParentId>3039</ParentId>    <Id>781</Id>  </ABSA3121_AccountNumbers> {{/AccountList}}  <AISxMetaData>    <IsCPA>0</IsCPA>    <IsNCA>false</IsNCA>    <Language>E</Language>    <IsDigitalSignature>false</IsDigitalSignature>  </AISxMetaData>  <ABSA3121>    <FormalInformalSettlement>{{Application.Settlement_type__c}}</FormalInformalSettlement>    <SiteVisitDate>{{Application.Site_visit_date__c | format_date}}</SiteVisitDate>    <SiteVisitCPFullName>{{Application.First_Name__c}}{{Application.Surname__c}}</SiteVisitCPFullName>    <CSARefNo>{{Application.Application_Number__c}}</CSARefNo>    <AccountNumber>{{Account.AccountNumber}}</AccountNumber>    <ClientCIF>{{Account.CIF__c}}</ClientCIF>    <InitiatorAbNo>{{User.AB_Number__c}}</InitiatorAbNo>    <SurnameOrEntityName>{{Account.Trading_Name__c}}{{Account.LastName}}</SurnameOrEntityName>    <TradingSurnameOrEntityName>{{Account.Trading_Name__c}}{{Account.LastName}}</TradingSurnameOrEntityName>    <InitiatorName>{{User.Name}}</InitiatorName>    <InitiatorSurname>{{User.LastName}}</InitiatorSurname>   <IdNo>{{Account.ID_Number__c}}</IdNo>    <IdType>{{Account.ID_Type__c}}</IdType>    <Id>1642</Id>    <PhysicalAddressCity>{{TradingAddress.Shipping_City__c}}</PhysicalAddressCity>    <PhysicalAddressCode>{{TradingAddress.Shipping_Zip_Postal_Code__c}}</PhysicalAddressCode>    <PhysicalAddressSuburb>{{TradingAddress.Shipping_Suburb__c}}</PhysicalAddressSuburb>    <PhysicalAddressLine2>{{TradingAddress.Shipping_State_Province__c}}</PhysicalAddressLine2>    <PhysicalAddressLine1>{{TradingAddress.Shipping_Street__c}}</PhysicalAddressLine1>    <SiteVerificationDetails></SiteVerificationDetails>    <!-- where do we capture than an address was verified-->    <VerifiedAddressInfo></VerifiedAddressInfo>    <PhysicalAddressCountry>{{TradingAddress.Shipping_Country__c}}</PhysicalAddressCountry>    <PhysicalAddressType>{{TradingAddress.Address_Type__c}}</PhysicalAddressType>    <InitiatorTitle>{{User.Title}}</InitiatorTitle>    <Title></Title>    <FullName>{{Account.Name}}</FullName>    <SiteVisitCPTitle>{{Application.Title__c}}</SiteVisitCPTitle>    <SiteVisitCPSurnameOrEntityName>{{Account.Trading_Name__c}}{{Account.LastName}}</SiteVisitCPSurnameOrEntityName>    <TradingFullName>{{Application.First_Name__c}}{{Application.Surname__c}}</TradingFullName>    <TradingTitle></TradingTitle>  </ABSA3121>  <LSOIAddress>  <!-- Not sure what row we talking of here-->    <Row></Row>  </LSOIAddress></Schema>';
		test6171DocumentTemplate.Document_Type__c = 'ABSA 6171 EX - Commercial Property Finance Loan';
		test6171DocumentTemplate.Signature_Required__c = True;
		test6171DocumentTemplate.ECM_Account_Number_Metadata__c = true;
		test6171DocumentTemplate.ECM_Business_Unit_Metadata__c = true;
		test6171DocumentTemplate.ECM_CIF_Code_Metadata__c = true;
		test6171DocumentTemplate.ECM_Filing_Date_Metadata__c = true;
		test6171DocumentTemplate.ECM_ID_Number_Metadata__c = true;
		test6171DocumentTemplate.ECM_Item_Type__c = 'Ent_AccountApplication';
		test6171DocumentTemplate.ECM_Origin_Metadata__c = true;
		test6171DocumentTemplate.Template_Id__c = '244';
		test6171DocumentTemplate.Parent_Document_Type__c = 'Business Client Agreement';
		docTempList.add(test6171DocumentTemplate);

		Document_Template__c test6173DocumentTemplate = new Document_Template__c();
		test6173DocumentTemplate.Name = 'ABSA 6173 Suretyship/Credit Guarantee';
		test6173DocumentTemplate.XML__c = '<Schema>  <ABSA3121_SiteVerificationDetails>    <SiteVerificationDetails></SiteVerificationDetails>    <Id>4074</Id>  </ABSA3121_SiteVerificationDetails>  {{#AccountList}}  <ABSA3121_AccountNumbers>    <AccountNumber>{{AccountNumber}}</AccountNumber>    <ParentId>3039</ParentId>    <Id>781</Id>  </ABSA3121_AccountNumbers> {{/AccountList}}  <AISxMetaData>    <IsCPA>0</IsCPA>    <IsNCA>false</IsNCA>    <Language>E</Language>    <IsDigitalSignature>false</IsDigitalSignature>  </AISxMetaData>  <ABSA3121>    <FormalInformalSettlement>{{Application.Settlement_type__c}}</FormalInformalSettlement>    <SiteVisitDate>{{Application.Site_visit_date__c | format_date}}</SiteVisitDate>    <SiteVisitCPFullName>{{Application.First_Name__c}}{{Application.Surname__c}}</SiteVisitCPFullName>    <CSARefNo>{{Application.Application_Number__c}}</CSARefNo>    <AccountNumber>{{Account.AccountNumber}}</AccountNumber>    <ClientCIF>{{Account.CIF__c}}</ClientCIF>    <InitiatorAbNo>{{User.AB_Number__c}}</InitiatorAbNo>    <SurnameOrEntityName>{{Account.Trading_Name__c}}{{Account.LastName}}</SurnameOrEntityName>    <TradingSurnameOrEntityName>{{Account.Trading_Name__c}}{{Account.LastName}}</TradingSurnameOrEntityName>    <InitiatorName>{{User.Name}}</InitiatorName>    <InitiatorSurname>{{User.LastName}}</InitiatorSurname>   <IdNo>{{Account.ID_Number__c}}</IdNo>    <IdType>{{Account.ID_Type__c}}</IdType>    <Id>1642</Id>    <PhysicalAddressCity>{{TradingAddress.Shipping_City__c}}</PhysicalAddressCity>    <PhysicalAddressCode>{{TradingAddress.Shipping_Zip_Postal_Code__c}}</PhysicalAddressCode>    <PhysicalAddressSuburb>{{TradingAddress.Shipping_Suburb__c}}</PhysicalAddressSuburb>    <PhysicalAddressLine2>{{TradingAddress.Shipping_State_Province__c}}</PhysicalAddressLine2>    <PhysicalAddressLine1>{{TradingAddress.Shipping_Street__c}}</PhysicalAddressLine1>    <SiteVerificationDetails></SiteVerificationDetails>    <!-- where do we capture than an address was verified-->    <VerifiedAddressInfo></VerifiedAddressInfo>    <PhysicalAddressCountry>{{TradingAddress.Shipping_Country__c}}</PhysicalAddressCountry>    <PhysicalAddressType>{{TradingAddress.Address_Type__c}}</PhysicalAddressType>    <InitiatorTitle>{{User.Title}}</InitiatorTitle>    <Title></Title>    <FullName>{{Account.Name}}</FullName>    <SiteVisitCPTitle>{{Application.Title__c}}</SiteVisitCPTitle>    <SiteVisitCPSurnameOrEntityName>{{Account.Trading_Name__c}}{{Account.LastName}}</SiteVisitCPSurnameOrEntityName>    <TradingFullName>{{Application.First_Name__c}}{{Application.Surname__c}}</TradingFullName>    <TradingTitle></TradingTitle>  </ABSA3121>  <LSOIAddress>  <!-- Not sure what row we talking of here-->    <Row></Row>  </LSOIAddress></Schema>';
		test6173DocumentTemplate.Document_Type__c = 'ABSA 6173 Suretyship/Credit Guarantee';
		test6173DocumentTemplate.Signature_Required__c = True;
		test6173DocumentTemplate.ECM_Account_Number_Metadata__c = true;
		test6173DocumentTemplate.ECM_Business_Unit_Metadata__c = true;
		test6173DocumentTemplate.ECM_CIF_Code_Metadata__c = true;
		test6173DocumentTemplate.ECM_Filing_Date_Metadata__c = true;
		test6173DocumentTemplate.ECM_ID_Number_Metadata__c = true;
		test6173DocumentTemplate.ECM_Item_Type__c = 'Ent_Suretyship';
		test6173DocumentTemplate.ECM_Origin_Metadata__c = true;
		test6173DocumentTemplate.Template_Id__c = '200';
		test6173DocumentTemplate.Parent_Document_Type__c = 'Business Client Agreement';
		docTempList.add(test6173DocumentTemplate);

		Document_Template__c absa6157 = new Document_Template__c();
		absa6157.Name = 'ABSA 6157 EX - OD Facility Letter';
		absa6157.XML__c = '<Schema>  <ABSA3121_SiteVerificationDetails>    <SiteVerificationDetails></SiteVerificationDetails>    <Id>4074</Id>  </ABSA3121_SiteVerificationDetails>  {{#AccountList}}  <ABSA3121_AccountNumbers>    <AccountNumber>{{AccountNumber}}</AccountNumber>    <ParentId>3039</ParentId>    <Id>781</Id>  </ABSA3121_AccountNumbers> {{/AccountList}}  <AISxMetaData>    <IsCPA>0</IsCPA>    <IsNCA>false</IsNCA>    <Language>E</Language>    <IsDigitalSignature>false</IsDigitalSignature>  </AISxMetaData>  <ABSA3121>    <FormalInformalSettlement>{{Application.Settlement_type__c}}</FormalInformalSettlement>    <SiteVisitDate>{{Application.Site_visit_date__c | format_date}}</SiteVisitDate>    <SiteVisitCPFullName>{{Application.First_Name__c}}{{Application.Surname__c}}</SiteVisitCPFullName>    <CSARefNo>{{Application.Application_Number__c}}</CSARefNo>    <AccountNumber>{{Account.AccountNumber}}</AccountNumber>    <ClientCIF>{{Account.CIF__c}}</ClientCIF>    <InitiatorAbNo>{{User.AB_Number__c}}</InitiatorAbNo>    <SurnameOrEntityName>{{Account.Trading_Name__c}}{{Account.LastName}}</SurnameOrEntityName>    <TradingSurnameOrEntityName>{{Account.Trading_Name__c}}{{Account.LastName}}</TradingSurnameOrEntityName>    <InitiatorName>{{User.Name}}</InitiatorName>    <InitiatorSurname>{{User.LastName}}</InitiatorSurname>   <IdNo>{{Account.ID_Number__c}}</IdNo>    <IdType>{{Account.ID_Type__c}}</IdType>    <Id>1642</Id>    <PhysicalAddressCity>{{TradingAddress.Shipping_City__c}}</PhysicalAddressCity>    <PhysicalAddressCode>{{TradingAddress.Shipping_Zip_Postal_Code__c}}</PhysicalAddressCode>    <PhysicalAddressSuburb>{{TradingAddress.Shipping_Suburb__c}}</PhysicalAddressSuburb>    <PhysicalAddressLine2>{{TradingAddress.Shipping_State_Province__c}}</PhysicalAddressLine2>    <PhysicalAddressLine1>{{TradingAddress.Shipping_Street__c}}</PhysicalAddressLine1>    <SiteVerificationDetails></SiteVerificationDetails>    <!-- where do we capture than an address was verified-->    <VerifiedAddressInfo></VerifiedAddressInfo>    <PhysicalAddressCountry>{{TradingAddress.Shipping_Country__c}}</PhysicalAddressCountry>    <PhysicalAddressType>{{TradingAddress.Address_Type__c}}</PhysicalAddressType>    <InitiatorTitle>{{User.Title}}</InitiatorTitle>    <Title></Title>    <FullName>{{Account.Name}}</FullName>    <SiteVisitCPTitle>{{Application.Title__c}}</SiteVisitCPTitle>    <SiteVisitCPSurnameOrEntityName>{{Account.Trading_Name__c}}{{Account.LastName}}</SiteVisitCPSurnameOrEntityName>    <TradingFullName>{{Application.First_Name__c}}{{Application.Surname__c}}</TradingFullName>    <TradingTitle></TradingTitle>  </ABSA3121>  <LSOIAddress>  <!-- Not sure what row we talking of here-->    <Row></Row>  </LSOIAddress></Schema>';
		absa6157.Document_Type__c = 'ABSA 6157 EX - OD Facility Letter';
		absa6157.Signature_Required__c = True;
		absa6157.ECM_Account_Number_Metadata__c = true;
		absa6157.ECM_Business_Unit_Metadata__c = true;
		absa6157.ECM_CIF_Code_Metadata__c = true;
		absa6157.ECM_Filing_Date_Metadata__c = true;
		absa6157.ECM_ID_Number_Metadata__c = true;
		absa6157.ECM_Item_Type__c = 'Ent_Agreement';
		absa6157.ECM_Origin_Metadata__c = true;
		absa6157.Parent_Document_Type__c = 'Agreements';
		absa6157.Template_Id__c = '105';
		docTempList.add(absa6157);

		Document_Template__c absa5701 = new Document_Template__c();
		absa5701.Name = 'ABSA 5701 - Overdraft Quotation and Agreement (Intermediate and Large)';
		absa5701.XML__c = '<Schema>  <ABSA3121_SiteVerificationDetails>    <SiteVerificationDetails></SiteVerificationDetails>    <Id>4074</Id>  </ABSA3121_SiteVerificationDetails>  {{#AccountList}}  <ABSA3121_AccountNumbers>    <AccountNumber>{{AccountNumber}}</AccountNumber>    <ParentId>3039</ParentId>    <Id>781</Id>  </ABSA3121_AccountNumbers> {{/AccountList}}  <AISxMetaData>    <IsCPA>0</IsCPA>    <IsNCA>false</IsNCA>    <Language>E</Language>    <IsDigitalSignature>false</IsDigitalSignature>  </AISxMetaData>  <ABSA3121>    <FormalInformalSettlement>{{Application.Settlement_type__c}}</FormalInformalSettlement>    <SiteVisitDate>{{Application.Site_visit_date__c | format_date}}</SiteVisitDate>    <SiteVisitCPFullName>{{Application.First_Name__c}}{{Application.Surname__c}}</SiteVisitCPFullName>    <CSARefNo>{{Application.Application_Number__c}}</CSARefNo>    <AccountNumber>{{Account.AccountNumber}}</AccountNumber>    <ClientCIF>{{Account.CIF__c}}</ClientCIF>    <InitiatorAbNo>{{User.AB_Number__c}}</InitiatorAbNo>    <SurnameOrEntityName>{{Account.Trading_Name__c}}{{Account.LastName}}</SurnameOrEntityName>    <TradingSurnameOrEntityName>{{Account.Trading_Name__c}}{{Account.LastName}}</TradingSurnameOrEntityName>    <InitiatorName>{{User.Name}}</InitiatorName>    <InitiatorSurname>{{User.LastName}}</InitiatorSurname>   <IdNo>{{Account.ID_Number__c}}</IdNo>    <IdType>{{Account.ID_Type__c}}</IdType>    <Id>1642</Id>    <PhysicalAddressCity>{{TradingAddress.Shipping_City__c}}</PhysicalAddressCity>    <PhysicalAddressCode>{{TradingAddress.Shipping_Zip_Postal_Code__c}}</PhysicalAddressCode>    <PhysicalAddressSuburb>{{TradingAddress.Shipping_Suburb__c}}</PhysicalAddressSuburb>    <PhysicalAddressLine2>{{TradingAddress.Shipping_State_Province__c}}</PhysicalAddressLine2>    <PhysicalAddressLine1>{{TradingAddress.Shipping_Street__c}}</PhysicalAddressLine1>    <SiteVerificationDetails></SiteVerificationDetails>    <!-- where do we capture than an address was verified-->    <VerifiedAddressInfo></VerifiedAddressInfo>    <PhysicalAddressCountry>{{TradingAddress.Shipping_Country__c}}</PhysicalAddressCountry>    <PhysicalAddressType>{{TradingAddress.Address_Type__c}}</PhysicalAddressType>    <InitiatorTitle>{{User.Title}}</InitiatorTitle>    <Title></Title>    <FullName>{{Account.Name}}</FullName>    <SiteVisitCPTitle>{{Application.Title__c}}</SiteVisitCPTitle>    <SiteVisitCPSurnameOrEntityName>{{Account.Trading_Name__c}}{{Account.LastName}}</SiteVisitCPSurnameOrEntityName>    <TradingFullName>{{Application.First_Name__c}}{{Application.Surname__c}}</TradingFullName>    <TradingTitle></TradingTitle>  </ABSA3121>  <LSOIAddress>  <!-- Not sure what row we talking of here-->    <Row></Row>  </LSOIAddress></Schema>';
		absa5701.Document_Type__c = 'ABSA 5701 - Overdraft Quotation and Agreement (Intermediate and Large)';
		absa5701.Signature_Required__c = True;
		absa5701.ECM_Account_Number_Metadata__c = true;
		absa5701.ECM_Business_Unit_Metadata__c = true;
		absa5701.ECM_CIF_Code_Metadata__c = true;
		absa5701.ECM_Filing_Date_Metadata__c = true;
		absa5701.ECM_ID_Number_Metadata__c = true;
		absa5701.ECM_Item_Type__c = 'Ent_Agreement';
		absa5701.ECM_Origin_Metadata__c = true;
		absa5701.Parent_Document_Type__c = 'Agreements';
		absa5701.Template_Id__c = '98';
		docTempList.add(absa5701);

		Document_Template__c absa5702 = new Document_Template__c();
		absa5702.Name = 'ABSA 5702 - Overdraft Quotation and Agreement (Small)';
		absa5702.XML__c = '<Schema>  <ABSA3121_SiteVerificationDetails>    <SiteVerificationDetails></SiteVerificationDetails>    <Id>4074</Id>  </ABSA3121_SiteVerificationDetails>  {{#AccountList}}  <ABSA3121_AccountNumbers>    <AccountNumber>{{AccountNumber}}</AccountNumber>    <ParentId>3039</ParentId>    <Id>781</Id>  </ABSA3121_AccountNumbers> {{/AccountList}}  <AISxMetaData>    <IsCPA>0</IsCPA>    <IsNCA>false</IsNCA>    <Language>E</Language>    <IsDigitalSignature>false</IsDigitalSignature>  </AISxMetaData>  <ABSA3121>    <FormalInformalSettlement>{{Application.Settlement_type__c}}</FormalInformalSettlement>    <SiteVisitDate>{{Application.Site_visit_date__c | format_date}}</SiteVisitDate>    <SiteVisitCPFullName>{{Application.First_Name__c}}{{Application.Surname__c}}</SiteVisitCPFullName>    <CSARefNo>{{Application.Application_Number__c}}</CSARefNo>    <AccountNumber>{{Account.AccountNumber}}</AccountNumber>    <ClientCIF>{{Account.CIF__c}}</ClientCIF>    <InitiatorAbNo>{{User.AB_Number__c}}</InitiatorAbNo>    <SurnameOrEntityName>{{Account.Trading_Name__c}}{{Account.LastName}}</SurnameOrEntityName>    <TradingSurnameOrEntityName>{{Account.Trading_Name__c}}{{Account.LastName}}</TradingSurnameOrEntityName>    <InitiatorName>{{User.Name}}</InitiatorName>    <InitiatorSurname>{{User.LastName}}</InitiatorSurname>   <IdNo>{{Account.ID_Number__c}}</IdNo>    <IdType>{{Account.ID_Type__c}}</IdType>    <Id>1642</Id>    <PhysicalAddressCity>{{TradingAddress.Shipping_City__c}}</PhysicalAddressCity>    <PhysicalAddressCode>{{TradingAddress.Shipping_Zip_Postal_Code__c}}</PhysicalAddressCode>    <PhysicalAddressSuburb>{{TradingAddress.Shipping_Suburb__c}}</PhysicalAddressSuburb>    <PhysicalAddressLine2>{{TradingAddress.Shipping_State_Province__c}}</PhysicalAddressLine2>    <PhysicalAddressLine1>{{TradingAddress.Shipping_Street__c}}</PhysicalAddressLine1>    <SiteVerificationDetails></SiteVerificationDetails>    <!-- where do we capture than an address was verified-->    <VerifiedAddressInfo></VerifiedAddressInfo>    <PhysicalAddressCountry>{{TradingAddress.Shipping_Country__c}}</PhysicalAddressCountry>    <PhysicalAddressType>{{TradingAddress.Address_Type__c}}</PhysicalAddressType>    <InitiatorTitle>{{User.Title}}</InitiatorTitle>    <Title></Title>    <FullName>{{Account.Name}}</FullName>    <SiteVisitCPTitle>{{Application.Title__c}}</SiteVisitCPTitle>    <SiteVisitCPSurnameOrEntityName>{{Account.Trading_Name__c}}{{Account.LastName}}</SiteVisitCPSurnameOrEntityName>    <TradingFullName>{{Application.First_Name__c}}{{Application.Surname__c}}</TradingFullName>    <TradingTitle></TradingTitle>  </ABSA3121>  <LSOIAddress>  <!-- Not sure what row we talking of here-->    <Row></Row>  </LSOIAddress></Schema>';
		absa5702.Document_Type__c = 'ABSA 5702 - Overdraft Quotation and Agreement (Small)';
		absa5702.Signature_Required__c = True;
		absa5702.ECM_Account_Number_Metadata__c = true;
		absa5702.ECM_Business_Unit_Metadata__c = true;
		absa5702.ECM_CIF_Code_Metadata__c = true;
		absa5702.ECM_Filing_Date_Metadata__c = true;
		absa5702.ECM_ID_Number_Metadata__c = true;
		absa5702.ECM_Item_Type__c = 'Ent_Agreement';
		absa5702.ECM_Origin_Metadata__c = true;
		absa5702.Parent_Document_Type__c = 'Agreements';
		absa5702.Template_Id__c = '318';

		//Document_Template__c
		Document_Template__c testDocumentTemplate = new Document_Template__c();
		testDocumentTemplate.Name = 'ABSA 3741 - Client Engagement';
		testDocumentTemplate.Client_Type__c = 'Individual Client';
		testDocumentTemplate.Parent_Document_Type__c = 'Business Client Agreement';
		testDocumentTemplate.XML__c = '<Schema><ABSA3741><AdviserEmployeeNumber>0939943</AdviserEmployeeNumber><AdviserName>SIFISO</AdviserName><AdviserSignDate>2020-03-10T00:00:00</AdviserSignDate><BusinesssStartDate>2010-03-10T00:00:00</BusinesssStartDate></ABSA3741></Schema>';
		docTempList.add(testDocumentTemplate);

		testDocumentTemplate = new Document_Template__c();
		testDocumentTemplate.Name = 'ABSA 3141 - Global Application to open/close savings/investment';
		testDocumentTemplate.Client_Type__c = 'PRIVATE COMPANY';
		testDocumentTemplate.Parent_Document_Type__c = 'Business Client Agreement';
		testDocumentTemplate.XML__c = '<Schema><ABSA3741><AdviserEmployeeNumber>0939943</AdviserEmployeeNumber><AdviserName>SIFISO</AdviserName><AdviserSignDate>2020-03-10T00:00:00</AdviserSignDate><BusinesssStartDate>2010-03-10T00:00:00</BusinesssStartDate></ABSA3741></Schema>';
		docTempList.add(testDocumentTemplate);

		testDocumentTemplate = new Document_Template__c();
		testDocumentTemplate.Name = System.Label.Merchant_Quote_Document_Template_Name;
		testDocumentTemplate.XML__c = 'XML';
		testDocumentTemplate.Document_Type__c = System.Label.Merchant_Quote_Document_Template_Name;
		testDocumentTemplate.Signature_Required__c = True;
		testDocumentTemplate.ECM_Account_Number_Metadata__c = true;
		testDocumentTemplate.ECM_Business_Unit_Metadata__c = true;
		testDocumentTemplate.ECM_CIF_Code_Metadata__c = true;
		testDocumentTemplate.ECM_Filing_Date_Metadata__c = true;
		testDocumentTemplate.ECM_ID_Number_Metadata__c = true;
		testDocumentTemplate.ECM_Item_Type__c = 'Ent_Quotation';
		testDocumentTemplate.ECM_Origin_Metadata__c = true;
		testDocumentTemplate.Opportunity_Record_Types__c = 'Merchant Onboarding';
		testDocumentTemplate.Parent_Document_Type__c = 'Business Client Agreement';
		docTempList.add(testDocumentTemplate);

		Document_Template__c test3121DocumentTemplate = new Document_Template__c();
		test3121DocumentTemplate.Name = 'ABSA 3121 - Physical Site visit conducted for Verification Purposes Confirmation';
		test3121DocumentTemplate.XML__c = '<Schema>  <ABSA3121_SiteVerificationDetails>    <SiteVerificationDetails></SiteVerificationDetails>    <Id>4074</Id>  </ABSA3121_SiteVerificationDetails>  {{#AccountList}}  <ABSA3121_AccountNumbers>    <AccountNumber>{{AccountNumber}}</AccountNumber>    <ParentId>3039</ParentId>    <Id>781</Id>  </ABSA3121_AccountNumbers> {{/AccountList}}  <AISxMetaData>    <IsCPA>0</IsCPA>    <IsNCA>false</IsNCA>    <Language>E</Language>    <IsDigitalSignature>false</IsDigitalSignature>  </AISxMetaData>  <ABSA3121>    <FormalInformalSettlement>{{Application.Settlement_type__c}}</FormalInformalSettlement>    <SiteVisitDate>{{Application.Site_visit_date__c | format_date}}</SiteVisitDate>    <SiteVisitCPFullName>{{Application.First_Name__c}}{{Application.Surname__c}}</SiteVisitCPFullName>    <CSARefNo>{{Application.Application_Number__c}}</CSARefNo>    <AccountNumber>{{Account.AccountNumber}}</AccountNumber>    <ClientCIF>{{Account.CIF__c}}</ClientCIF>    <InitiatorAbNo>{{User.AB_Number__c}}</InitiatorAbNo>    <SurnameOrEntityName>{{Account.Trading_Name__c}}{{Account.LastName}}</SurnameOrEntityName>    <TradingSurnameOrEntityName>{{Account.Trading_Name__c}}{{Account.LastName}}</TradingSurnameOrEntityName>    <InitiatorName>{{User.Name}}</InitiatorName>    <InitiatorSurname>{{User.LastName}}</InitiatorSurname>   <IdNo>{{Account.ID_Number__c}}</IdNo>    <IdType>{{Account.ID_Type__c}}</IdType>    <Id>1642</Id>    <PhysicalAddressCity>{{TradingAddress.Shipping_City__c}}</PhysicalAddressCity>    <PhysicalAddressCode>{{TradingAddress.Shipping_Zip_Postal_Code__c}}</PhysicalAddressCode>    <PhysicalAddressSuburb>{{TradingAddress.Shipping_Suburb__c}}</PhysicalAddressSuburb>    <PhysicalAddressLine2>{{TradingAddress.Shipping_State_Province__c}}</PhysicalAddressLine2>    <PhysicalAddressLine1>{{TradingAddress.Shipping_Street__c}}</PhysicalAddressLine1>    <SiteVerificationDetails></SiteVerificationDetails>    <!-- where do we capture than an address was verified-->    <VerifiedAddressInfo></VerifiedAddressInfo>    <PhysicalAddressCountry>{{TradingAddress.Shipping_Country__c}}</PhysicalAddressCountry>    <PhysicalAddressType>{{TradingAddress.Address_Type__c}}</PhysicalAddressType>    <InitiatorTitle>{{User.Title}}</InitiatorTitle>    <Title></Title>    <FullName>{{Account.Name}}</FullName>    <SiteVisitCPTitle>{{Application.Title__c}}</SiteVisitCPTitle>    <SiteVisitCPSurnameOrEntityName>{{Account.Trading_Name__c}}{{Account.LastName}}</SiteVisitCPSurnameOrEntityName>    <TradingFullName>{{Application.First_Name__c}}{{Application.Surname__c}}</TradingFullName>    <TradingTitle></TradingTitle>  </ABSA3121>  <LSOIAddress>  <!-- Not sure what row we talking of here-->    <Row></Row>  </LSOIAddress></Schema>';
		test3121DocumentTemplate.Document_Type__c = 'ABSA 3121 - Physical Site visit conducted for Verification Purposes Confirmation';
		test3121DocumentTemplate.Signature_Required__c = True;
		test3121DocumentTemplate.ECM_Account_Number_Metadata__c = true;
		test3121DocumentTemplate.ECM_Business_Unit_Metadata__c = true;
		test3121DocumentTemplate.ECM_CIF_Code_Metadata__c = true;
		test3121DocumentTemplate.ECM_Filing_Date_Metadata__c = true;
		test3121DocumentTemplate.ECM_ID_Number_Metadata__c = true;
		test3121DocumentTemplate.ECM_Item_Type__c = 'Ent_ProofOfAddress';
		test3121DocumentTemplate.ECM_Origin_Metadata__c = true;
		test3121DocumentTemplate.Opportunity_Record_Types__c = 'Merchant Onboarding';
		test3121DocumentTemplate.Parent_Document_Type__c = 'Business Client Agreement';
		docTempList.add(test3121DocumentTemplate);

		Document_Template__c merchSettleDocumentTemplate = new Document_Template__c();
		merchSettleDocumentTemplate.Name = 'Merchant Settlements';
		merchSettleDocumentTemplate.XML__c = '<Schema>{{#transactions}}<TransactionTable><Transactions>{{transaction}}</Transactions></TransactionTable>{{/transactions}}</Schema>';
		merchSettleDocumentTemplate.Document_Type__c = 'Merchant Settlements';
		merchSettleDocumentTemplate.Signature_Required__c = True;
		merchSettleDocumentTemplate.ECM_Account_Number_Metadata__c = true;
		merchSettleDocumentTemplate.ECM_Business_Unit_Metadata__c = true;
		merchSettleDocumentTemplate.ECM_CIF_Code_Metadata__c = true;
		merchSettleDocumentTemplate.ECM_Filing_Date_Metadata__c = true;
		merchSettleDocumentTemplate.ECM_ID_Number_Metadata__c = true;
		merchSettleDocumentTemplate.ECM_Item_Type__c = 'Ent_ProofOfAddress';
		merchSettleDocumentTemplate.ECM_Origin_Metadata__c = true;
		merchSettleDocumentTemplate.Opportunity_Record_Types__c = 'Merchant Onboarding';
		merchSettleDocumentTemplate.Parent_Document_Type__c = 'Business Client Agreement';
		docTempList.add(merchSettleDocumentTemplate);

		Document_Template__c documentTemplate5122 = new Document_Template__c();
		documentTemplate5122.Name = 'Absa 5122 EX - Merchant Application Form';
		documentTemplate5122.XML__c = '<Schema>{{#transactions}}<TransactionTable><Transactions>{{transaction}}</Transactions></TransactionTable>{{/transactions}}</Schema>';
		documentTemplate5122.Document_Type__c = 'Absa 5122 EX - Merchant Application Form';
		documentTemplate5122.Signature_Required__c = True;
		documentTemplate5122.ECM_Account_Number_Metadata__c = true;
		documentTemplate5122.ECM_Business_Unit_Metadata__c = true;
		documentTemplate5122.ECM_CIF_Code_Metadata__c = true;
		documentTemplate5122.ECM_Filing_Date_Metadata__c = true;
		documentTemplate5122.ECM_ID_Number_Metadata__c = true;
		documentTemplate5122.ECM_Item_Type__c = 'Ent_ProofOfAddress';
		documentTemplate5122.ECM_Origin_Metadata__c = true;
		documentTemplate5122.Opportunity_Record_Types__c = 'Merchant Onboarding';
		documentTemplate5122.Parent_Document_Type__c = 'Business Client Agreement';
		docTempList.add(documentTemplate5122);

		insert docTempList;

		Document__c testQuoteDocument = new Document__c();
		testQuoteDocument.Name = 'Quote.pdf';
		testQuoteDocument.Type__c = System.Label.Merchant_Quote_Document_Template_Name;
		testQuoteDocument.Opportunity__c = testMerchantOnboardingOpportunity.Id;
		testQuoteDocument.Contact__c = testContact.id;
		testQuoteDocument.Reference__c = '82 3 ICM7 UGOLSDB4 Will59 26 A1001001A19F14B41357J5034318 A19F14B41357J503431 14 2364';
		insert testQuoteDocument;

		Application_Financial_Account__c afa = new Application_Financial_Account__c(Application_Product_CPF__c = appPrdctcpf.id);
		insert afa;

		List<Application_Contract_Clause__c> covenants = new List<Application_Contract_Clause__c>();
		covenants.add(new Application_Contract_Clause__c(Application_Product_CPF__c = appPrdctcpf.id, Category__c = 'CPF Application', Type__c = 'Other Transactional Covenants'));
		covenants.add(new Application_Contract_Clause__c(Application_Product_CPF__c = appPrdctcpf.id, Category__c = 'CPF Application', Type__c = 'Loan and Value Covenants'));
		covenants.add(new Application_Contract_Clause__c(Application_Product_CPF__c = appPrdctcpf.id, Category__c = 'CPF Application', Type__c = 'Debit Service Cover Ratio'));
		covenants.add(new Application_Contract_Clause__c(Application_Product_CPF__c = appPrdctcpf.id, Category__c = 'CPF Application', Type__c = 'Other Entity'));
		covenants.add(new Application_Contract_Clause__c(Application_Product_CPF__c = appPrdctcpf.id, Category__c = 'CPF Application', Type__c = 'Further Condition Precedent'));
		covenants.add(new Application_Contract_Clause__c(Application_Product_CPF__c = appPrdctcpf.id, Category__c = 'CPF Application', Type__c = 'Special Condition'));
		covenants.add(new Application_Contract_Clause__c(Application_Product_CPF__c = appPrdctcpf.id, Category__c = 'CPF Application', Type__c = 'Lease'));
		insert covenants;

		LIST<Application_Lease_CPF__c> leases = new LIST<Application_Lease_CPF__c>();
		leases.add(new Application_Lease_CPF__c(Application_Product_CPF__c = appPrdctcpf.id, Other_Lease__c = 'Other Lease'));
		leases.add(new Application_Lease_CPF__c(Application_Product_CPF__c = appPrdctcpf.id));
		insert leases;

		Application_Repayment_Account_CPF__c ara = new Application_Repayment_Account_CPF__c(Application_Product_CPF__c = appPrdctcpf.id);
		insert ara;

		List<Security_Offered__c> securitiesOffered = new List<Security_Offered__c>();
		securitiesOffered.add(new Security_Offered__c(Account__c = acc.id, Application__c = cpfApp.id, Security_Type__c = 'Bonds and 99-year Leasehold', Bond_type__c = 'MBOND - MORTGAGE BOND'));
		securitiesOffered.add(new Security_Offered__c(Account__c = acc.id, Application__c = cpfApp.id, Security_Type__c = 'Bonds and 99-year Leasehold', Bond_type__c = 'GNBOND - GENERAL NOTARIAL BOND'));
		securitiesOffered.add(new Security_Offered__c(Account__c = acc.id, Contact__c = con.id, Application__c = cpfApp.id, Security_Type__c = 'Bonds and 99-year Leasehold', Bond_type__c = 'SNBOND - SPECIAL NOTARIAL BOND'));
		securitiesOffered.add(new Security_Offered__c(Account__c = acc.id, Client_Name__c = 'External', External_Entity_Linked__c = false, Application__c = cpfApp.id, Security_Type__c = 'Cession of Internal Investments'));
		securitiesOffered.add(new Security_Offered__c(Account__c = acc.id, Application__c = cpfApp.id, Security_Type__c = 'Cession of External Investments'));
		securitiesOffered.add(new Security_Offered__c(Account__c = acc.id, Application__c = cpfApp.id, Security_Type__c = 'Cession of Life Policy (Not Link)'));
		securitiesOffered.add(new Security_Offered__c(Account__c = acc.id, Application__c = cpfApp.id, Security_Type__c = 'Cession of Life Policy (Link) (Sanlam)'));
		securitiesOffered.add(new Security_Offered__c(Account__c = acc.id, Application__c = cpfApp.id, Security_Type__c = 'Suretyship', Security_Provider_Type__c = 'SECURITY BY / IN FAVOUR OF A SOLE PROPRIETOR'));
		securitiesOffered.add(new Security_Offered__c(Account__c = acc.id, Application__c = cpfApp.id, Security_Type__c = 'General Pledge'));
		securitiesOffered.add(new Security_Offered__c(Account__c = acc.id, Application__c = cpfApp.id, Security_Type__c = 'Cession of Debtors'));
		securitiesOffered.add(new Security_Offered__c(Account__c = acc.id, Application__c = cpfApp.id, Security_Type__c = 'Cession of Unit Trusts'));
		securitiesOffered.add(new Security_Offered__c(Account__c = acc.id, Application__c = cpfApp.id, Security_Type__c = 'Cession of Dematerialised Shares'));
		securitiesOffered.add(new Security_Offered__c(Account__c = acc.id, Application__c = cpfApp.id, Security_Type__c = 'Cession of Fire/Short Term Insurance'));
		securitiesOffered.add(new Security_Offered__c(Account__c = acc.id, Application__c = cpfApp.id, Security_Type__c = 'General Cession'));
		securitiesOffered.add(new Security_Offered__c(Account__c = acc.id, Application__c = cpfApp.id, Security_Type__c = 'Letter of Undertaking'));
		securitiesOffered.add(new Security_Offered__c(Account__c = acc.id, Application__c = cpfApp.id, Security_Type__c = 'Excon Ruling'));
		insert securitiesOffered;

		Questionnaire_Template__c qTemp = new Questionnaire_Template__c();
		qTemp.Name = 'SPM Record Of Advice';
		insert qTemp;

		Questionnaire_Question__c qQues = new Questionnaire_Question__c();
		qQues.Question__c = 'Supervisor attended the client meeting with the supervisee?';
		qQues.Question_Label__c = 'Supervisor attended the client meeting with the supervisee?';
		qQues.Include_Comment__c = true;
		qQues.Section__c = 'Artist Info';
		qQues.Default_Answer__c = 'No';
		qQues.Answer_Options__c = '';
		qQues.Answer_Type__c = 'String';
		qQues.Answer_Control_Type__c = 'Textbox';
		qQues.Questionnaire_Template__c = qTemp.Id;
		insert qQues;

		qQues = new Questionnaire_Question__c();
		qQues.Question__c = 'Client accepted/did not accept advice';
		qQues.Question_Label__c = 'Client accepted/did not accept advice';
		qQues.Include_Comment__c = true;
		qQues.Section__c = 'Artist Info';
		qQues.Default_Answer__c = 'Accepted';
		qQues.Answer_Options__c = '';
		qQues.Answer_Type__c = 'String';
		qQues.Answer_Control_Type__c = 'Textbox';
		qQues.Questionnaire_Template__c = qTemp.Id;
		insert qQues;

		Questionnaire_Answer__c qAnsw = new Questionnaire_Answer__c();
		qAnsw.Answer__c = 'Ola, how you doing?';
		qAnsw.Answer_Data_Type__c = 'String';
		qAnsw.Comment__c = 'Mxm, you do me like that huh?';
		qAnsw.Questionnaire_Question__c = qQues.Id;
		qAnsw.Questionnaire_Template__c = qQues.Questionnaire_Template__c;
		qAnsw.Related_Application__c = testApplication.Id;
		qAnsw.Related_Opportunity__c = testMerchantOnboardingOpportunity.id;
		insert qAnsw;

		Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Service Request').getRecordTypeId();
		Case testCase = new Case(RecordTypeId = caseRecordTypeId, Account = acc);
		//testCase.Additional_Information__c = '<line>76934255\t000000002455665\tZAMAPHI LIQUORS        \tLADYSMITH    \tNTZA\t532\t2021/07/12\t20:55:25\t597\t517992******5011   \tPFMyHF532216\t00\t 00000000010000\t  \tZTRADIN190\t05  \t0733073076\tZAMGAMTRADING@GMAIL.COM                           \t\n</line>\n<line>76934255\t000000002455665\tZAMAPHI LIQUORS        \tLADYSMITH    \tNTZA\t532\t2021/07/11\t04:39:19\t137\t402167******7010   \tPFMyHF532207\t00\t 00000000220000\t  \tZTRADIN190\t05  \t0733073076\tZAMGAMTRADING@GMAIL.COM                           \t\n</line>';
		testCase.Extended_Request_Data__c = '<line>76918831	000000002340099	BP SAM SERVICE STATION 	UMLAZI       	NTZA	119	2021/07/11	19:48:14	163	522250******8568   	PFMuGT119844	00	 00000000079386	  	AWTRADI097	05  	0836355332	bpchurchstreetauto@tiscali.co.                    	</line><line>76918831	000000002340099	BP SAM SERVICE STATION 	UMLAZI       	NTZA	119	2021/07/11	19:28:24	253	457896******5917   	PFMuGT119842	00	 00000000020000	  	AWTRADI097	05  	0836355332	bpchurchstreetauto@tiscali.co.                    	</line><line>76918831	000000002340099	BP SAM SERVICE STATION 	UMLAZI       	NTZA	119	2021/07/11	19:39:21	283	528497******0065   	PFMuGT119843	00	 00000000023000	  	AWTRADI097	05  	0836355332	bpchurchstreetauto@tiscali.co.                    	</line><line>76918831	000000002340099	BP SAM SERVICE STATION 	UMLAZI       	NTZA	119	2021/07/11	19:27:21	747	528497******8355   	PFMuGT119841	00	 00000000015003	  	AWTRADI097	05  	0836355332	bpchurchstreetauto@tiscali.co.                    	</line>';
		testCase.AccountId = testAccount.id;
		insert testCase;

		List<String> endpoints = new List<String>();
		endpoints.add('ECM Query Path');
		endpoints.add('ECM Authenication Path');
		endpoints.add('ECM Add Path');
		endpoints.add('ECM Logout Path');
		endpoints.add('ECM GetItemType Path');
		endpoints.add('ECM Get Path');
		endpoints.add('ECM GetItemTypes Path');
		IntegrationTestDataFactory.insertIntegrationSettings('API Manager', endpoints);

		List<String> endpoints2 = new List<String>();
		endpoints2.add('Document Template Processor');
		IntegrationTestDataFactory.insertIntegrationSettings('Jitterbit2', endpoints2);

		Transaction_Group__c transactionGroup = new Transaction_Group__c();
        insert transactionGroup;

		Accepted_Card__c testAcceptedCard = new Accepted_Card__c(Name='Cash Send',Plan_Type__c = 'CS1',Type__c = 'Card;Merchant Fee Category',Pre_Selected_for_Merchant_Class__c = 'FORECOURT;MEDICAL/RETAIL;RESTAURANT;RETAIL;SASOL;WORKSHOP');
        insert testAcceptedCard;
		Accepted_Card__c acceptedCard = new Accepted_Card__c();
        acceptedCard.Name = 'American Express';
        acceptedCard.Transaction_Group__c = transactionGroup.Id;
        acceptedCard.Plan_Type__c = 'CP1';
        acceptedCard.Pre_Selected_for_Merchant_Class__c = 'RETAIL';
        acceptedCard.Available_for_Merchant_Class__c = 'RESTAURANT';
        acceptedCard.Type__c = StringConstants.MERCHANT_ACCEPTED_CARD_TYPE_CARD;
        acceptedCard.Product_Family__c = 'Merchant';
        insert acceptedCard;

		PricingTestDataFactory pricingTestDataFactory = new PricingTestDataFactory();
	}

	/**
	 * @description testGenerateCPFDocument description
	 *
	 * @@ Return testMethodvoid: Return description
	 */
	@IsTest
	public static void testGenerateCPFDocument(){
		Opportunity cpfOpp = [Select id, Name
		                      from Opportunity
		                      where Name = 'CPF Onboarding'];
		Application_Product_CPF__c appPrdctcpf = [Select id, Name, Final_repayment_date__c
		                                          from Application_Product_CPF__c
		                                          Where Name = 'Test CPF Docs'];

		test.startTest();
		Map<String, String> ss = DocumentsGenerateControler.generateNewDocument(cpfOpp.Id, 'ABSA 6171 EX - Commercial Property Finance Loan');
		System.assertNotEquals(ss, null, 'SOmething should be returned if it is an error');
		test.stopTest();
	}

	@IsTest
	public static void testgenerateDocumentForCase(){
		Case cs = [Select id, Additional_Information__c, Extended_Request_Data__c
		           from Case
		           LIMIT 1];
		test.startTest();
		Map<String, String> ss = GenerateDocument.generateDocumentForCase(cs.Id, 'Merchant Settlements');
		System.assertNotEquals(ss, null, 'SOmething should be returned if it is an error');
		test.stopTest();
	}

	/**
	 * @description testGenerate6157 description
	 *
	 * @@ Return testMethodvoid: Return description
	 */
	@IsTest
	public static void testGenerate6157(){
		Application_Product__c appPrdct = [Select id, Name, Final_repayment_date__c
		                                   from Application_Product__c
		                                   Where Agreement_Category__c = 'M'];

		test.startTest();
		Map<String, String> ss = documentStubController.generateDoc(appPrdct.Id, 'ABSA 6157 EX - OD Facility Letter');
		System.assertNotEquals(ss, null, 'SOmething should be returned if it is an error');
		test.stopTest();
	}

	/**
	 * @description testGenerate5701 description
	 *
	 * @@ Return testMethodvoid: Return description
	 */
	@IsTest
	public static void testGenerate5701(){
		Application_Product__c appPrdct = [Select id, Name, Final_repayment_date__c
		                                   from Application_Product__c
		                                   Where Agreement_Category__c = 'M'];

		test.startTest();
		appPrdct.Agreement_Category__c = 'L';
		update appPrdct;
		documentStubController.generateDoc(appPrdct.Id, 'Credit Onboarding Quote');
		appPrdct.Agreement_Category__c = 'S';
		update appPrdct;
		documentStubController.generateDoc(appPrdct.Id, 'Credit Onboarding Quote');
		appPrdct.Agreement_Category__c = '';
		update appPrdct;
		Map<String, String> ss = documentStubController.generateDoc(appPrdct.Id, 'Credit Onboarding Quote');
		System.assertNotEquals(ss, null, 'SOmething should be returned if it is an error');
		test.stopTest();
	}

	/**
	 * @description testGenerateCPFDocumentMP description
	 *
	 * @@ Return testMethodvoid: Return description
	 */
	@IsTest
	public static void testGenerateCPFDocumentMP(){
		Opportunity cpfOpp = [Select id, Name
		                      from Opportunity
		                      where Name = 'CPF Onboarding'];
		cpfOpp.Form_Status__c = 'Pending Credit Approval';
		update cpfOpp;
		Application_Product_CPF__c appPrdctcpf = [Select id, Name, Final_repayment_date__c
		                                          from Application_Product_CPF__c
		                                          Where Name = 'Test CPF Docs'];

		test.startTest();
		appPrdctcpf.Final_repayment_date__c = 'after the Signature Date';
		appPrdctCpf.Measurement_period__c = 'each period of twelve months ending on the last day of a financial year';
		update appPrdctcpf;
		Map<String, String> ss = DocumentsGenerateControler.generateNewDocument(cpfOpp.Id, 'ABSA 6171 EX - Commercial Property Finance Loan');
		System.assertNotEquals(ss, null, 'SOmething should be returned if it is an error');
		test.stopTest();
	}

	/**
	 * @description testGenerateCPFDocumentAfterSig description
	 *
	 * @@ Return testMethodvoid: Return description
	 */
	@IsTest
	public static void testGenerateCPFDocumentAfterSig(){
		Opportunity cpfOpp = [Select id, Name
		                      from Opportunity
		                      where Name = 'CPF Onboarding'];
		cpfOpp.Form_Status__c = 'Draft';
		update cpfOpp;
		Application_Product_CPF__c appPrdctcpf = [Select id, Name, Final_repayment_date__c
		                                          from Application_Product_CPF__c
		                                          Where Name = 'Test CPF Docs'];

		test.startTest();
		appPrdctcpf.Final_repayment_date__c = 'after the Signature Date';
		appPrdctCpf.Measurement_period__c = 'each period of twelve months ending on the last day of a financial quarter';
		update appPrdctcpf;
		Map<String, String> ss = DocumentsGenerateControler.generateNewDocument(cpfOpp.Id, 'ABSA 6171 EX - Commercial Property Finance Loan');
		System.assertNotEquals(ss, null, 'SOmething should be returned if it is an error');
		test.stopTest();
	}

	/**
	 * @description testGenerateCPFDocumentAfter1st description
	 *
	 * @@ Return testMethodvoid: Return description
	 */
	@IsTest
	public static void testGenerateCPFDocumentAfter1st(){
		Opportunity cpfOpp = [Select id, Name
		                      from Opportunity
		                      where Name = 'CPF Onboarding'];
		Application_Product_CPF__c appPrdctcpf = [Select id, Name, Final_repayment_date__c
		                                          from Application_Product_CPF__c
		                                          Where Name = 'Test CPF Docs'];

		test.startTest();
		appPrdctcpf.Final_repayment_date__c = 'after the date of first drawdown';
		appPrdctCpf.Debt_service_cover_ratio__c = 'No Ratcheting';
		appPrdctCpf.Loan_To_Value_Covenant__c = 'No Ratcheting';
		appPrdctCpf.Measurement_period__c = 'each period of six months ending on the last day of each financial half year';
		update appPrdctcpf;
		Map<String, String> ss = DocumentsGenerateControler.generateNewDocument(cpfOpp.Id, 'ABSA 6171 EX - Commercial Property Finance Loan');
		System.assertNotEquals(ss, null, 'SOmething should be returned if it is an error');
		test.stopTest();
	}

	/**
	 * @description testGenerateDocument description
	 *
	 * @@ Return testMethodvoid: Return description
	 */
	@IsTest
	public static void testGenerateDocument(){
		//WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
		Test.startTest();
		List<String> endpoints = new List<String>();
		endpoints.add(CC_ContentService_IH_v1.GENERATE_CONTENT_PATH);
		endpoints.add(JitterbitAuth_IH_V1.JITTERBIT_AUTH_PATH);
		IntegrationTestDataFactory.insertIntegrationSettings('Jitterbit', endpoints);
		IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new List<String>{'ECM Authenication Path'});
		JitterbitAuthResponse authResponse = JitterbitAuthResponse.getExample();
		authResponse.token = '127168272819';
		CC_GenerateContentResponse res = CC_GenerateContentResponse.getExample();
		RestClientUtils.QueueHttpMock mock = new RestClientUtils.QueueHttpMock();
		mock.addResponse(JSON.serialize(authResponse));
		mock.addResponse(JSON.serialize(res));
		Test.setMock(HttpCalloutMock.class, mock);
		//CC_GenerateContentResponse response = CC_ContentService_IH_v1.generateContent(CC_GenerateContentRequest.getExample());
		//System.assert(response != null);
		//Opportunity opp = createData();
		Opportunity opp = getMerchantOpportunity();
		List<Application__c> applicationDetails = new ApplicationsSelector().selectByOpportunityId(opp.id);
		applicationDetails.get(0).Medium__c = 'Email';
        applicationDetails.get(0).ROA_SectionC_Table_Value__c = '{ id: 1, achiveFfinancialObjectives: "", reommendedNotRecommended: "", reason: "" },'+
			'{ id: 2, achiveFfinancialObjectives: "", reommendedNotRecommended: "", reason: "" },'+
			'{ id: 3, achiveFfinancialObjectives: "", reommendedNotRecommended: "", reason: "" },'+
			'{ id: 4, achiveFfinancialObjectives: "", reommendedNotRecommended: "", reason: "" }';
		CC_GenerateContentRequest request = new CC_GenerateContentRequest();
		String templateName = 'ABSA 3741 - Client Engagement';
		String templateName3121 = 'ABSA 3121 - Physical Site visit conducted for Verification Purposes Confirmation';
		request.fileName = 'Ent_ClientCommunication.pdf';
		Document_Template__c dt = new Document_Template__c();

		dt = new Document_Template__c();
		dt.Name = 'EPP Acceptance Quote';
		dt.Document_Type__c = 'EPP Acceptance Quote';
		dt.Parent_Document_Type__c = 'Business Client Agreement';
		dt.XML__c = '<Account><LastName>{Account.LastName}</LastName>';
		insert dt;

		dt = new Document_Template__c();
		dt.Name = 'EPP T&C';
		dt.Document_Type__c = 'EPP T&C';
		dt.Parent_Document_Type__c = 'Business Client Agreement';
		insert dt;

		dt = new Document_Template__c();
		dt.Name = 'EPP FAQ';
		dt.Document_Type__c = 'EPP FAQ';
		dt.Parent_Document_Type__c = 'Business Client Agreement';
		insert dt;

		String dtName = 'Merchant Settlements';
		dt = new Document_Template__c();
		dt.Name = 'Merchant Settlements';
		dt.Document_Type__c = 'Merchant Settlements';
		dt.Parent_Document_Type__c = 'Business Client Agreement';
		insert dt;
        Questionnaire_Template__c template = new Questionnaire_Template__c();
		template.Name = 'Onboarding Record Of Advice';
        insert template;
        
        List<String> questionLabels = new List<String>{'Meeting date','Advisor or Intermediary','FAIS Classification','Role','Delegates at the Meeting','Net Asset Value of Entity','Current Financial Situation','Current Financial Product Experience change/Investment Risk Profile','Needs or Objectives','Introductory Meeting',
            'Specific product requested','Follow-up Meeting','Other','Presentation','Name of Presentation','Details of Group Name','Date','Location','Folio Number of Presentation','Was the client advised of the risk involved?','The financial position was considered by completing a Financial Needs Analysis','The client opted not to provide the full facts in relation to his/her financial situation',
            'Makro (Sectoral ) – Industry','Makro (Sectoral) – Typical firm or Business Profile','Makro (Sectoral ) – Other','Did you select a product prior to receiving the information you provided?','will address the needs partially or fully replacing an existing financial product','your needs have an investment or investment component?',
            'valueOfInvestmentDetermined','feesToLevied','indicativeOfFuturePerformances','monetaryObligations','anyIncentives','penalties','specialTermsConditions','productReadilyAccessible','collingOffRights','riskswithProducts','Is this a replacement product?'};
        List<Questionnaire_Question__c> questions = new List<Questionnaire_Question__c>();
        List<Questionnaire_Answer__c> answers = new List<Questionnaire_Answer__c>();
        for(String labels : questionLabels){
            Questionnaire_Question__c question = new Questionnaire_Question__c();
            question.Question__c = labels;
            question.Question_Label__c = labels;
            question.Questionnaire_Template__c =template.Id;
            question.Section__c = labels;
            question.Answer_Control_Type__c = 'Textbox';
            question.Answer_Type__c = 'String';
            questions.add(question);
        }
        insert questions;
        for(Questionnaire_Question__c ques :  questions){
            Questionnaire_Answer__c ans = new Questionnaire_Answer__c();
            if(ques.question__c == 'The client opted not to provide the full facts in relation to his/her financial situation' || ques.question__c =='The financial position was considered by completing a Financial Needs Analysis'){
                ans.Answer__c ='true';
            }
            else{
                ans.Answer__c ='test';
            }
            ans.Answer_Data_Type__c = 'text';
            ans.Related_Opportunity__c = opp.Id;
            ans.Questionnaire_Question__c = ques.id;
            ans.Questionnaire_Template__c =  template.Id;
            answers.add(ans);
        }
        insert answers;
        GenerateDocument.generateTheDocument(opp.Id, templateName, null);
		Map<String, String> ss = GenerateDocument.generateNewDocument(opp.Id, templateName3121, null);
		GenerateDocument.updateDocument(getIndividualAccount(), opp.Id, get3121DocumentTemplate(), getQuoteDocumentId(), request, res);
		Map<String, String> ss1 = GenerateDocument.generateNewDocument(getCase().Id, dtName, null);
        System.assertNotEquals(ss, null, 'SOmething should be returned if it is an error');
		Test.stopTest();
	}

	/**
	 * @description testGenerateDocument2 description
	 *
	 * @@ Return testMethodvoid: Return description
	 */
	@IsTest
	public static void testGenerateDocument2(){
		//WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
		Test.startTest();
		List<String> endpoints = new List<String>();
		endpoints.add(CC_ContentService_IH_v1.GENERATE_CONTENT_PATH);
		endpoints.add(JitterbitAuth_IH_V1.JITTERBIT_AUTH_PATH);
		IntegrationTestDataFactory.insertIntegrationSettings('Jitterbit', endpoints);
		IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new List<String>{'ECM Authenication Path'});
		JitterbitAuthResponse authResponse = JitterbitAuthResponse.getExample();
		authResponse.token = '127168272819';
		CC_GenerateContentResponse res = CC_GenerateContentResponse.getExample();
		RestClientUtils.QueueHttpMock mock = new RestClientUtils.QueueHttpMock();
		mock.addResponse(JSON.serialize(authResponse));
		mock.addResponse(JSON.serialize(res));
		Test.setMock(HttpCalloutMock.class, mock);
		//CC_GenerateContentResponse response = CC_ContentService_IH_v1.generateContent(CC_GenerateContentRequest.getExample());
		//System.assert(response != null);
		//Opportunity opp = createData();
		Opportunity opp = getMerchantOpportunity();
		List<Application__c> applicationDetails = new ApplicationsSelector().selectByOpportunityId(opp.id);
		applicationDetails.get(0).Medium__c = 'Scan and Email';
        applicationDetails.get(0).ROA_SectionC_Table_Value__c = '{ id: 1, achiveFfinancialObjectives: "", reommendedNotRecommended: "", reason: "" },'+
            '{ id: 2, achiveFfinancialObjectives: "", reommendedNotRecommended: "", reason: "" },'+
            '{ id: 3, achiveFfinancialObjectives: "", reommendedNotRecommended: "", reason: "" },'+
            '{ id: 4, achiveFfinancialObjectives: "", reommendedNotRecommended: "", reason: "" }';
		CC_GenerateContentRequest request = new CC_GenerateContentRequest();
		String templateName = 'ABSA 3741 - Client Engagement';
		String templateName3121 = 'ABSA 3121 - Physical Site visit conducted for Verification Purposes Confirmation';
		request.fileName = 'Ent_ClientCommunication.pdf';
		Document_Template__c dt = new Document_Template__c();

		dt = new Document_Template__c();
		dt.Name = 'EPP Acceptance Quote';
		dt.Document_Type__c = 'EPP Acceptance Quote';
		dt.Parent_Document_Type__c = 'Business Client Agreement';
		dt.XML__c = '<Account><LastName>{Account.LastName}</LastName>';
		insert dt;

		dt = new Document_Template__c();
		dt.Name = 'EPP T&C';
		dt.Document_Type__c = 'EPP T&C';
		dt.Parent_Document_Type__c = 'Business Client Agreement';
		insert dt;

		dt = new Document_Template__c();
		dt.Name = 'EPP FAQ';
		dt.Document_Type__c = 'EPP FAQ';
		dt.Parent_Document_Type__c = 'Business Client Agreement';
		insert dt;

		Account clientAccount = getClientAccount();
		opp.AccountId = clientAccount.Id;
		update opp;

		List<SignatureRequest__c> sigReqs = new List<SignatureRequest__c>();
		SignatureRequest__c sigReq = new SignatureRequest__c();
		sigReq.Fullname__c = 'Test Signature';
		sigReq.Title__c = 'Test Title';
		sigReq.Email__c = 'test@gmail.com';
		sigReq.Mobile__c = '1234567898';
		sigReqs.add(sigReq);
        Questionnaire_Template__c template = new Questionnaire_Template__c();
		template.Name = 'Onboarding Record Of Advice';
        insert template;
        
        List<String> questionLabels = new List<String>{'Meeting date','Advisor or Intermediary','FAIS Classification','Role','Delegates at the Meeting','Net Asset Value of Entity','Current Financial Situation','Current Financial Product Experience change/Investment Risk Profile','Needs or Objectives','Introductory Meeting',
            'Specific product requested','Follow-up Meeting','Other','Presentation','Name of Presentation','Details of Group Name','Date','Location','Folio Number of Presentation','Was the client advised of the risk involved?','The financial position was considered by completing a Financial Needs Analysis','The client opted not to provide the full facts in relation to his/her financial situation',
            'Makro (Sectoral ) – Industry','Makro (Sectoral) – Typical firm or Business Profile','Makro (Sectoral ) – Other','Did you select a product prior to receiving the information you provided?','will address the needs partially or fully replacing an existing financial product','your needs have an investment or investment component?',
            'valueOfInvestmentDetermined','feesToLevied','indicativeOfFuturePerformances','monetaryObligations','anyIncentives','penalties','specialTermsConditions','productReadilyAccessible','collingOffRights','riskswithProducts','Is this a replacement product?'};
        List<Questionnaire_Question__c> questions = new List<Questionnaire_Question__c>();
        List<Questionnaire_Answer__c> answers = new List<Questionnaire_Answer__c>();
        for(String labels : questionLabels){
            Questionnaire_Question__c question = new Questionnaire_Question__c();
            question.Question__c = labels;
            question.Question_Label__c = labels;
            question.Questionnaire_Template__c =template.Id;
            question.Section__c = labels;
            question.Answer_Control_Type__c = 'Textbox';
            question.Answer_Type__c = 'String';
            questions.add(question);
        }
        insert questions;
        for(Questionnaire_Question__c ques :  questions){
            Questionnaire_Answer__c ans = new Questionnaire_Answer__c();
            if(ques.question__c == 'The client opted not to provide the full facts in relation to his/her financial situation' || ques.question__c =='The financial position was considered by completing a Financial Needs Analysis'){
                ans.Answer__c ='true';
            }
            else{
                ans.Answer__c ='test';
            }
            ans.Answer_Data_Type__c = 'text';
            ans.Related_Opportunity__c = opp.Id;
            ans.Questionnaire_Question__c = ques.id;
            ans.Questionnaire_Template__c =  template.Id;
            answers.add(ans);
        }
        insert answers;
		GenerateDocument.generateTheDocument(opp.Id, dt.Name, sigReqs);
		Map<String, String> ss = GenerateDocument.generateNewDocument(opp.Id, templateName3121, sigReqs);
		GenerateDocument.updateDocument(clientAccount, opp.Id, get3121DocumentTemplate(), getQuoteDocumentId(), request, res);
		System.assertNotEquals(ss, null, 'SOmething should be returned if it is an error');
		Test.stopTest();
	}

	/**
	 * @description testNFFE description
	 *
	 * @@ Return testMethodvoid: Return description
	 */
	@IsTest
	static void testNFFE(){
		//WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
		Opportunity opp = getMerchantOpportunity();
		Account testAccount = getClientAccount();
		List<Application__c> applicationDetails = new ApplicationsSelector().selectByOpportunityId(opp.id);
		applicationDetails.get(0).Medium__c = 'Fasimile';
		test.startTest();
		testAccount.share_information_to_third_party__c = true;
		testAccount.Is_Marketing_Consent_Email__c = true;
		testAccount.Reason_For_Not_Providing_SA_Tax_Number__c = 'COUNTRY OF TAX RESIDENCY DOESN\'T REQUIRE COLLECTION OF TAX NUMBER';
		testAccount.Identify_the_account_holder_type__c = 'Passive Non Financial Entity (PNFE)-With Foreign Shareholding';
		update testAccount;
		Map<String, String> ss = DocumentsGenerateControler.generateNewDocument(opp.Id, 'ABSA 3121 - Physical Site visit conducted for Verification Purposes Confirmation');
		System.assertNotEquals(ss, null, 'SOmething should be returned if it is an error');
		test.stopTest();
	}

	@IsTest
	static void testNFFE5(){
		//WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
		Opportunity opp = getMerchantOpportunity();
        OpportunityLineItem oppLineItem = getMerchantOpportunityLineItem(opp.Id);
		Account testAccount = getClientAccount();
		List<Application__c> applicationDetails = new ApplicationsSelector().selectByOpportunityId(opp.id);
		applicationDetails.get(0).Medium__c = 'Telephone';
		test.startTest();
		testAccount.Is_Marketing_Consent_voice_rec__c = true;
		testAccount.Credit_Worthiness_Consent__c = true;
		testAccount.Reason_For_Not_Providing_SA_Tax_Number__c = 'CUSTOMER UNABLE OR UNWILLING TO PROVIDE';
		testAccount.Identify_the_account_holder_type__c = 'Financial Institution (FI)';
		update testAccount;
		Map<String, String> ss = DocumentsGenerateControler.generateNewDocument(opp.Id, 'ABSA 3121 - Physical Site visit conducted for Verification Purposes Confirmation');
		System.assertNotEquals(ss, null, 'SOmething should be returned if it is an error');
		test.stopTest();
	}

	@IsTest
	static void testNFFE2(){
		// WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
		Opportunity opp = getMerchantOpportunity();
		Account testAccount = getClientAccount();
		test.startTest();
		testAccount.Identify_the_account_holder_type__c = 'Direct Reporting Non Financial Entity';
		testAccount.Reason_For_Not_Providing_SA_Tax_Number__c = 'TAX NUMBER NOT ISSUED BY THE TAX AUTHORITY IN THE COUNTRY OF TAX RESIDENCY';
		update testAccount;
		Map<String, String> ss = DocumentsGenerateControler.generateNewDocument(opp.Id, 'Absa 5122 EX - Merchant Application Form');
		System.assertNotEquals(ss, null, 'SOmething should be returned if it is an error');
		test.stopTest();
	}

	@IsTest
	static void testNFFE3(){
		//WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
		Opportunity opp = getMerchantOpportunity();
		Account testAccount = getClientAccount();
		test.startTest();
		testAccount.Identify_the_account_holder_type__c = 'Non Reportable Persons';
		update testAccount;
		Map<String, String> ss = DocumentsGenerateControler.generateNewDocument(opp.Id, 'ABSA 3121 - Physical Site visit conducted for Verification Purposes Confirmation');
		System.assertNotEquals(ss, null, 'SOmething should be returned if it is an error');
		test.stopTest();
	}

	@IsTest
	static void test5122(){
		//WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
		Opportunity opp = getMerchantOpportunity();
		Account testAccount = getClientAccount();
		test.startTest();
		testAccount.Identify_the_account_holder_type__c = 'Non Reportable Persons';
		update testAccount;
		Map<String, String> ss = DocumentsGenerateControler.generateNewDocument(opp.Id, 'Absa 5122 EX - Merchant Application Form');
		System.assertNotEquals(ss, null, 'SOmething should be returned if it is an error');
		test.stopTest();
	}

	@isTest
	public static void testSoleTrader(){
		System.Test.startTest();
		// WimiTestDataFactory factory = new WimiTestDataFactory();
		Account testAccount = new Account();
		testAccount.Name = 'Test Name';
		testAccount.Country_of_Incorporation__c = 'South Africa';
		testAccount.Client_Group__c = 'Non Individual';
		testAccount.Client_Type__c = 'Sole Trader';
		testAccount.CASA_Reference_Number__c = '12233';
		testAccount.Registration_Number__c = '2321323';
		testAccount.CIF__c = 'TESTCIF';
		testAccount.Countries_Traded_With__c = 'South Africa';
		testAccount.Source_of_Income__c = 'Grant';//updated from grants to grant
		testAccount.Identify_the_account_holder_type__c = 'Passive Non Financial Entity (PNFE)-With Foreign Shareholding';
		insert testAccount;

		Contact testContact = new Contact();
		testContact.FirstName = 'Test';
		testContact.LastName = 'Contact';
		testContact.Title = 'Mr.';
		testContact.Salutation = 'Mr.';
		testContact.AccountId = testAccount.Id;
		testContact.CASA_Reference_Number__c = '1712994';
		testContact.CASA_Risk_Status__c = 'Low';
		testContact.CASA_Screening_Date__c = Date.valueOf('2018-06-30');
		testContact.CASA_Screening_Status__c = 'Approved';
		testContact.CASA_Analyst_Comments__c = '30406';
		testContact.Occupation__c = 'South Africa';
		testContact.Income_Source__c = 'Bonus';
		testContact.Occupation_Status__c = 'Full Time Employed';
		testContact.Income_Bracket__c = 'R20;000 - R75;000 pm';
		testContact.Occupation_Category__c = 'Advertising';
		testContact.Communication_Language__c = 'Afrikaans';
		testContact.ID_Type__c = 'SA Identity Document';
		testContact.Nationality__c = 'South Africa';
		testContact.Country_of_Origin__c = 'South Africa';
		testContact.Country_of_Residence__c = 'South Africa';
		testContact.Country_of_Birth__c = 'South Africa';
		testContact.MobilePhone = '0747003747';
		testContact.AssistantPhone = '0112232233';
		testContact.Fax = '0112232233';
		testContact.HomePhone = '0112232233';
		testContact.OtherPhone = '0112232233';
		testContact.Phone = '0112232233';
		testContact.AssistantName = 'Test Assistant';
		testContact.Email = 'test123@test.com';
		testContact.FinServ__CurrentEmployer__c = 'Current Employer';
		testContact.Initials__c = 'JJ';
		testContact.Maiden_Name__c = 'Monroe';
		testContact.MailingStreet = 'Test Mailing';
		testContact.OtherStreet = 'Test Other';
		insert testContact;

		AccountContactRelation testAccountContactRelation = [SELECT id, UBO__c, roles
		                                                     FROM AccountContactRelation
		                                                     WHERE AccountId = :testAccount.id];
		//testAccountContactRelation.AccountId = testAccount.id;
		//testAccountContactRelation.ContactId = testContact.id;
		testAccountContactRelation.UBO__c = 'Yes';
		testAccountContactRelation.roles = 'Director;Managing Director/Chief Executive Officer;Shareholder/Controller;Contact Person;Operators on primary accounts ( Internet Main Users, Signatories, Card Users)';
		update testAccountContactRelation;

		Opportunity opp = getMerchantOpportunity();
		OpportunityLineItem oppLineItem = getMerchantOpportunityLineItem(opp.Id);

		ProductContactSignatoryRelationship__c testProductContactSignatoryRelationship = new ProductContactSignatoryRelationship__c();
		testProductContactSignatoryRelationship.AccountContactRelationshipId__c = testAccountContactRelation.Id;
		testProductContactSignatoryRelationship.In_terms_of_Resolution_date__c = Date.today();
		testProductContactSignatoryRelationship.Number_of_Signatories_for_account__c = '1';
		testProductContactSignatoryRelationship.OpportunityProductId__c = oppLineItem.Id;
		testProductContactSignatoryRelationship.PrimaryAccountId__c = testAccount.Id;
		testProductContactSignatoryRelationship.Product_Name__c = oppLineItem.Product2.name;
		testProductContactSignatoryRelationship.Signing_Instructions__c = 'Anyone to sign alone';
		testProductContactSignatoryRelationship.Signing_Purpose__c = 'IssueCards';
		testProductContactSignatoryRelationship.SigningAuthorityFromDate__c = Date.today();
		insert testProductContactSignatoryRelationship;

		opp.AccountId = testAccount.Id;
		update opp;

		Map<String, String> ss = DocumentsGenerateControler.generateNewDocument(opp.Id, 'ABSA 3121 - Physical Site visit conducted for Verification Purposes Confirmation');
		System.assertNotEquals(ss, null, 'SOmething should be returned if it is an error');
		System.Test.stopTest();
	}

	@isTest
	public static void testCompany(){
		System.Test.startTest();
		// WimiTestDataFactory factory = new WimiTestDataFactory();
		Account testAccount = new Account();
		testAccount.Name = 'Test Name';
		testAccount.Country_of_Incorporation__c = 'South Africa';
		testAccount.Client_Group__c = 'Non Individual';
		testAccount.Client_Type__c = 'Company';
		testAccount.CASA_Reference_Number__c = '12233';
		testAccount.Registration_Number__c = '2321323';
		testAccount.CIF__c = 'TESTCIF';
		testAccount.Countries_Traded_With__c = 'South Africa';
		testAccount.Source_of_Income__c = 'Grant';
		testAccount.Identify_the_account_holder_type__c = 'Passive Non Financial Entity (PNFE)-With Foreign Shareholding';
		insert testAccount;
		
		Contact testContact = new Contact();
		testContact.FirstName = 'Test';
		testContact.LastName = 'Contact';
		testContact.Title = 'Mr.';
		testContact.Salutation = 'Mr.';
		testContact.AccountId = testAccount.Id;
		testContact.CASA_Reference_Number__c = '1712994';
		testContact.CASA_Risk_Status__c = 'Low';
		testContact.CASA_Screening_Date__c = Date.valueOf('2018-06-30');
		testContact.CASA_Screening_Status__c = 'Approved';
		testContact.CASA_Analyst_Comments__c = '30406';
		testContact.Occupation__c = 'South Africa';
		testContact.Income_Source__c = 'Bonus';
		testContact.Occupation_Status__c = 'Full Time Employed';
		testContact.Income_Bracket__c = 'R20;000 - R75;000 pm';
		testContact.Occupation_Category__c = 'Advertising';
		testContact.Communication_Language__c = 'Afrikaans';
		testContact.ID_Type__c = 'SA Identity Document';
		testContact.Nationality__c = 'South Africa';
		testContact.Country_of_Origin__c = 'South Africa';
		testContact.Country_of_Residence__c = 'South Africa';
		testContact.Country_of_Birth__c = 'South Africa';
		testContact.MobilePhone = '0747003747';
		testContact.AssistantPhone = '0112232233';
		testContact.Fax = '0112232233';
		testContact.HomePhone = '0112232233';
		testContact.OtherPhone = '0112232233';
		testContact.Phone = '0112232233';
		testContact.AssistantName = 'Test Assistant';
		testContact.Email = 'test123@test.com';
		testContact.FinServ__CurrentEmployer__c = 'Current Employer';
		testContact.Initials__c = 'JJ';
		testContact.Maiden_Name__c = 'Monroe';
		testContact.MailingStreet = 'Test Mailing';
		testContact.OtherStreet = 'Test Other';
		insert testContact;

		AccountContactRelation testAccountContactRelation = [SELECT id, UBO__c, roles
		                                                     FROM AccountContactRelation
		                                                     WHERE AccountId = :testAccount.id];
		//testAccountContactRelation.AccountId = testAccount.id;
		//testAccountContactRelation.ContactId = testContact.id;
		testAccountContactRelation.UBO__c = 'Yes';
		testAccountContactRelation.roles = 'Director;Individual with Authority to Act;Managing Director/Chief Executive Officer;Shareholder/Controller;Contact Person;Operators on primary accounts ( Internet Main Users, Signatories, Card Users)';
		update testAccountContactRelation;

		Opportunity opp = getMerchantOpportunity();
		OpportunityLineItem oppLineItem = getMerchantOpportunityLineItem(opp.Id);

		ProductContactSignatoryRelationship__c testProductContactSignatoryRelationship = new ProductContactSignatoryRelationship__c();
		testProductContactSignatoryRelationship.AccountContactRelationshipId__c = testAccountContactRelation.Id;
		testProductContactSignatoryRelationship.In_terms_of_Resolution_date__c = Date.today();
		testProductContactSignatoryRelationship.Number_of_Signatories_for_account__c = '1';
		testProductContactSignatoryRelationship.OpportunityProductId__c = oppLineItem.Id;
		testProductContactSignatoryRelationship.PrimaryAccountId__c = testAccount.Id;
		testProductContactSignatoryRelationship.Product_Name__c = oppLineItem.Product2.name;
		testProductContactSignatoryRelationship.Signing_Instructions__c = 'Anyone to sign alone';
		testProductContactSignatoryRelationship.Signing_Purpose__c = 'IssueCards';
		testProductContactSignatoryRelationship.SigningAuthorityFromDate__c = Date.today();
		insert testProductContactSignatoryRelationship;

		List<Address__c> addressList = new List<Address__c>();
		Address__c testBusinessAddress = new Address__c(Account__c = testAccount.Id, Address_Type__c = 'Business Address', Shipping_Country__c = 'South Africa', Shipping_State_Province__c = 'Gauteng', Shipping_Street__c = 'Street 37', Shipping_Suburb__c = 'Maboneng', Shipping_Zip_Postal_Code__c = '1619');
		addressList.add(testBusinessAddress);
		Address__c testResAddress = new Address__c(Account__c = testAccount.Id, Address_Type__c = 'Residential', Shipping_Country__c = 'South Africa', Shipping_State_Province__c = 'Gauteng', Shipping_Street__c = 'Street 37', Shipping_Suburb__c = 'Maboneng', Shipping_Zip_Postal_Code__c = '1619');
		addressList.add(testResAddress);
		Address__c testRegAddress = new Address__c(Account__c = testAccount.Id, Address_Type__c = 'Registered', Shipping_Country__c = 'South Africa', Shipping_State_Province__c = 'Gauteng', Shipping_Street__c = 'Street 37', Shipping_Suburb__c = 'Maboneng', Shipping_Zip_Postal_Code__c = '1619');
		addressList.add(testRegAddress);
		Address__c testPostalAddress = new Address__c(Account__c = testAccount.Id, Address_Type__c = 'Postal', Shipping_Country__c = 'South Africa', Shipping_State_Province__c = 'Gauteng', Shipping_Street__c = 'Street 37', Shipping_Suburb__c = 'Maboneng', Shipping_Zip_Postal_Code__c = '1619');
		addressList.add(testPostalAddress);
		Address__c testMasterAddress = new Address__c(Account__c = testAccount.Id, Address_Type__c = 'Master of High Court', Shipping_Country__c = 'South Africa', Shipping_State_Province__c = 'Gauteng', Shipping_Street__c = 'Street 37', Shipping_Suburb__c = 'Maboneng', Shipping_Zip_Postal_Code__c = '1619');
		addressList.add(testMasterAddress);
		Address__c testHOAddress = new Address__c(Account__c = testAccount.Id, Address_Type__c = 'Head Office', Shipping_Country__c = 'South Africa', Shipping_State_Province__c = 'Gauteng', Shipping_Street__c = 'Street 37', Shipping_Suburb__c = 'Maboneng', Shipping_Zip_Postal_Code__c = '1619');
		addressList.add(testHOAddress);
		Address__c testEmpAddress = new Address__c(Account__c = testAccount.Id, Address_Type__c = 'Employers', Shipping_Country__c = 'South Africa', Shipping_State_Province__c = 'Gauteng', Shipping_Street__c = 'Street 37', Shipping_Suburb__c = 'Maboneng', Shipping_Zip_Postal_Code__c = '1619');
		addressList.add(testEmpAddress);
		insert addressList;

		opp.AccountId = testAccount.Id;
		update opp;
		Map<String, String> ss = DocumentsGenerateControler.generateNewDocument(opp.Id, 'ABSA 3121 - Physical Site visit conducted for Verification Purposes Confirmation');
		System.assertNotEquals(ss, null, 'SOmething should be returned if it is an error');
		System.Test.stopTest();
	}

	@isTest
	public static void testPartner(){
		System.Test.startTest();
		// WimiTestDataFactory factory = new WimiTestDataFactory();
		Account testAccount = new Account();
		testAccount.Name = 'Test Name';
		testAccount.Country_of_Incorporation__c = 'South Africa';
		testAccount.Client_Group__c = 'Non Individual';
		testAccount.Client_Type__c = 'Partnership';
		testAccount.CASA_Reference_Number__c = '12233';
		testAccount.CIF__c = 'TESTCIF';
		testAccount.Countries_Traded_With__c = 'South Africa';
		testAccount.Source_of_Income__c = 'Grant';
		testAccount.Identify_the_account_holder_type__c = 'Passive Non Financial Entity (PNFE)-With Foreign Shareholding';
		insert testAccount;
		Opportunity opp = getMerchantOpportunity();
		opp.AccountId = testAccount.Id;
		update opp;
		Map<String, String> ss = DocumentsGenerateControler.generateNewDocument(opp.Id, 'ABSA 3121 - Physical Site visit conducted for Verification Purposes Confirmation');
		System.assertNotEquals(ss, null, 'SOmething should be returned if it is an error');
		System.Test.stopTest();
	}

	@isTest
	public static void testIndividual(){
		System.Test.startTest();
		// WimiTestDataFactory factory = new WimiTestDataFactory();
		Account testAccount = new Account();
		testAccount.Name = 'Test Name';
		testAccount.Country_of_Incorporation__c = 'South Africa';
		testAccount.Client_Group__c = 'Individual';
		testAccount.Client_Type__c = 'Individual';
		testAccount.CASA_Reference_Number__c = '12233';
		testAccount.CIF__c = 'TESTCIF';
		testAccount.Countries_Traded_With__c = 'South Africa';
		testAccount.Source_of_Income__c = 'Salary';
		testAccount.Identify_the_account_holder_type__c = 'Passive Non Financial Entity (PNFE)-With Foreign Shareholding';
		insert testAccount;
		Opportunity opp = getMerchantOpportunity();
		opp.AccountId = testAccount.Id;

		Trading_as_Name__c testTradingAsName = new Trading_as_Name__c();
		testTradingAsName.Name = 'T/A Test';
		testTradingAsName.Account__c = testAccount.id;
		insert testTradingAsName;

		List<Address__c> addressList = new List<Address__c>();
		Address__c testBusinessAddress = new Address__c(Account__c = testAccount.Id, Address_Type__c = 'Business Address', Shipping_Country__c = 'South Africa', Shipping_State_Province__c = 'Gauteng', Shipping_Street__c = 'Street 37', Shipping_Suburb__c = 'Maboneng', Shipping_Zip_Postal_Code__c = '1619');
		addressList.add(testBusinessAddress);
		Address__c testResAddress = new Address__c(Account__c = testAccount.Id, Address_Type__c = 'Residential', Shipping_Country__c = 'South Africa', Shipping_State_Province__c = 'Gauteng', Shipping_Street__c = 'Street 37', Shipping_Suburb__c = 'Maboneng', Shipping_Zip_Postal_Code__c = '1619');
		addressList.add(testResAddress);
		Address__c testRegAddress = new Address__c(Account__c = testAccount.Id, Address_Type__c = 'Registered', Shipping_Country__c = 'South Africa', Shipping_State_Province__c = 'Gauteng', Shipping_Street__c = 'Street 37', Shipping_Suburb__c = 'Maboneng', Shipping_Zip_Postal_Code__c = '1619');
		addressList.add(testRegAddress);
		Address__c testPostalAddress = new Address__c(Account__c = testAccount.Id, Address_Type__c = 'Postal', Shipping_Country__c = 'South Africa', Shipping_State_Province__c = 'Gauteng', Shipping_Street__c = 'Street 37', Shipping_Suburb__c = 'Maboneng', Shipping_Zip_Postal_Code__c = '1619');
		addressList.add(testPostalAddress);
		Address__c testMasterAddress = new Address__c(Account__c = testAccount.Id, Address_Type__c = 'Master of High Court', Shipping_Country__c = 'South Africa', Shipping_State_Province__c = 'Gauteng', Shipping_Street__c = 'Street 37', Shipping_Suburb__c = 'Maboneng', Shipping_Zip_Postal_Code__c = '1619');
		addressList.add(testMasterAddress);
		Address__c testHOAddress = new Address__c(Account__c = testAccount.Id, Address_Type__c = 'Head Office', Shipping_Country__c = 'South Africa', Shipping_State_Province__c = 'Gauteng', Shipping_Street__c = 'Street 37', Shipping_Suburb__c = 'Maboneng', Shipping_Zip_Postal_Code__c = '1619');
		addressList.add(testHOAddress);
		Address__c testEmpAddress = new Address__c(Account__c = testAccount.Id, Address_Type__c = 'Employers', Shipping_Country__c = 'South Africa', Shipping_State_Province__c = 'Gauteng', Shipping_Street__c = 'Street 37', Shipping_Suburb__c = 'Maboneng', Shipping_Zip_Postal_Code__c = '1619');
		addressList.add(testEmpAddress);
		insert addressList;
		update opp;
		Map<String, String> ss = DocumentsGenerateControler.generateNewDocument(opp.Id, 'ABSA 3121 - Physical Site visit conducted for Verification Purposes Confirmation');
		System.assertNotEquals(ss, null, 'SOmething should be returned if it is an error');
		System.Test.stopTest();
	}

	@isTest
	public static void testCreateDocument(){
		// WimiTestDataFactory factory = new WimiTestDataFactory();
		Opportunity opp = getMerchantOpportunity();
		Account acc = getIndividualAccount();
		opp.AccountId = acc.Id;
		Document_Template__c dt = new Document_Template__c();
		dt.Name = 'EPP Acceptance Quote';
		dt.Document_Type__c = 'EPP Acceptance Quote';
		dt.Parent_Document_Type__c = 'Business Client Agreement';
		dt.XML__c = '<Account> <LastName>{Account.LastName}</LastName>';
		insert dt;
		CC_GenerateContentRequest request = new CC_GenerateContentRequest();
		request.fileName = 'Ent_ClientCommunication.pdf';
		CC_GenerateContentResponse response = CC_GenerateContentResponse.getExample();
		List<SignatureRequest__c> sigReqs = new List<SignatureRequest__c>();
		SignatureRequest__c sigReq = new SignatureRequest__c();
		sigReq.Fullname__c = 'Test Signature';
		sigReq.Title__c = 'Test Title';
		sigReq.Email__c = 'test@gmail.com';
		sigReq.Mobile__c = '1234567898';
		sigReqs.add(sigReq);
		String ss = GenerateDocument.createDocument(acc, opp.Id, dt, request, response, sigReqs);
		System.assertNotEquals(ss, null, 'SOmething should be returned if it is an error');
	}

	/**
	 * @description test4492 description
	 *
	 */
	@istest
	public static void test4492(){
		test.startTest();
		Opportunity opp = getMerchantOpportunity();
		Account acc = getClientAccount();
		opp.AccountId = acc.Id;
		System.assertNotEquals(opp.AccountId, null, 'SOmething should be returned if it is an error');
		test.stopTest();
	}

	/**
	 * @description testAutoGenerateDocIdField description
	 *
	 */
	@isTest
	public static void testAutoGenerateDocIdField(){
		//WimiTestDataFactory factory = new WimiTestDataFactory();
		System.Test.startTest();

		Opportunity opp = getMerchantOpportunity();
		Account acc = getClientAccount();
		opp.AccountId = acc.Id;
		Document_Template__c dt = new Document_Template__c();
		OpportunityLineItem oppLineItem = [SELECT Id
		                                   FROM OpportunityLineItem
		                                   WHERE OpportunityId = :opp.Id
		                                   LIMIT 1];
		oppLineItem.Contact_Person__c = getAccountContactRelation(acc.Id).Id;
		update oppLineItem;

		Application_Product_Merchant__c appProdMerch = getApplicationProductMerchant(oppLineItem.Id);
		appProdMerch.Selected_Cards__c = 'Cash Send;Electron (Visa Debit cards);Fleet;Garage Card and Petrol;Mastercard Debit;Mastercard Maestro;Mastercard Pre-paid;Pure Cash;Visa Debit Card;Visa pre-paid';
		update appProdMerch;

		Map<String, String> objectMap = new Map<String, String>();
		objectMap.put('applicationNumber', '009242');
		objectMap.put('applicationId', getApplication(opp.Id).Id);
		objectMap.put('applicationProductMerchantId', appProdMerch.Id);
		objectMap.put('opportunityLineItemId', oppLineItem.id);
		objectMap.put('inputType', 'fieldValues');
		objectMap.put('opportunityId', opp.Id);
		dt.Name = 'Absa 1391: Merchant Agreement';
		dt.Document_Type__c = 'Absa 1391: Merchant Agreement';
		dt.Parent_Document_Type__c = 'Business Client Agreement';
		dt.XML__c = '<Schema><ScheduleA><facilityType>{facilityType}</facilityType></ScheduleA><Main><tradingName>{Account.Name}</tradingName><regOrIdNumber>{Account.Registration_Number__c}</regOrIdNumber><companyEmailAddress>{Application_Product_Merchant__c.Authorised_Signatory__c}</companyEmailAddress><individualAddress>{Application_Product_Merchant__c.Authorised_Signatory__c}</individualAddress><debitDate>2020-06-24T00:00:00</debitDate></Main><Merchant_x0020_Agreement><facilityType>{Application_Product_Merchant__c.Device_Type__c}</facilityType><fuelFixedServiceFee>0</fuelFixedServiceFee><cardFixedService>0</cardFixedService><equipmentDescription></equipmentDescription><Quantity>{OpportunityLineItem.Quantity}</Quantity><rentalAmount>0</rentalAmount><merchantFeeCategory></merchantFeeCategory><merchantFeeRate>0</merchantFeeRate></Merchant_x0020_Agreement></Schema>';
		insert dt;

		System.assert(GenerateDocument.autoGenerateDocIdValues(dt.Name, objectMap) != null);

		dt = new DocumentTemplateSelector().selectTemplateByName(dt.Document_Type__c);
		GenerateDocument.autoGenerateDocIdValues(dt.Name, objectMap);
		System.Test.stopTest();
	}

	@isTest
	public static void testAutoGenerateDocIdField2(){
		//WimiTestDataFactory factory = new WimiTestDataFactory();
		System.Test.startTest();

		Opportunity opp = getMerchantOpportunity();
		Account acc = getClientAccount();
		opp.AccountId = acc.Id;
		Document_Template__c dt = new Document_Template__c();
		OpportunityLineItem oppLineItem = [SELECT Id
		                                   FROM OpportunityLineItem
		                                   WHERE OpportunityId = :opp.Id
		                                   LIMIT 1];
		oppLineItem.Contact_Person__c = getAccountContactRelation(acc.Id).Id;
		update oppLineItem;

		Application_Product_Merchant__c appProdMerch = getApplicationProductMerchant(oppLineItem.Id);
		appProdMerch.Selected_Cards__c = 'Cash Send;Electron (Visa Debit cards);Fleet;Garage Card and Petrol;Mastercard Debit;Mastercard Maestro;Mastercard Pre-paid;Pure Cash;Visa Debit Card;Visa pre-paid';
		update appProdMerch;

		Map<String, String> objectMap = new Map<String, String>();
		objectMap.put('applicationNumber', '009242');
		objectMap.put('applicationId', getApplication(opp.Id).Id);
		objectMap.put('applicationProductMerchantId', appProdMerch.Id);
		objectMap.put('opportunityLineItemId', oppLineItem.id);
		objectMap.put('inputType', 'fieldValues');
		objectMap.put('opportunityId', opp.Id);
		Document_Template__c test4492DocumentTemplate = new Document_Template__c();
		test4492DocumentTemplate.Name = 'Absa 4492 EX (CPA) - Merchant Agreement E-Commerce';
		test4492DocumentTemplate.XML__c = '<Schema><Parties><tradingName>{Account.Name}</tradingName><regOrIdNumber>{Account.Registration_Number__c}{Account.ID_Number__pc}</regOrIdNumber><addressLine1>{Address__c.Shipping_Street__c}</addressLine1><addressLine2></addressLine2><addressCity>{Address__c.Shipping_City__c}</addressCity><addressPostalCoed>{Address__c.Shipping_Zip_Postal_code__c}</addressPostalCoed><addressSuburb>{Address__c.Shipping_Suburb__c}</addressSuburb></Parties><CostToParticipate><TransactionFee>0.00</TransactionFee><FixedMonthlyServiceFee>0.00</FixedMonthlyServiceFee></CostToParticipate><DebitingOfYourAccount><AccountNumber>{Payment_Plan__c.Account_Number__c}</AccountNumber><BranchName>{Payment_Plan__c.Branch_Name__c}</BranchName><BankName>{Payment_Plan__c.Bank_Name__c}</BankName></DebitingOfYourAccount><LocalCredit><merchantFeeCategory>{localCredit}</merchantFeeCategory><merchantFeeRate>0{localCreditFeeRate}</merchantFeeRate></LocalCredit><LocalDebit><merchantFeeCategory>{localDebit}</merchantFeeCategory><merchantFeeRate>0{localDebitFeeRate}</merchantFeeRate></LocalDebit><International><merchantFeeCategory>{internationalCard}</merchantFeeCategory><merchantFeeRate>0{Application_Product_Merchant__c.International_Card__c}</merchantFeeRate></International><ScheduleB><AccountAdministrationFee>0.00</AccountAdministrationFee><ChargebackFee>0{Application_Product_Merchant__c.Chargeback_Fee__c}</ChargebackFee><MonthlyServiceFee>0.0</MonthlyServiceFee></ScheduleB><AISxMetaData><IsDigitalSignature>true</IsDigitalSignature></AISxMetaData></Schema>';
		test4492DocumentTemplate.Document_Type__c = 'Absa 4492 EX (CPA) - Merchant Agreement E-Commerce';
		test4492DocumentTemplate.Signature_Required__c = True;
		test4492DocumentTemplate.ECM_Account_Number_Metadata__c = true;
		test4492DocumentTemplate.ECM_Business_Unit_Metadata__c = true;
		test4492DocumentTemplate.ECM_CIF_Code_Metadata__c = true;
		test4492DocumentTemplate.ECM_Filing_Date_Metadata__c = true;
		test4492DocumentTemplate.ECM_ID_Number_Metadata__c = true;
		test4492DocumentTemplate.ECM_Item_Type__c = 'Ent_Agreement';
		test4492DocumentTemplate.ECM_Origin_Metadata__c = true;
		test4492DocumentTemplate.Opportunity_Record_Types__c = 'Merchant Onboarding';
		test4492DocumentTemplate.Parent_Document_Type__c = 'Business Client Agreement';
		insert test4492DocumentTemplate;

		test4492DocumentTemplate = new DocumentTemplateSelector().selectTemplateByName(test4492DocumentTemplate.Document_Type__c);
		System.assert(GenerateDocument.autoGenerateDocIdValues(test4492DocumentTemplate.Name, objectMap) == null);
		Map<String, Double> getFees = GenerateDocument.getFeeCategoryMap(opp.Id, appProdMerch.Id);
		Map<String, Double> getCards = GenerateDocument.getSelectedCardsMap(opp.Id, appProdMerch.Id);

		System.Test.stopTest();
	}

	/**
	 * @description testAutoGenerateDocField description
	 *
	 */
	@isTest
	public static void testAutoGenerateDocField(){
		System.Test.startTest();
		// WimiTestDataFactory factory = new WimiTestDataFactory();
		Opportunity opp = getMerchantOpportunity();
		Account acc = getIndividualAccount();
		opp.AccountId = acc.Id;
		Document_Template__c dt = new Document_Template__c();

		Map<String, String> fieldValue = new Map<String, String>();

		fieldValue.put('[SmartPay Terminal Rent]:[All]', '199');
		fieldValue.put('[Mobile Terminal Rent]:[All]', '420');
		fieldValue.put('[Initiation Fee]:[All]', '0');
		fieldValue.put('[Cancellation Fee]:[All]', '0');
		fieldValue.put('[MDF]:[All]', '390');
		fieldValue.put('[Desktop Terminal Rent]:[All]', '249');
		fieldValue.put('[International Card]:[All]', '2.74');
		fieldValue.put('[Debit Card]:[All]', '2.06');
		fieldValue.put('[Credit Card]:[All]', '2.06');
		fieldValue.put('quoteExpirationDate', '2020-08-04T17:07:01');
		fieldValue.put('quoteGeneratedBy', 'prashant.jain@absa.africa');
		fieldValue.put('quoteGenerationDate', '2020-07-25T17:07:01');
		fieldValue.put('selectedQuantity', '1');
		fieldValue.put('productName', 'Mobile - SmartPay');
		fieldValue.put('accountName', 'SOUTH AFRICAN COMPENSATORS (PTY) LTD');
		fieldValue.put('inputType', 'fieldValues');
		fieldValue.put('opportunityId', opp.Id);
		fieldValue.put('otherPrductOffering1', 'Monthly Admin Fee');
		fieldValue.put('numberOfDevices1', '2');
		fieldValue.put('sigDate', '2020-07-16T00:00:00');
		fieldValue.put('merchantFeeCategory', '');
		fieldValue.put('pricingRate', '34');
		fieldValue.put('pricingDate', '2020-07-16T00:00:00');
		fieldValue.put('condition', '567');
		fieldValue.put('monthlyAdminFee', '57');
		fieldValue.put('OnceoffSIMactivationfeepercellphonedevice', '68');
		fieldValue.put('ImplementationFee', '65');
		fieldValue.put('OnceoffECommerceBatchLinkSetUpfee', '68');
		fieldValue.put('MonthlyMaintenanceFee', '356');
		fieldValue.put('ChargebackFee', '93');
		fieldValue.put('CardNotPresentDebitCards', '87');
		fieldValue.put('CardNotPresentCreditCards', '56');

		System.assert(GenerateDocument.autoGenerateDoc('Absa 5778 EX - Merchant Payment Pricing Proposal', fieldValue) == null);

		System.Test.stopTest();
	}

	/**
	 * @description testAutoGenerateDocFieldAutoGenerate description
	 *
	 */
	@isTest
	public static void testAutoGenerateDocFieldAutoGenerate(){
		System.Test.startTest();
		// WimiTestDataFactory factory = new WimiTestDataFactory();
		Opportunity opp = getMerchantOpportunity();
		Account acc = getIndividualAccount();
		opp.AccountId = acc.Id;
		Document_Template__c dt = new Document_Template__c();


		Map<String, String> fieldValue = new Map<String, String>();

		fieldValue.put('[SmartPay Terminal Rent]:[All]', '199');
		fieldValue.put('[Mobile Terminal Rent]:[All]', '420');
		fieldValue.put('[Initiation Fee]:[All]', '0');
		fieldValue.put('[Cancellation Fee]:[All]', '0');
		fieldValue.put('[MDF]:[All]', '390');
		fieldValue.put('[Desktop Terminal Rent]:[All]', '249');
		fieldValue.put('[International Card]:[All]', '2.74');
		fieldValue.put('[Debit Card]:[All]', '2.06');
		fieldValue.put('[Credit Card]:[All]', '2.06');
		fieldValue.put('quoteExpirationDate', '2020-08-04T17:07:01');
		fieldValue.put('quoteGeneratedBy', 'prashant.jain@absa.africa');
		fieldValue.put('quoteGenerationDate', '2020-07-25T17:07:01');
		fieldValue.put('selectedQuantity', '1');
		fieldValue.put('productName', 'Mobile - SmartPay');
		fieldValue.put('accountName', 'SOUTH AFRICAN COMPENSATORS (PTY) LTD');
		fieldValue.put('inputType', 'idValues');
		fieldValue.put('opportunityId', opp.Id);
		fieldValue.put('otherPrductOffering1', 'Monthly Admin Fee');
		fieldValue.put('numberOfDevices1', '2');
		fieldValue.put('sigDate', '2020-07-16T00:00:00');
		fieldValue.put('merchantFeeCategory', '');
		fieldValue.put('pricingRate', '34');
		fieldValue.put('pricingDate', '2020-07-16T00:00:00');
		fieldValue.put('condition', '567');
		fieldValue.put('monthlyAdminFee', '57');
		fieldValue.put('OnceoffSIMactivationfeepercellphonedevice', '68');
		fieldValue.put('ImplementationFee', '65');
		fieldValue.put('OnceoffECommerceBatchLinkSetUpfee', '68');
		fieldValue.put('MonthlyMaintenanceFee', '356');
		fieldValue.put('ChargebackFee', '93');
		fieldValue.put('CardNotPresentDebitCards', '87');
		fieldValue.put('CardNotPresentCreditCards', '56');

		System.assert(GenerateDocument.autoGenerateDoc('Absa 5778 EX - Merchant Payment Pricing Proposal', fieldValue) == null);

		System.Test.stopTest();
	}

	/**
	 * @description testResolveObjects description
	 *
	 */
	@isTest
	public static void testResolveObjects(){
		System.Test.startTest();
		// WimiTestDataFactory factory = new WimiTestDataFactory();
		Account acc = getIndividualAccount();
		Opportunity opp = getMerchantOpportunity();
		Map<Id, SObject> actual = GenerateDocument.resolveObjects(acc, opp);
		System.assert(actual != null);
		System.Test.stopTest();
	}

	@isTest
	public static void testSetRequestParam(){
		System.Test.startTest();
		// WimiTestDataFactory factory = new WimiTestDataFactory();
		Document_Template__c template = new Document_Template__c();
		template.Name = 'EPP ROA';
		template.Document_Type__c = 'EPP ROA';
		template.Parent_Document_Type__c = 'Business Client Agreement';
		insert template;
		Account acc = getIndividualAccount();
		CC_GenerateContentRequest actual = GenerateDocument.setRequestParam(acc, template, template.XML__c);
		System.assert(actual != null);
		System.Test.stopTest();
	}

	@isTest
	public static void test(){
		System.Test.startTest();
		// WimiTestDataFactory factory = new WimiTestDataFactory();
		// Account acc = factory.testAccount;
		// Opportunity opp = factory.testOpportunity;
		Document_Template__c template = new Document_Template__c();
		template.Name = 'EPP ROA';
		template.Document_Type__c = 'EPP ROA';
		template.Parent_Document_Type__c = 'Business Client Agreement';
		template.XML__c = '<Account><LastName>{Account.LastName}</LastName>';
		insert template;
		// String actual = GenerateDocument.generateXmlData(acc, opp, template); // This is private so will not be visible here
		System.assert(template.Name != null);
		System.Test.stopTest();
	}
     @IsTest
	public static void testgenerateDocumentForCaseAIP(){
		id RecordtypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('AIP Case').getRecordTypeId();
        Case cs = [Select id, Additional_Information__c, Extended_Request_Data__c
		           from Case
		           LIMIT 1];
        cs.RecordtypeId = RecordtypeId;
        update cs;
		test.startTest();
		Map<String, String> ss = GenerateDocument.generateDocumentForCase(cs.Id, 'Merchant Settlements');
		System.assertNotEquals(ss, null, 'SOmething should be returned if it is an error');
		test.stopTest();
	}
	private static Account getIndividualAccount(){
		Map<String, Schema.RecordTypeInfo> AccountRecordTypeMap = Account.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
		Id accountId = [SELECT Id
		                FROM Account
		                WHERE RecordTypeId = :AccountRecordTypeMap.get('Individual_Client').getRecordTypeId()
		                LIMIT 1].Id;
		return new AccountsSelector().selectAllById(accountId);
	}

	private static Account getClientAccount(){
		Map<String, Schema.RecordTypeInfo> AccountRecordTypeMap = Account.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
		Id accountId = [SELECT Id
		                FROM Account
		                WHERE RecordTypeId = :AccountRecordTypeMap.get('Client').getRecordTypeId()
		                LIMIT 1].Id;
		return new AccountsSelector().selectCasaFieldsById(accountId, 1)[0];
	}

	private static Opportunity getMerchantOpportunity(){
		Map<String, Schema.RecordTypeInfo> OpportunityRecordTypeMap = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
		Id opportunityId = [SELECT Id
		                    FROM Opportunity
		                    WHERE RecordTypeId = :OpportunityRecordTypeMap.get('Merchant_Onboarding').getRecordTypeId()
		                    LIMIT 1].Id;
		return new OpportunitiesSelector().selectByOpportunityId(opportunityId)[0];
	}

	private static Case getCase(){
		Id caseId = [SELECT Id
		             FROM Case
		             LIMIT 1].Id;
		return new CasesSelector().selectByCaseId(caseId)[0];
	}

	private static Document_Template__c get3121DocumentTemplate(){
		return new DocumentTemplateSelector().selectTemplateByName('ABSA 3121 - Physical Site visit conducted for Verification Purposes Confirmation');
	}

	private static Id getQuoteDocumentId(){
		Id documentId = [SELECT Id
		                 FROM Document__c
		                 WHERE Name = 'Quote.pdf'
		                 LIMIT 1].Id;
		return documentId;
	}

	private static OpportunityLineItem getMerchantOpportunityLineItem(Id opportunityId){
		return new OpportunityLineItemsSelector().selectParentLineItemsByOpportunityId(opportunityId, 1)[0];
	}

	private static AccountContactRelation getAccountContactRelation(Id accountId){
		return new AccountContactRelationSelector().selectRelationByAccountId(accountId)[0];
	}

	private static Application__c getApplication(Id opportunityId){
		return new ApplicationsSelector().selectByCreditOpportunityId(opportunityId);
	}

	private static Application_Product_Merchant__c getApplicationProductMerchant(Id oppLineItemId){
		return new ApplicationProductMerchantsSelector().selectIdsByOpportunityLineItemId(oppLineItemId)[0];
	}
}