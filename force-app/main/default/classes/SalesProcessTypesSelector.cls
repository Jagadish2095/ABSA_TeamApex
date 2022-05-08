/**
 * @description       : * Apex Enterprise Design Patterns
*  W-006349 : Selector Layer for Sales_Process_Type__c object
 * @author            : @Rudolf Niehaus
 * @last modified on  : 2021-06-11
 * @last modified by  : Saurabh
 * Modifications Log
 * Ver   Date         Author    Modification
 * 1.0   2021-06-11   Saurabh   Initial Version
**/

public with sharing class SalesProcessTypesSelector extends fflib_SObjectSelector{


    /**
    * @description : Mandatory Apex Method
    * @author Saurabh | 2021-06-11
    * @return Schema.SObjectType
    **/
    public Schema.SObjectType getSObjectType(){
        return Sales_Process_Type__c.sObjectType;
    }

    /**
    * @description : Mandatory Apex Method
    * @author Saurabh | 2021-06-11
    * @return List<Schema.SObjectField>
    **/
    public List<Schema.SObjectField> getSObjectFieldList() {

        return new List<Schema.SObjectField> {

                Sales_Process_Type__c.Id,
                Sales_Process_Type__c.Name,
                Sales_Process_Type__c.Opportunity_Record_Type__c,
                Sales_Process_Type__c.Sales_Process__c,
                Sales_Process_Type__c.Product_Family__c,
                Sales_Process_Type__c.Product_Selector_Mode__c,
                Sales_Process_Type__c.Customer_Onboarding_Mode__c,
                Sales_Process_Type__c.Restrict_to_Single_Selection__c

        };
    }
    //MANDATORY ABSTRACT METHODS - END

    //INHERIT FROM BASE CLASS - START
    /**
    * @description  : Get Sales_Process_Type__c by id's
    * @author Saurabh | 2021-06-11
    * @param idSet
    * @return List<Sales_Process_Type__c>
    **/
    public List<Sales_Process_Type__c> selectById(Set<Id> idSet) {
        return (List<Sales_Process_Type__c>) selectSObjectsById(idSet);
    }
    //INHERIT FROM BASE CLASS - END


    /**
    * @description  : selectByRequestName select by request name i.e. What do you want to do today
    * @author Rudolf | 2021-06-11
    * @param requestName
    * @return List<Sales_Process_Type__c>
    **/
    public List<Sales_Process_Type__c> selectByRequestName(String requestName) {

        return Database.query(
            newQueryFactory().
            setCondition('Name = :requestName').
            toSOQL()
        );
    }

}