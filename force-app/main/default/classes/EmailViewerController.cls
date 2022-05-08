/**
* Controller for lightning component that views emails for salesforce mobile app
* @author  Kyle Alexander
* @created 2020-03-09
*/
public class EmailViewerController {
	/**
     * Method that gets the users record Id and links it to the task
     *
     * @param recId - user Id
     * @return Boolean - successful send or not
     */
    @AuraEnabled
    public static String fetchEmailBody(String recId) {
        EmailMessage message = [SELECT Id, TextBody FROM EmailMessage WHERE Id = :recId];
        return message.TextBody;
    }
    
    /**
     * Method that gets the email fields for replying
     *
     * @param recId - rec Id
     * @return EmailMessage - Email message with details
     */
    @AuraEnabled
    public static EmailMessage fetchEmailDetails(String recId) {
        EmailMessage message = [SELECT Id, FromName, FromAddress, ToAddress, Subject, MessageDate, TextBody, HtmlBody, CreatedDate, Lead__c, Lead__r.Lead_Thread_Id__c FROM EmailMessage WHERE Id = :recId LIMIT 1];
        return message;
    }
    
    /**
     * Method that gets the email fields for replying
     *
     * @param recId - rec Id
     * @return EmailMessage - Email message with details
     */
    @AuraEnabled
    public static Lead fetchNewEmailDetails(String recId) {
        Lead l = [SELECT Id, sd_Response_Email_Address__c, Email, Lead_Thread_Id__c FROM Lead WHERE Id = :recId LIMIT 1];
        return l;
    }
    
    /**
     * Method that gets a list of all specific emails
     * 
     * @param oppId - matter Id
     */
	@AuraEnabled 
    public static List<EmailMessage> getData(Id recId) {
        List<EmailMessage> emailMessages = [SELECT Id, FromName, FromAddress, Subject, MessageDate, TextBody, HasAttachment FROM EmailMessage WHERE Lead__c = :recId ORDER BY CreatedDate desc];
        
        String sfdcURL = URL.getSalesforceBaseUrl().toExternalForm() + '/'; 
        for(EmailMessage em : emailMessages){
            em.FromName = sfdcURL + em.Id; 
        }
        
        return emailMessages;
    }
    
    /**
     * Method that gets a list of all specific attachements
     * 
     * @param oppId - matter Id
     */
	@AuraEnabled 
    public static List<Attachment> getDataAtt(Id recId) {
        
        List<Attachment> cvList = [SELECT Id, Name, ContentType, CreatedDate, Description FROM Attachment WHERE ParentId = :recId Order By createddate desc];
        for(Attachment cv : cvList){
            cv.Description = URL.getSalesforceBaseUrl().toExternalForm() + '/' + cv.Id;
        }
        
        return cvList;
    } 
        
    @AuraEnabled 
        public static void sendMailMethod(String toAddress, String fromAddress, String mSubject, String mbody, String emailLeadId, String[] cdIds){
        
        List<Messaging.SingleEmailMessage> mails =  new List<Messaging.SingleEmailMessage>();     
        
        // Step 1: Create a new Email
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        // Step 2: Set list of people who should get the email
        List<String> sendTo = new List<String>();
        sendTo.add(toAddress);
        mail.setToAddresses(sendTo);
        
        // Step 3: Set who the email is sent from
        mail.setReplyTo(fromAddress); 
        
        // Step 4. Set email contents
        mail.setSubject(mSubject);
        mail.setHtmlBody(mbody);
        
        mail.setTargetObjectId(emailLeadId);
        mail.setTreatTargetObjectAsRecipient(false);
        mail.setSaveAsActivity(false); 
            
        // Step 5. Set file attachments
        if(cdIds.size() != 0){
            List<Messaging.EmailFileAttachment> attachments = new List<Messaging.EmailFileAttachment>();
            
            for(ContentVersion cversion : [SELECT title, PathOnClient, FileType, versiondata FROM contentversion WHERE ContentDocumentId IN :cdIds]){
                blob blbBody = cversion.versiondata;
                Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
                efa.setFileName(cversion.title + '.' + cversion.FileType);
                efa.setBody(blbBody);
                attachments.add(efa);
            }
            mail.setFileAttachments(attachments);  
        }

        // Step 6. Add your email to the master list
        mails.add(mail);

        if(!mails.isEmpty()){
            // Step 7: Send all emails in the master list
            Messaging.sendEmail(mails);
            
            List<EmailMessage> emailMsgList = new list<EmailMessage>();
            
            for(Messaging.SingleEmailMessage eachEmail : mails){
                
                //Create Email Message - to store on Lead
                EmailMessage emailMsg = new EmailMessage(); 
                
                emailMsg.FromAddress = fromAddress;
                emailMsg.ToAddress= (eachEmail.getToAddresses()[0]);
                emailMsg.Subject= eachEmail.getSubject();
                emailMsg.HtmlBody= eachEmail.getHtmlBody();
                emailMsg.Lead__c = eachEmail.getTargetObjectId();
                emailMsg.MessageDate = system.now();
                emailMsg.Status = '0';
                emailMsgList.add(emailMsg);
            }
            
            try{
                if(!emailMsgList.isEmpty()){
                    insert emailMsgList;
                    Lead l = [Select Id, Status, OwnerId From Lead Where Id = :emailLeadId LIMIT 1];
                    if(l.Status == 'Unallocated'){
                        l.Status = 'Allocated';
                    }
                    l.OwnerId = UserInfo.getUserId();
                    update l;
                }
            }catch(DMLException e){
                AuditTrailLog.logException(e, 'New', 'Warning', 'EmailViewerContoller', 'emailResponse', 'There was an error while inserting the Lead email message Task');
            }
        }
    }   
}