/* 
* This class used to test Shedule_SLABatchTest Scheduler Class
* Apex Class - Shedule_SLABatch
* @author   Vitthal j 
* @since    2021-06-02
*/

@isTest
public class Schedule_SLABatchTest {

    @isTest static void validateScheduler() 
    {
        Test.startTest(); 
        Schedule_SLABatch ab=new Schedule_SLABatch();
        String jobId = System.schedule('jobName', '0 0 * * * ?',ab);
        System.assert(jobId != null, 'job Id is null');
        Test.stopTest();
    }
    
}