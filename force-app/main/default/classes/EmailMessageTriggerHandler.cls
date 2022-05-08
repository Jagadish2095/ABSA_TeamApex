/**
* Default Email Message trigger handler that extends the TriggerHandler framework
*
* @author  Tracy de Bruin : CloudSmiths
* @since   2018-11-23
*
**/

public class EmailMessageTriggerHandler extends TriggerHandler {
    
   public virtual override void beforeInsert(List<sObject> newemailRecords) {
          //EmailMessageTriggerFunctions.CloseCase(Trigger.new);
        
   }

    /* Uncomment if needed
    public virtual override void beforeUpdate(Map<Id, sObject> newRecords, Map<Id, sObject> oldRecords) {
        
    }*/
    
    public virtual override void beforeDelete(Map<Id, sObject> oldRecords) {
       
        List<EmailMessage> oldEmailMessageValues = new List<EmailMessage>();
        
        for(Id oldRecordsId: oldRecords.keySet()) {
            EmailMessage oldEmailMessage = (EmailMessage)oldRecords.get(oldRecordsId); 
            oldEmailMessageValues.add(oldEmailMessage);
        }  
        
        EmailMessageTriggerFunctions.blockEmailDeleteOnCases(oldEmailMessageValues);
    }
    
    /* Uncomment if needed*/
    public virtual override void afterInsert(Map<Id, sObject> newRecords) {
        
        List<EmailMessage> newEmailMessageValues = new List<EmailMessage>();
        
        for(Id newRecordsId: newRecords.keySet()) {
            EmailMessage newEmailMessage = (EmailMessage)newRecords.get(newRecordsId); 
            newEmailMessageValues.add(newEmailMessage);
            
            EmailMessageTriggerFunctions.ReassignCase(newEmailMessageValues);
        }  
    }
    
    /* Uncomment if needed
    public virtual override void afterUpdate(Map<Id, sObject> newRecords, Map<Id, sObject> oldRecords) {
        
    }*/
    
    /* Uncomment if needed
    public virtual override void afterDelete(Map<Id, sObject> oldRecords) {
    
    }*/
    
    /* Uncomment if needed
    public virtual override void afterUndelete(Map<Id, sObject> oldRecords) {
    
    }*/
}