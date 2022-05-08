/**
* Schedulable class for scheduling the DataStagingProcessBatch
* class.
*
* @author  Rudolf Niehaus - CloudSmiths
* @since   2019-06-11
*/
global class DataStagingProcessSchedulable implements Schedulable {

    global void execute(SchedulableContext SC) {

        DataStagingProcessBatch processStagingData = new DataStagingProcessBatch();
        Database.executeBatch( processStagingData, 90 );
    }
}