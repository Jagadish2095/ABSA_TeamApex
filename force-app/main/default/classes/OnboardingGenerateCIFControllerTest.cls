/**
* @description Test class for OnboardingGenerateCIFController
*
* @author  Tracy de Bruin : Cloudsmiths
* @version Unkown 
* @since   Unkown
*
*/

@isTest
private class OnboardingGenerateCIFControllerTest {

    @isTest 
    public static void callScreening(){ 
        
        Test.setMock(HttpCalloutMock.class, new CreateClientCIFMock_ApiRest(StringConstants.POSITIVE_STRING, StringConstants.POSITIVE_STRING, StringConstants.POSITIVE_STRING,null));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.VALIDATE_CLIENT_DETAILS, StringConstants.VALIDATE_ADDRESS,StringConstants.CREATE_CLIENT_CIF});
        IntegrationTestDataFactory.insertIntegrationTranslations();     
       
        
         // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CvsValidationServiceMock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.VALIDATE_CLIENT_DETAILS});
        
         Account account = new Account(Name = 'Test Account');
         account.RecordTypeId = schema.SObjectType.account.getRecordTypeInfosByName().get('Business Prospect').getRecordTypeId();
        //W-005355 : Anka Ganta : 2020-07-09
        account.Country_of_Incorporation__c='South Africa';
        account.Client_Group__c = 'Non Individual';
        account.CASA_Reference_Number__c = '12233';
        account.CASA_Screening_Status__c = 'Cancelled';
        account.CIF__c = '12345';
        account.Countries_Traded_With__c = 'South Africa';
        account.Source_of_Income__c = 'Donation';
        insert account;
        
        
         //insert related acct;
         List<AccountContactRelation> acrList = new List<AccountContactRelation>();
        Account acctSecondary = new Account();
        acctSecondary.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual Prospect').getRecordTypeId();
        acctSecondary.ID_Number__pc = '6803037015089';
        acctSecondary.ID_Type__pc = 'SA Identity Document';
        acctSecondary.FirstName = 'First Name';
        acctSecondary.LastName = 'Test Last Name';
        acctSecondary.Initials__pc = 'I';
        acctSecondary.PersonTitle = 'Mr';
        acctSecondary.Client_Type__c = 'Individual Client';
        acctSecondary.CASA_Reference_Number__pc = '12454' ;
        acctSecondary.CASA_Screening_Status__pc = 'Matched';
        insert acctSecondary;        
        Account acc = [SELECT PersonContactId FROM Account WHERE Id =: acctSecondary.Id];
        Id personContactId = acc.PersonContactId;
        AccountContactRelation accConRel = new AccountContactRelation(AccountId = account.Id, ContactId = personContactId);
        insert accConRel;
        acrList.add(accConRel);

        System.debug('** acrList: ' + acrList.size());
        
        Set<Id> relatedPartIdSet = new Set<Id>();
        for(AccountContactRelation acr : acrList){
            relatedPartIdSet.add(acr.ContactId);
        }
       List<Account> rpAccounts = new AccountsSelector().selectCasaFieldsByPersonContactSetId(relatedPartIdSet);
       
       System.debug('rpAccounts++'+rpAccounts);
       
       
        
        Opportunity testOpp = new Opportunity();
        testOpp.Name = 'Test Opp';
        testOpp.CloseDate = Date.today();
        testOpp.StageName = 'Drafting';
        testOpp.accountId = account.Id;
        insert testOpp;
        
         Product2 prod = new Product2(Name = 'Cheque Product', Family = 'Cheque',ProductCode = '1234' );
         
        insert prod;
        
        System.debug('prod'+prod.Id);
        
         Pricebook2 standardPriceBook = WillsTestDataFactory.getStandardPriceBook();
         PricebookEntry pricebookEntry = WillsTestDataFactory.createPriceBookEntry(standardPriceBook.Id, prod.Id);
        
        OpportunityLineItem oli = new OpportunityLineItem();
        oli.OpportunityId = testOpp.Id;
        if(prod.Id != null) {
        oli.Product2Id = prod.Id;
        }
        oli.PriceBookEntryid = pricebookEntry.Id;
        oli.Quantity = 1;
        oli.TotalPrice = 100;
        insert oli;
        
        Test.startTest();
            OnboardingGenerateCIFController.getAccountData(testOpp.Id);
            OnboardingGenerateCIFController.getOpportunityData(testOpp.Id);
            OnboardingGenerateCIFController.getAccountRecordType(testOpp.Id);
            OnboardingGenerateCIFController.getPartcicpantAccountData(testOpp.Id);
            OnboardingGenerateCIFController.CheckRelatedPartyCasaStatus(testOpp.Id);
            system.assertEquals(testOpp.CASA_Screening_Date__c,null);
            
        Test.stopTest();
        
     }
    
   @isTest 
    public static void callScreening1(){
        
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CASAPrimaryClientScreeningMock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationTranslations();
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.CASA_PRIMARY_CLIENT_SCREENING, StringConstants.CASA_PRIMARY_CLIENT_SCREENING_V2});
        
        
         Account account = new Account(FirstName = 'Test Account',LastName = 'test');
         account.RecordTypeId = schema.SObjectType.account.getRecordTypeInfosByName().get('Individual Client').getRecordTypeId();
         account.PersonTitle = 'Mr.';
        insert account;
        
        Opportunity testOpp = new Opportunity();
        testOpp.Name = 'Test Opp';
        testOpp.CloseDate = Date.today();
        testOpp.StageName = 'Drafting';
        testOpp.accountId = account.Id;
        insert testOpp;
        
         Product2 prod = new Product2(Name = 'Cheque Product', Family = 'Cheque',ProductCode = '1234' );
         
        insert prod;
        
        System.debug('prod'+prod.Id);
        
         Pricebook2 standardPriceBook = WillsTestDataFactory.getStandardPriceBook();
         PricebookEntry pricebookEntry = WillsTestDataFactory.createPriceBookEntry(standardPriceBook.Id, prod.Id);
        
        OpportunityLineItem oli = new OpportunityLineItem();
        oli.OpportunityId = testOpp.Id;
        if(prod.Id != null) {
        oli.Product2Id = prod.Id;
        }
        oli.PriceBookEntryid = pricebookEntry.Id;
        oli.Quantity = 1;
        oli.TotalPrice = 100;
        insert oli;
        
        //Create Trading as Name test records
        Trading_as_Name__c testTradingAsName = new Trading_as_Name__c();
        testTradingAsName.Name = 'T/A Test';
        testTradingAsName.Account__c = testDataFactory.testAccount.id;
        testTradingAsName.CASA_Screening_Status__c = 'Pending';
        insert testTradingAsName;
        
        Test.startTest();
            OnboardingGenerateCIFController.getAccountData(testOpp.Id);
            OnboardingGenerateCIFController.getAccountRecordType(testOpp.Id);
             OnboardingGenerateCIFController.callToCreateCIF(testOpp.Id, 'Prospect');
         OnboardingGenerateCIFController.getTradingAsNameData(testOpp.Id);
         system.assertEquals(testOpp.CASA_Screening_Date__c,null);
        Test.stopTest();
    }

    @isTest 
    public static void testCreatecif(){  
        //Set Mock
        test.setMock(HttpCalloutMock.class, new ciupdateAccountUpdateMock_ApiRest(StringConstants.POSITIVE_STRING));
         //Insert Integration Settings
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.ACCOUNT_VERIFICATION_DETAILS});
        IntegrationTestDataFactory.insertIntegrationTranslations();
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        Test.setMock(HttpCalloutMock.class, new GetClientDetailsCIFMock_ApiRest(StringConstants.POSITIVE_STRING)); 
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.GET_CLIENT_DETAILS});
        
       Test.setMock(HttpCalloutMock.class, new CreateClientCIFMock_ApiRest(StringConstants.POSITIVE_STRING, StringConstants.POSITIVE_STRING, StringConstants.POSITIVE_STRING,null));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.VALIDATE_CLIENT_DETAILS, StringConstants.VALIDATE_ADDRESS,StringConstants.CREATE_CLIENT_CIF});
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, new list<String> {'ciupdateclientdetailv12'});
        IntegrationTestDataFactory.insertIntegrationTranslations();  
        Account account = new Account(Name = 'Test Account');
         account.RecordTypeId = schema.SObjectType.account.getRecordTypeInfosByName().get('Business Prospect').getRecordTypeId();
        //W-005355 : Anka Ganta : 2020-07-09
        account.Country_of_Incorporation__c='South Africa';
        account.Client_Group__c = 'Non Individual';
        account.CASA_Reference_Number__c = '12233';
        account.CIF__c = '';
        account.Countries_Traded_With__c = 'South Africa';
        account.Source_of_Income__c = 'Donation';
        insert account;
         Opportunity testOpp = new Opportunity();
        testOpp.Name = 'Test Opp';
        testOpp.CloseDate = Date.today();
        testOpp.StageName = 'Drafting';
        testOpp.accountId = account.Id;
        testOpp.Process_Type__c = 'Remediate Existing Customer';
        insert testOpp;
        Test.startTest();
        OnboardingGenerateCIFController.callToCreateCIF(testOpp.Id, 'Individual Prospect');
            OnboardingGenerateCIFController.cifwrappercls cifbean = new OnboardingGenerateCIFController.cifwrappercls();
            cifbean.cifoutput = 'test';
            cifbean.cifoutputerror = 'test';
            cifbean.errorObjMsg = 'test';
            list<String> errormsglistbean = new list<String> {'test1','test2'};
            cifbean.errormsglist = errormsglistbean;
        
        OnboardingGenerateCIFController.updateClientDetailsCIF(testOpp.Id, 'Individual Prospect');
        OnboardingGenerateCIFController.updateCIFRemediate(testOpp.Id,'Individual Prospect');
        system.assertNotEquals(testOpp.CIF__c,null);
        Test.stopTest();
    }

    @isTest 
    public static void confirmDocumentReceiptTest(){
                WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        Generatedocumentsv7_Req_IB_v1.createDummyRequest();
 
         
        Test.setMock(HttpCalloutMock.class, new Generatedocumentsv7_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT, new list<String> {'Jitterbit Auth Path'});
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, new list<String> {StringConstants.Generatedocumentsv7_STRING});
        Integration_API__c apiIntRec =Sys_Utilities_Integration.getIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, Sys_Utilities_General.getEnvironment(), StringConstants.Generatedocumentsv7_STRING);
        system.debug('********apiIntRec**********'+apiIntRec);
        system.assertNotEquals(apiIntRec,null);
        
       
        Account testAccount= new Account();
        testAccount.Name = 'Test Name';
        //W-005355 : Anka Ganta : 2020-07-09
        testAccount.Country_of_Incorporation__c ='South Africa';
        testAccount.Client_Group__c = 'Non Individual';
        testAccount.CASA_Reference_Number__c = '12233';
        testAccount.CIF__c = '';
        testAccount.Countries_Traded_With__c = 'South Africa';
        testAccount.Source_of_Income__c = 'Donation';
        insert testAccount;
         Opportunity testOpp = new Opportunity();
        testOpp.Name = 'Test Opp';
        testOpp.CloseDate = Date.today();
        testOpp.StageName = 'Drafting';
        testOpp.accountId = testAccount.Id;
        insert testOpp;
        Test.startTest();
        OnboardingGenerateCIFController.confirmDocumentReceipt(testOpp.Id);
        Test.stopTest();
    }
    
    @isTest 
    public static void confirmDocumentReceiptTestNeg(){
                WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        Generatedocumentsv7_Req_IB_v1.createDummyRequest();
 
         
        Test.setMock(HttpCalloutMock.class, new Generatedocumentsv7_ApiRest(StringConstants.POSITIVE_STRING, '0','0'));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT, new list<String> {'Jitterbit Auth Path'});
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, new list<String> {StringConstants.Generatedocumentsv7_STRING});
        Integration_API__c apiIntRec =Sys_Utilities_Integration.getIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, Sys_Utilities_General.getEnvironment(), StringConstants.Generatedocumentsv7_STRING);
        system.debug('********apiIntRec**********'+apiIntRec);
        system.assertNotEquals(apiIntRec,null);
        
       
        Account testAccount= new Account();
        testAccount.Name = 'Test Name';
        //W-005355 : Anka Ganta : 2020-07-09
        testAccount.Country_of_Incorporation__c='South Africa';
        testAccount.Client_Group__c = 'Non Individual';
        testAccount.CASA_Reference_Number__c = '12233';
        testAccount.CIF__c = '';
        testAccount.Countries_Traded_With__c = 'South Africa';
        testAccount.Source_of_Income__c = 'Donation';
        insert testAccount;
          Opportunity testOpp = new Opportunity();
        testOpp.Name = 'Test Opp';
        testOpp.CloseDate = Date.today();
        testOpp.StageName = 'Drafting';
        testOpp.accountId = testAccount.Id;
        insert testOpp;
        Test.startTest();
        OnboardingGenerateCIFController.confirmDocumentReceipt(testOpp.Id);
    }
    
    @isTest 
    public static void confirmDocumentReceiptTestNeg2(){
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        Generatedocumentsv7_Req_IB_v1.createDummyRequest();
        
        Test.setMock(HttpCalloutMock.class, new Generatedocumentsv7_ApiRest(StringConstants.POSITIVE_STRING, '2','0'));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT, new list<String> {'Jitterbit Auth Path'});
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, new list<String> {StringConstants.Generatedocumentsv7_STRING});
        Integration_API__c apiIntRec =Sys_Utilities_Integration.getIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, Sys_Utilities_General.getEnvironment(), StringConstants.Generatedocumentsv7_STRING);
        system.debug('********apiIntRec**********'+apiIntRec);
        system.assertNotEquals(apiIntRec,null);
        
        Account testAccount= new Account();
        testAccount.Name = 'Test Name';
        //W-005355 : Anka Ganta : 2020-07-09
        testAccount.Country_of_Incorporation__c='South Africa';
        testAccount.Client_Group__c = 'Non Individual';
        testAccount.CASA_Reference_Number__c = '12233';
        testAccount.CIF__c = '';
        testAccount.Countries_Traded_With__c = 'South Africa';
        testAccount.Source_of_Income__c = 'Donation';
        insert testAccount;
        Opportunity testOpp = new Opportunity();
        testOpp.Name = 'Test Opp';
        testOpp.CloseDate = Date.today();
        testOpp.StageName = 'Drafting';
        testOpp.accountId = testAccount.Id;
        insert testOpp;
        Test.startTest();
        OnboardingGenerateCIFController.confirmDocumentReceipt(testOpp.Id);
        Test.stopTest();
    }
    
    @isTest 
    public static void callScreeningPostive(){ 
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CreateClientCIFMock_ApiRest(StringConstants.POSITIVE_STRING, StringConstants.POSITIVE_STRING, StringConstants.POSITIVE_STRING,null));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.VALIDATE_CLIENT_DETAILS, StringConstants.VALIDATE_ADDRESS,StringConstants.CREATE_CLIENT_CIF});
        IntegrationTestDataFactory.insertIntegrationTranslations();  
         
        Account account = new Account(FirstName = 'Test Account',LastName = 'test');
        account.RecordTypeId = schema.SObjectType.account.getRecordTypeInfosByName().get('Individual Client').getRecordTypeId();
        account.Cif__c = '12345';
        insert account;
        
        Opportunity testOpp = new Opportunity();
        testOpp.Name = 'Test Opp';
        testOpp.CloseDate = Date.today();
        testOpp.StageName = 'Drafting';
        testOpp.accountId = account.Id;
        insert testOpp;
        
        Test.startTest();
        OnboardingGenerateCIFController.callToCreateCIF(testOpp.Id, 'Prospect');
        system.assertNotEquals(testOpp.CIF__c,null);
        Test.stopTest();
    }
    
     @isTest 
    public static void getOpportunityProductTest(){
        
        Account account = new Account(Name = 'Test Account');
         account.RecordTypeId = schema.SObjectType.account.getRecordTypeInfosByName().get('Business Prospect').getRecordTypeId();
        //W-005355 : Anka Ganta : 2020-07-09
        account.Country_of_Incorporation__c='South Africa';
        account.Client_Group__c = 'Non Individual';
        account.CASA_Reference_Number__c = '12233';
        account.CIF__c = '';
        account.Countries_Traded_With__c = 'South Africa';
        account.Source_of_Income__c = 'Donation';
        insert account;
        
        
         //insert related acct;
         List<AccountContactRelation> acrList = new List<AccountContactRelation>();
        Account acctSecondary = new Account();
        acctSecondary.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual Prospect').getRecordTypeId();
        acctSecondary.ID_Number__pc = '6803037015089';
        acctSecondary.ID_Type__pc = 'SA Identity Document';
        acctSecondary.FirstName = 'First Name';
        acctSecondary.LastName = 'Test Last Name';
        acctSecondary.Initials__pc = 'I';
        acctSecondary.PersonTitle = 'Mr';
        acctSecondary.Client_Type__c = 'Individual Client';
        acctSecondary.CASA_Reference_Number__pc = '12454' ;
        acctSecondary.CASA_Screening_Status__c = 'Matched';
        insert acctSecondary;        
        Account acc = [SELECT PersonContactId FROM Account WHERE Id =: acctSecondary.Id];
        Id personContactId = acc.PersonContactId;
        AccountContactRelation accConRel = new AccountContactRelation(AccountId = account.Id, ContactId = personContactId);
        insert accConRel;
        acrList.add(accConRel);

        System.debug('** acrList: ' + acrList.size());
        
        Set<Id> relatedPartIdSet = new Set<Id>();
        for(AccountContactRelation acr : acrList){
            relatedPartIdSet.add(acr.ContactId);
        }
       List<Account> rpAccounts = new AccountsSelector().selectCasaFieldsByPersonContactSetId(relatedPartIdSet);
       
       System.debug('rpAccounts++'+rpAccounts);
        
        Opportunity testOpp = new Opportunity();
        testOpp.Name = 'Test Opp';
        testOpp.CloseDate = Date.today();
        testOpp.StageName = 'Drafting';
        testOpp.accountId = account.Id;
        insert testOpp;
        
        Product2 prod = new Product2(Name = 'Cheque Product', Family = 'Cheque',ProductCode = '1234' );
        
        insert prod;
        
        System.debug('prod'+prod.Id);
        
        Pricebook2 standardPriceBook = WillsTestDataFactory.getStandardPriceBook();
        PricebookEntry pricebookEntry = WillsTestDataFactory.createPriceBookEntry(standardPriceBook.Id, prod.Id);
        
        OpportunityLineItem oli = new OpportunityLineItem();
        oli.OpportunityId = testOpp.Id;
        if(prod.Id != null) {
            oli.Product2Id = prod.Id;
        }
        oli.PriceBookEntryid = pricebookEntry.Id;
        oli.Quantity = 1;
        oli.TotalPrice = 100;
        insert oli;
        
          Test.startTest();
       String productName = OnboardingGenerateCIFController.getOpportunityProduct(testOpp.id);
       System.assertNotEquals(productName, null);
        Test.stopTest();
    }
     //Start changes for W-004683 By Himani 
     @isTest
    public static void testgetmandatorydocs()
   {
       
       string Entitytype = 'aa';
        Mandatory_Doc__mdt md1=new Mandatory_Doc__mdt();
        md1.Entity_Type__c='Sole Trader';
        md1.ECM_Type__c='Ent_Declaration';
        //return md1;
        Mandatory_Doc__mdt md2=new Mandatory_Doc__mdt();
        md1.Entity_Type__c='aa';
        md1.ECM_Type__c='bb';
       //Opportunity opp=[select id,CheckMandatoryDocuments__c,StageName,Entity_Type__c from opportunity limit 1 ];
        Account testAccount= new Account();
        testAccount.Name = 'Test Name';
       //W-005355 : Anka Ganta : 2020-07-09
        testAccount.Country_of_Incorporation__c='South Africa';
        testAccount.Client_Group__c = 'Non Individual';
        testAccount.Client_Type__c ='Sole Trader';
        testAccount.CASA_Reference_Number__c = '12233';
        testAccount.CIF__c = '';
        testAccount.Countries_Traded_With__c = 'South Africa';
        testAccount.Source_of_Income__c = 'Donation';
        insert testAccount;
       
        // W-005222 : Masechaba Maseli : 070820
        Account account = new Account(Name = 'Test Account');
        account.RecordTypeId = schema.SObjectType.account.getRecordTypeInfosByName().get('Business Prospect').getRecordTypeId();
        account.Country_of_Incorporation__c='South Africa';
        account.Client_Group__c = 'Non Individual';
        account.Client_Type__c ='Private Company';
        account.CASA_Reference_Number__c = '12233';
        account.CIF__c = '';
        account.Countries_Traded_With__c = 'South Africa';
        account.Source_of_Income__c = 'Donation';
        insert account;
       
       Account account2 = new Account(Name = 'Test Account2');
            account2.RecordTypeId = schema.SObjectType.account.getRecordTypeInfosByName().get('Business Prospect').getRecordTypeId();
            account2.Country_of_Incorporation__c='South Africa';
            account2.Client_Group__c = 'Non Individual';
            account2.Client_Type__c ='Private Company';
            account2.CASA_Reference_Number__c = '12233';
            account2.CIF__c = '';
            account2.Countries_Traded_With__c = 'South Africa';
            account2.Source_of_Income__c = 'Donation';
            insert account2;
       
        Account acctSecondary = new Account();
        acctSecondary.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual Prospect').getRecordTypeId();
        acctSecondary.ID_Number__pc = '6803037015089';
        acctSecondary.ID_Type__pc = 'SA Identity Document';
        acctSecondary.FirstName = 'First Name1';
        acctSecondary.LastName = 'Last Name1';
        acctSecondary.Initials__pc = 'I';
        acctSecondary.PersonTitle = 'Mr';
        acctSecondary.Client_Type__c = 'Individual Client';
        acctSecondary.CASA_Reference_Number__pc = '12454' ;
        acctSecondary.CASA_Screening_Status__c = 'Matched';
        insert acctSecondary; 
       
        Account acc = [SELECT PersonContactId FROM Account WHERE Id =: acctSecondary.Id];
        Id personContactId = acc.PersonContactId;
       
       AccountContactRelation accConRel2 = new AccountContactRelation(
       AccountId = account.Id, 
       ContactId = personContactId,
       Roles = 'Shareholder/Controller',
       Primary_Entity_Id__c = testAccount.Id,
       Share_Percentage__c = 50);
       insert accConRel2; 
       
       FinServ__ReciprocalRole__c resRole = new FinServ__ReciprocalRole__c();
       resRole.FinServ__CreateInverseRole__c = true;
       resRole.FinServ__InverseRole__c = 'Director';
       insert resRole;
       
       FinServ__AccountAccountRelation__c accAccRel = new FinServ__AccountAccountRelation__c(
       FinServ__Account__c = account.Id, 
       FinServ__RelatedAccount__c = account2.Id,
       Roles__c = 'Shareholder/Controller',
       FinServ__Role__c = resRole.id, 
       Primary_Entity_Id__c = account.Id,
       Shareholding_Percentage__c = 50);    
       insert accAccRel;
      // End of Changes by Masechaba Maseli  W-005222 
     
         Opportunity testOpp = new Opportunity();
        testOpp.Name = 'Test Opp';
        testOpp.CloseDate = Date.today();
        
        testOpp.StageName = 'Drafting';
        testOpp.accountId = testAccount.Id;
        insert testOpp;
        Document_Template__c d1=new Document_Template__c();
        d1.name='ABSA 6280 - Tax Self- Certification and Declaration';
        d1.ECM_Item_Type__c='Ent_Declaration';
       d1.Parent_Document_Type__c = 'Business Client Agreement';
       
        insert d1;
        Document__c d= new Document__c();
        d.name='aa';
        d.Type__c='ABSA 6280 - Tax Self- Certification and Declaration';
        d.Opportunity__c=testOpp.id;
        d.Reference__c = '92 3 ICM7 UGOLSDB13 Ent_Quotation59 26 A1001001A20F08C10108B0752518 A20F08C10108B075251 14 1868';
        insert d;
        
        Trading_as_Name__c testTradingAsName = new Trading_as_Name__c();
        testTradingAsName.Name = 'T/A Test';
        testTradingAsName.Account__c = testAccount.id;
        insert testTradingAsName;
        //list<Document_Template__c>doctemp=[select name,ECM_Item_Type__c from Document_Template__c where ECM_Item_Type__c =: 'Ent_Declaration' ];
        //List<Document__c> docList = new DocumentsSelector().selectDocumentsByOppId(testOpp.id);
        //list<Mandatory_Doc__mdt>manlist=[select label,Entity_Type__c,ECM_Type__c from Mandatory_Doc__mdt];
       Test.startTest();
       OnboardingGenerateCIFController.getentitytype(testOpp.Id);
       OnboardingGenerateCIFController.getDocs(testOpp.Id);
       OnboardingGenerateCIFController.getAllMandatoryDocuments('Sole Trader');
       OnboardingGenerateCIFController.getAllRelatedMandatoryDocuments(account.Client_Type__c, testOpp.Id);
       OnboardingGenerateCIFController.getPrimaryClientMandatoryDocuments(account.Client_Type__c, testOpp.Id);
       system.assertEquals(testOpp.CheckMandatoryDocuments__c,false);

       Test.stopTest();
   }
   @isTest 
    public static void testupdateopportunity()
        
    {
       //Opportunity opp=[select id,CheckMandatoryDocuments__c,StageName from opportunity limit 1 ];
       Opportunity testOpp = new Opportunity();
        testOpp.Name = 'Test Opp';
        testOpp.CloseDate = Date.today();
        testOpp.StageName = 'Drafting';
        
        insert testOpp;
       Test.startTest();
       try{
       OnboardingGenerateCIFController.updateOpportunity(testOpp.Id,'true');
       OnboardingGenerateCIFController.updateOpportunity(testOpp.Id,'false');
       OnboardingGenerateCIFController.updateOpportunity(null,null);
       system.assertEquals(testOpp.CheckMandatoryDocuments__c,false);
       }
        catch(Exception e){
            System.debug('Exception::'+e.getMessage());
        }
        Test.stopTest();
        
       
    }
    
    @isTest
    public static void testgetauditdocs()
   {
       Opportunity testOpp = new Opportunity();
        testOpp.Name = 'Test Opp';
        testOpp.CloseDate = Date.today();
        testOpp.StageName = 'Drafting';
        
        insert testOpp;
       //WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        Test.startTest();
      //List<Document__c> documentAuditList = 
        OnboardingGenerateCIFController.getDocs(testOpp.Id);
        OnboardingGenerateCIFController.getentitytype(testOpp.Id);
        system.assertEquals(testOpp.CheckMandatoryDocuments__c,false);
        Test.stopTest();
   }
   //End changes for W-004683 By Himani 
   @isTest
    public static void getDocsByOppIdTest()
   {
       Opportunity testOpp = new Opportunity();
       testOpp.Name = 'Test Opp';
       testOpp.CloseDate = Date.today();
       testOpp.StageName = 'Drafting';
       
       insert testOpp;
       Document__c doc1 = new Document__c(Name = 'mydoc.pdf', Reference__c = '12345', Type__c = 'EDD level ll report', Opportunity__c = testOpp.Id);
       Document__c doc2 = new Document__c(Name = 'mydoc.pdf', Reference__c = '12345', Type__c = 'Management sign off', Opportunity__c = testOpp.Id);
       Document__c doc3 = new Document__c(Name = 'mydoc.pdf', Reference__c = '12345', Type__c = 'Proof of source of Income / funds', Opportunity__c = testOpp.Id);
       List<Document__c> docList = new List<Document__c>();
       docList.add(doc1);
       docList.add(doc2);
       docList.add(doc3);
       insert docList;
       Test.startTest();
       OnboardingGenerateCIFController.getDocsByOppId(testOpp.Id);
       system.assertEquals(testOpp.CheckMandatoryDocuments__c,false);
       Test.stopTest();
   }

@isTest
    public static void getDocumentsCasaTiersTest(){
      WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        Generatedocumentsv7_Req_IB_v1.createDummyRequest();
 
         
        Test.setMock(HttpCalloutMock.class, new Generatedocumentsv7_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT, new list<String> {'Jitterbit Auth Path'});
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, new list<String> {StringConstants.Generatedocumentsv7_STRING});
        Integration_API__c apiIntRec =Sys_Utilities_Integration.getIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, Sys_Utilities_General.getEnvironment(), StringConstants.Generatedocumentsv7_STRING);
        system.debug('********apiIntRec**********'+apiIntRec);
        system.assertNotEquals(apiIntRec,null);
        
       
        Account testAccount= new Account();
        testAccount.Name = 'Test Name';
        testAccount.Country_of_Incorporation__c ='South Africa';
        testAccount.Client_Group__c = 'Non Individual';
        testAccount.CASA_Reference_Number__c = '12233';
        testAccount.CIF__c = '';
        testAccount.Countries_Traded_With__c = 'South Africa';
        testAccount.Source_of_Income__c = 'Donation';
        insert testAccount;
         Opportunity testOpp = new Opportunity();
        testOpp.Name = 'Test Opp';
        testOpp.CloseDate = Date.today();
        testOpp.StageName = 'Drafting';
        testOpp.accountId = testAccount.Id;
        insert testOpp;
        Test.startTest();
        String responsesuccess = OnboardingGenerateCIFController.getDocumentsCasaTiers(testOpp.Id);
        Test.stopTest();
        system.assertNotEquals(responsesuccess,null);
    }    
    
}