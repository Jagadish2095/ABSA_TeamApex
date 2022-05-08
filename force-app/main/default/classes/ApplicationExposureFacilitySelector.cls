/**
 * @description       : Selector class for Application_Exposure_Facility__c SObject
 * @author            : Ephetehe Mokgopanyane
 * @last modified on  : 2021-06-11
 * @last modified by  : Ephetehe Mokgopanyane
 * Modifications Log 
 * Ver   Date         Author                  Modification
 * 1.0   2021-06-11   Ephetehe Mokgopanyane   Initial Version
**/

public class ApplicationExposureFacilitySelector extends fflib_SObjectSelector {
    /**
    * @description : Method to get the sobject type
    * @author Ephetehe Mokgopanyane | 2021-06-11 
    * @return Schema.SObjectType 
    **/
    public Schema.SObjectType getSObjectType() {
        return Application_Exposure_Facility__c.sObjectType;
    }

    /**
    * @description : Method to get the sobject field list 
    * @author Ephetehe Mokgopanyane | 2021-06-11 
    * @return List<SObjectField> 
    **/
    public List<SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField>{
            Application_Exposure_Facility__c.Id,
            Application_Exposure_Facility__c.Application__c,
            Application_Exposure_Facility__c.Approved_Facility__c,
            Application_Exposure_Facility__c.Client_Code__c,
            Application_Exposure_Facility__c.Client_Name__c,
            Application_Exposure_Facility__c.Exposure_Non_Scored__c,
            Application_Exposure_Facility__c.Exposure_Scored__c,
            Application_Exposure_Facility__c.Exposure_Total__c,
            Application_Exposure_Facility__c.Installments_Non_Scored__c,
            Application_Exposure_Facility__c.Installments_Scored__c,
            Application_Exposure_Facility__c.Installments_Total__c,
            Application_Exposure_Facility__c.Name,
            Application_Exposure_Facility__c.LastModifiedDate
        };
    }

    /**
    * @description Method which order by created date
    * @author Ephetehe Mokgopanyane | 2021-06-11 
    * @return String 
    **/
    public override String getOrderBy(){
        return 'CreatedDate';
    }

    /**
    * @description : Method which selects by ID
    * @author Ephetehe Mokgopanyane | 2021-06-11 
    * @param idSet 
    * @return List<Application_Exposure_Facility__c> 
    **/
    public List<Application_Exposure_Facility__c> selectById(Set<Id> idSet) {
        return (List<Application_Exposure_Facility__c>) Database.query(
            newQueryFactory()
            .setCondition('Id IN:idSet')
            .toSOQL()
        );
    }

    /**
    * @description : Method which selects by application ID
    * @author Ephetehe Mokgopanyane | 2021-06-11 
    * @param idSet 
    * @return List<Application_Exposure_Facility__c> 
    **/
    public List<Application_Exposure_Facility__c> selectByApplicationId(Set<Id> idSet){
        return (List<Application_Exposure_Facility__c>) Database.query(
            newQueryFactory()
            .setCondition('Application__c IN:idSet')
            .toSOQL()
        );
    }

    /**
    * @description : Method which selects by opportunity ID
    * @author Ephetehe Mokgopanyane | 2021-06-11 
    * @param idSet 
    * @return List<Application_Exposure_Facility__c> 
    **/
    public List<Application_Exposure_Facility__c> selectByOpportunityId(Set<Id> idSet){
        return (List<Application_Exposure_Facility__c>) Database.query(
            newQueryFactory()
            .setCondition('Application__r.Opportunity__c IN:idSet')
            .toSOQL()
        );
    }

    
    /**
    * @description : Method which returns exposure facility using application Id and clientcode
    * @author Ephetehe Mokgopanyane | 2021-06-11 
    * @param applicationId 
    * @param clientCode 
    * @return List<Application_Exposure_Facility__c> 
    **/
    public List<Application_Exposure_Facility__c> exposureFacilities(Id applicationId,string clientCode) {
      return Database.query(
            newQueryFactory().
            setCondition('Client_Code__c =: clientCode AND Application__c =:applicationId').
            toSOQL()
        );
    }

    
    /**
    * @description : Method which gives exposure facilities using application ID
    * @author Ephetehe Mokgopanyane | 2021-06-11 
    * @param applicationId 
    * @return List<Application_Exposure_Facility__c> 
    **/
    public List<Application_Exposure_Facility__c> exposureFacilitiesUsingApplication(Id applicationId) {
      return Database.query(
            newQueryFactory().
            setCondition('Application__c =:applicationId').
            toSOQL()
        );
    }
}