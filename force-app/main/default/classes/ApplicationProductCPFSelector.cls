/**
*   @description Apex Enterprise Design Patters
* Selector layer for Application_Product_CPF__c objects
*
*  @author  Haritha P
*  @since   11/30/2020
*/

public class ApplicationProductCPFSelector extends fflib_SObjectSelector{

/**
*  @description Method to retrieve the sObjectType
*
* @return Schema.SObjectType  The sObjectType
*/
    public Schema.SObjectType getSObjectType() {
        return Application_Product_CPF__c.sObjectType;
    }

/**
*  @description Method to retrieve the list of fields on the sObject
*
*  @return  List<Schema.SObjectField>   The list of sObjectFields
*/
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField>{
            Application_Product_CPF__c.Id,
                Application_Product_CPF__c.Application__c
                };
                    }

/**
*  @description Method to retrieve Application_Product_CPF__c records based on an Appliaction Id
*  @param   ApplicationId
*  @return  Application_Product_CPF__c    Application_Product_CPF__c record
*/
    public  Application_Product_CPF__c selectByAppId(Id ApplicationId) {
        return Database.query(
            newQueryFactory().
            selectField('Id').
            selectField('Name').
            selectField('Secondary_Account_Applicable__c'). // PJAIN: 20200531
            selectField('Retention_amount__c').
            selectField('Amount_of_existing_register_mortgage_bon__c').
            selectField('Is_VAT_facility_applicable__c').
            selectField('Remaining_available_amount__c').
            selectField('Prime_rate_margin__c').
            selectField('Application__c').
            selectField('Drawdown_amount__c').
            selectField('Difference_clause_applicable__c').
            selectField('Include_balance_on_existing_account__c').
            selectField('Include_VAT_on_charges__c').
            selectField('Other_amounts_included_in_total_facility__c').
            selectField('Repayment_options__c').
            selectField('Interest_rate_basis__c').
            selectField('Interest_service_frequency__c').
			selectField('VAT_Facility_Final_instalment_amount__c').
            selectField('Margin__c').
            selectField('Include_repayment_schedule__c').
            selectField('Instalment_amount__c').
            selectField('Instalment_periods__c').
            selectField('Term__c').
            selectField('Date_of_final_repayment__c').
			selectField('Property_description_Dev__c').
			selectField('Development_loan_Purpose__c').
			selectField('VAT_Facility_Fee__c').
			selectField('VAT_Repayment_Options__c').
            selectField('Final_repayment_date__c').
            selectField('Number_of_periods_months__c').
            selectField('Number_of_periods_after_first_drawdown__c').
            selectField('Was_a_desktop_valuation_done__c').
            selectField('Obligor_incorporated_outside_of_SA__c').
            selectField('Environmental_permits__c').
            selectField('Financial_assistance__c').
            selectField('Electrical_compliance_certificate__c').
            selectField('Newly_formed_company__c').
            selectField('Borrowers_contribution_toward_acquisitio__c').
            selectField('Purchase_price__c').
            selectField('Pre_let__c').
            selectField('Restraint_against_free_alienation_notari__c').
            selectField('Pre_let_review__c').
            selectField('Notarially_Tied_Consolidation__c').
            selectField('Property_1__c').
            selectField('Property_2__c').
            selectField('Transactional_covenants_applicable__c').
            selectField('Covenants_applicable_to_the_Borrower__c').
            selectField('Covenants_applicable_to_the_Parent__c').
            selectField('Covenants_applicable_to_the_Guarantor_s__c').
            selectField('Covenants_applicable_to_the_Security_Pro__c').
            selectField('Other_Entity__c').
            selectField('Measurement_period__c').
            selectField('Financial_year_of__c').
            selectField('Consecutive_period_of_months__c').
            selectField('Financial_covenants_by_reference__c').
            selectField('Security_Provider_Consent__c').
            selectField('Indebtedness__c').
            selectField('Loan_To_Value_Covenant__c').
            selectField('Property_value_to_not_be_exceeded__c').
            selectField('Period__c').
            selectField('Vacancy_cover_ratio__c').
            selectField('Debt_service_cover_ratio2__c').
            selectField('Debt_service_cover_ratio__c').
            selectField('Financial_covenants_applicable__c').
            selectField('Corporate_covenants_applicable__c').
            selectField('Bank_conveyancer_contact_person__c').
            selectField('Bank_conveyancer_firm_details__c').
            selectField('Bank_conveyancer_contact_details__c').
            selectField('Owner_Occupied__c').
            selectField('Property_description__c').
            selectField('Facility_purpose__c').
            selectField('Monthly_charging_date__c').
            selectField('Further_loan_options__c').
            selectField('Amendment_and_restatement_clause_app__c').
            selectField('Withdrawal__c').
            selectField('When__c').
            selectField('Late_bond_registration_penalty__c').
            selectField('Cancellation_fee_payable__c').
            selectField('Include_guarantor_s__c').
            selectField('Admin_fee__c').
            selectField('Admin_fee_amount__c').
            selectField('Payable__c').
            selectField('Account_type__c').
            selectField('Include_admin_fee_in_total_facility2__c').
            selectField('Include_admin_fee_in_total_facility__c').
            selectField('Valuation_fee__c').
            selectField('Valuation_fee_amount__c').
            selectField('Restructure_fee__c').
            selectField('Commitment_Fee__c').
            selectField('Flexi_facility__c').
            selectField('Early_termination_fee__c').
            selectField('Early_termination_fee_year_1__c').
            selectField('Early_termination_fee_year_2__c').
            selectField('Early_termination_fee_year_3__c').
            selectField('Early_termination_fee_further_years__c').
            selectField('Prepayment_fee__c').
            selectField('Early_prepayment_fee_year_1__c').
            selectField('Early_prepayment_fee_year_2__c').
            selectField('Early_prepayment_fee_year_3__c').
            selectField('Other_fees_applicable__c').
            selectField('Cancellation_after_acceptance_clause__c').
            selectField('Payment_Requirements__c').
            selectField('Payment_requirements_details__c').
            selectField('Property_selection__c').
			selectField('Property_portfolio_description__c').
            selectField('Lease_options__c').
            selectField('Other_Leases__c').
            selectField('CPF_account_number__c').
            selectField('Purpose_as_approved_by_credit__c').
            selectField('Property_valuation_amount__c').
			selectField('Property_description_property__c').
            selectField('Borrowers_contribution_toward_acquisiti__c').
            selectField('Final_date_for_drawdown__c').
            selectField('Financial_statements__c').
            selectField('Financial_statements_for_year_ended_bo__c').
            selectField('Including_financial_statements_of_guaran__c').
            selectField('Financial_statements_for_year_ended_gu__c').
            selectField('Consolidated_financial_statements_for_y__c').
            selectField('Guarantor_s_to_provide_the_bank_with_fi__c').
            selectField('Parent_to_provide_the_bank_with_financia__c').
            selectField('The_bank_reserves_the_right_to__c').
            selectField('Already_held__c').
            selectField('Borrower_has_subsidiaries__c').
			selectField('Property_type__c').
			selectField('Development_description__c').
			selectField('Other_property_type__c').
			selectField('Development_loan_Is_VAT_Facility_applica__c').
			selectField('Development_loan_VAT_Facility_amount__c').
			selectField('Aggregate_maximum_amount__c').
			selectField('Amount_outstanding__c').
			selectField('Development_loan_Term__c').
			selectField('Development_loan_Final_Repayment_Date__c').
            selectField('Guarantor_s_has_have_subsidiaries__c').
            selectField('Unaudited_interim_statements_required__c').
            selectField('Financial_information_required__c').
			selectField('Development_Facility_purpose__c').
            selectField('Unaudited_interim_statements_available__c').
            selectField('Financial_statements_available_no_later__c').
			selectField('Include_balance_sheet_profit_loss_acc__c').
            selectField('Other_financial_information__c').
            selectField('Borrower_under_CPA__c').
            selectField('Transactional_banking_accounts__c').
            selectField('Undertakings_threshold__c').
			selectField('Threshold_periods__c').
			selectField('Additional_finance_documents__c').
            selectField('Replacement_value__c').
            selectField('Available__c').
            selectField('Opportunity_Product_Id__c').
            selectField('Corporate_Interest_Cover_Ratio__c').
            selectField('Gearing_Ratio__c').
            selectField('Asset_Type__c').
            selectField('Leverage_Ratio__c').
            selectField('Cash_Flow_Cover_Ratio__c').
            selectField('Dividend_Cover_Ratio__c').
            selectField('Minimum_NTA_Type__c').
            selectField('Minimum_NTA_Ratio__c').
            selectField('Corporate_covenants_applicable__c').
            selectField('Multiple_phases_applicable__c').
            selectField('Early_termination_fee_during_development__c').
            selectField('Late_bond_registration_penalty__c').
            selectField('Cancellation_after_acceptance_clause__c').
            selectField('Are_breakage_costs_applicable__c').
            selectField('Performance_Guarantees__c').
            selectField('Is_Section_82_Certificate__c').
            selectField('Is_Bank_Contractor_Insurance_Company__c').
            selectField('Is_Confirmation_From_Architect__c').
            selectField('Is_Structural_Integrity_Certificate__c').
            selectField('Is_Confirmation_Mech_Elec_Design__c').
            selectField('Is_Fire_Design__c').
            selectField('Is_Sufficient_Budget__c').
            selectField('Is_Professional_Certificate__c').
            selectField('Payment_Made_Amount__c').
            selectField('Is_Sectional_Title_Plan_Approved__c').
            selectField('Is_Upon_Completion_Of_Development__c').
            selectField('Final_date_for_drawdown__c').
            selectField('Equity_contributions__c').
            selectField('Equity_contribution_amount__c').
            selectField('Other_equity_contributions__c').
            selectField('Cross_default_threshold_amount__c').
            selectField('Litigation_threshold_amount__c').
            selectField('Pre_sales__c').
             selectField('Non_refundable_deposit__c').
             selectField('Non_refundable_deposit_amount__c').
             selectField('Non_refundable_deposit_percentage__c').
             selectField('Multiple_purchase__c').
             selectField('Multiple_purchase_deposit_amount__c').
             selectField('Multiple_purchase_Deposit_percentage__c').
             selectField('Proof_of_Pre_sales__c').
             selectField('Number_of_pre_sales__c').
             selectField('Aggregate_price__c').
             selectField('Schedule_of_net_sale__c').
             selectField('Schedule_of_sales__c').
             selectField('Max_by_single_investor__c').
             selectField('Copy_of_standard_sales_agreement__c').
             selectField('Copies_of_all_sale_agreements__c').
             selectField('Interest_Service_Cover_Ratio__c').
             selectField('Interest_Cover_Ratio__c').
             selectField('Conversion_options__c').
             selectField('Interest_Only_Period__c').
             selectField('Starting_Stepped_Instalment__c').
             selectField('Escalating_Perc__c').
             selectField('Instalment_periods__c').
             selectField('Interest_service_frequency__c').
             selectField('Final_Instalment_Amount__c').
             selectField('Loan_To_Cost__c').
             selectField('Loan_To_Cost_Picklist__c').
             selectField('Capitalised_Interest__c').
             selectField('Professional_certificate__c').
             selectField('Gap_insurance__c').
            setCondition('Application__c =: ApplicationId').
            toSOQL()
        );
    }

/**
* @description  Method to retrieve Application_Product_CPF__c records based on an Appliaction Id
*
* @param   ApplicationId    The Application Id
*
* @return  Application_Product_CPF__c   record
*Tinashe M Shoko because its better to work with a list
*/
    public  List<Application_Product_CPF__c> selectListByAppId(Id ApplicationId) {
        List<Application_Product_CPF__c> appProdCPF = new List<Application_Product_CPF__c>();
        String query = ' SELECT ';
        String field_name = null;
        Map< String, Schema.SObjectField > field_oject_map = Schema.getGlobalDescribe().get('Application_Product_CPF__c').getDescribe().Fields.getMap();
        List<Schema.SObjectField> field_object_values_map = field_oject_map.values();

        for( Schema.SObjectField s : field_object_values_map ){
            field_name = s.getDescribe().getName();
            query += field_name + ', ';
        }

        query = query.subStringBeforeLast(',');
        query += ' FROM Application_Product_CPF__c WHERE Application__c =  \'' + applicationid + '\'';

        appProdCPF = (List<Application_Product_CPF__c>)Database.query( query );
        return appProdCPF;
    }

/**
*  @description Method to retrieve Application_Product_CPF__c records based on an its Id
*  @param   appPrdctId
*  @return  Application_Product_CPF__c
*/
    public  Application_Product_CPF__c selectById(Id appPrdctId) {
        return Database.query(
            newQueryFactory().
            selectField('Id').
            selectField('Name').
            selectField('Secondary_Account_Applicable__c'). // PJAIN: 20200531
            selectField('Retention_amount__c').
            selectField('Amount_of_existing_register_mortgage_bon__c').
            selectField('Is_VAT_facility_applicable__c').
            selectField('Remaining_available_amount__c').
            selectField('Prime_rate_margin__c').
            selectField('Application__c').
            selectField('Drawdown_amount__c').
            selectField('Difference_clause_applicable__c').
            selectField('Include_balance_on_existing_account__c').
            selectField('Include_VAT_on_charges__c').
            selectField('Other_amounts_included_in_total_facility__c').
            selectField('Repayment_options__c').
            selectField('Interest_rate_basis__c').
            selectField('Interest_service_frequency__c').
            selectField('Margin__c').
            selectField('Include_repayment_schedule__c').
            selectField('Instalment_amount__c').
            selectField('Instalment_periods__c').
            selectField('Term__c').
            selectField('Date_of_final_repayment__c').
            selectField('Final_repayment_date__c').
            selectField('Number_of_periods_months__c').
            selectField('Number_of_periods_after_first_drawdown__c').
            selectField('Was_a_desktop_valuation_done__c').
            selectField('Obligor_incorporated_outside_of_SA__c').
            selectField('Environmental_permits__c').
            selectField('Financial_assistance__c').
            selectField('Electrical_compliance_certificate__c').
            selectField('Newly_formed_company__c').
            selectField('Borrowers_contribution_toward_acquisitio__c').
            selectField('Purchase_price__c').
            selectField('Pre_let__c').
            selectField('Restraint_against_free_alienation_notari__c').
            selectField('Pre_let_review__c').
            selectField('Notarially_Tied_Consolidation__c').
            selectField('Property_1__c').
            selectField('Property_2__c').
            selectField('Transactional_covenants_applicable__c').
            selectField('Covenants_applicable_to_the_Borrower__c').
            selectField('Covenants_applicable_to_the_Parent__c').
            selectField('Covenants_applicable_to_the_Guarantor_s__c').
            selectField('Covenants_applicable_to_the_Security_Pro__c').
            selectField('Other_Entity__c').
            selectField('Measurement_period__c').
            selectField('Financial_year_of__c').
            selectField('Consecutive_period_of_months__c').
            selectField('Financial_covenants_by_reference__c').
            selectField('Security_Provider_Consent__c').
            selectField('Indebtedness__c').
            selectField('Loan_To_Value_Covenant__c').
            selectField('Property_value_to_not_be_exceeded__c').
            selectField('Period__c').
            selectField('Vacancy_cover_ratio__c').
            selectField('Debt_service_cover_ratio2__c').
            selectField('Debt_service_cover_ratio__c').
            selectField('Financial_covenants_applicable__c').
            selectField('Corporate_covenants_applicable__c').
            selectField('Bank_conveyancer_contact_person__c').
            selectField('Bank_conveyancer_firm_details__c').
            selectField('Bank_conveyancer_contact_details__c').
            selectField('Owner_Occupied__c').
            selectField('Property_description__c').
            selectField('Final_date_for_drawdown__c').
            selectField('Facility_purpose__c').
            selectField('Monthly_charging_date__c').
            selectField('Further_loan_options__c').
            selectField('Amendment_and_restatement_clause_app__c').
            selectField('Withdrawal__c').
            selectField('When__c').
            selectField('Late_bond_registration_penalty__c').
            selectField('Cancellation_fee_payable__c').
            selectField('Include_guarantor_s__c').
            selectField('Admin_fee__c').
            selectField('Admin_fee_amount__c').
            selectField('Payable__c').
            selectField('Account_type__c').
            selectField('Include_admin_fee_in_total_facility2__c').
            selectField('Include_admin_fee_in_total_facility__c').
            selectField('Valuation_fee__c').
            selectField('Valuation_fee_amount__c').
            selectField('Restructure_fee__c').
            selectField('Commitment_Fee__c').
            selectField('Flexi_facility__c').
            selectField('Early_termination_fee__c').
            selectField('Early_termination_fee_year_1__c').
            selectField('Early_termination_fee_year_2__c').
            selectField('Early_termination_fee_year_3__c').
            selectField('Early_termination_fee_further_years__c').
            selectField('Prepayment_fee__c').
            selectField('Early_prepayment_fee_year_1__c').
            selectField('Early_prepayment_fee_year_2__c').
            selectField('Early_prepayment_fee_year_3__c').
            selectField('Other_fees_applicable__c').
            selectField('Cancellation_after_acceptance_clause__c').
            selectField('Payment_Requirements__c').
            selectField('Payment_requirements_details__c').
            selectField('Property_selection__c').
            selectField('The_bank_reserves_the_right_to__c').
            selectField('Already_held__c').
            selectField('Guarantor_s_to_provide_the_bank_with_fi__c').
            selectField('Parent_to_provide_the_bank_with_financia__c').
            selectField('Lease_options__c').
            selectField('Other_Leases__c').
            selectField('CPF_account_number__c').
            selectField('Purpose_as_approved_by_credit__c').
            selectField('Property_valuation_amount__c').
            selectField('Borrowers_contribution_toward_acquisiti__c').
            selectField('Financial_statements__c').
            selectField('Borrower_has_subsidiaries__c').
            selectField('Guarantor_s_has_have_subsidiaries__c').
            selectField('Unaudited_interim_statements_required__c').
            selectField('Financial_information_required__c').
            selectField('Unaudited_interim_statements_available__c').
            selectField('Financial_statements_for_year_ended_bo__c').
            selectField('Financial_statements_for_year_ended_gu__c').
            selectField('Financial_statements_available_no_later__c').
            selectField('Including_financial_statements_of_guaran__c').
            selectField('Other_financial_information__c').
            selectField('Borrower_under_CPA__c').
            selectField('Consolidated_financial_statements_for_y__c').
            selectField('Transactional_banking_accounts__c').
            selectField('Undertakings_threshold__c').
            selectField('Replacement_value__c').
            selectField('Available__c').
            selectField('Other_amounts_included_in_total_facility__c').
            selectField('Multiple_phases_applicable__c').

            selectField('Is_Sectional_Title_Plan_Approved__c').
            selectField('Is_Upon_Completion_Of_Development__c').

            selectField('Final_date_for_drawdown__c').
            selectField('Equity_contributions__c').
            selectField('Equity_contribution_amount__c').
            selectField('Other_equity_contributions__c').
            selectField('Cross_default_threshold_amount__c').
            selectField('Litigation_threshold_amount__c').
            selectField('Corporate_Interest_Cover_Ratio__c').
            selectField('Leverage_Ratio__c').
            selectField('Cash_Flow_Cover_Ratio__c').
            selectField('Dividend_Cover_Ratio__c').
            selectField('Minimum_NTA_Type__c').
            selectField('Minimum_NTA_Ratio__c').
            setCondition('Id =: appPrdctId').
            toSOQL()
        );
    }
}