/**
* Apex Enterprise Design Patterns
* Selector Layer for custom Object Decision_History__c
*
* @author  Jaco de Lange
* @since   2021-01-07
*/
public class DecisionHistoriesSelector extends fflib_SObjectSelector {
    
    //MANDATORY ABSTRACT METHODS - START
    public Schema.SObjectType getSObjectType(){
        return Decision_History__c.sObjectType;
    }
    
    public List<Schema.SObjectField> getSObjectFieldList(){
        return new List<Schema.SObjectField> {
            Decision_History__c.Id,
                Decision_History__c.Comments__c,
                Decision_History__c.Details__c,
                Decision_History__c.Decision__c,
                Decision_History__c.Outcome__c,
                Decision_History__c.CreatedDate,
                Decision_History__c.Sanctioner__c,
                Decision_History__c.Decision_By__c,
                Decision_History__c.Process_Name__c
            };
    }
    
     //INHERIT FROM BASE CLASS - START
    //get records by id's 
    public List<Decision_History__c> selectById(Set<Id> idSet) {
        return (List<Decision_History__c>) selectSObjectsById(idSet);
    }    
    //INHERIT FROM BASE CLASS - END
    
      /*
    * Return The Case Type and Subtype classification info
    * 
    * @param idSet Set<Id>
    * @param recordLimit Integer max records to return
    * @return List<Case>
    */
  public List<Decision_History__c> selectByCaseProcessName(String caseId, String processName) {
        return Database.query(
      		newQueryFactory(true).
            selectField('Decision__c').
            selectField('Details__c').
            selectField('Comments__c').
            selectField('Case__c').
            selectField('Process_Name__c').
            selectField('Approver__c').
            selectField('Sanctioner__c').
            selectField('Approver_Submitter__c').
            selectField('createdDate').
            setCondition('Case__c =:caseId AND Process_Name__c =: processName').
            toSOQL()
   		);
   }
    
     /*
    * Return The Case Type and Subtype classification info
    * 
    * @param idSet Set<Id>
    * @param recordLimit Integer max records to return
    * @return List<Case>
    */
  public List<Decision_History__c> selectByCaseDecision(String caseId, String decision) {
        return Database.query(
      		newQueryFactory(true).
            selectField('Decision__c').
            selectField('Details__c').
            selectField('Comments__c').
            selectField('Case__c').
            selectField('Process_Name__c').
            selectField('Approver__c').
            selectField('Sanctioner__c').
            selectField('Approver_Submitter__c').
            selectField('createdDate').
            setCondition('Case__c =:caseId AND Decision__c =:decision').
            toSOQL()
   		);
   }
}