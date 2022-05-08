/**
* Apex class to create cases from uploaded emails 
* @author: Koketso Mpshane
* @date: 2020-05-07
**/
public class UploadEmailToCaseController {
    
    public String jsonEmailMessage { get; set; }
    public List<Case> casesToCreate { get; set; }
    //inner class that holds the message data
    public class EmailMessageData {
        public String fromName {get;set;}
        public String fromAddress {get;set;}
        public String subject {get; set;}
        public String body {get; set;}
        public List<String> toAddressess {get; set;}
        public List<AttachmentFiles> attachments {get; set;}
        
        public EmailMessageData(String name, String fromEmail, String emailSubject, String emailBody, List<String> recipients, List<AttachmentFiles> attachments){
            this.fromName = name;
            this.fromAddress = fromEmail;
            this.subject = emailSubject;
            this.body = emailBody;
            this.toAddressess = recipients;
            this.attachments = attachments;
        }
    }
    
    //inner class that holds the attachments
    public class AttachmentFiles{
        public String attachmentName { get;set; }
        public Blob attachmentFile { get; set; }
    }
    
    //Inner class that holds the rule and case data
    public class CaseRulesData {
        
        public String ruleId {get;set;}
        public Boolean hasMathingRule {get;set;}
        public String ruleType {get;set;}
        public Case caseRecord {get;set;}
        public Decimal retentionPeriod{get;set;}
        
        public CaseRulesData(){
            this.ruleId = '';
            this.hasMathingRule = false;
            this.ruleType = '';
            this.caseRecord = new Case();
            this.retentionPeriod = 0;
        }
    }
    
    public UploadEmailToCaseController() {
        
    }
    
    public PageReference uploadFiles(){
        
        system.debug(LoggingLevel.FINE, '**jsonEmailMessage**' + jsonEmailMessage);
        
        if(!String.isBlank(jsonEmailMessage)){
            
            Map<String, EmailMessageData> emailMessageMap = new Map<String, EmailMessageData>();
            List<String> emailSendersList = new List<String>();
            
            List<Object> msgObjList = (List<Object>)JSON.deserializeUntyped(jsonEmailMessage);       
            List<Map<String, Object>> msgObjMapList = new List<Map<String, Object>>();
            
            casesToCreate = new List<Case>();
            
            if(msgObjList.size() > 0){
                for(Object msg: msgObjList){
                    msgObjMapList.add((Map<String, Object>)msg);
                }
            }
            
            if(msgObjMapList.size() > 0){
                
                for(Map<String, Object> msgObj: msgObjMapList){
                    
                    String senderName = String.valueOf(msgObj.get('senderName'));
                    String senderEmail = String.valueOf(msgObj.get('senderEmail'));
                    String subject = String.valueOf(msgObj.get('subject'));
                    String body = String.valueOf(msgObj.get('body'));
                    
                    List<Object> recipientList = (List<Object>)msgObj.get('recipients');
                    List<String> toEmailAddresses = new List<String>();
                    
                    if(recipientList.size() > 0){
                        for(Object recipient: recipientList){
                            String recipientStr = JSON.serialize(recipient);
                            String emailAddress = recipientStr.subStringBetween('"email":"','",');
                            toEmailAddresses.add(emailAddress);
                        }
                    }
                    
                    List<Object> attachmentsList = (List<Object>)msgObj.get('attachments');
                    system.debug(LoggingLevel.FINE, '**attachmentsList**' + attachmentsList);
                    
                    if(attachmentsList.size() > 0){
                        for(Object attachment: attachmentsList){
                            system.debug(LoggingLevel.FINE, '**attachment**' + attachment);
                        }
                    }
                    
                    EmailMessageData messageData = new EmailMessageData(senderName, senderEmail, subject, body, toEmailAddresses, new List<AttachmentFiles>());
                    system.debug(LoggingLevel.FINE, '**messageDataTo**' + messageData.toAddressess);
                    if(senderEmail != null){
                        emailMessageMap.put(senderEmail, messageData);
                        emailSendersList.add(senderEmail);
                    }else{
                        emailMessageMap.put(senderName, messageData);
                        emailSendersList.add(senderName);
                    }
                    
                }
                
                try{
                    //Make instance of the rule engin data class
                    Set<String> newCaseIds = new Set<String>();
                    List<String> errorList = new List<String>();
                    
                    Map<String, CaseRulesData> rulesData = new Map<String, CaseRulesData>();
                    rulesData = findMatchingRules(emailMessageMap, emailSendersList);
                    
                    if(!rulesData.isEmpty()){
                        if(rulesData.values().size() > 0){
                            for(CaseRulesData crd: rulesData.values()){
                                casesToCreate.add(crd.caseRecord);
                            }
                        }
                    }
                    
                    if(casesToCreate.size() > 0){
                        Database.SaveResult[] newCaseRecords = Database.insert(casesToCreate, false);
                        
                        for (Database.SaveResult sr : newCaseRecords){
                            if (sr.isSuccess()) {
                                newCaseIds.add(sr.getId());
                            }else {
                                for(Database.Error err : sr.getErrors()) {
                                    errorList.add(err.getMessage());
                                }
                                system.debug(LoggingLevel.FINE, 'uploadFiles Errors:'+ errorList);
                            }
                        }
                        system.debug(LoggingLevel.FINE, 'newCaseIds:'+ newCaseIds);
                        if(newCaseIds.size() > 0){
                            List<Case> casesList = [Select Id, Subject, Description, Email_From_Address__c From Case Where Id in: newCaseIds];
                            createEmailMessages(emailMessageMap, casesList);
                        }
                        
                    }
                }catch(Exception e){
                    AuditTrailLog.logException(e,  'New', 'Error', 'UploadEmailToCaseController', 'uploadFiles', 'Unable to create new rule matching Case'); 
                    system.debug(LoggingLevel.FINE, 'UploadEmailToCaseController Errors:'+ e.getMessage());
                }
            }
        }else{
            
        }
        
        return null;
    }
    
    public static Map<String, CaseRulesData> findMatchingRules(Map<String, EmailMessageData> emailMap, List<String> emailSendersList) {
        
        Map<String, CaseRulesData> ruleDataMap = new Map<String, CaseRulesData>();
        
        for(String sender: emailSendersList){
            
            Set<Id> ruleIds = new Set<Id>();
            Set<String> emailToAddresses = new Set<String>(); 
            
            Map<String, Boolean> ruleWasFoundMap = new Map<String, Boolean>(); 
            Map<String, String> ruleTypeMap = new Map<String, String>();
            Map<String, String> serviceGroupIdMap = new Map<String, String>();
            Map<String, String> serviceTypeIdMap = new Map<String, String>();
            Map<String, String> defaultRuleIdMap = new Map<String, String>();
            Map<String, String> ruleIdMap = new Map<String, String>();
            Map<String, String> communicationPlanIdMap = new Map<String, String>();
            Map<String, Decimal> retentionMap = new Map<String, Decimal>();
            Map<String, String> absaSupportAddressMap = new Map<String, String>();
            
            emailToAddresses.addAll(emailMap.get(sender).toAddressess);
            
            List<Shared_Email__c> sharedEmails = new SharedEmailsSelector().selectByToAddressesWithEmailRules(emailToAddresses);
            
            system.debug(LoggingLevel.FINE, 'sharedEmails : ' + sharedEmails);
            if(sharedEmails.size() > 0){
                String absaSupportAddress = sharedEmails[0].Inbox_Address__c;
                absaSupportAddressMap.put(sender, absaSupportAddress);
                
                if(sharedEmails[0].Shared_Email_Rules__r.size() > 0) {
                    for(Shared_Email_Rule__c sharedRule :sharedEmails[0].Shared_Email_Rules__r){
                        ruleIds.add(sharedRule.Email_Rule__c);
                    }
                }
                
                List<Email_Rule__c> emailRules = new EmailRulesSelector().selectByIdWithRelatedInfo(ruleIds, 2000);
                system.debug(LoggingLevel.FINE, 'emailRules : ' + emailRules);
                for(Email_Rule__c rule :emailRules){
                    if(rule.Default_Email_Rule__c){
                        defaultRuleIdMap.put(sender, rule.Id); 
                    }
                    ruleWasFoundMap.put(sender, true); 
                    ruleTypeMap.put(sender, rule.RecordType.DeveloperName);
                    serviceGroupIdMap.put(sender, rule.Route_To_Queue__c);
                    retentionMap.put(sender, rule.Retention_Period_Hrs__c);
                    ruleIdMap.put(sender, rule.Id);
                    communicationPlanIdMap.put(sender, rule.sd_Communication_Plan__c);
                    
                    if(String.isNotBlank(rule.Service_Type__c)){
                        serviceTypeIdMap.put(sender, rule.Service_Type__c);
                    }
                    system.debug(LoggingLevel.FINE, '**serviceGroupIdMap:**' + serviceGroupIdMap);
                    /*Map<Integer, Boolean> operatorLogicMap = new Map<Integer, Boolean>();
//If there are rule criteria define check if it match. 
//If no criteria are define but there are a rule, then its a match
//and we rout the email to the related queue. 	

//Logic 1
if(String.isNotBlank(rule.From_Criteria__c) && String.isNotBlank(rule.From_Operator__c)){
operatorLogicMap.put(1, EmailRuleEngine.isMatch(rule.From_Operator__c, rule.From_Criteria__c, emailMap.get(sender).fromAddress, false)); 
}
//Logic 2
if(String.isNotBlank(rule.Subject_Criteria__c) && String.isNotBlank(rule.Subject_Operator__c)){
operatorLogicMap.put(2, EmailRuleEngine.isMatch(rule.Subject_Operator__c, rule.Subject_Criteria__c, emailMap.get(sender).subject, false)); 
}
//Logic 3
if(String.isNotBlank(rule.Description_Criteria__c) && String.isNotBlank(rule.Description_Operator__c)){
operatorLogicMap.put(3, EmailRuleEngine.isMatch(rule.Description_Operator__c, rule.Description_Criteria__c, emailMap.get(sender).body, false));
}

if(!operatorLogicMap.isEmpty()){

List<Boolean> criteriaMatchList = new List<Boolean>();

if(operatorLogicMap.containsKey(1) ){
if(operatorLogicMap.get(1)){
criteriaMatchList.add(true);
}else{
criteriaMatchList.add(false);
}
}

if(operatorLogicMap.containsKey(2) ){
if(operatorLogicMap.get(2)){
criteriaMatchList.add(true);
}else{
criteriaMatchList.add(false);
}
}

if(operatorLogicMap.containsKey(3) ){
if(operatorLogicMap.get(3)){
criteriaMatchList.add(true);
}else{
criteriaMatchList.add(false);
}
}


if(!criteriaMatchList.contains(false)){
ruleWasFoundMap.put(sender, true); 
ruleTypeMap.put(sender, rule.RecordType.DeveloperName);
serviceGroupIdMap.put(sender, rule.Route_To_Queue__c);
retentionMap.put(sender, rule.Retention_Period_Hrs__c);
ruleIdMap.put(sender, rule.Id);
communicationPlanIdMap.put(sender, rule.sd_Communication_Plan__c);

if(String.isNotBlank(rule.Service_Type__c)){
serviceTypeIdMap.put(sender, rule.Service_Type__c);
}
system.debug(LoggingLevel.FINE, '**serviceGroupIdMap:**' + serviceGroupIdMap);
break;
}

}*/
                    
                }//End EmailRules Loop
                system.debug(LoggingLevel.FINE, '**sender:**' + sender);
                system.debug(LoggingLevel.FINE, '**ruleWasFoundMap:**' + ruleWasFoundMap);
                system.debug(LoggingLevel.FINE, '**ruleWasFoundMap:**' + ruleWasFoundMap);
                if(ruleWasFoundMap.containsKey(sender)){
                    if(ruleWasFoundMap.get(sender)){
                        CaseRulesData crd = new CaseRulesData();
                        crd.ruleType = ruleTypeMap.get(sender);
                        crd.hasMathingRule = true;
                        crd.ruleId = ruleIdMap.get(sender);
                        
                        if(ruleTypeMap.get(sender) != 'Blocking_Rule' ){
                            crd.caseRecord = actionRule(emailMap.get(sender), serviceGroupIdMap.get(sender), serviceTypeIdMap.get(sender), ruleTypeMap.get(sender), communicationPlanIdMap.get(sender), absaSupportAddressMap.get(sender));
                        }else{
                            crd.retentionPeriod = retentionMap.get(sender);
                        } 
                        ruleDataMap.put(sender, crd);
                    }
                }
            }
            
        }
        return ruleDataMap;
    }
    
    private static Case actionRule(EmailMessageData email, String serviceGroupId, String serviceTypeId, String ruleType, String commPlanId, String absaSupportAddress){
        
        String serviceLevelId = '';
        List<Service_Group__c> serviceGroups = new List<Service_Group__c>();
        List<Service_Group_Type__c> serviceGroupTypes = new List<Service_Group_Type__c>();
        
        if(String.isNotBlank(serviceGroupId)){
            Set<Id> idSet = new Set<Id>();
            idSet.add(serviceGroupId);
            serviceGroups = new ServiceGroupsSelector().selectById(idSet);
        }
        
        if(String.isNotBlank(serviceTypeId)){
            Set<Id> idSet = new Set<Id>();
            idSet.add(serviceTypeId);
            serviceGroupTypes = new ServiceGroupTypesSelector().selectByServiceTypeWithGroupAndServiceInfo(idSet);
            if(String.isBlank(serviceLevelId) && !serviceGroupTypes.isempty()){
                serviceLevelId = serviceGroupTypes[0].Service_Level__c;                
            }
        }
        
        return createRuleMatchingCase(email, serviceGroups, serviceGroupTypes, serviceLevelId, ruleType, commPlanId, absaSupportAddress);
    }
    
    
    
    public static Case createRuleMatchingCase(EmailMessageData email, List<Service_Group__c> serviceGroups, List<Service_Group_Type__c> serviceTypes, String servicecLevelId, String ruleType, String commPlanId, String absaSupportAddress){
        
        if(serviceGroups.size() == 0 ){
            return new Case();
        }
        
        //Get the unique email message ID for duplicate email detection
        //String msgID = email.messageId;
        //msgID = msgID.removeEnd('>');
        //msgID = msgID.removeStart('<');
        
        Case newEmailCase = new Case();
        
        List<Group> queueIds = new List<Group>();
        
        try{
            
            Map<String, Schema.RecordTypeInfo> caseRecordTypeMap = Case.sObjectType.getDescribe().getRecordTypeInfosByName();
            
            newEmailCase.Origin = 'Email';
            newEmailCase.Subject = email.subject;
            newEmailCase.sd_Inbox_Name__c = absaSupportAddress;
            
            if(email.fromAddress != null){
                newEmailCase.Email_From_Address__c = email.fromAddress;
            }else{
                newEmailCase.Email_From_Address__c = email.fromName;
            }
            
            Set<String> fromEmailAddress = new Set<String>();
            fromEmailAddress.add(email.fromAddress);
            
            //Search email address based on Contact
            List<Contact> contactList = new ContactsSelector().selectByEmail(fromEmailAddress, 1);
            if(contactList.size() > 0) {
                newEmailCase.ContactId = contactList[0].Id;
                newEmailCase.AccountId = contactList[0].AccountId;
            } 
            
            //Search email address based on Client if no Contact with AccountId returned
            if(newEmailCase.AccountId == null || newEmailCase.ContactId == null){
                List<Account> accountList = new AccountsSelector().selectByEmail(fromEmailAddress, 1);
                if(accountList.size() > 0) {
                    newEmailCase.AccountId = accountList[0].Id;
                    
                    //Populate Contact if person Account
                    if(accountList[0].PersonContactId != null) {
                        newEmailCase.ContactId = accountList[0].PersonContactId;
                    }
                }
            }
            
            //This field is used in the auto response emails to the client.
            //In some instances this from name do not pull through in the mail object
            //We set this value then to client as it will then display on the email template as 
            //Dear Client, and not just a blank value 
            if(String.isNotBlank(email.fromName)) {
                newEmailCase.Email_From_Name__c = email.fromName;
            }else {
                newEmailCase.Email_From_Name__c = 'Client';
            }
            
            newEmailCase.Client_Feedback__c = 'None';
            newEmailCase.sd_Original_Service_Queue__c = serviceGroups[0].Queue__c;
            newEmailCase.sd_Original_Service_Group__c = serviceGroups[0].Name;
            newEmailCase.sd_Service_Group__c = serviceGroups[0].Name;
            newEmailCase.sd_Service_Group_Id__c = serviceGroups[0].Id;
            newEmailcase.sd_Communication_Plan_Id__c = commPlanId;
            newEmailCase.Description = email.body;
            newEmailCase.sd_Pause_Statuses__c = serviceGroups[0].Pause_Statuses__c;
            newEmailCase.BusinessHoursId = serviceGroups[0].Business_Hours__c;
            newEmailCase.sd_Email_Template_Case_Creation__c = serviceGroups[0].Email_Template_Case_Creation__c;
            newEmailCase.sd_Internal_SLA_Time_Measure__c = serviceGroups[0].Internal_SLA_Time_Measure__c;
            newEmailCase.sd_Internal_SLA_Units__c = serviceGroups[0].Internal_SLA_Units__c;
            newEmailCase.Internal_SLA_Notification_User__c = serviceGroups[0].Internal_SLA_Notification_User__c;
            newEmailCase.sd_Response_Email_Address__c = serviceGroups[0].Response_Email_Address__c;
            
            queueIds = new GroupsSelector().selectByNameAndType(serviceGroups[0].Queue__c, 'Queue');
            
            if(!queueIds.isEmpty()){
                newEmailCase.ownerId = queueIds[0].id;
            }           
            
            //Email of classified case values 
            if(ruleType != 'Classify_Rule' || serviceTypes.isEmpty() ){
                
                if(caseRecordTypeMap.containsKey(serviceGroups[0].Assign_Record_Type__c)){
                    newEmailCase.RecordTypeId = caseRecordTypeMap.get(serviceGroups[0].Assign_Record_Type__c).RecordTypeId;
                }
                
                String bhId = serviceGroups[0].Business_Hours__c;
                //use default if list is empty
                if(String.isBlank(bhId)){
                    bhId = [Select Id From BusinessHours Where IsDefault=true].Id;
                }
                
                Map<String, DateTime> slaDateMap = CaseTriggerFunctions.calculateSLADateTime(System.now(),bhId, serviceGroups[0].Internal_SLA_Time_Measure__c, Integer.valueOf(serviceGroups[0].Internal_SLA_Units__c));
                
                newEmailCase.Internal_SLA_Warning_Date__c = slaDateMap.get('slaWarningDate');
                newEmailCase.Internal_SLA_End_Date__c = slaDateMap.get('slaEndDate');
                List<Service_Level__c> defaultSLA = new  List<Service_Level__c>();
                
                //Use the default Service Level until the case is classified by an agent
                if(String.isBlank(servicecLevelId)){
                    defaultSLA = new ServiceLevelsSelector().selectDefaultServiceType();
                }else{
                    Set<Id> idSet = new Set<Id>();
                    idSet.add(servicecLevelId);
                    defaultSLA = new ServiceLevelsSelector().selectById(idSet);
                }
                
                if(!defaultSLA.isEmpty()){
                    newEmailCase.sd_Email_Template_Case_Classification__c = defaultSLA[0].Email_Template_Case_Classification__c;
                    newEmailCase.sd_Email_Template_Case_Closure__c = defaultSLA[0].Email_Template_Case_Closure__c;                       
                    newEmailCase.sd_External_SLA_Time_Measure__c = defaultSLA[0].External_SLA_Time_Measure__c;
                    newEmailCase.sd_External_SLA_Units__c = defaultSLA[0].External_SLA_Units__c;
                    newEmailCase.External_SLA_Notification_User__c = defaultSLA[0].External_SLA_Notification_User__c;
                    newEmailCase.sd_Max_SLA_Units__c = defaultSLA[0].Max_SLA_Units__c;
                    newEmailCase.sd_Max_SLA_Time_Measure__c = defaultSLA[0].Max_SLA_Time_Measure__c;
                    
                    //use default if list is empty
                    if(String.isBlank(bhId)){
                        bhId = [Select Id From BusinessHours Where IsDefault=true].Id;
                    }
                    
                    slaDateMap = CaseTriggerFunctions.calculateSLADateTime(System.now(), bhId, defaultSLA[0].External_SLA_Time_Measure__c, Integer.valueOf(defaultSLA[0].External_SLA_Units__c));
                    
                    newEmailCase.External_SLA_Warning_Date__c = slaDateMap.get('slaWarningDate');
                    newEmailCase.External_SLA_End_Date__c = slaDateMap.get('slaEndDate');
                    
                }
                
            }else if(ruleType == 'Classify_Rule' || !serviceTypes.isEmpty()){
                
                newEmailCase.sd_Email_Template_Case_Classification__c = serviceTypes[0].Service_Level__r.Email_Template_Case_Classification__c;
                newEmailCase.sd_Email_Template_Case_Closure__c = serviceTypes[0].Service_Level__r.Email_Template_Case_Closure__c;
                
                if(caseRecordTypeMap.containsKey(serviceTypes[0].Service_Type__r.Case_Record_Type__c)){
                    newEmailCase.RecordTypeId = caseRecordTypeMap.get(serviceTypes[0].Service_Type__r.Case_Record_Type__c).RecordTypeId;
                }
                
                newEmailCase.Type__c = serviceTypes[0].Service_Type__r.Type__c;
                newEmailCase.Subtype__c = serviceTypes[0].Service_Type__r.Subtype__c;
                newEmailCase.Product__c = serviceTypes[0].Service_Type__r.Product__c; 
                newEmailCase.sd_Service_Type__c = serviceTypes[0].Service_Type__r.Name;
                newEmailCase.sd_External_SLA_Time_Measure__c = serviceTypes[0].Service_Level__r.External_SLA_Time_Measure__c;
                newEmailCase.sd_External_SLA_Units__c = serviceTypes[0].Service_Level__r.External_SLA_Units__c;
                newEmailCase.External_SLA_Notification_User__c = serviceTypes[0].Service_Level__r.External_SLA_Notification_User__c;
                newEmailCase.sd_Service_Type_Id__c = serviceTypes[0].Id;
                
                String bhId = serviceGroups[0].Business_Hours__c;
                //use default if list is empty
                if(String.isBlank(bhId)){
                    bhId = [Select Id From BusinessHours Where IsDefault=true].Id;
                }
                
                Map<String, DateTime> slaDateMap = CaseTriggerFunctions.calculateSLADateTime(System.now(), bhId, serviceTypes[0].Service_Level__r.External_SLA_Time_Measure__c, 
                                                                                             Integer.valueOf(serviceTypes[0].Service_Level__r.External_SLA_Units__c));
                
                
                newEmailCase.External_SLA_Warning_Date__c = slaDateMap.get('slaWarningDate');
                newEmailCase.External_SLA_End_Date__c = slaDateMap.get('slaEndDate');
            }
            
        }catch (Exception e){
            
            AuditTrailLog.logException(e,  'New', 'Error', 'UploadEmailToCaseController', 'createRuleMatchingCase', 'Unable to create new rule matching Case'); 
            system.debug(LoggingLevel.FINE, 'UploadEmailToCaseController Error:'+ e.getMessage());
            
        }
        
        return newEmailCase;
    }
    
    public static EmailMessage createEmailMessages(Map<String, EmailMessageData> emailMessageMap, List<Case> casesList){
        
        Boolean isBodySizeOk = true;
        Boolean isLargeBodyOk = false; 
        Blob emailBodyBlob;
        
        List<EmailMessage> emailMessagesList = new List<EmailMessage>();
        Set<String> newMsgIds = new Set<String>();
        List<String> errorMsgList = new List<String>();
        
        for(Case cse: casesList){
            
            String fromAddress;
            
            if(cse.Email_From_Address__c == null){
                fromAddress = 'Client';
            }else{
                fromAddress = cse.Email_From_Address__c;
            }
            String originalToAddresses = '';
            List<String> toEmailList = emailMessageMap.get(fromAddress).toAddressess;
            String fromEmailAddress = emailMessageMap.get(fromAddress).fromAddress;
            String fromEmailName = emailMessageMap.get(fromAddress).fromName;
            String emailBody = emailMessageMap.get(fromAddress).body;
            String emailSubject = emailMessageMap.get(fromAddress).subject;
            
            if(toEmailList != null){
                if(toEmailList.size() > 0){
                    for(String toa: toEmailList){
                        originalToAddresses+= toa + ';';
                    }
                }
            }
            
            //Create new Email Message and link to Case with all attachments
            EmailMessage emsg = new EmailMessage();
            emsg.FromAddress = fromEmailAddress;
            emsg.FromName = fromEmailName;
            emsg.ToAddress = originalToAddresses;
            emsg.Incoming = true;
            emsg.ThreadIdentifier = cse.Id;
            
            //If the size of the email body is smaller than 32000 chr insert the value 
            //else add the body content as a file to the 
            
            if(isBodySizeOk){
                emsg.TextBody = emailBody;
                emsg.HtmlBody = emailBody;
                emailBodyBlob = Blob.valueOf(emailBody);
            }else{
                //add message so users know what we did behind the scenes
                emsg.TextBody = 'The body of this email was too large to process. Please click on the \'View Email Body\' link to view the original email';
                emailBodyBlob = Blob.valueOf(emailBody);
                
                if(isLargeBodyOk){
                    emsg.Large_Text_Body__c =  emailBody;
                }
            }
            emsg.MessageDate = System.now();
            emsg.Subject = emailSubject;
            emsg.ParentId = cse.Id;
            
            emailMessagesList.add(emsg);
        }//End case loop
        
        if(emailMessagesList.size() > 0){
            Database.SaveResult[] newMsgRecords = Database.insert(emailMessagesList, false);
            
            for (Database.SaveResult sr : newMsgRecords){
                if (sr.isSuccess()) {
                    newMsgIds.add(sr.getId());
                }else {
                    for(Database.Error err : sr.getErrors()) {
                        errorMsgList.add(err.getMessage());
                    }
                    system.debug(LoggingLevel.FINE, 'uploadFiles Errors:'+ errorMsgList);
                }
            }
            system.debug(LoggingLevel.FINE, 'newMsgIds:'+ newMsgIds);
        }
        //Now add all the email attachments as content files and Feeditems related to the case
        //Get the location id where the content must go
        
        //RN : we dont need this anymore, we add files as part of the chatter feed to the case
        //so the location ID is nie nodig nie
        //String libId = [Select Id, Name From ContentWorkspace Where Name = 'Case Email Files'].Id;
        
        /*if (email.binaryAttachments != null && email.binaryAttachments.size() > 0) {
            
            //Tonga MM: Altered method to insert attachment on email
            list<String> verIds = createContent(email.binaryAttachments,emsg.Id);
            createContentLink(verIds, parentId);
            //createFeedItem(verIds, CaseID);
        }
        
        //allways add the email body as an HTML att in order to have concistancy when we
        //display the email body in the console side panel.
        Attachment eBody = new Attachment();
        eBody.ContentType = 'application/html';
        eBody.Body = emailBodyBlob;
        eBody.ParentId = emsg.Id;
        eBody.Name = 'Email Body.html';
        eBody.IsPrivate = false;
        insert eBody;*/
        
        return null;
    }
    
    
}