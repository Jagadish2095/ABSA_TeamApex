/**
* @author: Koketso Mpshane
* @dateCreated: 27/09/2019 - Created EmailRequestService Class to create cases and email messages related to robotics mailboxes
* @Methods:
**/
public class EmailRequestService {
    
    public static Case newcase;
    
    public class EmailRequest{
        public String fromAddress {get;set;}
        public String toAddress {get; set;}
        public String ccAddress {get; set;}
        public String bccAddress {get; set;}
        public String subject {get; set;}
        public String content {get; set;}
        public List<AttachmentFiles> attachments {get; set;}
    } 
    
    public class RequestStatus{
        public Boolean isSuccess{ get;set; }
        public String errorMsg { get; set; }
    }
    
    public class AttachmentFiles{
        public String attachmentName { get;set; }
        public Blob attachmentFile { get; set; }
    }
    
    /*
    * @method getResponseStatus - returns RequestStatus type, results to show whether json received was processed succeessfully or not 
    * @param String requestBody - json received via api
    * @param Boolean sendEmail - check whether to send email or not
    */
    public static RequestStatus getResponseStatus(String requestBody, Boolean sendEmail){
        
        EmailRequest emailReq = (EmailRequest)JSON.deserialize(requestBody, EmailRequest.class);
        RequestStatus reqStatus = new RequestStatus();
        
        try {
            
            String caseId = createCaseRecord(emailreq);
            system.debug(LoggingLevel.FINE, 'caseId:'+caseId);
            if(caseId != null){
                reqStatus.isSuccess = true; 
                reqStatus.errorMsg = '';
                
                if(sendEmail){
                    Messaging.SendEmailResult emailResult = sendClientEmail(newcase.Id, emailreq);
                    system.debug(LoggingLevel.FINE, 'emailResult:'+emailResult);
                    if(emailResult.success){
                        reqStatus.isSuccess = true; 
                        reqStatus.errorMsg = ''; 
                    }else{
                        reqStatus.isSuccess = false;
                        reqStatus.errorMsg = emailResult.errors[0].message;
                    }
                }
                createCaseEmailMessage(caseId, emailreq);
            }else{
                reqStatus.isSuccess = false; 
                reqStatus.errorMsg = 'Failed to create case, configuration not done for this mail address.';
            }
            
        }catch(Exception ex){
            reqStatus.isSuccess = false;
            reqStatus.errorMsg = reqStatus.errorMsg+'; '+ex.getMessage();
        }
        return reqStatus;
    }
    
    public static String createCaseRecord(EmailRequest emailreq){
        
        newcase = new Case();
        String caseId;
        
        List<Service_Group__c> serviceGroups; 
        List<Group> queues = new List<Group>();
        
        Set<String> emailAddresses = new Set<String>();
        emailAddresses.add(emailreq.fromAddress);
        
        try {
            
            List<Shared_Email__c> sharedEmails = new SharedEmailsSelector().selectByToAddressesWithEmailRules(emailAddresses);
            
            if(sharedEmails.size() > 0){
                Shared_Email__c sharedEmail = sharedEmails[0];
                
                if(sharedEmail.Shared_Email_Rules__r.size() > 0){
                    Shared_Email_Rule__c sharedEmailRule = sharedEmail.Shared_Email_Rules__r[0];
                    List<Email_Rule__c> emailRules = new EmailRulesSelector().selectSharedEmailDefaultWithRelatedInfo(sharedEmailRule.Email_Rule__c);
                    
                    if(emailRules.size() > 0){
                        Set<Id> serviceGroupIds = new Set<Id>();
                        serviceGroupIds.add(emailRules[0].Route_To_Queue__c);
                        
                        serviceGroups = new ServiceGroupsSelector().selectById(serviceGroupIds);
                        system.debug(LoggingLevel.FINE,'**serviceGroups**:'+serviceGroups);
                        
                        if(serviceGroups.size() > 0){
                            newcase.Origin = 'Email';
                            newcase.Subject = emailreq.subject;
                            newcase.Description = emailreq.content;
                            newcase.Email_From_Address__c = emailreq.fromAddress;
                            newcase.Email_From_Name__c = emailreq.fromAddress;
                            newcase.Client_Feedback__c = 'None';
                            newcase.sd_Original_Service_Queue__c = serviceGroups[0].Queue__c;
                            newcase.sd_Original_Service_Group__c = serviceGroups[0].Name;
                            newcase.sd_Service_Group__c = serviceGroups[0].Name;
                            newcase.sd_Service_Group_Id__c = serviceGroups[0].Id;
                            newcase.sd_Response_Email_Address__c = serviceGroups[0].Response_Email_Address__c;
                            newcase.sd_Inbox_Name__c = emailreq.fromAddress;
                            
                            queues = new GroupsSelector().selectByNameAndType(serviceGroups[0].Queue__c, 'Queue');
                            if(queues.size() > 0){
                                newcase.OwnerId = queues[0].Id;
                            }
                            
                            RecordType caseRecordType = [Select Id, Name From RecordType Where Name =:serviceGroups[0].Assign_Record_Type__c And sObjectType =:'Case'];
                            system.debug(LoggingLevel.FINE, 'caseRecordType:'+caseRecordType);
                            
                            if(caseRecordType != null){
                                newcase.RecordTypeId = caseRecordType.Id;
                            }
                            
                            insert newcase;
                            
                            if(newcase.Id != null){
                                caseId = newcase.Id;
                            }
                        }
                    }
                } 
            }
            
        }catch(Exception ex){
            system.debug(LoggingLevel.FINE,'**createCaseRecord-Exception**:'+ex);
        }
        
        return caseId;
    }
    
    public static void createCaseEmailMessage(Id caseId, EmailRequest emailreq){
        
        //Create new Email Message and link to Case with all attachments
        EmailMessage emailmsg = new EmailMessage();
        emailmsg.FromAddress = emailreq.fromAddress;
        emailmsg.FromName = emailreq.fromAddress;
        if(emailreq.ccAddress != null){
            emailmsg.CcAddress = emailreq.ccAddress;
        }
        if(emailreq.toAddress != null){
            emailmsg.ToAddress = emailreq.toAddress; 
        }
        emailmsg.Incoming = true;
        emailmsg.ThreadIdentifier = caseId;
        emailmsg.TextBody = emailreq.content;
        emailmsg.HtmlBody = emailreq.content;
        emailmsg.MessageDate = System.now();
        emailmsg.ParentId = caseId;
        emailmsg.Subject = emailreq.subject;
        
        try{
            insert emailmsg;
            
            if (emailreq.attachments.size() > 0) {
                List<Attachment> attList = new List<Attachment>();
                List<ContentVersion> contentList = new list<ContentVersion>();
                List<ContentDocumentLink> docLinks = new List<ContentDocumentLink>();
                List<Id> contentIds = new List<Id>();
                
                for(AttachmentFiles ob: emailreq.attachments) {
                    ContentVersion cv = new ContentVersion();
                    cv.title = String.valueOf(ob.attachmentName);
                    cv.versionData = ob.attachmentFile;
                    cv.pathOnClient = ob.attachmentName;
                    contentList.add(cv);
                    
                    Attachment att = new Attachment();
                    att.Body = ob.attachmentFile;
                    att.ParentId = emailmsg.Id;
                    att.Name = String.valueOf(ob.attachmentName);
                    att.IsPrivate = false;
                    attList.add(att);
                }
                
                Database.SaveResult[] attToInsert = Database.insert(attList, false);
                Database.SaveResult[] contentToInsert = Database.insert(contentList, false);
                
                for (Database.SaveResult sr : contentToInsert){
                    if (sr.isSuccess()) {
                        contentIds.add(sr.getId());
                    }else {
                        for(Database.Error err : sr.getErrors()) {
                            system.debug(LoggingLevel.FINE,'**ContentVersion Error**:'+err.getMessage());
                        }
                    }
                }
                
                if(contentIds.size() > 0){
                    for(ContentVersion cv :[Select ContentDocumentId From ContentVersion Where Id in:contentIds]){
                        ContentDocumentLink docLink = new ContentDocumentLink();
                        docLink.ContentDocumentId = cv.ContentDocumentId;
                        docLink.LinkedEntityId = caseId;
                        docLink.ShareType = 'I';
                        docLinks.add(docLink);
                    }
                    insert docLinks; 
                }
            }
        }catch(Exception ex){
            system.debug(LoggingLevel.FINE,'**Exception err**:'+ex.getMessage());
        }
        
    }
    
    public static Messaging.SendEmailResult sendClientEmail(Id caseId, EmailRequest emailreq){
        
        List<String> toAddresses = new List<String>();
        List<String> ccAddresses = new List<String>();
        List<String> bccAddresses = new List<String>();
        Messaging.SendEmailResult emailResult;
        
        if(emailReq.toAddress != null){
            toAddresses = emailReq.toAddress.split(';');
        }
        
        if(!String.isBlank(emailReq.ccAddress)){
            ccAddresses = emailReq.ccAddress.split(';');
        }
        
        if(!String.isBlank(emailReq.bccAddress)){
            bccAddresses = emailReq.bccAddress.split(';');
        }
        List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        
        email.setReplyTo(emailReq.fromAddress);
        email.setSenderDisplayName(emailReq.fromAddress);
        email.toAddresses = toAddresses;
        
        if(!ccAddresses.isEmpty()){
            email.ccaddresses = ccAddresses; 
        }
        if(!bccaddresses.isEmpty()){
            email.bccaddresses = ccAddresses; 
        }
        
        email.subject = emailReq.subject;
        
        String htmlbody = emailReq.content;
        email.htmlBody = htmlbody;
        
        //create email attachments
        List<Messaging.EmailFileAttachment> fileAttachments = new List<Messaging.EmailFileAttachment>();
        
        for(EmailRequestService.AttachmentFiles afile: emailReq.attachments){
            Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
            efa.setFileName(afile.attachmentName);
            efa.setBody(afile.attachmentFile);
            fileAttachments.add(efa); 
        }
        
        email.fileAttachments = fileAttachments;
        emailList.add(email);
        
        try {
            List<Messaging.SendEmailResult> emailResults = Messaging.sendEmail(emailList);
            emailResult = emailResults[0];
        }catch(Exception ex){
            system.debug(LoggingLevel.FINE,'**Email Exception**:'+ex);
        }
        
        return emailResult;
    }
    
}