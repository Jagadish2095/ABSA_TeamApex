@isTest
public class ASPDeviceKofaxDocumentScanningTest {

    @testSetup
    static void dataCreation(){
        Date birthDate = Date.newInstance(2000, 3, 9);
        Account account = new Account();
        account.ID_Number__pc = '9308305015082';
        account.FirstName = 'TestCVSServicesHelper';
        account.LastName = 'Tester';
        account.PersonBirthdate = birthDate;
        account.Gender__pc = 'Male';
        account.Date_Issued__pc = Date.today();
        account.Next_of_Kin_Last_Name__pc = 'Testing';
        account.Next_of_Kin_First_Name_s__pc = 'Testing';
        account.PersonOtherPhone='0834527788';
        insert account;
        Address__c residentialAddress = new Address__c(
            Account__c=account.Id,
            Address_Type__c='Residential');
        insert residentialAddress;
    }
    @isTest
    public static void testASPDeviceKofaxRequest(){
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User (Branch)'];
        User testUser = new User();
        testUser.Username = 'test.user@absa2.com.a2packages';
        testUser.SiteCode__c = '8392';
        testUser.Teller_Operator_Code__c = '5035555';
        testUser.LastName = 'User';
        testUser.Email = 'test.user@absa2.com.a2packages';
        testUser.Alias = 'testuser';
        testUser.TimeZoneSidKey = 'Africa/Johannesburg';
        testUser.LocaleSidKey = 'en_US';
        testUser.EmailEncodingKey = 'UTF-8';
        testUser.ProfileId = p.Id;
        testUser.LanguageLocaleKey = 'en_US';
        insert testUser;
        System.runAs(testUser) {
            Test.startTest();
            Account account = [SELECT Id FROM Account where FirstName = 'TestCVSServicesHelper' LIMIT 1];
            String getRequest = ASPDeviceKofaxDocumentScanningController.getKofaxScanningRequestMetadata(account.id,'test','12345');
            System.assert(getRequest != null, 'Test Working');
            Test.stopTest();
        }
    }
    @isTest
    public static void testDummyRequest(){
        ASPDeviceKofaxDocumentScanningRequest test = new ASPDeviceKofaxDocumentScanningRequest();
        test = test.getDummyReq();
        System.assert(test != null, 'Test Working');
    }
}