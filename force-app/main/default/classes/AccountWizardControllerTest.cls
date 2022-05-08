@isTest
public class AccountWizardControllerTest {
    
    public static testMethod void testAccountWizard(){
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();

        Test.startTest();
        
        AccountWizardController.createAccount(testDataFactory.testOpportunity.Id, testDataFactory.testAccount);
        
        testDataFactory.testAccount.CIF__c = null;
        update testDataFactory.testAccount;
        
        AccountWizardController.createAccount(testDataFactory.testOpportunity.Id, testDataFactory.testAccount);
        
        Test.stopTest();
    }
    
}