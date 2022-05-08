/**  
 * @Purpose      : Test Class for KnowledgeFeedback
 * @Author       : Dreamwares 
 * @Created Date : 07/09/2018
 */
@isTest
public class KnowledgeFeedbackTest {
    /*
     * Purpose : Method to create test data
     */
    @testSetup
    static void dataCreation(){
    	Knowledge__kav article = new Knowledge__kav(Title='test', UrlName = 'Test-Email-Template-temp',
                                                   Summary	= 'Testing');
        insert article;
    }
    
    //Method to test
    static testMethod void testKnowledgeFeedback(){
        Test.startTest();
        KnowledgeFeedback instance = new KnowledgeFeedback();
		String cronExp = '0 0 23 * * ?'; 
        System.schedule('Test Knowledge Feedback', cronExp, instance); 
        Test.stopTest(); 
        List<KnowledgeArticle> articleList = [SELECT Id FROM KnowledgeArticle];
        System.assertNotEquals(0, articleList.size());
    }
}