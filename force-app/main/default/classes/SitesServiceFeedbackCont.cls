/**
* Update cases based on the client's feedback sent back
* from the Close Case email template into a site
*
* @author  Rudolf Niehaus - CloudSmiths
* @since   2018-08-21
*/
public class SitesServiceFeedbackCont {
    
    public String caseId = '';
    public String feedBack = '';
    
    public SitesServiceFeedbackCont(){
        
        caseId = Apexpages.currentPage().getParameters().get('caseid');
        feedBack = Apexpages.currentPage().getParameters().get('feedback');
       
    }
    
    public void runOnLoad(){
		 
        Set<Id> idSet = new Set<Id>();
        idSet.add(caseId);
        
		//List<Case> feedbackCase = new CasesSelector().selectByIdForSitesUser(idSet, 1);
		
		//**** RN NOTE ***** - We do not use the selector layer here as it prevents a site guest user
		//from seeing cases with a Private OWD
		 
        List<Case> feedbackCase = [Select Id, Client_Feedback__c From Case Where Id = :caseId];
        
        if( !feedbackCase.isEmpty() ){
            
            feedbackCase[0].Client_Feedback__c = feedBack;
            
            try{
                
                update feedbackCase[0];
                
            }catch(DMLException ex){
                
                System.debug('There was an error updating a Case with the client feedback');
                System.debug('SitesServiceFeedbackCont -> updateCase -> update feedbackCase[0]');
                System.debug(ex.getMessage());
                
            } 
        }			
    }
}