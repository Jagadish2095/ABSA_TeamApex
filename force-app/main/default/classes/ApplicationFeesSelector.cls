/**
*  @description Apex Enterprise Design Patters
* Selector layer for Application_Fees__c objects
*
* @author  Diksha Wasekar
* @since   04/14/2021
*/
public class ApplicationFeesSelector extends fflib_SObjectSelector {

/**
* @description Method to retrieve the sObjectType
*
* @return  Schema.SObjectType  The sObjectType
*/
public Schema.SObjectType getSObjectType() {
return Application_Fees__c.sObjectType;
}
/**
* @description Method to retrieve the list of fields on the sObject
*
* @return  List<Schema.SObjectField>   The list of sObjectFields
*/
public List<Schema.SObjectField> getSObjectFieldList() {
return new List<Schema.SObjectField>{
Application_Fees__c.Id,
    Application_Fees__c.Application_Product_CPF__c
    };
        }

    /**
    * @description Method to retrieve Application_Fees__c records based on an Appliaction Id and Type
    *
    * @param   ApplicationPrdctId 
    * @param   Type
    * @return  List<Application_Fees__c> record
    */
    public  List<Application_Fees__c> selectByAppFeeswithtype(Id ApplicationPrdctId,string Type) {
        return Database.query(
            newQueryFactory().
            selectField('Id').
            selectField('Name').
            selectField('Fees_description__c').
            selectField('Application_Product_CPF__c').
            selectField('Fees_value__c').
            selectField('Type__c').
            selectField('Include_other_fee_in_total_facility__c').
            setCondition('Application_Product_CPF__c  =:ApplicationPrdctId AND Type__c =: Type' ).
            toSOQL()
        );
    }
 /**
    * @description Method to retrieve Application_Fees__c records based on an Appliaction Id and Type
    *
    * @param   ApplicationPrdctId 
    * @param   Type
    * @param   multiplephaseapplicable
    * @return  List<Application_Fees__c> record
    */
    public  List<Application_Fees__c> selectByAppFeeswithtypeandmultiplephaseapplicable(Id ApplicationPrdctId,string Type,string multiplephaseapplicable ) {
        return Database.query(
            newQueryFactory().
            selectField('Id').
            selectField('Name').
            selectField('Fees_description__c').
            selectField('Application_Product_CPF__c').
            selectField('Fees_value__c').
            selectField('Type__c').
            selectField('Phase_Number__c').
            selectField('Include_other_fee_in_total_facility__c').
            selectField('Application_Product_CPF__r.Multiple_phases_applicable__c').
            setCondition('Application_Product_CPF__c  =:ApplicationPrdctId AND Type__c =: Type And Application_Product_CPF__r.Multiple_phases_applicable__c =: multiplephaseapplicable').
            toSOQL()
        );
    }
    /**
    * @description Method to retrieve Application_Fees__c records based on an Appliaction Id and Type
    *
    * @param   ApplicationPrdctId
    * @return  List<Application_Fees__c> record
    */
    public  List<Application_Fees__c> selectAllAppFees(Id ApplicationPrdctId) {
        List<Application_Fees__c> appFees = new List<Application_Fees__c>();
        String query = ' SELECT ';
        String fieldname = null;
        Map< String, Schema.SObjectField > fieldobjectmap = Schema.getGlobalDescribe().get('Application_Fees__c').getDescribe().Fields.getMap();
        List<Schema.SObjectField> fieldobjectvaluesmap = fieldobjectmap.values();

        for( Schema.SObjectField s : fieldobjectvaluesmap ){
            fieldname = s.getDescribe().getName();
            query += fieldname + ', ';
        }

        query = query.subStringBeforeLast(',');
        query += ' FROM Application_Fees__c WHERE Application_Product_CPF__c =  \'' + ApplicationPrdctId + '\'';

        appFees = (List<Application_Fees__c>)Database.query( query );
        return appFees;
    }
}