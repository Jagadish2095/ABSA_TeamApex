/**
* Apex Enterprise Design Patterns
* Selector Layer for communication rules
*
* @author  Rudolf Niehaus - CloudSmiths
* @since   2018-02-27
*/
public class CommunicationRulesSelector extends fflib_SObjectSelector {

    //MANDATORY ABSTRACT METHODS - START
    public Schema.SObjectType getSObjectType() {
       return sd_Communication_Rule__c.sObjectType;
    }
    
    public List<Schema.SObjectField> getSObjectFieldList(){
        return new List<Schema.SObjectField> {
            sd_Communication_Rule__c.Id,
            sd_Communication_Rule__c.sd_Trigger_Condition__c,
            sd_Communication_Rule__c.sd_Trigger_Date_Field__c,
            sd_Communication_Rule__c.Name,
            sd_Communication_Rule__c.sd_Action__c,
            sd_Communication_Rule__c.sd_Before_After__c,
            sd_Communication_Rule__c.sd_Quantity__c,
            sd_Communication_Rule__c.sd_Units__c,
            sd_Communication_Rule__c.sd_Business_Hours__c,  
            sd_Communication_Rule__c.sd_When_to_Trigger__c,
            sd_Communication_Rule__c.sd_Rule_Description__c,
            sd_Communication_Rule__c.sd_Object__c,
            sd_Communication_Rule__c.sd_Email_Template__c,
            sd_Communication_Rule__c.sd_Email_Template_AFR__c,
            sd_Communication_Rule__c.sd_Email_Template_Id__c,
            sd_Communication_Rule__c.sd_Email_Template_Id_AFR__c,
            sd_Communication_Rule__c.sd_SMS_Template__c,
            sd_Communication_Rule__c.sd_SMS_Template_AFR__c,
            sd_Communication_Rule__c.sd_SMS_Template_Id__c,
            sd_Communication_Rule__c.sd_SMS_Template_Id_AFR__c,
            sd_Communication_Rule__c.sd_SMS_Field__c,
            sd_Communication_Rule__c.sd_Integration_Service__c,
            sd_Communication_Rule__c.sd_Email_Field__c
        };
    }
     //INHERIT FROM BASE CLASS - START
    public List<sd_Communication_Rule__c> selectById( Set<Id> idSet ) {
        return (List<sd_Communication_Rule__c>) selectSObjectsById(idSet);
    }
    //Override default sort order i.e. CreatedDate
    public override String getOrderBy(){
        return 'Name'; 
    }
    //INHERIT FROM BASE CLASS - STOP
    //CUSTOME METHODS
    /*
    * Return Communication Rules based on Communication Plan Parent Id's
    * 
    * @param idSet Set<String> Communication_Plan__c Id's
    * @param recordLimit String max records to return
    * @return List<Communication_Rule__c>
    */
   public List<sd_Communication_Rule__c> selectByParentId(Set<Id> idSet, Integer recordLimit) { 
       
       return (List<sd_Communication_Rule__c>) Database.query(
           
           	newQueryFactory().
            selectField('sd_Communication_Plan__c').   
            selectField('sd_Communication_Plan__r.Name').
           	setCondition('sd_Communication_Plan__c IN :idSet').
           	setLimit(recordLimit).
        	toSOQL()
       );
  }

  	/*
    * Return Communication Rules for a specific object type
    * 
    * @param idSet Set<String> Communication_Plan__c Id's
    * @param String objName
    * @return List<Communication_Rule__c>
    */
   public List<sd_Communication_Rule__c> selectByRuleIdAndObjectType(Set<Id> idSet, String objName) { 
       
       return (List<sd_Communication_Rule__c>) Database.query(
           
           	newQueryFactory().
            selectField('sd_Communication_Plan__c').   
            selectField('sd_Communication_Plan__r.Name').
           	setCondition('Id IN :idSet And sd_Object__c = :objName').
        	toSOQL()
       );
    } 

    /*
    * Return Communication Rules by rule Ids with Plan Name
    * 
    * @param idSet Set<String> Communication_Plan__c Id's
    * @return List<Communication_Rule__c>
    */
   public List<sd_Communication_Rule__c> selectByRuleIdWithPlanName(Set<Id> idSet) { 
       
       return (List<sd_Communication_Rule__c>) Database.query(
           
           	newQueryFactory().
            selectField('sd_Communication_Plan__c').   
            selectField('sd_Communication_Plan__r.Name').
           	setCondition('Id IN :idSet').
        	toSOQL()
       );
    } 
}