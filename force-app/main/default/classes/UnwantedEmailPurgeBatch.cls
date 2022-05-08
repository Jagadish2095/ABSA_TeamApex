/**
* Batch
*
* @author  Rudolf Niehaus - CloudSmiths
* @since   2018-08-07
*/
global class UnwantedEmailPurgeBatch implements Database.Batchable<Unwanted_Email__c> {
    
    global Iterable<Unwanted_Email__c> start(Database.BatchableContext BC) {
        
        List<Org_Wide_Lookup_Value__mdt> mdt = new OrgWideLookupValuesSelector().selectByLabel('Unwanted Email Purge Interval');
        
        DateTime purgeDate = System.now();
        
        if(!mdt.isEmpty()){
             purgeDate = purgeDate.addHours( Integer.valueOf(mdt[0].value__c) * (-1));
        }else{
             purgeDate = purgeDate.addHours(-72);//default to 3 days
        }
        
        List<Unwanted_Email__c> ue = new UnwantedEmailsSelector().selectByPurgeDate(purgeDate);
        
        return ue;
    }
 
    global void execute(Database.BatchableContext BC, List<Unwanted_Email__c> scope){
        try{
            delete scope;
        }catch(DMLException ex){
            System.debug('There was an error purging unwated email records -> UnwantedEmailPurgeBatch -> execute -> delete scope');
            System.debug(ex.getMessage());
        }
         
    }
    
    global void finish(Database.BatchableContext BC){
    }

}