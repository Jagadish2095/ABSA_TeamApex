/**  
*  The batch process first sync / update records in the stanging object
*  with updated CIF and MDM information, then update OR create new accounts
*  and contacts or person accounts from the data in the staging object. 
* 
* @author  Rudolf Niehaus : CloudSmiths
* @since   2019-06-11
*
* @modify	Tracy de Bruin
*/
global class DataStagingProcessBatch implements Database.Batchable<Data_Staging__c> {
    Set<String> cifNoSet = new set<String>();
    global Iterable<Data_Staging__c> start(Database.BatchableContext BC) {
        List<Data_Staging__c> stagedData = new DataStagingSelector().selectNotByProcessStatus('Success', 1000);
        
        return stagedData;
        
    }
    
    global void execute(Database.BatchableContext BC, List<Data_Staging__c> scope){

        if(scope.size() > 0) {
            List<Data_Staging__c>  processedData = DataStagingProcessBatchHelper.processBatch( scope );
            
            try{
                update processedData;
            }
            catch(DMLException ex){
                System.debug(ex.getMessage());
                throw ex;
            }
        }
    }
    
    global void finish(Database.BatchableContext BC){
        /* AccountCreate_CIF_MDM.GIPResponse createdAccount;
        for(String eachCIF : cifNoSet) {
            System.debug('###eachCIF : ' + eachCIF);
            createdAccount = AccountCreate_CIF_MDM.createAccountFromCIF(eachCIF, '0', '009970');
        }    */ 
    }
}