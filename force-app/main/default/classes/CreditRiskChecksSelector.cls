/**
* Selector Layer for Credit_Risk_Check__c objects
*
* @author  Jason Quevauvilliers
* @since   2020-06-10
*/
public class CreditRiskChecksSelector extends fflib_SObjectSelector{

    //MANDATORY ABSTRACT METHODS - START
    public Schema.SObjectType getSObjectType() {
        return Credit_Risk_Check__c.sObjectType;
    }

    public List<Schema.SObjectField> getSObjectFieldList() {
        Map< String, Schema.SObjectField > fieldObjectMap = Schema.getGlobalDescribe().get('Credit_Risk_Check__c').getDescribe().Fields.getMap();
        return fieldObjectMap.values();
    }
    //MANDATORY ABSTRACT METHODS - END

    /**
    * Method that takes an Account Id and Service Type
    *
    * @return List Credit_Risk_Check__c
    */
    public List<Credit_Risk_Check__c> selectByAccountIdAndServiceType(Id accountIdP, String serviceTypeP) {
        return Database.query(
                newQueryFactory().
                setCondition('AccountId__c =: accountIdP AND Service_Type__c =: serviceTypeP').
                toSOQL()
        );
    }
}