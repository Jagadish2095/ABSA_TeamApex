@isTest
public class DocumentTemplateMapperTest {
    @testSetup
    public static void dataCreation(){
        //WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        
        Account account = new Account();
        account.Name = 'Test Account';
        account.Client_Type__c = 'Private Individual';
        account.CIF__c = 'Test+001';
        insert account;
        
        Contact contact = new Contact(LastName='Test contact', AccountId = account.Id, Email = 'agents@support.co.za');
        insert contact;
        
        Opportunity testOpp = new Opportunity();
        testOpp.Name = 'Test Opp Onboarding 1';
        testOpp.CloseDate = Date.today();
        testOpp.StageName = 'New';
        testOpp.AccountId=account.Id;
        // testOpp.Site__c='Test';
        insert testOpp;

        Application__c app= new Application__c();
        app.Opportunity__c=testOpp.id;
        app.All_transaction_type__c = '';
        app.Payment__c = '';
        app.Withdrawal__c = '';
        app.Deposit__c = '';
        app.Returned_Transactions__c = '';
        app.Scheduled_transaction__c = '';
        app.Notification_time__c = Date.today();
        app.Minimum_amount__c = '';
        app.Account_to_be_debited_monthly_with_the_c__c = '';
        app.Number_of_authorisations_that_will_be_re__c = '';
        app.Number_of_main_users__c = '';
        app.Fee_Structure_code__c = '';
        app.Absa_online_for_business_BIB__c = '';
        app.Cell_phone_banking__c = '';
        app.Telephone_banking__c = '';
        app.Notifyme__c = '';
        app.Funds_transfer__c = '';
        app.Bill_payments__c = '';
        app.Own_defined_payments__c = '';
        app.Future_dated_payments__c = '';
        app.Stop_order_payments__c = '';
        app.Account_Access__c = 'Cellphone';
        app.Foreign_Services__c = 'Trade Finance Products';
        app.Surplus_Cash__c = 'Fixed Deposits';
        app.Borrowing_Requiment_General__c = 'Credit Card';
        app.Borrowing_requiment_Assest_Acquisition__c = 'Vehicle And Asset Finance';
        app.Protection_Of_Services__c = 'Retirement';
        app.Title__c = 'dd';
        app.FirstNameSignature__c = 'Litha';
        app.SurnameSignature__c = 'Nosekeleza';
        app.Signing_Date__c = System.today();
        
        insert app;
        
        Opportunity opp = new Opportunity();
        opp.StageName = 'Not Interested';
        opp.CloseDate = Date.today() + 10;
        opp.Name = 'EPP 2';
        insert opp;
        
        Product2 prod = new Product2(Name = 'Cheque Product', Family = 'Cheque');
        insert prod;
        
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id, UnitPrice = 10000, IsActive = true);
        insert standardPrice;
        
        Pricebook2 customPB = new Pricebook2(Name='Standard Pricebook', isActive=true);
        insert customPB;
        
        PricebookEntry customPrice = new PricebookEntry(Pricebook2Id = customPB.Id, Product2Id = prod.Id, UnitPrice = 12000, IsActive = true);
        insert customPrice;
        
        Quote testQuote = new Quote();
        testQuote.Name = 'Test Quote 1';
        testQuote.OpportunityId = opp.Id;
        testQuote.Pricebook2Id = pricebookId;
        testQuote.Commission_1st_Year__c = 100;
        testQuote.Commission_2nd_Year__c = 20;
        insert testQuote;
        
        testQuote = new Quote();
        testQuote.Name = 'Test Quote 2';
        testQuote.OpportunityId = opp.Id;
        testQuote.Pricebook2Id = pricebookId;
        testQuote.Commission_1st_Year__c = 100;
        testQuote.Commission_2nd_Year__c = 20;
        insert testQuote;
        
        OpportunityLineItem oppLineItem = new OpportunityLineItem();
        oppLineItem.OpportunityId = testOpp.id;
        oppLineItem.Product2Id = prod.id;
        oppLineItem.PricebookEntryId = customPrice.id;
        oppLineItem.Quantity = 1;
        oppLineItem.TotalPrice = 100;
        insert oppLineItem;
        
    }
    
    public static testMethod void testMapper() {
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        
        System.Test.startTest(); 
        
        Map<Id, sObject> objectMap = new Map<Id, sObject>();
        objectMap.put(testDataFactory.testAccount.Id, testDataFactory.testAccount);
        objectMap.put(testDataFactory.testQuote.Id, testDataFactory.testQuote);
        
        String test = '<Account> <LastName>{Account.LastName}</LastName> <FirstName>{Account.PersonBirthdate}</FirstName> <Quote> <QuoteName>{Quote.Name}</QuoteName> </Quote><Account>';
        String res = DocumentTemplateMapper.createXml(objectMap, test, null);
        System.debug(res);
        
        System.Test.stopTest();   
    }
    
    public static testMethod void testMapperNegative() {
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        
        System.Test.startTest(); 
        
        Map<Id, sObject> objectMap = new Map<Id, sObject>();
        objectMap.put(testDataFactory.testAccount.Id, testDataFactory.testAccount);
        objectMap.put(testDataFactory.testQuote.Id, testDataFactory.testQuote);
        
        String test = '<Account><LastName>{Account.LastName}</LastName><FirstName>{Account.PersonBirthdate}</FirstName><Quote><QuoteName>{Quote.Name}</QuoteName><ListOf.Quote.QuoteLineItem><QuoteLineItem><Date>{QuoteLineItem.ServiceDate}</Date><TotalPrice>{QuoteLineItem.TotalPrice}</TotalPrice></QuoteLineItem></ListOf.Quote.QuoteLineItem></Quote></Account>';
        String res;
        try {
            res = DocumentTemplateMapper.createXml(objectMap, test, null);
        } catch(Exception e) {
            System.debug(e);
        }
        System.debug(res);
        
        System.Test.stopTest();   
    }
    
    public static testMethod void testMapperWithList(){
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        
        System.Test.startTest(); 
        
        Map<Id, sObject> objectMap = new Map<Id, sObject>();
        objectMap.put(testDataFactory.testAccount.Id, testDataFactory.testAccount);
        objectMap.put(testDataFactory.testQuote.Id, testDataFactory.testQuote);
        
        Map<String, String> lookupMappings = new Map<String, String>();
        lookupMappings.put('Quote.QuoteLineItem', 'QuoteId');
        
        String test = '<Account><LastName>{Account.LastName}</LastName><FirstName>{Account.PersonBirthdate}</FirstName><Quote><QuoteName>{Quote.Name}</QuoteName><ListOf.Quote.QuoteLineItem><QuoteLineItem><Date>{QuoteLineItem.ServiceDate}</Date><TotalPrice>{QuoteLineItem.TotalPrice}</TotalPrice></QuoteLineItem></ListOf.Quote.QuoteLineItem></Quote></Account>';
        String res = DocumentTemplateMapper.createXml(objectMap, test, lookupMappings);
        
        Boolean isContinue = true;
        Integer currentSubstring = 0;
        Integer nextSubstring = 200;
        while(isContinue){
            if(nextSubstring < res.length()) {
                System.debug(res.substring(currentSubstring, nextSubstring));
                currentSubstring += 200;
                nextSubstring += 200; 
            }
            else{
                isContinue = false;
                System.debug(res.substring(currentSubstring, res.length()));
            }
            
        }
        
        System.Test.stopTest();   
    } 
    
    /*
     * author Thulani
     * 
     */
    public static testMethod void testMapperWithNestedList() {
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        
        Opportunity opp = new Opportunity();
        opp = testDataFactory.testOpportunity;
        opp.Id = null;
        opp.Name = 'EPP 2';
        insert opp;
        
        Id pricebookId = Test.getStandardPricebookId();
        
        Quote testQuote = new Quote();
        testQuote.Name = 'Test Quote 1';
        testQuote.OpportunityId = opp.Id;
        testQuote.Pricebook2Id = pricebookId;
        testQuote.Commission_1st_Year__c = 100;
        testQuote.Commission_2nd_Year__c = 20;
        insert testQuote;
        
        testQuote = new Quote();
        testQuote.Name = 'Test Quote 2';
        testQuote.OpportunityId = opp.Id;
        testQuote.Pricebook2Id = pricebookId;
        testQuote.Commission_1st_Year__c = 100;
        testQuote.Commission_2nd_Year__c = 20;
        insert testQuote;
        
        System.Test.startTest(); 
        
        Map<Id, sObject> objectMap = new Map<Id, sObject>();
        objectMap.put(testDataFactory.testAccount.Id, testDataFactory.testAccount);
        objectMap.put(testDataFactory.testQuote.Id, testDataFactory.testQuote);
        objectMap.put(testDataFactory.testOpportunity.Id, testDataFactory.testOpportunity);
        
        String test = '<Account><LastName>{Account.LastName}</LastName><FirstName>{Account.PersonBirthdate}</FirstName><Opportunity><Opportunity><OpportunityName>{Opportunity.Name}</OpportunityName><Quote><Picklist.Account><QuoteName>{Account.LastName}</QuoteName></Picklist.Account></Quote></Account>';
        
        Map<String, String> lookupMappings = new Map<String, String>();
        lookupMappings.put('Account.Opportunity', 'AccountId');
        lookupMappings.put('Opportunity.Quote', 'OpportunityId');
        
        String res = DocumentTemplateMapper.createXml(objectMap, test, lookupMappings);
        
        
        Boolean isContinue = true;
        Integer currentSubstring = 0;
        Integer nextSubstring = 200;
        while(isContinue){
            if(nextSubstring < res.length()){
                System.debug(res.substring(currentSubstring, nextSubstring));
                currentSubstring += 200;
                nextSubstring += 200;
            }
            else{
                isContinue = false;
                System.debug(res.substring(currentSubstring, res.length()));
            }
            
        }
        
        System.Test.stopTest();   
    }
    
    /*
     * author Thulani
     * 
     */
    
    public static testMethod void testCreateXmlForAuto() {
        WimiTestDataFactory factory = new WimiTestDataFactory();
        System.Test.startTest();
        
        Opportunity opp = factory.testOpportunity;
        Account acc = factory.testProspectAccount;
        opp.AccountId = acc.Id;
        OpportunityLineItem oppLineItem = [Select Id From OpportunityLineItem Limit 1];
        Document_Template__c dt = new Document_Template__c();
        
        dt.Name = 'Absa 5778: Merchant Payment Pricing Proposal';
        dt.XML__c = '<Schema><Main><proposal>{accountName}</proposal><desktopPosOffering>false</desktopPosOffering><bundleDesktopPosDevice>false</bundleDesktopPosDevice><mobileDesktopDevice>false</mobileDesktopDevice><paymentPebble>false</paymentPebble><inStoreBanking>false</inStoreBanking><showTerminal>false</showTerminal><eCommerce>false</eCommerce><batchlink>false</batchlink><paymentPebbleHandset>false</paymentPebbleHandset><airtime>false</airtime><other>false</other><proposalDate>{quoteGenerationDate}</proposalDate><proposalIssueBy>{quoteGeneratedBy}</proposalIssueBy><sigDate>2020-08-04T17:07:01</sigDate><otherPrductOffering1>{productName}</otherPrductOffering1></Main><Pricing><merchantFeeCategory>0</merchantFeeCategory><pricingRate>0</pricingRate><pricingDate>2020-08-04T17:07:01</pricingDate><condition>0</condition><monthlyAdminFee>0</monthlyAdminFee><MonthlyDevicerentalDesktop>{[Desktop Terminal Rent]:[All]}</MonthlyDevicerentalDesktop><MonthlyDevicerentalCellphone>{[Mobile Terminal Rent]:[All]}</MonthlyDevicerentalCellphone><OnceoffSIMactivationfeepercellphonedevice>{[Initiation Fee]:[All]}</OnceoffSIMactivationfeepercellphonedevice><ImplementationFee>0</ImplementationFee><OnceoffECommerceBatchLinkSetUpfee>0</OnceoffECommerceBatchLinkSetUpfee><MonthlyMaintenanceFee>0</MonthlyMaintenanceFee><MonthlyAdminFee>0</MonthlyAdminFee><MinimumDiscountFee>{[MDF]:[All]}</MinimumDiscountFee><ChargebackFee>0</ChargebackFee><CardPresentDebitCards>{[Debit Card]:[All]}</CardPresentDebitCards><CardPresentCreditCards>{[Credit Card]:[All]}</CardPresentCreditCards><CardNotPresentDebitCards>0</CardNotPresentDebitCards><CardNotPresentCreditCards>0</CardNotPresentCreditCards></Pricing></Schema>';
        insert dt;
        
        Map<String, String> fieldValue = new Map<String, String>();
        
        fieldValue.put('[SmartPay Terminal Rent]:[All]','199');
        fieldValue.put('[Mobile Terminal Rent]:[All]', '420');
        fieldValue.put('[Initiation Fee]:[All]', '0');
        fieldValue.put('[Cancellation Fee]:[All]', '0');
        fieldValue.put('[MDF]:[All]', '390');
        fieldValue.put('[Desktop Terminal Rent]:[All]', '249');
        fieldValue.put('[International Card]:[All]', '2.74');
        fieldValue.put('[Debit Card]:[All]', '2.06');
        fieldValue.put('[Credit Card]:[All]', '2.06');
        fieldValue.put('quoteExpirationDate', '2020-08-04T17:07:01');
        fieldValue.put('quoteGeneratedBy', 'prashant.jain@absa.africa');
        fieldValue.put('quoteGenerationDate', '2020-07-25T17:07:01');
        fieldValue.put('selectedQuantity', '1');
        fieldValue.put('productName', 'Mobile - SmartPay');
        fieldValue.put('accountName', 'SOUTH AFRICAN COMPENSATORS (PTY) LTD');
        fieldValue.put('inputType', 'fieldValues');
        fieldValue.put('opportunityId', opp.Id);
        fieldValue.put('otherPrductOffering1', 'Monthly Admin Fee');
        fieldValue.put('numberOfDevices1', '2');
        fieldValue.put('sigDate', '2020-07-16T00:00:00');
        fieldValue.put('merchantFeeCategory', '');
        fieldValue.put('pricingRate', '34');
        fieldValue.put('pricingDate', '2020-07-16T00:00:00');
        fieldValue.put('condition', '567');
        fieldValue.put('monthlyAdminFee', '57');
        fieldValue.put('OnceoffSIMactivationfeepercellphonedevice', '68');
        fieldValue.put('ImplementationFee', '65');
        fieldValue.put('OnceoffECommerceBatchLinkSetUpfee', '68');
        fieldValue.put('MonthlyMaintenanceFee', '356');
        fieldValue.put('ChargebackFee', '93');
        fieldValue.put('CardNotPresentDebitCards', '87');
        fieldValue.put('CardNotPresentCreditCards', '56');
        
        System.assert(DocumentTemplateMapper.createXmlForAuto(fieldValue, dt.XML__c) != null);
        
        System.Test.stopTest();   
    }
    
    
    public static testMethod void testMapperWithNested2List(){
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        
        Opportunity opp = new Opportunity();
        opp = testDataFactory.testOpportunity;
        opp.Id = null;
        opp.Name = 'EPP 2';
        insert opp;
        
        Id pricebookId = Test.getStandardPricebookId();
        
        Quote testQuote = new Quote();
        testQuote.Name = 'Test Quote 1';
        testQuote.OpportunityId = opp.Id;
        testQuote.Pricebook2Id = pricebookId;
        testQuote.Commission_1st_Year__c = 100;
        testQuote.Commission_2nd_Year__c = 20;
        insert testQuote;
        
        testQuote = new Quote();
        testQuote.Name = 'Test Quote 2';
        testQuote.OpportunityId = opp.Id;
        testQuote.Pricebook2Id = pricebookId;
        testQuote.Commission_1st_Year__c = 100;
        testQuote.Commission_2nd_Year__c = 20;
        insert testQuote;
        
        System.Test.startTest(); 
        
        Map<Id, sObject> objectMap = new Map<Id, sObject>();
        objectMap.put(testDataFactory.testAccount.Id, testDataFactory.testAccount);
        
        String test = '<Account><LastName>{Account.LastName}</LastName><FirstName>{Account.FirstName}</FirstName><Opportunity><ListOf.Account.Opportunity><OpportunityName>{Opportunity.Name}</OpportunityName><Quote><ListOf.Opportunity.Quote><QuoteName>{Quote.Name}</QuoteName><ListOf.Quote.QuoteLineItem><QuoteLineItem><Date>{QuoteLineItem.ServiceDate}</Date><TotalPrice>{QuoteLineItem.TotalPrice}</TotalPrice></QuoteLineItem></ListOf.Quote.QuoteLineItem></ListOf.Opportunity.Quote></Quote></ListOf.Account.Opportunity></Opportunity></Account>';
        
        Map<String, String> lookupMappings = new Map<String, String>();
        lookupMappings.put('Account.Opportunity', 'AccountId');
        lookupMappings.put('Opportunity.Quote', 'OpportunityId');
        lookupMappings.put('Quote.QuoteLineItem', 'QuoteId');
        
        String res = DocumentTemplateMapper.createXml(objectMap, test, lookupMappings);
        
        Boolean isContinue = true;
        Integer currentSubstring = 0;
        Integer nextSubstring = 200;
        while(isContinue){
            if(nextSubstring < res.length()){
                System.debug(res.substring(currentSubstring, nextSubstring));
                currentSubstring += 200;
                nextSubstring += 200; 
            }
            else{
                isContinue = false;
                System.debug(res.substring(currentSubstring, res.length()));
            }
            
        }
        
        System.Test.stopTest();   
    }
}