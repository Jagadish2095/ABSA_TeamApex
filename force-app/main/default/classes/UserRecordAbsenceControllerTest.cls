/**
* Test class for UserRecordAbsenceController
*
* @author  Koketso Mpshane
* @since   2020-06-15
*
**/
@isTest
public class UserRecordAbsenceControllerTest {
    
    @testSetup
    static void dataCreation(){
        
        //Create Parent Group
        Group grp = new Group();
        grp.name = 'TestGroup';
        grp.Type = 'Regular'; 
        Insert grp; 
        
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        
        system.runAs(thisUser){
            
            //Create Group Member
            GroupMember grpMem1 = new GroupMember();
            grpMem1.UserOrGroupId = UserInfo.getUserId();
            grpMem1.GroupId = grp.Id;
            Insert grpMem1;
            
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
                UserRoleId = r.Id
            );
            
            insert u;
        }
        
        BusinessHours businessHr = [SELECT Id FROM BusinessHours LIMIT 1];
        
        Service_Group__c serviceGr = new Service_Group__c();
        serviceGr.Name = 'TestGroup';
        serviceGr.Manager__c = UserInfo.getUserId();
        serviceGr.X2IC_Manager__c = UserInfo.getUserId();
        serviceGr.ITA_Manager__c = UserInfo.getUserId();
        serviceGr.Assign_Record_Type__c = 'Retail Sales Lead';
        serviceGr.Response_Email_Address__c = 'evg@t.com';
        serviceGr.Queue__c = 'Email';
        serviceGr.Business_Hours__c = businessHr.Id;
        serviceGr.Internal_SLA_Time_Measure__c = 'Hour(s)';
        serviceGr.Internal_SLA_Units__c = '8';
        serviceGr.Email_Template_Lead_Creation__c = null;
        serviceGr.Internal_SLA_Notification_User__c = null;
        insert serviceGr;
        
        Record_Absence__c existingAbsence = new Record_Absence__c();
        existingAbsence.Start_Date__c = system.today();
        existingAbsence.End_Date__c = system.today().addDays(5);
        existingAbsence.Absence_Reason__c = 'Leave';
        existingAbsence.User__c = UserInfo.getUserId();
        insert existingAbsence;
        
    }
    
    static testMethod void testUserRecordAbsence(){
        
        Record_Absence__c recordAbsence = new Record_Absence__c();
        recordAbsence.Start_Date__c = system.today();
        recordAbsence.End_Date__c = system.today().addDays(1);
        recordAbsence.Absence_Reason__c = 'Leave';
        recordAbsence.User__c = UserInfo.getUserId();
        
        Test.startTest();   
        
        UserRecordAbsenceController.getLoggedInUserAbsentDates(); 
        UserRecordAbsenceController.createRecordAbsence(recordAbsence); 
        
        Test.stopTest();
    }
    
}