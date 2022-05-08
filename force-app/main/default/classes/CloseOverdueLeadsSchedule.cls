/**
* Schedulable class for closing expired leads 
* @author  Koketso Mpshane
* @date    09/03/2020
*/
global class CloseOverdueLeadsSchedule implements Schedulable{
    
    global void execute(SchedulableContext sc) {
        CloseOverdueLeadsBatch leadsBatchClass = new CloseOverdueLeadsBatch(); 
        Database.executebatch(leadsBatchClass);
    }
    
}