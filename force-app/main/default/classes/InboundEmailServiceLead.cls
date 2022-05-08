/**
* @description The custom email for the call center - leads specific.
*
* @author  Kyle Alexander - CloudSmiths
* @since   2020-03-03
*
*/

global class InboundEmailServiceLead implements Messaging.InboundEmailHandler {
    /**
     * @description exception
     */
     public class CustomException extends Exception {}
     /**
      * @description handleInboundEmail description
      *
      * @param email (Messaging.InboundEmail): email
      * @param envelope (Messaging.InboundEnvelope): envelope
      * @return Return Messaging.InboundEmailResult: Return description
      */
     global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {

     /*    System.debug(LoggingLevel.FINE, 'InboundEmailService Running');
         System.debug(LoggingLevel.FINE, '-------------------------------------------------');
         System.debug(LoggingLevel.FINE, 'Headers : ' + email.headers);
         System.debug(LoggingLevel.FINE, 'From Address : ' + email.fromAddress);
         System.debug(LoggingLevel.FINE, 'From Name : ' + email.fromName);
         System.debug(LoggingLevel.FINE, 'To Addresses : ' + email.toAddresses);
         System.debug(LoggingLevel.FINE, 'CC Addresses : ' + email.ccAddresses);
         System.debug(LoggingLevel.FINE, '-------------------------------------------------');*/

         Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();

         String threadId = null;
         String externalReferenceNumber = null;
         Id leadId = null;

         //Variable to carry all email addresses copied
         Set<String> copiedAdresses = new Set<String>();
         if(email.toAddresses != null){
            copiedAdresses.addAll(email.toAddresses);
         }

         if(email.ccAddresses != null){
            copiedAdresses.addAll(email.ccAddresses);
         }

         //Call method to extract the Thread Id from the Email Subject/Body
         threadId = 'ref:' + EmailThreadId.getThreadId(email) + ':ref';
       //  System.debug('*** threadId' + threadId);

         //Call method to get

        boolean skipResponse = false;

        //Use std Case method to find the related case for the thread id
        //If the threadId belongs to a Case in a different or, the exception will
        //throw
         if(String.isNotBlank(threadId)) {
             try{
                 //Cases.getCaseIdFromEmailThreadId(threadId);
               //  System.debug('*** threadId' + threadId);
                 Lead lead = [SELECT Id FROM Lead WHERE Lead_Thread_Id__c = :threadId];
             }catch(Exception e){

                 email.subject = email.subject.replace('ref:'+threadId+':ref',' ');
                 threadId = null;
                 skipResponse = true;
             }
         }

         //Call method to avoid loops - if the From Email Address is one of the OWD Email Addresses
        if(String.isBlank(threadId)){

            if(EmailRuleEngine.isSenderOrgWideEmailAddress(email.fromAddress)){

                try {
                    throw new CustomException('The Email sender used a restricted From email address : ' + email.fromAddress + ' - The Email was ignored');
                }catch(CustomException e) {
                    return result;
                }
            }
        }

         // If we get an error, we need to rollback the whole process and disply friend message to users
        SavePoint sp = Database.setSavepoint();

         try{

             //Make instance of the rule engin data class
             EmailRuleEngine.RuleData ruleData = new EmailRuleEngine.RuleData();

           //  System.debug('###ruleData : ' + ruleData);

             if( String.isNotBlank(threadId) ){
                 try{
                   //  System.debug('*** threadId ' + threadId);
                     leadId = [SELECT Id FROM Lead WHERE Lead_Thread_Id__c = :threadId].Id;
                 }
                 catch(Exception e){
                    return null;
                 }
             }

             if(leadId == null){

                ruleData = EmailRuleEngine.findMatchingRule( email ,skipResponse, 'Lead');
               //  system.debug('ruleData.leadId'+ruleData);
                if( ruleData.hasMathingRule ){

                    if(ruleData.ruleType == 'Routing_Rule' || ruleData.ruleType == 'Classify_Rule'){
                        //if(ruleData.leadId!=null)//added newly by pranav for STI
                        if(string.isNotBlank(ruleData.leadId)){
                      //  system.debug('rule data'+ruleData.leadId);
                        leadId = ruleData.leadId;
                        }
                    }
                    EmailRuleEngine.updateTriggerCount( ruleData.ruleId );

                }else{
                    	Database.rollback(sp);

                    try{
                        throw new CustomException('No configuration and no default email rule found for the Shared Email address : ' + email.toAddresses + ' : The Email was ignored');
                    }catch(CustomException e) {
                        return result;
                    }
                }
             }

             if(ruleData.ruleType != 'Blocking_Rule' && String.isNotBlank(leadId)){

                // System.debug('In not Blocking Rule : ' + leadId);
                 // changed this logic to below by pranv for DD STI functionality

                 //-----added newly by pranav for Direct delivery STI sunctionality
                 String s1 = String.valueof(leadId);

                 if(s1.startsWith('00Q'))
                 	EmailCreateLead.createEmailMessage(email, envelope, leadId, 'Lead');
                 else
                 	EmailCreateLead.createEmailMessage(email, envelope, leadId, 'Case');
                 //-----pranav changes end
             }
         }catch(Exception e){

            Database.rollback(sp);

           // System.debug('Custom Email Handler Exception : ' + e.getMessage() + ' -> at line ' + e.getStackTraceString());

            result.message = /*'Custom Email Handler Exception : ' + e.getMessage() + ' -> at line ' + e.getStackTraceString()+*/
                'Your email to the ASBA Customer Support Center could not be processed due to a technical error.' +
                'Please wait a few minutes and resend the email.  '+
                'Please accept our apologies for any inconvenience caused.';

            return result;
        }

         return result;
     }
}