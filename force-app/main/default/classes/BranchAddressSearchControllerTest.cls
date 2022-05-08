/*
Controller Test Class For BranchAddressSearchController class
*
* @author  Clifford Willers : ABSA (IQ Business)
* @version v1.0
* @since   2020-11-17
*
*/

@isTest
public class BranchAddressSearchControllerTest {
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
    }

    @isTest
    public static void validateFieldsTest(){
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
            String area = 'FAERIE GLEN';
            Test.startTest();
            List<Map<String, Object>> errorText = BranchAddressSearchController.getPostalCodeDetails(area);
            System.assert(errorText != null, 'Test Working');
            Test.stopTest();
        }
    }
}