/**
 * @description :Selector Layer for Application_Exposure_Facility__c object
 *
 * @author  Englarmerdge Mongwe
 * @since   2020-08-27
 **/
public class NonScoredApprovedFacilitiesSelector extends fflib_SObjectSelector {
    /**
     * @description getSObjectType
     * @author englarmerdge.mongwe@absa.africa | 2021-06-12
     * @return Schema.SObjectType
    **/
    public Schema.SObjectType getSObjectType() {
        return Application_Exposure_Facility__c.sObjectType;
    }

    /**
     * @description getSObjectFieldSetList
     * @author englarmerdge.mongwe@absa.africa | 2021-06-12
     * @return List<Schema.FieldSet>
    **/
    public override List<Schema.FieldSet> getSObjectFieldSetList() {
        return new List<Schema.FieldSet>
        { SObjectType.Application_Exposure_Facility__c.FieldSets.Application_Finder_Compact_View };
    }

    /**
     * @description getSObjectFieldList
     * @author englarmerdge.mongwe@absa.africa | 2021-06-12
     * @return List<Schema.SObjectField>
    **/
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            Application_Exposure_Facility__c.Id,
            Application_Exposure_Facility__c.Application__c,
            Application_Exposure_Facility__c.Approved_Facility__c,
            Application_Exposure_Facility__c.Client_Name__c,
            Application_Exposure_Facility__c.Client_Code__c,
            Application_Exposure_Facility__c.Exposure_Non_Scored__c,
            Application_Exposure_Facility__c.Installments_Non_Scored__c,
            Application_Exposure_Facility__c.Installments_Total__c,
            Application_Exposure_Facility__c.LastModifiedDate
        };
    }

    /**
     * @description select by idset
     * @author englarmerdge.mongwe@absa.africa | 2021-06-12
     * @param idSet
     * @return List<Application_Exposure_Facility__c>
    **/
    public List<Application_Exposure_Facility__c> selectById(Set<ID> idSet) {
        return (List<Application_Exposure_Facility__c>) selectSObjectsById(idSet);
    }

    public override String getOrderBy() {
        return 'CreatedDate ASC';
    }

    /**
     * @description select by application id
     * @author englarmerdge.mongwe@absa.africa | 2021-06-12
     * @param appId
     * @return List<Application_Exposure_Facility__c>
    **/
    public List<Application_Exposure_Facility__c> selectByApplicationId(String appId) {
        return (List<Application_Exposure_Facility__c>) Database.query(
            newQueryFactory().
            setCondition('Application__c = :appId').
            toSOQL()
        );
    }

    /**
     * @description select by appId and clientName
     * @author englarmerdge.mongwe@absa.africa | 2021-06-12
     * @param appId
     * @param clientName
     * @return List<Application_Exposure_Facility__c>
    **/
    public List<Application_Exposure_Facility__c> selectByClientName(String appId, String clientName) {
        return (List<Application_Exposure_Facility__c>) Database.query(
            newQueryFactory().
            setCondition('Application__c = :appId AND Client_Name__c = :clientName').
            toSOQL()
        );
    }
}