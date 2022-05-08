@isTest
public class ProductSummaryControllerTest {
    
    public static testMethod void testProductSummary(){
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        
        Test.startTest();
        
        ProductSummaryController.getTotalQuoteData(testDataFactory.testOpportunity.id);
        ProductSummaryController.getQuoteLineItemsData(testDataFactory.testOpportunity.id);
        ProductSummaryController.getBeneficiaryData(testDataFactory.testOpportunity.id);
        ProductSummaryController.getDependantData(testDataFactory.testOpportunity.id);
        ProductSummaryController.getMainLifeData(testDataFactory.testOpportunity.id);
        ProductSummaryController.getSpouseData(testDataFactory.testOpportunity.id);
        
        Test.stopTest();
    }
}