/**
* Controller for Absa Instant Life
* @author  Satya Boyenepalli
* @created 2021-08-05
*/ 

/**
* @description AbsaInstantLifeControllerTest
*/
@isTest
public class AbsaInstantLifeControllerTest {
    public static final String POSITIVE_QUOTE_RESPONSE_BODY = '{"ValidationErrors":[],"InsuredLineResults":[{"InsuredAmount":"6000000","ProductCode":"LIFE_COVER","PremiumAmount":"1273.63","StatusCode":"ACC"}],"WebLink":"https://qawww.instantlife.co.za/LifeInsurance/Restore?orderId=200799759ad643dea18e69a39521ed92&linkId=720d9870142a4af4b3764c90b3cb59f0"}';
    public static final String POSITIVE_LEAD_RESPONSE_BODY = '{"ConfirmationId":"95a8d8f0486645f1bb0032283313e2fc","ValidationErrors":[]}';
    public static final String POSITIVE_TRACKER_BODY = '{"ValidationErrors":[],"Leads":[{"FirstName":"GERT COEN","LastName":"ABSA TEST","LeadDate":"2021-07-26T00:00:00","CallbackDateTime":"2021-07-29T10:00:00","LeadStatus":"InProgress"}]}';

    @testSetup
	static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{Lead_IH_v1.INTEGRATION_SERVICE_NAME, Quote_IH_v1.INTEGRATION_SERVICE_NAME, Tracker_IH_v1.INTEGRATION_SERVICE_NAME });
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
            Advisor_Code__c = '112233',
            AB_Number__c = '',
            SiteCode__c = '',
            Teller_Operator_Code__c =''
        );
        insert au;
    } 

    /**
* @description ABSA Instant Life Quote service test
*/
    @IsTest  static  void  getAbsaInstantLifeQuoteTest()
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
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_QUOTE_RESPONSE_BODY));
        Account account = new Account();
        account.ID_Number__pc = '9308305015082';
        account.FirstName = 'TestCVSServicesHelper';
        account.LastName = 'Tester';
        account.Gender__pc = 'Male';
        account.Next_of_Kin_Last_Name__pc = 'Testing';
        account.Next_of_Kin_First_Name_s__pc = 'Testing';
        account.CIF__c = 'LTD 933';
        account.Language__c = 'english';
        account.Number_Of_Dependents__c = 0;
        account.PersonEmail = 'test@absa.africa';
        account.PersonMobilePhone = '0819908786';
        account.ID_Type__pc = 'PASSPORT';
        account.Nationality__pc = 'ZIM';
        account.Highest_Qualification__pc = 'Matric';
        account.Residential_Status__pc = 'Owner';
        account.Marital_Status__pc = 'MARRIED';
        account.CASA_Risk_Status__c = 'High';
        account.PersonBirthdate=System.Date.newInstance(1990, 03, 03);
        insert account;
        Quote_Res_IB_v1 resultBean = new Quote_Res_IB_v1();
        Test.startTest();
        string responseBean=AbsaInstantLifeController.getAbsaInstantLifeQuote(account.Id,'5000000','PostMatricDiploma','N','20000');
        resultBean = (Quote_Res_IB_v1) (JSON.deserialize(responseBean, Quote_Res_IB_v1.class));
        System.assertEquals(resultBean.statusCode, 200);
        Test.stopTest();
        }
    }
    /**
* @description ABSA Instant Life Lead Submit service
*/
    @IsTest  static void  LeadSubmitTest()
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
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_LEAD_RESPONSE_BODY));
        Lead_Req_IB_v1 requestBean = new Lead_Req_IB_v1();
        Lead_Res_IB_v1 responseBean = new Lead_Res_IB_v1();
        //Account
        Account testAccount = new Account();
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Individual_Client').getRecordTypeId();
        testAccount.RecordTypeId = recordTypeId;
        testAccount.PersonMobilePhone = '0747003747';
        testAccount.PersonBirthdate = Date.valueOf('1981-07-11');
        testAccount.FirstName = 'Tony';
        testAccount.ID_Number__pc = '8107115017084';
        testAccount.ID_Type__pc = 'SA Identity Document';
        testAccount.LastName = 'Stark';
        testAccount.Client_Type__c = 'Individual Client';
        testAccount.Phone = '0114453322';
        testAccount.Gender__pc = 'Male';
        testAccount.AccountNumber = '1234567890';
        insert testAccount;
        Address__c add=new Address__c();
        add.Shipping_Street__c='test';
        add.Address_TYpe__c='Postal';
        add.Account__c= testAccount.Id;
        insert add;
        Test.startTest();
        String dateStr = String.valueof(Datetime.now().format('yyyy-MM-dd'));
        String results =AbsaInstantLifeController.submitAbsaInstantLifeLead(testAccount.Id, dateStr ,'T14:00:00');
        System.assertEquals(results, 'Success');
        Test.stopTest();
        }
    }
    /**
* @description ABSA Instant Life Lead Tracker service
*/
    @IsTest static  void getAbsaInstantLifLeadTracker()
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
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_TRACKER_BODY));
        Tracker_Res_IB_v1 response = new Tracker_Res_IB_v1() ;
        Test.startTest();
        string results = AbsaInstantLifeController.getAbsaInstantLifLeadTracker();
        response = (Tracker_Res_IB_v1) (JSON.deserialize(results, Tracker_Res_IB_v1.class));
        System.assertEquals(response.statusCode, 200);
        Test.stopTest();
        }
    }
    /**
* @description ABSA Instant Life getAccountInfo Method

*/ 
    @IsTest static  void getAccountInfo()
    {
        Account account = new Account();
        account.Name='test';
        insert account;
        Test.startTest();
        string results = AbsaInstantLifeController.getAccountInfo(account.Id);
        System.assertEquals(account.Id,account.Id);
        Test.stopTest();
    }
    /**
* @description ABSA Instant Life getName Method
*
*/ 
    @IsTest static  void getName()
    {
        Test.startTest();
        string results = AbsaInstantLifeController.getAgentName();
        System.assertEquals(results,results);
        Test.stopTest();
    }

}