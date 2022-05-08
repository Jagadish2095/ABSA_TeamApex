/**
* Batch class for purging Lead Allocation Staging records that have completed processing 
* @author  Koketso Mpshane
* @date    18/08/2020
*/
global class LeadAllocationStagingPurgeBatch implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        
        String stagingQuery = 'Select Id From Lead_Allocation_Staging__c';
                
        return Database.getQueryLocator(stagingQuery);
        
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        
        system.debug(LoggingLevel.FINE, '***stagingListSize:***'+scope.size());
        
        try{
            delete scope;
        }catch(DMLException ex){
            system.debug(LoggingLevel.FINE, '***LeadAllocationStagingPurgeBatch Error:***'+ex.getMessage());
        }
        
    }
    
    global void finish(Database.BatchableContext BC){
        system.debug('LeadAllocationStagingPurgeBatch finished processing!');
    }

}