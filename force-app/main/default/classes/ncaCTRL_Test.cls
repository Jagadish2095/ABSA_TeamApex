@isTest
public class ncaCTRL_Test { 
    @testSetup
    static void dataCreation(){
        Account account = new Account();
        account.Name = 'Test Account';
        insert account;
        Contact contact = new Contact(LastName='Test contact', AccountId = account.Id, Email = 'agents@support.co.za');
        insert contact;
        Opportunity testOpp = new Opportunity();
        testOpp.Name = 'Test Opp Credit Onboarding';
        testOpp.CloseDate = Date.today();
        testOpp.StageName = 'New';
        testOpp.AccountId=account.Id;
        // testOpp.Site__c='Test';
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
        insert oppLineItem;
        
        Application_Product_Credit__c apc = new Application_Product_Credit__c ();
        apc.Annual_Turnover__c = 110;
        apc.Asset_Value__c = 2000;
        apc.Opportunity__c = testOpp.Id;
        apc.Opportunity_Product_Id__c = oppLineItem.OpportunityId;
        
        insert apc;
        
        Application__c app= new Application__c();
        app.Opportunity__c=testOpp.id;     
        insert app;
        
    }
    static testMethod void getAPplicationProductCreditPositiveTest()
    {
        Account newClientRecord = [SELECT id, Name FROM Account LIMIT 1];
        Opportunity newOppRecord = [SELECT Id,Name FROM Opportunity LIMIT 1];
        Application__c applicationRecord = [SELECT Id,Name FROM Application__c LIMIT 1];
        OpportunityLineItem oppLine = [SELECT Id,Name FROM OpportunityLineItem LIMIT 1];
        Application_Product_Credit__c appC = [SELECT Id,Name FROM Application_Product_Credit__c LIMIT 1];
        Test.startTest();
        
        try{
            
            Application_Product_Credit__c appCredList = ncaCTRL.getApplicationProductCredit(newOppRecord.Id);
            
        }catch(Exception e){
            System.debug('Exception::'+e.getMessage());
        }
        Test.stopTest();
        
    }
    static testMethod void getApplicationProductCreditNegativeTest()
    {
        Account newClientRecord = [SELECT id, Name FROM Account LIMIT 1];
        Opportunity newOppRecord = [SELECT Id,Name FROM Opportunity LIMIT 1];
        Application__c applicationRecord = [SELECT Id,Name FROM Application__c LIMIT 1];
        OpportunityLineItem oppLine = [SELECT Id,Name FROM OpportunityLineItem LIMIT 1];
         Application_Product_Credit__c appC = [SELECT Id,Name FROM Application_Product_Credit__c LIMIT 1];
        Test.startTest();
        
       delete appC;
            ncaCTRL.getApplicationProductCredit(newOppRecord.Id);
           // Application_Product_Credit__c appCredList = ncaCTRL.getApplicationProductCredit(newOppRecord.Id);
         try{    
        }catch(Exception e){
            System.debug('Exception::'+e.getMessage());
        }
        Test.stopTest();
    }
    static testMethod void updateAPCpositive()
    {
        Opportunity newOppRecord = [SELECT Id,Name FROM Opportunity LIMIT 1];
        Application_Product_Credit__c appC = [SELECT Id,Name FROM Application_Product_Credit__c LIMIT 1];
        
        Test.startTest();
        appC.Annual_Turnover__c = 100000.0;
        appC.Client_Operates_Under_Existing_Franchise__c = true;
        appC.Credit_Agreement_at_Arms_Length__c = true;
        appC.Any_Juristic_Trustees__c = 'Yes';
        appC.Client_State__c = 'Yes';
        appC.Asset_Value__c = 200000.00;
        appC.Client_State__c = 'No';
        appC.Number_or_Trustees__c = 20.0;
        appC.Opportunity_Product_Id__c = newOppRecord.Id;
        appC.Part_of_Enterprise_Development_Fund__c = true;
        
        String response;
     
       response = ncaCTRL.updateNCAsection(true, 12345,'Yes', 100, 2000, 'Yes', true,false,newOppRecord.Id);

        try{
            upsert appC;
		         }
        catch(Exception e)
        {
         response = 'ERROR';
        }
        Test.stopTest();
    }
}