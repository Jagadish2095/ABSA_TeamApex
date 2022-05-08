/*
* Helper class for CVS ServiceCalls
* @author  Clifford Willers
* @created 2021-02-18
*/
@isTest
public class BranchAccountControllerTest {
    @testSetup
    static void dataCreation(){
        String auniqueUserName = 'UserAdmin' + DateTime.now().getTime() + '@testorg.com';
        String aemail = 'UserAdmin@testorg.com';
        Profile ap = [SELECT Id FROM Profile WHERE Name = 'Standard User (Branch)'];
        User au = new User(
            Alias = 'standt',
            Email = aemail,
            EmailEncodingKey = 'UTF-8',
            LastName = 'UserAdmin',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = ap.Id,
            TimeZoneSidKey = 'Africa/Johannesburg',
            UserName = auniqueUserName,
            MobilePhone = '0823389021',
            Advisor_Code__c = '112233'
        );
        insert au;

        System.runAs(au) {
            Account account = new Account();
            account.ID_Number__pc = '9308305015082';
            account.FirstName = 'BranchProductControllerTest';
            account.LastName = 'Tester';
            insert account;

            Application__c application = new Application__c(First_Name__c = 'TestApplication');
            insert application;
        }
    }

    @isTest
    public static void getAccountRecordId()
    {
        User au = new User();
        Set<String> userEmails = new Set<String>();
        userEmails.add('UserAdmin@testorg.com');
        List<User> userList = new UsersSelector().selectByEmail(userEmails);
        if (userList.size() > 0) {
            for (User u : userList) {
                if (u.Email == 'UserAdmin@testorg.com') {
                    au = u;
                }
            }
        }

        System.runAs(au) {
            Application__c application = [SELECT Id FROM Application__c where First_Name__c = 'TestApplication' LIMIT 1];
            String accountPurpose = 'Salary';
            Test.startTest();
            String output = BranchAccountController.getAccountRecordId(application.Id, accountPurpose);
            System.assert(output != null, 'Test Working');
            Test.stopTest();
        }
    }

    @isTest
    public static void getApplicationFinancialAccountRecordId(){
        User au = new User();
        Set<String> userEmails = new Set<String>();
        userEmails.add('UserAdmin@testorg.com');
        List<User> userList = new UsersSelector().selectByEmail(userEmails);
        if (userList.size() > 0) {
            for (User u : userList) {
                if (u.Email == 'UserAdmin@testorg.com') {
                    au = u;
                }
            }
        }

        System.runAs(au) {
            Application__c application = [SELECT Id FROM Application__c where First_Name__c = 'TestApplication' LIMIT 1];
            String accountPurpose = 'Salary';

            Test.startTest();
            String errorText = BranchAccountController.getAccountRecordId(application.Id, accountPurpose);
            System.assert(errorText != null, 'Test Working');
            Test.stopTest();
        }
    }

    @isTest
    public static void getSalaryAccoutDetails(){
        User au = new User();
        Set<String> userEmails = new Set<String>();
        userEmails.add('UserAdmin@testorg.com');
        List<User> userList = new UsersSelector().selectByEmail(userEmails);
        if (userList.size() > 0) {
            for (User u : userList) {
                if (u.Email == 'UserAdmin@testorg.com') {
                    au = u;
                }
            }
        }

        System.runAs(au) {
            Application__c application = [SELECT Id FROM Application__c where First_Name__c = 'TestApplication' LIMIT 1];

            Test.startTest();
            Map<String, String> errorText = BranchAccountController.getAccountDetail(application.Id, 'Salary');
            System.assert(errorText != null, 'Test Working');
            Test.stopTest();
        }
    }
}