/**
 * Apex Enterprise Design Patterns
 * @description Selector Layer for Account objects
 * @author   Kyle Alexander
 * @since    2018-07-17
 * @updated  2019/01/23  Nelson Chisoko (Dariel)
 *
 * @update Englarmerdge Mongwe
 * @dateUpdated 2020-09-14
 * Client detail section for sole trader - W-005852
 *
 * @update Jason Quevauvilliers.
 * @dateUpdated 2021-05-26
 */
public without sharing class AccountsSelector extends fflib_SObjectSelector {
	/**
	 * @description MANDATORY ABSTRACT METHODS - START
	 * @return Schema.SObjectType
	 */
	public Schema.SObjectType getSObjectType() {
		return Account.sObjectType;
	}
	//FIELDSETS NAMES TO INCLUDE
	public override List<Schema.FieldSet> getSObjectFieldSetList() {
		return new List<Schema.FieldSet>{ SObjectType.Account.FieldSets.Client_Finder_Compact_View };
	}

	/**
	 * @description getSObjectFieldList
	 * @return List<Schema.SObjectField>
	 */
	public List<Schema.SObjectField> getSObjectFieldList() {
		return new List<Schema.SObjectField>{
			Account.Id,
			Account.Description,
			Account.RecordTypeId,
			Account.PersonEmail,
			Account.CASA_Analyst_Comments__pc,
			Account.CASA_Reference_Number__pc,
			Account.CASA_Screening_Date__pc,
			Account.CASA_Screening_Status__pc,
			Account.Casa_Sequence_Number__c,
			Account.CASA_Risk_Status__pc,
			Account.Casa_Status__c,
			Account.Risk_Status__c,
			Account.Fraud_Status__c,
			Account.Occupation__pc,
			Account.Occupation_Status__pc,
			Account.Occupation_Level__pc,
			Account.Income_Source__pc,
			Account.BillingStreet,
			Account.BillingCity,
			Account.BillingPostalCode,
			Account.BillingCountry,
			Account.ShippingStreet,
			Account.ShippingCity,
			Account.ShippingCountry,
			Account.ShippingPostalCode,
			Account.Passport_Number__pc,
			Account.PersonMobilePhone,
			Account.PersonHomePhone,
			Account.PersonOtherPhone,
			Account.Phone,
			Account.PersonBirthDate,
			Account.PersonTitle,
			Account.FinServ__Gender__pc,
			Account.FirstName,
			Account.ID_Number__pc,
			Account.LastName,
			Account.CIF__c,
			Account.FinServ__CountryOfBirth__pc,
			Account.Country_of_Residence__pc,
			Account.Income_Bracket__pc,
			Account.Communication_Language__pc,
			Account.Marital_Status__pc,
			Account.Nationality__pc,
			Account.Initials__pc,
			Account.CASA_Reference_Number__c,
			Account.ID_Type__pc,
			Account.Territory__c,
			Account.CountryPassport__pc,
			Account.FinServ__CountryOfResidence__pc,
			Account.Country_of_Birth__pc,
			Account.CASA_Analyst_Comments__c,
			Account.CASA_Screening_Date__c,
			Account.CASA_Screening_Status__c,
			Account.Gender__pc,
			Account.Occupation_Category__pc,
			Account.Client_Type__c,
			Account.Marital_Contract_Type__pc,
			Account.Non_Credit_Marketing_Consent__pc,
			Account.Communication_Method__c,
			Account.Non_Credit_Marketing_Indicator__pc,
			Account.MiddleName,
			Account.Income_Tax_Number__pc,
			Account.Employer_Name__pc,
			Account.OwnerId,
			Account.Preferred_Communication_Method__pc,
			Account.Home_Language__pc,
			Account.Country_of_Origin__pc,
			Account.Name_of_FSP__c,
			Account.Certified_Copy_of_the_Licence_Received__c,
			Account.Conditions_and_Restrictions__c,
			Account.FSP_Number__c,
			Account.Named_Condition__c,
			Account.Is_the_Client_a_Non_resident__c,
			Account.Is_the_Client_a_Temporary_Resident__c,
			Account.Residential_Status_Address__c,
			Account.Residential_Status__pc,
			Account.Temporary_Resident_Permit_Number__c,
			Account.Temporary_Resident_Permit_Expiry_Date__c,
			Account.Date_Current_Address_Since__c,
			Account.Financial_Year_End__c,
			Account.Is_Client_Part_Of_Enter_Development_Fund__c,
			Account.Development_Fund_Partner_Client_Code__c,
			Account.Development_Fund_Name__c,
			Account.Is_Part_of_Franchise__c,
			Account.Franchise_Code__c,
			Account.Franchise_Name__c,
			Account.Business_Rescue_Affected_Party__c,
			Account.PersonContactId, //Added to fix an issue looking up the address for CreateClient Individual
			//Added for CIF Service - W-005849-ibiz
			Account.Account.Is_Marketing_Consent_SMS__c,
			Account.Monthly_Income__pc,
			Account.Account.FinServ__NumberOfChildren__pc,
			Account.Banking_Sector__c,
			Account.Client_Since_Date__c,
			Account.share_information_to_third_party__c,
			Account.SBU_Segment__c,
			Account.Employer_Sector__pc,
			Account.Affected_Person_Reg_3_1_f__c,
			Account.Client_ever_been_declared_Insolvent__c,
			Account.Sic,
			Account.Is_Marketing_Consent_Email__c,
			Account.Source_of_Income__c,
			Account.Date_Identified__c,
			Account.Date_Verified__c,
			Account.Does_the_Client_receive_Social_a_Grant__c,
			Account.Excon_Exprity_Date__c,
			Account.Date_Issued__pc,
			Account.Asylum_Permit_Expiry_Date__c,
			Account.Number_Of_Dependents__c,
			Account.Q4a_Client_affected_by_Regulation_3_1_F__c,
			Account.Standard_Industry_SIC_Code__c,
			Account.Number_of_Participants__c,
			Account.Process_Type__c,
			Account.Is_Spouse_Contribute__c,
			Account.VAT_Registration_Number__c,
			Account.Trading_Name__c,
			Account.Place_of_Residence__c,
			Account.Work_Phone__pc,
			Account.Under_Debt_Counselling__c,
			Account.Alternate_Phone1__pc,
			Account.Alternate_Phone2__pc,
			Account.Alternate_Phone3__pc,
			Account.Customer_On_boarded_via_Customer_One__c,
			Account.Physical_Address_Line_1__c, //added by Short Term Insurance
			Account.Physical_address_line_2_c__c,
			Account.Physical_Address_City__c,
			Account.Physical_Address_Suburb__c,
			Account.Physical_Address_Physical_Code__c,
			Account.Physical_Address_Country__c,
			Account.Postal_Address_Line__c,
			Account.billing_address_line_2__c,
			Account.Postal_Address_City__c,
			Account.Postal_Address_Suburb__c,
			Account.Postal_Address_Postal_Code__c,
			Account.Postal_Address_Country__c,
			Account.Data_Privacy_Flag__c, // Added by: Ashish, @desc: for Data Privacy Stories, @ref: W-012769
			Account.UBO_ParentAccountWrapper__c
			//Account.Is_the_Consent_Given__pc // using for consent for client
		};
	}

	//MANDATORY ABSTRACT METHODS - END

	//get cases by id's
	/**
	 * @description get cases by id's
	 * @param idSet
	 * @return List<Schema.SObjectField>
	 */
	public List<Account> selectById(Set<Id> idSet) {
		return (List<Account>) selectSObjectsById(idSet);
	}
	//Override default sort order i.e. CreatedDate
	public override String getOrderBy() {
		return 'Name';
	}

	//CUSTOM SELECTORS - START
	/**
	 * @description Return Accounts by Id Number
	 *
	 * @param searchValue String
	 * @param recordLimit String max records to return
	 * @return List<Account>
	 */
	public List<Account> selectByIdNumber(String searchValue, Integer recordLimit) {
		return (List<Account>) Database.query(
			newQueryFactory()
				.selectField('ID_Number__pc')
				.selectField('Id') // Added for DD STI Case
				.selectField('PersonContactId') // Added for DD STI Case
				.selectField('FirstName') // Added DD STI Case
				.selectField('LastName') // Added for DD STI Case
				.selectField('CIF__c')
				.selectField('Client_Type__c')
				.selectField('Source__c')
				.setCondition('ID_Number__pc = :searchValue')
				.setLimit(recordLimit)
				.toSOQL()
		);
	}

	/**
	 * @description Return Accounts by SUIN
	 *
	 * @param searchValue String
	 * @param recordLimit String max records to return
	 * @return List<Account>
	 */
	public List<Account> selectBySUIN(String searchValue, Integer recordLimit) {
		return (List<Account>) Database.query(
			newQueryFactory()
				.selectField('Id')
				.selectField('SUIN__c')
				.selectField('PersonContactId')
				.selectField('Client_Type__c')
				.setCondition('SUIN__c = :searchValue')
				.setLimit(recordLimit)
				.toSOQL()
		);
	}

	/**
	 * @description Method that gets a list of accounts from ID number with no limit
	 *
	 * @param IDnumber - Account's ID number
	 * @return  List<Account> a Account List with ID and name
	 */
	public List<Account> selectAccountByIdNumber(String IDnumber) {
		return Database.query(newQueryFactory().setCondition('ID_Number__pc = :IDnumber').toSOQL());
	}

	/**
	 * @description Method that get an account by account number
	 *
	 * @param accountId
	 * @return Account number
	 */
	public Account selectAllById(Id accountId) {
		return Database.query(
			newQueryFactory()
				.selectField('Description')
				.selectField('SBU_Segment__c')
				.selectField('Id')
				.selectField('ExecutionLayerRequestID__c')
				.selectField('Account_no_generated__c')
				.selectField('SPM_Platform_Type__c')
				.selectField('RecordTypeId')
				.selectField('PersonEmail')
				.selectField('Client_NCA_Status__c')
				.selectField('CASA_Analyst_Comments__pc')
				.selectField('CASA_Reference_Number__pc')
				.selectField('CASA_Screening_Date__pc')
				.selectField('CASA_Screening_Status__pc')
				.selectField('CASA_Risk_Status__pc')
				.selectField('Occupation__pc')
				.selectField('Occupation_Status__pc')
				.selectField('Income_Source__pc')
				.selectField('Employer_Sector__pc')
				.selectField('BillingStreet')
				.selectField('BillingCity')
				.selectField('BillingPostalCode')
				.selectField('BillingCountry')
				//Added by Sharath for W-009448 - Start
				.selectField('Business_Start_Date__c')
				.selectField('PEP_Status__pc')
				.selectField('CIF__pc')
				// .selectField('FICA_Address_Update_Date__c')
				//.selectField('identification_update_date__c')
				.selectField('Next_Refresh_Date__c')
				.selectField('FICA_Address_Attested_Date__pc')
				.selectField('Identification_Attested_Date__pc')
				.selectField('Risk_Rating__c')
				.selectField('Risk_Rating__pc')
				.selectField('Notification_sent__c')
				.selectField('Days_Due_F__c')
				.selectField('Expected_transactional_activity__c')
				.selectField('Company_Registration_Number__c')
				.selectField('Postal_Address_Line_1__c')
				.selectField('Postal_Address_Line_2__c')
				.selectField('Postal_Address_Line_3__c')
				.selectField('Postal_Address_Line_4__c')
				.selectField('Suburb_Town_Zip__c')
				.selectField('Postal_Code__c')
				.selectField('Relationship_Banker_Name__r.Name') // added by saiteja for W-008750
				.selectField('DD_Source_of_Funds__pc') // added by saiteja for W-008750
				.selectField('Nature_of_Client__c') // added by saiteja for W-008750
				.selectField('ShippingStreet')
				.selectField('ShippingCity')
				.selectField('ShippingState')
				.selectField('ShippingCountry')
				.selectField('ShippingPostalCode')
				.selectField('PersonMobilePhone')
				.selectField('PersonHomePhone')
				.selectField('PersonOtherPhone')
				.selectField('PersonContactId')
				.selectField('Phone')
				.selectField('PersonBirthDate')
				.selectField('PersonTitle')
				.selectField('FinServ__Gender__pc')
				.selectField('FirstName')
				.selectField('ID_Number__pc')
				.selectField('LastName')
				.selectField('CIF__c')
				.selectField('FinServ__CountryOfBirth__pc')
				.selectField('Country_of_Residence__pc')
				.selectField('Income_Bracket__pc')
				.selectField('Communication_Language__pc')
				.selectField('Marital_Status__pc')
				.selectField('Nationality__pc')
				.selectField('Initials__pc')
				.selectField('CASA_Reference_Number__c')
				.selectField('ID_Type__pc')
				.selectField('ID_Type__c')
				.selectField('Titles__pc')
				.selectField('Post_Matric_Qualification__pc')
				.selectField('Territory__c')
				.selectField('CountryPassport__pc')
				.selectField('FinServ__CountryOfResidence__pc')
				.selectField('Country_of_Birth__pc')
				.selectField('CASA_Analyst_Comments__c')
				.selectField('CASA_Screening_Date__c')
				.selectField('CASA_Screening_Status__c')
				.selectField('Gender__pc')
				.selectField('Occupation_Category__pc')
				.selectField('Client_Type__c')
				.selectField('Marital_Contract_Type__pc')
				.selectField('Non_Credit_Marketing_Consent__pc')
				.selectField('Communication_Method__c')
				.selectField('Non_Credit_Marketing_Indicator__pc')
				.selectField('MiddleName')
				.selectField('Income_Tax_Number__pc')
				.selectField('Employer_Name__pc')
				.selectField('OwnerId')
				.selectField('Preferred_Communication_Method__pc')
				.selectField('Preferred_Communication_Method__c')
				.selectField('Home_Language__pc')
				.selectField('Country_of_Origin__pc')
				.selectField('PersonContactId')
				.selectField('AccountNumber')
				.selectField('Registration_Number__c')
				.selectField('Site')
				.selectField('Name')
				.selectField('Income_Tax_Number__c')
				.selectField('VAT_Registration_Number__c')
				.selectField('Next_of_Kin_Cellphone_Number__pc')
				.selectField('Next_of_Kin_Email_Address__pc')
				.selectField('Next_of_Kin_First_Name_s__pc')
				.selectField('Next_of_Kin_Relationship__pc')
				.selectField('Next_of_Kin_Last_Name__pc')
				.selectField('Next_of_Kin_Telephone_Number__pc')
				.selectField('Language__c')
				.selectField('Source_of_Wealth_Capitalisation__c')
				.selectField('Country_of_Incorporation__c')
				.selectField('Country_Passport_Issued__pc')
				.selectField('Passport_Number__pc')
				.selectField('Monthly_Income__pc')
				.selectField('Monthly_Income__c')
				.selectField('Residential_Status__pc')
				.selectField('Is_the_Client_a_Temporary_Resident__c')
				.selectField('Trading_Name__c')
				.selectField('Website')
				.selectField('Country_of_Registration__c')
				.selectField('Credit_Worthiness_Consent__c')
				.selectField('Preferred_delivery_method_Legal_Notices__c')
				.selectField('Is_Marketing_Consent_Email__c')
				.selectField('Is_Marketing_Consent_Post__c')
				.selectField('Is_Marketing_Consent_SMS__c')
				.selectField('Is_Marketing_Consent_Phone__c')
				.selectField('Is_Marketing_Consent_voice_rec__c')
				.selectField('Credit_Marketing_Consent__pc')
				.selectField('Date_Established__c')
				.selectField('Date_Issued__pc')
				.selectField('Passport_Date_of_Issue__pc')
				.selectField('Insolvent_Debit_Review__pc')
				.selectField('Active_Email__c')
				.selectField('Fax')
				.selectField('Financial_Year_End__c')
				.selectField('Reason_For_Not_Providing_SA_Tax_Number__c')
				.selectField('Identify_the_account_holder_type__c')
				.selectField('Country_of_Citizenship__c')
				.selectField('What_is_the_intended_investment_term__c')
				.selectField('What_investment_experience_do_you_have__c')
				.selectField('Understand_financial_markets_and_invest__c')
				.selectField('investment_opportunities__c')
				.selectField('Number_of_dependants__c')
				.selectField('How_will_your_income_grow_in_relation_to__c')
				.selectField('liquidity_to_cover_emergencies__c')
				.selectField('Source_of_Income__c')
				.selectField('Banker_Name__c')
				.selectField('Bank_Name__c')
				.selectField('FinServ__BranchName__c')
				.selectField('Maiden_Name__pc')
				//selectField('SPM_Account_Type__c').
				//selectField('SPM_Account_Details__c').
				.selectField('Want_to_receive_companyproxy_other_issue__c')
				.selectField('SPM_Region__c')
				.selectField('Identified_by_Employee_Number__c')
				.selectField('Verified_by_Employee_Number__c')
				.selectField('Date_Identified__c')
				.selectField('Date_Verified__c')
				.selectField('Date_Established__c')
				.selectField('FSP_Number__c')
				.selectField('Name_of_FSP__c')
				.selectField('Named_Condition__c')
				.selectField('Certified_Copy_of_the_Licence_Received__c')
				.selectField('Conditions_and_Restrictions__c')
				.selectField('FAIS_Act__c')
				.selectField('Marketing_Consent_Info__c')
				.selectField('Marketing_Consent_SMS__c')
				.selectField('Marketing_Consent_Phone__c')
				.selectField('Passport_Expiry_Date__c')
				.selectField('share_information_to_third_party__c')
				.selectField('recordType.Name')
				.selectField('isPersonAccount') //Srikanth Nekkanti
				.selectField('Country_of_Foreign_tax__c')
				.selectField('Foreign_Tax_Number__c')
				.selectField('Client_Group__c')
				.selectField('Place_of_Birth_City_Town__c') // Tinashe - W-007975
				.setCondition('Id = :accountId')
				.selectField('Q1a_Client_affected_by_Regulation_3_1_F__c')
				.selectField('Q2a_Client_affected_by_Regulation_3_1_F__c')
				.selectField('Next_of_Kin_Initial__pc')
				.selectField('Credit_Marketing_Indicator__pc')
				.selectField('Standard_Industry_SIC_Code__c')
				.selectField('SIC_Classification_1__c')
				.selectField('SIC_Classification_2__c')
				.selectField('SIC_Classification_3__c')
				.selectField('Does_the_Client_fall_under_the_NCA__c')
				.selectField('Does_the_Client_fall_under_the_CPA__c')
				.selectField('Country_of_Operation__c')
				.selectField('PersonHomePhone')
				.selectField('Q1b_How_is_the_Client_Affected__c')
				.selectField('Q1c_Exchange_Control_Expiry_date__c')
				.selectField('Q2b_How_is_the_Client_Affected__c')
				.selectField('Q2c_Exchange_Control_Expiry_date__c')
				.selectField('Non_Credit_Marketing_Consent__pc')
				.selectField('Credit_Marketing_Consent__pc')
				.selectField('Country_of_Operation__c')
				.selectField('Q4a_Client_affected_by_Regulation_3_1_F__c')
				.selectField('Q4b_How_is_the_Client_Affected__c')
				.selectField('Q4c_Exchange_Control_Expiry_date__c')
				.selectField('Phone')
				.selectField('Statement_Preference__pc')
				.selectField('Country_of_Operation__c')
				.selectField('Foreign_Tax_Number__c')
				.selectField('Age__pc')
				.selectField('Nationality_List__pc')
				.selectField('Statement_Preference__pc')
				.selectField('Occupation_Level__pc')
				.selectField('Place_of_Residence__c')
				.selectField('FinServ__MailingAddress__pc')
				//selectField('Annual_turnover__c)').
				//selectField('Is_customer_registered_for_foreign_tax__c').
				//selectField('Is_customer_registered_for_income_tax__c').
				.setCondition('Id = :accountId')
				.selectField('Employer_Phone__c')
				.selectField('PersonOtherPhone')
				.selectField('Is_customer_registered_for_foreign_tax__c')
				.selectField('Is_customer_registered_for_income_tax__c')
				.selectField('Source_of_Income__pc')
				.selectField('CASA_Risk_Status__c')
				.selectField('DocumentAttestationOptions__c')
				.selectField('Client_Creation_Reason__c')
				.selectField('Contact_Method__pc')
				.selectField('Income_Tax_Number_Reason__pc')
				.selectField('SPM_Platform_Type__c')
				.selectField('Converted_Lead__pc')
				.selectField('Relationship_Banker_Name__r.Name') // added by saiteja for W-008750
				.selectField('DD_Source_of_Funds__pc') // added by saiteja for W-008750
				.selectField('Nature_of_Client__c') // added by saiteja for W-008750
				.selectField('SUIN__c') //Mohammed Junaid U
				.selectField('Relationship_Banker_Name__c') //BY Mohammed Junaid U to hide the PEP Status if it Non RBB Banker
				.selectField('Valid_Update_Bypass__c') // By Mohammed Junaid U to Bypass the validation
				.selectField('Owner.RBB_Super_Region__c') // Added by Sandeep Golla
				.selectField('Compliance_Status__c') // By Mohammed Junaid U to store compliance status in account object
				.selectField('Lock_Status__c') // By Mohammed Junaid U to store FIC Lock Status in account object
				.selectField('FICA_Requirements__c') // By Mohammed Junaid U to store FIC Documents and Missing fields
				.selectField('RecordType.DeveloperName') //By Mohammed Junaid U while checking for Casa Screening
				.selectField('Countries_Traded_With__c') //By Mohammed Junaid U while checking for Casa Screening
				.toSOQL()
		);
	}

	/**
	 * @description Method that get an account by account number
	 * @param accountId
	 * @return Account number
	 */
	public Account selectAllByIdFOrDocs(Id accountId) {
		return Database.query(
			newQueryFactory()
				.selectField('Description')
				.selectField('RecordTypeId')
				.selectField('PersonEmail')
				.selectField('CASA_Analyst_Comments__pc')
				.selectField('CASA_Reference_Number__pc')
				.selectField('CASA_Screening_Date__pc')
				.selectField('CASA_Screening_Status__pc')
				.selectField('CASA_Risk_Status__pc')
				.selectField('Occupation__pc')
				.selectField('Occupation_Status__pc')
				.selectField('Income_Source__pc')
				.selectField('BillingStreet')
				.selectField('BillingCity')
				.selectField('BillingPostalCode')
				.selectField('BillingCountry')
				.selectField('ShippingStreet')
				.selectField('ShippingCity')
				.selectField('ShippingCountry')
				.selectField('ShippingPostalCode')
				.selectField('PersonMobilePhone')
				.selectField('PersonHomePhone')
				.selectField('PersonOtherPhone')
				.selectField('PersonContactId')
				.selectField('Phone')
				.selectField('PersonBirthDate')
				.selectField('PersonTitle')
				.selectField('FinServ__Gender__pc')
				.selectField('FirstName')
				.selectField('ID_Number__pc')
				.selectField('LastName')
				.selectField('CIF__c')
				.selectField('FinServ__CountryOfBirth__pc')
				.selectField('Country_of_Residence__pc')
				.selectField('Income_Bracket__pc')
				.selectField('Communication_Language__pc')
				.selectField('Marital_Status__pc')
				.selectField('Nationality__pc')
				.selectField('Initials__pc')
				.selectField('CASA_Reference_Number__c')
				.selectField('ID_Type__pc')
				.selectField('ID_Type__c')
				.selectField('Territory__c')
				.selectField('CountryPassport__pc')
				.selectField('FinServ__CountryOfResidence__pc')
				.selectField('Country_of_Birth__pc')
				.selectField('CASA_Analyst_Comments__c')
				.selectField('CASA_Screening_Date__c')
				.selectField('CASA_Screening_Status__c')
				.selectField('Gender__pc')
				.selectField('Occupation_Category__pc')
				.selectField('Client_Type__c')
				.selectField('Marital_Contract_Type__pc')
				.selectField('Non_Credit_Marketing_Consent__pc')
				.selectField('Communication_Method__c')
				.selectField('Non_Credit_Marketing_Indicator__pc')
				.selectField('MiddleName')
				.selectField('Income_Tax_Number__pc')
				.selectField('Employer_Name__pc')
				.selectField('OwnerId')
				.selectField('Preferred_Communication_Method__pc')
				.selectField('Preferred_Communication_Method__c')
				.selectField('Preferred_Communication_Info__c')
				.selectField('Home_Language__pc')
				.selectField('Country_of_Origin__pc')
				.selectField('PersonContactId')
				.selectField('AccountNumber')
				.selectField('Registration_Number__c')
				.selectField('Customer_Accounts_closed_by_another_Bank__c')
				.selectField('If_Yes_please_provide_details__c')
				.selectField('Site')
				.selectField('Name')
				.selectField('Income_Tax_Number__c')
				.selectField('VAT_Registration_Number__c')
				.selectField('Next_of_Kin_Cellphone_Number__pc')
				.selectField('Next_of_Kin_Email_Address__pc')
				.selectField('Next_of_Kin_First_Name_s__pc')
				.selectField('Next_of_Kin_Relationship__pc')
				.selectField('Next_of_Kin_Last_Name__pc')
				.selectField('Next_of_Kin_Telephone_Number__pc')
				.selectField('Language__c')
				.selectField('Source_of_Wealth_Capitalisation__c')
				.selectField('Country_of_Incorporation__c')
				.selectField('Country_Passport_Issued__pc')
				.selectField('Passport_Number__pc')
				.selectField('Monthly_Income__pc')
				.selectField('Monthly_Income__c')
				.selectField('Residential_Status__pc')
				.selectField('Is_the_Client_a_Temporary_Resident__c')
				.selectField('Trading_Name__c')
				.selectField('Website')
				.selectField('Country_of_Registration__c')
				.selectField('Credit_Worthiness_Consent__c')
				.selectField('Preferred_delivery_method_Legal_Notices__c')
				.selectField('Is_Marketing_Consent_Email__c')
				.selectField('Is_Marketing_Consent_Post__c')
				.selectField('Is_Marketing_Consent_SMS__c')
				.selectField('Is_Marketing_Consent_Phone__c')
				.selectField('Is_Marketing_Consent_voice_rec__c')
				.selectField('Credit_Marketing_Consent__pc')
				.selectField('Date_Established__c')
				.selectField('Date_Issued__pc')
				.selectField('Passport_Date_of_Issue__pc')
				.selectField('Insolvent_Debit_Review__pc')
				.selectField('Active_Email__c')
				.selectField('Fax')
				.selectField('Financial_Year_End__c')
				.selectField('Reason_For_Not_Providing_SA_Tax_Number__c')
				.selectField('Identify_the_account_holder_type__c')
				.selectField('Country_of_Citizenship__c')
				.selectField('What_is_the_intended_investment_term__c')
				.selectField('What_investment_experience_do_you_have__c')
				.selectField('Understand_financial_markets_and_invest__c')
				.selectField('investment_opportunities__c')
				.selectField('Number_of_dependants__c')
				.selectField('Number_Of_Dependents__c')
				.selectField('How_will_your_income_grow_in_relation_to__c')
				.selectField('liquidity_to_cover_emergencies__c')
				.selectField('Source_of_Income__c')
				.selectField('Banker_Name__c')
				.selectField('Bank_Name__c')
				.selectField('FinServ__BranchName__c')
				//selectField('SPM_Account_Type__c').
				//selectField('SPM_Account_Details__c').
				.selectField('Want_to_receive_companyproxy_other_issue__c')
				.selectField('SPM_Region__c')
				.selectField('Identified_by_Employee_Number__c')
				.selectField('Verified_by_Employee_Number__c')
				.selectField('Date_Identified__c')
				.selectField('Date_Verified__c')
				.selectField('Date_Established__c')
				.selectField('FSP_Number__c')
				.selectField('Name_of_FSP__c')
				.selectField('Named_Condition__c')
				.selectField('Certified_Copy_of_the_Licence_Received__c')
				.selectField('Conditions_and_Restrictions__c')
				.selectField('FAIS_Act__c')
				.selectField('Marketing_Consent_Info__c')
				.selectField('Marketing_Consent_SMS__c')
				.selectField('Marketing_Consent_Phone__c')
				.selectField('Passport_Expiry_Date__c')
				.selectField('share_information_to_third_party__c')
				.selectField('recordType.Name')
				.selectField('isPersonAccount') //Srikanth Nekkanti
				.selectField('Country_of_Foreign_tax__c')
				.selectField('Foreign_Tax_Number__c')
				.selectField('Client_Group__c')
				.selectField('Place_of_Birth_City_Town__c') // Tinashe - W-007975
				.selectField('Sic')
				.selectField('Sub_Classification_Code__c')
				.selectField('Is_the_NPC_NGO_any_of_the_below__c')
				.selectField('Employer_Sector__pc')
				.selectField('Statement_Preference__pc')
				.selectField('Country_of_Birth__pc')
				.selectField('Country_of_Residence__pc')
				.selectField('Communication_Language__pc')
				.selectField('Industry')
				.selectField('Nature_of_Client__c')
				.selectField('SIC_Classification_1__c')
				.selectField('SIC_Classification_2__c')
				.selectField('SIC_Classification_3__c')
				.selectField('SIC_Classification_1_Percentage__c')
				.selectField('SIC_Classification_2_Percentage__c')
				.selectField('SIC_Classification_3_Percentage__c')
				.selectField('Does_the_Client_receive_Social_a_Grant__c')
				.selectField('Post_Matric_Qualification__pc')
				.selectField('Age__pc')
				.selectField('Trading_Name__c')
				.selectField('Countries_Traded_With__c')
				.selectField('Country_of_permanent_Residency__c')
				.selectField('Period_of_Visit__c')
				.selectField('Purpose_of_Visit__c')
				.selectField('Date_of_Arrival_in_South_Africa__c')
				.selectField('Temporary_resident_permit_number__c')
				.selectField('Temporary_Resident_Permit_Expiry_Date__c')
				.selectField('Is_the_Client_a_Non_resident__c')
				.selectField('US_person__c')
				.selectField('Client_ever_been_declared_Insolvent__c')
				.selectField('Under_Debt_Counselling__c')
				.selectField('Is_customer_registered_for_income_tax__c')
				.selectField('The_Client_is_involved_in_High_Risk_Indu__c')
				.selectField('Is_Customer_Multi_Banked__c')
				.selectField('Temporary_Resident_Permit__c')
				.selectField('Country_of_Incorporation__c')
				.selectField('Currently_Insolvent_Debit_Review__pc')
				.selectField('Insolvent_Debit_Review__pc')
				.selectField('Date_Registered_for_Foreign_Tax__c')
				.selectField('Trust_Number__c')
				.selectField('Trust_Number_New_format__c')
				.selectField('UBO_ParentAccountWrapper__c')
				.setCondition('Id = :accountId')
				.toSOQL()
		);
	}

	/**
	 * @description Method that gets a single account from and opportunity
	 *
	 * @param oppId - Opportunity ID
	 * @param recordLimit - recordLimit
	 * @return Account - single account with ID, RecordType, Email and PersonContactId
	 */
	public Account selectByOpportunityId(Id oppId, Integer recordLimit) {
		return Database.query(
			newQueryFactory()
				.selectField('PersonContactId')
				.selectField('ID_Number__pc')
				.selectField('Country_of_Residence__c')
				.selectField('SPM_Platform_Type__c')
				.selectField('Age__pc')
				.selectField('PersonBirthdate')
				.selectField('PersonEmail')
				.selectField('PersonMobilePhone')
				.setCondition('SicDesc')
				.selectField('Sub_Classification_Code__c')
				.selectField('Is_the_NPC_NGO_any_of_the_below__c')
				.selectField('Client_Type__c')
				.selectField('Id')
				.selectField('Name') //added by short term insurance
				.selectField('Agricultural_Sub_Type__c')
            	.selectField('Work_Phone__c')// Added for PRI
				.setCondition('Id =: oppId')
				.selectField('SicDesc')
				.setLimit(recordLimit)
				.toSOQL()
		);
	}

	/**
	 * @description Method that gets a single account from and opportunity
	 *
	 * @param personAccId - Opportunity ID
	 * @param recordLimit - Opportunity ID
	 * @return Account - single account with ID, RecordType, Email and PersonContactId
	 */
	public Account selectByOpportunityIdRel(Id personAccId, Integer recordLimit) {
		return Database.query(
			newQueryFactory()
				.selectField('PersonContactId')
				.selectField('Id')
				.selectField('FirstName')
				.selectField('Country_of_Residence__c')
				.selectField('BillingAddress')
				.selectField('LastNAme')
				.selectField('PersonTitle')
				.selectField('Initials__pc')
				.selectField('PersonContactId')
				.selectField('ID_Number__pc')
				.selectField('PersonBirthdate')
				.selectField('Gender__pc')
				.selectField('Client_Creation_Reason__c')
				.selectField('PersonMobilePhone')
				.selectField('PersonHomePhone')
				.selectField('Phone')
				.selectField('PersonEmail')
				.setCondition('PersonContactId =: personAccId')
				.setLimit(recordLimit)
				.toSOQL()
		);
	}

	/**
	 * @description Method that returns an Account based on Opportunity Id
	 *
	 * @param   oppId     The Opportunity Id
	 * @return  Account     The Account object record
	 */
	public Account selectIndvByOpportunityId(Id oppId) {
		Id oppAccId = new OpportunitiesSelector().selectByOpportunityId(oppId, 1).get(0).AccountId;

		return Database.query(
			newQueryFactory()
				.selectField('Age_years__c')
				.selectField('PersonContactId')
				.selectField('ID_Number__pc')
				.selectField('Age__pc')
				.selectField('Country_of_Residence__c')
				.selectField('Country_Passport_Issued__pc')
				.selectField('Occupation__pc')
				.selectField('ID_Type__c')
				.selectField('ID_Type__pc')
				.selectField('Passport_Number__pc')
				.selectField('Place_of_Residence__c')
				.selectField('Client_Type__c')
				.selectField('Trust_Number__c')
				.selectField('SDS_ID__c')
				.selectField('Preferred_Communication_Method__c')
				.selectField('Registration_Number__c')
				.selectField('Source_of_Income__c')
				.selectField('PersonBirthdate')
				.selectField('PersonEmail')
				.selectField('PersonMobilePhone')
				.selectField('VAT_Registration_Number__c')
				.selectField('CASA_Analyst_Comments__c')
				.selectField('CASA_Reference_Number__c')
				.selectField('CASA_Screening_Date__c')
				.selectField('CASA_Screening_Status__c')
				.selectField('CASA_Risk_Status__c')
				.selectField('CIF__c')
				.selectField('RecordType.Name')
				.selectField('BillingCity')
				.selectField('BillingPostalCode')
				.selectField('BillingCountry')
				.selectField('ShippingStreet')
				.selectField('ShippingCity')
				.selectField('ShippingCountry')
				.selectField('ShippingPostalCode')
				.selectField('Primary_Client__c')
				.selectField('Preferred_Communication_Info__c')
				.selectField('Client_Group__c')
				.selectField('Country_of_Incorporation__c')
				.selectField('Business_Start_Date__c')
				.selectField('Date_Established__c')
				.selectField('Business_Unit__c')
				.selectField('Standard_Industry_SIC_Category__c')
				.selectField('Standard_Industry_SIC_Code__c')
				.selectField('Business_Address_Line_1__c')
				.selectField('Business_Address_Line_2__c')
				.selectField('Financial_Year_End__c')
				.selectField('Id')
				.selectField('Income_Tax_Number__c')
				.selectField('Language__c')
				.selectField('AccountNumber')
				.selectField('AgriClass__c')
				.selectField('AgriClass_Percentage__c')
				.selectField('Foreign_Tax_Number__c')
				.selectField('Country_of_Foreign_tax__c')
				.selectField('SicDesc')
				.selectField('Source_of_Income__pc')
				.selectField('Source_of_Income__c')
				.selectField('Date_Verified__c')
				.selectField('Date_Identified__c')
				.selectField('Is_Marketing_Consent_Phone__c')
				.selectField('Is_Marketing_Consent_Email__c')
				.selectField('Is_Marketing_Consent_SMS__c')
				.selectField('Is_Marketing_Consent_Post__c')
				.selectField('Is_Marketing_Consent_voice_rec__c')
				.selectField('Credit_Marketing_Consent__pc')
				.selectField('Country_of_Operation__c')
				.selectField('Credit_Marketing_Indicator__pc')
				.selectField('Credit_Marketing_Consent__pc')
				.selectField('Country_of_Registration__c')
				.selectField('Date_Issued__pc')
				.selectField('Monthly_Income__pc')
				.selectField('Nationality__pc')
				.selectField('Is_the_Client_exempt_from_FICA__pc')
				.selectField('Next_of_Kin_Telephone_Number__pc')
				.selectField('Next_of_Kin_Initial__pc')
				.selectField('Next_of_Kin_First_Name_s__pc')
				.selectField('Next_of_Kin_Last_Name__pc')
				.selectField('Next_of_Kin_Relationship__pc')
				.selectField('Next_of_Kin_Cellphone_Number__pc')
				.selectField('Next_of_Kin_Email_Address__pc')
				.selectField('Credit_Worthiness_Consent__c')
				.selectField('Does_the_Client_receive_Social_a_Grant__c')
				.selectField('Does_the_Client_fall_under_the_CPA__c')
				.selectField('Does_the_Client_fall_under_the_NCA__c')
				.selectField('Post_Matric_Qualification__pc')
				.selectField('Is_Non_Credit_Marketing_Consent_Email__c')
				.selectField('Is_Non_Credit_Marketing_Consent_SMS__c')
				.selectField('Is_Non_Credit_Marketing_Consent_Phone__c')
				.selectField('Is_the_Client_a_Non_resident__c')
				.selectField('Is_the_Client_a_Temporary_Resident__c')
				.selectField('Is_Part_of_Franchise__c')
				.selectField('Non_Credit_Marketing_Consent_Email__c')
				.selectField('Non_Credit_Marketing_Consent_SMS__c')
				.selectField('Non_Credit_Marketing_Consent_Phone__c')
				.selectField('Trading_indicator__c')
				.selectField('Client_Intent_To_Go_Into_Business_Rescue__c')
				.selectField('Client_intends_to_declare_insolvency__c')
				.selectField('Client_ever_been_declared_Insolvent__c')
				.selectField('Client_is_a_stokvel__c')
				.selectField('Client_is_a_municipality__c')
				.selectField('Sic')
				.selectField('Marketing_Consent_Info__c')
				.selectField('Marketing_Consent_SMS__c')
				.selectField('Marketing_Consent_Phone__c')
				.selectField('Residential_Status_Address__c')
				.selectField('Residential_Status__pc')
				.selectField('Client_Agreement__c')
				.selectField('Number_Of_Dependents__c')
				.selectField('SIC_Classification_1__c')
				.selectField('SIC_Classification_1_Percentage__c')
				.selectField('SIC_Classification_2__c')
				.selectField('SIC_Classification_2_Percentage__c')
				.selectField('SIC_Classification_3__c')
				.selectField('SIC_Classification_3_Percentage__c')
				.selectField('Q4a_Client_affected_by_Regulation_3_1_F__c')
				.selectField('Q4b_How_is_the_Client_Affected__c')
				.selectField('Q4c_Exchange_Control_Expiry_date__c')
				.selectField('Q1a_Client_affected_by_Regulation_3_1_F__c')
				.selectField('Q1b_How_is_the_Client_Affected__c')
				.selectField('Q1c_Exchange_Control_Expiry_date__c')
				.selectField('Q2a_Client_affected_by_Regulation_3_1_F__c')
				.selectField('Q2b_How_is_the_Client_Affected__c')
				.selectField('Q2c_Exchange_Control_Expiry_date__c')
				.selectField('SPM_Region__c')
				.selectField('Residential_Status__c')
				.selectField('Date_Current_Address_Since__c')
				.selectField('Is_Client_Part_Of_Enter_Development_Fund__c')
				.selectField('Development_Fund_Partner_Client_Code__c')
				.selectField('Development_Fund_Name__c')
				.selectField('EDF_Code__c')
				.selectField('EDF_Name__c')
				.selectField('EDF_ReqCode__c')
				.selectField('EDF_ReqName__c')
				.selectField('Franchise_Code__c')
				.selectField('Franchise_Name__c')
				.selectField('Requested_Franchise_Code__c')
				.selectField('Requested_Franchise_Name__c')
				.selectField('Business_Rescue_Affected_Party__c')
				.selectField('Residential_Status__pc')
				.selectField('Client_Agreement__c')
				.selectField('Number_Of_Dependents__c')
				.selectField('SIC_Classification_1__c')
				.selectField('SIC_Classification_1_Percentage__c')
				.selectField('SIC_Classification_2__c')
				.selectField('SIC_Classification_2_Percentage__c')
				.selectField('SIC_Classification_3__c')
				.selectField('SIC_Classification_3_Percentage__c')
				.selectField('Q4a_Client_affected_by_Regulation_3_1_F__c')
				.selectField('Reason_For_Not_Providing_SA_Tax_Number__c')
				.selectField('FirstName') //added by short term insurance
				.selectField('LastName') //added by short term insurance
				.selectField('Monthly_Income__c') //added by short term insurance
				.selectField('Reason_For_Not_Providing_SA_Tax_Number__c') //added by short term insurance Place_of_Residence__c
				.selectField('Place_of_Residence__c') //added by short term insurance
				.selectField('Spouse_Account_Id__c')
				.selectField('Valid_Update_Bypass__c')
				.setCondition('Id =: oppAccId')
				.toSOQL()
		);
	}

	/**
	 * @description Method that returns an Account based on Opportunity Id
	 *
	 * @param   oppId     The Opportunity Id
	 * @return  Account     The Account object record
	 */
	public Account selectByOpportunityId(Id oppId) {
		Id oppAccId = new OpportunitiesSelector().selectByOpportunityId(oppId, 1).get(0).AccountId;

		return Database.query(
			newQueryFactory()
				.selectField('PersonContactId')
				.selectField('ID_Number__pc')
				.selectField('Age__pc')
				.selectField('Country_of_Residence__c')
				.selectField('ID_Type__c')
				.selectField('SPM_Platform_Type__c')
				.selectField('Preferred_Communication_Method__c')
				.selectField('Registration_Number__c')
				.selectField('Source_of_Income__c')
				.selectField('PersonBirthdate')
				.selectField('PersonEmail')
				.selectField('PersonMobilePhone')
				.selectField('VAT_Registration_Number__c')
				.selectField('CASA_Analyst_Comments__c')
				.selectField('CASA_Reference_Number__c')
				.selectField('CASA_Screening_Date__c')
				.selectField('CASA_Screening_Status__c')
				.selectField('CASA_Risk_Status__c')
				.selectField('CIF__c')
				.selectField('RecordType.Name')
				.selectField('BillingCity')
				.selectField('BillingPostalCode')
				.selectField('BillingCountry')
				.selectField('ShippingStreet')
				.selectField('ShippingCity')
				.selectField('ShippingCountry')
				.selectField('ShippingPostalCode')
				.selectField('Primary_Client__c')
				.selectField('Preferred_Communication_Info__c')
				.selectField('Client_Group__c')
				.selectField('Client_Type__c')
				.selectField('Trust_Number__c')
				.selectField('Country_of_Incorporation__c')
				.selectField('Date_Established__c')
				.selectField('Business_Unit__c')
				.selectField('Standard_Industry_SIC_Code__c')
				.selectField('Standard_Industry_SIC_Category__c')
				.selectField('Standard_Industry_SIC_Code__c')
				.selectField('Business_Address_Line_1__c')
				.selectField('Business_Address_Line_2__c')
				.selectField('Financial_Year_End__c')
				.selectField('Id')
				.selectField('Income_Tax_Number__c')
				.selectField('Language__c')
				.selectField('AccountNumber')
				.selectField('AgriClass__c')
				.selectField('AgriClass_Percentage__c')
				.selectField('Foreign_Tax_Number__c')
				.selectField('Country_of_Foreign_tax__c')
				.selectField('SicDesc')
				.selectField('Source_of_Income__pc')
				.selectField('Source_of_Income__c')
				.selectField('Date_Verified__c')
				.selectField('Date_Identified__c')
				.selectField('Is_Marketing_Consent_Phone__c')
				.selectField('Is_Marketing_Consent_Email__c')
				.selectField('Is_Marketing_Consent_SMS__c')
				.selectField('Is_Marketing_Consent_Post__c')
				.selectField('Is_Marketing_Consent_voice_rec__c')
				.selectField('Credit_Marketing_Consent__pc')
				.selectField('Country_of_Operation__c')
				.selectField('Country_of_Operation__c')
				.selectField('Credit_Marketing_Indicator__pc')
				.selectField('Credit_Marketing_Consent__pc')
				.selectField('Non_Credit_Marketing_Indicator__pc')
				.selectField('Credit_Marketing_Consent__pc')
				.selectField('Country_of_Registration__c')
				.selectField('Date_Issued__pc')
				.selectField('Monthly_Income__pc')
				.selectField('Name')
				.selectField('FirstName')
				.selectField('MiddleName')
				.selectField('LastName')
				.selectField('SIC_Classification_1__c')
				.selectField('SIC_Classification_1_Percentage__c')
				.selectField('SIC_Classification_2__c')
				.selectField('SIC_Classification_2_Percentage__c')
				.selectField('SIC_Classification_3__c')
				.selectField('SIC_Classification_3_Percentage__c')
				.selectField('Does_the_Client_fall_under_the_CPA__c')
				.selectField('Q4a_Client_affected_by_Regulation_3_1_F__c')
				.selectField('Q4b_How_is_the_Client_Affected__c')
				.selectField('Q4c_Exchange_Control_Expiry_date__c')
				.selectField('Q1a_Client_affected_by_Regulation_3_1_F__c')
				.selectField('Q1b_How_is_the_Client_Affected__c')
				.selectField('Q1c_Exchange_Control_Expiry_date__c')
				.selectField('Q2a_Client_affected_by_Regulation_3_1_F__c')
				.selectField('Q2b_How_is_the_Client_Affected__c')
				.selectField('Q2c_Exchange_Control_Expiry_date__c')
				.selectField('Country_Passport_Issued__pc')
				.selectField('Q3a_Client_affected_by_Regulation_3_1_F__c') //Manoj- W-008510 - 12212020
				.selectField('Q3b_How_is_the_Client_Affected__c')
				.selectField('Q3c_Exchange_Control_Expiry_date__c')
				.selectField('FinServ__RelationshipStartDate__c')
				.selectField('Sic')
				//selectField('Client_intends_to_declare_insolvency__c').
				.selectField('Client_ever_been_declared_Insolvent__c')
				//selectField('Client_is_a_stokvel__c').
				//selectField('Client_is_a_municipality__c').
				//selectField('Trading_indicator__c').
				.selectField('Marketing_Consent_Info__c')
				.selectField('Marketing_Consent_SMS__c')
				.selectField('Marketing_Consent_Phone__c')
				.selectField('Credit_Worthiness_Consent__c')
				.selectField('Sub_Classification_Code__c')
				.selectField('Is_the_NPC_NGO_any_of_the_below__c')
				.selectField('Banker_Name__c')
				.selectField('FinServ__BranchName__c')
				.selectField('SPM_region__c')
				.selectField('Passport_Expiry_Date__c')
				.selectField('Want_to_receive_companyproxy_other_issue__c')
				//selectField('Non_Credit_Marketing_Consent_SMS__c').
				//selectField('Non_Credit_Marketing_Consent_Phone__c').
				.selectField('Is_Non_Credit_Marketing_Consent_Email__c')
				.selectField('Is_Non_Credit_Marketing_Consent_SMS__c')
				.selectField('Is_Non_Credit_Marketing_Consent_Phone__c')
				.selectField('Non_Credit_Marketing_Consent_Email__c')
				.selectField('Non_Credit_Marketing_Consent_SMS__c')
				.selectField('Non_Credit_Marketing_Consent_Phone__c')
				.selectField('Trading_indicator__c')
				.selectField('Client_intends_to_declare_insolvency__c')
				.selectField('Client_ever_been_declared_Insolvent__c')
				.selectField('Client_is_a_stokvel__c')
				.selectField('Client_is_a_municipality__c')
				.selectField('Is_the_Client_a_Non_resident__c')
				.selectField('Is_the_Client_a_Temporary_Resident__c')
				.selectField('Identified_by_Employee_Number__c')
				.selectField('Verified_by_Employee_Number__c')
				.selectField('RecordType.DeveloperName')
				.selectField('AuthMessage__c')
				.selectField('Agricultural_Sub_Type__c')
				.setCondition('Id =: oppAccId')
				.selectField('Client_intends_to_declare_insolvency__c')
				.selectField('Client_is_a_stokvel__c')
				.selectField('Client_is_a_municipality__c')
				.selectField('Trading_indicator__c')
				.selectField('Employer_Sector__pc')
				.selectField('Employer_Phone__c')
				.selectField('Occupation_Level__pc')
				.selectField('Number_Of_Dependents__c')
				.selectField('Highest_Qualification__pc')
				.selectField('Residential_Status__pc')
				.selectField('Monthly_Income__c') //W-006976
				.selectField('Does_the_Client_fall_under_the_NCA__c')
				.selectField('Reason_For_Not_Providing_SA_Tax_Number__c')
				.selectField('Preferred_delivery_method_Legal_Notices__c')
				.selectField('SPM_Platform_Type__c')
				.selectField('Country_Passport_Issued__pc')
				.selectField('Gender__pc')
				.selectField('ID_Type__pc')
				.selectField('Country_of_Birth__pc')
				.selectField('Nationality__pc')
				.selectField('Initials__pc')
				.selectField('Phone')
				.selectField('Place_of_Residence__c')
				.selectField('Valid_Update_Bypass__c')
				.setCondition('Id =: oppAccId')
				.toSOQL()
		);
	}

	/**
	 * @description Method that gets a single account for update
	 *
	 * @param accId - Opportunity ID
	 * @param recordLimit - Opportunity ID
	 * @return Account - single account with ID, RecordType, Email and PersonContactId
	 */
	public Account selectByAccountId(Id accId, Integer recordLimit) {
		return Database.query(newQueryFactory(false).selectField('Id').selectField('Name').setCondition('id = :accId').setLimit(recordLimit).toSOQL());
	}

	/**## Added for W-008188
	 * @description Method that gets a specific Account fields
	 *
	 * @param accId - Account ID
	 * @return Account - accounts with required fields
	 */
	public Account selectFinancialStatementRedirectFieldsById(Id accId) {
		return Database.query(
			newQueryFactory()
				.selectField('Id')
				.selectField('Name')
				.selectField('CIF__c')
				.selectField('FirstName')
				.selectField('LastName')
				.selectField('Client_Type__c')
				.setCondition('Id = :accId')
				.toSOQL()
		);
	}

	/**
	 * @description Method that gets a list of CASA specific Account fields
	 *
	 * @param accId - Account ID
	 * @param recordLimit - Account ID
	 * @return List <Account> - list accounts with CASA fields
	 * W-005355 : Anka Ganta : 2020-07-09 : added : Country_of_Incorporation__c
	 */
	public List<Account> selectCasaFieldsById(Id accId, Integer recordLimit) {
		return Database.query(
			newQueryFactory()
				.selectField('Id')
				.selectField('FirstName')
				.selectField('LastName')
				//selectField('Name').
				.selectField('ID_Type__pc')
				.selectField('ID_Type__c')
				.selectField('ID_Number__pc')
				.selectField('Client_Group__c')
				.selectField('Client_Type__c')
				.selectField('PersonBirthdate')
				.selectField('Nationality__pc')
				.selectField('ShippingCity')
				.selectField('Country_of_Residence__pc')
				.selectField('Country_of_Birth__pc')
				.selectField('Country_of_Registration__c')
				.selectField('Country_of_Origin__pc')
				.selectField('Passport_Number__pc')
				.selectField('CASA_Analyst_Comments__c')
				.selectField('CASA_Reference_Number__c')
				.selectField('CASA_Screening_Date__c')
				.selectField('CASA_Screening_Status__c')
				.selectField('Countries_Traded_With__c')
				.selectField('Marital_Contract_Type__pc')
				.selectField('Non_Credit_Marketing_Consent__pc')
				.selectField('Non_Credit_Marketing_Indicator__pc')
				.selectField('Credit_Marketing_Consent__pc')
				.selectField('Credit_Marketing_Indicator__pc')
				.selectField('Communication_Method__c')
				.selectField('MiddleName')
				.selectField('Income_Tax_Number__pc')
				.selectField('CIF__c')
				.selectField('RecordType.Name')
				.selectField('RecordType.DeveloperName')
				.selectField('Preferred_Communication_Method__pc')
				.selectField('Monthly_Income__pc')
				.selectField('PersonContactId')
				.selectField('CASA_Analyst_Comments__c')
				.selectField('CASA_Reference_Number__c')
				.selectField('CASA_Reference_Number__pc')
				.selectField('Date_Issued__pc')
				.selectField('Primary_Client__c')
				.selectField('Registration_Number__c')
				.selectField('pepSts__c')
				.selectField('BillingStreet')
				.selectField('BillingCity')
				.selectField('BillingPostalCode')
				.selectField('BillingCountry')
				.selectField('BillingState')
				.selectField('ShippingStreet')
				.selectField('Source_of_Income__c')
				.selectField('PEP_Status__pc')
				.selectField('Complex_Contact__c') // added by Masechaba Maseli
				.selectField('Country_of_Incorporation__c')
				.selectField('PEP_Status__c')
				.selectField('FraudRiskAlert__c') //W-003718 - Manoj - Fraud Risk Screening
				.selectField('FraudRiskActionTaken__c') //W-003718 - Manoj - Fraud Risk Screening
				.selectField('Trading_Name__c')
				.setCondition('Id = :accId')
				.setLimit(recordLimit)
				.toSOQL()
		);
	}

	/**
	 * @description Method that gets a list of CASA specific Account fields
	 *
	 * W-04045 This method is added for Onboarding process to evoid confilt with WILLS process.
	 * @param accId - Account ID
	 * @param recordLimit - Account ID
	 * @return List <Account> - list accounts with CASA fields
	 *
	 * W-004987 by Masechaba Maseli added additional fields for the second CASA Screening
	 */
	public List<Account> selectCasaFieldsByIds(Id accId, Integer recordLimit) {
		return Database.query(
			newQueryFactory()
				.selectField('Id')
				.selectField('FirstName')
				.selectField('LastName')
				.selectField('PersonTitle')
				.selectField('Name')
				.selectField('ID_Type__pc')
				.selectField('ID_Type__c')
				.selectField('Trust_Number__c')
				.selectField('ID_Number__pc')
				.selectField('Client_Group__c')
				.selectField('Client_Type__c')
				.selectField('PersonBirthdate')
				.selectField('Nationality__pc')
				.selectField('ShippingCity')
				.selectField('Country_of_Residence__pc')
				.selectField('Country_of_Birth__pc')
				.selectField('Country_of_Registration__c')
				.selectField('Country_of_Origin__pc')
				.selectField('Passport_Number__pc')
				.selectField('CASA_Analyst_Comments__c')
				.selectField('CASA_Reference_Number__c')
				.selectField('CASA_Screening_Date__c')
				.selectField('CASA_Screening_Status__c')
				.selectField('CASA_Risk_Status__c') //Manoj - 11132020 - SIT Bug Fix
				.selectField('Countries_Traded_With__c')
				.selectField('Marital_Contract_Type__pc')
				.selectField('Non_Credit_Marketing_Consent__pc')
				.selectField('Non_Credit_Marketing_Indicator__pc')
				.selectField('Credit_Marketing_Consent__pc')
				.selectField('Credit_Marketing_Indicator__pc')
				.selectField('Communication_Method__c')
				.selectField('MiddleName')
				.selectField('Gender__pc')
				.selectField('Income_Tax_Number__pc')
				.selectField('CIF__c')
				.selectField('RecordType.Name')
				.selectField('RecordType.DeveloperName')
				.selectField('Preferred_Communication_Method__pc')
				.selectField('Monthly_Income__pc')
				.selectField('PersonContactId')
				.selectField('CASA_Analyst_Comments__c')
				.selectField('CASA_Reference_Number__c')
				.selectField('Date_Issued__pc')
				.selectField('Primary_Client__c')
				.selectField('Registration_Number__c')
				.selectField('pepSts__c')
				.selectField('Source_of_Income__c')
				.selectField('The_Client_is_involved_in_High_Risk_Indu__c')
				.selectField('PEP_Status__pc')
				.selectField('Sic')
				.selectField('Standard_Industry_SIC_Code__c')
				.selectField('Preferred_Communication_Method__c')
				.selectField('Language__c')
				.selectField('Phone')
				.selectField('BillingStreet')
				.selectField('BillingCity')
				.selectField('BillingPostalCode')
				.selectField('BillingCountry')
				.selectField('BillingState')
				.selectField('ShippingStreet')
				.selectField('Income_Tax_Number__c')
				.selectField('Marketing_Consent_Info__c')
				.selectField('VAT_Registration_Number__c')
				.selectField('Country_of_Incorporation__c')
				.selectField('Country_of_Operation__c')
				.selectField('Does_the_Client_fall_under_the_CPA__c')
				.selectField('Q4a_Client_affected_by_Regulation_3_1_F__c')
				.selectField('Q4b_How_is_the_Client_Affected__c')
				.selectField('Q4c_Exchange_Control_Expiry_date__c')
				.selectField('Q1a_Client_affected_by_Regulation_3_1_F__c')
				.selectField('Q1b_How_is_the_Client_Affected__c')
				.selectField('Q1c_Exchange_Control_Expiry_date__c')
				.selectField('Q2a_Client_affected_by_Regulation_3_1_F__c')
				.selectField('Q2b_How_is_the_Client_Affected__c')
				.selectField('Q2c_Exchange_Control_Expiry_date__c')
				.selectField('Country_of_Citizenship__c') // W-004987
				.selectField('CASA_Reference_Number2__c') // W-004987
				.selectField('CASA_Screening_Date2__c') // W-004987
				.selectField('CASA_Screening_Status_2__c') // W-004987
				.selectField('PEP_Status__c')
				.selectField('Sub_Classification_Code__c')
				.selectField('Is_the_NPC_NGO_any_of_the_below__c')
				.selectField('FraudRiskAlert__c') //W-003718
				.selectField('FraudRiskActionTaken__c') //W-003718
				.selectField('Work_Item_Classification__c') //W-0010160
				.selectField('Fraud_Status__c')
				.selectField('Country_Passport_Issued__pc')
				.selectField('Monthly_Income__c')
				.selectField('Marital_Status__pc')
				.selectField('Number_Of_Dependents__c')
				.selectField('Income_Tax_Number__c')
				.selectField('Temporary_resident_permit_number__c')
				.selectField('Post_Matric_Qualification__pc')
				.selectField('ByPassValidationInApex__c') //W-8562
				.selectField('Process_Type__c') //W-8562
				.selectField('NumberofClosedOpportunities__c') //W-8562
				.selectField('UBO_ParentAccountWrapper__c')
				.selectField('Trust_Number__c')
                .selectField('Trust_Number_New_format__c')
                .selectField('Registration_Number__c')
				.setCondition('Id = :accId')
				.setLimit(recordLimit)
				.toSOQL()
		);
	}

	/**
	 * @description Method that gets a list of CASA specific Account fields
	 *
	 * @param accId - Account ID
	 * @param recordLimit - recordLimit ID
	 * @return List <Account> - list accounts with CASA fields
	 */
	public List<Account> selectCasaIndividualFieldsById(Id accId, Integer recordLimit) {
		return Database.query(
			newQueryFactory()
				.selectField('Id')
				.selectField('FirstName')
				.selectField('LastName')
				.selectField('ID_Type__pc')
				.selectField('ID_Type__c')
				.selectField('ID_Number__pc')
				.selectField('Client_Group__c')
				.selectField('Client_Type__c')
				.selectField('PersonBirthdate')
				.selectField('Nationality__pc')
				.selectField('ShippingCity')
				.selectField('Country_of_Residence__pc')
				.selectField('Country_of_Birth__pc')
				.selectField('Country_of_Registration__c')
				.selectField('Country_of_Origin__pc')
				.selectField('Passport_Number__pc')
				.selectField('CASA_Analyst_Comments__c')
				.selectField('CASA_Reference_Number__pc')
				.selectField('CASA_Screening_Date__pc')
				.selectField('CASA_Screening_Status__pc')
				.selectField('PEP_Status__pc')
				.selectField('Countries_Traded_With__c')
				.selectField('Marital_Contract_Type__pc')
				.selectField('Non_Credit_Marketing_Consent__pc')
				.selectField('Non_Credit_Marketing_Indicator__pc')
				.selectField('Credit_Marketing_Consent__pc')
				.selectField('Credit_Marketing_Indicator__pc')
				.selectField('Communication_Method__c')
				.selectField('Source_of_Income__c')
				.selectField('MiddleName')
				.selectField('Income_Tax_Number__pc')
				.selectField('CIF__c')
				.selectField('RecordType.Name')
				.selectField('RecordType.DeveloperName')
				.selectField('Preferred_Communication_Method__pc')
				.selectField('Monthly_Income__pc')
				.selectField('PersonContactId')
				.selectField('CASA_Analyst_Comments__c')
				.selectField('CASA_Reference_Number__c')
				.selectField('Date_Issued__pc')
				.selectField('Primary_Client__c')
				.selectField('Registration_Number__c')
				.selectField('pepSts__c')
				.selectField('Casa_Sequence_Number__c')
				.selectField('Casa_Status__c')
				.selectField('Valid_Update_Bypass__c') //W-12037
				.setCondition('Id = :accId')
				.setLimit(recordLimit)
				.toSOQL()
		);
	}

	/**
	 * @description Method that gets a list of CASA specific Account fields
	 *
	 * @param accId - set ofAccount ID
	 * @return List <Account> - list accounts with CASA fields
	 */
	public List<Account> selectCasaFieldsBySetId(Set<Id> accId) {
		return Database.query(
			newQueryFactory()
				.selectField('Id')
				.selectField('FirstName')
				.selectField('LastName')
				.selectField('PersonTitle')
				.selectField('ID_Type__pc')
				.selectField('ID_Type__c')
				.selectField('ID_Number__pc')
				.selectField('Registration_Number__c')
				.selectField('Client_Type__c')
				.selectField('Client_Group__c')
				.selectField('PersonBirthdate')
				.selectField('Nationality__pc')
				.selectField('ShippingCity')
				.selectField('Country_of_Residence__pc')
				.selectField('Country_of_Birth__pc')
				.selectField('Country_of_Registration__c')
				.selectField('Country_of_Incorporation__c')
				.selectField('Country_of_Origin__pc')
				.selectField('Passport_Number__pc')
				.selectField('CASA_Analyst_Comments__c')
				.selectField('CASA_Reference_Number__c')
				.selectField('CASA_Screening_Date__c')
				.selectField('CASA_Screening_Status__c')
				.selectField('Countries_Traded_With__c')
				.selectField('Marital_Contract_Type__pc')
				.selectField('Non_Credit_Marketing_Consent__pc')
				.selectField('Non_Credit_Marketing_Indicator__pc')
				.selectField('Credit_Marketing_Consent__pc')
				.selectField('Credit_Marketing_Indicator__pc')
				.selectField('Communication_Method__c')
				.selectField('MiddleName')
				.selectField('Income_Tax_Number__pc')
				.selectField('CIF__c')
				.selectField('RecordType.Name')
				.selectField('Preferred_Communication_Method__pc')
				.selectField('Monthly_Income__pc')
				.selectField('BillingStreet')
				.selectField('BillingCity')
				.selectField('BillingPostalCode')
				.selectField('BillingCountry')
				.selectField('BillingState')
				.selectField('ShippingStreet')
				.selectField('PersonContactId')
				.selectField('CASA_Analyst_Comments__c')
				.selectField('Date_Issued__pc')
				.selectField('Primary_Client__c')
				.selectField('Customer_On_boarded_via_Customer_One__c')
				.setCondition('Id In :accId')
				.toSOQL()
		);
	}

	/**
	 * @description Method that gets a list of CASA specific Account fields
	 *
	 * @param accId - Account ID
	 * @param recordLimit - Account ID
	 * @return List <Account> - list accounts with CASA fields
	 */
	public List<Account> selectCasaFieldsJointAccountById(Id accId, Integer recordLimit) {
		return Database.query(
			newQueryFactory()
				.selectField('Id')
				.selectField('ID_Type__pc')
				.selectField('ID_Number__pc')
				.selectField('Trust_Number__c')
				.selectField('Client_Type__c')
				.selectField('PersonBirthdate')
				.selectField('Nationality__pc')
				.selectField('ShippingCity')
				.selectField('Country_of_Residence__pc')
				.selectField('Country_of_Birth__pc')
				.selectField('Country_of_Registration__c')
				.selectField('CASA_Analyst_Comments__c')
				.selectField('CASA_Reference_Number__c')
				.selectField('CASA_Screening_Date__c')
				.selectField('CASA_Screening_Status__c')
				.selectField('CASA_Risk_Status__c') //Manoj - 11132020 - SIT Bug Fix
				.selectField('CIF__c')
				.selectField('RecordType.Name')
				.selectField('RecordType.DeveloperName')
				.selectField('Name')
				.selectField('OwnerId')
				.selectField('Gender__pc')
				.selectField('Communication_Language__pc')
				.selectField('Marital_Contract_Type__pc')
				.selectField('Marital_Status__pc')
				.selectField('Non_Credit_Marketing_Consent__pc')
				.selectField('Non_Credit_Marketing_Indicator__pc')
				.selectField('Credit_Marketing_Consent__pc')
				.selectField('Credit_Marketing_Indicator__pc')
				.selectField('Occupation_Status__pc')
				.selectField('Occupation_Category__pc')
				.selectField('Preferred_Communication_Method__pc')
				.selectField('BillingStreet')
				.selectField('BillingCity')
				.selectField('BillingPostalCode')
				.selectField('BillingCountry')
				.selectField('BillingState')
				.selectField('ShippingStreet')
				.selectField('ShippingCity')
				.selectField('ShippingCountry')
				.selectField('ShippingPostalCode')
				.selectField('Registration_Number__c')
				.selectField('Primary_Client__c')
				.selectField('ID_Type__c')
				.selectField('Preferred_Communication_Info__c')
				.selectField('Client_Group__c')
				.selectField('Country_of_Incorporation__c')
				.selectField('Date_Established__c')
				.selectField('Business_Unit__c')
				.selectField('Standard_Industry_SIC_Category__c')
				.selectField('Standard_Industry_SIC_Code__c')
				.selectField('Business_Address_Line_1__c')
				.selectField('Business_Address_Line_2__c')
				.selectField('VAT_Registration_Number__c')
				.selectField('Financial_Year_End__c')
				.selectField('Source_of_Income__c')
				.selectField('Valid_Update_Bypass__c') //W-12037
				.setCondition('Id = :accId')
				.setLimit(recordLimit)
				.toSOQL()
		);
	}

	/**
	 * @description Method that gets a list of CASA specific Account fields
	 *
	 * @param personContactIdSet of - PersonContact ID's
	 * @return List <Account> - list accounts with CASA fields
	 */
	public List<Account> selectCasaFieldsByPersonContactSetId(Set<Id> personContactIdSet) {
		return (List<Account>) Database.query(
			newQueryFactory()
				.selectField('Name')
				//.selectField('Name')
				.selectField('FirstName')
				.selectField('MiddleName') //W-010679
				.selectField('LastName')
				.selectField('RecordType.Name')
				.selectField('CASA_Screening_Status__pc')
				.selectField('CASA_Screening_Date__pc')
				.selectField('CASA_Reference_Number__pc')
				.selectField('Country_of_Residence__c')
				.selectField('pepSts__c')
				.selectField('ID_Type__pc')
				.selectField('ID_Type__c')
				.selectField('ID_Number__pc')
				.selectField('BillingStreet')
				.selectField('BillingCity')
				.selectField('BillingPostalCode')
				.selectField('BillingCountry')
				.selectField('BillingState')
				.selectField('ShippingStreet')
				.selectField('Passport_Number__pc')
				.selectField('PersonTitle')
				.selectField('Initials__pc')
				.selectField('PEP_Status__pc') //added By Anka
				.selectField('Country_of_Citizenship__c') // W-004987
				.selectField('CASA_Reference_Number2__c') // W-004987
				.selectField('CASA_Screening_Date2__c') // W-004987
				.selectField('CASA_Screening_Status_2__c') // W-004987
				.selectField('ByPassValidationInApexPer__pc') // W-007479
				.selectField('RelPartyWithClosedOpportunity__pc') // W-007479
				.selectField('Process_Type__c') // W-007479
				.selectField('IsClosedOpportunity__pc') // W-007479
				.selectField('Casa_Status__c')
				.selectField('Registration_Number__c')
				.selectField('PersonBirthdate')
				.selectField('PersonHomePhone')
				.selectField('Employer_Name__pc')
				.selectField('Country_Passport_Issued__pc')
				.selectField('Residential_Status__pc')
				.selectField('PersonEmail')
				.selectField('Marital_Status__pc')
				.selectField('Risk_Status__c')
				.selectField('Fraud_Status__c')
				.setCondition('PersonContactId In :personContactIdSet')
				.toSOQL()
			);
		}

	/**
	 * @description Method that gets a list of CASA specific Account fields
	 *
	 * @param accountId of - PersonContact ID's
	 * @return List <Account> - list accounts with CASA fields
	 */
	public List<Account> selectRelatedPartyCASAByAccountId(Id accountId) {
		return Database.query(
			newQueryFactory()
				.selectField('CASA_Screening_Status__pc')
				.selectField('CASA_Screening_Date__pc')
				.selectField('CASA_Reference_Number__pc')
				.selectField('Country_of_Citizenship__c') // W-004987
				.selectField('CASA_Reference_Number2__c') // W-004987
				.selectField('CASA_Screening_Date2__c') // W-004987
				.selectField('CASA_Screening_Status_2__c') // W-004987
				.selectField('ID_Type__pc') // added by Short term Insurance
				.selectField('Initials__pc') // added by Short term Insurance
				.selectField('ID_Number__pc') // added by Short term Insurance
				.selectField('FinServ__Gender__pc') // added by Short term Insurance
				.selectField('Nationality__pc') // added by Short term Insurance
				.selectField('Occupation__pc') // added by Short term Insurance
				.selectField('Occupation_Status__pc') // added by Short term Insurance
				.selectField('PersonMobilePhone') // added by Short term Insurance
				.selectField('PersonHomePhone') // added by Short term Insurance
				.selectField('Valid_Update_Bypass__c') // W-12037
				.setCondition('id = :accountId')
				.toSOQL()
		);
	}

	/**
	 * @description Method that gets a list of Risk rating specific Account fields
	 *
	 * @param accId - Account ID
	 * @param recordLimit - Account ID
	 * @return List <Account> - list accounts with Risk fields
	 */
	public List<Account> selectRiskFieldsById(Id accId, Integer recordLimit) {
		return Database.query(
			newQueryFactory()
				.selectField('Id')
				.selectField('Occupation__pc')
				.selectField('Occupation_Category__pc')
				.selectField('Occupation_Status__pc')
				.selectField('Income_Source__pc')
				.selectField('CASA_Reference_Number__c')
				.selectField('Countries_Traded_With__c')
				.selectField('RecordType.Name')
				.setCondition('id = :accId')
				.setLimit(recordLimit)
				.toSOQL()
		);
	}

	/**
	 * @description Method that gets a list of all email specific Account fields
	 *
	 * @param accId - Account ID
	 * @param recordLimit - recordLimit
	 * @return List <Account> - list accounts with Email fields
	 */
	public List<Account> selectEmailFieldsById(Id accId, Integer recordLimit) {
		return Database.query(
			newQueryFactory(false)
				.selectField('Id')
				.selectField('FirstName')
				.selectField('LastName')
				.selectField('PersonEmail')
				.selectField('PersonContactId')
				.selectField('Alternative_Email__c')
				.selectField('Alternative_Email_1__c')
				.selectField('Alternative_Email_2__c')
				.selectField('Alternative_Email_3__c')
				.selectField('Alternative_Email_4__c')
				.selectField('CIF__c')
				.selectField('Client_Type__c')
				.selectField('Active_Email__c')
				.selectField('PersonMobilePhone')
				.setCondition('Id = :accId')
				.setLimit(recordLimit)
				.toSOQL()
		);
	}

	/**
	 * @description Method that gets a list of all phone specific Account fields
	 *
	 * @param accId - Account ID
	 * @param recordLimit recordLimit
	 * @return List <Account> - list accounts with Phone fields
	 */
	public List<Account> selectPhoneFieldsById(Id accId, Integer recordLimit) {
		return Database.query(
			newQueryFactory(false)
				.selectField('Id')
				.selectField('FirstName')
				.selectField('LastName')
				.selectField('PersonMobilePhone')
				.selectField('PersonContactId')
				.selectField('Client_Type__c')
				.setCondition('Id = :accId')
				.setLimit(recordLimit)
				.toSOQL()
		);
	}

	/**
	 * @description Return Accounts by Account Name
	 *
	 * @param names Set<String> Account names
	 * @return List<Account>
	 */
	public List<Account> selectByName(Set<String> names) {
		fflib_QueryFactory query = newQueryFactory();
		query.setCondition('Name IN :names');
		return (List<Account>) Database.query(query.toSOQL());
	}

	/**
	 * @description Return Accounts by Account Parent Id's
	 *
	 * @param idSet Set<String> Account Id's
	 * @param recordLimit String max records to return
	 * @return List<Account>
	 */
	public List<Account> selectByParentId(Set<Id> idSet, Integer recordLimit) {
		return (List<Account>) Database.query(newQueryFactory().selectField('Parent.Name').setCondition('ParentId IN :idSet').setLimit(recordLimit).toSOQL());
	}

	/**
	 * @description Return Accounts by Name
	 *
	 * @param searchValue String
	 * @param recordLimit String max records to return
	 * @return List<Account>
	 */
	public List<Account> selectByName(String searchValue, Integer recordLimit) {
		String searchValueTemp = '%' + searchValue + '%';
		return (List<Account>) Database.query(
			newQueryFactory()
				.selectField('CIF__c')
				.selectField('isPersonAccount')
				.selectField('PersonContactId')
				.selectField('FirstName')
				.selectField('LastName')
				.selectField('Salutation')
				.selectField('ID_Number__pc')
				.selectField('Communication_Method__c')
				.selectField('PersonMobilePhone')
				.selectField('PersonHomePhone')
				.selectField('Phone')
				.selectField('PersonEmail')
				.selectField('ShippingStreet')
				.selectField('ShippingCity')
				.selectField('ShippingPostalCode')
				.selectField('ShippingState')
				.selectField('BillingStreet')
				.selectField('BillingCity')
				.selectField('BillingPostalCode')
				.selectField('BillingState')
				.setCondition('Name LIKE :searchValueTemp')
				.setLimit(recordLimit)
				.toSOQL()
		);
	}

	/**
	 * @description Return Accounts by CIF
	 *
	 * @param searchValue String
	 * @param recordLimit String max records to return
	 * @return List<Account>
	 */
	public List<Account> selectByCIF(String searchValue, Integer recordLimit) {
		String searchValueTemp = '%' + searchValue + '%';
		return (List<Account>) Database.query(
			newQueryFactory()
				.selectField('CIF__c')
				.selectField('PersonContactId')
				.selectField('Client_Type__c')
            	.selectField('FinServ__Gender__pc')
				.setCondition('CIF__c LIKE :searchValueTemp')
				.setLimit(recordLimit)
				.toSOQL()
		);
	}

	/**
	 * @description Return Accounts by CIF
	 *
	 * @param searchValue Set
	 * @param recordLimit String max records to return
	 * @return List<Account>
	 */
	public List<Account> selectByCIF(Set<String> searchValue, Integer recordLimit) {
		return (List<Account>) Database.query(
			newQueryFactory()
				.selectField('CIF__c')
				.selectField('PersonContactId')
				.selectField('Salutation')
				.selectField('Preferred_Communication_Method__pc')
				.selectField('DD_Source_of_Funds__pc')
            	.selectField('FinServ__Gender__pc')
				.selectField('Income_Source__pc')
				.setCondition('CIF__c IN :searchValue')
				.setLimit(recordLimit)
				.toSOQL()
		);
	}

	/**
	 * @description Returns an account based on the CIF key
	 *
	 * @param cif        The client's CIF key
	 * @return  Account     The Account record
	 */
	public Account selectByCIF(String cif) {
		return Database.query(newQueryFactory().selectField('Id').selectField('Name').setCondition('CIF__c =: cif').toSOQL());
	}

	/**
	 * @description Returns an account based on the Salesforce Id
	 *
	 * @param accId        The client's Salesforce Id
	 * @return  Account     The Account record
	 *
	 *  Modified for USSD stories W-003951 - Tinashe M Shoko
	 */
	public Account selectById(Id accId) {
		return Database.query(
			newQueryFactory()
				.selectField('Id')
				.selectField('Name')
				.selectField('Preferred_Communication_Method__c')
				.selectField('Preferred_Communication_Info__c')
				.selectField('Preferred_Communication_Method__pc')
				.selectField('AccountNumber')
				.selectField('PersonContactId')
				.selectField('Salutation')
				.selectField('LastName')
				.selectField('PersonMobilePhone')
				.selectField('PersonEmail')
				.selectField('PersonBirthdate')
				.selectField('Passport_Expiry_Date__c')
				.selectField('Does_the_Client_fall_under_the_NCA__c')
				.selectField('Client_NCA_Status__c')
				.selectField('FinServ__Status__c')
				.selectField('UBO_ParentAccountWrapper__c')
				.selectField('Telebanking_Charge_Account_Number__c')
				.setCondition('Id =: accId')
				.toSOQL()
		);
	}

	/**
	 * @description Return Accounts by Id
	 *
	 * @param idSet AccountId's
	 * @param recordLimit String max records to return
	 * @return List<Account>
	 */
	public List<Account> selectById(Set<Id> idSet, Integer recordLimit) {
		return (List<Account>) Database.query(
			newQueryFactory()
				.selectField('CIF__c')
				.selectField('FirstName')
				.selectField('LastName')
				.selectField('Salutation')
				.selectField('Client_Type__c')
				.selectField('isPersonAccount')
				.selectField('PersonContactId')
				.selectField('PersonEmail')
				.selectField('Source__c')
				.selectField('Marital_Contract_Type__pc')
				.selectField('ID_Type__pc')
				.selectField('ID_Number__pc')
				.selectField('CountryPassport__pc')
				.selectField('Gender__pc')
				.selectField('Name')
				.selectField('RecordType.Name')
				.selectField('Age__pc')
				.selectField('Work_Phone__c') //added for short term insurance
				.selectField('ID_Type__c') //added for short term insurance
				.selectField('Physical_address_line_2_c__c') //added for short term insurance
				.selectField('PersonHomePhone') //added for short term insurance
				.selectField('BillingState') //added for short term insurance
				.selectField('Telebanking_Charge_Account_Number__c')
				.setCondition('Id IN :idSet')
				.setLimit(recordLimit)
				.toSOQL()
		);
	}

	/**
	 * @description Return Accounts by Passport or Registration Number
	 *
	 * @param searchValue String
	 * @param recordLimit String max records to return
	 * @return List<Account>
	 */
	public List<Account> selectByPassportOrRegistrationNumber(String searchValue, Integer recordLimit) {
		return (List<Account>) Database.query(
			newQueryFactory()
				.selectField('Passport_Number__pc')
				.selectField('Registration_Number__c')
				.selectField('CIF__c')
				.selectField('Client_Type__c')
				.selectField('Source__c')
				.setCondition('Passport_Number__pc LIKE :searchValue OR ' + 'Registration_Number__c LIKE :searchValue')
				.setLimit(recordLimit)
				.toSOQL()
		);
	}

	/**
	 * @description Return Accounts by CIF
	 *
	 * @param searchValue String
	 * @param recordLimit String max records to return
	 * @return List<Account>
	 */
	public List<Account> searchByValueOnAllFields(String searchValue, Integer recordLimit) {
		List<Account> accountsReturned = new List<Account>();
		Search.SearchResults searchResults = Search.find(
			'FIND \'' +
			searchValue +
			'\' IN ALL FIELDS RETURNING Account(id,name,CIF__c,ID_Number__pc,FinServ__Gender__pc,Passport_Number__pc,Initials__pc,ID_Type__pc,Company_Registration_Number__c, Client_Type__c,Source__c,FirstName,LastName,Salutation,Preferred_Communication_Method__pc,' +
			'isPersonAccount,PersonContactId,Communication_Method__c,PersonMobilePhone,PersonHomePhone,Phone,PersonEmail,ShippingStreet,Marital_Status__pc,RecordTypeId,RecordType.Name,DD_Source_of_Funds__pc,Income_Source__pc,' +
			'ShippingCity,ShippingPostalCode,ShippingState,BillingStreet,BillingCity,BillingPostalCode,BillingState,Gender__pc,PersonBirthdate), InsurancePolicy(Name, NameInsuredId), Claim(Name, AccountId) LIMIT ' +
			recordLimit
		); /* added Gender__pc,PersonBirthdate,Passport_Number__pc for flexi funeral */

		List<Search.SearchResult> accountList = searchResults.get('Account');
		//Danie Booysen W-007033 14/10/2020 & W-007157 22/10/2020
		//Start of changes
		List<Search.SearchResult> insurancePolicySOSLResultList = searchResults.get('InsurancePolicy');
		List<Search.SearchResult> claimSOSLResultList = searchResults.get('Claim');

		for (Search.SearchResult searchResult : insurancePolicySOSLResultList) {
			InsurancePolicy eachInsurancePolicy = (InsurancePolicy) searchResult.getSObject();
			//Query the account based on the accountId linked to the insurance policy record
			Account policyAccount = new AccountsSelector().selectAllById(eachInsurancePolicy.NameInsuredId);
			accountsReturned.add(policyAccount);
		}

		for (Search.SearchResult searchResult : claimSOSLResultList) {
			Claim eachClaim = (Claim) searchResult.getSObject();
			//Query the account based on the accountId linked to the claim record
			Account claimAccount = new AccountsSelector().selectAllById(eachClaim.AccountId);
			accountsReturned.add(claimAccount);
		}
		//End of changes

		for (Search.SearchResult searchResult : accountList) {
			Account eachAccount = (Account) searchResult.getSObject();
			accountsReturned.add(eachAccount);
		}

		return accountsReturned;
	}

	/**
	 * @description Return Accounts by CIF
	 *
	 * @param emailAddress Set
	 * @param recordLimit String max records to return
	 * @return List<Account>
	 */
	public List<Account> selectByEmail(Set<String> emailAddress, Integer recordLimit) {
		return (List<Account>) Database.query(
			newQueryFactory()
				.selectField('PersonContactId')
				.selectField('Id')
				.setCondition(
					'Active_Email__c IN :emailAddress OR ' +
					'Alternative_Email__c IN :emailAddress OR ' +
					'Alternative_Email_1__c IN :emailAddress OR ' +
					'Alternative_Email_2__c IN :emailAddress OR ' +
					'Alternative_Email_3__c IN :emailAddress OR ' +
					'Alternative_Email_4__c IN :emailAddress OR ' +
					'PersonEmail IN :emailAddress'
				)
				.setLimit(recordLimit)
				.toSOQL()
		);
	}

	/**
	 * @description Returns an account based on the Salesforce Id
	 *
	 * @param accId        The client's Salesforce Id
	 * @return  Account     The Account record
	 */
	public Account selectforRefreshById(Id accId) {
		return Database.query(
			newQueryFactory()
				.selectField('Id')
				.selectField('Name')
				.selectField('CIF__c')
				.selectField('Last_External_Update_User__c')
				.selectField('LastModifiedDate')
				.selectField('Last_External_Update_Time__c')
				.selectField('ID_Type__pc')
				.selectField('ID_Number__pc')
				.selectField('Passport_Number__pc')
				.setCondition('Id =: accId')
				.toSOQL()
		);
	}

	/**
	 * @description Returns accounts based on set of RSA IDs
	 *
	 * @param IDNumberSet - client's RSA IDs numbers set
	 * @return List of Accounts
	 */
	public List<Account> selectbyIDNumbers(Set<string> IDNumberSet) {
		return Database.query(
			newQueryFactory()
				.selectField('Id')
				.selectField('Name')
				.selectField('CIF__c')
				.selectField('Last_External_Update_User__c')
				.selectField('LastModifiedDate')
				.selectField('Last_External_Update_Time__c')
				.selectField('ID_Type__pc')
				.selectField('ID_Number__pc')
				.selectField('PersonContactId')
				.setCondition('ID_Number__pc IN: IDNumberSet')
				.toSOQL()
		);
	}

	/**
	 * @description Returns Accounts
	 *
	 * @param accContacts
	 * @return List of Account
	 */
	public List<Account> selectbyaccContacts(List<Account> accContacts) {
		return Database.query(
			newQueryFactory().selectField('Id').selectField('ID_Number__pc').selectField('PersonContactId').setCondition('Id IN: accContacts').toSOQL()
		);
	}

	/**
	 * PJAIN: 20200416
	 * @description Returns an account based on the Salesforce Id
	 *
	 * @param accId        The client's Salesforce Id
	 * @return  Account     The Account record
	 **/
	public List<Account> selectFranchisePriceSchemeIdById(Id accId) {
		return Database.query(
			newQueryFactory()
				.selectField('Id')
				.selectField('Name')
				.selectField('Franchise_Price_Scheme__c')
				.selectField('Franchise_Price_Scheme__r.Is_Negotiable__c')
				.setCondition('Id =: accId AND Is_Part_Of_Franchise__c = true AND Franchise_Price_Scheme__c != null')
				.toSOQL()
		);
	}

	/**
	 * @description Returns an account based on the Salesforce Id
	 *
	 * @param accId        The client's Salesforce Id
	 * @return  Account     The Account record
	 **/
	public Account selectByIdForIndividual(Id accId) {
		return Database.query(
			newQueryFactory()
				.selectField('PersonContactId')
				.selectField('ID_Number__pc')
				.selectField('Age__pc')
				.selectField('Country_of_Residence__c')
				.selectField('ID_Type__c')
				.selectField('Preferred_Communication_Method__c')
				.selectField('Registration_Number__c')
				.selectField('Source_of_Income__c')
				.selectField('PersonBirthdate')
				.selectField('PersonEmail')
				.selectField('PersonMobilePhone')
				.selectField('VAT_Registration_Number__c')
				.selectField('CASA_Analyst_Comments__c')
				.selectField('CASA_Reference_Number__c')
				.selectField('CASA_Screening_Date__c')
				.selectField('CASA_Screening_Status__c')
				.selectField('CIF__c')
				.selectField('RecordType.Name')
				.selectField('BillingCity')
				.selectField('BillingPostalCode')
				.selectField('BillingCountry')
				.selectField('ShippingStreet')
				.selectField('ShippingCity')
				.selectField('ShippingCountry')
				.selectField('ShippingPostalCode')
				.selectField('Primary_Client__c')
				.selectField('Preferred_Communication_Info__c')
				.selectField('Client_Group__c')
				.selectField('Country_of_Incorporation__c')
				.selectField('Date_Established__c')
				.selectField('Business_Unit__c')
				.selectField('Standard_Industry_SIC_Category__c')
				.selectField('Standard_Industry_SIC_Code__c')
				.selectField('Business_Address_Line_1__c')
				.selectField('Business_Address_Line_2__c')
				.selectField('Financial_Year_End__c')
				.selectField('Id')
				.selectField('Income_Tax_Number__c')
				.selectField('Language__c')
				.selectField('AccountNumber')
				.selectField('AgriClass__c')
				.selectField('AgriClass_Percentage__c')
				.selectField('Foreign_Tax_Number__c')
				.selectField('Country_of_Foreign_tax__c')
				.selectField('SicDesc')
				.selectField('Source_of_Income__pc')
				.selectField('Source_of_Income__c')
				.selectField('Date_Verified__c')
				.selectField('Date_Identified__c')
				.selectField('Is_Marketing_Consent_Phone__c')
				.selectField('Is_Marketing_Consent_Email__c')
				.selectField('Is_Marketing_Consent_SMS__c')
				.selectField('Is_Marketing_Consent_Post__c')
				.selectField('Is_Marketing_Consent_voice_rec__c')
				.selectField('Country_of_Operation__c')
				.selectField('Credit_Marketing_Indicator__pc')
				.selectField('Credit_Marketing_Consent__pc')
				.selectField('Country_of_Registration__c')
				.selectField('Date_Issued__pc')
				.selectField('Monthly_Income__pc')
				.selectField('Nationality__pc')
				.selectField('Is_the_Client_exempt_from_FICA__pc')
				.selectField('Next_of_Kin_Telephone_Number__pc')
				.selectField('Next_of_Kin_Initial__pc')
				.selectField('Next_of_Kin_First_Name_s__pc')
				.selectField('Next_of_Kin_Last_Name__pc')
				.selectField('Next_of_Kin_Relationship__pc')
				.selectField('Next_of_Kin_Cellphone_Number__pc')
				.selectField('Next_of_Kin_Email_Address__pc')
				.selectField('Credit_Worthiness_Consent__c')
				.selectField('Does_the_Client_receive_Social_a_Grant__c')
				.selectField('Does_the_Client_fall_under_the_CPA__c')
				.selectField('Does_the_Client_fall_under_the_NCA__c')
				.selectField('Post_Matric_Qualification__pc')
				.selectField('Residential_Status__pc')
				.selectField('Client_Agreement__c')
				.selectField('Number_Of_Dependents__c')
				.selectField('SIC_Classification_1__c')
				.selectField('SIC_Classification_1_Percentage__c')
				.selectField('SIC_Classification_2__c')
				.selectField('SIC_Classification_2_Percentage__c')
				.selectField('SIC_Classification_3__c')
				.selectField('SIC_Classification_3_Percentage__c')
				.selectField('Q4a_Client_affected_by_Regulation_3_1_F__c')
				.selectField('Q4b_How_is_the_Client_Affected__c')
				.selectField('Q4c_Exchange_Control_Expiry_date__c')
				.selectField('Q1a_Client_affected_by_Regulation_3_1_F__c')
				.selectField('Q1b_How_is_the_Client_Affected__c')
				.selectField('Q1c_Exchange_Control_Expiry_date__c')
				.selectField('Q2a_Client_affected_by_Regulation_3_1_F__c')
				.selectField('Q2b_How_is_the_Client_Affected__c')
				.selectField('Q2c_Exchange_Control_Expiry_date__c')
				.selectField('BillingState') //added by short term insurance
				.selectField('ShippingState') //added by short term insurance
				.selectField('Rounded_Age__c') //added by short term insurance
				.selectField('Work_Phone__c') //added by short term insurance
				.selectField('billing_address_line_2__c') //added by short term insurance
				.selectField('Physical_address_line_2_c__c') //added by short term insurance
				.setCondition('Id =: accId')
				.toSOQL()
		);
	}

	/**
	 * @description Tinashe - New Document Generation
	 *
	 * @param accountId   The client's Salesforce Id
	 * @param addressType
	 * @return  Account     The Account record
	 **/
	public List<Account> selectRelatedPatiesByAddressType(Id accountId, string addressType) {
		return [
			SELECT
				Id,
				ID_Number__pc,
				Name,
				PersonTitle,
				FirstName,
				LastName,
				Trading_Name__c,
				Insolvent_Debit_Review__pc,
				Nationality__pc,
				CountryPassport__pc,
				(
					SELECT
						Id,
						Client_Entity_Type__c,
						Shipping_State_Province__c,
						Shipping_Street__c,
						Shipping_Zip_Postal_Code__c,
						Shipping_Suburb__c,
						Shipping_City__c,
						Shipping_Country__c
					FROM Addresses__r
					WHERE Address_Type__c = :addressType
				)
			FROM Account
			WHERE Id = :accountId
		];
	}

	/**
	 * EMONGWE: 20200915
	 *
	 * @description Returns an account based on the Salesforce Id
	 * @param conId The client's Salesforce Id
	 * @param recordLimit
	 * @return  Account     The Account record
	 */
	public Account selectAccountByPersonContactId(Id conId, Integer recordLimit) {
		return Database.query(
			newQueryFactory()
				.selectField('Id')
				.selectField('Business_Address_Line_1__c')
				.selectField('Highest_Qualification__pc')
				.selectField('Number_Of_YearIn_The_Specific_Industry__c')
				.selectField('Months_Actively_Involved_In_The_Business__c')
				.selectField('Months_Since_Shareholding__c')
				.selectField('Is_the_Client_a_Non_resident__c')
				.selectField('Is_the_Client_a_Temporary_Resident__c')
				.setCondition('PersonContactId =: conId AND IsPersonAccount = true')
				.setLimit(recordLimit)
				.toSOQL()
		);
	}
	/**
	* @description : Metod to get list
	* @author Englarmerdge Mongwe | 2021-11-08 
	* @param conId 
	* @param recordLimit 
	* @return List<Account> 
	**/
	public List<Account> selectAccountsByPersonContactId(Id conId, Integer recordLimit) {

        return Database.query(
            newQueryFactory().
            selectField('Id').
            selectField('isPersonAccount').
            selectField('Business_Address_Line_1__c').
            selectField('Highest_Qualification__pc').
            selectField('Number_Of_YearIn_The_Specific_Industry__c').
            selectField('Months_Actively_Involved_In_The_Business__c').
            selectField('Months_Since_Shareholding__c').
            selectField('Is_the_Client_a_Non_resident__c').
            selectField('Is_the_Client_a_Temporary_Resident__c').
            setCondition('PersonContactId =:conId AND IsPersonAccount = true').
            setLimit(recordLimit).
            toSOQL()
        );
    }

	/**
	 * EMONGWE: 20210212
	 *
	 * @description Returns an account based on the Salesforce Set<Id>
	 * @param conIds The client's Salesforce Id
	 * @return  List<Account> The Account records
	 */
	public List<Account> selectAccountByPersonContactSetId(Set<Id> conIds) {
		return Database.query(
			newQueryFactory()
				.selectField('Id')
				.selectField('Business_Address_Line_1__c')
				.selectField('Highest_Qualification__pc')
				.selectField('Number_Of_YearIn_The_Specific_Industry__c')
				.selectField('Months_Actively_Involved_In_The_Business__c')
				.selectField('Months_Since_Shareholding__c')
				.selectField('Is_the_Client_a_Non_resident__c')
				.selectField('Is_the_Client_a_Temporary_Resident__c')
				.setCondition('PersonContactId IN :conIds AND IsPersonAccount = true')
				.toSOQL()
		);
	}

	/**
	 * @description Returns an account based on the Salesforce Id
	 * Saurabh : W:3780 Business Rules Validations
	 * @param accId        The client's Salesforce Id
	 * @return  Account     The Account record
	 */
	public Account selectFieldsforRulesEnginebyId(Id accId) {
		return Database.query(
			newQueryFactory()
				.selectField('Id')
				.selectField('Name')
				.selectField('CIF__c')
				.selectField('Banking_Sector__c')
				.selectField('SBU_Segment__c')
				.selectField('Client_Type__c')
				.selectField('Client_Group__c')
				.selectField('Standard_Industry_SIC_Code__c')
				.setCondition('Id =: accId')
				.toSOQL()
		);
	}

	/**
	 * @description Method that returns an Account based on Opportunity Id
	 *
	 * @param   oppId     The Opportunity Id
	 * @return  Account     The Account object record
	 */
	public Account selectIndvByOpportunityIdNew(Id oppId) {
		Id oppAccId = new OpportunitiesSelector().selectByOpportunityId(oppId, 1).get(0).AccountId;

		return Database.query(
			newQueryFactory()
				.selectField('Name') //Adding this field as it was failing in Credit Client Details Section
				.selectField('PersonContactId')
				.selectField('ID_Number__pc')
				.selectField('Business_Start_Date__c') //Added by Gulafsha for business start date field on client details section
				.selectField('Age__pc')
				.selectField('Country_of_Residence__c')
				.selectField('Company_Registration_Number__c')
				.selectField('Country_Passport_Issued__pc')
				.selectField('ID_Type__c')
				.selectField('Client_Type__c')
				.selectField('Trust_Number__c')
				.selectField('SDS_ID__c')
				.selectField('Franchise_Price_Scheme__c')
				.selectField('Occupation_Level__pc')
				.selectField('Preferred_Communication_Method__c')
				.selectField('Registration_Number__c')
				.selectField('Source_of_Income__c')
				.selectField('PersonBirthdate')
				.selectField('PersonEmail')
				.selectField('PersonMobilePhone')
				.selectField('VAT_Registration_Number__c')
				.selectField('CASA_Analyst_Comments__c')
				.selectField('CASA_Reference_Number__c')
				.selectField('CASA_Screening_Date__c')
				.selectField('CASA_Screening_Status__c')
				.selectField('CASA_Risk_Status__c')
				.selectField('CIF__c')
				.selectField('RecordType.Name')
				.selectField('BillingCity')
				.selectField('BillingPostalCode')
				.selectField('BillingCountry')
				.selectField('ShippingStreet')
				.selectField('ShippingCity')
				.selectField('ShippingCountry')
				.selectField('ShippingPostalCode')
				.selectField('Primary_Client__c')
				.selectField('Preferred_Communication_Info__c')
				.selectField('Client_Group__c')
				.selectField('Country_of_Incorporation__c')
				.selectField('Date_Established__c')
				.selectField('Business_Unit__c')
				.selectField('Standard_Industry_SIC_Category__c')
				.selectField('Standard_Industry_SIC_Code__c')
				.selectField('Business_Address_Line_1__c')
				.selectField('Business_Address_Line_2__c')
				.selectField('Financial_Year_End__c')
				.selectField('Id')
				.selectField('Income_Tax_Number__c')
				.selectField('Language__c')
				.selectField('AccountNumber')
				.selectField('AgriClass__c')
				.selectField('AgriClass_Percentage__c')
				.selectField('Foreign_Tax_Number__c')
				.selectField('Country_of_Foreign_tax__c')
				.selectField('SicDesc')
				.selectField('Source_of_Income__pc')
				.selectField('Source_of_Income__c')
				.selectField('Date_Verified__c')
				.selectField('Date_Identified__c')
				.selectField('Is_Marketing_Consent_Phone__c')
				.selectField('Is_Marketing_Consent_Email__c')
				.selectField('Is_Marketing_Consent_SMS__c')
				.selectField('Is_Marketing_Consent_Post__c')
				.selectField('Is_Marketing_Consent_voice_rec__c')
				.selectField('Country_of_Operation__c')
				.selectField('Credit_Marketing_Indicator__pc')
				.selectField('Credit_Marketing_Consent__pc')
				.selectField('Country_of_Registration__c')
				.selectField('Date_Issued__pc')
				.selectField('Monthly_Income__pc')
				.selectField('Nationality__pc')
				//selectField('Is_the_Client_exempt_from_FICA__pc').
				.selectField('Next_of_Kin_Telephone_Number__pc')
				.selectField('Next_of_Kin_Initial__pc')
				.selectField('Next_of_Kin_First_Name_s__pc')
				.selectField('Next_of_Kin_Last_Name__pc')
				.selectField('Next_of_Kin_Relationship__pc')
				.selectField('Next_of_Kin_Cellphone_Number__pc')
				.selectField('Next_of_Kin_Email_Address__pc')
				.selectField('Credit_Worthiness_Consent__c')
				.selectField('Does_the_Client_receive_Social_a_Grant__c')
				.selectField('Does_the_Client_fall_under_the_CPA__c')
				.selectField('Does_the_Client_fall_under_the_NCA__c')
				.selectField('Post_Matric_Qualification__pc')
				.selectField('Is_Non_Credit_Marketing_Consent_Email__c')
				.selectField('Is_Non_Credit_Marketing_Consent_SMS__c')
				.selectField('Is_Non_Credit_Marketing_Consent_Phone__c')
				.selectField('Is_the_Client_a_Non_resident__c')
				.selectField('Is_the_Client_a_Temporary_Resident__c')
				.selectField('Is_Part_of_Franchise__c')
				.selectField('Non_Credit_Marketing_Consent_Email__c')
				.selectField('Non_Credit_Marketing_Consent_SMS__c')
				.selectField('Non_Credit_Marketing_Consent_Phone__c')
				.selectField('Trading_indicator__c')
				.selectField('Client_Intent_To_Go_Into_Business_Rescue__c')
				.selectField('Client_intends_to_declare_insolvency__c')
				.selectField('Client_ever_been_declared_Insolvent__c')
				.selectField('Client_is_a_stokvel__c')
				.selectField('Client_is_a_municipality__c')
				.selectField('Sic')
				.selectField('Marketing_Consent_Info__c')
				.selectField('Marketing_Consent_SMS__c')
				.selectField('Marketing_Consent_Phone__c')
				.selectField('Residential_Status_Address__c')
				.selectField('Residential_Status__pc')
				.selectField('Client_Agreement__c')
				.selectField('Number_Of_Dependents__c')
				.selectField('SIC_Classification_1__c')
				.selectField('SIC_Classification_1_Percentage__c')
				.selectField('SIC_Classification_2__c')
				.selectField('SIC_Classification_2_Percentage__c')
				.selectField('SIC_Classification_3__c')
				.selectField('SIC_Classification_3_Percentage__c')
				.selectField('Q4a_Client_affected_by_Regulation_3_1_F__c')
				.selectField('Q4b_How_is_the_Client_Affected__c')
				.selectField('Q4c_Exchange_Control_Expiry_date__c')
				.selectField('Q1a_Client_affected_by_Regulation_3_1_F__c')
				.selectField('Q1b_How_is_the_Client_Affected__c')
				.selectField('Q1c_Exchange_Control_Expiry_date__c')
				.selectField('Q2a_Client_affected_by_Regulation_3_1_F__c')
				.selectField('Q2b_How_is_the_Client_Affected__c')
				.selectField('Q2c_Exchange_Control_Expiry_date__c')
				.selectField('SPM_Region__c')
				.selectField('Residential_Status__c')
				.selectField('Temporary_Resident_Permit_Number__c')
				.selectField('Temporary_Resident_Permit_Expiry_Date__c')
				.selectField('Date_Current_Address_Since__c')
				.selectField('Is_Client_Part_Of_Enter_Development_Fund__c')
				.selectField('Development_Fund_Partner_Client_Code__c')
				.selectField('Development_Fund_Name__c')
				.selectField('Franchise_Code__c')
				.selectField('Franchise_Name__c')
				.selectField('Business_Rescue_Affected_Party__c')
				.selectField('Trust_Or_Other_Fund_Number__c')
				.selectField('SBU_Segment__c')
				.selectField('Passport_Number__pc')
				.selectField('BillingState') //added by short term insurance
				.selectField('ShippingState') //added by short term insurance
				.selectField('Rounded_Age__c') //added by short term insurance
				.selectField('Work_Phone__c') //added by short term insurance
				.selectField('billing_address_line_2__c') //added by short term insurance
				.selectField('Physical_address_line_2_c__c') //added by short term insurance
				.setCondition('Id =: oppAccId')
				.toSOQL()
		);
	}

	/**
	 * @description Method that returns an Account based on Opportunity Id
	 *
	 * @param   oppId     The Opportunity Id
	 * @return  Account     The Account object record
	 */
	public Account selectIndvByOpportunityIdUpdate(Id oppId) {
		Id oppAccId = new OpportunitiesSelector().selectByOpportunityId(oppId, 1).get(0).AccountId;

		return Database.query(
			newQueryFactory()
				.selectField('PersonContactId')
				.selectField('ID_Number__pc')
				.selectField('Age__pc')
				.selectField('Country_of_Residence__c')
				.selectField('Country_Passport_Issued__pc')
				.selectField('ID_Type__c')
				.selectField('Client_Type__c')
				.selectField('SDS_ID__c')
				.selectField('Preferred_Communication_Method__c')
				.selectField('Registration_Number__c')
				.selectField('Source_of_Income__c')
				.selectField('PersonBirthdate')
				.selectField('PersonEmail')
				.selectField('PersonMobilePhone')
				.selectField('Occupation_Level__pc')
				.selectField('VAT_Registration_Number__c')
				.selectField('CASA_Analyst_Comments__c')
				.selectField('CASA_Reference_Number__c')
				.selectField('CASA_Screening_Date__c')
				.selectField('CASA_Screening_Status__c')
				.selectField('CASA_Risk_Status__c')
				.selectField('CIF__c')
				.selectField('RecordType.Name')
				.selectField('BillingCity')
				.selectField('BillingPostalCode')
				.selectField('BillingCountry')
				.selectField('ShippingStreet')
				.selectField('ShippingCity')
				.selectField('ShippingCountry')
				.selectField('ShippingPostalCode')
				.selectField('Primary_Client__c')
				.selectField('Preferred_Communication_Info__c')
				.selectField('Client_Group__c')
				.selectField('Country_of_Incorporation__c')
				.selectField('Date_Established__c')
				.selectField('Business_Unit__c')
				.selectField('Standard_Industry_SIC_Category__c')
				.selectField('Standard_Industry_SIC_Code__c')
				.selectField('Business_Address_Line_1__c')
				.selectField('Business_Address_Line_2__c')
				.selectField('Financial_Year_End__c')
				.selectField('Id')
				.selectField('Income_Tax_Number__c')
				.selectField('Language__c')
				.selectField('AccountNumber')
				.selectField('AgriClass__c')
				.selectField('AgriClass_Percentage__c')
				.selectField('Foreign_Tax_Number__c')
				.selectField('Country_of_Foreign_tax__c')
				.selectField('SicDesc')
				.selectField('Source_of_Income__pc')
				.selectField('Source_of_Income__c')
				.selectField('Date_Verified__c')
				.selectField('Date_Identified__c')
				.selectField('Is_Marketing_Consent_Phone__c')
				.selectField('Is_Marketing_Consent_Email__c')
				.selectField('Is_Marketing_Consent_SMS__c')
				.selectField('Is_Marketing_Consent_Post__c')
				.selectField('Is_Marketing_Consent_voice_rec__c')
				.selectField('Country_of_Operation__c')
				.selectField('Credit_Marketing_Indicator__pc')
				.selectField('Credit_Marketing_Consent__pc')
				.selectField('Country_of_Registration__c')
				.selectField('Date_Issued__pc')
				.selectField('Monthly_Income__pc')
				.selectField('Nationality__pc')
				.selectField('Next_of_Kin_Telephone_Number__pc')
				.selectField('Next_of_Kin_Initial__pc')
				.selectField('Next_of_Kin_First_Name_s__pc')
				.selectField('Next_of_Kin_Last_Name__pc')
				.selectField('Next_of_Kin_Relationship__pc')
				.selectField('Next_of_Kin_Cellphone_Number__pc')
				.selectField('Next_of_Kin_Email_Address__pc')
				.selectField('Credit_Worthiness_Consent__c')
				.selectField('Does_the_Client_receive_Social_a_Grant__c')
				.selectField('Does_the_Client_fall_under_the_CPA__c')
				.selectField('Does_the_Client_fall_under_the_NCA__c')
				.selectField('Post_Matric_Qualification__pc')
				.selectField('Is_Non_Credit_Marketing_Consent_Email__c')
				.selectField('Is_Non_Credit_Marketing_Consent_SMS__c')
				.selectField('Is_Non_Credit_Marketing_Consent_Phone__c')
				.selectField('Is_the_Client_a_Non_resident__c')
				.selectField('Is_the_Client_a_Temporary_Resident__c')
				.selectField('Is_Part_of_Franchise__c')
				.selectField('Non_Credit_Marketing_Consent_Email__c')
				.selectField('Non_Credit_Marketing_Consent_SMS__c')
				.selectField('Non_Credit_Marketing_Consent_Phone__c')
				.selectField('Trading_indicator__c')
				.selectField('Client_Intent_To_Go_Into_Business_Rescue__c')
				.selectField('Client_intends_to_declare_insolvency__c')
				.selectField('Client_ever_been_declared_Insolvent__c')
				.selectField('Client_is_a_stokvel__c')
				.selectField('Client_is_a_municipality__c')
				.selectField('Sic')
				.selectField('Marketing_Consent_Info__c')
				.selectField('Marketing_Consent_SMS__c')
				.selectField('Marketing_Consent_Phone__c')
				.selectField('Residential_Status_Address__c')
				.selectField('Residential_Status__pc')
				.selectField('Client_Agreement__c')
				.selectField('Number_Of_Dependents__c')
				.selectField('SIC_Classification_1__c')
				.selectField('SIC_Classification_1_Percentage__c')
				.selectField('SIC_Classification_2__c')
				.selectField('SIC_Classification_2_Percentage__c')
				.selectField('SIC_Classification_3__c')
				.selectField('SIC_Classification_3_Percentage__c')
				.selectField('Residential_Status__c')
				.selectField('Temporary_Resident_Permit_Number__c')
				.selectField('Temporary_Resident_Permit_Expiry_Date__c')
				.selectField('Date_Current_Address_Since__c')
				.selectField('Is_Client_Part_Of_Enter_Development_Fund__c')
				.selectField('Development_Fund_Partner_Client_Code__c')
				.selectField('Development_Fund_Name__c')
				.selectField('Franchise_Code__c')
				.selectField('Franchise_Name__c')
				.selectField('Business_Rescue_Affected_Party__c')
				.selectField('BillingStreet') //added by short term insurance
				.selectField('BillingState') //added by short term insurance
				.selectField('ShippingState') //added by short term insurance
				.selectField('Work_Phone__c') //added by short term insurance
				.selectField('Rounded_Age__c') //added by short term insurance
				.selectField('billing_address_line_2__c') //added by short term insurance
				.selectField('Physical_address_line_2_c__c') //added by short term insurance
				.selectField('Risk_Rating__c') //added by short term insurance
				.setCondition('Id =: oppAccId')
				.toSOQL()
		);
	}
	/**
	 * @description Method that returns an Account based on Opportunity Id
	 *
	 * @param   accId     The Opportunity Id
	 * @return  Account     The Account object record
	 */
	public Account selectAccountFieldsCIFById(Id accId) {
		return Database.query(
			newQueryFactory()
				.selectField('PersonContactId')
				.selectField('ID_Number__pc')
				.selectField('Active_Email__c')
				.selectField('Age__pc')
				.selectField('Country_of_Residence__c')
				.selectField('ID_Type__c')
				.selectField('Client_Type__c')
				.selectField('Preferred_Communication_Method__c')
				.selectField('Registration_Number__c')
				.selectField('Source_of_Income__c')
				.selectField('Monthly_Income__c')
				.selectField('PersonBirthdate')
				.selectField('PersonEmail')
				.selectField('PersonMobilePhone')
				.selectField('VAT_Registration_Number__c')
				.selectField('CASA_Analyst_Comments__c')
				.selectField('CASA_Reference_Number__c')
				.selectField('CASA_Screening_Date__c')
				.selectField('CASA_Screening_Status__c')
				.selectField('CIF__c')
				.selectField('RecordType.Name')
				.selectField('BillingCity')
				.selectField('BillingPostalCode')
				.selectField('BillingCountry')
				.selectField('ShippingStreet')
				.selectField('ShippingCity')
				.selectField('ShippingCountry')
				.selectField('Dealer_Code__c')
				.selectField('ShippingPostalCode')
				.selectField('Primary_Client__c')
				.selectField('Preferred_Communication_Info__c')
				.selectField('Client_Group__c')
				.selectField('Country_of_Incorporation__c')
				.selectField('Date_Established__c')
				.selectField('Business_Unit__c')
				.selectField('Reason_For_Not_Providing_SA_Tax_Number__c')
				.selectField('Standard_Industry_SIC_Category__c')
				.selectField('Standard_Industry_SIC_Code__c')
				.selectField('Business_Address_Line_1__c')
				.selectField('Business_Address_Line_2__c')
				.selectField('Financial_Year_End__c')
				.selectField('Id')
				.selectField('Income_Tax_Number__c')
				.selectField('Language__c')
				.selectField('Name')
				.selectField('AccountNumber')
				.selectField('AgriClass__c')
				.selectField('AgriClass_Percentage__c')
				.selectField('Foreign_Tax_Number__c')
				.selectField('Country_of_Foreign_tax__c')
				.selectField('SicDesc')
				.selectField('Source_of_Income__pc')
				.selectField('Source_of_Income__c')
				.selectField('Date_Verified__c')
				.selectField('Date_Identified__c')
				.selectField('Is_Marketing_Consent_Phone__c')
				.selectField('Is_Marketing_Consent_Email__c')
				.selectField('Is_Marketing_Consent_SMS__c')
				.selectField('Is_Marketing_Consent_Post__c')
				.selectField('Is_Marketing_Consent_voice_rec__c')
				.selectField('Country_of_Operation__c')
				.selectField('Credit_Marketing_Indicator__pc')
				.selectField('Credit_Marketing_Consent__pc')
				.selectField('Country_of_Registration__c')
				.selectField('Date_Issued__pc')
				.selectField('Monthly_Income__pc')
				.selectField('Nationality__pc')
				.selectField('Is_the_Client_exempt_from_FICA__pc')
				.selectField('Next_of_Kin_Telephone_Number__pc')
				.selectField('Next_of_Kin_Initial__pc')
				.selectField('Next_of_Kin_First_Name_s__pc')
				.selectField('Next_of_Kin_Last_Name__pc')
				.selectField('Next_of_Kin_Relationship__pc')
				.selectField('Next_of_Kin_Cellphone_Number__pc')
				.selectField('Next_of_Kin_Email_Address__pc')
				.selectField('Credit_Worthiness_Consent__c')
				.selectField('Does_the_Client_receive_Social_a_Grant__c')
				.selectField('Does_the_Client_fall_under_the_CPA__c')
				.selectField('Does_the_Client_fall_under_the_NCA__c')
				.selectField('Post_Matric_Qualification__pc')
				.selectField('Residential_Status__pc')
				.selectField('Client_Agreement__c')
				.selectField('Trading_Name__c')
				.SelectField('Is_the_Consent_Given__pc')
				.SelectField('Policy_and_Procedures_in_organisation__c')
				.SelectField('How_many_years_trading__c')
				.selectField('Number_Of_Dependents__c')
				.selectField('SIC_Classification_1__c')
				.selectField('SIC_Classification_1_Percentage__c')
				.selectField('SIC_Classification_2__c')
				.selectField('SIC_Classification_2_Percentage__c')
				.selectField('SIC_Classification_3__c')
				.selectField('SIC_Classification_3_Percentage__c')
				.selectField('Q4a_Client_affected_by_Regulation_3_1_F__c')
				.selectField('Q1a_Client_affected_by_Regulation_3_1_F__c')
				.selectField('Q2a_Client_affected_by_Regulation_3_1_F__c')
				.selectField('SPM_Region__c')
				.selectField('AuthMessage__c')
				.selectField('Preferred_delivery_method_Legal_Notices__c')
				.setCondition('Id =: accId')
				.toSOQL()
		);
	}

	/**
	 * @description Method that returns an Account based on Opportunity Id
	 *
	 * @param   type     The Opportunity Id
	 * @param   recordLimit     The Opportunity Id
	 * @return  Account     The Account object record
	 */
	public List<Account> selectAllByType(String type, Integer recordLimit) {
		return Database.query(
			newQueryFactory()
				.selectField('Id')
				.selectField('FirstName')
				.selectField('LastName')
				.selectField('Name')
				.selectField('Phone')
				.selectField('Dealer_Code__c')
				.selectField('ID_Type__pc')
				.selectField('ID_Type__c')
				.selectField('ID_Number__pc')
				.selectField('Client_Group__c')
				.selectField('Client_Type__c')
				.selectField('PersonBirthdate')
				.selectField('Nationality__pc')
				.selectField('ShippingCity')
				.selectField('Country_of_Residence__pc')
				.selectField('Country_of_Birth__pc')
				.selectField('Country_of_Registration__c')
				.selectField('Country_of_Origin__pc')
				.selectField('Passport_Number__pc')
				.selectField('CASA_Analyst_Comments__c')
				.selectField('CASA_Reference_Number__c')
				.selectField('CASA_Screening_Date__c')
				.selectField('CASA_Screening_Status__c')
				.selectField('Countries_Traded_With__c')
				.selectField('Marital_Contract_Type__pc')
				.selectField('Non_Credit_Marketing_Consent__pc')
				.selectField('Non_Credit_Marketing_Indicator__pc')
				.selectField('Credit_Marketing_Consent__pc')
				.selectField('Credit_Marketing_Indicator__pc')
				.selectField('Communication_Method__c')
				.selectField('MiddleName')
				.selectField('Income_Tax_Number__pc')
				.selectField('CIF__c')
				.selectField('RecordType.Name')
				.selectField('RecordType.DeveloperName')
				.selectField('Preferred_Communication_Method__pc')
				.selectField('Monthly_Income__pc')
				.selectField('PersonContactId')
				.selectField('CASA_Analyst_Comments__c')
				.selectField('CASA_Reference_Number__c')
				.selectField('Date_Issued__pc')
				.selectField('Primary_Client__c')
				.selectField('Registration_Number__c')
				.selectField('pepSts__c')
				.selectField('Source_of_Income__c')
				.selectField('PEP_Status__pc')
				.setCondition('Type = :type')
				.setLimit(recordLimit)
				.toSOQL()
		);
	}

	/**
	 * --Poornima Aduru
	 * @description Method that returns an Account with phone fields based on Account Id
	 *
	 * @param   accId     The Account Id
	 * @return  Account     The Account object record
	 */
	public Account selectAccountPhoneDetailsByID(String accId) {
		return Database.query(
			newQueryFactory()
				.selectField('Id')
				.selectField('Work_Phone__pc')
				.selectField('RecordTypeId')
				.selectField('ID_Type__pc')
				.selectField('ID_Number__pc')
				.selectField('Alternate_Phone1__pc')
				.selectField('Alternate_Phone2__pc')
				.selectField('Alternate_Phone3__pc')
				.selectField('Alternate_Phone4__pc')
				.selectField('Alternate_Phone5__pc')
				.selectField('Alternate_Phone6__pc')
				.selectField('Alternate_Phone7__pc')
				.selectField('New_Alternate_Contact__pc')
				.selectField('CIF__c')
				.selectField('Registration_Number__c')
				.selectField('AccountNumber')
				.setCondition('Id = :accId')
				.toSOQL()
		);
	}
	/**
	 * --Poornima Aduru
	 * @description Method that returns an Account based on CIF and ID Number
	 *
	 * @param   searchValueCIF     CIF Number , searchValueID ID Number
	 * @param   searchValueID
	 * @return  Account     The Account object record
	 */
	public List<Account> selectAccountByCIFAndID(String searchValueCIF, String searchValueID) {
		return Database.query(newQueryFactory().selectField('Id').setCondition('CIF__c = : searchValueCIF AND ID_Number__pc=: searchValueID').toSOQL());
	}

	/**
	 * @description Method that gets a list of accounts that have the same ID Number, Passport Number or Registration Number as the ones supplied in the parameters
	 * JQUEV / D Booysen
	 * @param identificationNumber - Account's Registration number
	 * @return a Account List
	 */
	public List<Account> selectAccountByIdPassportRegNumber(String identificationNumber) {
		return Database.query(
			newQueryFactory()
				.setCondition(
					'ID_Number__pc =: identificationNumber OR Passport_Number__pc =: identificationNumber OR Registration_Number__c =: identificationNumber'
				)
				.toSOQL()
		);
	}

	/**
	 * @description Method that gets a list of accounts that have the same ID Number, Passport Number or Registration Number as the ones supplied in the parameters
	 * Ephetehe
	 * @param identificationNumber - Account's ID number
	 * @return a Account List
	 */
	public List<Account> selectAccountByIdPassportRegNumber(Set<String> identificationNumber) {
		return Database.query(
			newQueryFactory()
				.selectField('Name')
				.setCondition(
					'ID_Number__pc IN: identificationNumber OR Passport_Number__pc IN: identificationNumber OR Registration_Number__c IN: identificationNumber'
				)
				.toSOQL()
		);
	}
	/**
	 * @description returns Accounts that have either the Id or CIF__c specified in the Sets
	 * @param accountIdSet
	 * @param accountCIFSet
	 * @return List<Account>
	 *
	 */
	public List<Account> selectByIdOrCIF(Set<String> accountIdSet, Set<String> accountCIFSet) {
		return (List<Account>) Database.query(
			newQueryFactory()
				.selectField('Id')
				.selectField('CIF__c')
				.selectField('Telebanking_Charge_Account_Number__c')
				.setCondition('Id IN : accountIdSet OR CIF__c IN : accountCIFSet')
				.toSOQL()
		);
	}

	/**
	 * @description Method that gets a list of person accounts
	 * @param accId
	 * @return Account
	 */
	public Account selectPersonAccountById(String accId) {
		return Database.query(
			newQueryFactory()
				.selectField('Id')
				.selectField('Country_of_Birth__pc')
				.selectField('Country_of_Citizenship__c')
				.selectField('Full_Name_NO_UI__pc')
				.selectField('FirstName')
				.selectField('Country_of_Residence__c')
				.selectField('BillingAddress')
				.selectField('LastName')
				.selectField('PersonTitle')
				.selectField('Initials__pc')
				.selectField('ID_Number__pc')
				.selectField('ID_Type__pc')
				.selectField('PersonBirthdate')
				.selectField('Gender__pc')
				.selectField('Client_Creation_Reason__c')
				.selectField('PersonMobilePhone')
				.selectField('PersonHomePhone')
				.selectField('Phone')
				.selectField('PersonEmail')
				.selectField('Communication_Method__c')
				.selectField('Country_Passport_Issued__pc')
				.selectField('Date_Issued__pc')
				.selectField('Communication_Language__pc')
				.selectField('Occupation_Status__pc')
				.selectField('Occupation__pc')
				.selectField('Occupation_Category__pc')
				.selectField('Employer_Name__pc')
				.selectField('Employer_Sector__pc')
				.selectField('Place_of_Residence__c')
				.selectField('US_Person__c')
				.selectField('Operating_Roles__c')
				.selectField('Type_of_Instruction__c')
				.selectField('Account_Applicable__c')
				.selectField('Instruction_Method__c')
				.selectField('Is_the_Client_a_Temporary_Resident__c')
				.selectField('Country_of_Permanent_Residency__c')
				.selectField('Period_of_Visit__c')
				.selectField('Purpose_of_Visit__c')
				.selectField('Date_of_Arrival_in_South_Africa__c')
				.selectField('Temporary_Resident_Permit__c')
				.selectField('Temporary_Resident_Permit_Expiry_Date__c')
				.setCondition('(Id = :accId OR PersonContactId = :accId) AND IsPersonAccount = TRUE')
				.toSOQL()
		);
	}
	/**
	 * @description
	 * @param ids
	 * @param accountId
	 * @return List<Account>
	 **/
	public List<Account> selectRelatedPartiesByAddressType(Set<Id> ids, Id accountId) {
		return [
			SELECT
				Id,
				Name,
				Registration_Number__c,
				Country_of_Registration__c,
				Trust_Number__c,
				(
					SELECT Id, FinServ__RelatedAccount__c, Roles__c, Shareholding_Percentage__c, FinServ__Account__c, FinServ__Role__r.Name
					FROM FinServ__RelatedToAccounts__r
					WHERE FinServ__Role__r.Name != 'Inverse Testing' AND FinServ__Account__c = :accountId
				),
				(
					SELECT
						Id,
						Client_Entity_Type__c,
						Address_Type__c,
						Shipping_State_Province__c,
						Shipping_Street__c,
						Shipping_Street_2__c,
						Shipping_Zip_Postal_Code__c,
						Shipping_Suburb__c,
						Shipping_City__c,
						Shipping_Country__c
					FROM Addresses__r
					WHERE
						Address_Type__c = 'Head Office'
						OR Address_Type__c = 'Registered'
						OR Address_Type__c = 'Operational'
						OR Address_Type__c = 'Business Address'
				),
				(SELECT Id, Name FROM Trading_as_Names__r)
			FROM Account
			WHERE Id IN :ids
		];
	}

	/**
	 * @description Method that gets a list of CASA specific Account fields
	 *
	 * @param accId - set ofAccount ID
	 * @return List <Account> - list accounts with CASA fields
	 */
	public List<Account> selectCasaBusinessFieldsBySetId(Set<Id> accId) {
		return Database.query(
			newQueryFactory(false)
				.selectField('Id')
				.selectField('Name')
				.selectField('ID_Type__c')
				.selectField('Trust_Number__c')
                .selectField('Trust_Number_New_format__c')
				.selectField('Registration_Number__c')
				.selectField('Client_Type__c')
				.selectField('Client_Group__c')
				.selectField('Country_of_Registration__c')
				.selectField('Country_of_Incorporation__c')
				.selectField('CASA_Analyst_Comments__c')
				.selectField('CASA_Reference_Number__c')
				.selectField('CASA_Screening_Date__c')
				.selectField('CASA_Status__c')
				.selectField('CASA_Screening_Status__c')
				.selectField('Countries_Traded_With__c')
				.selectField('Communication_Method__c')
				.selectField('CIF__c')
				.selectField('RecordType.Name')
				.selectField('BillingStreet')
				.selectField('BillingCity')
				.selectField('BillingPostalCode')
				.selectField('BillingCountry')
				.selectField('BillingState')
				.selectField('ShippingStreet')
				.selectField('PersonContactId')
				.selectField('CASA_Analyst_Comments__c')
				.selectField('Primary_Client__c')
				.setCondition('Id In :accId')
				.toSOQL()
		);
	}

	/**
	 * @description Method that gets a list of CASA specific Account fields
	 *
	 * @param accountId of - PersonContact ID's
	 * @return List <Account> - list accounts with CASA fields
	 */
	public List<Account> selectRelatedPartyBusinessCASAByAccountId(Id accountId) {
		return Database.query(
			newQueryFactory()
				.selectField('CASA_Screening_Status__c')
				.selectField('CASA_Screening_Date__c')
				.selectField('CASA_Reference_Number__c')
				.selectField('Country_of_Citizenship__c') // W-004987
				.selectField('CASA_Reference_Number2__c') // W-004987
				.selectField('CASA_Screening_Date2__c') // W-004987
				.selectField('CASA_Screening_Status_2__c') // W-004987
				.setCondition('id = :accountId')
				.toSOQL()
		);
	}
	/**
	 * @description
	 * @param personContactIdSet
	 * @return List<Account>
	 **/
	public List<Account> selectCasaFieldsByPersonContactSetIds(Set<Id> personContactIdSet) {
		return (List<Account>) Database.query(
			newQueryFactory()
				.selectField('FirstName')
				.selectField('MiddleName') //W-010679
				.selectField('LastName')
				.selectField('RecordType.Name')
				.selectField('CASA_Screening_Status__pc')
				.selectField('CASA_Screening_Date__pc')
				.selectField('CASA_Reference_Number__pc')
				.selectField('Country_of_Residence__c')
				.selectField('pepSts__c')
				.selectField('ID_Type__pc')
				.selectField('ID_Type__c')
				.selectField('ID_Number__pc')
				.selectField('BillingStreet')
				.selectField('BillingCity')
				.selectField('BillingPostalCode')
				.selectField('BillingCountry')
				.selectField('BillingState')
				.selectField('ShippingStreet')
				.selectField('Passport_Number__pc')
				.selectField('PersonTitle')
				.selectField('Initials__pc')
				.selectField('PEP_Status__pc') //added By Anka
				.selectField('Country_of_Citizenship__c') // W-004987
				.selectField('CASA_Reference_Number2__c') // W-004987
				.selectField('CASA_Screening_Date2__c') // W-004987
				.selectField('CASA_Screening_Status_2__c') // W-004987
				.selectField('ByPassValidationInApexPer__pc') // W-007479
				.selectField('RelPartyWithClosedOpportunity__pc') // W-007479
				.selectField('Process_Type__c') // W-007479
				.selectField('IsClosedOpportunity__pc') // W-007479
				.selectField('Casa_Status__c')
				.selectField('Registration_Number__c')
				.selectField('PersonBirthdate')
				.selectField('PersonHomePhone')
				.selectField('Employer_Name__pc')
				.selectField('Country_Passport_Issued__pc')
				.selectField('Residential_Status__pc')
				.selectField('PersonEmail')
				.selectField('Marital_Status__pc')
				.selectField('Valid_Update_Bypass__c') // W-12000
				.selectField('Risk_Status__c')
				.selectField('Fraud_Status__c')
				.setCondition('PersonContactId In :personContactIdSet')
				.toSOQL()
		);
	}

	//CUSTOM SELECTORS - END
}