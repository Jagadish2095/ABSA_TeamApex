/**
 * @description FraudService_IH_v1_test
 */
@istest
public class FraudService_IH_v1_test {
	public static final String POSITIVE_RESPONSE_BODY = '{"applicationDateTime": "2020-07-12T08:30:09+10:00","header": {"channel": {             "channelDetails": [                 {                     "fieldName": "SITE_CODE",                     "value": "9082"                 },                 {                     "fieldName": "USER_ID",                     "value": "123456"                 },                 {                     "fieldName": "USER_TYPE",                     "value": "Employee"                 },                 {                     "fieldName": "BRANCH_NAME",                     "value": "cresta"                 },                 {                     "fieldName": "IP_ADDRESS",                     "value": "190.90.92"                 },                 {                     "fieldName": "TERMINAL_ID",                     "value": "23456"                 },                 {                     "fieldName": "OS",                     "value": "android"                 }             ],             "channelType": "BRANCH",             "channelName": "DSP"         },         "channelReference": "0986532222"     },     "productDetails": {         "campaignReference": 98765,         "limitAmount": 0,         "productSubType": "Cheque",         "productType": "SAVINGS"     },     "customerDetails": [         {             "addressDetails": [                 {                     "addressDateSince": 8,                     "addressType": "HOME_ADDRESS",                     "buildingName": "Absa building",                     "postalCode": 2194,                     "streetName": "Republic road",                     "streetNumber": 270,                     "suburbOrTown": "Randburg"                 }             ],             "creditDetails": {                 "grossIncome": 0,                 "totalExpenses": 0             },             "customerIndicator": "PRIMARY",             "customerType": "NEW_TO_BANK",             "dateOfBirth": "1994-03-25",             "employmentDetails": {                 "companyName": "Absa",                 "employmentSector": "Information and communication technology",                 "occupationLevel": "Manager",                 "occupationStatus": "Full Time Employed",                 "companyPhoneNumber": "string",                 "companyEmailAddress": "string",                 "occupationalStatusCode": 0             },             "firstName": "Cynthia",             "gender": "MALE",             "identity": {                 "idNumber": 9403250985081,                 "idType": "PASSPORT",                 "passportNationality": "ZIM"             },             "language": "english",             "lastName": "string",             "maritalStatus": "MARRIED",             "noOfDependants": 0,             "qualification": "Matric",             "residentialStatus": "Renter",             "tempPermitNo": "string",             "contactDetails": [                 {                     "contactDetailsType": "EMAIL_ADDRESS",                     "preferenceOrder": 0,                     "contactDetailsDescription": "PERSONAL_EMAIL",                     "correspondence": "test@absa.africa"                 },                 {                     "contactDetailsType": "PHONE_NUMBER",                     "preferenceOrder": 0,                     "contactDetailsDescription": "MOBILE_NUMBER",                     "correspondence": "0819908786"                 },                 {                     "contactDetailsType": "PHONE_NUMBER",                     "preferenceOrder": 0,                     "contactDetailsDescription": "HOME_PHONE",                     "correspondence": "0838491324"                 }             ]         }     ] }';
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
	static void testFraudPositive() {
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

			Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODYSer));
			FraudService_Req_IB_v1 requestBean = new FraudService_Req_IB_v1();
			DateTime dt = Datetime.now();
			string tempDate = dt.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss.SSSXXX');

			tempDate = tempDate.removeEnd('Z');

			requestBean.applicationDateTime = tempDate;
			requestBean.header = new FraudService_Req_IB_v1.Header();
			requestBean.header.channelReference = '0986532222';
			requestBean.header.channel = new FraudService_Req_IB_v1.Channel();
			requestBean.header.channel.channelDetails = new List<FraudService_Req_IB_v1.ChannelDetails>();
			FraudService_Req_IB_v1.ChannelDetails a = new FraudService_Req_IB_v1.ChannelDetails();
			a.fieldName = 'SITE_CODE';
			a.value = 'MOLO';
			requestBean.header.channel.channelDetails.add(a);
			FraudService_Req_IB_v1.ChannelDetails b = new FraudService_Req_IB_v1.ChannelDetails();
			b.fieldName = 'USER_ID';
			b.value = '1234';
			requestBean.header.channel.channelDetails.add(b);
			FraudService_Req_IB_v1.ChannelDetails c = new FraudService_Req_IB_v1.ChannelDetails();
			c.fieldName = 'USER_TYPE';
			c.value = 'Employee';
			requestBean.header.channel.channelDetails.add(c);
			FraudService_Req_IB_v1.ChannelDetails d = new FraudService_Req_IB_v1.ChannelDetails();
			d.fieldName = 'BRANCH_NAME';
			d.value = 'BRANCH';
			requestBean.header.channel.channelDetails.add(d);

			requestBean.header.channel.channelType = 'BRANCH';
			requestBean.header.channel.channelName = 'SalesForce';

			requestBean.productDetails = new FraudService_Req_IB_v1.ProductDetails();
			requestBean.productDetails.campaignReference = 0;
			requestBean.productDetails.limitAmount = 0;
			requestBean.productDetails.productSubType = 'SAVINGS';
			requestBean.productDetails.productType = 'SAVINGS';

			requestBean.customerDetails = new List<FraudService_Req_IB_v1.CustomerDetails>();

			FraudService_Req_IB_v1.CustomerDetails customerDetail = new FraudService_Req_IB_v1.CustomerDetails();
			customerDetail.addressDetails = new List<FraudService_Req_IB_v1.AddressDetails>();

			FraudService_Req_IB_v1.AddressDetails addressDetail = new FraudService_Req_IB_v1.AddressDetails();
			addressDetail.addressDateSince = 0;
			addressDetail.addressType = 'HOME_ADDRESS';
			addressDetail.buildingName = '';
			addressDetail.postalCode = 4000;

			addressDetail.streetName = 'TSHWANE';
			addressDetail.streetNumber = 0;
			addressDetail.suburbOrTown = 'TSHWANE';

			customerDetail.addressDetails.add(addressDetail);

			customerDetail.creditDetails = new FraudService_Req_IB_v1.CreditDetails();
			customerDetail.creditDetails.grossIncome = 0;
			customerDetail.creditDetails.totalExpenses = 0;

			customerDetail.customerIndicator = 'PRIMARY';
			customerDetail.customerType = 'NEW_TO_BANK';
			customerDetail.dateOfBirth = '1992';

			customerDetail.employmentDetails = new FraudService_Req_IB_v1.EmploymentDetails();
			customerDetail.employmentDetails.companyName = 'MBOLO';
			customerDetail.employmentDetails.employmentSector = 'VOZA';
			customerDetail.employmentDetails.occupationLevel = 'JUNIOR';
			customerDetail.employmentDetails.occupationStatus = 'FARM';
			customerDetail.employmentDetails.companyPhoneNumber = '0123453455';
			customerDetail.employmentDetails.companyEmailAddress = '';
			customerDetail.employmentDetails.occupationalStatusCode = 0;

			customerDetail.firstName = 'MPHO';
			customerDetail.gender = 'FEMALE';
			customerDetail.identity = new FraudService_Req_IB_v1.Identity();
			customerDetail.identity.idNumber = Long.valueOf('9212030865091');
			customerDetail.identity.idType = 'ID_NUMBER';
			customerDetail.identity.passportNationality = 'SOUTH AFRICA';

			customerDetail.lastName = 'REMO';
			customerDetail.language = 'ENGLISH';

			customerDetail.maritalStatus = 'MARRIED';
			customerDetail.noOfDependants = 2;
			customerDetail.qualification = '';
			customerDetail.residentialStatus = 'Owner'; //acc.Residential_Status__pc;
			customerDetail.tempPermitNo = '';

			customerDetail.contactDetails = new List<FraudService_Req_IB_v1.ContactDetails>();
			FraudService_Req_IB_v1.ContactDetails emailContactDetail = new FraudService_Req_IB_v1.ContactDetails();

			emailContactDetail.contactDetailsType = 'EMAIL_ADDRESS';
			emailContactDetail.preferenceOrder = 0;
			emailContactDetail.contactDetailsDescription = 'PERSONAL_EMAIL';
			emailContactDetail.correspondence = 'noemail@noemail.co.za';
			customerDetail.contactDetails.add(emailContactDetail);

			FraudService_Req_IB_v1.ContactDetails mobileContactDetail = new FraudService_Req_IB_v1.ContactDetails();

			mobileContactDetail.contactDetailsType = 'PHONE_NUMBER';
			mobileContactDetail.preferenceOrder = 0;
			mobileContactDetail.contactDetailsDescription = 'MOBILE_NUMBER';
			mobileContactDetail.correspondence = '0000000000';
			customerDetail.contactDetails.add(mobileContactDetail);
			requestBean.customerDetails.add(customerDetail);

			FraudService_Resp_IB_v1 response = FraudService_IH_v1.FraudService(requestBean);
			System.assert(response != null, 'Success');

			Test.stopTest();
		}
	}
}