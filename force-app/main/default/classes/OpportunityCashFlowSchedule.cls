/**
* Schedulable class for all new Opportunities
* @author Lulu Rankwe
* @date   28/10/2020
*/
global class OpportunityCashFlowSchedule implements Schedulable{
    
    global void execute(SchedulableContext sc){
        
        ApplicationProductCashflowBatch applicationProductBatchClass = new ApplicationProductCashflowBatch(); 
        Database.executebatch(applicationProductBatchClass);
        
    
    }

}