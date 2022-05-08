/**
* Apex Enterprise Design Patterns
* Selector Layer for custom Object Case_Checklist__c
*
* @author  Jaco de Lange
* @since   2021-01-25
*/
public class CaseQAChecklistSelector extends fflib_SObjectSelector {

//MANDATORY ABSTRACT METHODS - START
public Schema.SObjectType getSObjectType(){
        return Case_Checklist__c.sObjectType;
}

public List<Schema.SObjectField> getSObjectFieldList(){
        return new List<Schema.SObjectField> {
            Case_Checklist__c.Id,
                Case_Checklist__c.Case_checklist_question__c,
                Case_Checklist__c.Validate__c,
                Case_Checklist__c.Case_Checklist_Template__c
            };
    }

//INHERIT FROM BASE CLASS - START
//get records by id's 
public List<Case_Checklist__c> selectById(Set<Id> idSet) {
       return (List<Case_Checklist__c>) selectSObjectsById(idSet);
}    
}