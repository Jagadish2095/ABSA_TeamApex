/**
* Schedulable class for scheduling and running the 
* UnwantedEmailPurgeBatch class
*
* @author  Rudolf Niehaus - CloudSmiths
* @since   2018-08-08
*/
global class UnwantedEmailPurgeSchedule implements Schedulable {
   global void execute(SchedulableContext sc) {
      UnwantedEmailPurgeBatch purgeBatchClass = new UnwantedEmailPurgeBatch(); 
      database.executebatch( purgeBatchClass );
   }
}