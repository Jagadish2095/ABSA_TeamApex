/**
* Test class for UserRecordAbsenceBatch
* @author  Koketso Mpshane
* @date    16/06/2020
*/
@isTest
public class UserRecordAbsenceBatchTest {
    
    /*
     * Purpose : Method to create test data
     */
    @testSetup
    static void dataCreation(){
        
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        
        system.runAs(thisUser){
                        
            UserRole r = new UserRole(DeveloperName = 'Test_Role1', Name = 'Test Role1');
            insert r;
            
            User u = new User(
                ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
                LastName = 'last',
                Email = 'puser000@cs.com',
                Username = 'puser000@cs.com' + System.currentTimeMillis(),
                CompanyName = 'TEST',
                Title = 'title',
                Alias = 'alias',
                TimeZoneSidKey = 'America/Los_Angeles',
                EmailEncodingKey = 'UTF-8',
                LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US',
                UserRoleId = r.Id,
                Is_Absent__c = true
            );
            
            insert u;
            
            Record_Absence__c rAbsence = new Record_Absence__c();
            rAbsence.Start_Date__c = system.today();
            rAbsence.End_Date__c = system.today().addDays(5);
            rAbsence.Absence_Reason__c = 'Leave';
            rAbsence.User__c = thisUser.Id;
            rAbsence.Approved__c = true;
            insert rAbsence;
        }
        
        
    }
    
    //Method to test
    static testMethod void testUserRecordAbsenceBatch(){
        Test.startTest();
        UserRecordAbsenceSchedule instance = new UserRecordAbsenceSchedule();
		String cronExp = '0 0 23 * * ?'; 
        system.schedule('Test UserRecordAbsenceSchedule', cronExp, instance); 
        
        String emailBody = 'Test email';
        UserRecordAbsenceBatch.sendEmailWithErrors(emailBody);
        
        Test.stopTest();
    }

}