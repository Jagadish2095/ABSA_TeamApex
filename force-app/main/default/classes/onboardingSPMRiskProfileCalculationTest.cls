/*
 * Testclass for onboardingSPMRiskProfileCalculation Class
 *
 * @author  Diksha Wasekar : Absa
 * @version v1.0
 * @since   2020-11-11
 * @modified Haritha P
 */
@isTest
public class onboardingSPMRiskProfileCalculationTest {
    
    @testSetup
    static void dataCreation(){
        Account account = new Account();
        account.Name = 'Test Account';
        //account.Other_Employer_Sector__c='test';
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
         Product2 prod = new Product2(Name = 'SPM Equity Product', Family = 'SPM',ProductCode = '19' );
        insert prod;
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

        
        Application__c app= new Application__c();
        app.Opportunity__c=testOpp.id; 
        app.What_is_the_intended_investment_term__c = ' B – Between 3 (Three) and 5 (five) years';                                           
        app.What_investment_experience_do_you_have__c = 'A – I have never invested';
        app.understand_financial_markets_and_investm__c = 'C – Good understanding';
        app.investment_opportunities__c = ' E – A return that can fluctuate between -11% and 31% p.a.'; 
        app.Number_of_dependants__c='D – 3';
        app.income_grow_in_relation_to_inflation__c='B – With inflation';
        app.liquidity_to_cover_emergencies__c='D – Definitely yes';
        app.Total_Score__c='Medium';
        
        insert app;
        Application_Product__c appPrdctRec=new Application_Product__c();
        appPrdctRec.Opportunity__c=testOpp.id;
        appPrdctRec.Opportunity_Product_Id__c=oli.Id;
      	appPrdctRec.Management_Type_Managed_Code__c  = 'Discretionary Account';
        appPrdctRec.Application_Source__c ='Platform';
        //appPrdctRec.Product_Wrapper__c = 'Endowment';
        //appPrdctRec.House_Portfolio__c = 'Balanced Portfolio';
        appPrdctRec.Independent_Financial_Advisor__c = 'test';
        appPrdctRec.PRI_Number__c ='12345';
        insert appPrdctRec;
    }
    @isTest
    public static void getApplicationProductsTest()
    {
        Account newClientRecord = [SELECT id,SPM_region__c,Passport_Expiry_Date__c,Name FROM Account LIMIT 1];
        Opportunity newOppRecord = [select id,Name,PRI_Number__c,Client_Or_Person_On_US_Citizenship__c,Complex_Application_Approval__c,Relationship_Manager__c,Portfolio_Manager__c,AccountId,Account.Name,Account.SPM_region__c,Account.Passport_Expiry_Date__c from Opportunity where AccountId=:newClientRecord.id   LIMIT 1];
        Application__c appRec = [SELECT Id,Product_Wrapper__c,House_Portfolio__c,Name,What_is_the_intended_investment_term__c,What_investment_experience_do_you_have__c,understand_financial_markets_and_investm__c,investment_opportunities__c,Number_of_dependants__c,income_grow_in_relation_to_inflation__c,liquidity_to_cover_emergencies__c FROM Application__c LIMIT 1];
        Application_Product__c appPrdctRec = [SELECT Id,Management_Type_Managed_Code__c,Independent_Financial_Advisor__c,Application_Source__c,PRI_Number__c FROM Application_Product__c LIMIT 1];
        List<OpportunityLineItem> OpportunityLineItemList = [SELECT Id FROM OpportunityLineItem WHERE OpportunityId =: newOppRecord.Id];
         list<Application_Product__c>   applicationProductList;
        if(OpportunityLineItemList.size() > 0){
           applicationProductList = [SELECT Id FROM Application_Product__c
                                      WHERE Opportunity_Product_Id__c =: OpportunityLineItemList[0].Id];
        }
        Test.startTest();
        
        
        Account acc = onboardingSPMRiskProfileCalculation.getAccount(newOppRecord.Id);
        onboardingSPMRiskProfileCalculation.getOpp(newOppRecord.Id);
       // onboardingSPMRiskProfileCalculation.getPortfolioManagerlist();
       // onboardingSPMRiskProfileCalculation.getRelationshipManagerlist();
        onboardingSPMRiskProfileCalculation.getWealthManagerlist();
        onboardingSPMRiskProfileCalculation.getFinancialInvestmentAdvisorlist();
         onboardingSPMRiskProfileCalculation.updateOppStage(newOppRecord.Id,true,true);
        onboardingSPMRiskProfileCalculation.updateOppStage(newOppRecord.Id,false,true);
        onboardingSPMRiskProfileCalculation.updateOppStage(newOppRecord.Id,false,false);
        Application__c app = onboardingSPMRiskProfileCalculation.getAppRec(newOppRecord.Id);
        if(applicationProductList.size() > 0){
            applicationProductList[0] = onboardingSPMRiskProfileCalculation.getAppPrdctRec(newOppRecord.Id); }
        onboardingSPMRiskProfileCalculation.getradiobtn(newOppRecord.Id);
       onboardingSPMRiskProfileCalculation.CalculateScore(newOppRecord.Id);
        string details = onboardingSPMRiskProfileCalculation.updateAppDetails(appRec.What_is_the_intended_investment_term__c, appRec.What_investment_experience_do_you_have__c,appRec.understand_financial_markets_and_investm__c,
                                          appRec.investment_opportunities__c, appRec.Number_of_dependants__c,appRec.income_grow_in_relation_to_inflation__c,
                                          appRec.liquidity_to_cover_emergencies__c,appRec.Id);
       onboardingSPMRiskProfileCalculation.updateAppRec('SPM','Apparent','Apparent',appRec.Id);
        onboardingSPMRiskProfileCalculation.updateAppPrdctRec(newOppRecord.Id,appPrdctRec.Management_Type_Managed_Code__c,acc.SPM_region__c,acc.Passport_Expiry_Date__c,appPrdctRec.Application_Source__c,appRec.Product_Wrapper__c,appRec.House_Portfolio__c,appPrdctRec.Independent_Financial_Advisor__c,appPrdctRec.PRI_Number__c,newOppRecord.Complex_Application_Approval__c);
      
        onboardingSPMRiskProfileCalculation.SendEmailforpassportExpiry(newOppRecord.Id);
        system.assertEquals(newOppRecord.Id, newOppRecord.Id);
        Test.stopTest();
        
    }
    
    
}