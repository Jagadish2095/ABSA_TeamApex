/*
Controller Test Class For BranchCreditCardReferralController class
*
* @author  Clifford Willers : ABSA (IQ Business)
* @version v1.0
* @since   2021-04-09
*
*/
@isTest
public class BranchCreditCardReferralControllerTest {
    @TestSetup
    static void makeData(){
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
    }

    @isTest
    public static void callApplicationInformationTest()
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
            Test.startTest();
            Id acc = createTestAccount();
            Id app = createTestApplication(acc);
            String applicationInformation = BranchCreditCardReferralController.callApplicationInformation(app);
            System.assert(applicationInformation != null, 'ApplyPreScreen has a response');
            Test.stopTest();
        }
    }

    private static Id createTestAccount() {
        Account acc = new Account();
        acc.FirstName = 'Test';
        acc.LastName = 'Account';
        acc.PersonEmail = 'test@account.com';
        acc.PersonMobilePhone = '0123456789';
        acc.ID_Number__pc = '9308305015082';
        acc.Titles__pc = 'Mr';
        acc.PersonBirthdate = Date.newInstance(1993, 08, 30);
        insert acc;
        return acc.Id;
    }

    private static Id createTestApplication(Id accountId) {
        Application__c app = new Application__c();
        app.Account__c = accountId;
        insert app;
        return app.Id;
    }
}