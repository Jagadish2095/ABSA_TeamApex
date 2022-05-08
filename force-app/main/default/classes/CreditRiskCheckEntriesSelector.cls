/**
* Apex Enterprise Design Patterns
* Selector Layer for Credit_Risk_Check_Entry__c objects
*
* @author       Jason Quevauvilliers
* @since        2020-06-10
*/
public class CreditRiskCheckEntriesSelector extends fflib_SObjectSelector{

    //MANDATORY ABSTRACT METHODS - START
    public Schema.SObjectType getSObjectType() {
        return Credit_Risk_Check_Entry__c.sObjectType;
    }

    public List<Schema.SObjectField> getSObjectFieldList() {
        Map< String, Schema.SObjectField > fieldObjectMap = Schema.getGlobalDescribe().get('Credit_Risk_Check_Entry__c').getDescribe().Fields.getMap();
        return fieldObjectMap.values();
    }
    //MANDATORY ABSTRACT METHODS - END

    /**
     * Method that takes a set of Credit_Risk_Check__c ID's
     *
     * @return List<Credit_Risk_Check_Entry__c> - returns a list of Credit_Risk_Check_Entry__c
     */
    public List<Credit_Risk_Check_Entry__c> selectByCreditRiskCheckIdList(List<Id> idListP) {
        return Database.query(
                newQueryFactory().
                setCondition('Credit_Risk_Check__c =: idListP').
                toSOQL()
        );
    }
}