/**
* This is the PaymentFee Lightning Component Apex controller test class
*
* @author   Lulu Rankwe / Makgotso Lebajoa
* @created    2019/01/29
*/
@IsTest
public class DraftingFeeControllerTest {


    static testMethod void PositiveTestcheckPaymentPreferenceSetonApplication() {
        
        WillsTestDataFactory testDataFactory = new WillsTestDataFactory();
        Application__c application = WillsTestDataFactory.createApplication(testDataFactory.testOpportunity.Id);
        
        Test.startTest();
        
        DraftingFeeController.checkPaymentPreferenceSetonApplication(application.Id); 

        Test.stopTest();  

    }
    
    static testMethod void testCheckPaymentPreferenceSetTypeOnApplication() {
        
        WillsTestDataFactory testDataFactory = new WillsTestDataFactory();     
        Test.startTest();
        
        DraftingFeeController.checkPaymentPreferenceSetTypeOnApplication(testDataFactory.testOpportunity.Id);
        Test.stopTest(); 
        

    }
    
   static testMethod void testCheckBankingDetailsValidated() {
        
        Opportunity testOpportunity = WillsTestDataFactory.createOpportunity();
        //Submit Pending
        DraftingFeeController.submitDraftingFeeStatus(testOpportunity.Id, 'Pending');
        //Actual
        String result = new ApplicationsSelector().selectByOpportunityId(testOpportunity.Id).get(0).Drafting_Fee_Status__c;
        System.assertEquals('Valid', result);
        
        DraftingFeeController.checkBankingDetailsValidated(testOpportunity.Id);
        System.assertEquals(false, DraftingFeeController.checkBankingDetailsValidated(testOpportunity.Id));
        
    }
    
    
    
    static testMethod void testGetApplicationByOpportunityId() {
        
        Opportunity testOpportunity = WillsTestDataFactory.createOpportunity();
        //Submit Pending
        DraftingFeeController.submitDraftingFeeStatus(testOpportunity.Id, 'Pending');
        //Actual
        String result = new ApplicationsSelector().selectByOpportunityId(testOpportunity.Id).get(0).Drafting_Fee_Status__c;
        System.assertEquals('Valid', result);
        
        System.assert(DraftingFeeController.getApplicationByOpportunityId(testOpportunity.Id) != null);
        
    }
    
    static testMethod void submitApplication() {
        
        WillsTestDataFactory testDataFactory = new WillsTestDataFactory();
        Application__c application = WillsTestDataFactory.createApplication(testDataFactory.testOpportunity.Id);
        
        Test.startTest();
        
        Pricebook2 price = WillsTestDataFactory.getStandardPriceBook();   
        
        Product2 product = WillsTestDataFactory.createProduct('R0.00 - WAIVED (ABSA EXECUTOR)','WILL');
        PricebookEntry pricebookEntry = WillsTestDataFactory.createPriceBookEntry(price.Id, product.Id);
        DraftingFeeController.submitApplication(application.Id, 'Fees Waived');
        
        Product2 productEstate = WillsTestDataFactory.createProduct('R0.00 - ESTATE PROVIDER PLAN','WILL');
        PricebookEntry pricebookEntryEstate = WillsTestDataFactory.createPriceBookEntry(price.Id, productEstate.Id);
        DraftingFeeController.submitApplication(application.Id, 'Fees for Estate Provider Plan');   
        
        Product2 proExemStaff = WillsTestDataFactory.createProduct('R0.00 - EXEMPTED - STAFF','WILL');
        PricebookEntry pricebookExemStaff = WillsTestDataFactory.createPriceBookEntry(price.Id, proExemStaff.Id);
        DraftingFeeController.submitApplication(application.Id, 'Fees for Staff');  
        
        DraftingFeeController.submitApplication(application.Id, 'Fees Paid');
        
        
        Test.stopTest();  
        
    }
    
    static testMethod void testGetDraftingFeesList() {
        
        WillsTestDataFactory testDataFactory = new WillsTestDataFactory();
        DraftingFeeController.getSelectOptions(testDataFactory.testPaymentPlan, 'Method__c');
        
    }
    
    static testMethod void testSetBankingDetailsValidationStatus() {
        
        Opportunity testOpportunity = WillsTestDataFactory.createOpportunity();
        //Submit Pending
        DraftingFeeController.submitDraftingFeeStatus(testOpportunity.Id, 'Pending');
        //Actual
        String result = new ApplicationsSelector().selectByOpportunityId(testOpportunity.Id).get(0).Drafting_Fee_Status__c;
        System.assertEquals('Valid', result);
        
        DraftingFeeController.setBankingDetailsValidationStatus(testOpportunity.Id, 'Valid');
        List<Application__c> applicationsList = new ApplicationsSelector().selectByOpportunityId(testOpportunity.Id);
        if (!applicationsList.isEmpty()) {
            System.assertEquals(true, applicationsList.get(0).Drafting_Banking_Details_Validated__c);
        }
        
    }
    
    static testMethod void testCreatePricebookEntry() {
        WillsTestDataFactory testDataFactory = new WillsTestDataFactory();
        
        Product2 product = WillsTestDataFactory.createProduct('R0.00 - WAIVED (ABSA EXECUTOR)','WILL');  
        Pricebook2 price = WillsTestDataFactory.getStandardPriceBook();
        PricebookEntry pricebookEntry = WillsTestDataFactory.createPriceBookEntry(price.Id, product.Id);
        DraftingFeeController.createPricebookEntry(testDataFactory.testOpportunity.Id, product);
    }
    
    
    static testMethod void testDeleteOpportunityLineItems() {
        WillsTestDataFactory testDataFactory = new WillsTestDataFactory();
        
        Test.startTest();  
        DraftingFeeController.deleteOpportunityLineItems(testDataFactory.testOpportunity.Id);
        
        Test.stopTest();  
    }
    
    
    static testMethod void testUpdateApplication() {
        
        WillsTestDataFactory testDataFactory = new WillsTestDataFactory();
        
        Test.startTest();
        
        Pricebook2 price = WillsTestDataFactory.getStandardPriceBook();     
        Product2 product = WillsTestDataFactory.createProduct('R0.00 - WAIVED (ABSA EXECUTOR)','WILL');
        PricebookEntry pricebookEntry = WillsTestDataFactory.createPriceBookEntry(price.Id, product.Id);
        DraftingFeeController.updateApplication(testDataFactory.testOpportunity.Id, 'Fees Waived');
        
        
        Product2 productEstate = WillsTestDataFactory.createProduct('R0.00 - ESTATE PROVIDER PLAN','WILL');
        PricebookEntry pricebookEntryEstate = WillsTestDataFactory.createPriceBookEntry(price.Id, productEstate.Id);
        DraftingFeeController.updateApplication(testDataFactory.testOpportunity.Id, 'Fees for Estate Provider Plan');  
        
        
        Product2 proExemStaff = WillsTestDataFactory.createProduct('R0.00 - EXEMPTED - STAFF','WILL');
        PricebookEntry pricebookExemStaff = WillsTestDataFactory.createPriceBookEntry(price.Id, proExemStaff.Id);
        DraftingFeeController.updateApplication(testDataFactory.testOpportunity.Id, 'Fees for Staff');  
        
        
        DraftingFeeController.updateApplication(testDataFactory.testOpportunity.Id, 'Fees Paid');
        
        
        Test.stopTest();  
    }
    
    static testMethod void testSubmitDraftingFeeStatus() {
        
        Opportunity testOpportunity = WillsTestDataFactory.createOpportunity();
        List<Application__c> applicationsList = new ApplicationsSelector().selectByOpportunityId(testOpportunity.Id);
        
        DraftingFeeController.submitDraftingFeeStatus(testOpportunity.Id, 'Valid');
        
        String result = new ApplicationsSelector().selectByOpportunityId(testOpportunity.Id).get(0).Drafting_Fee_Status__c;
        System.assertEquals('Valid', result);
    }
    
    static testMethod void testGetSelectOptions() {
        WillsTestDataFactory testDataFactory = new WillsTestDataFactory();
        DraftingFeeController.getSelectOptions(testDataFactory.testPaymentPlan, 'Method__c');
    }
    
    static testMethod void testSubmitProductItem() {
        Opportunity testOpportunity = WillsTestDataFactory.createOpportunity();//getStandardPriceBook
        Pricebook2 price = WillsTestDataFactory.getStandardPriceBook();
        Product2 product = WillsTestDataFactory.createProduct('R1.725.00 - DISCOVERY/MOMENTUM CONSULT (EXTR EXEC)','WILL');
        PricebookEntry pricebookEntry = WillsTestDataFactory.createPriceBookEntry(price.Id, product.Id);
        DraftingFeeController.submitProductItem(testOpportunity.Id,product.Name,null,null) ;
    }
    
    static testMethod void testGetDraftingFeesDirectDebitList() {
        // Opportunity testOpportunity = WillsTestDataFactory.createOpportunity();
        DraftingFeeController.getDraftingFeesDirectDebitList() ;
    }
    
    static testMethod void testGetPersonAccountIDNumber() {
        Opportunity testOpportunity = WillsTestDataFactory.createOpportunity();
        DraftingFeeController.getPersonAccountIDNumber(testOpportunity.Id) ;
    }
    
    static testMethod void testSubmitPaymentPlanDetail() {
        Opportunity testOpportunity = WillsTestDataFactory.createOpportunity();
        DraftingFeeController.submitPaymentPlanDetail(testOpportunity.Id, '1573017159', 'Cheque', 'NEDBANK', '157342', 'PHUMULANI MALL TEMBIS (157342)', 'Cheque - 1573017159', 'Monthly', 100.00, '12345', 'Debit Order', 'New', 'Will Safe Custody Fee', 'AS PAID IN - AN AMOUNT (NOT LISTED)');
        DraftingFeeController.submitPaymentPlanDetail(testOpportunity.Id, '1573017159', 'Cheque', 'NEDBANK', '157342', 'PHUMULANI MALL TEMBIS (157342)', 'Cheque - 1573017159', 'Monthly', 100.00, '12345', 'Debit Order', 'New', 'Will Safe Custody Fee', 'AS PAID IN - AN AMOUNT (NOT LISTED)');
    }
    
    static testMethod void testselectByTypeByApplicationId(){
        Opportunity testOpportunity = WillsTestDataFactory.createOpportunity();
        Payment_Plan__c testPayPlan  = DraftingFeeController.selectByTypeByApplicationId(testOpportunity.Id, 'Will Safe Custody Fee');
    }    
    
    static testMethod void testGetDraftingFeesList2() {
        WillsTestDataFactory.createFinancialProduct('Will', 'Insure');
        Product2 product = WillsTestDataFactory.createProduct('R0.00 - WAIVED (ABSA EXECUTOR)','WILL');
        DraftingFeeController.getDraftingFeesList();
    }
    
    static testMethod void testExistsPaymentPlan() {
        Opportunity testOpportunity = WillsTestDataFactory.createOpportunity();
        DraftingFeeController.existsPaymentPlan(testOpportunity.Id, 'Fees Waived');
    }
    
    static testMethod void testExistsOpportunityLineItem() {
        Opportunity testOpportunity = WillsTestDataFactory.createOpportunity();
        DraftingFeeController.existsOpportunityLineItem(testOpportunity.Id);
    }
    
    /*static testMethod void testSelectByTypeByApplicationId() {
        
        WillsTestDataFactory testDataFactory = new WillsTestDataFactory();

        
        Application__c application = WillsTestDataFactory.createApplication(testDataFactory.testOpportunity.Id);

        DraftingFeeController.selectByTypeByApplicationId(application.Id,'Will Drafting Fee');

    }*/
    
  
    static testMethod void testCheckBankAccount() {
        DraftingFeeController.checkBankAccount('4048075451', '632005', 'Cheque');
    }
    
    static testMethod void testValidateAbsaBankAccount() {
        DraftingFeeController.validateAbsaBankAccount('4048075451', 'Cheque', '632005', '150.00');
    }
    
    @isTest
    static void testValidateAVSBankAccount() {
        new WillsTestDataFactory();
        Opportunity testOpportunity = [SELECT Id FROM Opportunity LIMIT 1];
        //new WimiTestDataFactory();
        //Opportunity testOpportunity = []
        Test.setMock(HttpCalloutMock.class, new AccountVerificationMock_ApiRest(StringConstants.POSITIVE_STRING));
        //Insert Integration Settings
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.ACCOUNT_VERIFICATION_DETAILS});
        IntegrationTestDataFactory.insertIntegrationTranslations();
        Test.startTest();
        DraftingFeeController.validateAVSBankAccount(testOpportunity.Id, '4048075451', '632005', 'ABSA BANK LIMITED', 'Savings');
        Test.stopTest();
    }
    
    static testMethod void testCheckIfBankIsOnAVSList() {
        Opportunity testOpportunity = WillsTestDataFactory.createOpportunity();
        DraftingFeeController.checkIfBankIsOnAVSList('NEDBANK');
    }
    
    static testMethod void testGetProductName() {
        Opportunity testOpportunity = WillsTestDataFactory.createOpportunity();
        DraftingFeeController.getProductName(testOpportunity.Id);
    }
    
    static testMethod void testcheckCASAValidity() {
        Opportunity testOpportunity = WillsTestDataFactory.createOpportunity();
        String casa = DraftingFeeController.checkCASAValidity(testOpportunity.Id);
    }
    
}