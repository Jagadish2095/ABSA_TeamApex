/**  
 * @Purpose      : Test Class for SitesServiceFeedbackCont
 * @Author       : Dreamwares 
 * @Created Date : 07/09/2018
 */
@isTest
public class SitesServiceFeedbackContTest {
    /*
     * Purpose : Method to create test data
     */
    @testSetup
    static void dataCreation(){
        //Added Rakesh Byri Test Class Failing because of Validation Rule
        Contact con = new Contact(Title='ContactTest',Phone='87837743123456769',LastName='ContactTest');
        insert con;
        Case caseRec0 = new Case(Communication_Method__c = 'Phone', Status = 'New', Origin = 'Email', Type__c = 'abc', Subtype__c = 'xyz');
        insert caseRec0;
    	Case caseRec = new Case(ParentId=caseRec0.Id,Communication_Method__c = 'Phone', Status = 'Closed', Origin = 'Email', Type__c = 'abc', Subtype__c = 'xyz');
        insert caseRec;
    }
    
    //Method to test
    static testMethod void testSitesServiceFeedbackCont(){
        Case caseRec = [SELECT Id FROM Case LIMIT 1];
        
        Test.startTest();
        SitesServiceFeedbackCont controller = new SitesServiceFeedbackCont();
        controller.feedBack = 'None';
        controller.caseId = caseRec.Id;  
        controller.runOnLoad();
        Test.stopTest();
        
        Case testCase = [SELECT Id, Client_Feedback__c FROM Case WHERE Id =: caseRec.Id];
        System.assertEquals(testCase.Client_Feedback__c, 'None');
    }
}