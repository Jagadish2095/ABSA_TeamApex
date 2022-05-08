/**
* Knowledge trigger fuction class that contains all the logic for trigger execution
*
* @author  Rudolf Niehaus : CloudSmiths
* @since   2018-11-01
*
**/
public class KnowledgeTriggerFunctions {
    
     /*
    * When a knowledge article is updated, this method
    * keeps the custom Assigned_User in sync with the std AssignedToId
    * This is then used to notify the assignd user of the article was submitted
    * for approval. 
    * 
    * @param updatedRecords List<Knowledge__kav>
    */		    
     public static void syncAssignedToBeforeUpdate(List<Knowledge__kav> updatedRecords) {
     
          for(Knowledge__kav article :updatedRecords) {
              
              if( article.AssignedToId != article.Assigned_User__c ){
                  article.Assigned_User__c = article.AssignedToId;
              }
          }
     }
}