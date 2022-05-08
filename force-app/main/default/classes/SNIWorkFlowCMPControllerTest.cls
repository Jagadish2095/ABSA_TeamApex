@isTest
public class SNIWorkFlowCMPControllerTest {
   @isTest 
    public static void SNIWorkflowTest(){
        Opportunity testOpp = new Opportunity();
        testOpp.Name = 'Test Opp';
        testOpp.CloseDate = Date.today();
        testOpp.StageName = 'Drafting';
        insert testOpp;
        
        Test.startTest();
        SNIWorkFlowCMPController.updateOpp(testOpp.Id);
        Test.stopTest();
    } 

}