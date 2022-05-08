/**
* Default Communication Rule trigger handler that extends the TriggerHandler framework
* The beforeUpdate method 
*       
*
* @author  Rudolf Niehaus : CloudSmiths
* @since   2019-06-24
*
**/
public with sharing class CommunicationRuleTriggerHandler extends TriggerHandler{
    
    public virtual override void beforeUpdate(Map<Id, sObject> newRecords, Map<Id, sObject> oldRecords) {

        Map<Id, sd_Communication_Rule__c> newRules = (Map<Id, sd_Communication_Rule__c>) newRecords;
        Map<Id, sd_Communication_Rule__c> oldRules = (Map<Id, sd_Communication_Rule__c>) oldRecords;
        Map<Id, sd_Communication_Rule__c> changedRules = new Map<Id, sd_Communication_Rule__c>();

	    for (Id ruleId : newRules.keySet()) {

            sd_Communication_Rule__c newRule = newRules.get(ruleId); 
            sd_Communication_Rule__c oldRule = oldRules.get(ruleId);

            //check all the material fields for changes
            // we allow changes to these descriptive fiels and to activate/deactivate teh rule
            // Active__c, Rule_Order__c, Rule_Description__c

            Boolean isChanged = 
                newRule.sd_When_to_Trigger__c != oldRule.sd_When_to_Trigger__c || 
                newRule.sd_Units__c != oldRule.sd_Units__c || 
                newRule.sd_Trigger_Date_Field__c != oldRule.sd_Trigger_Date_Field__c || 
                newRule.sd_Trigger_Condition__c != oldRule.sd_Trigger_Condition__c || 
                newRule.sd_SMS_Template__c != oldRule.sd_SMS_Template__c || 
                newRule.sd_SMS_Template_AFR__c != oldRule.sd_SMS_Template_AFR__c || 
                newRule.sd_SMS_Field__c != oldRule.sd_SMS_Field__c || 
                newRule.sd_Quantity__c != oldRule.sd_Quantity__c || 
                newRule.sd_Object__c != oldRule.sd_Object__c || 
                newRule.sd_Email_Template__c != oldRule.sd_Email_Template__c || 
                newRule.sd_Email_Template_AFR__c != oldRule.sd_Email_Template_AFR__c || 
                newRule.sd_Email_Field__c != oldRule.sd_Email_Field__c || 
                newRule.sd_Business_Hours__c != oldRule.sd_Business_Hours__c || 
                newRule.sd_Before_After__c != oldRule.sd_Before_After__c || 
                newRule.sd_Action__c != oldRule.sd_Action__c; 
            
            if (isChanged) {
                changedRules.put(ruleId, newRule);						          
            }

        }	        

        addErrorIfTasksScheduled(changedRules, 'This rule conditions cannot be changed as there are existing scheduled tasks for this rule.');

    }

    public virtual override void beforeDelete(Map<Id, sObject> oldRecords) {

        addErrorIfTasksScheduled(oldRecords, 'This rule cannot be deleted as there are existing scheduled tasks for this rule.');

    }

    private void addErrorIfTasksScheduled (Map<Id, sObject> records, String errorMessage) {

        Map<String, Schema.RecordTypeInfo> taskRecordTypeMap = Task.sObjectType.getDescribe().getRecordTypeInfosByName();
        Set<Id> scheduledTasks = new Set<Id>();

        for(Task t :new TasksSelector().selectByRuleIdsRecordTypeAndStatus(records.keySet(),
                                                                            taskRecordTypeMap.get('Communication Plan Tasks').RecordTypeId,
                                                                            'Scheduled')){
            scheduledTasks.add(t.Communication_Rule_Id__c);                                                                          

        }
        
        for(Id recordId: records.keySet()) {
            if( scheduledTasks.contains(recordId) ){
                records.get(recordId).addError(errorMessage);
            }
        }
    }
}