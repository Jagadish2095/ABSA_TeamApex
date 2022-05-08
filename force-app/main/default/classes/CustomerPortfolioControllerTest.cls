/*
Lightning Component Controller For Customer Portfolio Controller Test Class
*
* @author  Muvhuso Nekhubvi : Absa
* @version v1.0
* @since   2020-01-26
*
*/

@isTest
public class CustomerPortfolioControllerTest {
    @isTest
    public static void testNegativeCustomerPortfolio(){
        Account ac1 = new Account();
        ac1.Name='Test2';
        ac1.CIF__c= 'ATRUST1375';
        insert ac1;



        User uc = new User();
        uc.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator (Custom)'].Id;
        uc.LastName = 'last';
        uc.Alias = 'alias';
        uc.Email = 'muvhus@absa.co.za';
        uc.Username = 'muvhus1@absa.co.za';
        uc.TimeZoneSidKey = 'America/Los_Angeles';
        uc.EmailEncodingKey = 'UTF-8';
        uc.LanguageLocaleKey = 'en_US';
        uc.EmployeeNumber = '2697052';
        uc.LocaleSidKey = 'en_US';
       // uc.UserRoleId = r.Id;
        insert uc;


         // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new CMSServiceMock_ApiRest(StringConstants.NEGATIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.CMS_GET_ACCOUNTDEATILS});

        Test.startTest();
        CustomerPortfolioController.getControlOfficers(ac1.Id);
        Test.stopTest();
    }

    @isTest
    public static void testNegativeCustomerPortfolios(){
        Account ac1 = new Account();
        ac1.Name='Test2';

        insert ac1;

         // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new CMSServiceMock_ApiRest(StringConstants.NEGATIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.CMS_GET_ACCOUNTDEATILS});

         Test.startTest();
         CustomerPortfolioController.getControlOfficers(ac1.Id);
        //dummy response call
        CMSGetBankerInfo_Resp_IB_v1 response = new CMSGetBankerInfo_Resp_IB_v1();
        Test.stopTest();
    }

     @isTest
    public static void testCustomerPortfolio(){
        Account ac = new Account();
        ac.Name='Test';
        ac.CIF__c= 'ATRUST1375';
        insert ac;


        User uc = new User();
        uc.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator (Custom)'].Id;
        uc.LastName = 'last';
        uc.Alias = 'alias';
        uc.Email = 'muvhus@absa.co.za';
        uc.Username = 'muvhus2@absa.co.za';
        uc.TimeZoneSidKey = 'America/Los_Angeles';
        uc.EmailEncodingKey = 'UTF-8';
        uc.LanguageLocaleKey = 'en_US';
        uc.EmployeeNumber = '2697052';
        uc.LocaleSidKey = 'en_US';

        insert uc;
         // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new CMSServiceMock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.CMS_GET_ACCOUNTDEATILS});

        Test.startTest();
        String displayCustomerPorfolio = CustomerPortfolioController.getControlOfficers(ac.Id);
        system.assertNotEquals(null, displayCustomerPorfolio);

        Test.stopTest();


    }

     @isTest //RN - Need this as the ConnectAPI is called in the casetriggerfunctions
    public static void testSendEmail() {

		map<String, Schema.RecordTypeInfo> caseRecordTypeMap = Case.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
        Account account = new Account(Name = 'Test Account');
        insert account;
		Contact con = new Contact();
        con.AccountId = account.id;
        con.LastName = 'testNatis';
        con.FirstName = 'NatisTest';
        con.Email = 'Natis@test.co.za';

        insert con;

        Case caseRec = new Case(Communication_Method__c = 'Email',
                                Status = 'New',
                                Origin = 'Email',
                                AccountId = account.Id,
                                Email__c = 'Natis@test.co.za',
                               	recordTypeId = caseRecordTypeMap.get('Service_Request').getRecordTypeId(),
                                Subject = 'test',
                                Description = 'test',
                               	Type__c = 'abc',
                                Out_Of_SLA_Comments__c = 'Test',
                           		Out_Of_SLA_Reason__c = 'Account Closed',
                                Bypass_Validation_Rules__c = true);

        insert caseRec;


        String emailAddress = 'Natis@test.co.za';

        Test.startTest();

        String response =  CustomerPortfolioController.sendEmail(emailAddress, caseRec.Id,'','','','','');
		System.assertNotEquals(null, response);
        Test.stopTest();

    }

}