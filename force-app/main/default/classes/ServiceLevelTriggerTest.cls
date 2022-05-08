/**
* Test Class for ServiceLevelTrigger
*
**/
@IsTest
public class ServiceLevelTriggerTest {
    
    /*
* Purpose : Method to create test data
*/
    @testSetup
    static void dataCreation(){
        
        List<User> usrlist = new List<User>();
        
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        
        system.runAs(thisUser){
            
            UserRole rl = new UserRole(DeveloperName = 'Test_Role1', Name = 'Test Role1');
            insert rl;
            
            User usr1 = new User(ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id, FirstName = 'first1',
                                 LastName = 'last1', Email = 'test1@test.com', Username = 'test1@test.com' + System.currentTimeMillis(),
                                 CompanyName = 'TEST', Title = 'title', Alias = 'alias', TimeZoneSidKey = 'America/Los_Angeles',
                                 EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', UserRoleId = rl.Id);
            usrlist.add(usr1);
            
            User usr2 = new User(ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id, FirstName = 'first2',
                                 LastName = 'last2', Email = 'test2@test.com', Username = 'test2@test.com' + System.currentTimeMillis(),
                                 CompanyName = 'TEST', Title = 'title', Alias = 'alias', TimeZoneSidKey = 'America/Los_Angeles',
                                 EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', UserRoleId = rl.Id);
            usrlist.add(usr2);
            
            insert usrlist;
        }
        
        Map<String, Schema.RecordTypeInfo> caseRecordTypeMap = Case.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
        
        Account account = new Account(Name = 'Test Account');
        insert account;
        
        Contact contact = new Contact(LastName='Test contact', AccountId = account.Id);
        insert contact;
        
        User usr = [SELECT Id FROM User Where LastName= 'last1'];
        
        Service_Group__c sg = new Service_Group__c(Name = 'SG', Queue__c = 'Queue', Assign_Record_Type__c = 'Complaint', 
                                                   Internal_SLA_Notification_User__c = usr.Id, Active__c = true);
        insert sg;
        
        Service_Level__c sl = new Service_level__c(Name = 'SL', Default_Service_Level__c = true,
                                                   External_SLA_Notification_User__c = usr.Id);
        insert sl;
        
        Service_Type__c st = new Service_Type__c(Name = 'Type Subtype', Type__c = 'Type', Subtype__c = 'Subtype');
        insert st;
        
        Service_Group_Type__c sgt = new Service_Group_Type__c(Service_Group__c = sg.Id, Service_Level__c = sl.id, Service_Type__c = st.Id);
        insert sgt;
        
        
        Case caseRec = new Case(Communication_Method__c = 'Email', Status = 'New', Origin = 'Email',
                                Account = account, Email__c = 'test@test.com', Subject = 'test',
                                recordTypeId = caseRecordTypeMap.get('Complaint').getRecordTypeId(),
                                Description = 'test', Expectation_of_the_Customer__c = 'test',
                                Incident_Date__c = date.today(), sd_Service_Group_Id__c = sg.Id,
                                Internal_SLA_Notification_User__c = sg.Internal_SLA_Notification_User__c,
                                External_SLA_Notification_User__c = sl.External_SLA_Notification_User__c);
        insert caseRec;
        
    }
    
    //Method to test
    static testMethod void testServiceLevelTrigger() {
        
        Test.startTest();
        
        User usr = [SELECT Id FROM User Where LastName= 'last2'];
        
        Service_Level__c sl = [Select Id, External_SLA_Notification_User__c From Service_Level__c Where Name =:'SL'];
        sl.External_SLA_Notification_User__c = usr.Id;
        update sl;
        
        Test.stopTest();
    }
    
}