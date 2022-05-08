/**
* Apex Enterprise Design Patterns
* Selector Layer for Accepted_Card__c objects
*
* @author  Tracy de Bruin - CloudSmiths
* @since   2020-05-21
*/

public class AcceptedCardsSelector extends fflib_SObjectSelector {
    //MANDATORY ABSTRACT METHODS - START
    public Schema.SObjectType getSObjectType(){
        return Accepted_Card__c.sObjectType;
    }

    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            Accepted_Card__c.Id,
            Accepted_Card__c.Name,
            Accepted_Card__c.Available_for_Merchant_Class__c,
            Accepted_Card__c.Plan_Type__c,
            Accepted_Card__c.Pre_Selected_for_Merchant_Class__c,
            Accepted_Card__c.Price_Override__c,
            Accepted_Card__c.Transaction_Group__c,
            Accepted_Card__c.Type__c
        };
    }
    //MANDATORY ABSTRACT METHODS - END

    //INHERIT FROM BASE CLASS - START
    //get Accepted_Card__c by id's
    public List<Accepted_Card__c> selectById(Set<Id> idSet) {
        return (List<Accepted_Card__c>) selectSObjectsById(idSet);
    }
    //INHERIT FROM BASE CLASS - END

    // PJAIN: 20200525
    public List<Accepted_Card__c> selectByMerchantClass(String merchantClass, String type, String productFamily) {

        return Database.query(
            newQueryFactory().
            selectField('Id').
            setCondition('Type__c INCLUDES (:type) AND (Available_for_Merchant_Class__c INCLUDES (:merchantClass) OR Pre_Selected_for_Merchant_Class__c INCLUDES (:merchantClass)) AND Product_Family__c INCLUDES (:productFamily)').
            toSOQL()
        );
    }

    // PJAIN: 20200525
    public List<Accepted_Card__c> selectByName(Set<String> names, String type) {

        return Database.query(
            newQueryFactory().
            selectField('Id').
            selectField('Transaction_Group__r.Name').
            selectField('Type__c').
            setCondition('Type__c INCLUDES (:type) AND Name IN :names').
            toSOQL()
        );
    }

    // PJAIN: 20200525
    public List<Accepted_Card__c> selectByType(String type) {

        return Database.query(
            newQueryFactory().
            selectField('Id').
            selectField('Transaction_Group__r.Name').
            selectField('Type__c').
            setCondition('Type__c INCLUDES (:type)').
            toSOQL()
        );
    }
}