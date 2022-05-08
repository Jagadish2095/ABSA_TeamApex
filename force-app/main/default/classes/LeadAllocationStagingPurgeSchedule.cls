/**
* Schedulable class for purging Lead Allocation Staging records that have completed processing 
* @author  Koketso Mpshane
* @date    18/08/2020
*/
global class LeadAllocationStagingPurgeSchedule implements Schedulable {
    
    global void execute(SchedulableContext sc) {
        LeadAllocationStagingPurgeBatch stagingBatchClass = new LeadAllocationStagingPurgeBatch(); 
        Database.executebatch(stagingBatchClass);
    }

}