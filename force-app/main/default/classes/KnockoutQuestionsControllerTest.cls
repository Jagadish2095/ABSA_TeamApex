@isTest(SeeAllData=true)
public class KnockoutQuestionsControllerTest {
    
    public static testMethod void testFetchKnockoutQuestions(){
        Test.startTest();
        string questionList = KnockoutQuestionsController.fetchKnockoutQuestions('Knockout');
        Test.stopTest();
        
        System.assert(questionList.length() > 0);
    }
    
}