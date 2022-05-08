@isTest
public class Wqgetanalystcommentsv7_IH_v1_Test {
     
    @isTest static void testWqgetanalystcommentsv7Positive(){
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new Wqgetanalystcommentsv7_ApiRest(StringConstants.POSITIVE_STRING));
        //Insert Integration Settings
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT, new list<String> {'Jitterbit Auth Path'});
        IntegrationTestDataFactory.insertIntegrationSettingsJitterbit(StringConstants.JITTERBIT_API_RB_STRING, new list<String> {StringConstants.Wqgetanalystcommentsv7_STRING});
        Integration_API__c apiIntRec =Sys_Utilities_Integration.getIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, Sys_Utilities_General.getEnvironment(), StringConstants.Wqgetanalystcommentsv7_STRING);
        system.debug('********apiIntRec**********'+apiIntRec);
        system.assertNotEquals(apiIntRec,null);
        Account account = new Account(Name = 'Test Account');
         account.RecordTypeId = schema.SObjectType.account.getRecordTypeInfosByName().get('Business Prospect').getRecordTypeId();
        account.Country_of_Registration__c='South Africa';
        account.Client_Group__c = 'Non Individual';
        account.CASA_Reference_Number__c = '12233';
        account.CIF__c = '';
        account.Countries_Traded_With__c = 'South Africa';
        account.Country_of_Registration__c = 'South Africa';
        //account.Source_of_Income__c = 'Salary';
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
        // Call the method to test
        Wqgetanalystcommentsv7_Req_IB_v1.dummyRequest();
        Wqgetanalystcommentsv7_Resp_IB_v1.dummyResponse();
         Wqgetanalystcommentsv7_IU_v1.mapRequestFields(acctSecondary);
       Wqgetanalystcommentsv7_IH_v1.getCasaAnalystComments(acctSecondary, false);
      // List<Wqgetanalystcommentsv7_Resp_IB_v1> responseBean = new List<Wqgetanalystcommentsv7_Resp_IB_v1>(beanToLogMap.keySet());
        //System.assertEquals(200, responseBean[0].statusCode);
        Test.stopTest();
        
        
    }
    
    @isTest static void testWqgetanalystcommentsv7Negative(){
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new Wqgetanalystcommentsv7_ApiRest(StringConstants.NEGATIVE_STRING));
        //Insert Integration Settings
        //Insert Integration Settings
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT, new list<String> {'Jitterbit Auth Path'});
        IntegrationTestDataFactory.insertIntegrationSettingsJitterbit(StringConstants.JITTERBIT_API_RB_STRING, new list<String> {StringConstants.Wqgetanalystcommentsv7_STRING});
        Integration_API__c apiIntRec =Sys_Utilities_Integration.getIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, Sys_Utilities_General.getEnvironment(), StringConstants.Wqgetanalystcommentsv7_STRING);
        system.debug('********apiIntRec**********'+apiIntRec);
        system.assertNotEquals(apiIntRec,null);
       Account account = new Account(Name = 'Test Account');
         account.RecordTypeId = schema.SObjectType.account.getRecordTypeInfosByName().get('Business Prospect').getRecordTypeId();
        account.Country_of_Registration__c='South Africa';
        account.Client_Group__c = 'Non Individual';
        account.CASA_Reference_Number__c = '12233';
        account.CIF__c = '';
        account.Countries_Traded_With__c = 'South Africa';
        account.Country_of_Registration__c = 'South Africa';
        //account.Source_of_Income__c = 'Salary';
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
        // Call the method to test
        
       Wqgetanalystcommentsv7_IH_v1.getCasaAnalystComments(acctSecondary, false);
       //List<Wqgetanalystcommentsv7_Resp_IB_v1> responseBean = new List<Wqgetanalystcommentsv7_Resp_IB_v1>(beanToLogMap.keySet());
       //System.assertEquals(200, responseBean[0].statusCode);
        Test.stopTest();
        
    }
    
    @isTest static void testWqgetanalystcommentsv7NoIntegrationSettings(){
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new Wqgetanalystcommentsv7_ApiRest(StringConstants.POSITIVE_STRING));
         Account account = new Account(Name = 'Test Account');
         account.RecordTypeId = schema.SObjectType.account.getRecordTypeInfosByName().get('Business Prospect').getRecordTypeId();
        account.Country_of_Registration__c='South Africa';
        account.Client_Group__c = 'Non Individual';
        account.CASA_Reference_Number__c = '12233';
        account.CIF__c = '';
        account.Countries_Traded_With__c = 'South Africa';
        account.Country_of_Registration__c = 'South Africa';
        //account.Source_of_Income__c = 'Salary';
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
        // Call the method to test
        
       Wqgetanalystcommentsv7_IH_v1.getCasaAnalystComments(acctSecondary, false);
        
        Test.stopTest();
       
    }
    
    @isTest static void testgetCasaAnalystComments(){
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new Wqgetanalystcommentsv7_ApiRest(StringConstants.POSITIVE_STRING));
        //Insert Integration Settings
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT, new list<String> {'Jitterbit Auth Path'});
        IntegrationTestDataFactory.insertIntegrationSettingsJitterbit(StringConstants.JITTERBIT_API_RB_STRING, new list<String> {StringConstants.Wqgetanalystcommentsv7_STRING});
        Integration_API__c apiIntRec =Sys_Utilities_Integration.getIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, Sys_Utilities_General.getEnvironment(), StringConstants.Wqgetanalystcommentsv7_STRING);
        system.debug('********apiIntRec**********'+apiIntRec);
        system.assertNotEquals(apiIntRec,null);
         Account account = new Account(Name = 'Test Account');
         account.RecordTypeId = schema.SObjectType.account.getRecordTypeInfosByName().get('Business Prospect').getRecordTypeId();
        account.Country_of_Registration__c='South Africa';
        account.Client_Group__c = 'Non Individual';
        account.CASA_Reference_Number__c = '12233';
        account.CIF__c = '';
        account.Countries_Traded_With__c = 'South Africa';
        account.Country_of_Registration__c = 'South Africa';
        //account.Source_of_Income__c = 'Salary';
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
        // Call the method to test
        
       Wqgetanalystcommentsv7_IH_v1.getCasaAnalystComments(acctSecondary, false);
       
        Test.stopTest();
        
    }
}