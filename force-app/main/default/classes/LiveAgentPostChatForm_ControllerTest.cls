/**  
 * @Purpose      : Test Class for LiveAgentPostChatForm_Controller
 * @Author       : Dreamwares 
 * @Created Date : 07/09/2018
 */
@isTest
public class LiveAgentPostChatForm_ControllerTest {
    /*
     * Purpose : Method to create test data
     */
    @testSetup
    static void dataCreation(){
        LiveChatVisitor visitor = new LiveChatVisitor();
        insert visitor;
        
        LiveChatTranscript liveChatTrascript = new LiveChatTranscript(ChatKey = '123', LiveChatVisitorId = visitor.id, body = '<br>( 10s ) test: end<br>( 16s ) Lisa.Singh: cool<br>');
        insert liveChatTrascript;
    }
    
    //Method to test
    static testMethod void testLiveAgentPostChatForm_Controller(){
        Test.startTest();
        LiveAgentPostChatForm_Controller controller = new LiveAgentPostChatForm_Controller();
        controller.chatKey = '123';
        controller.satified = 'Thumbs Up';
        controller.updateTranscript();
        Test.stopTest();
        LiveChatTranscript lct = [SELECT Id, Client_Feedback__c FROM LiveChatTranscript];
       System.assertEquals(lct.Client_Feedback__c, 'Thumbs Up');
    }
}