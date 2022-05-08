/**
* Schedulable class for updating relavant fields related to case SLAs 
* @author  Koketso Mpshane
* @date    21/08/2020
*/
global class CaseSLAManagementSchedule implements Schedulable {
    
    global void execute(SchedulableContext sc) {
        CaseSLAManagementBatch slaBatchClass = new CaseSLAManagementBatch(); 
        Database.executebatch(slaBatchClass);
    }

}