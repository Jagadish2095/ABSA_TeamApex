/**
* Page controller for LiveAgentPostChatForm
*
* @author  Deshan Pillay - CloudSmiths
* @since   2018-08-16
*/
public class LiveAgentPostChatForm_Controller {
    
    public String satified {get;set;}
    public String chatKey {get;set;}
    public Boolean surveyCompleted {get;set;}
        
    public LiveAgentPostChatForm_Controller(){
        surveyCompleted = false;
    }
    
    /**
    * Updates the chat transcript
    * This method locates the LiveChatTranscript using the ChatKey(Unique identifier) on the post chat page.  
    * It updates the LiveChatTranscript with the reponse details. 
    */
    public void updateTranscript(){
        LiveChatTranscript lct = [SELECT Id, ChatKey, Client_Feedback__c FROM LiveChatTranscript WHERE ChatKey =:chatKey];
        lct.Client_Feedback__c = satified;
        update lct;
        
        surveyCompleted = true;
    }

}