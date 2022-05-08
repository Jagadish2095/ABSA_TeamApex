@isTest
public class LiquidityCalculatorControllerTest {
    
    public static testMethod void testLiquidityCalculator(){
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        
        Test.startTest();
        
        LiquidityCalculatorController.saveFinancialNeedsAnalysis(testDataFactory.testFna, testDataFactory.testOpportunity.id);
        LiquidityCalculatorController.saveShortFinancialNeedsAnalysis(testDataFactory.testFna, testDataFactory.testOpportunity.id);
        LiquidityCalculatorController.getLatestFinancialNeedsAnalysis(testDataFactory.testOpportunity.id);
        LiquidityCalculatorController.getselectOptions(testDataFactory.testFna, 'Life_Policies_Action__c');
        String recorType = LiquidityCalculatorController.getOpportunityRecordType(testDataFactory.testOpportunity.id);
        
        Test.stopTest();
    }
}