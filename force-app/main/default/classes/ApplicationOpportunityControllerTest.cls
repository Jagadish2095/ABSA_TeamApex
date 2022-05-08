@isTest
public class ApplicationOpportunityControllerTest {
    
    public static testMethod void testApplicationOpportunityParties(){
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        
        Test.startTest();
        
        ApplicationOpportunityPartiesController.checkInitValidity(testDataFactory.testOpportunity.id);
        ApplicationOpportunityPartiesController.checkDependantValidity(testDataFactory.testOpportunity.id);
        ApplicationOpportunityPartiesController.checkValidity(testDataFactory.testOpportunity.id);
        
        testDataFactory.testOpportunityPartyBeneficiary.Benefit_Split__c = 1;
        update testDataFactory.testOpportunityPartyBeneficiary;
        
        ApplicationOpportunityPartiesController.checkValidity(testDataFactory.testOpportunity.id);
        
        Test.stopTest();
    }
}