/**
* @description Apex Enterprise Design Patters
* Selector layer for Application_Phase__c objects
*
* @author  Diksha Wasekar
* @since   04/14/2021
*/
public class ApplicationPhasesCPFSelector extends fflib_SObjectSelector {

/**
* @description Method to retrieve the sObjectType
*
* @return  Schema.SObjectType  The sObjectType
*/
public Schema.SObjectType getSObjectType() {
return Application_Phase_CPF__c.sObjectType;
}
/**
* @description Method to retrieve the list of fields on the sObject
*
* @return  List<Schema.SObjectField>   The list of sObjectFields
*/
public List<Schema.SObjectField> getSObjectFieldList() {
return new List<Schema.SObjectField>{
    Application_Phase_CPF__c.Id,
    Application_Phase_CPF__c.Application_Product_CPF__c
        };
            }

    /**
    * @description Method to retrieve Application_Phase_CPF__c records based on an Appliaction Id and Type
    * @param  ApplicationPrdctId
    * @param  Type
    * @return  List<Application_Phase_CPF__c> 
    */
    public  List<Application_Phase_CPF__c> selectByAppPhasewithtype(Id ApplicationPrdctId,string Type) {
        return Database.query(
            newQueryFactory().
            selectField('Id').
            selectField('Name').
            selectField('Application_Product_CPF__c').
            selectField('Type__c').
            selectField('Account_type__c').
            selectField('Admin_fee__c').
            selectField('Admin_fee_amount__c').
            selectField('All_in_risk_margin__c').
            selectField('Cancellation_fee_payable__c').
            selectField('Commitment_fee__c').
            selectField('Date_of_final_repayment__c').
            selectField('Development_period_months__c').
            selectField('Drawdown_Amount__c').
            selectField('Drawdown_inspection_fee__c').
            selectField('Drawdown_inspection_fee_cur__c').
            selectField('Early_prepayment_fee_year_1__c').
            selectField('Early_prepayment_fee_year_2__c').
            selectField('Early_prepayment_fee_year_3__c').
            selectField('Final_instalment_amount__c').
            selectField('Final_repayment_date__c').
            selectField('Fixed_rate_period__c').
            selectField('Free_flow_option__c').
            selectField('Include_admin_fee_in_total_facility__c').
            selectField('Include_admin_fee_in_total_facility2__c').
            selectField('Include_balance_on_existing_account__c').
            selectField('Include_VAT_on_charges__c').
            selectField('Interest_only_period__c').
            selectField('Interest_rate_basis__c').
            selectField('Interest_service_frequency__c').
            selectField('Margin__c').
            selectField('Net_margin__c').
            selectField('Number_of_periods_months__c').
            selectField('Other_amounts_included_in_total_facility__c').
            selectField('Other_fees_applicable__c').
            selectField('Payable__c').
            selectField('Phase_Number__c').
            selectField('Practical_Completion_Date__c').
            selectField('Prepayment_fee__c').
            selectField('Prime_rate_margin__c').
            selectField('Repayment_options_during_development__c').
            selectField('Restructure_fee__c').
            selectField('Retention_Amount__c').
            selectField('Valuation_fee__c').
            selectField('Valuation_fee_amount__c').
            selectField('Number_of_pre_sales__c').
            selectField('Aggregate_price__c').
            selectField('Capital_Repayments__c').
            selectField('Capitalised_Interest__c').
            setCondition('Application_Product_CPF__c  =:ApplicationPrdctId AND Type__c =: Type ' ).
            toSOQL()
        );
    }

    /**
    * @description Method to retrieve Application_Phase_CPF__c records based on an Appliaction Id and Type
    *
    * @param   ApplicationPrdctId
    * @return  List<Application_Phase_CPF__c> record
    */
    public  List<Application_Phase_CPF__c> selectAllAppPhaseFees(Id ApplicationPrdctId) {
        List<Application_Phase_CPF__c> appPhaseFees = new List<Application_Phase_CPF__c>();
        String query = ' SELECT ';
        String fieldname = null;
        Map< String, Schema.SObjectField > fieldobjectmap = Schema.getGlobalDescribe().get('Application_Phase_CPF__c').getDescribe().Fields.getMap();
        List<Schema.SObjectField> fieldobjectvaluesmap = fieldobjectmap.values();

        for( Schema.SObjectField s : fieldobjectvaluesmap ){
            fieldname = s.getDescribe().getName();
            query += fieldname + ', ';
        }

        query = query.subStringBeforeLast(',');
        query += ' FROM Application_Phase_CPF__c WHERE Application_Product_CPF__c =  \'' + ApplicationPrdctId + '\'';

        appPhaseFees = (List<Application_Phase_CPF__c>)Database.query( query );
        return appPhaseFees;
    }
}