/**  
 * Test Class for the KnowledgeTrigger
 * @author	Rudolf Niehaus - CloudSmiths
 * @since	2018-11-02	
 */
@isTest
public class KnowledgeTriggerTest {
    
    static testMethod void testKnowledgeTrigger() {
        
        Profile profile = [Select Id From Profile Where Name='System Administrator'];
        
        User user = new User(FirstName = 'User7', LastName= 'Lastname7', Email='KnowledgeUser7@test.com', 
                             Phone='111-111-1111', alias = 'know', EmailEncodingKey='UTF-8', ProfileId = profile.Id, 
                             LanguageLocaleKey='en_US', LocaleSidKey='en_US', TimeZoneSidKey='America/Los_Angeles', 
                             UserName = 'KnowledgeUser@test777.com', IsActive = true);
        insert user;
        
        Knowledge__kav article = new Knowledge__kav(Title = 'testDoc123', 
                                                    UrlName = 'Test-Email-Template-temp',
                                                    Summary = 'Testing');
        insert article;
        
        Test.startTest();
		
        List<Knowledge__kav> articleList = [Select Id, ValidationStatus, AssignedToId, Assigned_User__c 
                                            From Knowledge__kav limit 1];
        
        if(!articleList.isEmpty()){
			
            articleList[0].ValidationStatus = 'Work In Progress';
            articleList[0].Assigned_User__c = user.Id;
            update articleList[0];
            
            System.assertEquals(articleList[0].AssignedToId , articleList[0].Assigned_User__c);
        }

        Test.stopTest(); 

    }
}