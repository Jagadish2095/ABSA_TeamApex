/*
Controller Test Class For BranchInterviewsController class
*
* @author  Clifford Willers : ABSA (IQ Business)
* @version v1.0
* @since   2021-04-09
*
*/
@isTest
public class BranchInterviewsControllerTest {
    @testSetup
    static void dataCreation(){
        Account account = new Account();
        account.ID_Number__pc = '9308305015082';
        account.FirstName = 'TestBranchInterviewsController';
        account.LastName = 'Tester';
        account.Gender__pc = 'Male';
        account.Date_Issued__pc = Date.today();
        account.Next_of_Kin_Last_Name__pc = 'Testing';
        account.Next_of_Kin_First_Name_s__pc = 'Testing';
        account.PersonOtherPhone='0834527788';
        insert account;
    }

    @isTest
    public static void getPausedInterviewsTest(){
        Account account = [SELECT Id FROM Account where FirstName = 'TestBranchInterviewsController' LIMIT 1];
        List<BranchInterviewsController.BranchPausedInterview> interviewList = new List<BranchInterviewsController.BranchPausedInterview>();

        Test.startTest();
        List<BranchInterviewsController.BranchPausedInterview> pausedInterviews = BranchInterviewsController.getPausedInterviews(account.Id);
        System.assertEquals(interviewList, pausedInterviews, '');
        Test.stopTest();
    }

    @isTest
    public static void getInterviewDetailsTest(){
        String testValue = '0Fo9E000002AHQsSAO';
        FlowInterviewLog interviewLog = new FlowInterviewLog();

        Test.startTest();
        FlowInterviewLog interviewDetails = BranchInterviewsController.getInterviewDetails(testValue);
        System.assertEquals(interviewLog, interviewDetails, '');
        Test.stopTest();
    }

    @isTest
    public static void deleteInterviewTest(){
        String testValue = '0Fo9E000002AHQsSAO';
        FlowInterview interview = new FlowInterview();
        Test.startTest();
        FlowInterview flowInterview = BranchInterviewsController.deleteInterview(testValue);
        System.assertEquals(flowInterview, interview, '');
        Test.stopTest();
    }

    @isTest
    public static void getFlowRecordRelationDetailTest(){
        BranchInterviewsController.BranchPausedInterview pausedInterview = new BranchInterviewsController.BranchPausedInterview();
        FlowRecordRelation flowRecordRelation = new FlowRecordRelation();

        Test.startTest();
        BranchInterviewsController.BranchPausedInterview flowInterview = BranchInterviewsController.getFlowRecordRelationDetail(pausedInterview, flowRecordRelation);
        System.assertEquals(flowInterview, pausedInterview, '');
        Test.stopTest();
    }

    @isTest
    public static void getFlowInterviewLogDetailTest(){
        BranchInterviewsController.BranchPausedInterview pausedInterview = new BranchInterviewsController.BranchPausedInterview();
        FlowInterviewLog flowInterviewLog = new FlowInterviewLog();

        Test.startTest();
        BranchInterviewsController.BranchPausedInterview flowInterview = BranchInterviewsController.getFlowInterviewLogDetail(pausedInterview, flowInterviewLog);
        System.assertEquals(flowInterview, pausedInterview, '');
        Test.stopTest();
    }
}