@isTest
private class LightningFileUploadHandler_Test {
    
   @testSetup
    static void setupTestData() {
       // test.startTest();
        Case caseInTest = new Case(Account_Application_In_Order__c = true, Proof_Of_Address_In_Order__c = false, Proof_Of_Identification_In_Order__c = true, Signing_Instructions_in_Order__c = false, status = 'new', subject = 'test');
        insert caseInTest;
        

       // test.stopTest();
    }
    static testMethod void test_getFiles_UseCase1() {
        Case caseInTest = new Case(Account_Application_In_Order__c = true, Proof_Of_Address_In_Order__c = false, Proof_Of_Identification_In_Order__c = true, Signing_Instructions_in_Order__c = false, status = 'new', subject = 'test');
        insert caseInTest;
        List<Case> caseObj = [SELECT Id,IsEscalated from Case];
        System.assertEquals(true, caseObj.size() > 0, false);
        LightningFileUploadHandler obj01 = new LightningFileUploadHandler();
        LightningFileUploadHandler.getFiles(caseInTest.Id);
    }
    static testMethod void test_deleteFiles_UseCase1() {
        List<Case> caseObj = [SELECT Id,IsEscalated from Case];
        System.assertEquals(true, caseObj.size() > 0, false);
        LightningFileUploadHandler obj01 = new LightningFileUploadHandler();
        LightningFileUploadHandler.deleteFiles('test data');
    }
}