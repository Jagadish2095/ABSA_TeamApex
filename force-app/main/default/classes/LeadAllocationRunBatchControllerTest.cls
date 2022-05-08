@isTest
public class LeadAllocationRunBatchControllerTest {
    
    @isTest
    static void runLeadAllocationRunBatchTest(){

        ApexPages.StandardSetController stdSetController;

        LeadAllocationRunBatchController cont = new LeadAllocationRunBatchController(stdSetController);
        cont.redirect();
    }
}