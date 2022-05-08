/**
 * @description EmailExternalReferenceNo description
* Reusable class to extract the Email Thread ID
* from Emails and finding the related Case
*
* @author  Tracy de Bruin - CloudSmiths
* @since   2018-06-14
*/
public class EmailExternalReferenceNo {
    
    /**
     * @description getExternalReferenceNo description
     *
     * @param email (Messaging.InboundEmail): email
     * @return Return String: Return description
     */
    public static String getExternalReferenceNo(Messaging.InboundEmail email) {
        
        String threadId;
        
        if( String.isNotBlank(email.subject)){
            threadId = extractExternalReferenceNo(email.subject);
        }

        //Only call extractEmailThreadId() method when Subject did not return a Thread Id
        if(threadId == null){
            
            if(String.isEmpty(email.htmlBody)) {
                
                threadId = extractExternalReferenceNo(email.plainTextBody);
                
            }else if (!String.isEmpty(email.htmlBody)){
                
                threadId = extractExternalReferenceNo(email.htmlBody);
            } 
        }
        System.debug('###threadId : ' + threadId);
        return threadId;
    }


    /**
@description getCaseNumber description
@param email (InboundEmail) : email
@return Return String : return CaseNumberFound
*/
    public static String getCaseNumber(Messaging.InboundEmail email) {

        String caseNumber;
		String CaseNumberFound = '';
		Pattern p = Pattern.compile('([C]+[-]+\\d{8})');

        if( String.isNotBlank(email.subject)){

		Matcher pm = p.matcher(email.subject);
		if( pm.find() )
    			CaseNumberFound = pm.group(1);
        }

        if(CaseNumberFound  == null || CaseNumberFound  == ''){

            if(String.isEmpty(email.htmlBody)) {
				Matcher pm = p.matcher(email.plainTextBody);
				if( pm.find() )
    				CaseNumberFound = pm.group(1);
            }else if (!String.isEmpty(email.htmlBody)){
                   Matcher pm = p.matcher(email.htmlBody);
				  if( pm.find() )
    				CaseNumberFound = pm.group(1);
            }
        }
        System.debug('###CaseNumberFound : ' + CaseNumberFound);
        return CaseNumberFound;
    }

    /**
     * @description findCaseByCaseNo description
     * @param caseNumber : String
     * @return Return Id : return caseId
*/
    public static Id findCaseByCaseNo( String caseNumber ) {

	System.debug(LoggingLevel.FINE,'caseNumberinfindCaseByCaseNo::'+caseNumber);

        Id caseId = null;

        if(Test.isRunningTest()){
            caseId = [Select Id From Case Limit 1].Id;
        }else{
            //Find Case with External Reference
            Case caseRecord = new CasesSelector().selectCasesByCaseNumber(caseNumber);
            if(caseRecord != null) {
                if(!caseRecord.IsClosed){
                    caseId = caseRecord.Id;
                }

            }
        }

        System.debug(LoggingLevel.FINE,'caseIdinfindCaseByCaseNo::'+caseId);
        return caseId;
    }

    /**
     * @description findCaseByExternalReferenceNo description
     *
     * @param externalRefNo (String): externalRefNo
     *@param returnOnlyIfOpen (Boolean): returnOnlyIfOpen
     * @return Return Id: Return description
     */
    public static Id findCaseByExternalReferenceNo( String externalRefNo, Boolean returnOnlyIfOpen ) {
        
		System.debug(LoggingLevel.FINE,'externalRefNo::'+externalRefNo);
        
        Id caseId;
        
        if(Test.isRunningTest()){
            caseId = [Select Id From Case Limit 1].Id;
        }else{
            //Find Case with External Reference
            List<Case> caseList = new casesSelector().selectByExternalReferenceNo(externalRefNo, 1);
            if(caseList != null && caseList.size() > 0) {
              caseId = caseList[0].Id; 
            }
        }
         
        System.debug(LoggingLevel.FINE,'caseId::'+caseId);
        //Find existing Case
        Set<Id> idSet = new Set<Id>();
        idSet.add(caseId);
        
        List<Case> existingCase = new CasesSelector().selectById(idSet);
        
        //Check if open or closed
        if(!existingCase.isEmpty()){
            
            if( !returnOnlyIfOpen ){
				 return caseId;
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
    
    /*TdB - CloudSmiths
    * Extract the external ID from the email subject
    * and body if no thread was found in the subject
    * @description extractExternalReferenceNo description 
    * @param String (emailString) : String
    * @return Return String : return externalReferenceNo
    */
    private static String extractExternalReferenceNo (String emailString) {
        
        //Get all Email Rules with Regex External Refernce Number Patterns
        List<Email_Rule__c> emailRulesList = new EmailRulesSelector().selectByExternalCaseReference();
        
        String patternString;
        Pattern regexPattern;
        Matcher regexMatch;
        String externalReferenceNo;
        
        if(String.isNotBlank(emailString)){
            
            if(emailString.length() > 800){
                emailString = emailString.substring(0,800);
            }
            System.debug(LoggingLevel.FINE,'emailString::'+emailString);
            
            for(Email_Rule__c eachRules : emailRulesList) {
                
                System.debug(LoggingLevel.FINE,'emailString::'+emailString);
                if(eachRules.Subject_Criteria__c != null) {
                     patternString = eachRules.Subject_Criteria__c;
                }else if (eachRules.Description_Criteria__c != null) {
                    patternString = eachRules.Description_Criteria__c;
                }
                if(String.isNotBlank(patternString)){
                    
                    regexPattern = Pattern.compile(patternString);
                    regexMatch = regexPattern.matcher(emailString);
                    
                    System.debug(LoggingLevel.FINE,'regexMatch::'+regexMatch);
                    //Find external ID
                    if(regexMatch.find()){
                        externalReferenceNo = regexMatch.group();
                        break;
                    }else{
                        externalReferenceNo = null;
                    }

                }
            }
        }
        
        return externalReferenceNo;
        
    }
    
}