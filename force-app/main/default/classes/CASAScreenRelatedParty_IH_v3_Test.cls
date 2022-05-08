/**
* @description       :
* @author            : ChangeMeIn@UserSettingsUnder.SFDoc
* @group             :
* @last modified on  : 2021-11-08
* @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
* Modifications Log
* Ver   Date         Author                               Modification
* 1.0   03-29-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
@isTest
public class CASAScreenRelatedParty_IH_v3_Test {

    public static final String POSITIVE_RESPONSE_BODY = '{"msgNo":"0","msg":"Success","refNo":"120004946","status":"P"}';
    public static final String NEGATIVE_RESPONSE_BODY = '{"msgNo":"0","msg":"Success","refNo":"0","status":""}';
    /**
*@description make data fro testing
*/
    @testSetup
    public static void makeData() {
        String auniqueUserName = 'UserAdmin' + DateTime.now().getTime() + '@testorg.com';
        String aemail = 'UserAdmin@testorg.com';
       // Profile ap = [SELECT Id FROM Profile WHERE Name = 'Standard User (Branch)'];
        Profile ap = [SELECT Id FROM Profile WHERE Name = 'System Administrator (Custom)'];
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
        Integration_API__c apiDev = new Integration_API__c();
        apiDev.Name = 'API Manager';
        apiDev.Environment__c = getEnvironment();
        apiDev.Client_Secret__c = '*****';
        apiDev.Client_ID__c = '*****';
        apiDev.Base_URL__c = 'https://Absa330762.jitterbit.eu';
        insert apiDev;
    }
    @isTest public static String getEnvironment() {
        List<Organization> salesforceOrg = new List<Organization>();
        
       if(salesforceOrg.size() == 0){
           salesforceOrg = [SELECT IsSandbox FROM Organization];
        }
            if (salesforceOrg.size() == 1) {
            if (salesforceOrg[0].IsSandbox) {
                String hostName = String.valueOf(URL.getSalesforceBaseUrl());
                return hostName.contains(StringConstants.UAT_LOWERCASE_STRING) ? StringConstants.UAT_UPPERCASE_STRING : StringConstants.DEVELOPMENT_STRING;
            } else {
                return StringConstants.PRODUCTION_STRING;
            }
            
        } 
        System.assertEquals(salesforceOrg.size(), 1);
        return null;
    }
    @isTest static void screenRelatedPartyPositive() {
  
         // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CASAScreenRelatedPartyMock_ApiRest_v2(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.CASA_SCREEN_RELATED_PARTY});
       // WimiTestDataFactory testDataFactory = new WimiTestDataFactory();       
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
        
         Account testAccount= new Account();
        testAccount.firstName = 'Test Name';
        testAccount.lastname = 'Test Sur';
        testAccount.ID_Number__pc = '4407285096080';
        testAccount.PersonBirthdate = Date.valueOf('1967-03-13');
        //W-005355 : Anka Ganta : 2020-07-09
        testAccount.Country_of_Incorporation__c='South Africa';
        testAccount.Client_Group__c = 'Individual';
        
        testAccount.CIF__c = '';
        testAccount.Countries_Traded_With__c = 'South Africa';
        testAccount.Source_of_Income__c = 'Salary';
        insert testAccount;
        Integration_API__c apiDev = [Select id,Environment__c,Client_Secret__c,Client_ID__c, Base_URL__c from Integration_API__c where Name = 'API Manager' limit 1];

        Account acctSecondary = new Account();
		acctSecondary.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual Prospect').getRecordTypeId();
		acctSecondary.ID_Number__pc = '6803037015089';
		acctSecondary.ID_Type__pc = 'SA Identity Document';
		acctSecondary.FirstName = 'First Name1';
		acctSecondary.LastName = 'Last Name1';
		acctSecondary.Initials__pc = 'I';
		acctSecondary.PersonTitle = 'Mr';
		acctSecondary.Client_Type__c = 'Individual Client';
		acctSecondary.CASA_Reference_Number__pc = '12454';
		acctSecondary.CASA_Screening_Status__c = 'Matched';
		insert acctSecondary;

		Account acc = [SELECT PersonContactId FROM Account WHERE Id = :acctSecondary.Id];
		Id personContactId = acc.PersonContactId;

		AccountContactRelation accConRel2 = new AccountContactRelation(
			AccountId = testAccount.Id,
			ContactId = personContactId,
			Roles = 'Shareholder/Controller',
			Primary_Entity_Id__c = testAccount.Id,
			Share_Percentage__c = 50
		);
		insert accConRel2;
        
        // Set mock callout class        
        System.runAs(au) {           
            Test.startTest();
            Map<CASAScreenRelatedParty_Resp_IB_v3, Sys_Log_Integration__c> responseBean = CASAScreenRelatedParty_IH_v3.screenRelatedPartyMapBusinessAcc(testAccount, '121212',apiDev);
             testAccount.ID_Type__c = 'Registration Number';
            update testAccount;
            Map<CASAScreenRelatedParty_Resp_IB_v3, Sys_Log_Integration__c> responseBean2 = CASAScreenRelatedParty_IH_v3.screenRelatedPartyMapBusinessAcc(testAccount,'1200',apiDev);
            CASAScreenRelatedParty_Req_IB_v3 response3 = CASAScreenRelatedParty_IU_v3.mapRequestStokvelaccountFields(accConRel2, null);
            Test.stopTest();
            System.assert( responseBean != null, 'assert failed');
        }
    }
     @isTest static void screenRelatedPartyNegative() {
         // WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        IntegrationTestDataFactory.insertIntegrationTranslations();
        Map<CASAScreenRelatedParty_Resp_IB_v3, Sys_Log_Integration__c> relatedPartyMap = new Map<CASAScreenRelatedParty_Resp_IB_v3, Sys_Log_Integration__c>();
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CASAScreenRelatedParty_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.CASA_SCREEN_RELATED_PARTY});
     
        
        Account testAccount= new Account();
        testAccount.firstName = 'Test Name';
        testAccount.lastname = 'Test Sur';
        testAccount.ID_Number__pc = '4407285096080';
        testAccount.PersonBirthdate = Date.valueOf('1967-03-13');
        //W-005355 : Anka Ganta : 2020-07-09
        testAccount.Country_of_Incorporation__c='South Africa';
        testAccount.Client_Group__c = 'Individual';
        
        testAccount.CIF__c = '';
        testAccount.Countries_Traded_With__c = 'South Africa';
        testAccount.Source_of_Income__c = 'Salary';
        insert testAccount;
   
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
        Integration_API__c apiDev = [Select id,Environment__c,Client_Secret__c,Client_ID__c, Base_URL__c from Integration_API__c where Name = 'API Manager' limit 1];
        // Set mock callout class        
        System.runAs(au) {           
         Test.startTest();
         relatedPartyMap = CASAScreenRelatedParty_IH_v3.screenRelatedPartyMapBusinessAcc(testAccount,'1200',apiDev);
        Test.stopTest();
        System.assert(CASAScreenRelatedParty_IH_v3.screenRelatedPartyMapBusinessAcc(testAccount,'1200',apiDev)  != null,'') ;
        }
        
           }
    
    @isTest static void screenRelatedPartyException() {        
        // Set mock callout class 
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.CASA_SCREEN_RELATED_PARTY});
        
        Test.startTest();
        Integration_API__c apiDev = [Select id,Environment__c,Client_Secret__c,Client_ID__c, Base_URL__c from Integration_API__c where Name = 'API Manager' limit 1];
        Map<CASAScreenRelatedParty_Resp_IB_v3, Sys_Log_Integration__c> responseBean = CASAScreenRelatedParty_IH_v3.screenRelatedPartyMapBusinessAcc(null,'',apiDev);  
        System.assert( responseBean != null, 'assert failed');
        Test.stopTest();
    }
   
    
    @isTest
    static void screenRelatedPartyNoIntegrationPositieSettings() {
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ StringConstants.ECASA_STRING});
        CASAScreenRelatedParty_Resp_IB_v3 response =new CASAScreenRelatedParty_Resp_IB_v3();
        response.refNo ='12344';
        response.statusCode = 200;
        response.message ='succcess';
        response.msgNo ='0';
        response.msg = 'success';
        response.respStatus= 'P';
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
            Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
            Test.startTest();
            CASAScreenRelatedParty_Resp_IB_v3 respo = CASAScreenRelatedParty_IH_v3.translateToInternalValues(response);
          
            //response.respStatus = respo.respStatus;
            System.assert(response.respStatus ==respo.respStatus,'assert failed');
            Test.stopTest();
        }
    }
    @isTest static void screenRelatedPartyNoIntegrationNegativeSettings() {
       //  IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ StringConstants.ECASA_STRING});
        CASAScreenRelatedParty_Resp_IB_v3 response =new CASAScreenRelatedParty_Resp_IB_v3();
        response.refNo ='12344';
        response.statusCode = 200;
        response.message ='succcess';
        response.msgNo ='0';
        response.msg = 'success';
        response.respStatus= 'w';
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
            Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
            Test.startTest();
            CASAScreenRelatedParty_Resp_IB_v3 respo = CASAScreenRelatedParty_IH_v3.translateToInternalValues(response);
         
            response.respStatus = respo.respStatus;

            System.assert(response.respStatus !='P','assert failed');
            Test.stopTest();
        }
    }
      @isTest static void screenRelatedPartyMapBusinessPositiveAcc() {
            
           // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CASAScreenRelatedPartyMock_ApiRest_v2(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.CASA_SCREEN_RELATED_PARTY});
      //  WimiTestDataFactory testDataFactory = new WimiTestDataFactory(); 
          
        Account testAccount= new Account();
        testAccount.firstName = 'Test Name';
        testAccount.lastname = 'Test Sur';
        testAccount.ID_Number__pc = '4407285096080';
        testAccount.PersonBirthdate = Date.valueOf('1967-03-13');
        //W-005355 : Anka Ganta : 2020-07-09
        testAccount.Country_of_Incorporation__c='South Africa';
        testAccount.Client_Group__c = 'Individual';
        
        testAccount.CIF__c = '';
        testAccount.Countries_Traded_With__c = 'South Africa';
        testAccount.Source_of_Income__c = 'Salary';
        insert testAccount;
          
          //Create Trading as Name test records
        Trading_as_Name__c testTradingAsName = new Trading_as_Name__c();
        testTradingAsName.Name = 'T/A Test';
        testTradingAsName.Account__c = testAccount.id;
        insert testTradingAsName;         
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
        Integration_API__c apiDev = [Select id,Environment__c,Client_Secret__c,Client_ID__c, Base_URL__c from Integration_API__c where Name = 'API Manager' limit 1];
        // Set mock callout class        
        System.runAs(au) {           
            Test.startTest();
            Map<CASAScreenRelatedParty_Resp_IB_v3, Sys_Log_Integration__c> responseBean = CASAScreenRelatedParty_IH_v3.screenTradingAsNamesMapBusinessAcc(testTradingAsName, '121212',apiDev);
            Test.stopTest();
            System.assert( responseBean != null, 'assert failed');
        }
    }
     
    @isTest static void screenRelatedPartyMapBusinessNegativeAcc() {
            
           // Set mock callout class 
       // Test.setMock(HttpCalloutMock.class, new CASAScreenRelatedPartyMock_ApiRest_v2(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.CASA_SCREEN_RELATED_PARTY});
      //  WimiTestDataFactory testDataFactory = new WimiTestDataFactory(); 
          
        Account testAccount= new Account();
        testAccount.firstName = 'Test Name';
        testAccount.lastname = 'Test Sur';
        testAccount.ID_Number__pc = '4407285096080';
        testAccount.PersonBirthdate = Date.valueOf('1967-03-13');
        //W-005355 : Anka Ganta : 2020-07-09
        testAccount.Country_of_Incorporation__c='South Africa';
        testAccount.Client_Group__c = 'Individual';
        
        testAccount.CIF__c = '';
        testAccount.Countries_Traded_With__c = 'South Africa';
        testAccount.Source_of_Income__c = 'Salary';
        insert testAccount;
        
          //Create Trading as Name test records
        Trading_as_Name__c testTradingAsName = new Trading_as_Name__c();
        testTradingAsName.Name = 'T/A Test';
        testTradingAsName.Account__c = testAccount.id;
        insert testTradingAsName;
       
          
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
        Integration_API__c apiDev = [Select id,Environment__c,Client_Secret__c,Client_ID__c, Base_URL__c from Integration_API__c where Name = 'API Manager' limit 1];
      
        // Set mock callout class        
        System.runAs(au) {           
            Test.startTest();
            Map<CASAScreenRelatedParty_Resp_IB_v3, Sys_Log_Integration__c> responseBean = CASAScreenRelatedParty_IH_v3.screenTradingAsNamesMapBusinessAcc(null, '121212', apiDev);
           
             Test.stopTest();
            System.assert( responseBean != null, 'assert failed');
        }
    }
    /*
    @isTest static void dummyResponse() {
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ StringConstants.CASA_SCREEN_RELATED_PARTY_V6});
        Test.startTest();
        CASAScreenRelatedParty_Resp_IB_v3.createDummyRequest();
        CASAScreenRelatedParty_Req_IB_v3.createDummyRequest();        
        System.assertEquals('SUCESSS','SUCESSS');
        Test.stopTest();
    }*/
    
    
    private static CASAScreenRelatedParty_Resp_IB_v3 callStokvelscreenrelatedMethod() {
        CASAScreenRelatedParty_Req_IB_v3    dummyBean = CASAScreenRelatedParty_Req_IB_v3.createDummyRequestV3();
        CASAScreenRelatedParty_Resp_IB_v3  responseBean = CASAScreenRelatedParty_IH_v3.casaScreenRelatedClientV7(dummyBean);
        return responseBean;
    }
    @isTest
    static void stokvelscreenrelatedPositive() {
        //IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new List<String>{ StringConstants.CASA_SCREEN_RELATED_PARTY_V6});
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
            Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
            CASAScreenRelatedParty_Resp_IB_v3 response = callStokvelscreenrelatedMethod();
            string positveResponse = JSON.serializePretty(response);           
            CASAScreenRelatedParty_Resp_IB_v3 validresponse = (CASAScreenRelatedParty_Resp_IB_v3)JSON.deserialize(positveResponse, CASAScreenRelatedParty_Resp_IB_v3.class);
            System.assert(validresponse.refNo !='120004946','assert failed');
            Test.stopTest();
        }
    }
    
    @isTest
    static void stokvelscreenrelatedNegativeTest() {
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ StringConstants.CASA_SCREEN_RELATED_PARTY_V6});
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
        // Set mock callout class
        
        System.runAs(au) {
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, NEGATIVE_RESPONSE_BODY));
            CASAScreenRelatedParty_Resp_IB_v3 response = callStokvelscreenrelatedMethod();
            string negatveResponse = JSON.serializePretty(response);           
            CASAScreenRelatedParty_Resp_IB_v3 validresponse = (CASAScreenRelatedParty_Resp_IB_v3)JSON.deserialize(negatveResponse, CASAScreenRelatedParty_Resp_IB_v3.class);
            System.assert(validresponse.refNo !='0','assert failed');
            Test.stopTest();
        }
    }
    
    
}