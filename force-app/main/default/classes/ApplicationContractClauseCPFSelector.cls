/**
* @description Apex Enterprise Design Patters
* Selector layer for Application_Contract_Clause__c objects
*
* @author  *****
* @since   12/19/2020
*/
public class ApplicationContractClauseCPFSelector extends fflib_SObjectSelector {


/**
* @description 
* @author  | 2021-06-07 
* @return Schema.SObjectType 
**/
public Schema.SObjectType getSObjectType() {
    return Application_Contract_Clause__c.sObjectType;
}

/**
* @description 
* @author  | 2021-06-07 
* @return List<Schema.SObjectField> 
**/
public List<Schema.SObjectField> getSObjectFieldList() {
    return new List<Schema.SObjectField>{
        Application_Contract_Clause__c.Id,
            Application_Contract_Clause__c.Application_Product_CPF__c
            };
                }

/**
* @description 
* @author  | 2021-06-07 
* @param ApplicationPrdctId 
* @param Category 
* @param clausetype 
* @return List<Application_Contract_Clause__c> 
**/
public  List<Application_Contract_Clause__c> selectByAppPrdctId(Id ApplicationPrdctId,string Category,String clausetype) {
    return Database.query(
        newQueryFactory().
        selectField('Id').
        selectField('Name').
        selectField('Category__c').
        selectField('Description__c').
        selectField('Type__c').
        selectField('Application_Product_CPF__c').
        selectField('Covenants_applicable_to_the_Other_Entity__c').
        selectField('Date__c').
        selectField('Debit_Service_Cover_Ratio__c').
        selectField('Entity_Name__c').
        selectField('Measurement_period_number_years__c').
        selectField('Other_Entity_details__c').
        selectField('Other_transactional_covenants__c').
        selectField('Property_value_to_not_be_exceeded__c').
        selectField('Registration_number__c').
        selectField('Other_Pre_Lodgement_Conditions__c').
        selectField('Other_pre_disbursement_conditions__c').
        selectField('Measurement_period_number_interest__c').
        selectField('Interest_Service_Cover_Ratio__c').
        setCondition('Application_Product_CPF__c  =:ApplicationPrdctId AND Category__c =: Category AND Type__c =: clausetype' ).
        // setCondition('Category__c =: Category').
        toSOQL()
    );
}

/**
* @description 
* @author  | 2021-06-07 
* @param ApplicationPrdctId 
* @param Category 
* @param Type 
* @return List<Application_Contract_Clause__c> 
**/
public  List<Application_Contract_Clause__c> selectByAppPrdctwithtypecategory(Id ApplicationPrdctId,string Category,string Type) {
    return Database.query(
        newQueryFactory().
        selectField('Id').
        selectField('Name').
        selectField('Category__c').
        selectField('Application_Product_CPF__c').
        selectField('Category__c').
        selectField('Type__c').
        setCondition('Application_Product_CPF__c  =:ApplicationPrdctId AND Category__c =: Category AND Type__c =: Type' ).
        // setCondition('Category__c =: Category').
        toSOQL()
    );
}


/**
* @description 
* @author  | 2021-06-07 
* @param ApplicationPrdctId 
* @param Category 
* @return List<Application_Contract_Clause__c> 
**/
public  List<Application_Contract_Clause__c> selectByAppPrdctIdAndType(Id ApplicationPrdctId,string Category) {
    return Database.query(
        newQueryFactory().
        selectField('Id').
        selectField('Name').
        selectField('Category__c').
        selectField('Description__c').
        selectField('Type__c').
        selectField('Application_Product_CPF__c').
        selectField('Covenants_applicable_to_the_Other_Entity__c').
        selectField('Date__c').
        selectField('Debit_Service_Cover_Ratio__c').
        selectField('Entity_Name__c').
        selectField('Measurement_period_number_years__c').
        selectField('Other_Entity_details__c').
        selectField('Other_transactional_covenants__c').
        selectField('Property_value_to_not_be_exceeded__c').
        selectField('Registration_number__c').
        //selectField('Financial_covenants_applicable__c').
        setCondition('Application_Product_CPF__c  =:ApplicationPrdctId AND Category__c =: Category' ).
        // setCondition('Category__c =: Category').
        toSOQL()
    );
}
}