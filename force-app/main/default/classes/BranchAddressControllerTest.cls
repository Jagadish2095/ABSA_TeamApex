/*
Controller Test Class For BranchAddressController class
*
* @author  Clifford Willers : ABSA (IQ Business)
* @version v1.0
* @since   2020-12-04
*
*/
@isTest
public class BranchAddressControllerTest {
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
            Map <String, Schema.RecordTypeInfo> accountRecordTypeMap = Account.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
            Account individualAccount = new Account();
            individualAccount.RecordTypeId = accountRecordTypeMap.get('Individual_Client').getRecordTypeId();
            individualAccount.Client_Type__c = null;
            individualAccount.PersonTitle = 'Mr.';
            individualAccount.Initials__pc = 'T';
            individualAccount.FirstName = 'Tony';
            individualAccount.LastName = 'Stark';
            individualAccount.Gender__pc = 'Male';
            individualAccount.PersonBirthdate = Date.valueOf('1981-07-11');
            individualAccount.ID_Number__pc = '8107115017084';
            individualAccount.ID_Type__pc = 'SA Identity Document';
            individualAccount.PersonEmail = 'test@test.co.za';
            individualAccount.Alternative_Email__c = 'test@test.com';
            individualAccount.Phone = '0114453322';
            individualAccount.PersonMobilePhone = '0747003747';
            individualAccount.Non_Credit_Marketing_Consent__pc = 'Yes';
            individualAccount.Credit_Marketing_Consent__pc = 'Yes';
            individualAccount.Non_Credit_Marketing_Indicator__pc = 'Email;SMS';
            individualAccount.Credit_Marketing_Indicator__pc = 'Email;SMS';
            insert individualAccount;
            Address__c employersAddress = new Address__c(
                Account__c=individualAccount.Id,
                Address_Type__c='Employers');
            insert employersAddress;
        }
    }

    @isTest
    public static void getAddress(){
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
            Account account = [SELECT Id FROM Account where PersonEmail = 'test@test.co.za' LIMIT 1];
            List<String> requestedAddressTypeList = new List<String>{'Employers', 'Postal'};
            Test.startTest();
            Map<String, String> addresses = BranchAddressController.getAddress(account.Id, requestedAddressTypeList);
            System.assert(addresses != null, 'Test Working');
            Test.stopTest();
        }
    }

    @isTest
    public static void getFieldPickListValues(){
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
            SObject objObject = Address__c.SObjectType.newSObject();
            String objField = 'Shipping_Country__c';
            Test.startTest();
            List<String> addresses = BranchAddressController.getFieldPickListValues(objObject, objField);
            System.assert(addresses != null, 'Test Working');
            Test.stopTest();
        }
    }
}