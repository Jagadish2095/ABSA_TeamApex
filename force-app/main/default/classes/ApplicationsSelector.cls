/**
 * Apex Enterprise Design Patters
 * @description Selector layer for Application__c objects
 *
 * @author  Nelson Chisoko (Dariel)
 * @since   11/02/2019
 */
public class ApplicationsSelector extends fflib_SObjectSelector {
	/**
	 * @description Method to retrieve the sObjectType
	 *
	 * @return  Schema.SObjectType  The sObjectType
	 */
	public Schema.SObjectType getSObjectType() {
		return Application__c.sObjectType;
	}

	/**
	 * @description Method to retrieve the list of fields on the sObject
	 *
	 * @return  List<Schema.SObjectField>   The list of sObjectFields
	 */
	public List<Schema.SObjectField> getSObjectFieldList() {
		return new List<Schema.SObjectField>{
			Application__c.Id,
			Application__c.Opportunity__c,
			Application__c.Client_Entity_Type__c,
			Application__c.AIPS__c,
			Application__c.Customer_Region__c
		};
	}

	//Custom Selectors

	/**
	 * @description Method to retrieve an Application__c based on its Id
	 *
	 * @param   applicationId     The Id of the Application__c record
	 *
	 * @return  Application__c  The application record
	 */
	public Application__c selectById(Id applicationId) {
		return Database.query(
			newQueryFactory()
				.selectField('Id')
				.selectField('Safe_Custody_Payment_Same_As_Drafting__c')
				.selectField('Preferred_Email__c')
				.selectField('Preferred_SMS__c')
				.selectField('Fees_Waived__c')
				.selectField('Safe_Custody_Is_Required__c')
				.selectField('StockServiceTrace__c')
				.selectField('TrackerTrace__c')
				.selectField('UpdateWillTrace__c')
				.selectField('What_is_the_intended_investment_term__c')
				.selectField('What_investment_experience_do_you_have__c')
				.selectField('understand_financial_markets_and_investm__c')
				.selectField('investment_opportunities__c')
				.selectField('Number_of_dependants__c')
				.selectField('income_grow_in_relation_to_inflation__c')
				.selectField('liquidity_to_cover_emergencies__c')
				.selectField('Signing_Date__c')
				.selectField('Account_Maintenance__c')
				.selectField('Change_Limits__c')
				.selectField('Issue_New_or_Replacement_Cards__c')
				.selectField('Number_of_Signatories_for_account_Operat__c')
				.selectField('Special_Instruction__c')
				.selectField('Signature_Type__c')
				.selectField('Signing_Authority_From_Date__c')
				.selectField('In_Terms_Of_Resolution_Dated__c')
				.selectField('Signed_at__c')
				.selectField('Signed_on__c')
				.selectField('global_application_form__c')
				.selectField('Standard_Absa_resolution_for_you__c')
				.selectField('Absa_mandate_and_indemnity__c')
				.selectField('Standard_Absa_site_visit_for_you__c')
				.selectField('Standard_Absa_power_of_attorney_for_you__c')
				.selectField('Record_of_telephonic_engagement__c')
				.selectField('Are_all_the_related_parties__c')
				.selectField('Is_there_more_than_one_natural_person__c')
				.selectField('Foreign_Exchange_Authority_Form_for_you__c')
				.selectField('Settlement_type__c')
				.selectField('Site_visit_date__c')
				.selectField('Address_type__c')
				.selectField('First_Name__c')
				.selectField('Surname__c')
				.selectField('Completed_By__c')
				.selectField('Meeting_Held_At__c')
				.selectField('Meeting_Date__c')
				.selectField('Delegates_Meeting_Date__c')
				.selectField('Extract_signed_date__c')
				.selectField('Meeting_Of__c')
				.selectField('Delegates_at_Meeting__c')
				.selectField('Number_of_Signatories_for_account_Operat__c')
				.selectField('Transactional_Account__c')
				.selectField('Account_Access__c')
				.selectField('Foreign_Services__c')
				.selectField('Surplus_Cash__c')
				.selectField('Borrowing_Requiment_General__c')
				.selectField('Borrowing_requiment_Assest_Acquisition__c')
				.selectField('Protection_Of_Services__c')
				.selectField('Protection_Of_Services_Business__c')
				.selectField('Products_And_Services__c')
				.selectField('Title__c')
				.selectField('FirstNameSignature__c')
				.selectField('SurnameSignature__c')
				.selectField('Signing_Date__c')
				.selectField('Source_of_Funds_Savings__c')
				.selectField('Payment__c')
				.selectField('Net_Asset_Value__c')
				.selectField('Current_Situation__c')
				.selectField('Current_Finacial_Product_Experience__c')
				.selectField('Needs_or_Objectives__c')
				.selectField('Macro_or_Sectorial_Firm__c')
				.selectField('Other_Macro_or_Sectorial_Comments__c')
				.selectField('General_Notes__c')
				.selectField('Did_Client_Select_Product__c')
				.selectField('Produts_Considered__c')
				.selectField('Product_Recommended_to_Client__c')
				.selectField('Reason_why_Recommended_not_Recommended__c')
				.selectField('Presentation_Name__c')
				.selectField('Presentation_Group_Name__c')
				.selectField('Presentation_Date__c')
				.selectField('Presentation_Location__c')
				.selectField('Presentation_Folio_Number__c')
				.selectField('First_Name__c')
				.selectField('Surname__c')
				.selectField('Designation__c')
				.selectField('Stock_Number__c')
				.selectField('Date__c')
				.selectField('Client_Under_Supervision__c')
				.selectField('Advice_Given__c')
				.selectField('Replacing_an_Existing_Product__c')
				.selectField('Total_number_of_accounts_to_be_Open__c')
				.selectField('Client_Entity_Type__c')
				.selectField('Investment_Number_s__c') /*W-006717*/
				.selectField('Investor_Type__c') /*W-006717*/
				.selectField('Specify_Other_Investment_Type__c') /*W-006717*/
				.selectField('Investment_Product_s_please_list_them__c') /*W-006717*/
				.selectField('applicable_option__c') /*W-006717*/
				.selectField('Exemption__c') /*W-006717*/
				.selectField('Comments_on_explanation_given_for_Source__c')
				.selectField('SA_Account_SA_Resident_Not_US_Person__c')
				.selectField('Tick_this_box_if_you_are_a_US_person__c')
				.selectField('US_Person_Country__c')
				.selectField('US_Person_Tax_Identification_Number__c')
				.selectField('US_Person_Tax_number_not_available__c')
				.selectField('Reason_tax_number_not_available_Supply__c')
				.selectField('Standard_Absa_US_Person_for_you__c')
				.selectField('Auto_Increase_Limit__c') //W-006358
				.selectField('Recalc_Limit__c') //W-006358
				.selectField('Credit_Agreement_NCA__c') //W-006358
				.selectField('Absa_Reward__c') //W-006358
				.selectField('Reward_Debit_Account__c') //W-006358
				.selectField('Rewards_Terms_Conditions__c') //W-006358
				.selectField('Credit_Life_Benefit__c') //W-006358
				.selectField('Electronic_Statements__c') //W-006518
				.selectField('Parent__c')
				.selectField('Is_the_parent_also_a_guarantor__c')
				.selectField('Name__c')
				.selectField('Registration_incorporation_numb__c')
				.selectField('Required_numof_signatories_to_give_instr__c')
				.selectField('Number_of_days_for_Borrower_to_accept_of__c')
				.selectField('Change_of_control_party__c')
				.selectField('DERPCOUNIQUENUMBER__c')
				.selectField('Platform__c')
				.selectField('Product_Wrapper__c')
				.selectField('House_Portfolio__c')
				.selectField('Purpose_of_Account__c')
				.selectField('Purpose_of_Account_Text__c')
				.selectField('Account_Activity_Calculator__c')
				.selectField('Customer_Region__c')
				.selectField('Date_of_Completion__c')
				.setCondition('Id =: applicationId')
				.toSOQL()
		);
	}

	/**
	 * @description selectByIdForValueAddService description
	 *
	 * @param applicationId (Id): applicationId
	 * @return Application__c: Return description
	 */
	public Application__c selectByIdForValueAddService(Id applicationId) {
		return Database.query(
			newQueryFactory()
				.selectField('Id')
				.selectField('Transactional_Account__c')
				.selectField('Account_Access__c')
				.selectField('Foreign_Services__c')
				.selectField('Surplus_Cash__c')
				.selectField('Borrowing_Requiment_General__c')
				.selectField('Borrowing_requiment_Assest_Acquisition__c')
				.selectField('Protection_Of_Services__c')
				.selectField('Protection_Of_Services_Business__c')
				.selectField('Products_And_Services__c')
				.selectField('Title__c')
				.selectField('FirstNameSignature__c')
				.selectField('SurnameSignature__c')
				.selectField('Signing_Date__c')
				.selectField('Account_to_be_debited_monthly_with_the_c__c')
				.selectField('Combi_Record_Number__c')
				.selectField('Number_of_authorisations_that_will_be_re__c')
				.selectField('Number_of_main_users__c')
				.selectField('Fee_Structure_code__c')
				.selectField('Absa_online_for_business_BIB__c')
				.selectField('Cell_phone_banking__c')
				.selectField('Telephone_banking__c')
				.selectField('Notifyme__c')
				.selectField('Funds_transfer__c')
				.selectField('Bill_payments__c')
				.selectField('Own_defined_payments__c')
				.selectField('Future_dated_payments__c')
				.selectField('Stop_order_payments__c')
				.selectField('Record_of_telephonic_engagement__c')
				.selectField('Are_all_the_related_parties__c')
				.selectField('Is_there_more_than_one_natural_person__c')
				.selectField('Foreign_Exchange_Authority_Form_for_you__c')
				.selectField('Settlement_type__c')
				.selectField('Site_visit_date__c')
				.selectField('Address_type__c')
				.selectField('First_Name__c')
				.selectField('Surname__c')
				.selectField('Signed_at__c')
				.selectField('Signed_on__c')
				.selectField('Completed_By__c')
				.selectField('Stock_Number__c')
				.setCondition('Id =: applicationId')
				.toSOQL()
		);
	}

	/**
	 * @description selectAppWithIds description
	 *
	 * @param idSet (Set<String>): idSet
	 * @return List<Application__c>: Return description
	 */
	public List<Application__c> selectAppWithIds(Set<String> idSet) {
		return Database.query(
			newQueryFactory(false)
				.selectField('Id')
				.selectField('ASV_Securities__c')
				.selectField('MASV_Bonds__c')
				.selectField('MASV_Securities__c')
				.selectField('opportunity__r.account.Registration_Number__c')
				.setCondition('Id IN :idSet')
				.toSOQL()
		);
	}

	/**
	 * @description Method to retrieve Application__c records based on an Opportunity Id
	 *
	 * @param   opportunityId           The Opportunity Id
	 * @return  List<Application__c>    A list of Application__c records
	 */
	public List<Application__c> selectByOpportunityId(Id opportunityId) {
		return Database.query(
			newQueryFactory()
				.selectField('Id')
				.selectField('Opportunity__c')
				.selectField('Safe_Custody_Payment_Same_As_Drafting__c')
				.selectField('Credit_Application_Status__c')
				.selectField('Preferred_Email__c')
				.selectField('Preferred_SMS__c')
				.selectField('AIPS__c')
				.selectField('Preferred_Communication_Method__c')
				.selectField('Will_Stock_Confirmation__c')
				.selectField('Will_Created_In_Will_System__c')
				.selectField('Will_Record_Created_In_SF__c')
				.selectField('Will_Initialise_Tracker_Create__c')
				.selectField('Get_Will_Detail__c')
				.selectField('Will_Drafting_Banking_Detail_Created__c')
				.selectField('Will_Banking_Detail_Created__c')
				.selectField('Will_Update_To_CIF__c')
				.selectField('Will_Communication_Sent__c')
				.selectField('Will_Asset_Liabilities_Created__c')
				.selectField('Will_Registration_Tracker_Retreive__c')
				.selectField('Will_Registration_Tracker_Created__c')
				.selectField('Will_Reg_Stock_Service_Error__c')
				.selectField('Will_Reg_Asset_creation_in_Will_Sy_Error__c')
				.selectField('Will_Reg_Asset_creation_in_SF_Error__c')
				.selectField('Will_Initialise_Tracker_Created_Error__c')
				.selectField('Will_Reg_Get_Asset_from_Will_Error__c')
				.selectField('Will_Reg_Asset_update_in_Will_Sys_Error__c')
				.selectField('Will_Reg_Crete_Will_Banking_Detail_Error__c')
				.selectField('Will_Reg_Asset_update_In_CIF_Sys_Error__c')
				.selectField('Will_Registration_Tracker_Retreive_Error__c')
				.selectField('Will_Registration_Tracker_Created_Error__c')
				.selectField('Will_Drafting_Banking_Detail_Error__c')
				.selectField('Will_Asset_Liabilities_Created_Error__c')
				.selectField('Will_Communication_Sent_Error__c')
				.selectField('Revision_Get_Asset_from_Will_Error__c')
				.selectField('Revision_Drafting_Banking_Detail_Error__c')
				.selectField('Revision_Crete_Will_Banking_Detail_Error__c')
				.selectField('Revision_Asset_Liabilities_Created_Error__c')
				.selectField('Revision_Will_Update_Error__c')
				.selectField('Revision_Reg_Tracker_Created_Error__c')
				.selectField('Registration_Status__c')
				.selectField('Drafting_Fee_Status__c')
				.selectField('Communication_Preference_Status__c')
				.selectField('Safe_Custody_Status__c')
				.selectField('Fees_Waived__c')
				.selectField('Fee_For_Estate_Provider_Plan__c')
				.selectField('Fee_For_Staff__c')
				.selectField('Safe_Custody_Is_Required__c')
				.selectField('Will_Type__c')
				.selectField('Legality_Checking_Completed__c')
				.selectField('Legality_Checking_Required__c')
				.selectField('Legality_Check_Required_Reason__c')
				.selectField('Drafting_Banking_Details_Validated__c')
				.selectField('Safe_Custody_Banking_Details_Validated__c')
				.selectField('StockServiceTrace__c')
				.selectField('TrackerTrace__c')
				.selectField('UpdateWillTrace__c')
				.selectField('Merchant_Estatements_Email_Address__c')
				.selectField('All_transaction_type__c')
				.selectField('Payment__c')
				.selectField('Withdrawal__c')
				.selectField('Deposit__c')
				.selectField('Returned_Transactions__c')
				.selectField('Scheduled_transaction__c')
				.selectField('Purchases__c')
				.selectField('Notification_time__c')
				.selectField('Minimum_amount__c')
				.selectField('Minimum_Amount1__c')//15225
                .selectField('Notification_Time_Window__c')//15225
				.selectField('Balance_update__c')
				.selectField('Specific_day__c')
				.selectField('Account_to_be_debited_monthly_with_the_c__c')
				.selectField('Combi_Record_Number__c')
				.selectField('Number_of_authorisations_that_will_be_re__c')
				.selectField('Number_of_main_users__c')
				.selectField('Fee_Structure_code__c')
				.selectField('Absa_online_for_business_BIB__c')
				.selectField('Cell_phone_banking__c')
				.selectField('Telephone_banking__c')
				.selectField('Notifyme__c')
				.selectField('Funds_transfer__c')
				.selectField('Bill_payments__c')
				.selectField('Own_defined_payments__c')
				.selectField('Future_dated_payments__c')
				.selectField('Stop_order_payments__c')
				.selectField('Settlement_type__c')
				.selectField('Site_visit_date__c')
				.selectField('First_Name__c')
				.selectField('Surname__c')
				.selectField('Application_Number__c')
				.selectField('Trading_Address__c')
				.selectField('Address_type__c')
				.selectField('Completed_By__c')
				.selectField('Signed_at__c')
				.selectField('Signed_on__c')
				.selectField('Stock_Number__c')
				.selectField('Account_Access__c')
				.selectField('Foreign_Services__c')
				.selectField('Surplus_Cash__c')
				.selectField('Borrowing_Requiment_General__c')
				.selectField('Borrowing_requiment_Assest_Acquisition__c')
				.selectField('Protection_Of_Services__c')
				.selectField('Protection_Of_Services_Business__c')
				.selectField('Products_And_Services__c')
				.selectField('Transactional_Account__c')
				.selectField('Designation__c')
				.selectField('Signature_Type__c')
				.selectField('Meeting_Of__c')
				.selectField('Meeting_Held_At__c')
				.selectField('Meeting_Date__c')
				.selectField('Delegates_Meeting_Date__c')
				.selectField('Extract_signed_date__c')
				.selectField('Delegates_at_Meeting__c')
				.selectField('Source_of_Funds_Savings__c')
				.selectField('Number_of_Signatories_for_account_Operat__c')
				.selectField('Req_NumOf_signs_to_Open_Close_Accounts__c')
				.selectField('Required_numof_signatories_to_give_instr__c')
				.selectField('individual_s_is_are_authorised_to_act__c')
				.selectField('Client_Under_Supervision__c')
				.selectField('Advice_Given__c')
				.selectField('Replacing_an_Existing_Product__c')
				.selectField('Total_number_of_accounts_to_be_Open__c')
				.selectField('verify_the_address_and_or_Trade_Name__c')
				.selectField('Client_Entity_Type__c')
				.selectField('Comments_on_explanation_given_for_Source__c')
				.selectField('PCI_DSS_Checkbox_1__c')
				.selectField('RecordTypeId')
				.selectField('Medium__c')
				.selectField('Purpose_of_Account__c')
				.selectField('Purpose_of_Account_Text__c')
				.selectField('Account_Activity_Calculator__c')
				.selectField('SA_Account_SA_Resident_Not_US_Person__c')
				.selectField('Tick_this_box_if_you_are_a_US_person__c')
				.selectField('US_Person_Country__c')
				.selectField('US_Person_Tax_Identification_Number__c')
				.selectField('US_Person_Tax_number_not_available__c')
				.selectField('Reason_tax_number_not_available_Supply__c')
				.selectField('Standard_Absa_US_Person_for_you__c')
				.selectField('Is_Principal_Shareholder_Info_Correct__c')
				.selectField('Pending_Debt_Counselling_Application__c')
				.selectField('Date_of_Application__c')
				.selectField('Currently_Undergoing_Debt_Counselling__c')
				.selectField('Name_of_Debt_Counsellor__c')
				.selectField('Ever_Undergone_Debt_Counselling__c')
				.selectField('Debt_Counselling_Clearance_Date__c')
				.selectField('Standard_Absa_Debt_Counselling_for_you__c')
				.selectField('Standard_Absa_Annual_Credit_Limit_Incre__c')
				.selectField('Annual_Credit_Limit_Increase__c')
				.selectField('Parent__c')
				.selectField('Is_the_parent_also_a_guarantor__c')
				.selectField('Name__c')
				.selectField('Registration_incorporation_numb__c')
				.selectField('Required_numof_signatories_to_give_instr__c')
				.selectField('Number_of_days_for_Borrower_to_accept_of__c')
				.selectField('Change_of_control_party__c')
				.selectField('Required_numof_signatories_to_give_instr__c')
				.selectField('Absa_Reward__c')
				.selectField('Credit_Life_Benefit__c')
				.selectField('Electronic_Statements__c')
				.selectField('Application_Correctness_Consent__c')
				.selectField('ROAQuestionnaire__c')
				.selectField('Completed_By__r.EmployeeNumber')
				.selectField('Completed_By__r.Name')
				.selectField('For_whom_are_you_generating_the_document__c')
				.selectField('For_whom_are_you_generating_the_document__r.Name')
				.selectField('For_whom_are_you_generating_the_document__r.EmployeeNumber')
				.setCondition('Opportunity__c =: opportunityId')
				.selectField('Platform__c')
				.selectField('Product_Wrapper__c')
				.selectField('House_Portfolio__c')
				.selectField('Investment_Number_s__c')
				.selectField('Investment_Product_s_please_list_them__c')
				.selectField('Investor_Type__c')
				.selectField('Specify_Other_Investment_Type__c')
				.selectField('Exemption__c')
				.selectField('applicable_option__c')
				.selectField('What_is_the_intended_investment_term__c')
				.selectField('What_investment_experience_do_you_have__c')
				.selectField('understand_financial_markets_and_investm__c')
				.selectField('investment_opportunities__c')
				.selectField('Number_of_dependants__c')
				.selectField('income_grow_in_relation_to_inflation__c')
				.selectField('liquidity_to_cover_emergencies__c')
				.selectField('Total_Score__c')
				.selectField('Please_List_All__c')//added by Manish
				.selectField('Purpose_of_Account__c')
				.selectField('Purpose_of_Account_Text__c')
				.selectField('Account_Activity_Calculator__c')
				.selectField('Date_of_Completion__c')
				.selectField('Account_Number__c')
				.selectField('Total_Number_Of_Accounts__c')
				.selectField('New_or_Existing_Mandated_Official__c')
				.selectField('Accounts_Orchestration_JSON__c')
				.selectField('Intermediary_Client_Name__c')
				.selectField('Intermediary_Client_Number__c')
            	.selectField('ROA_SectionD_Table_Value__c')
            	.selectField('ROA_SectionC_Table_Value__c')
           	 	.selectField('General_Notes__c')
            	.selectField('Residential_Address__c')
				.selectField('Address_type__c')
            	.selectField('Confirmation_of_Record_Completion__c')
				.selectField('Automatic_re_investment_of_on_Expiry_Dat__c')
				.selectField('Will_operator_system_be_used__c')
				.selectField('Power_of_Attorney__c')
				.selectField('Account_applicable_to_Special_Power_of_a__c')
				.setCondition('Opportunity__c =: opportunityId')
				.setLimit(50000)
				.toSOQL()
		);
	}

	/**
	 * @description Method to retrieve Application__c records based on an Opportunity Id
	 * @param   opportunityId           The Opportunity Id
	 * @return  List<Application__c>    A list of Application__c records
	 */
	public List<Application__c> selectByOpportunityBranchId(Id opportunityId) {
		return Database.query(
			newQueryFactory()
				.selectField('Id')
				.selectField('Opportunity__c')
				.selectField('Safe_Custody_Payment_Same_As_Drafting__c')
				.selectField('Preferred_Email__c')
				.selectField('Preferred_SMS__c')
				.selectField('Preferred_Communication_Method__c')
				.selectField('Will_Stock_Confirmation__c')
				.selectField('Will_Created_In_Will_System__c')
				.selectField('Will_Record_Created_In_SF__c')
				.selectField('Will_Initialise_Tracker_Create__c')
				.selectField('Get_Will_Detail__c')
				.selectField('Will_Drafting_Banking_Detail_Created__c')
				.selectField('Will_Banking_Detail_Created__c')
				.selectField('Will_Update_To_CIF__c')
				.selectField('Will_Communication_Sent__c')
				.selectField('Will_Asset_Liabilities_Created__c')
				.selectField('Will_Registration_Tracker_Retreive__c')
				.selectField('Will_Registration_Tracker_Created__c')
				.selectField('Will_Reg_Stock_Service_Error__c')
				.selectField('Will_Reg_Asset_creation_in_Will_Sy_Error__c')
				.selectField('Will_Reg_Asset_creation_in_SF_Error__c')
				.selectField('Will_Initialise_Tracker_Created_Error__c')
				.selectField('Will_Reg_Get_Asset_from_Will_Error__c')
				.selectField('Will_Reg_Asset_update_in_Will_Sys_Error__c')
				.selectField('Will_Reg_Crete_Will_Banking_Detail_Error__c')
				.selectField('Will_Reg_Asset_update_In_CIF_Sys_Error__c')
				.selectField('Will_Registration_Tracker_Retreive_Error__c')
				.selectField('Will_Registration_Tracker_Created_Error__c')
				.selectField('Will_Drafting_Banking_Detail_Error__c')
				.selectField('Will_Asset_Liabilities_Created_Error__c')
				.selectField('Will_Communication_Sent_Error__c')
				.selectField('Revision_Get_Asset_from_Will_Error__c')
				.selectField('Revision_Drafting_Banking_Detail_Error__c')
				.selectField('Revision_Crete_Will_Banking_Detail_Error__c')
				.selectField('Revision_Asset_Liabilities_Created_Error__c')
				.selectField('Revision_Will_Update_Error__c')
				.selectField('Revision_Reg_Tracker_Created_Error__c')
				.selectField('Registration_Status__c')
				.selectField('Drafting_Fee_Status__c')
				.selectField('Communication_Preference_Status__c')
				.selectField('Safe_Custody_Status__c')
				.selectField('Fees_Waived__c')
				.selectField('Fee_For_Estate_Provider_Plan__c')
				.selectField('Fee_For_Staff__c')
				.selectField('Safe_Custody_Is_Required__c')
				.selectField('Will_Type__c')
				.selectField('Legality_Checking_Completed__c')
				.selectField('Legality_Checking_Required__c')
				.selectField('Legality_Check_Required_Reason__c')
				.selectField('Drafting_Banking_Details_Validated__c')
				.selectField('Safe_Custody_Banking_Details_Validated__c')
				.selectField('StockServiceTrace__c')
				.selectField('TrackerTrace__c')
				.selectField('UpdateWillTrace__c')
				.selectField('Merchant_Estatements_Email_Address__c')
				.selectField('All_transaction_type__c')
				.selectField('Payment__c')
				.selectField('Withdrawal__c')
				.selectField('Deposit__c')
				.selectField('Returned_Transactions__c')
				.selectField('Scheduled_transaction__c')
				.selectField('Purchases__c')
				.selectField('Notification_time__c')
				.selectField('Minimum_amount__c')
				.selectField('Balance_update__c')
				.selectField('Specific_day__c')
				.selectField('Account_to_be_debited_monthly_with_the_c__c')
				.selectField('Combi_Record_Number__c')
				.selectField('Number_of_authorisations_that_will_be_re__c')
				.selectField('Number_of_main_users__c')
				.selectField('Fee_Structure_code__c')
				.selectField('Absa_online_for_business_BIB__c')
				.selectField('Cell_phone_banking__c')
				.selectField('Telephone_banking__c')
				.selectField('Notifyme__c')
				.selectField('Funds_transfer__c')
				.selectField('Bill_payments__c')
				.selectField('Own_defined_payments__c')
				.selectField('Future_dated_payments__c')
				.selectField('Stop_order_payments__c')
				.selectField('Settlement_type__c')
				.selectField('Site_visit_date__c')
				.selectField('First_Name__c')
				.selectField('Surname__c')
				.selectField('Application_Number__c')
				.selectField('Trading_Address__c')
				.selectField('Address_type__c')
				.selectField('Completed_By__c')
				.selectField('Signed_at__c')
				.selectField('Signed_on__c')
				.selectField('Stock_Number__c')
				.selectField('Account_Access__c')
				.selectField('Foreign_Services__c')
				.selectField('Surplus_Cash__c')
				.selectField('Borrowing_Requiment_General__c')
				.selectField('Borrowing_requiment_Assest_Acquisition__c')
				.selectField('Protection_Of_Services__c')
				.selectField('Protection_Of_Services_Business__c')
				.selectField('Products_And_Services__c')
				.selectField('Transactional_Account__c')
				.selectField('Designation__c')
				.selectField('Signature_Type__c')
				.selectField('Meeting_Of__c')
				.selectField('Meeting_Held_At__c')
				.selectField('Meeting_Date__c')
				.selectField('Extract_signed_date__c')
				.selectField('Delegates_at_Meeting__c')
				.selectField('Source_of_Funds_Savings__c')
				.selectField('Number_of_Signatories_for_account_Operat__c')
				.selectField('Req_NumOf_signs_to_Open_Close_Accounts__c')
				.selectField('Required_numof_signatories_to_give_instr__c')
				.selectField('Electronic_Statements__c')
				.selectField('Intermediary_Client_Name__c')
				.selectField('Intermediary_Client_Number__c')
				.setCondition('Opportunity__c =: opportunityId')
				.setLimit(50000)
				.toSOQL()
		);
	}

	/**
	 * @description Method to retrieve Application__c records based on an Opportunity Id
	 * @param   opportunityId           The Opportunity Id
	 * @return  List<Application__c>    A list of Application__c records
	 */
	public List<Application__c> selectByOpportunityOnboardId(Id opportunityId) {
		return Database.query(
			newQueryFactory()
				.selectField('Id')
				.selectField('RecordTypeId') // PJAIN: 20200531
				.selectField('Opportunity__r.RecordTypeId') // PJAIN: 20200531
				.selectField('Opportunity__c')
				.selectField('Decision__c')
				.selectField('Request_Details_Comments__c')
				.selectField('Email_Response_To__c')
				.selectField('SMS_Response_To__c')
				.selectField('Source_of_Funds__c')
				.selectField('Source_of_Funds_Savings__c')
				.selectField('What_is_the_intended_investment_term__c')
				.selectField('What_investment_experience_do_you_have__c')
				.selectField('understand_financial_markets_and_investm__c')
				.selectField('investment_opportunities__c')
				.selectField('income_grow_in_relation_to_inflation__c')
				.selectField('liquidity_to_cover_emergencies__c')
				.selectField('Number_of_dependants__c')
				.selectField('Total_Score__c')
				.selectField('Re_Direct_Fees__c') // Changes done for W-004995 by Chandra dated 12/06/2020
				.selectField('All_transaction_type__c')
				.selectField('Payment__c')
				.selectField('Withdrawal__c')
				.selectField('Deposit__c')
				.selectField('Returned_Transactions__c')
				.selectField('Scheduled_transaction__c')
				.selectField('Purchases__c')
				.selectField('Notification_time__c')
				.selectField('Minimum_amount__c')
				.selectField('Minimum_Amount1__c')//15225
                .selectField('Notification_Time_Window__c')//15225
				.selectField('Balance_update__c')
				.selectField('Specific_day__c')
				.selectField('global_application_form__c')
				.selectField('Standard_Absa_resolution_for_you__c')
				.selectField('Absa_mandate_and_indemnity__c')
				.selectField('Standard_Absa_site_visit_for_you__c')
				.selectField('Standard_Absa_power_of_attorney_for_you__c')
				.selectField('Record_of_telephonic_engagement__c')
				.selectField('Are_all_the_related_parties__c')
				.selectField('Is_there_more_than_one_natural_person__c')
				.selectField('Foreign_Exchange_Authority_Form_for_you__c')
				.selectField('Settlement_type__c')
				.selectField('Site_visit_date__c')
				.selectField('Address_type__c')
				.selectField('First_Name__c')
				.selectField('Surname__c')
				.selectField('Completed_By__c')
				.selectField('completed_By__r.employeenumber')
				.selectField('Trading_Address__c')
				.selectField('Merchant_Id_Ref__r.Merchant_Id__c')
				.selectField('QA_Status_Updated_By__c') // PJAIN: 20200610
				.selectField('Transactional_Account__c')
				.selectField('Account_Access__c')
				.selectField('Foreign_Services__c')
				.selectField('Surplus_Cash__c')
				.selectField('Borrowing_Requiment_General__c')
				.selectField('Borrowing_requiment_Assest_Acquisition__c')
				.selectField('Protection_Of_Services__c')
				.selectField('Protection_Of_Services_Business__c')
				.selectField('Products_And_Services__c')
				.selectField('Title__c')
				.selectField('FirstNameSignature__c')
				.selectField('SurnameSignature__c')
				.selectField('Signing_Date__c')
				.selectField('Purpose_of_Account_Text__c')
				.selectField('Purpose_of_Account__c')
				.selectField('Expected_number_of_credits_per_month__c')
				.selectField('Rand_value_of_credits_per_month__c')
				.selectField('Credits_received_via__c')
				.selectField('Where_will_the_credits_be_coming_from__c')
				.selectField('Number_of_staff_members__c')
				.selectField('Payment_date_of_staff__c')
				.selectField('Number_of_debits_per_month__c')
				.selectField('Number_of_supplier_payments_per_month__c')
				.selectField('Where_are_the_suppliers_located__c')
				.selectField('Rand_value_of_debits_per_month__c')
				.selectField('Reason_for_debit_orders__c')
				.selectField('Account_Activity_Calculator__c')
				.selectField('Stock_Number__c')
				.selectField('Advice_Given__c')
				.selectField('Client_Under_Supervision__c')
				.selectField('Replacing_an_Existing_Product__c')
				.selectField('verify_the_address_and_or_Trade_Name__c')
				.selectField('Meeting_Of__c')
				.selectField('Meeting_Held_At__c')
				.selectField('Meeting_Date__c')
				.selectField('Delegates_Meeting_Date__c')
				.selectField('Extract_signed_date__c')
				.selectField('Delegates_at_Meeting__c')
				.selectField('Number_of_Signatories_for_account_Operat__c')
				.selectField('Total_number_of_accounts_to_be_Open__c')
				.selectField('Client_Entity_Type__c')
				.selectField('Comments_on_explanation_given_for_Source__c')
				.selectField('Delivery_Method__c')
				.selectField('Accrual_Day_of_Month__c')
				.selectField('Capitilisation_Day_of_Week__c')
				.selectField('Capitilisation_Day_of_Month__c')
				.selectField('Charge_Capitalization_Date__c')
				.selectField('Accrual_Day_of_Week__c')
				.selectField('Minimum_amount1__c') //Changes done for W-007524 by Manoj dated 11/24/2020
				.selectField('Statement_Frequency__c') //Changes done for W-007524 by Manoj dated 11/24/2020
				.selectField('Statement_Day_of_the_month__c') //Changes done for W-007524 by Manoj dated 11/24/2020
				.selectField('Account_to_be_debited_monthly_with_the_c__c') //Changes done for W-007524 by Manoj dated 11/24/2020
				.selectField('Combi_Record_Number__c') //Changes done for W-007524 by Manoj dated 11/24/2020
				.selectField('Number_of_authorisations_that_will_be_re__c') //Changes done for W-007524 by Manoj dated 11/24/2020
				.selectField('Number_of_main_users__c') //Changes done for W-007524 by Manoj dated 11/24/2020
				.selectField('Fee_Structure_code__c') //Changes done for W-007524 by Manoj dated 11/24/2020
				.selectField('RecordTypeId')
				.selectField('Credit_Rate_Plan__c')
				.selectField('Is_there_a_Transfer_to_be_performed_for__c')
				.selectField('Notice_period__c')
				.selectField('Liquidity_Split__c')
				.setCondition('Opportunity__c =: opportunityId')
				.selectField('Re_Direct_Fees__c') // Changes done for W-004995 by Chandra dated 12/06/2020
				.selectField('All_transaction_type__c')
				.selectField('Platform__c')
				.selectField('Product_Wrapper__c')
				.selectField('House_Portfolio__c')
				.selectField('Purpose_of_Account__c')
				.selectField('Purpose_of_Account_Text__c')
				.selectField('Account_Activity_Calculator__c')
				.selectField('Date_of_Completion__c')
                .selectField('Confirmation_of_Record_Completion__c')
                .selectField('ROA_SectionC_Table_Value__c')
                .selectField('ROA_SectionD_Table_Value__c')
                .selectField('General_Notes__c')
				.selectField('RecordTypeId')
				.toSOQL()
		);
	}

	/**
	 * @description Method to retrieve Application__c records based on an Opportunity Id List
	 *
	 * @param   opportunityIds           The Opportunity Id
	 *
	 * @return  List<Application__c>    A list of Application__c records
	 *
	 * Tinashe M Shoko - 2020-07-20
	 */
	public List<Application__c> selectByOpportunityIdList(Set<Id> opportunityIds) {
		return Database.query(
			newQueryFactory()
				.selectField('Id')
				.selectField('Application_Status__c')
				.selectField('Opportunity__c')
				.selectField('Merchant_Id_Ref__r.Merchant_Id__c')
				.setCondition('Opportunity__c in :opportunityIds')
				.toSOQL()
		);
	}

	/**
	 * @description selectByOpportunityIdList2 description
	 *
	 * @param opportunityIds (Set<Id>): opportunityIds
	 * @return List<Application__c>: Return description
	 */
	public List<Application__c> selectByOpportunityIdList2(Set<Id> opportunityIds) {
		return Database.query(
			newQueryFactory()
				.selectField('Id')
				.selectField('Opportunity__c')
				.selectField('Opportunity__r.Account.Id')
				.setCondition('Opportunity__c in :opportunityIds')
				.toSOQL()
		);
	}

	/**
	 *  AG- W-005904
	 * @description  Return all email and phone fields related to a Application object
	 * if the owner is a user not a queue
	 *
	 * @param idSet Set<Id>
	 * @return List<Application__c>
	 */
	public List<Application__c> selectByIdWithCommunicationFields(Set<Id> idSet) {
		return Database.query(
			newQueryFactory(false)
				.selectField('Id')
				.selectField('OwnerId')
				.selectField('Communication_Method__c')
				.selectField('Phone__c')
				.selectField('Name')
				.selectField('Client_Name__c')
				.selectField('Email__c')
				.selectField('Client_Email__c')
				.selectField('Client_Number__c')
				.selectField('sd_Response_Email_Address__c')
				.selectField('Owner.Email')
				.selectField('Owner.Type')
				.selectField('Language_Preference__c')
				.setCondition('Id IN :idSet')
				.toSOQL()
		);
	}

	/**
	 * @description Method to retrieve Application__c records based on an Opportunity Id
	 *
	 * @param opportunityId The Opportunity Id
	 * @return Application__c record
	 **/
	public Application__c selectByOppGrants(Id opportunityId) {
		return Database.query(
			newQueryFactory()
				.selectField('Id')
				.selectField('Opportunity__c')
				.selectField('Customer_COG__c')
				.selectField('Customer_Condition_of_Grant__c')
				.selectField('Customer_Condition_of_Grant__c')
				.selectField('Customer_COG_Comment__c')
				.selectField('Internal_COG__c')
				.selectField('Internal_Condition_of_Grant__c')
				.selectField('Internal_COG_Comment__c')
				.selectField('Standard_COG__c')
				.selectField('Standard_Condition_of_Grant__c')
				.selectField('Standard_COG_Standard_Comment__c')
				.setCondition('Opportunity__c =: opportunityId')
				.setLimit(1)
				.toSOQL()
		);
	}

	/**
	 * @description Method to retrieve Application__c records based on an Opportunity Id
	 *
	 * @param opportunityId The Opportunity Id
	 * @return Application__c record
	 **/
	public Application__c selectByCreditOpportunityId(Id opportunityId) {
		return Database.query(
			newQueryFactory()
				.selectField('Id')
				.selectField('Opportunity__c')
				.selectField('Name')
				.selectField('Number_of_Product_Types__c')
				.selectField('AIPS__c')
				.selectField('EDF_ReqCode__c')
				.selectField('EDF_ReqName__c')
				.selectField('Requested_Franchise_Code__c')
				.selectField('Requested_Franchise_Name__c')
				.selectField('CreatedBy.Name')
				.selectField('Is_Principal_Shareholder_Info_Correct__c')
				.selectField('LastModifiedDate')
				.selectField('Stock_Number__c')
			    .selectField('Annual_Turnover__c')  // Saurabh : 20210503 Added Fields for NCA
                .selectField('Asset_Value__c')
				.selectField('Number_of_Trustees__c')
				.selectField('Any_Juristic_Trustees__c') //NCA Fields End
				.selectField('Credit_App_Status_Change_Date__c')
				.selectField('Credit_App_Status_Change_Time__c')
				.selectField('DERPCOUNIQUENUMBER__c')
				.selectField('IsAmendmentRequired__c')
				.selectField('acceptedProductsCount__c')
				.selectField('Asset_Value__c')
				.selectField('Annual_Turnover__c') // Saurabh : 20210503 Added Fields for NCA
				.selectField('NoOfDaysSinceBureauDate__c')
				.selectField('Lookup_Period__c')
				.selectField('Enforce_Rework__c')
				.selectField('acceptedProductsCount__c')
				.selectField('Number_of_Trustees__c')
				.selectField('Any_Juristic_Trustees__c')
				.selectField('ASV_Securities__c')
				.selectField('MASV_Bonds__c')
				.selectField('Accounts_Orchestration_JSON__c')
				.setCondition('Opportunity__c =: opportunityId')
				.setLimit(1)
				.toSOQL()
		);
	}

	/**
	 * @description Method to retrieve Application__c records based on an Opportunity.Account Id
	 *
	 * @param accountIds Set<Id>
	 * @return List<Application__c> record
	 **/
	public List<Application__c> selectByOpportunityAccountId(Set<Id> accountIds) {
		return Database.query(
			newQueryFactory()
				.selectField('Id')
				.selectField('Opportunity__c')
				.selectField('Name')
				.setCondition('Opportunity__r.AccountId IN :accountIds AND Opportunity__r.StageName !=' + '\'Closed\'')
				.toSOQL()
		);
	}
	//Method to get Application record from security Offered object
	/**
	 * @description Method to retrieve Application__c records based on an App Id
	 *
	 * @param appId
	 * @return Application__c record
	 **/
	public Application__c selectByIdFromSecurityOffered(Id appId) {
		return Database.query(
			newQueryFactory()
				.selectField('Id')
				.selectField('Opportunity__c')
				.selectField('Account__c')
				.selectField('Name')
				.selectField('Client_Name__c')
				.selectField('Client_Email__c')
				.selectField('Client_Surname__c')
				.selectField('Delivery_Method__c')
				.selectField('Signed_at__c')
				.selectField('Signed_on__c')
				.setCondition('Id =: appId')
				.setLimit(1)
				.toSOQL()
		);
	}
	/**
	 * @description Method to retrieve Application__c records based on an applicationId
	 *
	 * @param applicationId
	 * @return Application__c record
	 **/
	public Application__c selectByIdForContract(Id applicationId) {
		return Database.query(newQueryFactory().selectField('Id').selectField('Absa_Reward__c').setCondition('Id =: applicationId').toSOQL());
	}

	/**
	 * @description
	 * @param accId
	 * @return List<Application__c>
	 **/
	public List<Application__c> applicationRelatedToAcc(Id accId) {
		return Database.query(
			newQueryFactory(false)
				.selectField('Id')
				.selectField('Account__c')
				.selectField('Purpose_of_Account__c')
				.selectField('Transactional_Account__c')
				.selectField('Source_of_Funds_Savings__c')
				.selectField('Product_Interest__c')
				.selectField('source_of_funds__c') // Added by Mohammed Junaid U for W-009448
				.selectField('account__r.next_refresh_date__c') // Added by Mohammed Junaid U for W-009448
				.setCondition('Account__c = :accId')
				.addOrdering('LastModifiedDate', fflib_QueryFactory.SortOrder.DESCENDING, true) // Added by Mohammed Junaid U for W-009448
				.toSOQL()
		);
	}
}