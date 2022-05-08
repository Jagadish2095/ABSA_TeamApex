/*
Controller Test Class For PackageProductController class
*
* @author  Clifford Willers : ABSA (IQ Business)
* @version v1.0
* @since   2020-12-09
*
*/

@isTest
public class PackageProductControllerTest {

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
            Date birthDate = Date.newInstance(2000, 3, 9);
            Account account = new Account();
            account.ID_Number__pc = '9308305015082';
            account.FirstName = 'TestPackageProductController';
            account.LastName = 'Tester';
            account.PersonBirthdate = birthDate;
            account.Gender__pc = 'Male';
            account.Date_Issued__pc = Date.today();
            account.Next_of_Kin_Last_Name__pc = 'Testing';
            account.Next_of_Kin_First_Name_s__pc = 'Testing';
            insert account;
        }
    }

    private static Id createTestAccount() {
        Account acc = new Account();
        acc.FirstName = 'Test';
        acc.LastName = 'Account';
        acc.PersonEmail = 'test@account.com';
        acc.PersonMobilePhone = '0123456789';
        acc.ID_Number__pc = '0123456789012';
        acc.Titles__pc = 'Mr';
        insert acc;
        return acc.Id;
    }

    private static Id createTestApplication(Id accountId) {
        Application__c app = new Application__c();
        app.Account__c = accountId;
        insert app;
        return app.Id;
    }

    @isTest
    public static void callActionQuotationTest(){
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
            Account account = [SELECT Id FROM Account where FirstName = 'TestPackageProductController' LIMIT 1];
            Test.startTest();
            String errorText = PackageProductController.callActionQuotation(account.Id, 'newCreditLimit', 'wkFiid', 'wkAcctProd', 'wkAcctType');
            System.assert(errorText != null, 'Test Working');
            Test.stopTest();
        }
    }

    @isTest
    public static void callCompleteOneTest(){
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
            Test.startTest();
            Id acc = createTestAccount();
            Id app = createTestApplication(acc);
            String errorText = PackageProductController.callCompleteOne(app, '', '', '', '', '', '0', '', '');
            System.assert(errorText != null, 'Test Working');
            Test.stopTest();
        }
    }
}