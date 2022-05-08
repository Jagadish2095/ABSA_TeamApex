/*
Controller Test Class For BranchPaymentPlanHelper class
*
* @author  Clifford Willers : ABSA (IQ Business)
* @version v1.0
* @since   2020-11-17
*
*/

@isTest
public class BranchPaymentPlanHelperTest {
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
            Application__c application = new Application__c(First_Name__c = 'TestApplication');
            insert application;

            Application__c applicationPP = new Application__c(First_Name__c = 'TestApplicationPaymentPlan');
            insert applicationPP;

            Payment_Plan__c paymentPlan = new Payment_Plan__c(
                Application__c=applicationPP.Id,
                Name=applicationPP.Id,
                Status__c='New',
                Method__c='Debit Order');
            insert paymentPlan;
        }
    }

    @isTest
    public static void getPaymentPlanRecordIdNewTest(){
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
            String errorText = BranchPaymentPlanHelper.getPaymentPlanRecordId(application.Id);
            System.assert(errorText != null, 'Test Working');
            Test.stopTest();
        }
    }

    @isTest
    public static void getPaymentPlanRecordIdTest(){
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
            Application__c application = [SELECT Id FROM Application__c where First_Name__c = 'TestApplicationPaymentPlan' LIMIT 1];
            Test.startTest();
            String errorText = BranchPaymentPlanHelper.getPaymentPlanRecordId(application.Id);
            System.assert(errorText != null, 'Test Working');
            Test.stopTest();
        }
    }
}