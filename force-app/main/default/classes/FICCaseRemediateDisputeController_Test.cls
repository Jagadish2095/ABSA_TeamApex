@isTest
public class FICCaseRemediateDisputeController_Test {
    
    static testMethod void testMethod1(){
        
        Case caseInTest = new Case(Account_Application_In_Order__c = true, Proof_Of_Address_In_Order__c = false, Proof_Of_Identification_In_Order__c = true, Signing_Instructions_in_Order__c = false, status = 'new', subject = 'test');
        insert caseInTest;
        
        
        String caseId = caseInTest.Id;
        FICCaseRemediateDisputeCaseController.getCase(caseId);
        
        FICCaseRemediateDisputeCaseController.updateDisputeCase( caseInTest,'Return' );
        FICCaseRemediateDisputeCaseController.enrouteCase(caseInTest, 'FIC Maintenance');
        Case caseFromTest = [SELECT Status FROM case WHERE ID =:caseId  Limit 1];
       
        System.assertEquals('New', caseFromTest.Status, 'old');
    }
}