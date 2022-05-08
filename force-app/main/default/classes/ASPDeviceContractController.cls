/**
 * @description       : Controller to generate contract request
 * @author            : PaulJohn.duRand@absa.africa
 * @created 2021-02-01
 * Modifications Log
 * Ver   Date         Author                        Modification
 * 1.0   2021-06-22   PaulJohn.duRand@absa.africa   Changed Gross income to CFTS grossMonthlySalary
 * 1.0   2021-07-01   Arrie.Castelyn@absa.africa    Added Residential and Postal Street 2
 * 1.0   2021-07-27   PaulJohn.duRand@absa.africa   ASPDeviceContractController class Refactor and Cleanup
 * 1.0   2021-08-16   PaulJohn.duRand@absa.africa   Added CreditworthinessConsent and isBusinessProspect from BranchFunctions
 */

public without sharing class ASPDeviceContractController {
	public static final String ChequeProductFamily = 'Cheque';
	public static final String SavingsProductFamily = 'Savings';
	public static ASPDeviceContractRequest aspContractRequest;
    public static string contractTypeStk='';
    public static string contractDataStk='';
	/**
	 * @description Function used to create Contract request
	 * @param opportunityID
	 * @param contractType
	 * @param contractData
	 * @param featureAndBenefitProduct
	 * @return string
	 */
	@AuraEnabled
	public static String getDeviceContractRequestMetadata(string opportunityID, string contractType, string contractData, string featureAndBenefitProduct) {
		List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(opportunityID);
		List<OpportunityLineItem> oppProducts = new OpportunityLineItemsSelector().selectByOpportunityId(opportunityID);
		Account accountRecord = new AccountsSelector().selectAllById(opportunities.get(0).AccountId);
		List<Application__c> applicationDetailList = new ApplicationsSelector().selectByOpportunityId(opportunityID);
		Application__c application;
		aspContractRequest = ASPDeviceContractRequest.getNewInstance();
		if (applicationDetailList.size() > 0) {
			application = applicationDetailList.get(0);
			ASPDeviceContractController.populateVasData(application);
		}
		contractTypeStk=contractType;
        contractDataStk=contractData;
		ASPDeviceContractController.populateDefaultValues();
		ASPDeviceContractController.populateUserData(accountRecord);
		ASPDeviceContractController.populateGenericData(opportunityID,accountRecord);
		String AccountNumber = ASPDeviceContractController.populateAccountNumber(oppProducts);		
		ASPDeviceContractController.populateSwitchingData(opportunityID, AccountNumber);
		ASPDeviceContractController.populateFeaturesAndBenefitProduct(opportunityID, featureAndBenefitProduct);
		//ASPDeviceContractController.populateWimiProducts(opportunityID, accountRecord);
		for (ASPDeviceContractRequest.contractTypes st : ASPDeviceContractRequest.contractTypes.values()) {
			if (st.name() == contractType.toUpperCase()) {
				aspContractRequest.contractTypes = st;
				break;
			}
		}
		switch on aspContractRequest.contractTypes {
			when PACKAGES, CREDITCARD {
				ASPDeviceContractController.populateCreditCardSpecificData(contractData, application.id);
			}
            when STOKVEL {
				ASPDeviceContractController.PopulateProductParentCode(aspContractRequest.productType);
			}
		}
		String requestJson = JSON.serialize(aspContractRequest);
		return requestJson;
	}

	/**
	 * @description Function used to get PopulatePaymentPlanData
	 * @param applicationid
	 */
	public static void populatePaymentPlanData(id applicationid) {
		Payment_Plan__c paymentplan = [
			SELECT
				Application__c,
				Account_Number__c,
				Account_Holder_Name__c,
				Branch_Code__c,
				Debit_authentication_Type__c,
				Account_Type__c,
				Bank_Name__c,
				Creditor_Short_Name__c,
				Collection_Start_Date__c,
				Frequency__c,
				Collection_Day__c,
				Adjustable_Debit_Date__c,
				Amount__c,
				Debit_Value_Type__c,
				Branch_Name__c,
				Reference__c,
				Debit_Order_Commencement_Date__c
			FROM Payment_Plan__c
			WHERE Application__c = :applicationid
		];
		aspContractRequest.debitedAcc = paymentplan.Account_Number__c;
		aspContractRequest.accHoldername = paymentplan.Account_Holder_Name__c;
		aspContractRequest.institutionName = paymentplan.Bank_Name__c;
		aspContractRequest.creditorAbbrName = paymentplan.Creditor_Short_Name__c;
		aspContractRequest.branchClearingCode1 = String.valueOf(paymentplan.Branch_Code__c);
		aspContractRequest.firstCollectionDate = String.valueOf(paymentplan.Debit_Order_Commencement_Date__c);
		aspContractRequest.contractRef = paymentplan.Reference__c;
		aspContractRequest.maximumAmount = String.valueOf(paymentplan.Amount__c);
		aspContractRequest.collectionDay = paymentplan.Collection_Day__c;
		aspContractRequest.dateAdjustment = String.valueOf(paymentplan.Adjustable_Debit_Date__c);
		aspContractRequest.authenticationtype = paymentplan.Debit_authentication_Type__c;
		aspContractRequest.accType = paymentplan.Account_Type__c;
		aspContractRequest.frequency = paymentplan.Frequency__c;
		aspContractRequest.mandatetype = paymentplan.Debit_Value_Type__c;
	}

	/**
	 * @description Function used to get PopulateGenericData
	 * @param accountRecord
	 */
	public static void populateGenericIndividualData(Account accountRecord) {
		aspContractRequest.name = accountRecord.FirstName;
		aspContractRequest.surname = accountRecord.Lastname;
		aspContractRequest.fullName = accountRecord.name;
		aspContractRequest.casaReferenceNumber = accountRecord.CASA_Reference_Number__pc;
		aspContractRequest.placeofResidence = accountRecord.Country_of_Residence__pc;
		aspContractRequest.title = accountRecord.Titles__pc;
		aspContractRequest.initials = accountRecord.Initials__pc;
		aspContractRequest.gender = accountRecord.Gender__pc;
		aspContractRequest.countryofbirth = accountRecord.Country_of_Birth__pc;
		aspContractRequest.idNumber = accountRecord.ID_Number__pc;
		aspContractRequest.dateIssued = string.valueOf(accountRecord.Date_Issued__pc);
		aspContractRequest.nationality = accountRecord.Nationality__pc;
		aspContractRequest.maritalStatus = accountRecord.Marital_Status__pc;
		aspContractRequest.maritalContractType = accountRecord.Marital_Contract_Type__pc;
		aspContractRequest.postmatricQualification = accountRecord.Post_Matric_Qualification__pc;
		aspContractRequest.residentialStatus = accountRecord.Residential_Status__pc;
		aspContractRequest.section129NoticeDeliveryAddress = accountRecord.Preferred_delivery_method_Legal_Notices__c;
		aspContractRequest.homTelephoneNumber = accountRecord.PersonHomePhone;
		aspContractRequest.cellphoneNumber = accountRecord.PersonMobilePhone;
		aspContractRequest.email = accountRecord.PersonEmail;
		aspContractRequest.preferredCommunicationChannel = accountRecord.Preferred_Communication_Method__pc;
		aspContractRequest.preferredLanguage = accountRecord.Home_Language__pc;
		aspContractRequest.occupationLevel = accountRecord.Occupation_Level__pc;
		aspContractRequest.occupationCode = accountRecord.Occupation_Category__pc;
		aspContractRequest.occupationalStatus = accountRecord.Occupation_Status__pc;
		aspContractRequest.employmentSector = accountRecord.Employer_Sector__pc;
		aspContractRequest.areyouregisteredforSouthAfricanIncomeTax = accountRecord.Is_customer_registered_for_income_tax__c == true ? 'Yes' : 'No';
		aspContractRequest.areyouregisteredforForeignIncomeTax = accountRecord.Is_customer_registered_for_foreign_tax__c == true ? 'Yes' : 'No';
		if (aspContractRequest.areyouregisteredforSouthAfricanIncomeTax != null && aspContractRequest.areyouregisteredforSouthAfricanIncomeTax == 'Yes') {
			aspContractRequest.southAfricanTaxNumber = accountRecord.Income_Tax_Number__pc != null ? accountRecord.Income_Tax_Number__pc : '0';
			aspContractRequest.reasonSouthAfricanTaxNumberNotGiven = (accountRecord.Income_Tax_Number__pc == null ||
				accountRecord.Income_Tax_Number__pc == '0')
				? accountRecord.Income_Tax_Number_Reason__pc
				: '';
		}
		aspContractRequest.monthlyIncome = accountRecord.Monthly_Income__pc;
		aspContractRequest.sourceofIncome = accountRecord.Income_Source__pc;
		aspContractRequest.nextofKinSurname = accountRecord.Next_of_Kin_Last_Name__pc;
		aspContractRequest.nextofKinfullName = accountRecord.Next_of_Kin_First_Name_s__pc + '' + accountRecord.Next_of_Kin_Last_Name__pc;
		aspContractRequest.nextofKinrelationship = accountRecord.Next_of_Kin_Relationship__pc;
		aspContractRequest.nextofKinWorkTelephoneNumber = accountRecord.Next_of_Kin_Telephone_Number__pc;
		aspContractRequest.nextofKinemail = accountRecord.Next_of_Kin_Email_Address__pc;
		Account accountHasPostMatric = [SELECT Has_Post_Matric_Qualification__pc FROM Account WHERE Account.Id = :accountRecord.Id];
		aspContractRequest.doesTheCustomerHaveAPostMatricQualification = accountHasPostMatric.Has_Post_Matric_Qualification__pc == true ? 'Yes' : 'No';
		aspContractRequest.doesTheCustomerReceiveASocialGrant = String.valueOf(accountRecord.Does_the_Client_receive_Social_a_Grant__c);
		aspContractRequest.hasTheCustomerEverBeenDeclaredInsolvent = String.valueOf(accountRecord.Client_ever_been_declared_Insolvent__c);
		aspContractRequest.debitOrderSurname = accountRecord.Maiden_Name__pc;
		aspContractRequest.debitOrderInitials = accountRecord.Initials__pc;
		aspContractRequest.debitOrderIdNumber = accountRecord.ID_Number__pc;
		aspContractRequest.dateofBirth = String.valueOf(accountRecord.PersonBirthdate);
		aspContractRequest.countryPassportIssued = accountRecord.CountryPassport__pc;
		aspContractRequest.residentialAddressCountry = accountRecord.Country_of_Residence__pc;
		aspContractRequest.numberofDependents = String.valueOf(accountRecord.Number_Of_Dependents__c);
		aspContractRequest.employersName = accountRecord.Employer_Name__pc;
		aspContractRequest.employersAddress = accountRecord.Employer_Name__pc;
		aspContractRequest.idType = accountRecord.ID_Type__pc;
		aspContractRequest.age = String.valueOf(accountRecord.Age__pc);
		aspContractRequest.employerWorktelephoneNumber = accountRecord.Employer_Phone__c;
		aspContractRequest.homTelephoneNumber = accountRecord.PersonHomePhone;
		aspContractRequest.mandateHolderName = accountRecord.Name;
		aspContractRequest.reasonforOpening = accountRecord.Client_Creation_Reason__c;
		aspContractRequest.customerCode = accountRecord.CIF__c;
		aspContractRequest.correspondenceLanguage = accountRecord.Communication_Language__pc;
		aspContractRequest.sourceofIncome = accountRecord.Source_of_Income__pc;

		aspContractRequest.absaGroupMarketingConsent = accountRecord.Non_Credit_Marketing_Consent__pc;
		if (accountRecord.Non_Credit_Marketing_Consent__pc == 'Yes') {
			aspContractRequest.absaGroupMarketingItems = setMarketingConsentItems(accountRecord.Non_Credit_Marketing_Indicator__pc);
		}

		aspContractRequest.absaGroupCreditMarketingConsent = accountRecord.Credit_Marketing_Consent__pc;
		if (accountRecord.Credit_Marketing_Consent__pc == 'Yes') {
			aspContractRequest.absaGroupCreditMarketingItems = setMarketingConsentItems(accountRecord.Credit_Marketing_Indicator__pc);
		}

		Address__c residentialAddress = [
			SELECT Shipping_Street__c, Shipping_Street_2__c, Shipping_Suburb__c, Shipping_City__c, Shipping_Country__c, Shipping_Zip_Postal_Code__c
			FROM Address__c
			WHERE Account__c = :accountRecord.Id AND Address_TYpe__c = 'Residential'
			LIMIT 1
		];
		aspContractRequest.residential.street = (residentialAddress.Shipping_Street__c != null) ? residentialAddress.Shipping_Street__c.toUpperCase() : '';
		aspContractRequest.residential.street2 = (residentialAddress.Shipping_Street_2__c != null) ? residentialAddress.Shipping_Street_2__c.toUpperCase() : '';
		aspContractRequest.residential.suburb = (residentialAddress.Shipping_Suburb__c != null) ? residentialAddress.Shipping_Suburb__c.toUpperCase() : '';
		aspContractRequest.residential.city = (residentialAddress.Shipping_City__c != null) ? residentialAddress.Shipping_City__c.toUpperCase() : '';
		aspContractRequest.residential.postalCode = (residentialAddress.Shipping_Zip_Postal_Code__c != null)
			? residentialAddress.Shipping_Zip_Postal_Code__c
			: '';
		aspContractRequest.residential.country = (residentialAddress.Shipping_Country__c != null) ? residentialAddress.Shipping_Country__c : '';
		Address__c postalAddress = [
			SELECT Shipping_Street__c, Shipping_Street_2__c, Shipping_Suburb__c, Shipping_City__c, Shipping_Country__c, Shipping_Zip_Postal_Code__c
			FROM Address__c
			WHERE Account__c = :accountRecord.Id AND Address_TYpe__c = 'Postal'
			LIMIT 1
		];
		aspContractRequest.postal.street = (postalAddress.Shipping_Street__c != null) ? postalAddress.Shipping_Street__c.toUpperCase() : '';
		aspContractRequest.postal.street2 = (postalAddress.Shipping_Street_2__c != null) ? postalAddress.Shipping_Street_2__c.toUpperCase() : '';
		aspContractRequest.postal.suburb = (postalAddress.Shipping_Suburb__c != null) ? postalAddress.Shipping_Suburb__c.toUpperCase() : '';
		aspContractRequest.postal.city = (postalAddress.Shipping_City__c != null) ? postalAddress.Shipping_City__c.toUpperCase() : '';
		aspContractRequest.postal.postalCode = (postalAddress.Shipping_Zip_Postal_Code__c != null) ? postalAddress.Shipping_Zip_Postal_Code__c : '0';
	}

	/**
	 * @description Function used to get list of marketing Items
	 * @param multiselect
	 * @return List<string>
	 */
	public static List<string> setMarketingConsentItems(string multiselect) {
		List<string> marketingList = new List<String>();
		if (getMulitselectItemIfPresent(multiselect, 'Email') != null) {
			marketingList.add('Email');
		}
		if (getMulitselectItemIfPresent(multiselect, 'SMS') != null) {
			marketingList.add('SMS');
		}
		if (getMulitselectItemIfPresent(multiselect, 'Voice Recording') != null) {
			marketingList.add('Voice Recording');
		}
		if (getMulitselectItemIfPresent(multiselect, 'Telephone') != null) {
			marketingList.add('Telephone');
		}
		if (getMulitselectItemIfPresent(multiselect, 'Mail') != null) {
			marketingList.add('Mail');
		}
		return marketingList;
	}

	/**
	 * @description Multiselect Check
	 * @param multiselect
	 * @param item
	 * @return string
	 */
	public static string getMulitselectItemIfPresent(string multiselect, string item) {
		if (multiselect.contains(item)) {
			return item;
		} else {
			return null;
		}
	}

	/**
	 * @description Function used to get PopulatePackageSpecificData
	 * @param complete2
	 * @param ApplicationId
	 */
	public static void populateCreditCardSpecificData(string complete2, string ApplicationId) {
		CCApplicationService_apply_Resp_IB_v1 cftsCompleteTwo = (CCApplicationService_apply_Resp_IB_v1) json.deserialize(
			complete2,
			CCApplicationService_apply_Resp_IB_v1.class
		);
		aspContractRequest.totalNetIncome = cftsCompleteTwo.applyResponse.z_return.application.primaryApplicant.income.nettMonthlyIncome;
		aspContractRequest.totalGrossIncome = cftsCompleteTwo.applyResponse.z_return.application.primaryApplicant.income.grossMonthlySalary;
		aspContractRequest.disposableMonthlyIncome = cftsCompleteTwo.applyResponse.z_return.application.primaryApplicant.income.disposableMonthlyIncome;
		aspContractRequest.maintenanceExpense = cftsCompleteTwo.applyResponse.z_return.application.primaryApplicant.expense.maintenance;
		aspContractRequest.totalLivingExpenses = cftsCompleteTwo.applyResponse.z_return.application.primaryApplicant.expense.totalLivingExpense;
		aspContractRequest.totalFixedDebitInstalments = cftsCompleteTwo.applyResponse.z_return.application.primaryApplicant.expense.totalFixedDebtExpense;
		aspContractRequest.quoteNumber = cftsCompleteTwo.applyResponse.z_return.application.quote.z_number;
		aspContractRequest.isDEA = (cftsCompleteTwo.applyResponse.z_return.application.consents.deaConsent == 'true') ? true : false;
		aspContractRequest.isACL = (cftsCompleteTwo.applyResponse.z_return.application.annualCreditLimitIncreases == 'true') ? true : false;
		aspContractRequest.creditworthinessConsent = (cftsCompleteTwo.applyResponse.z_return.application.primaryApplicant.mayCheckCreditWorthiness == 'true')
			? 'true'
			: 'false';
		String knockoutList = KnockoutQuestionsController.fetchKnockoutQuestions('Knockout');
		if (knockoutList != null && string.isNotEmpty(knockoutList)) {
			aspContractRequest.KnockoutQuestions = knockoutList.replaceAll('<ul>|<li>|</li>|</ul>|', '');
		}
		ASPDeviceContractController.populatePaymentPlanData(ApplicationId);
	}

	/**
	 * @description Function used to get PopulateSwitchingData
	 * @param opportunityID
	 * @param accountNumber
	 */
	public static void populateSwitchingData(String opportunityID, string accountNumber) {
		List<Switching_Entry__c> switchesList = [
			SELECT
				Account_Number__c,
				Previous_Account_Number__c,
				OpportunityId__c,
				Was_Switch_Successful__c,
				Previous_Account_Type__c,
				Previous_Institution__c,
				Due_Date__c,
				Frequency__c,
				Notes__c,
				Overdue__c,
				Channel__c,
				State__c,
				Switch_Type__c,
				Origin_Employee_Name__c,
				Origin_Employee_Number__c,
				Origin_Employee_Surname__c,
				Origin_Site_Code__c,
				Amount__c,
				Previous_Account_Holder__c,
				Employer_Name__c,
				FixVar__c
			FROM Switching_Entry__c
			WHERE OpportunityId__c = :opportunityID AND Was_Switch_Successful__c = TRUE
		];

		if (switchesList.size() > 0) {
			aspContractRequest.switching = new ASPDeviceContractRequest.Switching();
			aspContractRequest.switching.debitOrders = new List<ASPDeviceContractRequest.DebitOrder>();
			aspContractRequest.switching.isBeneficiarySwitch = false;

			aspContractRequest.switching.absaAccountNo = accountNumber;
			aspContractRequest.switching.absaBranchCode = '632005';
			aspContractRequest.switching.absaAccoutType = 'Cheque';

			for (Switching_Entry__c switchItem : switchesList) {
				if (switchItem.Switch_Type__c == 'SALARY') {
					aspContractRequest.switching.isSalarySwitch = true;
					aspContractRequest.switching.previousAccountNo = switchItem.Previous_Account_Number__c;
					aspContractRequest.switching.previousFinancialInstitution = switchItem.Previous_Institution__c;
					aspContractRequest.switching.previousProductType = switchItem.Previous_Account_Type__c;
					aspContractRequest.switching.employer = switchItem.Employer_Name__c;
					aspContractRequest.switching.dueDate = switchItem.Due_Date__c;
				} else {
					aspContractRequest.switching.isDebitOrderSwitch = true;
					if (aspContractRequest.switching.previousAccountNo == '') {
						aspContractRequest.switching.previousAccountNo = switchItem.Previous_Account_Number__c;
					}
					if (aspContractRequest.switching.previousFinancialInstitution == '') {
						aspContractRequest.switching.previousFinancialInstitution = switchItem.Previous_Institution__c;
					}
					if (aspContractRequest.switching.previousProductType == '') {
						aspContractRequest.switching.previousProductType = switchItem.Previous_Account_Type__c;
					}
					ASPDeviceContractRequest.DebitOrder debitOrder = new ASPDeviceContractRequest.DebitOrder();
					debitOrder.beneficiary = switchItem.Employer_Name__c;
					debitOrder.refAccountNo = switchItem.Account_Number__c;
					debitOrder.telUserCode = '';
					debitOrder.dateDue = switchItem.Due_Date__c;
					debitOrder.frequency = switchItem.Frequency__c;
					debitOrder.amount = switchItem.Amount__c;

					aspContractRequest.switching.debitOrders.add(debitOrder);
				}
			}
		}
	}
	/**
	 * @description Function used to get populateStokvelData
	 * @param opportunityID
	 * @param accountRecord
	 */
	public static void populateGenericBusinessEntityData(String opportunityID,Account accountRecord) {
		aspContractRequest.name = accountRecord.Name;
		aspContractRequest.casaReferenceNumber = accountRecord.CASA_Reference_Number__c;
		aspContractRequest.placeofResidence = accountRecord.Country_of_Incorporation__c;
		aspContractRequest.IDNumber = accountRecord.ID_Number__pc;
		//aspContractRequest.cellphoneNumber = accountRecord.Phone;
        //aspContractRequest.email = accountRecord.Active_Email__c;
		aspContractRequest.preferredCommunicationChannel = accountRecord.Communication_Method__c;
		aspContractRequest.preferredLanguage = accountRecord.Communication_Language__pc;
		aspContractRequest.creditworthinessConsent = string.valueOf(accountRecord.Credit_Worthiness_Consent__c);
		aspContractRequest.AbsaGroupMarketingConsent = accountRecord.Credit_Marketing_Consent__pc;
		aspContractRequest.sourceofIncome = accountRecord.Source_of_Income__c;
		aspContractRequest.NextofKinSurname = accountRecord.Next_of_Kin_Last_Name__pc;
		aspContractRequest.NextofKinfullName = accountRecord.Next_of_Kin_First_Name_s__pc + '' + accountRecord.Next_of_Kin_Last_Name__pc;
		aspContractRequest.NextofKinrelationship = accountRecord.Next_of_Kin_Relationship__pc;
		aspContractRequest.NextofKinWorkTelephoneNumber = accountRecord.Next_of_Kin_Telephone_Number__pc;
		aspContractRequest.NextofKinemail = accountRecord.Next_of_Kin_Email_Address__pc;
		aspContractRequest.preferredLanguage = accountRecord.Language__c;
		aspContractRequest.reasonforOpening = accountRecord.Client_Creation_Reason__c;
		aspContractRequest.customerCode = accountRecord.CIF__c;
		aspContractRequest.correspondenceLanguage = accountRecord.Communication_Language__pc;
		//aspContractRequest.sourceofIncome = accountRecord.Source_of_Income__pc;
        
        aspContractRequest.postmatricQualification = contractTypeStk;
		aspContractRequest.knockoutQuestions = contractDataStk;
		AccountContactRelation accountcontroler = AccountContactController.GetAccountContactController(accountRecord.Id);
		Account accountcontrolerdetail = AccountContactController.GetAccountControllerDetails(accountcontroler.ContactId);
		// pls dod a null check
		Address__c postalAddress = StokvelEntityCasaCIFController.getAddessByType(accountcontrolerdetail.Id, 'Postal');
		Address__c residentialAddress = StokvelEntityCasaCIFController.getAddessByType(accountcontrolerdetail.Id, 'Residential');

		aspContractRequest.Residential.Street = (residentialAddress.Shipping_Street__c != null) ? residentialAddress.Shipping_Street__c.toUpperCase() : '';
		aspContractRequest.Residential.Suburb = (residentialAddress.Shipping_Suburb__c != null) ? residentialAddress.Shipping_Suburb__c.toUpperCase() : '';
		aspContractRequest.Residential.City = (residentialAddress.Shipping_City__c != null) ? residentialAddress.Shipping_City__c.toUpperCase() : '';
		aspContractRequest.Residential.PostalCode = (residentialAddress.Shipping_Zip_Postal_Code__c != null)
			? residentialAddress.Shipping_Zip_Postal_Code__c
			: '';
		aspContractRequest.Residential.Country = (residentialAddress.Shipping_Country__c != null) ? residentialAddress.Shipping_Country__c : '';

		aspContractRequest.Postal.Street = (postalAddress.Shipping_Street__c != null) ? postalAddress.Shipping_Street__c.toUpperCase() : '';
		aspContractRequest.Postal.Suburb = (postalAddress.Shipping_Suburb__c != null) ? postalAddress.Shipping_Suburb__c.toUpperCase() : '';
		aspContractRequest.Postal.City = (postalAddress.Shipping_City__c != null) ? postalAddress.Shipping_City__c.toUpperCase() : '';
		aspContractRequest.Postal.PostalCode = (postalAddress.Shipping_Zip_Postal_Code__c != null) ? postalAddress.Shipping_Zip_Postal_Code__c : '0';
		
        
        aspContractRequest.groupScheme = accountRecord.Standard_Industry_SIC_Code__c; 
       // aspContractRequest.debitOrderSurname = string.valueOf(accountRecord.Number_of_Participants__c);
        // aspContractRequest.institutionName = accountRecord.Standard_Industry_SIC_Category__c;
        aspContractRequest.corporateSubProduct = accountRecord.Country_of_Foreign_tax__c;        
        aspContractRequest.southAfricanTaxNumber = accountRecord.Income_Tax_Number__c != null ? accountRecord.Income_Tax_Number__c : '0';			
        
        ASPDeviceContractController.populateRelatedData(opportunityID,accountRecord);
    }

    /**
	 * @description Function used to get PopulateRelatedData
	 * @param opportunityID
	 * @param accountRecord
	 */
	public static void populateRelatedData(string opportunityID,Account accountRecord) {
        List<AccountContactRelation> accountlist = [SELECT Id, 
                                                    AccountId,ContactId,
                                                    Contact.CASA_Reference_Number__c,                                                    
                                                    Contact.Source_of_Income__c,
                                                    Contact.Initials__c,
                                                    contact.Titles__c,
                                                    Contact.ID_Type__c,
                                                   Contact.Date_Issued__c, 
                                                    Contact.FirstName,
                                                    Contact.LastName,
                                                    Contact.ID_Number__c,
                                                    Contact.OtherPhone,
                                                    Controlling_Person_is_Taxed_Outside__c,// controller
                                                    Control_of_Passive_Non_Financial_Entity__c,//signatory
                                                   Contact.Birthdate,
                                                    Contact.Country_of_Birth__c,
                                                    Contact.Country_of_Residence__c,
                                                    Contact.Occupation_Status__c,
                                                    Contact.occupation_Level__c,
                                                    Contact.Nationality__c,
                                                    Contact.Gender__c,
                                                    Contact.CIF__c,
													Contact.Occupation_Category__c,
                                                    Contact.MobilePhone
                                                    FROM AccountContactRelation
                                                    WHERE AccountId = :accountRecord.Id AND Primary_Entity_Id__c =:accountRecord.Id
                                                    WITH SECURITY_ENFORCED
                                                   ];
         aspContractRequest.relatedParty = new ASPDeviceContractRequest.RelatedParty();
        aspContractRequest.relatedParty.relSignatoryCount = RelatedPartyDetailsController.getRelatedpartyCount(accountRecord.Id);
        
        aspContractRequest.relatedParty.relatedPartyDetails = new List<ASPDeviceContractRequest.RelatedPartyDetails>();
		if (accountlist.size() > 0) {
			for (AccountContactRelation contactRelation : accountlist) 
            {
                ASPDeviceContractRequest.RelatedPartyDetails relatedPartyDetails = new ASPDeviceContractRequest.RelatedPartyDetails();
                ASPDeviceContractRequest.Address relatedAddress = new ASPDeviceContractRequest.Address();
                ProductContactSignatoryRelationship__c accountcontactReldetails = AccountContactController.GetProductContactSignatoryRelationship(opportunityID,contactRelation.Id);
                if(accountcontactReldetails != null)
                {
                    relatedPartyDetails.relCompulsorySignature = accountcontactReldetails.Compulsory_Signature__c;
                    aspContractRequest.relatedParty.relSignatoryCount = accountcontactReldetails.Number_of_Signatories_for_account__c;
					aspContractRequest.recipientName = accountcontactReldetails.Special_Instruction__c;                    
                }
                
                relatedPartyDetails.relCasaRefNumber = contactRelation.Contact.CASA_Reference_Number__c;
                string firstName=  contactRelation.Contact.FirstName;
                
                if(firstName != '')
                {
                    relatedPartyDetails.relInitials = getInitials(firstName);
                }
                relatedPartyDetails.relTitle = contactRelation.Contact.Titles__c;
                relatedPartyDetails.relIdType = contactRelation.Contact.ID_Type__c;
                relatedPartyDetails.relDateIssued = string.valueOf(contactRelation.Contact.Date_Issued__c);
                relatedPartyDetails.relFirstName = contactRelation.Contact.FirstName;                
                relatedPartyDetails.relSurName = contactRelation.Contact.LastName;
                relatedPartyDetails.relIdNumber = contactRelation.Contact.ID_Number__c;
                relatedPartyDetails.relHomeTelNumber = contactRelation.Contact.OtherPhone;
                relatedPartyDetails.relController = contactRelation.Controlling_Person_is_Taxed_Outside__c;
                relatedPartyDetails.relSignatory = contactRelation.Control_of_Passive_Non_Financial_Entity__c;
                relatedPartyDetails.relDateOfBirth = string.valueOf(contactRelation.Contact.Birthdate);                
                relatedPartyDetails.relCountryOfBirth = contactRelation.Contact.Country_of_Birth__c;
                relatedPartyDetails.relCountryOfResidence = contactRelation.Contact.Country_of_Residence__c;                
                relatedPartyDetails.relOccupationalCode = contactRelation.Contact.occupation_Level__c;                
                relatedPartyDetails.relOccupationalStatus = contactRelation.Contact.Occupation_Status__c;                
                relatedPartyDetails.relNationality = contactRelation.Contact.Nationality__c;                
                relatedPartyDetails.relGender = contactRelation.Contact.Gender__c;                
                relatedPartyDetails.relCustomerCode = contactRelation.Contact.CIF__c;                
                relatedPartyDetails.relOccupationCategory = contactRelation.Contact.Occupation_Category__c;                
                relatedPartyDetails.relCellNumber = contactRelation.Contact.MobilePhone;
                
                Account accountcontrolerdetail = AccountContactController.GetAccountControllerDetails(contactRelation.ContactId);
                if(relatedPartyDetails.relController == true)
                {
                    aspContractRequest.cellphoneNumber = accountcontrolerdetail.PersonMobilePhone;
                    aspContractRequest.email = accountcontrolerdetail.PersonEmail;
                }
                Address__c postalAddress = StokvelEntityCasaCIFController.getAddessByType(accountcontrolerdetail.Id, 'Postal');
                Address__c residentialAddress = StokvelEntityCasaCIFController.getAddessByType(accountcontrolerdetail.Id, 'Residential');
                relatedPartyDetails.relResidential =  new ASPDeviceContractRequest.Address();
                relatedPartyDetails.relResidential.Street = (residentialAddress.Shipping_Street__c != null) ? residentialAddress.Shipping_Street__c.toUpperCase() : '';
                relatedPartyDetails.relResidential.Suburb = (residentialAddress.Shipping_Suburb__c != null) ? residentialAddress.Shipping_Suburb__c.toUpperCase() : '';
                relatedPartyDetails.relResidential.City = (residentialAddress.Shipping_City__c != null) ? residentialAddress.Shipping_City__c.toUpperCase() : '';
                relatedPartyDetails.relResidential.PostalCode = (residentialAddress.Shipping_Zip_Postal_Code__c != null)
                    ? residentialAddress.Shipping_Zip_Postal_Code__c
                    : '';
                relatedPartyDetails.relResidential.Country = (residentialAddress.Shipping_Country__c != null) ? residentialAddress.Shipping_Country__c : '';
                 relatedPartyDetails.relPostal =  new ASPDeviceContractRequest.Address();
                relatedPartyDetails.relPostal.Street = (postalAddress.Shipping_Street__c != null) ? postalAddress.Shipping_Street__c.toUpperCase() : '';
                relatedPartyDetails.relPostal.Suburb = (postalAddress.Shipping_Suburb__c != null) ? postalAddress.Shipping_Suburb__c.toUpperCase() : '';
                relatedPartyDetails.relPostal.City = (postalAddress.Shipping_City__c != null) ? postalAddress.Shipping_City__c.toUpperCase() : '';
                relatedPartyDetails.relPostal.PostalCode = (postalAddress.Shipping_Zip_Postal_Code__c != null) ? postalAddress.Shipping_Zip_Postal_Code__c : '0';
               
                aspContractRequest.relatedParty.relatedPartyDetails.add(relatedPartyDetails);                
               
            }
        }
	}
    
    /**
	 * @description Derive Initials From Names
	 * @author PaulJohn.duRand@absa.africa | 2021-09-06
	 * @param fullName
	 * @return string
	 **/
	public static string getInitials(string fullName) {
		List<String> fullNameList = fullName.split(' ');
		String initials = '';
		for (String x : fullNameList) {
			x = x.replace('-', '');
			x = x.replace('\'', '');
			initials = initials + x.left(1);
		}
		return initials;
	}
	/**
	 * @description Populate Generic Data
	 * @author PaulJohn.duRand@absa.africa | 2021-07-27
	 * @param opportunityID
	 * @param accountRecord
	 **/
	private static void populateGenericData(String opportunityID,Account accountRecord) {
		if (!BranchFunctions.isBusinessProspect(accountRecord.Id)) {
			ASPDeviceContractController.populateGenericIndividualData(accountRecord);
		} else {
			ASPDeviceContractController.populateGenericBusinessEntityData(opportunityID,accountRecord);
		}
	}

	/**
	 * @description Populate User details to request
	 * @author PaulJohn.duRand@absa.africa | 2021-07-27
	 * @param accountRecord
	 **/
	private static void populateUserData(Account accountRecord) {
		User currentUser = new UsersSelector().selectById(UserInfo.getUserId());
		if (currentUser != null) {
			aspContractRequest.registeringSite = currentUser.SiteCode__c;
			aspContractRequest.capturedBy = currentUser.Name;
			aspContractRequest.ficaIdentifiedBy = accountRecord.Identified_by_Employee_Number__c;
			aspContractRequest.ficaVerifiedBy = currentUser.EmployeeNumber;
			aspContractRequest.ficaDateIdentified = String.valueOf(accountRecord.Date_Identified__c);
			aspContractRequest.ficaDateVerified = String.valueOf(accountRecord.Date_Verified__c);
			aspContractRequest.absaRepresentativeName = currentUser.Name;
			aspContractRequest.absaEmployeeNumber = currentUser.EmployeeNumber;
			aspContractRequest.salesConsultant = currentUser.Name;
		}
	}

	/**
	 * @description Populate Account Number
	 * @author PaulJohn.duRand@absa.africa | 2021-07-27
	 * @param oppproducts
	 * @return string
	 **/
	private static string populateAccountNumber(List<OpportunityLineItem> oppproducts) {
		OpportunityLineItem oppproduct = new OpportunityLineItem();
		for (OpportunityLineItem o : oppproducts) {
			if (o.Product_Family__c == ChequeProductFamily || o.Product_Family__c == SavingsProductFamily) {
				oppproduct = o;
				break;
			}
		}
        if (oppproduct != null) {
            aspContractRequest.product = oppproduct.Product_Family__c;
			aspContractRequest.accountNumber = oppproduct.Policy_Number__c;
		}
		return aspContractRequest.accountNumber;
	}

	/**
	 * @description Populate Vas Detail
	 * @author PaulJohn.duRand@absa.africa | 2021-07-27
	 * @param application
	 **/
	private static void populateVasData(Application__c application) {
		Application__c app = [
			SELECT
				ROAQuestionnaire__c,
				Source_of_Funds__c,
				Internet_Banking__c,
				Notifyme__c,
				Absa_Reward__c,
				Electronic_Statements__c,
				Absa_Reward_MembershipNumber__c,
				Absa_Rewards_Debit_Day__c,
            	Absa_Rewards_Fee__c
			FROM Application__c
			WHERE Id = :application.Id
		];
		aspContractRequest.isEStatement = app.Electronic_Statements__c;
		aspContractRequest.isInternetBanking = app.Internet_Banking__c;
		//NotifyMe
		aspContractRequest.isNotify = (app.Notifyme__c == 'Yes') ? true : false;
		if (aspContractRequest.isNotify) {
			aspContractRequest.notifyMeCode = '19';
			aspContractRequest.notifyMeDescription = 'PAYMENTS';
		}
		//Rewards
		aspContractRequest.isRewards = app.Absa_Reward__c;
		if (aspContractRequest.isRewards) {
			aspContractRequest.rewardsMembershipNumber = app.Absa_Reward_MembershipNumber__c;
            aspContractRequest.rewardsMonthlyFee = app.Absa_Rewards_Fee__c;
            aspContractRequest.rewardsDebitDay = app.Absa_Rewards_Debit_Day__c;
		}
		aspContractRequest.incomeAndExpensesDeclaration = application.Currently_Undergoing_Debt_Counselling__c;
		aspContractRequest.creditLifeSelected = String.valueOf(application.Credit_Life_Benefit__c);
		aspContractRequest.incomeAndExpensesDebtCounselling = String.valueOf(application.Application_Correctness_Consent__c);
		aspContractRequest.roaQuestionnaire = app.ROAQuestionnaire__c;
		if (application != null) {
			Application_Product__c[] applicationProduct = [
				SELECT ChequeAccountBasicManagerNumber__c, ChequeAccountBasicOpenDate__c
				FROM Application_Product__c
				WHERE Application__c = :application.Id
			];
			if (applicationProduct.size() > 0) {
				aspContractRequest.managerNumber = applicationProduct[0].ChequeAccountBasicManagerNumber__c;
				aspContractRequest.chequeAccountOpenDate = applicationProduct[0].ChequeAccountBasicOpenDate__c;
			}
			aspContractRequest.sourceofFunds = app.Source_of_Funds__c;
		}
	}

	/**
	 * @description populate Features AndBenefit Product (Populates from Product Line Item if featureAndBenefitProduct is not parsed)
	 * @author PaulJohn.duRand@absa.africa | 2021-07-27
	 * @param oppId
	 * @param featureAndBenefitProduct
	 **/
	private static void populateFeaturesAndBenefitProduct(string oppId, string featureAndBenefitProduct) {
		string productName='';
        if (featureAndBenefitProduct == null || featureAndBenefitProduct == '') {
			Product2 p = [
				SELECT Name,ProductCode, Price_Scheme_Code__c
				FROM Product2
				WHERE Id IN (SELECT Product2Id FROM OpportunityLineItem WHERE OpportunityId = :oppId AND ProductCode != NULL) AND Family != NULL
				LIMIT 1
			];
            productName = p.Name;
			if (p.Price_Scheme_Code__c != null && p.Price_Scheme_Code__c != '') {
				featureAndBenefitProduct = String.valueOf(p.ProductCode) + '_' + p.Price_Scheme_Code__c;
			} else {
				featureAndBenefitProduct = String.valueOf(p.ProductCode);
			}
		}
		aspContractRequest.packageName = featureAndBenefitProduct;
        aspContractRequest.productType = productName;
	}    
	/**
	 * @description populate Wimi Product
	 * @param opportunityID
	 * @param account
	 **/
	/*private static void populateWimiProducts(String opportunityID, Account account){
		aspContractRequest.WimiProducs = WimiContractHelper.GetContractDetailsForProductItems(opportunityID, account);
	}*/
	/**
	 * @description Populate default Values
	 * @author PaulJohn.duRand@absa.africa | 2021-07-27
	 **/
	private static void populateDefaultValues() {
		aspContractRequest.notifyTime = 'All hours';
		aspContractRequest.minimumAmount = '0';
		aspContractRequest.frequencyofIncome = 'Monthly';
		aspContractRequest.siteName = 'ABS';
		aspContractRequest.newAccount = 'Yes';
		aspContractRequest.abcUser = 'No';
		aspContractRequest.accountStopped = 'No';
		aspContractRequest.creditBackdateLimit = 'S';
		aspContractRequest.debitBackdateLimit = 'S';
		aspContractRequest.corporateSubProduct = 'O';
	}
    
    /**
	 * @description Function used to get PopulateProductParentCode
	 * @param productType	 
	 */
	public static void PopulateProductParentCode(string productType) {
        try{
        Product2 productId = [
            SELECT ID,ProductCode,Price_Scheme_Code__c 
            FROM Product2
            WHERE Name = :productType AND ProductCode  != NULL LIMIT 1];
        if(productId != null)
        {
           Product_Product_Entry__c productEntry = [
                SELECT Id, Name, Parent_Product__c, 
                Related_Product__c 
                FROM Product_Product_Entry__c
                WHERE Related_Product__c = :productId.Id LIMIT 1];
            if(productEntry != null)
            {
                Product2 productCodeDetails = [
                    SELECT ID,ProductCode
                    FROM Product2
                    WHERE id = :productEntry.Parent_Product__c LIMIT 1];
                aspContractRequest.productType = productCodeDetails.ProductCode + ' ' +  productType;
            }
        }
        }catch(Exception e)
        {
            aspContractRequest.productType ='Investment club';
        }
    }
}