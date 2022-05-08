/******************************************************
 *
 * Author : Tracy de Bruin
 * @description : createRuleMatchingCase
 * 14/06/2018 - TdB -
 * ***************************************************
 *
 * Modified By : Tonga MM
 * Description : Added the ability to add attachments
 * onto emails so they too can be forwarded
 * ***************************************************/
public class EmailCreateCase {

    public static Case newEmailCase;
    public static Boolean isOriginalEmail;


    /** RN - CloudSmiths
    * Creat new case
    * <p>
    * Creat a new case based on a mathing rule
    * 1 - Routing Rule
    * 2 - Classification Rule
    * 3 - Bocking Rule
    * @description createRuleMatchingCase description
    * @param email (InboundEmail)  : email
    * @param serviceGroup (List<Service_Group__c>) : serviceGroup
    * @param serviceType (List<Service_Group_Type__c>) : serviceType
    * @param servicecLevelId (String) : servicecLevelId
    * @param ruleType (String) : Ruletype
    * @param absaSupportAddress (String) : absaSupportAddress
    * @param skipResponse (boolean) :skipResponse
    * @param referenceType (String) : referenceType
    * @param referenceNumber (String) : referenceNumber
    * @param commPlanId (String) : commPlanId
    * @param ruleEmailTemplate (String) : ruleEmailTemplate
    * @return Return String : Return caseId
    */
    public static String createRuleMatchingCase(Messaging.InboundEmail email, List<Service_Group__c> serviceGroup,
                                                List<Service_Group_Type__c> serviceType, String servicecLevelId,
                                                String ruleType, String absaSupportAddress,boolean skipResponse,
                                                String referenceType, String referenceNumber, String commPlanId,
                                                String ruleEmailTemplate){

        if( serviceGroup.size() == 0 ){
            return '';
        }

        //Get the unique email message ID for duplicate email detection
        String msgID = email.messageId;
        msgID = msgID.removeEnd('>');
        msgID = msgID.removeStart('<');

        //Flag this case to skip any auto responses, if it is detected as beig part of an infinite loop

        Boolean skipAutoResponses = emailLoopDetected(email.fromAddress, absaSupportAddress);

        if(skipResponse){
            skipAutoResponses = skipResponse;
        }

        newEmailCase = new Case();

        List<Group> queueIds = new List<Group>();

        try{

            Map<String, Schema.RecordTypeInfo> caseRecordTypeMap = Case.sObjectType.getDescribe().getRecordTypeInfosByName();

             //common values accross case types

            //This will throw a duplication value error if the msg ID is the same
            newEmailCase.Email_Message_Id__c = msgID;

            //if true, set flag to true that will bypass any auto responses for this case
            if(skipAutoResponses){
               newEmailCase.Skip_Auto_Response__c = skipAutoResponses;
            }


            newEmailCase.Origin = 'Email';
            newEmailCase.Subject = email.subject;
            newEmailCase.Email_From_Address__c = email.fromAddress;
            newEmailCase.sd_Inbox_Name__c = absaSupportAddress;

            //TdB - Auto link Case to Account and/or Contact (if exist in Salesforce) based on Email From Address
            Set<String> fromEmailAddress = new Set<String>();
            fromEmailAddress.add(email.fromAddress);

            //Search email address based on Contact
            List<Contact> contactList = new ContactsSelector().selectByEmail(fromEmailAddress, 1);
            if(contactList.size() > 0) {
                newEmailCase.ContactId = contactList[0].Id;
                newEmailCase.AccountId = contactList[0].AccountId;
                //System.debug('contactList[0] '+contactList[0]);
            }

            // if service group is AIP Case
              // added by Pravin W. on 2021/07/17
              if (serviceGroup[0].Name == 'AIP Services'){
                  newEmailCase.Status = 'In Progress';
                  newEmailCase.Bypass_validation_Rules__c = true;
                  String bodyOfEmail = email.plainTextBody;
                  String IdNumberFound = '';
                  Pattern p = Pattern.compile('(\\d{13})');
                  Matcher pm = p.matcher(bodyOfEmail);
                  if( pm.find() ){
                      IdNumberFound = pm.group(1);
                  }
                  if(IdNumberFound == null || IdNumberFound == ''){
                      pm = p.matcher(email.subject);
                      if( pm.find() ){
                          IdNumberFound = pm.group(1);
                      }
                  }
                  //System.debug(' the Id is ' + IdNumberFound);
                  List<Account> acclst = new List<Account>();
                  if(IdNumberFound != null && IdNumberFound != ''){
                       acclst= new AccountsSelector().selectByIdNumber(IdNumberFound,1);
                  }
                  if( acclst.size() == 0 ){
                       acclst = new AccountsSelector().selectByEmail(fromEmailAddress, 1);
                  }
                  //System.debug('acclst '+acclst);
                  if(acclst.size() > 0){
                          newEmailCase.AccountId = acclst[0].Id;
                          //Populate Contact if person Account
                          if(acclst[0].PersonContactId != null) {
                              newEmailCase.ContactId = acclst[0].PersonContactId;
                          }
                          // find the related AIP Case and return the id
                          string aipCaseRecTypeID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('AIP Case').getRecordTypeId();
                          Set<Id> idSet = new set<Id>();
                          idSet.add(acclst[0].Id);
                          list<Case> lstCase = new list<Case>();
                          lstCase = new CasesSelector().selectByAccountIdSetByCaseStatus(idSet,aipCaseRecTypeID,'Proof to be sent','Proof of insurance');
                          //System.debug('lstCase '+lstCase);
                          if( lstCase.size() > 0 )
                              return lstCase[0].id;
                      }
            }

            //Search email address based on Client if no Contact with AccountId returned
            if(newEmailCase.AccountId == null || newEmailCase.ContactId == null){

                // Added for DD STI to check the ID number in email body
                if (serviceGroup[0].Name == 'DD STI Case'){
                    String bodyOfEmail = email.plainTextBody;
                    String IdNumberFound = '';
                    Pattern p = Pattern.compile('(\\d{13})');
                    Matcher pm = p.matcher(bodyOfEmail);
                    if( pm.find() ){
                        IdNumberFound = pm.group(1);
                    }
                   // System.debug(' the Id is ' + IdNumberFound);
                    if(IdNumberFound != null && IdNumberFound != ''){
                        List<Account> acclst= new AccountsSelector().selectByIdNumber(IdNumberFound,1);
                        if(acclst.size() > 0){
                            newEmailCase.AccountId = acclst[0].Id;
                            //Populate Contact if person Account
                            if(acclst[0].PersonContactId != null) {
                                newEmailCase.ContactId = acclst[0].PersonContactId;
                            }
                        }
                    }
                }
                else{
                     List<Account> accountList = new AccountsSelector().selectByEmail(fromEmailAddress, 1);
                     if(accountList.size() > 0) {
                        newEmailCase.AccountId = accountList[0].Id;

                        //Populate Contact if person Account
                        if(accountList[0].PersonContactId != null) {
                            newEmailCase.ContactId = accountList[0].PersonContactId;
                        }
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
 // Added for AIP Complaints
 if (serviceGroup[0].Name == 'AIP Complaints'){
    newEmailCase.Category__c = 'Complaint';
    newEmailCase.Status = 'Not Started';
}
            newEmailCase.Client_Feedback__c = 'None';
            newEmailCase.sd_Original_Service_Queue__c = serviceGroup[0].Queue__c;
            newEmailCase.sd_Original_Service_Group__c = serviceGroup[0].Name;
            newEmailCase.sd_Service_Group__c = serviceGroup[0].Name;
            newEmailCase.sd_Service_Group_Id__c = serviceGroup[0].Id;
            newEmailcase.sd_Communication_Plan_Id__c = commPlanId;

            if(String.isNotBlank(email.htmlBody)){
                newEmailCase.Description = EmailRuleEngine.htmlToText(email.htmlBody);
            }else if(String.isNotBlank(email.plainTextBody)){
                newEmailCase.Description = email.plainTextBody;
            }

            newEmailCase.sd_Pause_Statuses__c = serviceGroup[0].Pause_Statuses__c;
            newEmailCase.BusinessHoursId = serviceGroup[0].Business_Hours__c;
            newEmailCase.sd_Email_Template_Case_Creation__c = serviceGroup[0].Email_Template_Case_Creation__c;
            newEmailCase.sd_Email_Rule_Template__c = ruleEmailTemplate;
            newEmailCase.sd_Internal_SLA_Time_Measure__c = serviceGroup[0].Internal_SLA_Time_Measure__c;
            newEmailCase.sd_Internal_SLA_Units__c = serviceGroup[0].Internal_SLA_Units__c;
            newEmailCase.Internal_SLA_Notification_User__c = serviceGroup[0].Internal_SLA_Notification_User__c;
            newEmailCase.sd_Response_Email_Address__c = serviceGroup[0].Response_Email_Address__c;
            queueIds = new GroupsSelector().selectByNameAndType(serviceGroup[0].Queue__c, 'Queue');

            if(!queueIds.isEmpty()){
                newEmailCase.ownerId = queueIds[0].id;
            }

            //Rudolf Niehaus - Add parent case id that cause this case to be recreated when a client
            //replied (with threadID) to an close case for service_requests
            //We store the parent Id on the email class
            List<String> parentcaseId = email.references;
            if(parentcaseId != null){
                if(!parentcaseId.isEmpty()){
                    if(parentcaseId[0] instanceof Id ){
                        newEmailCase.Case_Reopened_From__c = parentcaseId[0];
                    }
                }
            }


            //Email of classified case values
            if( ruleType != 'Classify_Rule' || serviceType.isEmpty() ){

               // System.debug(LoggingLevel.FINE, 'Is a Routing Rule');
                //declare the max sla var. -- Short term insurance change.
                Map<String, Datetime> extensionSLA;

                if(caseRecordTypeMap.containsKey(serviceGroup[0].Assign_Record_Type__c)){
                    newEmailCase.RecordTypeId = caseRecordTypeMap.get(serviceGroup[0].Assign_Record_Type__c).RecordTypeId;
                }

                String bhId = serviceGroup[0].Business_Hours__c;
                //use default if list is empty
                if(String.isBlank(bhId)){
                    bhId = [Select Id From BusinessHours Where IsDefault=true].Id;
                }

                Map<String, DateTime> slaDateMap = CaseTriggerFunctions.calculateSLADateTime(System.now(),
                                                                                               bhId,
                                                                                               serviceGroup[0].Internal_SLA_Time_Measure__c,
                                                                                               Integer.valueOf(serviceGroup[0].Internal_SLA_Units__c));


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

                if( !defaultSLA.isEmpty() ){

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


                    slaDateMap = CaseTriggerFunctions.calculateSLADateTime(System.now(),
                                                                           bhId,
                                                                           defaultSLA[0].External_SLA_Time_Measure__c,
                                                                           Integer.valueOf(defaultSLA[0].External_SLA_Units__c));


                    newEmailCase.External_SLA_Warning_Date__c = slaDateMap.get('slaWarningDate');
                    newEmailCase.External_SLA_End_Date__c = slaDateMap.get('slaEndDate');
                    //Calculate the max sla for short term insurance
                    if(String.isNotBlank(serviceGroup[0].Name) && serviceGroup[0].Name == 'Absa Short Term Insurance'){
                        extensionSLA = CaseTriggerFunctions.calculateSLADateTime(newEmailCase.External_SLA_End_Date__c,
                                                                                 bhId,
                                                                                 defaultSLA[0].Max_SLA_Time_Measure__c,
                                                                                 integer.valueof(defaultSLA[0].Max_SLA_Units__c));

                        newEmailCase.Max_SLA_Extension_Date__c = extensionSLA.get('slaEndDate');
                    }

                }

            }else if( ruleType == 'Classify_Rule' || !serviceType.isEmpty() ){

              //  System.debug(LoggingLevel.FINE, 'Is a Classify Rule');

                newEmailCase.sd_Email_Template_Case_Classification__c = serviceType[0].Service_Level__r.Email_Template_Case_Classification__c;
                newEmailCase.sd_Email_Template_Case_Closure__c = serviceType[0].Service_Level__r.Email_Template_Case_Closure__c;

                if(caseRecordTypeMap.containsKey(serviceType[0].Service_Type__r.Case_Record_Type__c)){
                    newEmailCase.RecordTypeId = caseRecordTypeMap.get(serviceType[0].Service_Type__r.Case_Record_Type__c).RecordTypeId;
                }

                newEmailCase.Type__c = serviceType[0].Service_Type__r.Type__c;
                newEmailCase.Subtype__c = serviceType[0].Service_Type__r.Subtype__c;
                newEmailCase.Product__c = serviceType[0].Service_Type__r.Product__c;
                newEmailCase.sd_Service_Type__c = serviceType[0].Service_Type__r.Name;
                newEmailCase.sd_External_SLA_Time_Measure__c = serviceType[0].Service_Level__r.External_SLA_Time_Measure__c;
                newEmailCase.sd_External_SLA_Units__c = serviceType[0].Service_Level__r.External_SLA_Units__c;
                newEmailCase.External_SLA_Notification_User__c = serviceType[0].Service_Level__r.External_SLA_Notification_User__c;
                newEmailCase.sd_Service_Type_Id__c = serviceType[0].Id;

                String bhId = serviceGroup[0].Business_Hours__c;

                //use default if list is empty
                if(String.isBlank(bhId)){
                    bhId = [Select Id From BusinessHours Where IsDefault=true].Id;
                }


                Map<String, DateTime> slaDateMap = CaseTriggerFunctions.calculateSLADateTime(System.now(),
                                                                                               bhId,
                                                                                               serviceType[0].Service_Level__r.External_SLA_Time_Measure__c,
                                                                                              Integer.valueOf(serviceType[0].Service_Level__r.External_SLA_Units__c));


                newEmailCase.External_SLA_Warning_Date__c = slaDateMap.get('slaWarningDate');
                newEmailCase.External_SLA_End_Date__c = slaDateMap.get('slaEndDate');
            }

            if(referenceNumber != null && referenceNumber != '') {
                newEmailCase.External_Reference_Number__c = referenceNumber;
            }

            if(referenceType != null && referenceType != '') {
                newEmailCase.External_Reference_Type__c = referenceType;
            }

            insert newEmailCase;

        }catch(DmlException e) {

            if(e.getMessage().contains('DUPLICATE_VALUE')){
                 AuditTrailLog.logException(e,  'New', 'Info', 'EmailCreateCase', 'createRuleMatchingCase', 'Duplicate Email Message ID, Skip Case creation');
            }else{
                 AuditTrailLog.logException(e,  'New', 'Error', 'EmailCreateCase', 'createRuleMatchingCase', 'DML Exception on Case creation');
               //  system.debug(LoggingLevel.FINE, e.getMessage());
            }

        }catch (Exception e){

            AuditTrailLog.logException(e,  'New', 'Error', 'EmailCreateCase', 'createRuleMatchingCase', 'Unable to create new rule matching Case');
          //  system.debug(LoggingLevel.FINE, e.getMessage());

        }

        return newEmailCase.Id;
    }

    /** RN - CloudSmiths
    * Create an unwanted email record based
    * on a blocking rule
    * @description createUnwantedEmailRecord description
    * @param  email (InboundEmail)  : email
    * @param  retention (Decimal)  : retention
    * @return Return Boolean : return boolean
    */

    public static Boolean createUnwantedEmailRecord( Messaging.InboundEmail email, Decimal retention ){

        try{

            Unwanted_Email__c unwanted = new Unwanted_Email__c();

            unwanted.Subject__c = email.subject;

            if(String.isNotBlank(email.htmlBody)){
                unwanted.Email_Body__c = email.htmlBody;
            }else{
                unwanted.Email_Body__c = email.plainTextBody;
            }

            unwanted.From_Address__c = email.fromAddress;
            unwanted.Sender_Name__c = email.fromName;
            unwanted.Retention_Period_Hrs__c = retention;
            unwanted.To_Address__c = email.toAddresses[0];

            insert unwanted;

            return true;

        }catch (Exception e){
            AuditTrailLog.logException(e,  'New', 'Error', 'EmailCreateCase', 'createUnwantedEmailRecord', 'Unable to create a new Unwanted_Email__c record');
            return false;
        }


    }

     /**
    * @description createEmailMessage description
    * @param  email (InboundEmail)  : email
    * @param  envelope (InboundEnvelope)  : envelope
    * @param  parentId (Id) : parentId
    * @param  recordType (String) : recordType
    * @return Return emailMessage : return null
    */
    public static emailMessage createEmailMessage(Messaging.InboundEmail email,Messaging.InboundEnvelope envelope, Id parentId, String recordType){
        Boolean isBodySizeOk = true;
        Boolean isLargeBodyOk = false;
        Blob emailBodyBlob;

       // System.debug('*** createEmailMessage ' + parentId);

        //Call method to validate email body
        isBodySizeOk = EmailRuleEngine.emailBodyCheck(email);

        //get the toAddresses from the original inbound email object into a string array
        String originalToAddresses = '';
        if(email.toAddresses != null){
            if(email.toAddresses.size() > 0){
                for(String toa:email.toAddresses){
                    originalToAddresses+= toa + ';';
                }
            }
        }
        //get the cc addresses from the original inbound email object into a string array
        String originalCCAddresses = '';
        if(email.ccAddresses != null){
            if(email.ccAddresses.size() > 0){
                for(String s :email.ccAddresses){
                    originalCCAddresses+= s + ';';
                }
            }
        }
        //Create new Email Message and link to Case with all attachments
        EmailMessage emsg = new EmailMessage();
        emsg.FromAddress = email.fromAddress;
        emsg.FromName = email.fromName;

        //if any add cc
        if(String.isNotBlank(originalCCAddresses)){
            emsg.CcAddress = originalCCAddresses;
        }
        //add all to addresses
        if(String.isNotBlank(originalToAddresses)){
            emsg.ToAddress = originalToAddresses;
        }

        /*koketso - removed, because is only adding one toAddress
        if( email.toAddresses != null ){
            emsg.ToAddress = email.toAddresses[0];
        }*/

        //emsg.isOriginalEmail__c = isOriginalEmail;
        emsg.Incoming = true;
        emsg.ThreadIdentifier = parentId;
        //If the size of the email body is smaller than 32000 chr insert the value
        //else add the body content as a file to the
        //EmailMessage

        if(isBodySizeOk){
            if (String.isEmpty(email.htmlBody)){
                emsg.TextBody = email.plainTextBody;
                emailBodyBlob = Blob.valueOf(email.plainTextBody);
            }else{
                emsg.HtmlBody = email.htmlBody;
                emailBodyBlob = Blob.valueOf(email.htmlBody);
            }
        }else{
            //add message so users know what we did behind the scenes
            emsg.TextBody = 'The body of this email was too large to process. Please click on the \'Email Body\' link to view the original email';
            if (String.isEmpty(email.htmlBody)){
                emailBodyBlob = Blob.valueOf(email.plainTextBody);
            }else{
                emailBodyBlob = Blob.valueOf(email.htmlBody);
            }

            if(isLargeBodyOk){
                if (String.isEmpty(email.htmlBody)){
                    emsg.Large_Text_Body__c =  email.plainTextBody;
                }else{
                    emsg.Large_Text_Body__c = email.htmlBody;
                }
            }
        }

        emsg.MessageDate = System.now();
        emsg.Subject = email.subject;
       // System.debug('*** ' + recordType);
        if(recordType == 'Lead'){
         //   System.debug('***Setting emsg ****');
            emsg.Lead__c = parentId;
            emsg.status = '3';
            emsg.ParentId = null;
            String[] toIds = new String[]{parentId};
            emsg.toIds = toIds;
        }
        //Vikas Balusu added else only in below line for Maturity Retention
      else if(recordType == 'Opportunity'){
            emsg.RelatedToId = parentId;
            emsg.Status = '0';
        }
        else{
            emsg.ParentId = parentId;
        }

      //  System.debug('*** Lead__c' + emsg.Lead__c);
      //  System.debug('*** ParentId' + emsg.ParentId);
        //System.debug('*** ' + emsg);

        insert emsg;

        //Added by Minal 2021-03-04
        //Since its a lead record emails would need to appear on the activities pane so an EmailMessageRelation instance needs
        //to be inserted.
        if(recordType == 'Lead'){
          //  System.debug('***Setting emsgrelation ****');
            EmailMessageRelation emr = new EmailMessageRelation();
            emr.emailMessageId = emsg.Id;
            emr.RelationAddress=emsg.FromAddress;
            emr.relationId = parentId; // Lead Id
            emr.relationType = 'FromAddress';
            if(!Test.isRunningTest())insert emr;
        }
        //Now add all the email attachments as content files and Feeditems related to the case
        //Get the location id where the content must go

        //RN : we dont need this anymore, we add files as part of the chatter feed to the case
        //so the location ID is nie nodig nie
        //String libId = [Select Id, Name From ContentWorkspace Where Name = 'Case Email Files'].Id;

        if (email.binaryAttachments != null && email.binaryAttachments.size() > 0) {

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
        insert eBody;

        return null;
    }

    /**
    * @description createContent description
    * @param  att (list<Messaging.InboundEmail.BinaryAttachment>)  : att
    * @param  emsgId (Id) : emsgId
    * @return Return list<String> : return newIds
    */
    public static list<String> createContent(list<Messaging.InboundEmail.BinaryAttachment> att,ID emsgId){

        list<Attachment> attList = new List<Attachment>();
        list<ContentVersion> contvers = new list<ContentVersion>();
        list<String> newIds = new list<String>();

        for(Messaging.InboundEmail.BinaryAttachment b :att) {

            if(b.body.size() > 0 && !b.filename.contains('image')){

                ContentVersion cv = new ContentVersion();
                cv.title = b.filename.substringBeforeLast('.');
                cv.versionData = b.body;
                cv.pathOnClient = b.filename;
                contvers.add(cv);

                //Tonga MM : Along with creating the email, attachments should be added onto the actual email,
                Attachment eBody = new Attachment();
                eBody.Body = b.body;
                eBody.ParentId = emsgId;
                eBody.Name = b.filename;
                eBody.IsPrivate = false;
                attList.add(eBody);


            }
        }

        try{
            Database.SaveResult[] srList = Database.insert(attList,false);
            Database.SaveResult[] contversList = Database.insert(contvers,false);

            for (Database.SaveResult sr : contversList){
                if (sr.isSuccess()) {
                    newIds.add(sr.getId());
                }
                else {
                    // Operation failed, so get all errors
                    for(Database.Error err : sr.getErrors()) {
                        AuditTrailLog.logException(new DMLException(), 'New', 'Error', 'EmailCreatCase', 'createContent',
                                                   'There was an error inserting a ContentVersion record\n ' + err.getMessage());
                    }
                }
            }

        }catch(DMLException ex){
          //  System.debug('Adding content error');
          //  System.debug(ex.getMessage());
             AuditTrailLog.logException(new DMLException(), 'New', 'Error', 'EmailCreateCase', 'createContent', ex.getMessage());
        }

        return newIds;
    }


    /** RN - CloudSmiths
    * Link content to relevant case
    *
    * @description createContentLink description
    * @param contentVersionId (list<String>) : contentVersionId
    * @param caseID (String) : caseID
    */
    public static void createContentLink(list<String> contentVersionId, String caseID){

        List<ContentDocumentLink> docLinks = new List<ContentDocumentLink>();

        for(ContentVersion cv :[Select ContentDocumentId From ContentVersion Where Id IN :contentVersionId]){

            ContentDocumentLink docLink = new ContentDocumentLink();
            docLink.ContentDocumentId = cv.ContentDocumentId;
            docLink.LinkedEntityId = caseID;
            //RN : Inferred permission. The user’s permission is determined by the related record.
            docLink.ShareType = 'I';
            docLinks.add(docLink);

        }

        try{
            insert docLinks;


        }catch(DMLException ex){

            AuditTrailLog.logException(new DMLException(), 'New', 'Error', 'EmailCreatCase', 'createContentLink',
                                                   'There was an error inserting a ContentDocumentLink between the Contentversions and the Case\n ' + ex.getMessage());
          //  System.debug(ex.getMessage());

        }
        catch(Exception ex){

            AuditTrailLog.logException(new DMLException(), 'New', 'Error', 'EmailCreatCase', 'createContentLink',
                                                   'There was an error inserting a ContentDocumentLink between the Contentversions and the Case\n ' + ex.getMessage());
         //   System.debug(ex.getMessage());

        }

    }

      /**
    * RN - CloudSmiths
    *
    * Detect if an email is part of an infinit loop based on
    * rule parameters defined in a custom metadata type
    *
    * @description emailLoopDetected description
    * @param fromAddress (String) : fromAddress
    * @param inboxName (String) : inboxName
    * @return Retun Boolean : Return boolean
    */
    public static Boolean emailLoopDetected(String fromAddress, String inboxName) {

        //Get the loop detection rule parameter values from a custom metadata type
        List<Org_Wide_Lookup_Value__mdt> timeThresholdRec = new OrgWideLookupValuesSelector().selectByLabel('Email Loop Time Threshold');
        List<Org_Wide_Lookup_Value__mdt> numberThresholdRec = new OrgWideLookupValuesSelector().selectByLabel('Email Loop Number Threshold');

        Integer timeThreshold;
        Integer countThreshold;

        //default if we couldnt get any values
        if(!timeThresholdRec.isEmpty()){
            //convert decimal to integer
            timeThreshold = Integer.valueOf(timeThresholdRec[0].Integer_Value__c);
        }else{
            timeThreshold = 10;
        }
        if(!numberThresholdRec.isEmpty()){
            countThreshold = Integer.valueOf(numberThresholdRec[0].Integer_Value__c);
        }else{
            countThreshold = 5;
        }


        //Go back in time x minutes
        DateTime cutOffTime = System.now();
        cutOffTime = cutOffTime.addMinutes((timeThreshold * -1));

        //Get the number of current cases that matched the from and inbox addresses for a specific time frame. If that number
        //is equal to or greater than the threshold number, then we can assume we are dealing with an infinit loop
        Integer numberOfDuplicates = new CasesSelector().selectCountByFromAndToAddress(fromAddress, inboxName, cutOffTime);

        if( numberOfDuplicates >= countThreshold) {
             return true;
        }else{
             return false;
        }
    }

    /**
    * 07/2019 - Koketso Mpshane: Created Method to Update Service group and queue when one of prioritised shared email is copied on incoming email
    *
    * @description prioritiseCaseToCopiedGroup description
    * @param caseId (Id) : caseId
    * @param serviceGroupId (Id) : serviceGroupId
    * @param emailaddresses (Set<String>) : emailaddresses
    */
    public static void prioritiseCaseToCopiedGroup(Id caseId, Id serviceGroupId, Set<String> emailaddresses){
        Set<Id> serviceGroupIds = new Set<Id>();

        try{
            serviceGroupIds.add(serviceGroupId);
          //  system.debug(LoggingLevel.FINE, 'serviceGroupIds:'+serviceGroupIds);
            List<Service_Group__c> serviceGroups = new ServiceGroupsSelector().selectById(serviceGroupIds);
            if(serviceGroups.size() > 0){
                Case caseRecord = [Select OwnerId, sd_Service_Group__c From Case Where Id =:caseId];
                List<GroupMember> groups  = [Select Group.Name, UserOrGroupId From GroupMember Where UserOrGroupId =:caseRecord.OwnerId And Group.Name =:serviceGroups[0].Name];
              //  system.debug(LoggingLevel.FINE, '*groups*:'+groups);

                if(groups.isEmpty() && (caseRecord.sd_Service_Group__c != serviceGroups[0].Name)){
                    if(!Test.isRunningTest()){
                        CaseTransferActionExt.transferCase(caseId, 'EmailTransfer', null, 'Transfered by email', serviceGroups[0]);
                    }
                }
            }else{
             //   system.debug('There was an error transferring the Case - Service Group is not setup correctly, please contact your Salesforce Administrator');
            }

        }catch(Exception ex){
          //  system.debug(LoggingLevel.FINE, 'prioritiseCaseToCopiedGroupERRORS:'+ex.getMessage());
            throw ex;
        }

    }

}