@IsTest
public class YYY_DummyIntegrationTestControllerTest {

    @isTest static void testExcecuteMakePostCalloutToSiebel(){
        
        YYY_DummyIntegrationTestController constructor = new YYY_DummyIntegrationTestController();
        Opportunity opp = new Opportunity();
        opp.Name = 'testOpp';
        opp.stageName = 'Closed Won';
        opp.CloseDate = Date.valueOf(System.now());
        insert opp;
        
        constructor.opportunityId = opp.Id;
        constructor.stageName = 'Closed Won';
        constructor.externalId = '1234';
        
        Test.startTest();
        constructor.excecuteMakePostCalloutToSiebel();
        Test.stopTest();
    }
    
    @isTest static void testExcecuteCreateOpportunities(){
        
        YYY_DummyIntegrationTestController constructor = new YYY_DummyIntegrationTestController();
        
        Test.startTest();
        constructor.excecuteCreateOpportunities();
        Test.stopTest();
    }
    
    /*@isTest static void testGetClientRiskProfile(){
        
        YYY_DummyIntegrationTestController constructor = new YYY_DummyIntegrationTestController();
        
        Test.startTest();
        constructor.getClientRiskProfile();
        Test.stopTest();
    }*/
    
    @isTest static void testGetBankClearanceCodes(){
        
        YYY_DummyIntegrationTestController constructor = new YYY_DummyIntegrationTestController();
        
        Test.startTest();
        constructor.getBankClearanceCodes();
        Test.stopTest();
    }
    
    @isTest static void testCheckDigitVerification(){
        
        YYY_DummyIntegrationTestController constructor = new YYY_DummyIntegrationTestController();
        
        Test.startTest();
        constructor.checkDigitVerification();
        Test.stopTest();
    }
    
    @isTest static void testGetOpportunities(){
        
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        
        YYY_DummyIntegrationTestController constructor = new YYY_DummyIntegrationTestController();
        
        Test.startTest();
        List<SelectOption> optionList = constructor.getOpportunities();
        Test.stopTest();
    }
    
    @isTest static void testGetStageNames(){
        
        YYY_DummyIntegrationTestController constructor = new YYY_DummyIntegrationTestController();
        
        Test.startTest();
        List<SelectOption> optionList = constructor.getStageNames();
        Test.stopTest();
    }
    
    @isTest static void testConstuctorWithParam(){
        
        //DH Needed for new leads validation rules
        Financial_Product__c testFinancialProduct = new Financial_Product__c(Name = 'Test', Product_Type__c = '', Business_Unit__c = 'Business Banking');
        insert testFinancialProduct;
        
        Lead testLead = new Lead();
        testLead.LastName = 'Doe';
        testLead.Status = 'New';//DH Need to pass validation rules
        testLead.Company = 'Doe';
        testLead.MobilePhone = '0123456789';  //DH Need to pass validation rules
        testLead.Financial_Product__c =testFinancialProduct.Id; //DH Need to pass validation rules
        
        insert testLead;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(testLead);
        
        YYY_DummyIntegrationTestController constructorWithParam = new YYY_DummyIntegrationTestController(sc);
    }
    
}