/**
* Apex Test Class for Debit Card
* @author  Mbuyiseni Mbhokane 
*
**/

@isTest
public class DebitCardOrderingControllerTest {
    
     @testSetup
    static void createDataCreation(){
        
        Account account = new Account();
        account.Name = 'Test Account';
        insert account;
        
        Account indivAccount = new Account();
        indivAccount.RecordTypeId = schema.SObjectType.account.getRecordTypeInfosByName().get('Individual Prospect').getRecordTypeId();
        indivAccount.FirstName = 'Test';
        indivAccount.LastName = 'Individual';
        indivAccount.Communication_Language__pc = 'English';
        indivAccount.PersonTitle = 'Mr.';
        indivAccount.Initials__pc = 'T';
        indivAccount.Client_Group__c = 'Individual';
        indivAccount.Client_Type__c = 'Private Individual';
        insert indivAccount;
        
        //Create address: 
        Address__c address =  new Address__c();
        address.Address_Type__c = 'Residential';
        address.Shipping_City__c = 'City';
        address.Shipping_Country__c = 'South Africa';
        address.Shipping_State_Province__c = 'prov';
        address.Shipping_Street__c = 'steert';
        address.Shipping_Suburb__c = 'Sub';
        address.Shipping_Zip_Postal_Code__c = '1000';
        address.Account__c = indivAccount.Id;
        insert address;

        Contact contact = new Contact(LastName='Test contact', AccountId = account.Id, Email = 'agents@support.co.za');
        insert contact;
        
        Opportunity testOpp = new Opportunity();
        testOpp.Name = 'Test Opp Onboarding 1';
        testOpp.CloseDate = Date.today();
        testOpp.StageName = 'New';
        testOpp.AccountId=account.Id;

        insert testOpp;
        
        Product2 prod = new Product2(Name = 'Cheque Product', Family = 'Cheque');
        insert prod;
        
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id, UnitPrice = 10000, IsActive = true);
        insert standardPrice;
        
        Pricebook2 customPB = new Pricebook2(Name='Standard Pricebook', isActive=true);
        insert customPB;
        
        PricebookEntry customPrice = new PricebookEntry(Pricebook2Id = customPB.Id, Product2Id = prod.Id, UnitPrice = 12000, IsActive = true);
        insert customPrice;

        OpportunityLineItem oppLineItem = new OpportunityLineItem();
        oppLineItem.OpportunityId = testOpp.id;
        oppLineItem.Product2Id = prod.id;
        oppLineItem.PricebookEntryId = customPrice.id;
        oppLineItem.Quantity = 1;
        oppLineItem.TotalPrice = 100;
        oppLineItem.Policy_Number__c = '4048371403';
        insert oppLineItem;
        
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
        acctSecondary.CASA_Reference_Number__c = '12454' ;
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
        
        
    }

    @isTest static void cclistPrefProductForClientV2PositiveTest() {
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, CClistPrefProductForClientV2_IH_v2_Test.PREF_PROD_RESPONSE_BODY));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{CClistPrefProductForClientV2_IH_v2.INTEGRATION_SERVICE_NAME});
        IntegrationTestDataFactory.insertIntegrationTranslations();
        test.startTest();
        //String listPrefProductForClientResult =  DebitCardOrderingController.listPrefProductForClient('SACOMPE203', '4048371403', 'C');
        String listPrefProductForClientResult = DebitCardOrderingController.productForClient('SACOMPE203', '4048371403', 'C');
        test.stopTest();
    }
    
        @isTest static void cclistPrefProductForClientV2NegativeTest() {
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.NEGATIVE_STRING, StringConstants.NEGATIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{CClistPrefProductForClientV2_IH_v2.INTEGRATION_SERVICE_NAME});
        IntegrationTestDataFactory.insertIntegrationTranslations();
        test.startTest();
        //String listPrefProductForClientResult =  DebitCardOrderingController.listPrefProductForClient('SACOMPE203', '4048371403', 'C');
        String listPrefProductForClientResult = DebitCardOrderingController.productForClient('SACOMPE203', '4048371403', 'C');
        test.stopTest();
    }
    
   /* @isTest static void cclistCombiBrandsForPrefProdPositiveTest() {
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, CClistCombiBrandsForPrefProdV1IH_v1_Test.POSITIVE_RESPONSE_BODY));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{CClistCombiBrandsForPrefProdV1_IH_v1.INTEGRATION_SERVICE_NAME});
        IntegrationTestDataFactory.insertIntegrationTranslations();
        test.startTest();
        String cclistCombiBrandsForPrefProdResult =  DebitCardOrderingController.cclistCombiBrandsForPrefProd('CQ','11016', 'C');
        test.stopTest();
    }
    
    @isTest static void cclistCombiBrandsForPrefProdNegativeTest() {
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.NEGATIVE_STRING, StringConstants.NEGATIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{CClistCombiBrandsForPrefProdV1_IH_v1.INTEGRATION_SERVICE_NAME});
        IntegrationTestDataFactory.insertIntegrationTranslations();
        test.startTest();
        String cclistCombiBrandsForPrefProdResult =  DebitCardOrderingController.cclistCombiBrandsForPrefProd('CQ','11016', 'C');
        test.stopTest();
    }*/
    
    @isTest static void ccissuePositiveTest() {
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, CCIssueV2_IH_v2_Test.POSITIVE_RESPONSE_BODY));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{CCIssueV2_IH_v2.INTEGRATION_SERVICE_NAME});
        IntegrationTestDataFactory.insertIntegrationTranslations();
        test.startTest();
        //String ccissueResult =  DebitCardOrderingController.ccissue('6003','N','0','WALINM 001','1565','11032','N','4048063812','9051159122','0','N','N','N','P','sd45676');
        String ccissueResult = DebitCardOrderingController.ccIssueCard('6003', 'N', 'N', 'Glen Johnston', '1537396144', 'WALINM 001', '1565', '11032', 'N', '4048063812', '9051159122', '0', 'N', 'N', 'N', 'P', 'sd45676', 'I');
        test.stopTest();  
    }
    
    @isTest static void ccissueNegativeTest() {
        String negative_body = '{"errorCode" : 404, "message": "Resource not found"}"';
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.NEGATIVE_STRING, negative_body));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{CCIssueV2_IH_v2.INTEGRATION_SERVICE_NAME});
        IntegrationTestDataFactory.insertIntegrationTranslations();
        test.startTest();
        String ccissueResult =  DebitCardOrderingController.ccIssueCard('6003', 'N', 'N', 'Glen Johnston', '1537396144', 'WALINM 001', '1565', '11032', 'N', '4048063812', '9051159122', '0', 'N', 'N', 'N', 'P', 'sd45676', 'I');
        test.stopTest();  
    }
    
    @isTest static void ccIssueBBCombiCardPositiveTest() {
        
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, CCissueBBCombiCardV1_IH_v2_Test.COMBI_CARD_POS_RESPONSE_BODY));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{CCissueBBCombiCardV1_IH_v2.COMBICARD_SERVICE_NAME});
        IntegrationTestDataFactory.insertIntegrationTranslations();
        test.startTest();
        //String ccIssueBBCombiCardResult = DebitCardOrderingController.ccIssueBBCombiCard('ESP','BBBBDO 008','1033081801','11016','1033081801','0','B','231','H','BBOYS  001','Y','B','N',null);
        String ccIssueBBCombiCardResult = DebitCardOrderingController.ccIssueCombiCard('ESP', 'BBBBDO 008', '1033081801', '11016', '2631', '8913', 'H', 'BBOYS  001', 'F', 'May Khumalo', '1033081801', '0', 'C', 'Y') ;
        test.stopTest();
    }
    
        @isTest static void ccIssueBBCombiCardNegativeTest() {
        
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.NEGATIVE_STRING, StringConstants.NEGATIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{CCissueBBCombiCardV1_IH_v2.COMBICARD_SERVICE_NAME});
        IntegrationTestDataFactory.insertIntegrationTranslations();
        test.startTest();
        //String ccIssueBBCombiCardResult = DebitCardOrderingController.ccIssueBBCombiCard('ESP','BBBBDO 008','1033081801','11016','1033081801','0','B','231','H','BBOYS  001','Y','B','N',null);
        String ccIssueBBCombiCardResult = DebitCardOrderingController.ccIssueCombiCard('ESP', 'BBBBDO 008', '1033081801', '11016', '2631', '8913', 'H', 'BBOYS  001', 'F', 'May Khumalo', '1033081801', '0', 'C', 'Y') ;
        test.stopTest();
    }
    
    @isTest static void updateDailyLimitTest() {
        test.startTest();
        String updateDailyLimitResult = DebitCardOrderingController.updateDailyLimits('999999', '99', '999999', '8913', '1033081801', '100', '100', '100', '100', '1033081801', '1234', '100', '100', '100', '9051159122', '2468', '100', '100', '100');
        test.stopTest();
    }
    
    @isTest static void getOpportunityLineItemsTest() {
        
        Opportunity opportunity = [SELECT Id,Name FROM Opportunity LIMIT 1];
        test.startTest();
        List<Map<String, String>> oppLineItems = DebitCardOrderingController.getOpportunityLineItems(opportunity.Id);
        test.stopTest();
    }
    
    @isTest static void getOpportunityLineItemDetailsTest() {
        Opportunity newopportunity = [SELECT Id,Name FROM Opportunity LIMIT 1];
        test.startTest();
        List<OpportunityLineItem> opportunityLineItemDetails = DebitCardOrderingController.getOpportunityLineItemDetails(newopportunity.Id);
        test.stopTest();
    }
    
    @isTest static void getRelatedPartiesTest() {
        Opportunity currentOpp = [SELECT Id,Name FROM Opportunity LIMIT 1];
        test.startTest();
        List<Map<String, Object>> relatedPartiesResult = DebitCardOrderingController.getRelatedParties(currentOpp.Id);
        test.stopTest();
    }
    
    //TdB - Test Method for Mini CIF Positive
    @isTest static void createCIFMiniClientTestPostive() {
        
        Test.setMock(HttpCalloutMock.class, new CreateClientCIFMock_ApiRest(StringConstants.POSITIVE_STRING, StringConstants.POSITIVE_STRING, StringConstants.POSITIVE_STRING,null));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new list<String> {StringConstants.CI_Create_Client_V12});
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.VALIDATE_CLIENT_DETAILS, StringConstants.VALIDATE_ADDRESS});
        IntegrationTestDataFactory.insertIntegrationTranslations();  
        
        Account newAcc = [SELECT Id,Name FROM Account WHERE isPersonAccount = TRUE LIMIT 1];
        
        test.startTest();
        DebitCardOrderingController.createCIFMiniClient(newAcc.Id);
        DebitCardOrderingController.cifwrappercls cifwrpr = new DebitCardOrderingController.cifwrappercls();
        cifwrpr.cifoutput = 'test';
        cifwrpr.cifoutputerror = 'test';
        cifwrpr.errorObjMsg = 'test';
        list<String> errormsglistbean = new list<String> {'test1','test2'};
        cifwrpr.errormsglist = errormsglistbean;
        test.stopTest();
    }
    
    //TdB - Test Method for Mini CIF Negative
    @isTest static void createCIFMiniClientTestNegative() {
        
        Test.setMock(HttpCalloutMock.class, new CreateClientCIFMock_ApiRest(StringConstants.NEGATIVE_STRING, StringConstants.NEGATIVE_STRING, StringConstants.NEGATIVE_STRING,null));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new list<String> {StringConstants.CI_Create_Client_V12});
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.VALIDATE_CLIENT_DETAILS, StringConstants.VALIDATE_ADDRESS});
        IntegrationTestDataFactory.insertIntegrationTranslations();  
        
        Account newAcc = [SELECT Id FROM Account WHERE isPersonAccount = TRUE LIMIT 1];
        
        test.startTest();
        DebitCardOrderingController.selectedRelatedPartyAddress(newAcc.Id);
        DebitCardOrderingController.createCIFMiniClient(newAcc.Id);
        try {
            DebitCardOrderingController.createCIFMiniClient(null);
        } catch (Exception ex) {
            
        }
         
        test.stopTest();
    }
    
    @isTest static void createCIFMiniClientTestPositive2() {
        
        Test.setMock(HttpCalloutMock.class, new CreateClientCIFMock_ApiRest(StringConstants.POSITIVE_STRING, StringConstants.POSITIVE_STRING, StringConstants.POSITIVE_STRING,null));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new list<String> {StringConstants.CI_Create_Client_V12});
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.VALIDATE_CLIENT_DETAILS, StringConstants.VALIDATE_ADDRESS});
        IntegrationTestDataFactory.insertIntegrationTranslations();  
        
        Account newAcc = [SELECT Id FROM Account WHERE isPersonAccount = TRUE LIMIT 1]; 
        newAcc.Client_Type__c = NULL;
        newAcc.Client_Group__c = NULL; 
        update newAcc;
        
        test.startTest();
        
        try{
            DebitCardOrderingController.createCIFMiniClient(newAcc.Id);
        } catch (Exception ex) {
            System.debug('Error : ' + ex);
        }
        test.stopTest();
    }
    
    @isTest static void createApplicationProductRecordTest(){
        Opportunity newOpp = [SELECT Id,Name FROM Opportunity LIMIT 1];
        
        Application_Product__c createApplicationRecord = new Application_Product__c();
        createApplicationRecord.Account_Auto_Link_Indicator__c = 'N';
        createApplicationRecord.Blind_Or_Disable_Indicator__c = 'N';
        createApplicationRecord.Opportunity__c = newOpp.Id;
        createApplicationRecord.Opportunity_Product_Id__c = newOpp.Id;
        insert createApplicationRecord;
        
        test.startTest();
        DebitCardOrderingController.createApplicationProductRecord(createApplicationRecord,newOpp.Id);
        test.stopTest();
    }
    
    @isTest static void brandNumbersTest(){
        test.startTest();
        DebitCardOrderingController.brandNumbers();
        test.stopTest();
    }

    @isTest static void selectedRelatedPartyAddressTest(){
        Account individualAcc = [SELECT Id FROM Account WHERE isPersonAccount = TRUE LIMIT 1];
        Address__c relatedPartyAddress = [SELECT Id,Name, Address_Type__c FROM Address__c LIMIT 1];
        test.startTest();
        DebitCardOrderingController.selectedRelatedPartyAddress(individualAcc.Id);
        test.stopTest();
    }

}