/**
* Class for the lightning component CaseFlagAction.
* This class flags unwanted cases and push them to the 
* unwanted queue
*
* @author  Rudolf Niehaus - CloudSmiths
* @since   2018-07-31
*/
public class CaseFlagActionExt {
    
     /*
    * Close and flag a Email / Case as a unwanted type
    * 
    * @param caseId String The case id
    * @param theAction String The unwanted type
    */
    
    @AuraEnabled
    public static void flagCase(String caseId, String theAction){
        
        try{
        
            Case c = [Select Id, Status, Unwanted_Type__c From Case Where Id = :caseId];
            
            c.Unwanted_Type__c = theAction;
            update c;
            
        }catch(DMLException ex){
            System.debug('There was an error while flagging a Case as Unwanted -> CaseFlagActionExt -> flagCase');
            System.debug(ex.getMessage());
        }
    }

}