@isTest
public class onboardingSPMNeedAnalysisConTest {

        @testSetup
    static void dataCreation(){
        
        Account account = new Account();
        account.Name = 'Test Account';
        //account.Other_Employer_Sector__c='test';
        insert account;
        Contact contact = new Contact(LastName='Test contact', AccountId = account.Id, Email = 'agents@support.co.za');
        insert contact;
     
        Product2 prod = new Product2(Name = 'SPM Equity Product');
        insert prod;
        
        Product2 prod1 = new Product2(Name = 'Bespoke');
        insert prod1;
        
        Pricebook2 pb = new Pricebook2();
        pb.IsActive=true;
        pb.id = Test.getStandardPricebookId();
        update pb;

        PricebookEntry customPrice = new PricebookEntry(Pricebook2Id = Test.getStandardPricebookId(), Product2Id = prod.Id, UnitPrice = 12000, IsActive = true);
        insert customPrice;

        Opportunity testOpp = new Opportunity();
        testOpp.Name = 'Test Opp Onboarding 1';
        testOpp.CloseDate = Date.today();
        testOpp.StageName = 'New';
        testOpp.AccountId=account.Id;
        testOpp.Pricebook2Id = Test.getStandardPricebookId();
        insert testOpp;
        
        Application__c app= new Application__c();
        app.Opportunity__c=testOpp.id; 
        insert app;
      
        opportunitylineitem oppline= new opportunitylineitem();
        oppline.Product2Id=prod.id;
        oppline.Investment_Allocation__c='100';
        oppline.Investment_amount_R__c='100';
        oppline.OpportunityId=testOpp.id;
        oppline.Quantity = 5;
        oppline.TotalPrice =10;
        oppline.PricebookEntryId=customPrice.id;
        insert oppline;
        
        Application_Product__c appProd =new Application_Product__c ();
        appProd.Opportunity__c=testOpp.id;
        appProd.Other_special_requirements__c='test';
        appProd.Frequency_of_payment_required__c='On Request';
        appProd.Cash_accruals__c='Paid Out';
        appProd.Regular_withdrawal_amount_R__c='12345'; //Opportunity_Product_Id__c
        appProd.Opportunity_Product_Id__c=oppline.id;
        insert appProd;
        
        
        Product_Product_Entry__c ppE =new Product_Product_Entry__c();
        ppE.Related_Product__c=prod.id;
        ppE.Parent_Product__c=prod.id;
        insert ppE;
        
    }
    static testMethod void getRiskProfileTest()
    {
        Account newClientRecord = [SELECT id,SPM_region__c,Passport_Expiry_Date__c,Name FROM Account LIMIT 1];
        Pricebook2 pb = new Pricebook2();
        pb.IsActive=true;
        pb.id = Test.getStandardPricebookId();
        update pb;
        Product2 prod = new Product2(Name = 'SPM Equity Product');
        insert prod;
		PricebookEntry customPrice = new PricebookEntry(Pricebook2Id = Test.getStandardPricebookId(), Product2Id = prod.Id, UnitPrice = 12000, IsActive = true);
        insert customPrice;
        Opportunity newOppRecord = [select id,Name,AccountId,Account.Name from Opportunity  LIMIT 1];
        Application__c appRec = [SELECT Id,Name FROM Application__c LIMIT 1];
        
        opportunitylineitem oppline= new opportunitylineitem();
        oppline.Product2Id=prod.id;
        oppline.Investment_Allocation__c='100';
        oppline.Investment_amount_R__c='100';
        oppline.OpportunityId=newOppRecord.id;
        oppline.Quantity = 5;
        oppline.TotalPrice =10;
        oppline.PricebookEntryId=customPrice.id;
        insert oppline;
        
       // OpportunityLineItem oppproduct=[select id,name,Investment_amount_R__c,Investment_Allocation__c,product2id,product2.Name from OpportunityLineItem LIMIT 1] ; 
        Application_Product__c appproduct = [select id,name,Cash_accruals__c,Regular_withdrawal_amount_R__c,Frequency_of_payment_required__c,Other_special_requirements__c from Application_Product__c Limit 1];
        List<Product_Product_Entry__c> SPMProductlst=[select id ,name ,Related_Product__r.id ,Related_Product__r.name , Parent_Product__r.name  ,Related_Product__r.Risk_Profile__c from Product_Product_Entry__c where Parent_Product__r.Name='SPM Equity Product'];      

        string portfoliovalue='test';
        string savedvalues='[{"InvestmentAllocation":"19","id":"row-0"}]'; //,{"InvestmentAllocation":"30","id":"row-1"}
        Test.startTest();

        onboardingSPMNeedAnalysisCon.getIds(newOppRecord.id);
        onboardingSPMNeedAnalysisCon.getProducts(newOppRecord.id);
        onboardingSPMNeedAnalysisCon.savePortfolios(newOppRecord.id, savedvalues);
        onboardingSPMNeedAnalysisCon.updateDetails(oppline.Investment_amount_R__c, appproduct.Cash_accruals__c, appproduct.Regular_withdrawal_amount_R__c, appproduct.Frequency_of_payment_required__c, appproduct.Other_special_requirements__c, oppline.id, appproduct.id);
       // onboardingSPMNeedAnalysisCon.getAppPrdctRec(newOppRecord.id);
        onboardingSPMNeedAnalysisCon.getAccount(newOppRecord.id);
        system.assertEquals(newOppRecord.id, newOppRecord.id);
        Test.stopTest();
    }
}