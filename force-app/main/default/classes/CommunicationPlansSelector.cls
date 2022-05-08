/**
* @description Apex Enterprise Design Patterns
* Selector Layer for communication plans
*
* @author  Rudolf Niehaus - CloudSmiths
* @since   2018-02-27
*/

public without sharing class CommunicationPlansSelector extends fflib_SObjectSelector {
    
    /**
    * @description getSObjectType
    * @return sd_Communication_Plan__c.sObjectType
    */
    //MANDATORY ABSTRACT METHODS - START
    public Schema.SObjectType getSObjectType() {
        return sd_Communication_Plan__c.sObjectType;
    }

    /**
    * @description getSObjectFieldList
    * @return List<Schema.SObjectField>
    */
    public List<Schema.SObjectField> getSObjectFieldList(){
        return new List<Schema.SObjectField> {
            sd_Communication_Plan__c.Id,
            sd_Communication_Plan__c.Name
        };
    }

    /**
    * @description selectById
    * @param idSet
    * @return List<sd_Communication_Plan__c
    *
    */
     //INHERIT FROM BASE CLASS - START
    public List<sd_Communication_Plan__c> selectById( Set<Id> idSet ) {
        return (List<sd_Communication_Plan__c>) selectSObjectsById(idSet);
    }
    //Override default sort order i.e. CreatedDate
    public override String getOrderBy(){
        return 'Name';
    }
    //INHERIT FROM BASE CLASS - STOP
    //CUSTOME METHODS
    /** 
    * @description Return Communication_Plan__c by Id
    * WITH related Communication_Rule__c records
    * Custom selector USING the Base class queryFactory
    *  
    * @param planId Set
    * @return List<Communication_Rule__c>
    */
    public List<sd_Communication_Plan__c> selectByIdWithRules(Set<Id> planId) {
        
        fflib_QueryFactory query = newQueryFactory(false).
            setCondition('Id IN :planId');
            

        
        new CommunicationRulesSelector().addQueryFactorySubselect(query,'sd_Communication_Rules__r');
        
        return (List<sd_Communication_Plan__c>) Database.query( query.toSOQL() );
        
    }
    /** 
    * @description selectPlanByName
    * @param commPlanNames
    * @return List<sd_Communication_Plan__c> 
    */
   public List<sd_Communication_Plan__c> selectPlanByName(Set<String> commPlanNames) {
        fflib_QueryFactory query = newQueryFactory(false).
            setCondition('Name IN :commPlanNames');
        
        new CommunicationRulesSelector().addQueryFactorySubselect(query,'sd_Communication_Rules__r');
        
        return (List<sd_Communication_Plan__c>) Database.query( query.toSOQL() );
   } 
}