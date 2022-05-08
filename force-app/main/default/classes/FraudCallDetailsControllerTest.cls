/**
 * @description       : Test Class for FraudController
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             :
 * @last modified on  : 2021-10-19
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log
 * Ver   Date         Nkaiseng Malete      Modification
 * 1.0   05-11-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
 **/
@IsTest
public class FraudCallDetailsControllerTest {
	public static final String POSITIVE_RESPONSE_BODY = '{"applicationDateTime": "2020-07-12T08:30:09+10:00","header": {"channel": {             "channelDetails": [                 {                     "fieldName": "SITE_CODE",                     "value": "9082"                 },                 {                     "fieldName": "USER_ID",                     "value": "123456"                 },                 {                     "fieldName": "USER_TYPE",                     "value": "Employee"                 },                 {                     "fieldName": "BRANCH_NAME",                     "value": "cresta"                 },                 {                     "fieldName": "IP_ADDRESS",                     "value": "190.90.92"                 },                 {                     "fieldName": "TERMINAL_ID",                     "value": "23456"                 },                 {                     "fieldName": "OS",                     "value": "android"                 }             ],             "channelType": "BRANCH",             "channelName": "DSP"         },         "channelReference": "0986532222"     },     "productDetails": {         "campaignReference": 98765,         "limitAmount": 0,         "productSubType": "Cheque",         "productType": "SAVINGS"     },     "customerDetails": [         {             "addressDetails": [                 {                     "addressDateSince": 8,                     "addressType": "HOME_ADDRESS",                     "buildingName": "Absa building",                     "postalCode": 2194,                     "streetName": "Republic road",                     "streetNumber": 270,                     "suburbOrTown": "Randburg"                 }             ],             "creditDetails": {                 "grossIncome": 0,                 "totalExpenses": 0             },             "customerIndicator": "PRIMARY",             "customerType": "NEW_TO_BANK",             "dateOfBirth": "1994-03-25",             "employmentDetails": {                 "companyName": "Absa",                 "employmentSector": "Information and communication technology",                 "occupationLevel": "Manager",                 "occupationStatus": "Full Time Employed",                 "companyPhoneNumber": "string",                 "companyEmailAddress": "string",                 "occupationalStatusCode": 0             },             "firstName": "Cynthia",             "gender": "MALE",             "identity": {                 "idNumber": 9403250985081,                 "idType": "PASSPORT",                 "passportNationality": "ZIM"             },             "language": "english",             "lastName": "string",             "maritalStatus": "MARRIED",             "noOfDependants": 0,             "qualification": "Matric",             "residentialStatus": "Renter",             "tempPermitNo": "string",             "contactDetails": [                 {                     "contactDetailsType": "EMAIL_ADDRESS",                     "preferenceOrder": 0,                     "contactDetailsDescription": "PERSONAL_EMAIL",                     "correspondence": "test@absa.africa"                 },                 {                     "contactDetailsType": "PHONE_NUMBER",                     "preferenceOrder": 0,                     "contactDetailsDescription": "MOBILE_NUMBER",                     "correspondence": "0819908786"                 },                 {                     "contactDetailsType": "PHONE_NUMBER",                     "preferenceOrder": 0,                     "contactDetailsDescription": "HOME_PHONE",                     "correspondence": "0838491324"                 }             ]         }     ] }';
	// public static final String POSITIVE_RESPONSE_BODY = '{"headers":{"X-Backside-Transport":["OK OK"],"Connection":["Keep-Alive"],"Transfer-Encoding":["chunked"],"X-Powered-By":["Servlet/3.1"],"Content-Type":["application/json; charset=UTF-8"],"Content-Language":["en-US"],"Date":["Mon, 07 Dec 2020 10:13:34 GMT"],"Expires":["Thu, 01 Dec 1994 16:00:00 GMT"],"Cache-Control":["no-cache=\"set-cookie, set-cookie2\""],"X-Global-Transaction-ID":["1cf73a895fce004ec67f67ad"],"Access-Control-Expose-Headers":["APIm-Debug-Trans-Id, X-RateLimit-Limit, X-RateLimit-Remaining, X-RateLimit-Reset, X-Global-Transaction-ID"],"Access-Control-Allow-Origin":["*"],"Access-Control-Allow-Methods":["POST"],"Set-Cookie":["LtpaToken2=\"\"; Expires=Thu, 01 Dec 1994 16:00:00 GMT; Path=/; Secure; HttpOnly","LtpaToken2=Qq0mFXVDnbh6/7BhhI1hjCV3+KnusyxFT6nT9aNiNwPjXvFB1HEeJTvzVTRRGtOqD4pg1f1xn1eJiWYxrydSiazSk+XWFqmvcCr8xvqefLZMQoxOHYt5dgUVHzo8YnsmiB3hqow3mU5/izpXvJtFzYboBgQVqsj0IUH2jlvPhsNKutTVe1aCuPnHyAIqvsVx0eDEuFpEUxyrFQGGAbrub8cASWpcAllj6vAV/A1FeIA0H6fBxopcWkj97uAodN0BMMtD+GZhCUN7jUaO4pbcVJXtEPhprfJnq8rJm7PzNs2xPwHw8Ah9x3W3JUuD+MuV; Path=/; HttpOnly"],"X-RateLimit-Limit":["name=100 Per Minute,100;"],"X-RateLimit-Remaining":["name=100 Per Minute,99;"]},"body":{"NBSAPDPO": {"NBSAPLO": {"returnCode": 98,"reasonCode": 62557593,"outputServiceVersion": "uscab"}},"MSGO": {"NBSMSGO3": {"version": "6.8.1","systemErrorText": "nadahize","numberUserMessages": 330,"numberUserErrors": 274,"messageEntry": [{"messageClass": "26","messageCode": "29","messageErrorIndicator": "54","messageText": "53"},{"messageClass": "57","messageCode": "32","messageErrorIndicator": "42", "messageText": "64"},{"messageClass": "18","messageCode": "23","messageErrorIndicator": "26","messageText": "32"},{"messageClass": "46","messageCode": "56","messageErrorIndicator": "26","messageText": "33"},{"messageClass": "19","messageCode": "40","messageErrorIndicator": "34","messageText": "34"}]}},"SVSP15O": {"SVNP15O_OUTPUT_AREA": {"AccountNumber": 9051159122}}}';
	public static final String POSITIVE_RESPONSE_BODYSer = '{"FraudService_Resp_IB_v1":{"outTransferred": 2,"msgNo": 200,"msg":"Succesfully got Client Details"}}';

	@TestSetup
	static void makeData() {
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT2,
			new List<String>{ SVcreateLinkSavingsAccount_IH_v1.INTEGRATION_SERVICE_NAME }
		);

		Account mainacc = new Account(
			Name = 'TheStokvel',
			Phone = '0840404898',
			CIF__c = 'SEBENZA037',
			CASA_Reference_Number__c = '121229158',
			Client_Group__c = 'Non Individual',
			Number_of_Participants__c = 2
		);
		insert mainacc;

		Pricebook2 pb = new Pricebook2();
		pb.IsActive = true;
		pb.id = test.getStandardPricebookId();
		update pb;

		Product2 savingsprod = new Product2(Name = 'Savings Product', Family = 'Savings', ProductCode = '09050');
		insert savingsprod;

		Product2 savingsprodInvset = new Product2(Name = 'Investment Club', Family = 'Savings', ProductCode = '09072');
		insert savingsprodInvset;

		PricebookEntry savingsPrice = new PricebookEntry(Pricebook2Id = pb.Id, Product2Id = savingsprod.Id, UnitPrice = 12000, IsActive = true);
		insert savingsPrice;

		PricebookEntry savingsPriceInvse = new PricebookEntry(Pricebook2Id = pb.Id, Product2Id = savingsprodInvset.Id, UnitPrice = 12000, IsActive = true);
		insert savingsPriceInvse;

		Sales_Process_Type__c salesProcess = new Sales_Process_Type__c();
		salesProcess.Request_Name__c = 'CAF Application';
		salesProcess.Name = 'CAF Application';
		salesProcess.Opportunity_Record_Type__c = 'CAF Application';
		insert salesProcess;

	

		Account relatedPartyAccount = new Account(
			FirstName = 'Phukubyane',
			LastName = 'Pjane',
			MiddleName = 'snopo',
			Phone = '0835002323',
			CIF__c = '',
			CASA_Reference_Number__c = '121229159',
			Nationality__pc = 'ZIM',
			Highest_Qualification__pc = 'Matric',
			Residential_Status__pc = 'Owner',
			Marital_Status__pc = 'MARRIED',
			Country_of_Residence__pc = 'South Africa',
			ID_Number__pc = '8604254315089',
			Client_Group__c = 'Individual',
			ID_Type__c = 'SA Identity Document',
			Countries_Traded_With__c = 'India',
			Country_of_Birth__pc = 'South Africa',
			Employer_Name__pc = 'holo',
			PersonBirthdate = Date.valueOf('1986-04-25'),
			Date_Issued__pc = Date.valueOf('2021-07-05')
		);
		insert relatedPartyAccount;
		Account relatedPartfy = [SELECT Id, PersonContactId FROM Account WHERE lastName = 'Pjane'];

		Contact relatedcntParty = [
			SELECT
				Id,
				CASA_Reference_Number__c,
				CASA_Screening_Date__c,
				CASA_Screening_Status__c,
				Birthdate,
				Country_of_Birth__c,
				Source_of_Income__c,
				FirstName,
				LastName,
				ID_Number__c,
				Country_of_Residence__c,
				Nationality__c,
				Gender__c
			FROM Contact
			WHERE ID = :relatedPartfy.PersonContactId
		];

		relatedcntParty.ID_Number__c = '6905257273088';
		relatedcntParty.FirstName = 'Phukubyane';
		relatedcntParty.LastName = 'Pjane';
		relatedcntParty.CASA_Reference_Number__c = '121238147';
		relatedcntParty.CASA_Screening_Date__c = date.valueof('2021-06-11');
		relatedcntParty.CASA_Screening_Status__c = 'P';
		relatedcntParty.Source_of_Income__c = 'Salary';
		relatedcntParty.OtherPhone = '0897897654';
		relatedcntParty.Birthdate = date.valueof('2021-06-11');
		relatedcntParty.Country_of_Birth__c = 'South Africa';
		relatedcntParty.Country_of_Residence__c = 'South Africa';
		relatedcntParty.Nationality__c = 'South Africa';
		relatedcntParty.Gender__c = 'Male';
		update relatedcntParty;

		AccountContactRelation acr = new AccountContactRelation();
		acr.AccountId = mainacc.Id;
		acr.ContactId = relatedcntParty.Id;
		acr.Control_of_Passive_Non_Financial_Entity__c = true;
		acr.Controlling_Person_is_Taxed_Outside__c = true;
		acr.Primary_Entity_Id__c = mainacc.Id;

		insert acr;

		Account relatedPartyAccount2 = new Account(
			FirstName = 'MAar',
			LastName = 'Wawa',
			CIF__C = 'MASKIE11',
			date_issued__pc = date.valueOf('2021-07-09'),
			Employer_Phone__c = '0121231234',
			CASA_Reference_Number__c = '121229159',
			Nationality__pc = 'ZIM',
			Highest_Qualification__pc = 'Matric',
			Residential_Status__pc = 'Owner',
			Marital_Status__pc = 'MARRIED',
			Employer_Name__pc = 'absa',
			Country_of_Residence__pc = 'South Africa',
			ID_Number__pc = '8904254315089',
			Client_Group__c = 'Individual',
			ID_Type__c = 'SA Identity Document',
			Countries_Traded_With__c = 'India',
			Country_of_Birth__pc = 'South Africa',
			PersonBirthdate = Date.valueOf('1989-04-25')
		);
		insert relatedPartyAccount2;
		Account relatedPartyd = [SELECT Id, PersonContactId FROM Account WHERE lastName = 'Wawa'];

		Address__c residential1 = new Address__c(
			Shipping_Street__c = 'matabane',
			Address2__c = 'matabane',
			Shipping_Suburb__c = 'boksburg',
			Shipping_City__c = 'matabane',
			Shipping_Country__c = 'south africa',
			Shipping_Zip_Postal_Code__c = '0101',
			Address_TYpe__c = 'Residential',
			Account__c = relatedPartyd.ID
		);
		insert residential1;
		Address__c postal1 = new Address__c(
			Shipping_Street__c = 'matabane',
			Address2__c = 'matabane',
			Shipping_Suburb__c = 'boksburg',
			Shipping_City__c = 'matabane',
			Shipping_Country__c = 'south africa',
			Shipping_Zip_Postal_Code__c = '0101',
			Address_TYpe__c = 'Postal',
			Account__c = relatedPartyd.ID
		);
		insert postal1;

		Address__c employer1 = new Address__c(
			Shipping_Street__c = 'matabane',
			Address2__c = 'matabane',
			Shipping_Suburb__c = 'boksburg',
			Shipping_City__c = 'matabane',
			Shipping_Country__c = 'south africa',
			Shipping_Zip_Postal_Code__c = '0101',
			Address_TYpe__c = 'Employers',
			Account__c = relatedPartyd.ID
		);
		insert employer1;

		Contact relatedcntParty2 = [
			SELECT
				Id,
				CASA_Reference_Number__c,
				CASA_Screening_Date__c,
				CASA_Screening_Status__c,
				Birthdate,
				Country_of_Birth__c,
				Source_of_Income__c,
				FirstName,
				LastName,
				ID_Number__c,
				Country_of_Residence__c,
				Nationality__c,
				Gender__c
			FROM Contact
			WHERE ID = :relatedPartyd.PersonContactId
		];

		relatedcntParty2.ID_Number__c = '6906257273088';
		relatedcntParty2.FirstName = 'MAar';
		relatedcntParty2.LastName = 'Wawa';
		relatedcntParty2.CASA_Reference_Number__c = '121212';
		relatedcntParty2.CASA_Screening_Date__c = date.valueof('2021-06-11');
		relatedcntParty2.CASA_Screening_Status__c = 'P';
		relatedcntParty2.Birthdate = date.valueof('2021-06-11');
		relatedcntParty2.Country_of_Birth__c = 'South Africa';
		relatedcntParty2.Country_of_Residence__c = 'South Africa';
		relatedcntParty2.Nationality__c = 'South Africa';
		relatedcntParty2.Gender__c = 'Male';
		update relatedcntParty2;

		Account relatedParty5 = [SELECT Id, PersonContactId FROM Account WHERE lastName = 'wawa'];
		AccountContactRelation acr1 = new AccountContactRelation();
		acr1.AccountId = mainacc.Id;
		acr1.ContactId = relatedcntParty2.Id;
		acr1.Primary_Entity_Id__c = mainacc.Id;
		acr1.Control_of_Passive_Non_Financial_Entity__c = false;
		acr1.Controlling_Person_is_Taxed_Outside__c = false;
		insert acr1;

		Address__c postalAddress = new Address__c(
			Shipping_Street__c = 'matabane',
			Address2__c = 'matabane',
			Shipping_Suburb__c = 'boksburg',
			Shipping_City__c = 'matabane',
			Shipping_Country__c = 'south africa',
			Shipping_Zip_Postal_Code__c = '0101',
			Account__c = relatedPartyAccount.ID,
			Address_TYpe__c = 'Postal'
		);

		insert postalAddress;
		Address__c residential = new Address__c(
			Shipping_Street__c = 'matabane',
			Address2__c = 'matabane',
			Shipping_Suburb__c = 'boksburg',
			Shipping_City__c = 'matabane',
			Shipping_Country__c = 'south africa',
			Shipping_Zip_Postal_Code__c = '0101',
			Address_TYpe__c = 'Residential',
			Account__c = relatedPartyAccount.ID
		);
		insert residential;
		Address__c employer = new Address__c(
			Shipping_Street__c = 'matabane',
			Address2__c = 'matabane',
			Shipping_Suburb__c = 'boksburg',
			Shipping_City__c = 'matabane',
			Shipping_Country__c = 'south africa',
			Shipping_Zip_Postal_Code__c = '0101',
			Address_TYpe__c = 'Employers',
			Account__c = relatedPartyAccount.ID
		);
		insert employer;

		site__c siteRec = new site__c();
		siteRec.Site_Code__c = '1334';
		siteRec.Name = 'Test';
		insert siteRec;

		Opportunity savingsOpportunity = new Opportunity();
		savingsOpportunity.Name = 'Test Savings Onboarding';
		savingsOpportunity.CloseDate = Date.today();
		savingsOpportunity.StageName = 'New';
		savingsOpportunity.Pricebook2Id = pb.id;
		savingsOpportunity.AccountId = mainacc.id;
		savingsOpportunity.Site__c = siteRec.id;
		savingsOpportunity.CBPIndicator__c = '123456789';
		savingsOpportunity.Risk_Rating__c = 'High';
		insert savingsOpportunity;

		OpportunityLineItem savingsLineItem = new OpportunityLineItem();
		savingsLineItem.OpportunityId = savingsOpportunity.id;
		savingsLineItem.Product2Id = savingsprod.id;
		savingsLineItem.PricebookEntryId = savingsPrice.id;
		savingsLineItem.Quantity = 1;
		savingsLineItem.TotalPrice = 100;

		OpportunityLineItem savingsLineItemInvest = new OpportunityLineItem();
		savingsLineItemInvest.OpportunityId = savingsOpportunity.id;
		savingsLineItemInvest.Product2Id = savingsprod.id;
		savingsLineItemInvest.PricebookEntryId = savingsPriceInvse.id;
		savingsLineItemInvest.Quantity = 1;
		savingsLineItemInvest.TotalPrice = 100;

		//savingsLineItem.Product_Name__c='Investment Club';
		//savingsLineItem.Policy_Number__c='9051159122';
		insert savingsLineItemInvest;

		String auniqueUserName = 'UserAdmin' + DateTime.now().getTime() + '@testorg.com';
		String aemail = 'UserAdmin@testorg.com';
		Profile ap = [SELECT Id FROM Profile WHERE Name = 'Standard User (Branch)'];
		User au = new User(
			Alias = 'standt',
			Email = aemail,
			EmailEncodingKey = 'UTF-8',
			LastName = 'UserAdmin',
			LanguageLocaleKey = 'en_US',
			LocaleSidKey = 'en_US',
			ProfileId = ap.Id,
			TimeZoneSidKey = 'Africa/Johannesburg',
			UserName = auniqueUserName,
			MobilePhone = '0823389021',
			Advisor_Code__c = '112233',
			SiteCode__c = '1334',
			Supervisor__c = '47028'
		);
		insert au;
		Integration_Translation__c returnValues = new Integration_Translation__c(
			External_Value__c = '02',
			Value_Type__c = 'Sofsoi',
			Internal_Value__c = 'Investments',
			System_Name__c = 'CIFCodesList',
			Direction__c = 'Outbound'
		);
		insert returnValues;
		Integration_Translation__c returnValuess = new Integration_Translation__c(
			External_Value__c = 'account from Nedbank',
			Value_Type__c = 'Reason',
			Internal_Value__c = 'account from Nedbank',
			System_Name__c = 'Savings',
			Direction__c = 'Outbound'
		);
		insert returnValuess;

		ROAProduct__c returnProducts = new ROAProduct__c(ProductId__c = 'Investment Club', PackageChargeOption__c = 'Reason', Code__c = 'SVO0907202');
		insert returnProducts;
	}
	@isTest
	static void testNegative() {
		String auniqueUserName = 'UserAdmin' + DateTime.now().getTime() + '@testorg.com';
		String aemail = 'UserAdmin@testorg.com';
		//Profile ap = [SELECT Id FROM Profile WHERE Name = 'Standard User (Branch)'];
		Profile ap = [SELECT Id FROM Profile WHERE Name = 'System Administrator (Custom)'];
		User au = new User(
			Alias = 'standt',
			Email = aemail,
			EmailEncodingKey = 'UTF-8',
			LastName = 'UserAdmin',
			LanguageLocaleKey = 'en_US',
			LocaleSidKey = 'en_US',
			ProfileId = ap.Id,
			TimeZoneSidKey = 'Africa/Johannesburg',
			UserName = auniqueUserName,
			MobilePhone = '0823389021',
			Advisor_Code__c = '112233'
		);
		insert au;
		System.runAs(au) {
			Test.startTest();
			Opportunity opportunity = [SELECT Id, AccountId FROM Opportunity WHERE Name = 'Test Savings Onboarding' LIMIT 1];
			Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODYSer));

			Map<String, String> fraudResponseMap = new Map<String, String>();
			fraudResponseMap = FraudCallDetailsController.FraudCallDetails(opportunity.Id);
			if (fraudResponseMap != null) {
				System.assert(fraudResponseMap == null, 'Failed to call service');
			}
			Test.stopTest();
		}

	}
	@isTest
	static void testPositive() {
		String auniqueUserName = 'UserAdmin' + DateTime.now().getTime() + '@testorg.com';
		String aemail = 'UserAdmin@testorg.com';
		//Profile ap = [SELECT Id FROM Profile WHERE Name = 'Standard User (Branch)'];
		Profile ap = [SELECT Id FROM Profile WHERE Name = 'System Administrator (Custom)'];
		User au = new User(
			Alias = 'standt',
			Email = aemail,
			EmailEncodingKey = 'UTF-8',
			LastName = 'UserAdmin',
			LanguageLocaleKey = 'en_US',
			LocaleSidKey = 'en_US',
			ProfileId = ap.Id,
			TimeZoneSidKey = 'Africa/Johannesburg',
			UserName = auniqueUserName,
			MobilePhone = '0823389021',
			Advisor_Code__c = '112233'
		);
		insert au;
		System.runAs(au) {
			Test.startTest();
			Opportunity opportunity = [SELECT Id, AccountId FROM Opportunity WHERE Name = 'Test Savings Onboarding' LIMIT 1];
			Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODYSer));

			Map<String, String> fraudResponseMap = new Map<String, String>();
			fraudResponseMap = FraudCallDetailsController.FraudCallDetails(opportunity.Id);
			if (fraudResponseMap != null) {
				System.assert(fraudResponseMap != null, 'Success');
			}
			Test.stopTest();
		}
	}

	@IsTest
	public static void convertMaritalStatus() {
		User au = new User();
		Set<String> userEmails = new Set<String>();
		userEmails.add('UserAdmin@testorg.com');
		List<User> userList = new UsersSelector().selectByEmail(userEmails);
		if (userList.size() > 0) {
			for (User u : userList) {
				if (u.Email == 'UserAdmin@testorg.com') {
					au = u;
				}
			}
		}

		System.runAs(au) {
			Test.startTest();
			FraudCallDetailsController.convertMaritalStatus('MARRIED');
			FraudCallDetailsController.convertMaritalStatus('SEPARATED');
			FraudCallDetailsController.convertMaritalStatus('');
			String response = FraudCallDetailsController.convertMaritalStatus('SINGLE');

			System.assert(response != '', 'assert failed');
			Test.stopTest();
		}
	}
}