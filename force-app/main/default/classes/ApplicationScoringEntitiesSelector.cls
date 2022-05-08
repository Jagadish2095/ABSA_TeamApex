/**
 * Selector class for Application_Scoring_Entity__c sObject
 *
 * @author Ephetehe Mokgopanyane (ephetehe.mokgopanyane@tetrad.co.za)
 * @date February 2021
 */
public class ApplicationScoringEntitiesSelector extends fflib_SObjectSelector{
	
    /**
     * Method to retrieve the sObjectType
     *
     * @return  Schema.SObjectType  The sObjectType
    */
    public Schema.SObjectType getSObjectType() {
        return Application_Scoring_Entity__c.sObjectType;
    }

    /**
     * Method to retrieve the list of fields on the sObject
     *
     * @return  List<Schema.SObjectField>   The list of sObjectFields
    */
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            Application_Scoring_Entity__c.Id,
            Application_Scoring_Entity__c.Application_Scoring__c,
            Application_Scoring_Entity__c.Entity_Name__c,
            Application_Scoring_Entity__c.Entity_Number__c,
            Application_Scoring_Entity__c.Financials_Required__c,
            Application_Scoring_Entity__c.Financials_Type_Required__c,
            Application_Scoring_Entity__c.INTENTCLIENTCODE1__c,
            Application_Scoring_Entity__c.WRSTREPORT__c
        };
    }

    public List<Application_Scoring_Entity__c> selectByApplicationScoringId(Set<Id> idSet){
        return Database.query(
        	newQueryFactory()
            .selectField('LastModifiedDate')
            .setCondition('Application_Scoring__c IN: idSet')
            .toSOQL()
        );
    }
    
    public List<Application_Scoring_Entity__c> selectByOppIdAndIdRegPassportNumber(Set<Id> idSet, Set<String> stageSet, Set<String> idRegPassSet){
        return Database.query(
        	newQueryFactory()
            .setCondition('Application_Scoring__r.Application_Number__r.Opportunity__c IN: idSet AND Application_Scoring__r.Stage__c IN: stageSet AND Application_Scoring__c IN: idRegPassSet')
            .toSOQL()
        );
    }
    
    public List<Application_Scoring_Entity__c> selectByAppScoringIdStageIdEntityNum(Set<Id> idSet, Set<String> stageSet, Set<String> entNumSet){
        return Database.query(
        	newQueryFactory()
            .selectField('Financials_Required__c')
            .setCondition('Application_Scoring__r.Application_Number__r.Opportunity__c IN: idSet AND Application_Scoring__r.Stage__c IN: stageSet AND Entity_Number__c IN: entNumSet')
            .toSOQL()
        );
    }
}