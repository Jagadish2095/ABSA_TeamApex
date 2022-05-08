/**
* Default LiveChatTrascript trigger handler that extends the TriggerHandler framework
*
* @author  Rudolf Niehaus : CloudSmiths
* @since   2018-10-13
*
*Modified by Muvhuso Nekhubvi: Absa
**/
public class LiveChatTranscriptTriggerHandler extends TriggerHandler {
    
	public virtual override void beforeUpdate(Map<Id, sObject> newRecords, Map<Id, sObject> oldRecords) {
    	LiveChatTranscriptTriggerFunctions.mailTranscript( newRecords, oldRecords );
        LiveChatTranscriptTriggerFunctions.createTask(newRecords , oldRecords);
        
    } 
}