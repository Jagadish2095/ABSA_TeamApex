/**
* @description Apex Enterprise Design Patters
* Selector layer for Security_Offered_CPF__c objects
*
* @author  Haritha P
* @since   12/10/2020
*/
public class ApplicationSecurityCPFSelector extends fflib_SObjectSelector {

/**
* @description Method to retrieve the sObjectType
*
* @return  Schema.SObjectType  The sObjectType
*/
    public Schema.SObjectType getSObjectType() {
        return Application_Security_CPF__c.sObjectType;
    }

    /**
* @description Method to retrieve the list of fields on the sObject
*
* @return  List<Schema.SObjectField>   The list of sObjectFields
*/
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField>{
            Application_Security_CPF__c.Id,
            Application_Security_CPF__c.Application_Product_CPF__c
                };
       }

       /**
     * @description Method to retrieve Application_Product_CPF__c records based on an Appliaction Id
     *
     * @param   ApplicationPrdctId           The Application Product Id
     * @param Category
     * @return  List<Application_Security_CPF__c>    Application_Product_CPF__c record
     */
    public  List<Application_Security_CPF__c> selectByAppPrdctId(Id ApplicationPrdctId,string Category) {
        return Database.query(
            newQueryFactory().
            selectField('Id').
            selectField('Name').
            selectField('Category__c').
            selectField('Guarantor_name__c').
            selectField('Guarantor_registration_number__c').
            selectField('Session_of_claims_and_loans_accounts__c').
            selectField('CPA_document_version__c').
            selectField('Amount__c').
            selectField('Application_Product_CPF__c').
            selectField('Address_line_1__c').
            selectField('Address_line_2__c').
            selectField('To_be_released__c').
            selectField('When_to_release_months__c').
            selectField('Release_condition__c').
            selectField('Guarantor_email_address_for_notices__c').
            selectField('Suburb__c').
            selectField('City__c').
            selectField('Country__c').
            selectField('Postal_Code__c').
            selectField('Cross_collateralisation__c').
            selectField('Security_provided_by__c').
            selectField('Facilities__c').
            selectField('Specific_facility_detail__c').
            selectField('Include_address__c').
            selectField('Type__c').
            selectField('Lease_and_rentals_of_property__c').
            selectField('Proceeds_in_respect_of_sale_or_transfer__c').
            selectField('Revenues_in_respect_of_property__c').
            selectField('Claims_in_respect_of_insurance__c').
            selectField('Book_debts_and_other_debt_claims__c').
            selectField('VAT_reimbursement_and_payments__c').
            selectField('Investments_and_or_other_deposits__c').
            selectField('Cedent_name__c').
            selectField('Cedent_registration_number__c').
            selectField('Pledge_and_cession_of__c').
            selectField('Date_registered__c').
            selectField('Entity_name__c').
            selectField('Entity_registration_Identification_num__c').
            selectField('Loan_accounts_by__c').
            selectField('Details__c').
            selectField('Lease_and_rentals_Property__c').
            selectField('Proceeds_in_respect_sale_or_transfer__c').
            selectField('Revenues_in_respect_property__c').
            selectField('Claims_in_respect_insurance__c').
            selectField('Book_debts_and_other_debt_claim__c').
            selectField('VAT_reimbursement_and_payment__c').
            selectField('Investments_and_or_other_deposit__c').
            selectField('Mortgage_bond_type__c').
            selectField('Property_ranking__c').
            selectField('Property_description__c').
            selectField('Mortgage_bond_amount__c').
            selectField('Including_cession_of_claims_and_loan_acc__c').
            selectField('Who_will_be_responsible_pay__c').
            selectField('Suretyship_name__c').
            selectField('Suretyship_email_address_for_notices__c').
            selectField('Suretyship_registration_number__c').
            selectField('Cross_guarantee__c').
            selectField('Subordination_Agreement_of_Loan_Accounts__c').
            setCondition('Application_Product_CPF__c  =:ApplicationPrdctId AND Category__c =: Category' ).
            toSOQL()
        );
    }

    /**
     * @description Method to retrieve Application_Product_CPF__c records based on an Appliaction Id
     *
     * @param   ApplicationPrdctId           The Application Product Id
     * @param Category
     * @param securityclass
     * @return  List<Application_Security_CPF__c>    Application_Product_CPF__c record
     */
    public  List<Application_Security_CPF__c> selectByAppPrdctIdandClass(Id ApplicationPrdctId,string Category,string securityclass) {
        return Database.query(
            newQueryFactory().
            selectField('Id').
            selectField('Name').
            selectField('Category__c').
            selectField('Guarantor_name__c').
            selectField('Guarantor_registration_number__c').
            selectField('Session_of_claims_and_loans_accounts__c').
            selectField('CPA_document_version__c').
            selectField('Amount__c').
            selectField('Application_Product_CPF__c').
            selectField('Address_line_1__c').
            selectField('Address_line_2__c').
            selectField('To_be_released__c').
            selectField('When_to_release_months__c').
            selectField('Release_condition__c').
            selectField('Guarantor_email_address_for_notices__c').
            selectField('Suburb__c').
            selectField('City__c').
            selectField('Country__c').
            selectField('Postal_Code__c').
            selectField('Cross_collateralisation__c').
            selectField('Security_provided_by__c').
            selectField('Facilities__c').
            selectField('Specific_facility_detail__c').
            selectField('Include_address__c').
            selectField('Type__c').
            selectField('Lease_and_rentals_of_property__c').
            selectField('Proceeds_in_respect_of_sale_or_transfer__c').
            selectField('Revenues_in_respect_of_property__c').
            selectField('Claims_in_respect_of_insurance__c').
            selectField('Book_debts_and_other_debt_claims__c').
            selectField('VAT_reimbursement_and_payments__c').
            selectField('Investments_and_or_other_deposits__c').
            selectField('Cedent_name__c').
            selectField('Cedent_registration_number__c').
            selectField('Pledge_and_cession_of__c').
            selectField('Date_registered__c').
            selectField('Entity_name__c').
            selectField('Entity_registration_Identification_num__c').
            selectField('Loan_accounts_by__c').
            selectField('Details__c').
            selectField('Security_Class__c').
            selectField('Including_cession_of_claims_and_loan_acc__c').
            selectField('Lease_and_rentals_Property__c').
            selectField('Proceeds_in_respect_sale_or_transfer__c').
            selectField('Revenues_in_respect_property__c').
            selectField('Claims_in_respect_insurance__c').
            selectField('Book_debts_and_other_debt_claim__c').
            selectField('VAT_reimbursement_and_payment__c').
            selectField('Investments_and_or_other_deposit__c').
            selectField('Suretyship_name__c').
            selectField('Suretyship_email_address_for_notices__c').
            selectField('Suretyship_registration_number__c').
            selectField('Mortgage_bond_type__c').
            selectField('Property_description__c').
            selectField('Property_ranking__c').
            selectField('Mortgage_bond_amount__c').
            selectField('Undertaking_to_inject_cost_overrun_funds__c').
            selectField('Who_will_be_responsible_pay__c').
            selectField('Cross_guarantee__c').
            selectField('Third_party_name__c').
            selectField('Third_party_registration_ID_number__c').
            selectField('Additional_bond__c').
            selectField('Subordination_Agreement_of_Loan_Accounts__c').
            selectField('Claims_By__c').
            selectField('Cross_default_clause_party__c').
            setCondition('Application_Product_CPF__c  =:ApplicationPrdctId AND Category__c =: Category AND Security_Class__c =: securityclass').
            toSOQL()
        );
    }

/**
     * @description Method to retrieve Application_Product_CPF__c records based on an Appliaction Id
     *
     * @param   ApplicationPrdctId           The Application Product Id
     * @param Category
     * @param Type
     * @return  List<Application_Security_CPF__c>    Application_Product_CPF__c record
     */
    public  List<Application_Security_CPF__c> selectByAppPrdctwithtypecategory(Id ApplicationPrdctId,string Category,string Type) {
        return Database.query(
            newQueryFactory().
            selectField('Id').
            selectField('Name').
            selectField('Category__c').
            selectField('Guarantor_name__c').
            selectField('Guarantor_registration_number__c').
            selectField('Session_of_claims_and_loans_accounts__c').
            selectField('CPA_document_version__c').
            selectField('Amount__c').
            selectField('Application_Product_CPF__c').
            selectField('Address_line_1__c').
            selectField('Address_line_2__c').
            selectField('When_to_release_months__c').
            selectField('Release_condition__c').
            selectField('Guarantor_email_address_for_notices__c').
            selectField('Suburb__c').
            selectField('City__c').
            selectField('Country__c').
            selectField('Postal_Code__c').
            selectField('Cross_collateralisation__c').
            selectField('Security_provided_by__c').
            selectField('Facilities__c').
            selectField('Specific_facility_detail__c').
            selectField('Include_address__c').
            selectField('Type__c').
            selectField('Cross_guarantee__c').
            selectField('To_be_released__c').
            selectField('Including_cession_of_claims_and_loan_acc__c').
            selectField('Subordination_Agreement_of_Loan_Accounts__c').
            selectField('Undertaking_to_inject_cost_overrun_funds__c').
            selectField('Cross_default_clause__c').
            selectField('Claims_By__c').
            selectField('Who_will_be_responsible_pay__c').
            selectField('Lease_and_rentals_Property__c').
            selectField('Cedent_name__c').
            selectField('Cedent_registration_number__c').
            selectField('Proceeds_in_respect_of_sale_or_transfer__c').
            selectField('Revenues_in_respect_property__c').
            selectField('Claims_in_respect_of_insurance__c').
            selectField('Book_debts_and_other_debt_claims__c').
            selectField('VAT_reimbursement_and_payment__c').
            selectField('Investments_and_or_other_deposits__c').
            selectField('Details__c').
            selectField('Entity_name__c').
            selectField('Mortgage_bond_type__c').
            selectField('Lease_and_rentals_of_property__c').
            selectField('Revenues_in_respect_of_property__c').
            selectField('VAT_reimbursement_and_payments__c').
            selectField('Property_ranking__c').
            selectField('Property_description__c').
            selectField('Mortgage_bond_amount__c').
            selectField('Date_registered__c').
            selectField('Proceeds_in_respect_sale_or_transfer__c').
            selectField('Book_debts_and_other_debt_claim__c').
            selectField('Claims_in_respect_insurance__c').
            selectField('Investments_and_or_other_deposit__c').
            selectField('Suretyship_name__c').
            selectField('Suretyship_email_address_for_notices__c').
            selectField('Suretyship_registration_number__c').
            selectField('Cross_default_clause_party__c').
            setCondition('Application_Product_CPF__c  =:ApplicationPrdctId AND Category__c =: Category AND Type__c =: Type' ).
            toSOQL()
        );
    }

    /**
    * @description Method to retrieve Application_Product_CPF__c records based on an Appliaction Id
    *
    * @param   ApplicationPrdctId           The Application Product Id
    * @param Category
    * @param Type
    * @param securityclass
    * @return  List<Application_Security_CPF__c>    Application_Product_CPF__c record
    */
    public  List<Application_Security_CPF__c> selectByAppPrdctwithtypecategoryandClass(Id ApplicationPrdctId,string Category,string Type,string securityclass) {
        return Database.query(
            newQueryFactory().
            selectField('Id').
            selectField('Name').
            selectField('Category__c').
            selectField('Guarantor_name__c').
            selectField('Guarantor_registration_number__c').
            selectField('Session_of_claims_and_loans_accounts__c').
            selectField('CPA_document_version__c').
            selectField('Amount__c').
            selectField('Application_Product_CPF__c').
            selectField('Address_line_1__c').
            selectField('Address_line_2__c').
            selectField('When_to_release_months__c').
            selectField('Release_condition__c').
            selectField('Guarantor_email_address_for_notices__c').
            selectField('Suburb__c').
            selectField('City__c').
            selectField('Country__c').
            selectField('Postal_Code__c').
            selectField('Cross_collateralisation__c').
            selectField('Security_provided_by__c').
            selectField('Facilities__c').
            selectField('Specific_facility_detail__c').
            selectField('Include_address__c').
            selectField('Type__c').
            selectField('Cross_guarantee__c').
            selectField('To_be_released__c').
            selectField('Including_cession_of_claims_and_loan_acc__c').
            selectField('Subordination_Agreement_of_Loan_Accounts__c').
            selectField('Undertaking_to_inject_cost_overrun_funds__c').
            selectField('Cross_default_clause__c').
            selectField('Claims_By__c').
            selectField('Security_Class__c').
            selectField('Who_will_be_responsible_pay__c').
            selectField('Lease_and_rentals_Property__c').
            selectField('Cedent_name__c').
            selectField('Cedent_registration_number__c').
            selectField('Proceeds_in_respect_of_sale_or_transfer__c').
            selectField('Revenues_in_respect_property__c').
            selectField('Claims_in_respect_of_insurance__c').
            selectField('Book_debts_and_other_debt_claims__c').
            selectField('VAT_reimbursement_and_payment__c').
            selectField('Investments_and_or_other_deposits__c').
            selectField('Details__c').
            selectField('Entity_name__c').
            selectField('Mortgage_bond_type__c').
            selectField('Lease_and_rentals_of_property__c').
            selectField('Revenues_in_respect_of_property__c').
            selectField('VAT_reimbursement_and_payments__c').
            selectField('Property_ranking__c').
            selectField('Property_description__c').
            selectField('Mortgage_bond_amount__c').
            selectField('Date_registered__c').
            selectField('Proceeds_in_respect_sale_or_transfer__c').
            selectField('Book_debts_and_other_debt_claim__c').
            selectField('Claims_in_respect_insurance__c').
            selectField('Investments_and_or_other_deposit__c').
            selectField('Suretyship_name__c').
            selectField('Suretyship_email_address_for_notices__c').
            selectField('Suretyship_registration_number__c').
            selectField('Cross_default_clause_party__c').
            setCondition('Application_Product_CPF__c  =:ApplicationPrdctId AND Category__c =: Category AND Type__c =: Type AND Security_Class__c =: securityclass').
            toSOQL()
        );
    }

    /**
    * @description Method to retrieve Application_Product_CPF__c records based on an Appliaction Id and Class
    *
    * @param   ApplicationPrdctId           The Application Product Id
    * @param securityclass
    * @return  List<Application_Security_CPF__c>    Application_Product_CPF__c record
    */
    public  List<Application_Security_CPF__c> selectByAppPrdctwithClass(Id ApplicationPrdctId, string securityclass) {
        return Database.query(
            newQueryFactory().
            selectField('Id').
            selectField('Name').
            selectField('Category__c').
            selectField('Guarantor_name__c').
            selectField('Guarantor_registration_number__c').
            selectField('Session_of_claims_and_loans_accounts__c').
            selectField('CPA_document_version__c').
            selectField('Amount__c').
            selectField('Application_Product_CPF__c').
            selectField('Address_line_1__c').
            selectField('Address_line_2__c').
            selectField('When_to_release_months__c').
            selectField('Release_condition__c').
            selectField('Guarantor_email_address_for_notices__c').
            selectField('Suburb__c').
            selectField('City__c').
            selectField('Country__c').
            selectField('Postal_Code__c').
            selectField('Cross_collateralisation__c').
            selectField('Security_provided_by__c').
            selectField('Facilities__c').
            selectField('Specific_facility_detail__c').
            selectField('Include_address__c').
            selectField('Type__c').
            selectField('Cross_guarantee__c').
            selectField('To_be_released__c').
            selectField('Including_cession_of_claims_and_loan_acc__c').
            selectField('Subordination_Agreement_of_Loan_Accounts__c').
            selectField('Undertaking_to_inject_cost_overrun_funds__c').
            selectField('Cross_default_clause__c').
            selectField('Claims_By__c').
            selectField('Security_Class__c').
            selectField('Who_will_be_responsible_pay__c').
            selectField('Lease_and_rentals_Property__c').
            selectField('Cedent_name__c').
            selectField('Cedent_registration_number__c').
            selectField('Proceeds_in_respect_of_sale_or_transfer__c').
            selectField('Revenues_in_respect_property__c').
            selectField('Claims_in_respect_of_insurance__c').
            selectField('Book_debts_and_other_debt_claims__c').
            selectField('VAT_reimbursement_and_payment__c').
            selectField('Investments_and_or_other_deposits__c').
            selectField('Details__c').
            selectField('Entity_name__c').
            selectField('Mortgage_bond_type__c').
            selectField('Lease_and_rentals_of_property__c').
            selectField('Revenues_in_respect_of_property__c').
            selectField('VAT_reimbursement_and_payments__c').
            selectField('Property_ranking__c').
            selectField('Property_description__c').
            selectField('Mortgage_bond_amount__c').
            selectField('Date_registered__c').
            selectField('Proceeds_in_respect_sale_or_transfer__c').
            selectField('Book_debts_and_other_debt_claim__c').
            selectField('Claims_in_respect_insurance__c').
            selectField('Investments_and_or_other_deposit__c').
            selectField('Suretyship_name__c').
            selectField('Suretyship_email_address_for_notices__c').
            selectField('Suretyship_registration_number__c').
            setCondition('Application_Product_CPF__c  =:ApplicationPrdctId AND Security_Class__c =: securityclass').
            toSOQL()
        );
    }

    /**
    * @description Method to retrieve Application_Product_CPF__c records based on an Appliaction Id
    *
    * @param   ApplicationPrdctId           The Application Product Id
    * @param Category
    * @param mortgageBondType
    * @param securityclass
    * @return  List<Application_Security_CPF__c>    Application_Product_CPF__c record
    */
    public  List<Application_Security_CPF__c> selectByAppPrdctMortgageBondType(Id ApplicationPrdctId,string Category,string mortgageBondType, string securityclass) {
        return Database.query(
            newQueryFactory().
            selectField('Id').
            selectField('Name').
            selectField('Category__c').
            selectField('Guarantor_name__c').
            selectField('Guarantor_registration_number__c').
            selectField('Session_of_claims_and_loans_accounts__c').
            selectField('CPA_document_version__c').
            selectField('Amount__c').
            selectField('Application_Product_CPF__c').
            selectField('Address_line_1__c').
            selectField('Address_line_2__c').
            selectField('When_to_release_months__c').
            selectField('Release_condition__c').
            selectField('Guarantor_email_address_for_notices__c').
            selectField('Suburb__c').
            selectField('City__c').
            selectField('Country__c').
            selectField('Postal_Code__c').
            selectField('Cross_collateralisation__c').
            selectField('Security_provided_by__c').
            selectField('Facilities__c').
            selectField('Specific_facility_detail__c').
            selectField('Include_address__c').
            selectField('Type__c').
            selectField('Cross_guarantee__c').
            selectField('To_be_released__c').
            selectField('Including_cession_of_claims_and_loan_acc__c').
            selectField('Subordination_Agreement_of_Loan_Accounts__c').
            selectField('Undertaking_to_inject_cost_overrun_funds__c').
            selectField('Cross_default_clause__c').
            selectField('Claims_By__c').
            selectField('Security_Class__c').
            selectField('Who_will_be_responsible_pay__c').
            selectField('Lease_and_rentals_Property__c').
            selectField('Cedent_name__c').
            selectField('Cedent_registration_number__c').
            selectField('Proceeds_in_respect_of_sale_or_transfer__c').
            selectField('Revenues_in_respect_property__c').
            selectField('Claims_in_respect_of_insurance__c').
            selectField('Book_debts_and_other_debt_claims__c').
            selectField('VAT_reimbursement_and_payment__c').
            selectField('Investments_and_or_other_deposits__c').
            selectField('Details__c').
            selectField('Entity_name__c').
            selectField('Mortgage_bond_type__c').
            selectField('Lease_and_rentals_of_property__c').
            selectField('Revenues_in_respect_of_property__c').
            selectField('VAT_reimbursement_and_payments__c').
            selectField('Property_ranking__c').
            selectField('Property_description__c').
            selectField('Mortgage_bond_amount__c').
            selectField('Date_registered__c').
            selectField('Proceeds_in_respect_sale_or_transfer__c').
            selectField('Book_debts_and_other_debt_claim__c').
            selectField('Claims_in_respect_insurance__c').
            selectField('Investments_and_or_other_deposit__c').
            selectField('Suretyship_name__c').
            selectField('Suretyship_email_address_for_notices__c').
            selectField('Suretyship_registration_number__c').
            selectField('Third_party_name__c').
            selectField('Third_party_registration_ID_number__c').
            selectField('Additional_bond__c').
            selectField('Cross_default_clause_party__c').
            setCondition('Application_Product_CPF__c  =:ApplicationPrdctId AND Category__c =: Category AND Mortgage_bond_type__c =: mortgageBondType AND Security_Class__c =: securityclass').
            toSOQL()
        );
    }
}