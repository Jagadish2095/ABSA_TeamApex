/**
* Switching Get Institutions Schedule Test
* @author André Pietersen
* @created 2021-04-26
*/
@isTest 
public class SwitchingDeleteInstitutionsScheduleTest {
    public static testmethod void test1(){
        Test.startTest();
  
        // This test runs a scheduled job at midnight Sept. 3rd. 2022
        String CRON_EXP = '0 0 0 3 9 ? 2022';
        // Schedule the test job
        String jobId = System.schedule('SwitchingDeleteInstitutionsScheduleTest', CRON_EXP, new SwitchingDeleteInstitutionsSchedule());
        // Get the information from the CronTrigger API object 
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId]; 
        // Verify the expressions are the same System.assertEquals(CRON_EXP, ct.CronExpression); 
        // Verify the job has not run 
        System.assertEquals(0, ct.TimesTriggered); 
        // Verify the next time the job will run 
        System.assertEquals('2022-09-03 00:00:00', String.valueOf(ct.NextFireTime));   
        Test.stopTest();   
    }

    public static testmethod void test2(){
        Switching_Institution__c institution = new Switching_Institution__c();
        institution.Name = 'Test';
        institution.Route__c = 'Test';
        insert institution;

        Test.startTest();
  
        // This test runs a scheduled job at midnight Sept. 3rd. 2023
        String CRON_EXP = '0 0 0 3 9 ? 2023';
        // Schedule the test job
        String jobId = System.schedule('SwitchingDeleteInstitutionsScheduleTest', CRON_EXP, new SwitchingDeleteInstitutionsSchedule());
        // Get the information from the CronTrigger API object 
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId]; 
        // Verify the expressions are the same System.assertEquals(CRON_EXP, ct.CronExpression); 
        // Verify the job has not run 
        System.assertEquals(0, ct.TimesTriggered); 
        // Verify the next time the job will run 
        System.assertEquals('2023-09-03 00:00:00', String.valueOf(ct.NextFireTime));   
        Test.stopTest();   
    }
}