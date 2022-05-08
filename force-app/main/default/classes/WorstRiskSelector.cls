/**
 * @description       : Selector class for Worst_Risk_Indicator__mdt custom metadata
 * @author            : Himani Joshi
 * @last modified on  : 2021-07-07
 * @last modified by  : Himani Joshi
 * Modifications Log 
 * Ver   Date         Author         Modification
 * 1.0   2021-07-07   Himani Joshi   Initial Version
**/

public class WorstRiskSelector extends fflib_SObjectSelector
{
    /**
    * @description : Method to get the sobject type
    * @author Himani Joshi | 2021-07-07 
    * @return Schema.SObjectType 
    **/
    public Schema.SObjectType getSObjectType(){
        return Worst_Risk_Indicator__mdt.sObjectType;
    }

    /**
    * @description : Method to get the sobject field list
    * @author Himani Joshi | 2021-07-07 
    * @return List<Schema.SObjectField> 
    **/
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
                Worst_Risk_Indicator__mdt.label,
                Worst_Risk_Indicator__mdt.Early_warning_Listing__c,
                Worst_Risk_Indicator__mdt.Sequence_Number__c
                };
    }

    /**
    * @description : Method to get the sequence number
    * @author Himani Joshi | 2021-07-07 
    * @return List<Worst_Risk_Indicator__mdt> 
    **/
    public List<Worst_Risk_Indicator__mdt> getSequenceNumber() {
      return Database.query(
            newQueryFactory().selectField('Id').
            selectField('Id').
            selectField('Label').
            selectField('Early_warning_Listing__c').
            selectField('Sequence_Number__c').
            selectField('Worst_Risk_Hold_Code__c').
            selectField('Type__c').
            selectField('WorstColRiskType__c').
            toSOQL()
        ); 
    }
}