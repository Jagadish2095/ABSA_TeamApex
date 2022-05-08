/**  
 * @Purpose      : Test Class for UnwantedEmailPurgeSchedule
 * @Author       : Dreamwares 
 * @Created Date : 07/09/2018
 */
@isTest
public class UnwantedEmailPurgeScheduleTest {
    /*
     * Purpose : Method to create test data
     */
    @testSetup
    static void dataCreation(){
    	Unwanted_Email__c unwantedEmail = new Unwanted_Email__c(Email_Body__c = 'Hello', From_Address__c = 'test@t.com',
                                                                Sender_Name__c = 'John', Subject__c = 'Test',
                                                                To_Address__c = 'test@t1.com');
        insert unwantedEmail;
        Test.setCreatedDate(unwantedEmail.Id, Date.today().AddDays(-5));
    }
    
    //Method to test
    static testMethod void testUnwantedEmailPurgeSchedule(){
        Test.startTest();
        UnwantedEmailPurgeSchedule instance = new UnwantedEmailPurgeSchedule();
		String cronExp = '0 0 23 * * ?'; 
        System.schedule('Test UnwantedEmailPurgeSchdeule', cronExp, instance); 
        Test.stopTest();
    }
}