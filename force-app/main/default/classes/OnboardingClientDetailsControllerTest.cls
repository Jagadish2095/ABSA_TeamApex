/*
Controller Test Class For OnboardingClientDetailsController class
*
* @author  Manoj Danthala : Absa 
* @version v1.0
* @since   2020-02-06
* @Last modified   2021-11-09
*/

@isTest
public class OnboardingClientDetailsControllerTest {

    @testSetup
    static void dataCreation(){
        Account account = new Account(Name = 'Test Account');
        account.UBO_ParentAccountWrapper__c = '[{"Type":"PrivateCompany","ShareholderCount":4,"Shareholder":"LONDANICOAL(PTY)LTD","recordId":"0015r00000HvTN3AAN","ParentShareholding":100,"Controllinginterest":100,"Accwrplist":[{"UBO":"","Type":"CentralBankorRegulator","ShareholderCount":3,"Shareholder":"PINEAPPLECENTRALBANKANDREG","roles":"Director;IndividualwithAuthoritytoAct;Shareholder/Controller","relatedAccountId":"0015r00000HJk9qAAD","recordId":"a005r000001uMlTAAU","primaryEntityId":"0015r00000HvTN3AAN","ParentShareholding":20.00,"parentAccountId":"0015r00000HvTN3AAN","idType":"RegistrationNumber","Controllinginterest":20.00,"childwrplist":[{"UBO":"Yes","Type":"Individual","ShareholderCount":0,"Shareholder":"FANTAFANTA","roles":"Director;Shareholder/Controller;ContactPerson","relatedAccountId":"0035r00000EccagAAB","recordId":"07k5r000004DDDBAA4","primaryEntityId":"0015r00000HJk9qAAD","ParentShareholding":60.00,"parentAccountId":"0015r00000HJk9qAAD","idType":"SAIdentityDocument","Controllinginterest":12.00,"childwrplist":null,"accType":"AccountContact"}],"accType":"AccountAccount"}],"accType":"Account"}]';
        insert account;

        Contact contact = new Contact(LastName='Test contact', AccountId = account.Id, Email = 'agents@support.co.za');
        insert contact;

        Pricebook2 pb = new Pricebook2();
        pb.IsActive=true;
        pb.id =test.getStandardPricebookId();
        update pb;

        //Insert Integration Translation
        Integration_Translation__c translation = new Integration_Translation__c();
        translation.Direction__c = 'Outbound';
        translation.System_Name__c = 'eCASA';
        translation.Internal_Value__c = 'Private Company';
        translation.External_Value__c = '07';
        translation.Value_Type__c = 'Client Type';
        translation.Name =  'Private Company';
        insert translation;
    }

    @isTest
    public static void callGetLoggedInUserDetails(){

        Test.startTest();
        OnboardingClientDetailsController.getLoggedInUserDetails();
        OnboardingClientDetailsController.getloggedinUserProfileName();
        OnboardingClientDetailsController.getEntitiesMapping();
        System.assertNotEquals(OnboardingClientDetailsController.getLoggedInUserDetails(), null , 'Error');
        Test.stopTest();
    }

    @isTest
    public static void callExperianService(){
        // Set mock callout class4
         try{
        Test.setMock(HttpCalloutMock.class, Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(StringConstants.POSITIVE_STRING, ExperianBusinessDetailsGet_IH_v1_Test.STATIC_RESOURCE_NAME_MOCK_POSITIVE));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String> {ExperianBusinessDetailsGet_IH_v1.INTEGRATION_SERVICE_NAME});
        Test.startTest();
            String respStr = OnboardingClientDetailsController.callExperianHandler('197101150307');
            System.assertNotEquals(null, respStr);

             Account acc = OnboardingClientDetailsController.CreateBusinessProspect(respStr, null,'', '', '',false,false);
            System.assertNotEquals(null, acc);
            System.assertNotEquals(0, [select count() from address__c where account__c=:acc.Id]);
             OnboardingClientDetailsController.getAccountRecordTypeId('Prospect');
             Test.stopTest();
        } catch (Exception ex) {
             String str = ex.getMessage();
        }


    }

    @isTest
    public static void callCreateOnboardingOpportunity(){
        Test.startTest();
            Account account = new Account();
            Account.Name='Test Account';
            insert account;

        Product2 prod = new Product2(
            Name = 'SPM Equity Product',
            ProductCode = '1122',
            isActive = true
        );
        insert prod;
        //Setting Up sales Process Type for credit
        Sales_Process_Type__c salesProcessType = new Sales_Process_Type__c(
            Name = 'New Credit Product (Business Banking)',
            Sales_Process__c = 'Credit Onboarding',
            Opportunity_Record_Type__c = 'Credit Onboarding',
            Request_Name__c = 'New Credit Product (Business Banking)');
        insert salesProcessType;

                //[SELECT Id FROM Account where Name = 'Test Account' LIMIT 1];
                try{
                    String oppId = OnboardingClientDetailsController.CreateOnboardingOpportunity(account.Id,'Existing Customer');
                    OnboardingClientDetailsController.updateDocumentPlaceholders(account.Id, oppId);
                    System.assertNotEquals(null, oppId);
                }catch(exception e){
                    string msg = '';
                }
            
        try{
        OnboardingClientDetailsController.createSPMOnboardingOpportunity(account.Id,'');
        }catch(exception e){
            string msg ='';
        }
        OnboardingClientDetailsController.CreateCreditOnboardingOpportunity(account.Id,'Lite Onboarding');
        OnboardingClientDetailsController.CreateCAFOnboardingOpportunity(account.Id,'Lite Onboarding');
        OnboardingClientDetailsController.CreateCPFOnboardingOpportunity(account.Id);
        OnboardingClientDetailsController.getPortfolioManagerlist();


           
        Test.stopTest();
    }

    /* Prashant Jain and Tinashe Shoko: 20200312: New test method for Merchant Onboarding */
    @isTest
    public static void callCreateMerchantOnboardingOpportunity(){
        Test.startTest();
        Account account = [SELECT Id FROM Account where Name = 'Test Account' LIMIT 1];
        String oppId = OnboardingClientDetailsController.CreateMerchantOnboardingOpportunity(account.Id);

        Account newAccount = new Account();
        newAccount.Name = 'Test';
        String accId = OnboardingClientDetailsController.createBusinessProspectLimitedData(newAccount,false,'',false);
        System.assertNotEquals(null, oppId);
        Test.stopTest();
    }

    @isTest
    public static void callgetselectOptions(){
        Account account = new Account(Name = 'Test Account');
        System.assertNotEquals(null, account);
        Test.startTest();
        OnboardingClientDetailsController.getselectOptions(account, 'Countries_Traded_With__c');
        Test.stopTest();
    }

    @isTest
    public static void callValidateRelatedPartiesPositive(){
        Account account = [SELECT Id FROM Account where Name = 'Test Account' LIMIT 1];
        AccountContactRelation acr = [SELECT Id, Roles FROM AccountContactRelation WHERE AccountId =: account.Id];
        acr.Roles = 'Business User;Decision Maker;Director;Economic Buyer;Economic Decision Maker;Evaluator;Executive Sponsor;Individual with Authority to Act;Influencer;Managing Director/Chief Executive Officer;Other;Shareholder/Controller;Technical Buyer';
        update acr;
        System.assertNotEquals(null, acr);
        Test.startTest();
        String errorText = OnboardingClientDetailsController.validateRelatedParties(account.Id,'','Private Company');
        Test.stopTest();
    }

    @isTest
    public static void callValidateRelatedPartiesNegative(){
        Account account = [SELECT Id FROM Account where Name = 'Test Account' LIMIT 1];
        AccountContactRelation acr = [SELECT Id, Roles FROM AccountContactRelation WHERE AccountId =: account.Id];
        acr.Roles = 'Business User';
        update acr;
        System.assertNotEquals(null, acr);
        Test.startTest();
        String errorText = OnboardingClientDetailsController.validateRelatedParties(account.Id,'','Private Company');
        Test.stopTest();
    }

    /* Updating Process Type of Lite Opportunity - 6097 - Trigger Full Client On-boarding Prior Fulfilment
    * @param: Opportunity Id
    * @return: true
    * Manoj - 11/03/2020
    * */
    @isTest
    public static void callupdateLiteOpportunity(){
        Account account = [SELECT Id FROM Account where Name = 'Test Account' LIMIT 1];
        Opportunity testOpp = new Opportunity();
        testOpp.Name = 'Test Opp';
        testOpp.CloseDate = Date.today();
        testOpp.StageName = 'Drafting';
        testOpp.AccountId = account.Id;
        insert testOpp;

        Test.startTest();
            boolean result = OnboardingClientDetailsController.updateLiteOpportunity(testOpp.Id);
            System.assertEquals(result, true);
            Account acc = OnboardingClientDetailsController.getAccountId(testOpp.Id);
            System.assertNotEquals(acc, null);
        Test.stopTest();
    }
    /* Updating Process Type of Lite Opportunity - 6097 - Trigger Full Client On-boarding Prior Fulfilment
    * @param: Opportunity Id
    * @return: true
    * Manoj - 11/03/2020
    * */
    @isTest
    public static void callgetAccountId(){
        Account acctSecondary = new Account();
        acctSecondary.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual Prospect').getRecordTypeId();
        acctSecondary.ID_Number__pc = '6803037015089';
        acctSecondary.ID_Type__pc = 'SA Identity Document';
        acctSecondary.FirstName = 'First Name';
        acctSecondary.LastName = 'Test Last Name';
        acctSecondary.Initials__pc = 'I';
        acctSecondary.PersonTitle = 'Mr';
        acctSecondary.Client_Type__c = 'Individual Client';
        acctSecondary.ID_Number__pc='6211275132089';
        acctSecondary.Country_of_Citizenship__c =  'South Africa';
        acctSecondary.PersonBirthdate = Date.valueOf('1962-11-27');
        acctSecondary.Date_Issued__pc = Date.valueOf('1962-11-27');
        acctSecondary.Gender__pc = 'Male';

        insert acctSecondary;
        /*Opportunity testOpp = new Opportunity();
        testOpp.Name = 'Test Opp';
        testOpp.CloseDate = Date.today();
        testOpp.StageName = 'Drafting';
        testOpp.AccountId = account.Id;
        insert testOpp;*/
        System.assertNotEquals(acctSecondary, null);
        Test.startTest();
       // try{
            //OnboardingClientDetailsController.clientdetails(acctSecondary.Id);
        //}catch(Exception e){
            //System.debug(ex);
        //}
            //Account acc = OnboardingClientDetailsController.getAccountId(account.Id);
            //System.assertNotEquals(acc, null);
        Test.stopTest();
    }
        @isTest
    static void TestUpdatedAccountTest(){
        Test.setMock(HttpCalloutMock.class, new ciupdateAccountUpdateMock_ApiRest(StringConstants.POSITIVE_STRING));

         String clientAccountId; //= '0010E00000uP3C2QAK';
        //AddressesSelector addrSelector = new AddressesSelector();
        //List<Address__c> addressList = addrSelector.addressesRelatedToAcc(clientAccountId);

     Account acc = new Account();
     acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual Prospect').getRecordTypeId();
     acc.CIF__c= 'ZUMA123';
     acc.PersonMobilePhone= '0478956208';
     acc.Initials__pc= 'S';
     acc.PersonTitle= 'Mr';
     acc.LastName= 'Mathe';
     acc.BillingStreet= '15 Johhanesburg';
     acc.BillingCity= 'Sandton';
     acc.BillingPostalCode= '2001';
     acc.ID_Type__pc= 'SA Identity Document';
     acc.ID_Number__pc= '9202031586089';
     acc.PersonBirthdate = Date.newInstance(1992, 2, 3);
     acc.Client_Type__c= 'Trusts';
     acc.Gender__pc= 'Male';
     acc.Number_Of_Dependents__c = 2.00;
     acc.Occupation_Category__pc= 'Actuary';
     acc.Client_ever_been_declared_Insolvent__c = false;
     acc.Marital_Contract_Type__pc= 'In Community Of Property';
     acc.Home_Language__pc= 'English';
     acc.Income_Tax_Number__pc = '1.00';
     acc.FirstName= 'ABSA';
     acc.Occupation_Status__pc= 'Full Time Employed';
     acc.PersonEmail= 'test@test.com';
     acc.Preferred_Communication_Method__pc= 'Email';
     acc.Sic= '0000';
     acc.Client_Group__c = 'Non Individual';
     acc.Client_Type__c ='Sole Trader';
     acc.Client_Group__c ='SOLE TRADER CLIENT';
     acc.Source_of_Income__c = 'Commission';
     acc.Date_Identified__c  = Date.newInstance(2020, 12, 9);
     acc.Nationality__pc= 'South Africa';
     acc.Q4a_Client_affected_by_Regulation_3_1_F__c = false;
     acc.Date_Issued__pc  = Date.newInstance(2016, 11, 9);
     acc.CASA_Reference_Number__pc= '7877';
     acc.Marital_Status__pc= 'Married';
     acc.Communication_Language__pc= 'English';
     acc.Monthly_Income__pc= 'R15000 - 19999';

     insert acc;

        String clientAccId = [Select Id from Account where Id =: acc.Id LIMIT 1].Id;
        String OppId = ' ';


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
        acctSecondary.ID_Number__pc='6211275132089';
        acctSecondary.Country_of_Citizenship__c =  'South Africa';
        acctSecondary.PersonBirthdate = Date.valueOf('1962-11-27');
        acctSecondary.Gender__pc = 'Male';

        insert acctSecondary;
        Account account1 = [SELECT PersonContactId FROM Account WHERE Id =: acctSecondary.Id];
        Id personContactId = account1.PersonContactId;
        AccountContactRelation accConRel = new AccountContactRelation(AccountId = acc.Id, ContactId = personContactId,Roles = 'Director;Shareholder/Controller;Individual with Authority to Act;Managing Director/Chief Executive Officer');
        insert accConRel;



        Account account = new Account();
        account.Name = 'Test Account';
        account.Client_Group__c = 'SOLE TRADER CLIENT';
        insert account;

        Contact contact = New Contact();

        contact.AccountId           = account.Id;
        contact.FirstName           = 'testName';
        contact.LastName            = 'testSurname';
        contact.Email               = 'ActiveEmail@gmail.com';
        contact.Phone                       = '0761116754';
        contact.Communication_Language__c   = 'English';
        insert contact;

        Opportunity testOpp = new Opportunity();
        testOpp.Name = 'Test Opp Onboarding';
        testOpp.CloseDate = Date.today();
        testOpp.StageName = 'New';
        testOpp.AccountId = account.Id;
        insert testOpp;


        Integration_API__c api = new Integration_API__c();
        api.Name = 'ciupdatexx';
        api.Environment__c = 'UAT';
        api.Base_URL__c = 'https://testme/';
        api.Client_ID__c = '89797897987';
        api.Client_Secret__c = '789798';
        insert api;

        Integration_API__c api2 = new Integration_API__c();
        api2.Name = 'ciupdatexx';
        api2.Environment__c = 'Production';
        api2.Base_URL__c = 'https://testme/';
        api2.Client_ID__c = '89797897987';
        api2.Client_Secret__c = '789798';
        insert api2;

        Integration_Service__c intsrv = new Integration_Service__c();
        intsrv.Integration_API_ID__c = api.Id;
        intsrv.Name = 'ciupdateclientdetailv12';
        intsrv.Method__c = 'POST';
        intsrv.URL_Extension__c = 'ciupdate';
        intsrv.Username__c = 'abc';
        intsrv.Password__c = 'zyx';
        intsrv.Content_Type__c = 'application/json';
        insert intsrv;

        Integration_Service__c intsrv2 = new Integration_Service__c();
        intsrv2.Integration_API_ID__c = api2.Id;
        intsrv2.Name = 'ciupdateclientdetailv12';
        intsrv2.Method__c = 'POST';
        intsrv2.URL_Extension__c = 'ciupdate';
        intsrv2.Username__c = 'abc';
        intsrv2.Password__c = 'zyx';
        intsrv2.Content_Type__c = 'application/json';
        insert intsrv2;


        System.assertNotEquals(intsrv2, null);

        Test.startTest();

        String getAccount = productOnboardingController.getAccountByOppId(testOpp.Id);

        OnboardingClientDetailsController.getRelatedParties(testOpp.Id);


        Test.setMock(HttpCalloutMock.class, new GetClientDetailsCIFMock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.GET_CLIENT_DETAILS});

       // OnboardingClientDetailsController.clientdetails(acc.Id);
        //ciupdateclientdetailV12_Resp_IB_v1 responseBean = OnboardingClientDetailsController.clientdetails(clientAccId);
        test.stopTest();
    }

        @isTest
static void updateCertDocsTest(){   

    Account acctPrimary = new Account(Name = 'Test Primary Account');    
    insert acctPrimary;
    
    Opportunity testOpp = new Opportunity();
        testOpp.Name = 'Test Opp';
        testOpp.CloseDate = Date.today();
        testOpp.StageName = 'Drafting';
        testOpp.accountId = acctPrimary.Id;
        insert testOpp;
        
        Test.startTest();
    OnboardingClientDetailsController.updateCertDocs(acctPrimary.Id,testOpp.Id);
    System.assertNotEquals(null, testOpp);
    Test.stopTest();
    }
    
}