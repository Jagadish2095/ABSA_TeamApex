/**
 * @description       :
 * @author            : Sandeep Golla
 * @last modified on  : 2021-07-07
 * @last modified by  : Sandeep Golla
 * Modifications Log
 * Ver   Date         Author          Modification
 * 1.0   2021-07-07   Sandeep Golla   Initial Version
**/
public class DataPrivacyRBCaseSelector extends fflib_SObjectSelector {

    /**
    * @description
    * @author Sandeep Golla | 2021-07-07
    * @return Schema.SObjectType
    **/
    public Schema.SObjectType getSObjectType(){
        return Data_Privacy_RB_Case__mdt.sObjectType;
    }

    /**
    * @description
    * @author Sandeep Golla | 2021-07-07
    * @return List<Schema.SObjectField>
    **/
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            Data_Privacy_RB_Case__mdt.label,
                Data_Privacy_RB_Case__mdt.Queue_Name__c,
                Data_Privacy_RB_Case__mdt.RBB_Super_Region__c,
                Data_Privacy_RB_Case__mdt.SBU_Segment__c
                };
                    }

    /**
    * @description
    * @author Sandeep Golla | 2021-07-07
    * @param sbuSegment
    * @param rbbRegion
    * @return List<Data_Privacy_RB_Case__mdt>
    **/
    public List<Data_Privacy_RB_Case__mdt> getQueueBasedOnSBUSegmentAndRegion(string sbuSegment,string rbbRegion) {
        return (List<Data_Privacy_RB_Case__mdt>) Database.query(
            newQueryFactory().
            selectField('Id').
            selectField('Label').
            selectField('Queue_Name__c').
            selectField('RBB_Super_Region__c').
            selectField('SBU_Segment__c').
            setCondition('SBU_Segment__c = :sbuSegment AND RBB_Super_Region__c =: rbbRegion').
            toSOQL()
        );
    }
}