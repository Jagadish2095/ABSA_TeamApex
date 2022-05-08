/**
* Test class for TOM Handler -TOMComplaint_IH_v1.cls
* @author  Anka Ganta : Absa
* @since   2019-08-15
*
**/
@isTest
public class TOMComplaint_IH_v1_Test {
    @testSetup
    static void createTestData(){
        User adm = new User();
        String uniqueUserName = 'UserAdmin' + DateTime.now().getTime() + '@testorg.com';
        String email = 'UserAdmin@testorg.com';
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator (Custom)'];
        adm = new User(Alias = 'standt', Email=email,EmailEncodingKey='UTF-8', LastName='UserAdmin', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='Africa/Johannesburg', UserName=uniqueUserName, MobilePhone='0823389021');
        Insert adm;
        System.runAs(adm){
            map<String, Schema.RecordTypeInfo> caseRecordTypeMap = Case.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
            DateTime dt=system.today();
            Service_Type__c serviceType = new Service_Type__c(Name = 'Test1', Case_Record_Type__c = 'ATM', Subtype__c = 'Sample', Type__c = 'T01');
            insert serviceType;
            BusinessHours businessHr = [SELECT Id FROM BusinessHours LIMIT 1];
            Service_Group__c serviceGr = new Service_Group__c(Name = 'Test1', Assign_Record_Type__c = 'Email', Response_Email_Address__c = 'evg@t.com', Queue__c = 'Email', Business_Hours__c = businessHr.Id, Internal_SLA_Time_Measure__c = 'Hour(s)', Internal_SLA_Units__c = '8');
            insert serviceGr;
            Service_Level__c serviceLevel = new Service_Level__c(Name = 'Test1', External_SLA_Time_Measure__c = 'Hour(s)', External_SLA_Units__c = '8', Default_Service_Level__c = true);
            insert serviceLevel;
            Service_Group_Type__c serviceGrType = new Service_Group_Type__c(Service_Type__c = serviceType.Id, Service_Group__c = serviceGr.Id, Service_Level__c = serviceLevel.Id);
            insert serviceGrType;
            Site__c site = new Site__c (Name = 'Test', Service_Group__c = serviceGr.Id);
            insert site;
            Contact con = new Contact(Title='ContactTest',Phone='87837743123456769',LastName='ContactTest');
            insert con;
            Account acc = new Account(LastName = 'Test',FirstName='TOM test account',source__c='CIF',CIF__c='765');
            insert acc;
            Case tomCase = new Case(AccountId=acc.Id,Communication_Method__c = 'Email', Status = 'New', Origin = 'Email', Risk_Management_Centre__c = 'Digital Fraud', Email__c = 'testTOm@test.com',
                            Subject = 'TOM Test', Description = 'TOM test', Expectation_of_the_Customer__c = 'test', Incident_Date__c = date.today(), Type__c = 'deposit', 
                            Claim_Amount__C = 150, Amount_Withdrawn__c = 130, Amount_Received__c = 100, SequenceNumber__c='12345', Receipt_Slip_Available__c=true,
                            NonAbsaATMText__c='yes', Account_Number__c ='12345', IncidentTime__c=Time.newInstance(dt.hour(),dt.minute(),dt.second(),dt.millisecond()),
                            recordTypeId = caseRecordTypeMap.get('ATM').getRecordTypeId());
            insert tomCase;
        }
    }

    @isTest static void getTOMStatusPositive(){
        User adm = new User();
        Set<String> userEmails = new Set<String>();
        userEmails.add('UserAdmin@testorg.com');
        List<User> userList = new UsersSelector().selectByEmail(userEmails);
        if (userList.size()>0) {
            for (User u : userList) {
                if (u.Email=='UserAdmin@testorg.com') {
                    adm=u;
                }
            }
        }
        System.runAs(adm){
            String newCaseId;
            List<Account> accList = new List<Account>();
            Set<Id> idSet = new Set<Id>();
            accList = [SELECT Id FROM Account WHERE FirstName ='TOM test account' AND CIF__c='765' LIMIT 1 ];
            if (!accList.isEmpty() && accList.size() >0) {
                idSet.add(accList.get(0).Id);
                List<Case> caseList = new List<Case>();
                caseList = new CasesSelector().selectByAccountId(idSet,1);
                if (!caseList.isEmpty() && caseList.size() >0) {
                    newCaseId = caseList.get(0).Id;
                }
            }
            Test.setMock(HttpCalloutMock.class, new TOMComplaintServiceMock_ApiRest(StringConstants.POSITIVE_STRING));
            IntegrationTestDataFactory.insertIntegrationSettingsJitterbit(StringConstants.Jitterbit2, new list<String> {StringConstants.TOM_STRING});
            Test.startTest();
                TOMComplaint_IH_v1.callToTOMComplaint(newCaseId);
                system.assertNotEquals(newCaseId,null);
            Test.StopTest();
        }
    }

    @isTest static void noRecordPassingToTom(){
        User adm = new User();
        Set<String> userEmails = new Set<String>();
        userEmails.add('UserAdmin@testorg.com');
        List<User> userList = new UsersSelector().selectByEmail(userEmails);
        if (userList.size()>0) {
            for (User u : userList) {
                if (u.Email=='UserAdmin@testorg.com') {
                    adm=u;
                }
            }
        }
        System.runAs(adm){
            String newCaseId;
            List<Account> accList = new List<Account>();
            Set<Id> idSet = new Set<Id>();
            accList = [SELECT Id FROM Account WHERE FirstName ='TOM test account' AND CIF__c='765' LIMIT 1 ];
            if (!accList.isEmpty() && accList.size() >0) {
                idSet.add(accList.get(0).Id);
                List<Case> caseList = new List<Case>();
                caseList = new CasesSelector().selectByAccountId(idSet,1);
                if (!caseList.isEmpty() && caseList.size() >0) {
                    newCaseId = caseList.get(0).Id;
                }
            }
            Test.setMock(HttpCalloutMock.class, new TOMComplaintServiceMock_ApiRest(StringConstants.POSITIVE_STRING));
            Test.startTest();
                TOMComplaint_IH_v1.callToTOMComplaint(null);
            Test.stopTest();
        }
    }

    @isTest static void noIntegrationSettings(){
        User adm = new User();
        Set<String> userEmails = new Set<String>();
        userEmails.add('UserAdmin@testorg.com');
        List<User> userList = new UsersSelector().selectByEmail(userEmails);
        if (userList.size()>0) {
            for (User u : userList) {
                if (u.Email=='UserAdmin@testorg.com') {
                    adm=u;
                }
            }
        }
        System.runAs(adm){
            String newCaseId;
            List<Account> accList = new List<Account>();
            Set<Id> idSet = new Set<Id>();
            accList = [SELECT Id FROM Account WHERE FirstName ='TOM test account' AND CIF__c='765' LIMIT 1 ];
            if (!accList.isEmpty() && accList.size() >0) {
                idSet.add(accList.get(0).Id);
                List<Case> caseList = new List<Case>();
                caseList = new CasesSelector().selectByAccountId(idSet,1);
                if (!caseList.isEmpty() && caseList.size() >0) {
                    newCaseId = caseList.get(0).Id;
                }
            }
            Test.setMock(HttpCalloutMock.class, new TOMComplaintServiceMock_ApiRest(StringConstants.POSITIVE_STRING));
            Test.startTest();
                TOMComplaint_IH_v1.callToTOMComplaint(newCaseId);
            Test.stopTest();
        }
    }

    @isTest static void getTOMStatusNegative(){
        User adm = new User();
        Set<String> userEmails = new Set<String>();
        userEmails.add('UserAdmin@testorg.com');
        List<User> userList = new UsersSelector().selectByEmail(userEmails);
        if (userList.size()>0) {
            for (User u : userList) {
                if (u.Email=='UserAdmin@testorg.com') {
                    adm=u;
                }
            }
        }
        System.runAs(adm){
            String newCaseId;
            List<Account> accList = new List<Account>();
            Set<Id> idSet = new Set<Id>();
            accList = [SELECT Id FROM Account WHERE FirstName ='TOM test account' AND CIF__c='765' LIMIT 1 ];
            if (!accList.isEmpty() && accList.size() >0) {
                idSet.add(accList.get(0).Id);
                List<Case> caseList = new List<Case>();
                caseList = new CasesSelector().selectByAccountId(idSet,1);
                if (!caseList.isEmpty() && caseList.size() >0) {
                    newCaseId = caseList.get(0).Id;
                }
            }
            Test.setMock(HttpCalloutMock.class, new TOMComplaintServiceMock_ApiRest(StringConstants.NEGATIVE_STRING));
            IntegrationTestDataFactory.insertIntegrationSettingsJitterbit('Jitterbit', new list<String> {StringConstants.TOM_STRING,'Jitterbit Auth Path'});
            Test.setMock(HttpCalloutMock.class, new TOMComplaintServiceMock_ApiRest(StringConstants.NEGATIVE_STRING));
            IntegrationTestDataFactory.insertIntegrationSettingsJitterbit(StringConstants.JITTERBIT_API_RB_STRING, new list<String> {StringConstants.TOM_STRING});
            Integration_API__c apiIntRec =Sys_Utilities_Integration.getIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, Sys_Utilities_General.getEnvironment(), StringConstants.TOM_STRING);
            system.debug('********apiIntRec**********'+apiIntRec);
            TOMComplaint_IH_v1.callToTOMComplaint(newCaseId);
        }
    }

    @isTest static void getTOMStatusNegative1(){
        User adm = new User();
        Set<String> userEmails = new Set<String>();
        userEmails.add('UserAdmin@testorg.com');
        List<User> userList = new UsersSelector().selectByEmail(userEmails);
        if (userList.size()>0) {
            for (User u : userList) {
                if (u.Email=='UserAdmin@testorg.com') {
                    adm=u;
                }
            }
        }
        System.runAs(adm){
            String newCaseId;
            List<Account> accList = new List<Account>();
            Set<Id> idSet = new Set<Id>();
            accList = [SELECT Id FROM Account WHERE FirstName ='TOM test account' AND CIF__c='765' LIMIT 1 ];
            if (!accList.isEmpty() && accList.size() >0) {
                idSet.add(accList.get(0).Id);
                List<Case> caseList = new List<Case>();
                caseList = new CasesSelector().selectByAccountId(idSet,1);
                if (!caseList.isEmpty() && caseList.size() >0) {
                    newCaseId = caseList.get(0).Id;
                }
            }
            Test.setMock(HttpCalloutMock.class, new TOMComplaintServiceMock_ApiRest(StringConstants.POSITIVE_STRING));
            IntegrationTestDataFactory.insertIntegrationSettingsJitterbit('Jitterbit', new list<String> {StringConstants.TOM_STRING,'Jitterbit Auth Path'});
            IntegrationTestDataFactory.insertIntegrationSettingsJitterbit(StringConstants.JITTERBIT_API_RB_STRING, new list<String> {StringConstants.TOM_STRING});
            Integration_API__c apiIntRec =Sys_Utilities_Integration.getIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, Sys_Utilities_General.getEnvironment(), StringConstants.TOM_STRING);
            system.debug('********apiIntRec**********'+apiIntRec);
            TOMComplaint_IH_v1.callToTOMComplaint(newCaseId);
        }
    }
}