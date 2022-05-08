@isTest
public class CloseScreenControllerTest {
    
    public static testMethod void testCloseScreen(){
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        
        Test.startTest();
        
        CloseScreenController.getDeclarationData(testDataFactory.testOpportunity.id);
        CloseScreenController.checkInitValidity(testDataFactory.testOpportunity.id);
        CloseScreenController.checkIfShowWrningMessage(testDataFactory.testOpportunity.id);
        
        List<Clause__c> clauses = new List<Clause__c>();
        clauses.add(testDataFactory.testClause);
        CloseScreenController.saveDeclarationData(testDataFactory.testOpportunity.id, clauses);
        
        testDataFactory.testOpportunity.Application_Status__c = 'Valid';
        update testDataFactory.testOpportunity;
        CloseScreenController.checkInitValidity(testDataFactory.testOpportunity.id);
        
        testDataFactory.testOpportunity.CASA_Status__c = 'Valid';
        update testDataFactory.testOpportunity;
        CloseScreenController.checkInitValidity(testDataFactory.testOpportunity.id);
        
        Test.stopTest();
    }
}