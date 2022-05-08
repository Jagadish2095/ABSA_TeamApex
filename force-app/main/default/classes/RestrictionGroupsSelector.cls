/**
* Apex Enterprise Design Patterns
* Selector Layer for Restriction Group object
*/
public class RestrictionGroupsSelector extends fflib_SObjectSelector {

    //MANDATORY ABSTRACT METHODS - START
   public Schema.SObjectType getSObjectType(){
      return RestrictionGroup__c.sObjectType;
   } 
    
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            RestrictionGroup__c.Case__c,
                RestrictionGroup__c.Description__c,
                RestrictionGroup__c.EffectiveEndDate__c,
                RestrictionGroup__c.EffectiveStartDate__c,
                RestrictionGroup__c.EntityType__c,
                RestrictionGroup__c.GroupID__c,
                RestrictionGroup__c.Name,
                RestrictionGroup__c.IsEffectiveEndDateInfinity__c,
                RestrictionGroup__c.Restriction_ID__c,
                RestrictionGroup__c.Status__c
                };
                    } 
   //MANDATORY ABSTRACT METHODS - END
   
    
    /**
    * Method that returns Restriction Groups by Case Id
    *
    * @param caseIds - Set<CaseID>
    * @return RestrictionGroups - List<RestrictionGroup__c>
    */
    
    public List<RestrictionGroup__c> selectByCaseId(Set<Id> idSet) {
        return Database.query(
            newQueryFactory().
            selectField('Id').
            selectField('Name').
            selectField('Case__c').
            selectField('Description__c').
            selectField('GroupID__c').
            selectField('Restriction_ID__c').
            selectField('Approval_Status__c').
            setCondition('Case__c IN :idSet').
            toSOQL()
        );
    }
}