@isTest
public class BeneficiaryManagementControllerTest {
    
    public static testMethod void testLiquidityCalculator(){
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        
        Test.startTest();
        BeneficiaryManagementController.getAllPartyData(testDataFactory.testOpportunity.id);//Added by Divya
        BeneficiaryManagementController.getOppRec(testDataFactory.testOpportunity.id);//Added by Divya
        BeneficiaryManagementController.insertOppPartyData(testDataFactory.testOpportunityPartyBeneficiaryList,testDataFactory.testOpportunityPartyDependantList);//Added by Divya
        BeneficiaryManagementController.getPartyData(testDataFactory.testOpportunity.id);
        BeneficiaryManagementController.getSingleParty(testDataFactory.testOpportunityPartyBeneficiary.id);
        BeneficiaryManagementController.createOpportunityParty(testDataFactory.testOpportunityPartyBeneficiary, testDataFactory.testOpportunity.id, false);
        BeneficiaryManagementController.updateOpportunityParty(testDataFactory.testOpportunityPartyBeneficiary, testDataFactory.testOpportunityPartyBeneficiary.id, false);
        BeneficiaryManagementController.checkNumberOpportunityParty(testDataFactory.testOpportunity.id);
        BeneficiaryManagementController.checkTotalBenefitSplit(testDataFactory.testOpportunity.id);
        BeneficiaryManagementController.checkDuplicateRecord(testDataFactory.testOpportunity.id, testDataFactory.testOpportunityPartyBeneficiary);
        BeneficiaryManagementController.removeOpportunityParty(testDataFactory.testOpportunityPartyBeneficiary.id);
        BeneficiaryManagementController.getselectOptions(testDataFactory.testFna, 'Life_Policies_Action__c');

        Test.stopTest();
    }
    
    public static testMethod void testLiquidityCalculatorNegative(){
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        
        Test.startTest();
        
        BeneficiaryManagementController.createOpportunityParty(testDataFactory.testOpportunityPartyBeneficiary, testDataFactory.testOpportunity.id, true);
        BeneficiaryManagementController.updateOpportunityParty(testDataFactory.testOpportunityPartyBeneficiary, testDataFactory.testOpportunityPartyBeneficiary.id, true);
        BeneficiaryManagementController.removeOpportunityParty(testDataFactory.testOpportunity.id);
        BeneficiaryManagementController.removeBeneficiaryParty(testDataFactory.testOpportunityPartyBeneficiary.id, 'Flexi Funeral');//added by Divya
        
        Test.stopTest();
    }
}