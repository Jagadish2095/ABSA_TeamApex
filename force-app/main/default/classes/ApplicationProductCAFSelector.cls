/**
* @description Method to retrieve the sObjectType
* @param 
* @author  Haritha P
* @since   11/30/2020
*/
public class ApplicationProductCAFSelector extends fflib_SObjectSelector {
    
    /**
* @description Method to retrieve the sObjectType
* @param 
* @return Schema.SObjectType  The sObjectType
*/
    
    public Schema.SObjectType getSObjectType() {
        return Application_Product_CAF__c.sObjectType;
    }
    
    /**
* @description Method to retrieve the list of fields on the sObject
* @param 
* @return  List<Schema.SObjectField>   The list of sObjectFields
*/
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField>{
            Application_Product_CAF__c.Id,
                Application_Product_CAF__c.Name,
                Application_Product_CAF__c.Do_you_have_short_term_insurance__c,
                Application_Product_CAF__c.Case__c,
                Application_Product_CAF__c.Asset_Type__c,
                Application_Product_CAF__c.Article_Type__c,
                Application_Product_CAF__c.Year_First_Registered__c,
                Application_Product_CAF__c.Mileage__c,
                Application_Product_CAF__c.Registration_Number__c,
                Application_Product_CAF__c.VIN_Chassis_Number__c,
                Application_Product_CAF__c.Serial_Number__c,
                Application_Product_CAF__c.Company_turnover__c,
                Application_Product_CAF__c.Vehicle_Make_Model__c,
                Application_Product_CAF__c.Engine_Number__c,
                Application_Product_CAF__c.Insurance_Policy_Number__c,
                Application_Product_CAF__c.Insurance_Company_Name__c,
                Application_Product_CAF__c.Contract_Type__c,
                Application_Product_CAF__c.Purchase_price_amount_excl_VAT__c,
                Application_Product_CAF__c.VAT_amount__c,
                Application_Product_CAF__c.VAT_Indicator__c,
                Application_Product_CAF__c.Commercial_document_fee__c,
                Application_Product_CAF__c.Service_fee_incl_VAT__c,
                Application_Product_CAF__c.Initiation_fee__c,
                Application_Product_CAF__c.Deposit_amount__c,
                Application_Product_CAF__c.Dealer_Trade_in_amount__c,
                Application_Product_CAF__c.Dealer_Cash_deposit_amount__c,
                Application_Product_CAF__c.Residual_Value__c,
                Application_Product_CAF__c.Payment_frequency__c,
                Application_Product_CAF__c.Term_in_months__c,
                Application_Product_CAF__c.Interest_rate__c,
                Application_Product_CAF__c.Fixed_or_linked__c,
                Application_Product_CAF__c.Commencement_Date__c,
                Application_Product_CAF__c.X1st_payment_date__c,
                Application_Product_CAF__c.Joint_venture_alliance_code__c,
                Application_Product_CAF__c.Statement_delivery_method__c,
                Application_Product_CAF__c.Pay_DIC_to_dealer__c,
                Application_Product_CAF__c.Landlord_Full_Name__c,
                Application_Product_CAF__c.Landlord_Address__c,
                Application_Product_CAF__c.Sales_person_full_name__c,
                Application_Product_CAF__c.Contact_number__c,
                Application_Product_CAF__c.Email_address__c,
                Application_Product_CAF__c.VAT_Pay_Back__c,
                Application_Product_CAF__c.Skip_payments__c,
                Application_Product_CAF__c.Skip_months__c,
                Application_Product_CAF__c.Skip_months_from__c,
                Application_Product_CAF__c.Skip_months_to__c,
                Application_Product_CAF__c.Debit_order__c,
                Application_Product_CAF__c.Bank_name__c,
                Application_Product_CAF__c.Account_holder__c,
                Application_Product_CAF__c.Account_number__c,
                Application_Product_CAF__c.Account_type__c,
                Application_Product_CAF__c.Branch_clearing_code__c,
                Application_Product_CAF__c.Credit_Line__c,
                Application_Product_CAF__c.Is_sanctioning_required__c,
                Application_Product_CAF__c.Type_of_request__c,
                Application_Product_CAF__c.CAF_sitecode__c,
                Application_Product_CAF__c.Absa_site_code__c,
                Application_Product_CAF__c.Package_name__c,
                Application_Product_CAF__c.Segment__c,
                Application_Product_CAF__c.Sales_branch__c,
                Application_Product_CAF__c.Campaign_name__c,
                Application_Product_CAF__c.Approved_Dealer__c,
                Application_Product_CAF__c.Mandate_holder__c,
                Application_Product_CAF__c.Marketer_BDO_User__c,
                Application_Product_CAF__c.Marketer_BDO__c,
                Application_Product_CAF__c.Select_cheque_account__c,
                Application_Product_CAF__c.Profit_margin__c,
                Application_Product_CAF__c.Debt_levels__c,
                Application_Product_CAF__c.Number_of_company_shareholders__c,
                Application_Product_CAF__c.Article_secure__c,
                Application_Product_CAF__c.Indicator_Insolvent__c,
                Application_Product_CAF__c.Indicator_ITC_Consent__c,
                Application_Product_CAF__c.Is_this_an_enterprise_customer__c,
                Application_Product_CAF__c.Existing_Absa_finance_to_be_settled__c,
                Application_Product_CAF__c.Customer_TFL__c,
                Application_Product_CAF__c.Business_status__c,
                Application_Product_CAF__c.Age_of_article_less_than_10_years_at_the__c,
                Application_Product_CAF__c.Total_potential_exposure_less_than_1_5__c,
                Application_Product_CAF__c.Application_amount_less_than_15_of_turn__c    
                };
                    }
    
    /**
* Method that gets a List of Application_Product_CAF__c from set of Application_Product_CAF__c Ids
* @description Method to retrieve the list of fields on the sObject
* @param idSet
* @return List of Application_Product_CAF__c records
*/
    public List<Application_Product_CAF__c> selectById(Set<Id> idSet) {
        return (List<Application_Product_CAF__c>) selectSObjectsById(idSet);
    }
    
    /**
* Method that gets a single Application_Product_CAF__c from Application_Product_CAF__c Id
* @description Method to retrieve the list of fields on the sObject
* @param applicationId
* @return Application_Product_CAF__c - single Application_Product_CAF__c with ID
*/
    public Application_Product_CAF__c selectByAppProdCAFId(Id applicationId) {
        return Database.query(
            newQueryFactory()
            .selectField('Id')
            .selectField('Do_you_have_short_term_insurance__c')
            .selectField('Case__c')
            .selectField('Asset_Type__c')
            .selectField('Bank_name__c')
            .selectField('Article_Type__c')
            .selectField('Year_First_Registered__c')
            .selectField('Select_cheque_account__c')
            .selectField('Profit_margin__c')
            .selectField('Debt_levels__c')
            .selectField('Number_of_company_shareholders__c')
            .selectField('Indicator_Insolvent__c')
            .selectField('Indicator_ITC_Consent__c')
            .selectField('Existing_Absa_finance_to_be_settled__c')
            .selectField('Customer_TFL__c')
            .selectField('Business_status__c')
            .selectField('Insurance_Policy_Number__c')
            .selectField('Insurance_Company_Name__c')
            .selectField('VAT_Indicator__c')
            .selectField('Landlord_Full_Name__c')
            .selectField('Landlord_Address__c')
            .selectField('Sales_person_full_name__c')
            .selectField('Contact_number__c')
            .selectField('Email_address__c')
            .selectField('Skip_months__c')
            .selectField('Skip_months_from__c')
            .selectField('Skip_months_to__c')
            .selectField('Account_holder__c')
            .selectField('Account_number__c')
            .selectField('Account_type__c')
            .selectField('Branch_clearing_code__c')
            .selectField('CAF_sitecode__c')
            .selectField('Package_name__c')
            .selectField('Segment__c')
            .selectField('Campaign_name__c')
            .selectField('Approved_Dealer__c')
            .selectField('Marketer_BDO_User__c')
            .selectField('Mileage__c')
            .selectField('Registration_Number__c')
            .selectField('VIN_Chassis_Number__c')
            .selectField('Serial_Number__c')
            .selectField('Description__c')
            .selectField('Contract_Type__c')
            .selectField('Purchase_price_amount_excl_VAT__c')
            .selectField('VAT_amount__c')
            .selectField('Commercial_document_fee__c')
            .selectField('Service_fee_incl_VAT__c')
            .selectField('Initiation_fee__c')
            .selectField('Deposit_amount__c')
            .selectField('Dealer_Trade_in_amount__c')
            .selectField('Dealer_Cash_deposit_amount__c')
            .selectField('Residual_Value__c')
            .selectField('Payment_frequency__c')
            .selectField('Term_in_months__c') //JQUEV 20200710
            .selectField('Interest_rate__c')
            .selectField('Fixed_or_linked__c')
            .selectField('Commencement_Date__c')
            .selectField('X1st_payment_date__c')
            .selectField('Joint_venture_alliance_code__c')
            .selectField('Pay_DIC_to_dealer__c')
            .selectField('Statement_delivery_method__c')
            .selectField('Landlord_Waiver__c')
            .selectField('VAT_Pay_Back__c')
            .selectField('Skip_payments__c')
            .selectField('Debit_order__c')
            .selectField('Is_sanctioning_required__c')
            .selectField('Credit_Line__c')
            .selectField('Type_of_request__c')
            .selectField('CAF_site_code__c')
            .selectField('Region__c')
            .selectField('Absa_site_code__c')
            .selectField('Sanctioner_work_queue_regions__c')
            .selectField('Sales_branch__c')
            .selectField('Mandate_holder__c')
            .selectField('Marketer_BDO__c')
            .selectField('Additional_comments__c')
            .selectField('Vehicle_Make_Model__c')
            .selectField('Article_secure__c')
            .selectField('Is_this_an_enterprise_customer__c')
            .selectField('principals_clear_bureau__c')
            .selectField('Business_clear_bureau_data__c')
            .selectField('customer_business_favourable__c')
            .selectField('principals_favourable__c')
            .selectField('Loan_value_less_than_110__c')
            .selectField('Age_of_article_less_than_10_years_at_the__c')
            .selectField('Total_potential_exposure_less_than_1_5__c')
            .selectField('Application_amount_less_than_15_of_turn__c')
            .selectField('Financed_amount__c')
            .selectField('Vehicle_Make_Model__c')
            .selectField('Company_turnover__c')
            .selectField('Case__r.Status')
            .selectField('Case__r.OwnerId')
            .selectField('Client_Details__c')
            .selectField('Name')
            .selectField('Dealer_Trading_name_or_code__c')
            .selectField('Dealer_Code__c')
            .selectField('Business_Originator_Reference_Number__c')
            .selectField('Vehicle_Make_Model_Id__c')
            .selectField('Commercial_asset_finance__c')
            .selectField('Contract_Email__c')
            .selectField('Another_Contract_Email__c')
            .selectField('Marketer_BDO_Employee_Number__c')
            .selectField('Marketer_BDO_Email_address__c')
            .selectField('Agree_Term_and_Condition__c')
            .selectField('Site_code_CAF__c')
            .selectField('Account_NCA_Status__c')
            .setCondition('Id =: applicationId')
            .toSOQL()
        );
    }
    
    /**
* Method that gets a List of Application_Product_CAF__c from set of OpportunityLineItem Ids
* @description Method to retrieve the list of fields on the sObject
* @param oppLineItemIdSet
* @return List of Application_Product_CAF__c records
*/
    
    public List<Application_Product_CAF__c> selectByOpportunityLineItemId(Set<Id> oppLineItemIdSet) {
        return Database.query(
            newQueryFactory()
            .selectField('Id')
            .selectField('Name')
            .selectField('Do_you_have_short_term_insurance__c')
            .selectField('Case__c')
            .selectField('Asset_Type__c')
            .selectField('Article_Type__c')
            .selectField('Year_First_Registered__c')
            .selectField('Mileage__c')
            .selectField('Registration_Number__c')
            .selectField('VIN_Chassis_Number__c')
            .selectField('Vehicle_Make_Model__c')
            .selectField('Company_turnover__c')
            .setCondition('Id =: oppLineItemIdSet')
            .toSOQL()
        );
    }
    
    /**
* Method that gets a List of Application_Product_CAF__c from set of OpportunityLineItem Ids
* @description Method to retrieve the list of fields on the sObject
* @param caseId
* @return List of Application_Product_CAF__c records
*/
    
    public Application_Product_CAF__c selectByCaseId(String caseId) {
        return Database.query(
            newQueryFactory()
            .selectField('Id')
            .selectField('Name')
            .selectField('Case__c')
            .setCondition('Case__c =: caseId')
            .toSOQL()
        );
    }
    
}