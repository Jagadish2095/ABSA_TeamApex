@isTest
public class AppScreenControllerTest {
    
    public static testMethod void testAppScreenController(){
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        
        EPP_Pricing_Matrix__c eppPM = new EPP_Pricing_Matrix__c();
        eppPM.Sum_Insured__c = 2500;
        eppPM.Funeral_Plan_Member__c = 'Spouse';
        insert eppPM;
        
        eppPM = new EPP_Pricing_Matrix__c();
        eppPM.Sum_Insured__c = 2500;
        eppPM.Funeral_Plan_Member__c = 'Stillbirths til 11 months';
        insert eppPM;
        
        eppPM = new EPP_Pricing_Matrix__c();
        eppPM.Sum_Insured__c = 2500;
        eppPM.Funeral_Plan_Member__c = 'Children aged 1-5';
        insert eppPM;
        
        eppPM = new EPP_Pricing_Matrix__c();
        eppPM.Sum_Insured__c = 2500;
        eppPM.Funeral_Plan_Member__c = 'Children aged 6-13';
        insert eppPM;
        
        eppPM = new EPP_Pricing_Matrix__c();
        eppPM.Sum_Insured__c = 2500;
        eppPM.Funeral_Plan_Member__c = 'Children aged 14-21';
        insert eppPM;
        
        Test.startTest();
        
        AppScreenController.getPartyData(testDataFactory.testOpportunity.id, 'Beneficiary');
        AppScreenController.getSingleParty(testDataFactory.testOpportunityPartyBeneficiary.Id);
        AppScreenController.checkNumberOpportunityParty(testDataFactory.testOpportunity.id);
        AppScreenController.checkIfFuneralBenefitTaken(testDataFactory.testOpportunity.id);
        AppScreenController.getSpouseDOB(testDataFactory.testOpportunity.id);
        AppScreenController.dependantValidity(testDataFactory.testOpportunity.id);
        AppScreenController.checkSpouseValidity(testDataFactory.testOpportunity.id);
        AppScreenController.checkTotalBenefitSplit(testDataFactory.testOpportunity.id);
        AppScreenController.checkDuplicateRecord(testDataFactory.testOpportunity.id, testDataFactory.testOpportunityPartyBeneficiary);
        AppScreenController.createOpportunityParty(testDataFactory.testOpportunityPartyBeneficiary, testDataFactory.testOpportunity.id);
        AppScreenController.updateOpportunityParty(testDataFactory.testOpportunityPartyBeneficiary, testDataFactory.testOpportunityPartyBeneficiary.id);
        AppScreenController.removeOpportunityParty(testDataFactory.testOpportunityPartyBeneficiary.id);
        AppScreenController.createOpportunityPartyDep(testDataFactory.testOpportunityPartyBeneficiary, testDataFactory.testOpportunity.id);
        AppScreenController.updateOpportunityPartyDep(testDataFactory.testOpportunityPartyDependant, testDataFactory.testOpportunity.id, testDataFactory.testOpportunityPartyDependant.Id);
        AppScreenController.removeOpportunityPartyDep(testDataFactory.testOpportunityPartyDependant.id);
        AppScreenController.getTotalBenefitSplit(testDataFactory.testOpportunity.id);
        AppScreenController.checkInitValidity(testDataFactory.testOpportunity.id);
        AppScreenController.checkDependantValidity(testDataFactory.testOpportunity.id);
        AppScreenController.checkValidity(testDataFactory.testOpportunity.id);
        AppScreenController.getselectOptions(testDataFactory.testFna, 'Life_Policies_Action__c');
        
        Opportunity_Party__c op = new Opportunity_Party__c(); 
        op = testDataFactory.testOpportunityPartyDependant;
        op.Relationship__c = 'Child';
        op.Id = null;
        insert op;
        AppScreenController.updateOpportunityPartyDep(op, testDataFactory.testOpportunity.id, op.Id);
        
        Test.stopTest();
    }
    
    public static testMethod void testEmailsSend(){
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        
        Test.startTest();
        
        //Send emails test
        AppScreenController.saveEmail(testDataFactory.testOpportunity.id, 'test@test.com');
        AppScreenController.saveAlternativeEmail(testDataFactory.testOpportunity.id, 'test@test.com');
        AppScreenController.getEmails(testDataFactory.testOpportunity.id);
        
        AppScreenController.saveAlternativeEmail(testDataFactory.testOpportunity.id, 'test@test.com');
        AppScreenController.saveAlternativeEmail(testDataFactory.testOpportunity.id, 'test@test.com');
        AppScreenController.saveAlternativeEmail(testDataFactory.testOpportunity.id, 'test@test.com');
        AppScreenController.saveAlternativeEmail(testDataFactory.testOpportunity.id, 'test@test.com');

        AppScreenController.getEmails(testDataFactory.testOpportunity.id);

        Test.stopTest();
    }
}