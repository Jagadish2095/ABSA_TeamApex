/**
 *  @description Test Class Name: CASAPrimaryClientScreening_IH_v3_Test
 *  Main Handler Class : CASAPrimaryClientScreening_IH_v3
 * @author  Anka Ganta : Absa 
 * @since   2019-12-04
 *
 */
@isTest
public class CASAPrimaryClientScreening_IH_v3_Test {
    @isTest
    private static void CASAPrimaryClientScreeningTest() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new CASAScreenRelatedParty_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(
            StringConstants.API_MANAGER,
            new List<String>{ StringConstants.CASA_PRIMARY_CLIENT_SCREENING, StringConstants.CASA_SCREEN_RELATED_PARTY_V6 }
        );
        IntegrationTestDataFactory.insertIntegrationTranslations();
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        //W-005355 : Anka Ganta : 2020-07-09
        testDataFactory.testAccount.Country_of_Incorporation__c = 'South Africa';

        //Create Trading as Name test records
        Trading_as_Name__c testTradingAsName = new Trading_as_Name__c();
        List<Trading_as_Name__c> testTradingAsNameLst = new List<Trading_as_Name__c>();
        testTradingAsName.Name = 'T/A Test';
        testTradingAsName.Account__c = testDataFactory.testAccount.id;
        testTradingAsNameLst.add(testTradingAsName);
        insert testTradingAsNameLst;

        List<User> userList = [SELECT AB_Number__c FROM User WHERE AB_Number__c != NULL];

        System.assert(testTradingAsNameLst != null);

        Test.startTest();
        CASAPrimaryClientScreening_IH_v3.casaPrimaryClientScreeningBusinessAcc(
            testDataFactory.testAccount,
            new List<Account>{ testDataFactory.testProspectAccount },
            testTradingAsNameLst,
            null
        );
        Test.stopTest();
    }

    //Primary Account
    @isTest
    static void CASAPrimaryClientScreeningPositiveResponse() {
        IntegrationTestDataFactory.insertIntegrationTranslations();
        List<AccountContactRelation> acrList = new List<AccountContactRelation>();
        //insert acct;
        Account acctPrimary = new Account(Name = 'Test Primary Account');
        acctPrimary.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Prospect').getRecordTypeId();
        acctPrimary.Country_of_Incorporation__c = 'South Africa';
        acctPrimary.Client_Group__c = 'Non Individual';
        acctPrimary.CASA_Reference_Number__c = '12233';
        acctPrimary.CIF__c = '';
        acctPrimary.Countries_Traded_With__c = 'South Africa';
        acctPrimary.Source_of_Income__c = 'Donation';
        acctPrimary.Registration_Number__c = '1223333';
        acctPrimary.CASA_Screening_Date__c = System.today();
        acctPrimary.CASA_Risk_Status__c = '';
        acctPrimary.Client_Type__c = 'Non Individual';
        acctPrimary.ID_Type__c = 'Registration Number';
        insert acctPrimary;

        //insert related acct;
        Account acctSecondary = new Account();
        acctSecondary.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual Prospect').getRecordTypeId();
        acctSecondary.ID_Number__pc = '6803037015089';
        acctSecondary.ID_Type__pc = 'SA Identity Document';
        acctSecondary.FirstName = 'First Name';
        acctSecondary.LastName = 'Test Last Name';
        acctSecondary.Initials__pc = 'I';
        acctSecondary.PersonTitle = 'Mr';
        acctSecondary.Client_Type__c = 'Individual Client';
        acctSecondary.Country_of_Citizenship__c = 'South Africa';
        acctPrimary.Country_of_Incorporation__c = 'South Africa';
        insert acctSecondary;
        Account acc = [SELECT PersonContactId FROM Account WHERE Id = :acctSecondary.Id];
        Id personContactId = acc.PersonContactId;
        AccountContactRelation accConRel = new AccountContactRelation(AccountId = acctPrimary.Id, ContactId = personContactId);
        insert accConRel;
        acrList.add(accConRel);

        Set<Id> relatedPartIdSet = new Set<Id>();
        for (AccountContactRelation acr : acrList) {
            relatedPartIdSet.add(acr.ContactId);
        }
        List<Account> rpAccounts = new AccountsSelector().selectCasaFieldsByPersonContactSetId(relatedPartIdSet);

        //Create Trading as Name test records
        Trading_as_Name__c testTradingAsName = new Trading_as_Name__c();
        List<Trading_as_Name__c> testTradingAsNameLst = new List<Trading_as_Name__c>();
        testTradingAsName.Name = 'T/A Test';
        testTradingAsName.Account__c = acctPrimary.id;
        testTradingAsNameLst.add(testTradingAsName);
        insert testTradingAsNameLst;

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new CASAPrimaryCliScreeV3_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new List<String>{ StringConstants.CASA_PRIMARY_CLIENT_SCREENING_V2 });

        List<Integration_API__c> apiList = new List<Integration_API__c>();
        //API (Dev)
        Integration_API__c apiDev = new Integration_API__c();
        apiDev.Name = 'API Manager';
        apiDev.Environment__c = 'Development';
        apiDev.Client_Secret__c = '*****';
        apiDev.Client_ID__c = '*****';
        apiList.add(apiDev);

        List<Integration_Service__c> serviceList = new List<Integration_Service__c>();
        //Service(Dev)
        Integration_Service__c serviceDev = new Integration_Service__c();
        serviceDev.Integration_API_ID__c = apiDev.Id;
        serviceDev.Name = 'CASA Screen Related Party';
        serviceDev.Content_Type__c = 'application/json';
        serviceDev.Method__c = 'POST';
        serviceDev.URL_Extension__c = 'CASA Screen Related Party';
        serviceDev.Username__c = '**/***@****/******';
        serviceDev.Password__c = '****************';
        serviceList.add(serviceDev);

        Account account2 = new Account(Name = 'Test Account2');
        account2.RecordTypeId = schema.SObjectType.account.getRecordTypeInfosByName().get('Business Prospect').getRecordTypeId();
        account2.Country_of_Incorporation__c = 'South Africa';
        account2.Client_Group__c = 'Non Individual';
        account2.Client_Type__c = 'Private Company';
        account2.CASA_Reference_Number__c = '12233';
        account2.CIF__c = '';
        account2.Countries_Traded_With__c = 'South Africa';
        account2.Source_of_Income__c = 'Donation';
        insert account2;
        
        FinServ__ReciprocalRole__c resRole = new FinServ__ReciprocalRole__c();
        resRole.FinServ__CreateInverseRole__c = true;
        resRole.FinServ__InverseRole__c = 'Director';
        insert resRole;

        FinServ__AccountAccountRelation__c accAccRel = new FinServ__AccountAccountRelation__c(
            FinServ__Account__c = acctPrimary.Id,
            FinServ__RelatedAccount__c = account2.Id,
            Roles__c = 'Shareholder/Controller',
            FinServ__Role__c = resRole.id,
            Primary_Entity_Id__c = acctPrimary.Id,
            Shareholding_Percentage__c = 0
        );
        insert accAccRel;
        Test.startTest();

        String countryOfResTranslated = 'SA';
        String clientTypeGrpTranslated = '';
        CASAPrimaryClientScreening_IU_v3.mapRequestFields(acctPrimary, countryOfResTranslated, clientTypeGrpTranslated, '05');

        CASAPrimaryClientScreening_IH_v3.casaPrimaryClientScreeningBusinessAcc(acctPrimary, rpAccounts, testTradingAsNameLst, new List<Account> {account2});

        List<Account> relparty = new List<Account>();

        CASAPrimaryClientScreening_Resp_IB_v3  response = CASAPrimaryClientScreening_IH_v3.casaPrimaryClientScreeningBusinessAcc(acctSecondary, relparty, testTradingAsNameLst, new List<Account> {account2});

        System.assertNotEquals(400, response.statusCode);
        Test.stopTest();
    }

    @isTest
    static void CASAPrimaryClientScreeningNegativeResponseWithInvalidAccAndUserID() {
        IntegrationTestDataFactory.insertIntegrationTranslations();
        Account testAccount = new Account();
        // testAccount.Client_Group__c = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.ECASA_STRING, StringConstants.CLIENT_TYPE_GROUP, testAccount.Client_Group__c.replace('Non Individual', 'Non-Individual'), StringConstants.OUTBOUND_RECORD_TYPE);
        testAccount.Name = 'Test Name';
        testAccount.Country_of_Incorporation__c = 'South Africa';
        testAccount.Client_Group__c = 'Non Individual';
        testAccount.CASA_Reference_Number__c = '12233';
        testAccount.CIF__c = '';
        testAccount.Countries_Traded_With__c = 'South Africa';
        testAccount.Source_of_Income__c = 'Donation';
        testAccount.Registration_Number__c = '1223333';
        testAccount.CASA_Screening_Date__c = System.today();
        testAccount.CASA_Risk_Status__c = '';
        testAccount.Client_Type__c = '';
        testAccount.ID_Type__c = 'Registration Number';
        insert testAccount;

        //Create Trading as Name test records
        Trading_as_Name__c testTradingAsName = new Trading_as_Name__c();
        List<Trading_as_Name__c> testTradingAsNameLst = new List<Trading_as_Name__c>();
        testTradingAsName.Name = 'T/A Test';
        testTradingAsName.Account__c = testAccount.id;
        testTradingAsNameLst.add(testTradingAsName);
        insert testTradingAsNameLst;

        List<AccountContactRelation> acrList = [SELECT AccountId, ContactId FROM AccountContactRelation WHERE AccountId = :testAccount.Id];

        Set<Id> relatedPartIdSet = new Set<Id>();
        for (AccountContactRelation acr : acrList) {
            relatedPartIdSet.add(acr.ContactId);
        }
        List<Account> rpAccounts = new AccountsSelector().selectCasaFieldsByPersonContactSetId(relatedPartIdSet);
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new CASAPrimaryCliScreeV3_Mock_ApiRest(StringConstants.NEGATIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new List<String>{ StringConstants.CASA_PRIMARY_CLIENT_SCREENING_V3 });

        Account account2 = new Account(Name = 'Test Account2');
        account2.RecordTypeId = schema.SObjectType.account.getRecordTypeInfosByName().get('Business Prospect').getRecordTypeId();
        account2.Country_of_Incorporation__c = 'South Africa';
        account2.Client_Group__c = 'Non Individual';
        account2.Client_Type__c = 'Private Company';
        account2.CASA_Reference_Number__c = '12233';
        account2.CIF__c = '';
        account2.Countries_Traded_With__c = 'South Africa';
        account2.Source_of_Income__c = 'Donation';
        insert account2;
        
        FinServ__ReciprocalRole__c resRole = new FinServ__ReciprocalRole__c();
        resRole.FinServ__CreateInverseRole__c = true;
        resRole.FinServ__InverseRole__c = 'Director';
        insert resRole;

        FinServ__AccountAccountRelation__c accAccRel = new FinServ__AccountAccountRelation__c(
            FinServ__Account__c = testAccount.Id,
            FinServ__RelatedAccount__c = account2.Id,
            Roles__c = 'Shareholder/Controller',
            FinServ__Role__c = resRole.id,
            Primary_Entity_Id__c = testAccount.Id,
            Shareholding_Percentage__c = 0
        );
        insert accAccRel;

        Test.startTest();
        CASAPrimaryClientScreening_Resp_IB_v3 response = CASAPrimaryClientScreening_IH_v3.casaPrimaryClientScreeningBusinessAcc(
            testAccount,
            rpAccounts,
            testTradingAsNameLst, 
            new List<Account> {account2}
        );
        System.assertEquals(500, response.statusCode);
        Test.stopTest();
    }

    @isTest
    static void CASAPrimaryClientScreeningNegativeNoMockResponse() {
        IntegrationTestDataFactory.insertIntegrationTranslations();
        Account testAccount = new Account();
        testAccount.Client_Group__c = 'Non Individual'; //Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.ECASA_STRING, StringConstants.CLIENT_TYPE_GROUP, testAccount.Client_Group__c.replace('Non Individual', 'Non-Individual'), StringConstants.OUTBOUND_RECORD_TYPE);
        testAccount.Name = 'Test Name';
        testAccount.Country_of_Incorporation__c = 'South Africa';
        insert testAccount;
        List<AccountContactRelation> acrList = [SELECT AccountId, ContactId FROM AccountContactRelation WHERE AccountId = :testAccount.Id];

        Set<Id> relatedPartIdSet = new Set<Id>();
        for (AccountContactRelation acr : acrList) {
            relatedPartIdSet.add(acr.ContactId);
        }

        //Create Trading as Name test records
        Trading_as_Name__c testTradingAsName = new Trading_as_Name__c();
        List<Trading_as_Name__c> testTradingAsNameLst = new List<Trading_as_Name__c>();
        testTradingAsName.Name = 'T/A Test';
        testTradingAsName.Account__c = testAccount.id;
        testTradingAsNameLst.add(testTradingAsName);
        insert testTradingAsNameLst;

        Account account2 = new Account(Name = 'Test Account2');
        account2.RecordTypeId = schema.SObjectType.account.getRecordTypeInfosByName().get('Business Prospect').getRecordTypeId();
        account2.Country_of_Incorporation__c = 'South Africa';
        account2.Client_Group__c = 'Non Individual';
        account2.Client_Type__c = 'Private Company';
        account2.CASA_Reference_Number__c = '12233';
        account2.CIF__c = '';
        account2.Countries_Traded_With__c = 'South Africa';
        account2.Source_of_Income__c = 'Donation';
        insert account2;
        
        FinServ__ReciprocalRole__c resRole = new FinServ__ReciprocalRole__c();
        resRole.FinServ__CreateInverseRole__c = true;
        resRole.FinServ__InverseRole__c = 'Director';
        insert resRole;

        FinServ__AccountAccountRelation__c accAccRel = new FinServ__AccountAccountRelation__c(
            FinServ__Account__c = testAccount.Id,
            FinServ__RelatedAccount__c = account2.Id,
            Roles__c = 'Shareholder/Controller',
            FinServ__Role__c = resRole.id,
            Primary_Entity_Id__c = testAccount.Id,
            Shareholding_Percentage__c = 0
        );
        insert accAccRel;

        List<Account> rpAccounts = new AccountsSelector().selectCasaFieldsByPersonContactSetId(relatedPartIdSet);
        Test.startTest();
        CASAPrimaryClientScreening_Resp_IB_v3 response = CASAPrimaryClientScreening_IH_v3.casaPrimaryClientScreeningBusinessAcc(
            testAccount,
            rpAccounts,
            testTradingAsNameLst,
             new List<Account> {account2}
        );
        System.assertEquals(500, response.statusCode);
        Test.stopTest();
    }

    @isTest
    static void CASAPrimaryClientScreeningDummyRequest() {
        Test.startTest();

        CASAPrimaryClientScreening_Req_IB_v3 screenResponse = CASAPrimaryClientScreening_Req_IB_v3.createDummyRequest();
        CASAPrimaryClientScreening_Resp_IB_v3.dummyResponse();
        System.assert(screenResponse != null);
        Test.stopTest();
    }

    @isTest
    static void CASAPrimaryClientScreeningNoTranslations() {
        Account testAccount = new Account();
        testAccount.Name = 'Test Name';
        testAccount.Country_of_Incorporation__c = 'South Africa';
        insert testAccount;
        List<AccountContactRelation> acrList = [SELECT AccountId, ContactId FROM AccountContactRelation WHERE AccountId = :testAccount.Id];

        //Create Trading as Name test records
        Trading_as_Name__c testTradingAsName = new Trading_as_Name__c();
        List<Trading_as_Name__c> testTradingAsNameLst = new List<Trading_as_Name__c>();
        testTradingAsName.Name = 'T/A Test';
        testTradingAsName.Account__c = testAccount.id;
        testTradingAsNameLst.add(testTradingAsName);
        insert testTradingAsNameLst;

        Set<Id> relatedPartIdSet = new Set<Id>();
        for (AccountContactRelation acr : acrList) {
            relatedPartIdSet.add(acr.ContactId);
        }
        List<Account> rpAccounts = new AccountsSelector().selectCasaFieldsByPersonContactSetId(relatedPartIdSet);
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new CASAPrimaryCliScreeV3_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new List<String>{ StringConstants.CASA_PRIMARY_CLIENT_SCREENING_V2 });

        Test.startTest();
        CASAPrimaryClientScreening_Resp_IB_v3 response = CASAPrimaryClientScreening_IH_v3.casaPrimaryClientScreeningBusinessAcc(
            testAccount,
            null,
            testTradingAsNameLst,
            null
        );
        System.assertEquals(500, response.statusCode);
        Test.stopTest();
    }

    //Primary Account
    @isTest
    static void CASAPrimaryTradingNamePositiveResponse() {
        IntegrationTestDataFactory.insertIntegrationTranslations();
        List<AccountContactRelation> acrList = new List<AccountContactRelation>();
        //insert acct;
        Account acctPrimary = new Account(Name = 'Test Primary Account');
        acctPrimary.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Prospect').getRecordTypeId();
        acctPrimary.Country_of_Incorporation__c = 'South Africa';
        acctPrimary.Client_Group__c = 'Non Individual';
        acctPrimary.CASA_Reference_Number__c = '12233';
        acctPrimary.CIF__c = '';
        acctPrimary.Countries_Traded_With__c = 'South Africa';
        acctPrimary.Source_of_Income__c = 'Donation';
        acctPrimary.Registration_Number__c = '1223333';
        acctPrimary.CASA_Screening_Date__c = System.today();
        acctPrimary.CASA_Risk_Status__c = '';
        acctPrimary.Client_Type__c = 'Non Individual';
        acctPrimary.ID_Type__c = 'Registration Number';
        insert acctPrimary;

        //Create Trading as Name test records
        Trading_as_Name__c testTradingAsName = new Trading_as_Name__c();
        List<Trading_as_Name__c> testTradingAsNameLst = new List<Trading_as_Name__c>();
        testTradingAsName.Name = 'T/A Test';
        testTradingAsName.Account__c = acctPrimary.id;
        testTradingAsNameLst.add(testTradingAsName);
        insert testTradingAsNameLst;

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new CASAPrimaryCliScreeV3_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new List<String>{ StringConstants.CASA_PRIMARY_CLIENT_SCREENING_V2 });
        //IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.CASA_SCREEN_RELATED_PARTY});

        Test.startTest();

        String countryOfResTranslated = 'SA';
        String clientTypeGrpTranslated = '';
        CASAPrimaryClientScreening_IU_v3.mapRequestFields(acctPrimary, countryOfResTranslated, clientTypeGrpTranslated, '05');

        CASAPrimaryClientScreening_Resp_IB_v3  response = CASAPrimaryClientScreening_IH_v3.casaPrimaryClientScreeningBusinessAcc(acctPrimary, null, testTradingAsNameLst, null);

        System.assertNotEquals(400, response.statusCode);
        Test.stopTest();
    }

    //Primary Account
    @isTest
    static void CASARelatedPartyDualCitizenship() {
        IntegrationTestDataFactory.insertIntegrationTranslations();
        List<AccountContactRelation> acrList = new List<AccountContactRelation>();
        //insert acct;
        Account acctPrimary = new Account(Name = 'Test Primary Account');
        acctPrimary.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Prospect').getRecordTypeId();
        acctPrimary.Country_of_Incorporation__c = 'South Africa';
        acctPrimary.Client_Group__c = 'Non Individual';
        acctPrimary.CASA_Reference_Number__c = '12233';
        acctPrimary.CIF__c = '';
        acctPrimary.Countries_Traded_With__c = 'South Africa';
        acctPrimary.Source_of_Income__c = 'Donation';
        acctPrimary.Registration_Number__c = '1223333';
        acctPrimary.CASA_Screening_Date__c = System.today();
        acctPrimary.CASA_Risk_Status__c = '';
        acctPrimary.Client_Type__c = 'Non Individual';
        acctPrimary.ID_Type__c = 'Registration Number';
        insert acctPrimary;

        //insert related acct;
        List<Account> rpAccounts2 = new List<Account>();
        Account acctSecondary = new Account();
        acctSecondary.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual Prospect').getRecordTypeId();
        acctSecondary.ID_Number__pc = '6803037015089';
        acctSecondary.ID_Type__pc = 'SA Identity Document';
        acctSecondary.FirstName = 'First Name';
        acctSecondary.LastName = 'Test Last Name';
        acctSecondary.Initials__pc = 'I';
        acctSecondary.PersonTitle = 'Mr';
        acctSecondary.Client_Type__c = 'Individual Client';
        acctSecondary.Country_of_Citizenship__c = 'South Africa;United Kingdom';
        acctSecondary.PersonBirthdate = date.newInstance(1968, 03, 03);
        acctPrimary.Country_of_Incorporation__c = 'South Africa';
        rpAccounts2.add(acctSecondary);
        insert acctSecondary;

        Account acc = [SELECT PersonContactId FROM Account WHERE Id = :acctSecondary.Id];
        Id personContactId = acc.PersonContactId;
        AccountContactRelation accConRel = new AccountContactRelation(AccountId = acctPrimary.Id, ContactId = personContactId);
        insert accConRel;
        acrList.add(accConRel);

        Set<Id> relatedPartIdSet = new Set<Id>();
        for (AccountContactRelation acr : acrList) {
            relatedPartIdSet.add(acr.ContactId);
        }
        List<Account> rpAccounts = new AccountsSelector().selectCasaFieldsByPersonContactSetId(relatedPartIdSet);

        //Create Trading as Name test records
        Trading_as_Name__c testTradingAsName = new Trading_as_Name__c();
        List<Trading_as_Name__c> testTradingAsNameLst = new List<Trading_as_Name__c>();
        testTradingAsName.Name = 'T/A Test';
        testTradingAsName.Account__c = acctPrimary.id;
        testTradingAsNameLst.add(testTradingAsName);
        insert testTradingAsNameLst;

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new CASAPrimaryCliScreeV3_Mock_ApiRest(StringConstants.POSITIVE_STRING));

        /* List<Integration_API__c> apiList = new List<Integration_API__c>();
        //API (Dev)
        Integration_API__c apiDev = new Integration_API__c();
        apiDev.Name = 'API Manager';
        apiDev.Environment__c = 'Development';
        apiDev.Client_Secret__c = '*****';
        apiDev.Client_ID__c = '*****';
        //apiDev.Base_URL__c = 'https://esb.ext.api.uat.absa.co.za/enterprise-ext-uat/ext';
        apiList.add(apiDev);
        insert apiList;
        
        List<Integration_Service__c> serviceList = new List<Integration_Service__c>();
        //Service(Dev)
            Integration_Service__c serviceDev = new Integration_Service__c();
            serviceDev.Integration_API_ID__c = apiList[0].Id;
            serviceDev.Name = 'CASA Screen Related Party';
            serviceDev.Content_Type__c = 'application/json';
            serviceDev.Method__c = 'POST';
            serviceDev.URL_Extension__c = 'CASA Screen Related Party';
            serviceDev.Username__c = '*****@**********';
            serviceDev.Password__c = '****************';
            serviceList.add(serviceDev);
        
            Integration_Service__c serviceDev2 = new Integration_Service__c();
            serviceDev2.Integration_API_ID__c = apiList[0].Id;
            serviceDev2.Name = 'CASA Primary Client Screening V2';
            serviceDev2.Content_Type__c = 'application/json';
            serviceDev2.Method__c = 'POST';
            serviceDev2.URL_Extension__c = 'CASA Primary Client Screening V2';
            serviceDev2.Username__c = '*****@*********';
            serviceDev2.Password__c = '****************';
            serviceList.add(serviceDev2);
        
        insert serviceList;*/

        Account account2 = new Account(Name = 'Test Account2');
        account2.RecordTypeId = schema.SObjectType.account.getRecordTypeInfosByName().get('Business Prospect').getRecordTypeId();
        account2.Country_of_Incorporation__c = 'South Africa';
        account2.Client_Group__c = 'Non Individual';
        account2.Client_Type__c = 'Private Company';
        account2.CASA_Reference_Number__c = '12233';
        account2.CIF__c = '';
        account2.Countries_Traded_With__c = 'South Africa';
        account2.Source_of_Income__c = 'Donation';
        insert account2;
        
        FinServ__ReciprocalRole__c resRole = new FinServ__ReciprocalRole__c();
        resRole.FinServ__CreateInverseRole__c = true;
        resRole.FinServ__InverseRole__c = 'Director';
        insert resRole;

        FinServ__AccountAccountRelation__c accAccRel = new FinServ__AccountAccountRelation__c(
            FinServ__Account__c = acctPrimary.Id,
            FinServ__RelatedAccount__c = account2.Id,
            Roles__c = 'Shareholder/Controller',
            FinServ__Role__c = resRole.id,
            Primary_Entity_Id__c = acctPrimary.Id,
            Shareholding_Percentage__c = 0
        );
        insert accAccRel;        

        IntegrationTestDataFactory.insertIntegrationSettings(
            'API Manager',
            new List<String>{ 'CASA Primary Client Screening V2', 'CASA Screen Related Party V2', 'CASA Screen Related Party' }
        );

        Test.startTest();

        String countryIncorporationTranslated = 'SO003';
        String clientTypeGrpTranslated = 'N';
        CASAPrimaryClientScreening_IU_v3.mapRequestFields(acctPrimary, countryIncorporationTranslated, clientTypeGrpTranslated, '05');

        CASAPrimaryClientScreening_IH_v3.casaPrimaryClientScreeningBusinessAcc(acctPrimary, rpAccounts, testTradingAsNameLst, new List<Account> {account2});

        List<Account> relparty = new List<Account>();

        CASAPrimaryClientScreening_IH_v3.casaPrimaryClientScreeningBusinessAcc(acctSecondary, relparty, testTradingAsNameLst, new List<Account> {account2});

        CASAPrimaryClientScreening_Resp_IB_v3 responseBean = CASAPrimaryClientScreening_Resp_IB_v3.dummyResponse();
        System.assertEquals(200, responseBean.statusCode);

        Test.stopTest();
    }
}