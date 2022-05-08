public class LeadAllocationRunBatchController {
    
    public LeadAllocationRunBatchController(ApexPages.StandardSetController stdSetController){

    }

    public PageReference redirect(){
        
        Id batchJobClassId = [Select Id From ApexClass Where Name = 'LeadAllocationBatch'].Id;
        
        //get the running jobs to prevent batch from being executed more than once
        List<AsyncApexJob> runningJobs = [Select Id, Status, ApexClassId From AsyncApexJob Where ApexClassId =:batchJobClassId And Status != 'Completed' And Status != 'Failed' And Status != 'Aborted'];
        
        system.debug(LoggingLevel.FINE, '**runningJobs:**'+runningJobs);
        system.debug(LoggingLevel.FINE, '**runningJobsSize:**'+runningJobs.size());
        
        if(runningJobs.isEmpty()){
            
            Integer batchScope = 200;
            
            List<Org_Wide_Lookup_Value__mdt> mdt = [Select Integer_Value__c From Org_Wide_Lookup_Value__mdt Where DeveloperName = 'Lead_Allocation_Batch_Scope'];
            
            if(mdt.size() > 0){
                batchScope = Integer.valueOf(mdt[0].Integer_Value__c);
            }
            
            Id batchJobId = Database.executeBatch(new LeadAllocationBatch(), batchScope);
        }
            
        return new ApexPages.Action('{!List}').invoke();
                				
	}

}