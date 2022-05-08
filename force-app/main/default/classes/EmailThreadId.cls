/**
* Reusable class to extract the Email Thread ID
* from Emails and finding the related Case
*
* @author  Tracy de Bruin - CloudSmiths
* @since   2018-06-14
*/
public class EmailThreadId {
    
    /*TdB - CloudSmiths
    * Extract the thread ID from the email subject
    * and body if no thread was found in the subject
    * 
    * @param email InboundEmail
    * @return String
    */
    public static String getThreadId(Messaging.InboundEmail email) {
        
        String threadId;
        
        if( String.isNotBlank(email.subject)){
            threadId = extractEmailThreadId(email.subject);
        }

        //Only call extractEmailThreadId() method when Subject did not return a Thread Id
        if(threadId == null){
            
            if(String.isEmpty(email.htmlBody)) {
                
                threadId = extractEmailThreadId(email.plainTextBody);
                
            }else if (!String.isEmpty(email.htmlBody)){
                
                threadId = extractEmailThreadId(email.htmlBody);
            } 
        }
        
        return threadId;
    }

    /*RN - CloudSmiths
     * 
    * Find the existing Case based
    * on the thread ID of the Email and
    * if a Case is Open or Closed
    * 
    * @param threadId String
    * @param returnOnlyIfOpen Boolean
    * @return Id
    */
    public static Id findCaseByThreadId( String threadId, Boolean returnOnlyIfOpen, Messaging.InboundEmail email ) {
        
		System.debug(LoggingLevel.FINE,'threadId::'+threadId);
        
        Id caseId;
        
        if(Test.isRunningTest()){
            caseId = [Select Id From Case Limit 1].Id;
        }else{
            caseId = Cases.getCaseIdFromEmailThreadId(threadId);
        }
         
        System.debug(LoggingLevel.FINE,'caseId::'+caseId);
        
        List<Case> existingCase = new CasesSelector().selectByIdWithRecordTypeDeveloperName(caseId);
        
        //Check if open or closed
        if(!existingCase.isEmpty()){
            
            if( !returnOnlyIfOpen ){
                
                if(existingCase[0].RecordType.DeveloperName == 'Service_Request'){
					Service_Group__c serviceGroup = [Select Id, Open_New_Case__c From Service_Group__c Where Id =:existingCase[0].sd_Service_Group_Id__c];
                    if(existingCase[0].IsClosed && serviceGroup.Open_New_Case__c == true && existingCase[0].Unwanted_Type__c == null ){

                        //Rudolf Niehaus: set the case id on the email class,
                        //we will use this to set it on the new case as a ref
                        List<String> caseIds = new List<String>();
                        caseIds.add(caseId);   
                        email.references = caseIds;

                        //null will force the process to create a new case
                        //even if we have a threadId as this case is closed
                        //and of type service request
                        return null;

                    }else{
                        return caseId;
                    }

                }else{
                    return caseId;
                } 

            }else{
				if(!existingCase[0].IsClosed && returnOnlyIfOpen ){ 
                	return caseId;
                }else{
                    return null;
                }
            }
        }else{
            return null;
        }
    }
    
    /*RN - CloudSmiths
    * Extract the thread ID from the email subject
    * and body if no thread was found in the subject
    * 
    * @param emailString String
    * @return String
    */
    private static String extractEmailThreadId (String emailString) {
        
        String patternString;
        Pattern regexPattern;
        Matcher regexMatch;
        
        if(String.isNotBlank(emailString)){
            emailString = emailString.stripHtmlTags();
            //Error handling to handle complex Regex limits error. You cannot catch this error
            //but you can prevent it by checking the size of the string you pass through to the matcher
            if(emailString.length() > 800){
                emailString = emailString.substring(0,800);
            }
            System.debug(LoggingLevel.FINE,'emailString::'+emailString);
            patternString = '.*ref:(.+):ref.*';
            regexPattern = Pattern.compile(patternString);
            regexMatch = regexPattern.matcher(emailString);
            
            System.debug(LoggingLevel.FINE,'regexMatch::'+regexMatch);
     
            //Found a ThreadId?
            if(regexMatch.find()){
                return regexMatch.group(1);
            }else{
                return null;
            }
        }else{
           return null; 
        }
    }
}