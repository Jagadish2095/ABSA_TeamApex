/**
* Schedulable class for checking if user if absent or otherwise
* @author  Koketso Mpshane
* @date    16/06/2020
*/
global class UserRecordAbsenceSchedule implements Schedulable {
    
    global void execute(SchedulableContext sc) {
        UserRecordAbsenceBatch userBatch = new UserRecordAbsenceBatch(); 
        Database.executebatch(userBatch);
    }
    
}