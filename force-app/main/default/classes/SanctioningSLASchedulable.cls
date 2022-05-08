/**
* Schedulable class for scheduling the SLA Tracking Sanctioning 
* class.
*
* @author  Almas Aleem : absa
* @since   2020-07-20
*/

global class SanctioningSLASchedulable implements Schedulable{
     global void execute(SchedulableContext SC) {

        SanctioningSLATrackingBatch slaTrackers = new SanctioningSLATrackingBatch();
        Database.executeBatch( slaTrackers );
         
         //System.schedule('SanctioningSLATracking', '0 0 * * * ?', new SanctioningSLASchedulable() ); 
    }

}