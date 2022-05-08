/**
* Schedulable class for scheduling the TaskOverdueEmailBatch
* class.
*
* @author  Diksha Wasekar
*  
*/

global class TaskOverdueEmailSchedulable implements Schedulable{
    
    global void execute(SchedulableContext SC) {

        TaskOverdueEmailBatch overdueemail = new TaskOverdueEmailBatch(); 
        database.executebatch(overdueemail); 
    }
}