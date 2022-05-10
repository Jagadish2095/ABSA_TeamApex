@isTest(SeeAllData = false)
public with sharing class CreditCardCustomerDetailsControllerTest {
    @TestSetup
    public static void makeData() {
        User adminUser = new User();
		String uniqueUserName = 'UserAdmin' + DateTime.now().getTime() + '@testorg.com';
		String email = 'UserAdmin@testorg.com';
		Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator (Custom)'];
		adminUser = new User(
			Alias = 'standt',
			Email = email,
			EmailEncodingKey = 'UTF-8',
			LastName = 'UserAdmin',
			LanguageLocaleKey = 'en_US',
			LocaleSidKey = 'en_US',
			ProfileId = p.Id,
			TimeZoneSidKey = 'Africa/Johannesburg',
			UserName = uniqueUserName,
			MobilePhone = '0823389021'
		);
		insert adminUser;
        System.runAs(adminUser) {
            Map<String, Schema.RecordTypeInfo> AccountRecordTypeMap = Account.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
			Map<String, Schema.RecordTypeInfo> ContactRecordTypeMap = Contact.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
			List<Account> accList = new List<Account>();
			Account  individualAccount = new Account();
			individualAccount.RecordTypeId = AccountRecordTypeMap.get('Individual_Client').getRecordTypeId();
			individualAccount.Client_Type__c = null;
			individualAccount.PersonTitle = 'Mr.';
			individualAccount.Initials__pc = 'T';
			individualAccount.FirstName = 'Tony';
			individualAccount.LastName = 'Stark';
			individualAccount.Gender__pc = 'Male';
			individualAccount.PersonBirthdate = Date.valueOf('1981-07-11');
			individualAccount.ID_Number__pc = '8701057648086'; //'8107115017084';
			individualAccount.ID_Type__pc = 'SA Identity Document';
			individualAccount.PersonEmail = 'test@test.co.za';
			individualAccount.Alternative_Email__c = 'test@test.com';
			individualAccount.Phone = '0114453322';
			individualAccount.PersonMobilePhone = '0747003747';
			individualAccount.Non_Credit_Marketing_Consent__pc = 'Yes';
			individualAccount.Credit_Marketing_Consent__pc = 'Yes';
			individualAccount.Non_Credit_Marketing_Indicator__pc = 'Email;SMS';
			individualAccount.Credit_Marketing_Indicator__pc = 'Email;SMS';
			accList.add(individualAccount);
            insert accList;

            Opportunity opportunity = new Opportunity(Name = 'Tony Opportunity', AccountId = accList[0].Id, StageName = 'Won', CloseDate = system.today());
            insert opportunity;

            Application__c application = new Application__c();
            application.Account__c = accList[0].id;
            application.Account_Access__c = 'Cellphone';
            application.Surplus_Cash__c = 'Fixed Deposits';
            application.Borrowing_Requiment_General__c = 'Credit Card';
            application.Protection_Of_Services__c = 'Retirement';
            application.Title__c = 'dd';
            application.FirstNameSignature__c = 'Litha';
            application.SurnameSignature__c = 'Nosekeleza';
            application.Signing_Date__c = System.today();
            application.Stock_Number__c = '';
            insert application;
        }
    }

    @isTest
    public static void retriveAccountsByIdTest() {
        // List<Account> accounts = [SELECT Id, Id_Number__pc FROM Account WHERE FirstName = 'Tony'];
        List<Opportunity> opportunities = [SELECT Id, AccountId, Account.Id_Number__pc FROM Opportunity WHERE Name = 'Tony Opportunity'];
        Test.startTest();
        CreditCardCustomerDetailsController.retriveAccountsById(opportunities[0].AccountId);
        CreditCardCustomerDetailsController.getAccountByIdNumber(opportunities[0].Id, opportunities[0].Account.Id_Number__pc);
        CreditCardCustomerDetailsController.getCPBInfoById(opportunities[0].AccountId);
        //CreditCardCustomerDetailsController.updateClientCIF(opportunities[0].AccountId);
        CreditCardCustomerDetailsController.getPicklistByObject('Account', 'Gender__pc');
        Test.stopTest();
        System.assertNotEquals(0, [SELECT Id FROM Account WHERE FirstName = 'Tony'].Size());
    }

    @isTest
    public static void getMDMClientDetailsBeanTest() {
        List<Account> accounts = [SELECT Id, Id_Number__pc FROM Account WHERE FirstName = 'Tony'];
        String responseStr = '';
        Test.startTest();
        responseStr = CreditCardCustomerDetailsController.getMDMClientDetailsBean('ID Number', accounts[0].Id_Number__pc);
        //CreditCardCustomerDetailsController.getMDMClientDetailsBean('CIF No','AKHILAM001');
        Test.stopTest();
        System.assertNotEquals('', responseStr);
    }

    @isTest
    public static void getClientDetailsBeanTest() {
        List<Account> accounts = [SELECT Id, Id_Number__pc FROM Account WHERE FirstName = 'Tony'];
        String responseStr = '';
        Test.startTest();
        responseStr = CreditCardCustomerDetailsController.getClientDetailsBean('ID Number', accounts[0].Id_Number__pc);
        //CreditCardCustomerDetailsController.getClientDetailsBean('CIF No','AKHILAM001');
        Test.stopTest();
        System.assertNotEquals('', responseStr);
    }

    @isTest
    public static void getGIResponseAccountTest() {
        List<Account> accounts = [SELECT Id, Id_Number__pc FROM Account WHERE FirstName = 'Tony'];
        List<Account> accountRec = new List<Account>();
        Test.startTest();
        accountRec = CreditCardCustomerDetailsController.getGIResponseAccount('ID Number', accounts[0].Id_Number__pc);
        Test.stopTest();
    }

    @isTest
    public static void updateCustomerDetailsTest() {
        List<Account> accounts = [SELECT Id, Id_Number__pc FROM Account WHERE FirstName = 'Tony'];
        List<Account> accountRec = new List<Account>();
        String modifiedData = '{"identityInformation":{"personTitle":"Mr.","firstName":"XI","idNumber":"8305025256087","genderValue":"Male","nationality":"South Africa","countryOfResidence":"South Africa","initials":"X","lastName":"JINPING","personBirthDate":"1986-01-30","idType":"","countryOfBirth":"South Africa"},"residentialInformation":{},"contactInformation":{"personEmail":"muvhuso.nekhubvi@absa.africa","personMobilePhone":"0715333844"},"nextKinInformation":{},"maritalInformation":{"maritalStatus":"Single"},"personalInformation":{"homeLanguage":"English","communicationLanguage":"English","communicationChannel":"Phone"}}';
        Test.startTest();
        accountRec = CreditCardCustomerDetailsController.updateCustomerDetails(accounts[0].Id, modifiedData, '102204201549099886');
        Test.stopTest();
        System.assertEquals('XI', accountRec[0].FirstName);
    }
}