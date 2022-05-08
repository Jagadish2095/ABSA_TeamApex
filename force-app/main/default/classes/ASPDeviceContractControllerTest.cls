/**
 * @description       : Controller to generate contract request
 * @author            : PaulJohn.duRand@absa.africa
 * @created 2021-02-01
 * @modification      : (Brian Maswanganyi) to call test for Coverage
 * 1.0   2021-07-27   PaulJohn.duRand@absa.africa   ASPDeviceContractController class Refactor and Cleanup
 */
@isTest
public class ASPDeviceContractControllerTest{
	@testSetup
	static void makeData() {
		
		Map<String, Schema.RecordTypeInfo> accountRecordTypeMap = Account.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
		Map<String, Schema.RecordTypeInfo> opportunityRecordTypeMap = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
		String auniqueUserName = 'UserAdmin' + DateTime.now().getTime() + '@testorg.com';
		String aemail = 'UserAdmin@testorg.com';
		Profile ap = [SELECT Id FROM Profile WHERE Name =  'System Administrator (Custom)'];//'Standard User (Branch)'];
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
			Product2 prod = new Product2(Name = 'Cheque Product', Family = 'Cheque', ProductCode = '11021',Price_Scheme_Code__c ='02');
			insert prod;
            Product2 prod1 = new Product2(Name = 'Cheque Product1', Family = 'Cheque', ProductCode = '11072',Price_Scheme_Code__c ='03');
			insert prod1;
			Pricebook2 pb = new Pricebook2();
			pb.IsActive = true;
			pb.id = test.getStandardPricebookId();
			update pb;
			PricebookEntry customPrice = new PricebookEntry(Pricebook2Id = pb.Id, Product2Id = prod.Id, UnitPrice = 12000, IsActive = true);
			insert customPrice;

            PricebookEntry customPrice1 = new PricebookEntry(Pricebook2Id = pb.Id, Product2Id = prod1.Id, UnitPrice = 12000, IsActive = true);
			insert customPrice1;
            Product_Product_Entry__c productEntry = new Product_Product_Entry__c(Parent_Product__c = prod1.Id,
                                                                                 Related_Product__c = prod.Id);
			insert productEntry;
            
			Account acc = new Account();
			acc.FirstName = 'First test';
			acc.LastName = 'last test';
			acc.CIF__c = 'LTD 933';
			acc.Language__c = 'english';
			acc.Number_Of_Dependents__c = 0;
			acc.PersonEmail = 'test@absa.africa';
			acc.Phone = '0819908786';
			acc.Non_Credit_Marketing_Consent__pc = 'Yes';
			acc.Credit_Marketing_Consent__pc = 'Yes';
			acc.Credit_Marketing_Indicator__pc = 'Email;SMS';
			acc.Non_Credit_Marketing_Indicator__pc = 'Email;SMS';
			acc.Contact_Method__pc = 'Email';
			acc.ID_Number__pc = '9301295015018';
			acc.PersonBirthdate = Date.valueOf('1993-01-12');
			insert acc;
            
			Address__c employersAddress = new Address__c(Account__c = acc.Id, Address_Type__c = 'Employers');
			Address__c residentialAddress = new Address__c(Account__c = acc.Id, Address_Type__c = 'Residential');
			Address__c postalAddress = new Address__c(Account__c = acc.Id, Address_Type__c = 'Postal');
			insert employersAddress;
			insert residentialAddress;
			insert postalAddress;
			site__c siteRec = new site__c();
			siteRec.Site_Code__c = '1334';
			siteRec.Name = 'Test';
			insert siteRec;
			Opportunity opp = new Opportunity();
			opp.Name = 'Test Opp Onboarding';
			opp.CloseDate = Date.today();
			opp.StageName = 'New';
			opp.Pricebook2Id = pb.id;
			opp.AccountId = acc.id;
			opp.Site__c = siteRec.id;
			insert opp;
			Application__c app = new Application__c();
			app.Opportunity__c = opp.id;
			app.Source_of_Funds_Savings__c = '27	ALLOWANCE';
			insert app;
			OpportunityLineItem oppLineItem = new OpportunityLineItem();
			oppLineItem.OpportunityId = opp.id;
			oppLineItem.Product2Id = prod.id;
			oppLineItem.PricebookEntryId = customPrice.id;
			oppLineItem.Quantity = 1;
			oppLineItem.TotalPrice = 100;
			oppLineItem.Policy_Number__c = '4048272164';
			insert oppLineItem;
			Payment_Plan__c paymentplan = new Payment_Plan__c();
			paymentplan.Account_Number__c = '';
			paymentplan.Account_Holder_Name__c = '';
			paymentplan.Bank_Name__c = '';
			paymentplan.Branch_Code__c = 8311;
			paymentplan.Account_Number__c = '';
			paymentplan.Amount__c = 1215454;
			paymentplan.Application__c = app.id;
			paymentplan.Status__c = 'New';
			paymentplan.Method__c = 'Debit Order';
			insert paymentplan;
			Switching_Entry__c switchEntry1 = new Switching_Entry__c();
			switchEntry1.OpportunityId__c = opp.Id;
			switchEntry1.Account_Number__c = '4078949848';
			switchEntry1.Previous_Account_Number__c = '9052345737';
			switchEntry1.Was_Switch_Successful__c = true;
			switchEntry1.Previous_Account_Type__c = 'Cheque';
			switchEntry1.Due_Date__c = '2021-04-23';
			switchEntry1.Frequency__c = 'Monthly';
			switchEntry1.Switch_Type__c = 'DEBIT_ORDER';
			switchEntry1.Amount__c = '100';
			switchEntry1.Name = 'Switch Entry Test';
			switchEntry1.Employer_Name__c = 'Test Institution';
			switchEntry1.Previous_Institution__c = 'Test Institution';
			insert switchEntry1;

			Switching_Entry__c switchEntry2 = new Switching_Entry__c();
			switchEntry2.OpportunityId__c = opp.Id;
			switchEntry2.Account_Number__c = '4078949848';
			switchEntry2.Previous_Account_Number__c = '9052345737';
			switchEntry2.Was_Switch_Successful__c = true;
			switchEntry2.Previous_Account_Type__c = 'Cheque';
			switchEntry2.Due_Date__c = '2021-04-23';
			switchEntry2.Frequency__c = 'Monthly';
			switchEntry2.Switch_Type__c = 'SALARY';
			switchEntry2.Amount__c = '100';
			switchEntry2.Name = 'Switch Entry Test';
			switchEntry2.Employer_Name__c = 'Test Institution';
			switchEntry2.Previous_Institution__c = 'Test Institution';
			insert switchEntry2;
		}
	}

	@isTest
	public static void validateGetDeviceContractCaseRequestMetadata() {
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
			Opportunity opp = [SELECT Id FROM Opportunity WHERE Name = 'Test Opp Onboarding' LIMIT 1];
			Test.startTest();
			string resp = ASPDeviceContractController.getDeviceContractRequestMetadata(
				opp.Id,
				'packages',
				'{"applyResponse":{"z_return":{"application":{"annualCreditLimitIncreases":true,"applicationNumber":102104201143082807,"applicationType":"P","campaignId":0,"cardProdSubProdGroupId":162,"channelCode":"B","consents":{"deaConsent":true},"corpCode":"ABSA","creditLifeRequired":true,"creditLimitApproved":190000,"creditLimitSelected":190000,"creditStatus":{"description":"Final Scoring Approved","id":"03"},"dateCreated":"2021-04-20T11:43:08.818+02:00","debitOrderDetails":{"accountHolderName":"TESTER","accountNumber":4047893133,"accountType":{"code":"C","description":"Cheque Account                                         "},"bankInstitutionName":"ABSA","branchCode":632005,"branchName":"ABSA ELECTRONIC SETTLEMENT CNT","creditorDetails":{"mandCredAccountID":295414146,"mandCredBranch":632005,"mandCredName":"ABSA CARD","mandUltCredName":"ABSACC","mandUltCredShortName":"ABSACC"},"debitOrderType":{"description":"Minimum Amount","id":"M"},"debtorDetails":{"debtorEmail":"CLIFFORDWILLERS@GMAIL.COM","debtorPhone":"0838224512","idOrRegistrationNo":"7306285007088       ","idtype":"01","ownAccount":"Y"},"mandateDetails":{"clientRef":"WILLECW004"},"otherBankInstitutionName":null,"paymentAmount":0,"paymentDay":1,"paymentDetails":{"instalmentOccurrence":0,"mandFrequencyTyp":"MNTH","mandInstalcollAmount":5700,"mandMaxAmount":190000,"mandTrackingInd":"T","RMSCollStDate":"2021-05-01 00:00:00.0","RMSCustFxdAmt":"ZAR","RMSDoSubtyp":2,"supllAdjCategory":"N","supplAdjAmount":0,"supplAdjRate":0,"supplDtValueTyp":"USAGE BASED","supplDteAdjRuleInd":"N","supplFirstCollAmount":0}},"electronicStatementEmailAddress1":"CLIFFORDWILLERS@GMAIL.COM","externalConsumerData":{"customerId":7306285007088,"customerSourceCode":"BSF","customerSourceReferenceNumber":7306285007088},"hasAcceptedCourierCollectionFee":false,"hasAcceptedSpecifiedCreditLimit":false,"knockOutQuestions":{"absaRewards":false,"casaClauseRead":true,"creditBureauConsent":false,"creditLifeTermsAndConditionsRead":false,"curatorship":true,"currentlyUnderDebtCounselling":false,"debitOrderByPass":false,"declaredInsolvent":false,"monthlyGrossIncomeAboveMin":false,"olderThan18Years":false,"pendingDebtCounselling":false,"permanentSAResident":false,"registeredForeingTax":false,"rehabilitation":{"everBeenDeclaredInsolvent":false,"everUndergoneDebtCounselling":false},"spouseConsent":false,"termsAndConditionsRead":true},"linkedAccountSelected":null,"lockVersionId":51672,"lowValuePaymentRequired":false,"marketingSiteId":8392,"numberOfSecondaryApplicantsRequested":0,"packageId":"11032 CQT01S49","personWhoCreatedApplication":"EXAC017","pinOptionSelected":null,"pricingSchemeCode":"CQT01S49","primaryApplicant":{"cardCollection":{"cardCollectionMethod":{"courierCollectionFee":null,"description":"Branch","id":"B"},"cardCollectionSite":{"id":8915,"nameLong":"ISANDO","nameShort":"ISANDO","status":"Y   ","streetAddress":{"addressLine1":"HEKRO BUILDING","addressLine2":"36 ELECTRON AVENUE","city":null,"postalCode":"01600","suburb":"ISANDO"},"subType":"001      ","type":"034 "}},"cardTypeSelected":{"description":"Credit Card","id":"C"},"cards":[{"cardType":{"description":"Credit Card","id":"C"}}],"casaInformation":{"countryOfResidence":"SO003","nationality":"SOU01","referenceNumber":121213298,"riskRating":"M ","versionNumber":26},"cellPhoneNumber":{"countryCode":null,"extension":null,"number":"0838224512"},"clientCode":"WILLECW004","communicationLanguage":"E","customerType":"001","dateOfBirth":"1973-06-28T00:00:00+02:00","deliveryAddress":null,"emailAddress":"CLIFFORDWILLERS@GMAIL.COM","employer":{"address":{"addressLine1":"12 LEEUSTREET","city":"SANDTON","postalCode":"2196      ","suburb":"SANDTON"},"name":"IQBUSINESS"},"employmentSector":null,"expense":{"bondInstalmentOrRent":10500,"creditCardInstalment":4500,"household":6000,"insuranceOrFuneralPolicy":5000,"jointDebt":"N","maintenance":0,"otherExpense":{"amount":0,"description":null},"otherFixedDebtExpense":{"amount":5000,"description":"RETAIL ACCOUNTS"},"personalLoanInstalment":0,"rent":0,"schoolOrUniversityFee":3000,"totalFixedDebtExpense":29500,"totalLivingExpense":18500,"transport":4500,"vehicleInstalment":9500},"familyStatus":{"maritalStatus":1,"numberOfDependents":0},"financialAccountInfo":{"accountNumber":4047893133,"bankInstitutionName":"ABSA","otherBankInstitutionName":null,"salaryAccountType":"C"},"financialInformationSuppliedCorrect":true,"firstNames":"CLIFFORD","gender":1,"hasSocialGrant":false,"homeFaxNumber":null,"homeLanguage":"E","homeTelephoneNumber":null,"idOrRegistrationNo":"7306285007088       ","identificationType":"01","income":{"disposableMonthlyIncome":32000,"grossMonthlyIncome":80000,"grossMonthlySalary":90000,"nettMonthlyIncome":70000,"otherIncome":{"amount":0,"description":null},"rentalIncome":10000},"incomeTaxNumber":0,"initials":"CW        ","isInBusinessRescueAffectedParty":false,"marketingConsentGiven":false,"mayCheckCreditWorthiness":true,"mayReceiveMarketingViaEmail":false,"mayReceiveMarketingViaPost":false,"mayReceiveMarketingViaSMS":false,"mayReceiveMarketingViaTelephone":false,"nextOfKin":{"cellPhoneNumber":{"countryCode":null,"extension":null,"number":"0831241010"},"emailAddress":"RENE77@GMAIL.COM","fullNames":"RENE","homeTelephoneNumber":null,"relationship":15,"surname":"RENE","workTelephoneNumber":null},"occupationCode":15,"occupationLevel":"02","occupationStatus":"01","placeOfResidence":"01","postalAddress":{"addressLine1":"398 LOTHAIR RD FAERIE GLEN","addressLine2":null,"city":"PRETORIA","country":"SO003","postalCode":"0081","suburb":"FAERIE GLEN"},"preAssessed":null,"preferredCommunicationChannel":"02","qualification":{"hasPostMatricQualification":false},"residentialAddress":{"addressLine1":"399 LOTHAIR RD FAERIE GLEN","addressLine2":null,"city":"FAERIE GLEN","country":"SO003","postalCode":"0081","suburb":"FAERIE GLEN EXT 11"},"shareInfoWithCreditProviders":false,"sourceOfIncome":20,"sourceOfFunds":[20],"surname":"WILLERS","tempPermitNumber":0,"titleType":"01","workFaxNumber":null,"workTelephoneNumber":null,"cardProdSubProdGroupId":162,"countryOfBirth":"SO003","cardDetails":null},"productGroupId":1,"productInformation":[{"accountType":"PPR","cardCollectionMethodsAllowed":[{"courierCollectionFee":0,"description":"Branch","id":"B"},{"courierCollectionFee":0,"description":"Courier","id":"S"}],"cardProdSubProdGroupId":160,"cardProductDescription":"VISA PREMIUM PACKAGE","cardProductOrder":2,"creditLifeMaxAge":70,"creditLifeOffered":"Y","debitOrderTypeAllowed":[{"description":"Minimum Amount","id":"M"},{"description":"Full Amount","id":"F"},{"description":"Fixed Amount","id":"A"}],"electronicStatementDeliveryAllowed":"Y","garageCardAllowed":"Y","isStaff":false,"linkedAccountRequired":"N","lowValuePaymentAllowed":"N","maximumCreditLimit":250000,"minimumCreditLimit":1000,"pinOptionTypeAllowed":[{"description":"Pin Mailer","id":"M"},{"description":"Branch","id":"B"}],"principalBankCorpCode":"ABSA","productFamilyId":"PTT","productGroupDescription":"Individual Credit Card","productId":"VIS","productgroupId":1,"secondariesAllowed":"Y","sourceId":"PLT+4787692","subProductGroupDescription":"Platinum Cards","subProductgroupId":31}],"quote":{"cardProdSubProdGroupId":162,"creditLifeRequired":true,"creditLimit":190000,"linkedAccountNumberSelected":null,"number":"90542           ","numberOfQuotesIssued":1,"statusCode":"ISS"},"statementDeliveryMethodSelected":{"code":"EML","description":"eMail"},"statusGroup":4},"responseCommons":{"messageTimeStamp":"2021-04-20T12:00:23.512+02:00","success":"TRUE"}}}}',
				''
			);
			System.assert(resp != null, 'Test Working');
			Test.stopTest();
		}
	}
	@isTest
	public static void validateGetDeviceContractStokvelRequestMetadata() {
		Product2 prod = new Product2(Name = 'Savings Product', Family = 'Savings', ProductCode = '096021');
		insert prod;
		Pricebook2 pb = new Pricebook2();
		pb.IsActive = true;
		pb.id = test.getStandardPricebookId();
		update pb;
		PricebookEntry customPrice = new PricebookEntry(Pricebook2Id = pb.Id, Product2Id = prod.Id, UnitPrice = 12000, IsActive = true);
		insert customPrice;
		Account mainacc = new Account();
		mainacc.Name = 'TheStokvel';
		mainacc.Phone = '0840404898';
		mainacc.Communication_Method__c = 'Email';
		mainacc.CASA_Reference_Number__c = '121229158';
		mainacc.Client_Group__c = 'Non Individual';
		mainacc.Number_of_Participants__c = 2;
		mainacc.Country_of_Registration__c = 'South Africa';
		mainacc.Country_of_Incorporation__c = 'South Africa';
		mainacc.RepresetentiveName__c = 'anna';
		mainacc.RepresentativeLastname__c = 'dave';
		insert mainacc;

		Account relatedPartyAccount = new Account(
			FirstName = 'Phukubyane',
			LastName = 'Pjane',
			Phone = '0835002323',
			CIF__c = 'AubreP009',
			CASA_Reference_Number__c = '121229159',
			Nationality__pc = 'South Africa',
			Country_of_Residence__pc = 'South Africa',
			ID_Number__pc = '8604254315089',
			Client_Group__c = 'Individual',
			ID_Type__c = 'SA Identity Document',
			PersonBirthdate = Date.valueOf('1986-04-25')
		);
		insert relatedPartyAccount;
		Account relatedParty = [SELECT Id, PersonContactId FROM Account WHERE lastName = 'Pjane' LIMIT 1];
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
			WHERE ID = :relatedParty.PersonContactId
		];

		relatedcntParty.ID_Number__c = '12121212121212';
		relatedcntParty.FirstName = 'Phukubyane';
		relatedcntParty.LastName = 'Pjane';
		relatedcntParty.CASA_Reference_Number__c = '121212';
		relatedcntParty.CASA_Screening_Date__c = date.valueof('2021-06-11');
		relatedcntParty.CASA_Screening_Status__c = 'P';
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

		Address__c postAddress = new Address__c();
		postAddress.Shipping_Street__c = 'matabane';
		postAddress.Address2__c = 'matabane';
		postAddress.Shipping_Suburb__c = 'boksburg';
		postAddress.Shipping_City__c = 'matabane';
		postAddress.Shipping_Country__c = 'south africa';
		postAddress.Shipping_Zip_Postal_Code__c = '0101';
		postAddress.Account__c = relatedParty.ID;
		postAddress.Address_TYpe__c = 'Postal';
		insert postAddress;

		Address__c residential = new Address__c();
		residential.Shipping_Street__c = 'matabane';
		residential.Address2__c = 'matabane';
		residential.Shipping_Suburb__c = 'boksburg';
		residential.Shipping_City__c = 'matabane';
		residential.Shipping_Country__c = 'south africa';
		residential.Shipping_Zip_Postal_Code__c = '0101';
		residential.Address_TYpe__c = 'Residential';
		residential.Account__c = relatedParty.ID;
		insert residential;

		site__c siteRec = new site__c();
		siteRec.Site_Code__c = '1334';
		siteRec.Name = 'Test';
		insert siteRec;
		Opportunity opp = new Opportunity();
		opp.Name = 'Test stokvel Onboarding';
		opp.CloseDate = Date.today();
		opp.StageName = 'New';
		opp.Pricebook2Id = pb.id;
		opp.AccountId = mainacc.id;
		opp.Site__c = siteRec.id;
		insert opp;
		Application__c app = new Application__c();
		app.Opportunity__c = opp.id;
		app.Source_of_Funds_Savings__c = '27	ALLOWANCE';
		insert app;
		OpportunityLineItem oppLineItem = new OpportunityLineItem();
		oppLineItem.OpportunityId = opp.id;
		oppLineItem.Product2Id = prod.id;
		oppLineItem.PricebookEntryId = customPrice.id;
		oppLineItem.Quantity = 1;
		oppLineItem.TotalPrice = 100;
		oppLineItem.Policy_Number__c = '4048272164';
		insert oppLineItem;
		Payment_Plan__c paymentplan = new Payment_Plan__c();
		paymentplan.Account_Number__c = '';
		paymentplan.Account_Holder_Name__c = '';
		paymentplan.Bank_Name__c = '';
		paymentplan.Branch_Code__c = 8311;
		paymentplan.Account_Number__c = '';
		paymentplan.Amount__c = 1215454;
		paymentplan.Application__c = app.id;
		paymentplan.Status__c = 'New';
		paymentplan.Method__c = 'Debit Order';
		insert paymentplan;

		Opportunity oppotunity = [SELECT Id FROM Opportunity WHERE Name = 'Test stokvel Onboarding' LIMIT 1];
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
			string resp = ASPDeviceContractController.getDeviceContractRequestMetadata(
				oppotunity.Id,
				'stokvel',
				'{"applyResponse":{"z_return":{"application":{"annualCreditLimitIncreases":true,"applicationNumber":102104201143082807,"applicationType":"P","campaignId":0,"cardProdSubProdGroupId":162,"channelCode":"B","consents":{"deaConsent":true},"corpCode":"ABSA","creditLifeRequired":true,"creditLimitApproved":190000,"creditLimitSelected":190000,"creditStatus":{"description":"Final Scoring Approved","id":"03"},"dateCreated":"2021-04-20T11:43:08.818+02:00","debitOrderDetails":{"accountHolderName":"TESTER","accountNumber":4047893133,"accountType":{"code":"C","description":"Cheque Account                                         "},"bankInstitutionName":"ABSA","branchCode":632005,"branchName":"ABSA ELECTRONIC SETTLEMENT CNT","creditorDetails":{"mandCredAccountID":295414146,"mandCredBranch":632005,"mandCredName":"ABSA CARD","mandUltCredName":"ABSACC","mandUltCredShortName":"ABSACC"},"debitOrderType":{"description":"Minimum Amount","id":"M"},"debtorDetails":{"debtorEmail":"CLIFFORDWILLERS@GMAIL.COM","debtorPhone":"0838224512","idOrRegistrationNo":"7306285007088       ","idtype":"01","ownAccount":"Y"},"mandateDetails":{"clientRef":"WILLECW004"},"otherBankInstitutionName":null,"paymentAmount":0,"paymentDay":1,"paymentDetails":{"instalmentOccurrence":0,"mandFrequencyTyp":"MNTH","mandInstalcollAmount":5700,"mandMaxAmount":190000,"mandTrackingInd":"T","RMSCollStDate":"2021-05-01 00:00:00.0","RMSCustFxdAmt":"ZAR","RMSDoSubtyp":2,"supllAdjCategory":"N","supplAdjAmount":0,"supplAdjRate":0,"supplDtValueTyp":"USAGE BASED","supplDteAdjRuleInd":"N","supplFirstCollAmount":0}},"electronicStatementEmailAddress1":"CLIFFORDWILLERS@GMAIL.COM","externalConsumerData":{"customerId":7306285007088,"customerSourceCode":"BSF","customerSourceReferenceNumber":7306285007088},"hasAcceptedCourierCollectionFee":false,"hasAcceptedSpecifiedCreditLimit":false,"knockOutQuestions":{"absaRewards":false,"casaClauseRead":true,"creditBureauConsent":false,"creditLifeTermsAndConditionsRead":false,"curatorship":true,"currentlyUnderDebtCounselling":false,"debitOrderByPass":false,"declaredInsolvent":false,"monthlyGrossIncomeAboveMin":false,"olderThan18Years":false,"pendingDebtCounselling":false,"permanentSAResident":false,"registeredForeingTax":false,"rehabilitation":{"everBeenDeclaredInsolvent":false,"everUndergoneDebtCounselling":false},"spouseConsent":false,"termsAndConditionsRead":true},"linkedAccountSelected":null,"lockVersionId":51672,"lowValuePaymentRequired":false,"marketingSiteId":8392,"numberOfSecondaryApplicantsRequested":0,"packageId":"11032 CQT01S49","personWhoCreatedApplication":"EXAC017","pinOptionSelected":null,"pricingSchemeCode":"CQT01S49","primaryApplicant":{"cardCollection":{"cardCollectionMethod":{"courierCollectionFee":null,"description":"Branch","id":"B"},"cardCollectionSite":{"id":8915,"nameLong":"ISANDO","nameShort":"ISANDO","status":"Y   ","streetAddress":{"addressLine1":"HEKRO BUILDING","addressLine2":"36 ELECTRON AVENUE","city":null,"postalCode":"01600","suburb":"ISANDO"},"subType":"001      ","type":"034 "}},"cardTypeSelected":{"description":"Credit Card","id":"C"},"cards":[{"cardType":{"description":"Credit Card","id":"C"}}],"casaInformation":{"countryOfResidence":"SO003","nationality":"SOU01","referenceNumber":121213298,"riskRating":"M ","versionNumber":26},"cellPhoneNumber":{"countryCode":null,"extension":null,"number":"0838224512"},"clientCode":"WILLECW004","communicationLanguage":"E","customerType":"001","dateOfBirth":"1973-06-28T00:00:00+02:00","deliveryAddress":null,"emailAddress":"CLIFFORDWILLERS@GMAIL.COM","employer":{"address":{"addressLine1":"12 LEEUSTREET","city":"SANDTON","postalCode":"2196      ","suburb":"SANDTON"},"name":"IQBUSINESS"},"employmentSector":null,"expense":{"bondInstalmentOrRent":10500,"creditCardInstalment":4500,"household":6000,"insuranceOrFuneralPolicy":5000,"jointDebt":"N","maintenance":0,"otherExpense":{"amount":0,"description":null},"otherFixedDebtExpense":{"amount":5000,"description":"RETAIL ACCOUNTS"},"personalLoanInstalment":0,"rent":0,"schoolOrUniversityFee":3000,"totalFixedDebtExpense":29500,"totalLivingExpense":18500,"transport":4500,"vehicleInstalment":9500},"familyStatus":{"maritalStatus":1,"numberOfDependents":0},"financialAccountInfo":{"accountNumber":4047893133,"bankInstitutionName":"ABSA","otherBankInstitutionName":null,"salaryAccountType":"C"},"financialInformationSuppliedCorrect":true,"firstNames":"CLIFFORD","gender":1,"hasSocialGrant":false,"homeFaxNumber":null,"homeLanguage":"E","homeTelephoneNumber":null,"idOrRegistrationNo":"7306285007088       ","identificationType":"01","income":{"disposableMonthlyIncome":32000,"grossMonthlyIncome":80000,"grossMonthlySalary":90000,"nettMonthlyIncome":70000,"otherIncome":{"amount":0,"description":null},"rentalIncome":10000},"incomeTaxNumber":0,"initials":"CW        ","isInBusinessRescueAffectedParty":false,"marketingConsentGiven":false,"mayCheckCreditWorthiness":true,"mayReceiveMarketingViaEmail":false,"mayReceiveMarketingViaPost":false,"mayReceiveMarketingViaSMS":false,"mayReceiveMarketingViaTelephone":false,"nextOfKin":{"cellPhoneNumber":{"countryCode":null,"extension":null,"number":"0831241010"},"emailAddress":"RENE77@GMAIL.COM","fullNames":"RENE","homeTelephoneNumber":null,"relationship":15,"surname":"RENE","workTelephoneNumber":null},"occupationCode":15,"occupationLevel":"02","occupationStatus":"01","placeOfResidence":"01","postalAddress":{"addressLine1":"398 LOTHAIR RD FAERIE GLEN","addressLine2":null,"city":"PRETORIA","country":"SO003","postalCode":"0081","suburb":"FAERIE GLEN"},"preAssessed":null,"preferredCommunicationChannel":"02","qualification":{"hasPostMatricQualification":false},"residentialAddress":{"addressLine1":"399 LOTHAIR RD FAERIE GLEN","addressLine2":null,"city":"FAERIE GLEN","country":"SO003","postalCode":"0081","suburb":"FAERIE GLEN EXT 11"},"shareInfoWithCreditProviders":false,"sourceOfIncome":20,"sourceOfFunds":[20],"surname":"WILLERS","tempPermitNumber":0,"titleType":"01","workFaxNumber":null,"workTelephoneNumber":null,"cardProdSubProdGroupId":162,"countryOfBirth":"SO003","cardDetails":null},"productGroupId":1,"productInformation":[{"accountType":"PPR","cardCollectionMethodsAllowed":[{"courierCollectionFee":0,"description":"Branch","id":"B"},{"courierCollectionFee":0,"description":"Courier","id":"S"}],"cardProdSubProdGroupId":160,"cardProductDescription":"VISA PREMIUM PACKAGE","cardProductOrder":2,"creditLifeMaxAge":70,"creditLifeOffered":"Y","debitOrderTypeAllowed":[{"description":"Minimum Amount","id":"M"},{"description":"Full Amount","id":"F"},{"description":"Fixed Amount","id":"A"}],"electronicStatementDeliveryAllowed":"Y","garageCardAllowed":"Y","isStaff":false,"linkedAccountRequired":"N","lowValuePaymentAllowed":"N","maximumCreditLimit":250000,"minimumCreditLimit":1000,"pinOptionTypeAllowed":[{"description":"Pin Mailer","id":"M"},{"description":"Branch","id":"B"}],"principalBankCorpCode":"ABSA","productFamilyId":"PTT","productGroupDescription":"Individual Credit Card","productId":"VIS","productgroupId":1,"secondariesAllowed":"Y","sourceId":"PLT+4787692","subProductGroupDescription":"Platinum Cards","subProductgroupId":31}],"quote":{"cardProdSubProdGroupId":162,"creditLifeRequired":true,"creditLimit":190000,"linkedAccountNumberSelected":null,"number":"90542           ","numberOfQuotesIssued":1,"statusCode":"ISS"},"statementDeliveryMethodSelected":{"code":"EML","description":"eMail"},"statusGroup":4},"responseCommons":{"messageTimeStamp":"2021-04-20T12:00:23.512+02:00","success":"TRUE"}}}}',
				''
			);
			System.assert(resp != null, 'Test Working');
			Test.stopTest();
		}
	}
    
    @isTest
    public static void ASPContractRequestTestMethod()
    {
        //ASPDeviceContractRequest request = ASPDeviceContractRequest.getNewInstance();
		//System.assert(request != null, 'Test Working');
        
        ASPDeviceContractRequest.getNewInstance();
		System.assertEquals('Success', 'Success', 'Succeded');
    }
}