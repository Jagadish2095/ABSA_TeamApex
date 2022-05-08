/******************************************************
 *
 * Author : Kyle Alexander
 *
 * @since : 2020-03-03
 * @update : 2020-03-20 - Rudolf Niehaus -
 *  @description          extract additional info from the email body
 *
 * ***************************************************/

public class EmailCreateLead {
    public static Lead newEmailLead;
    public static Boolean isOriginalEmail;

    /** Create new lead
     *
     * Create a new lead based on a mathing rule
     * 1 - Routing Rule
     * 2 - Classification Rule
     * 3 - Bocking Rule
     * @description createRuleMatchingLead description
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
     * @return  Return String: Return description
     */
    public static String createRuleMatchingLead(
        Messaging.InboundEmail email,
        List<Service_Group__c> serviceGroup,
        List<Service_Group_Type__c> serviceType,
        String servicecLevelId,
        String ruleType,
        String absaSupportAddress,
        boolean skipResponse,
        String referenceType,
        String referenceNumber,
        String commPlanId
    ) {
        if (serviceGroup.size() == 0) {
            return '';
        }

        //Get the unique email message ID for duplicate email detection
        String msgID = email.messageId;
        msgID = msgID.removeEnd('>');
        msgID = msgID.removeStart('<');

        //Flag this lead to skip any auto responses, if it is detected as beig part of an infinite loop

        Boolean skipAutoResponses = emailLoopDetected(email.fromAddress, absaSupportAddress);

        if (skipResponse) {
            skipAutoResponses = skipResponse;
        }

        newEmailLead = new Lead();

        List<Group> queueIds = new List<Group>();

        try {
            Map<String, Schema.RecordTypeInfo> leadRecordTypeMap = Lead.sObjectType.getDescribe().getRecordTypeInfosByName();

            //common values accross lead types

            //This will throw a duplication value error if the msg ID is the same
            newEmailLead.Email_Message_Id__c = msgID;

            //if true, set flag to true that will bypass any auto responses for this lead
            if (skipAutoResponses) {
                newEmailLead.Skip_Auto_Response__c = skipAutoResponses;
            }

            String firstName = '';
            String lastName = '';

            //Extract the customer name from the email subject
            if (String.isNotBlank(email.subject) && email.subject.contains('Customer name:')) {
                String customerName = email.subject.substringBetween('Customer name:', '"');
                if (customerName == null) {
                    firstName = 'MSALead';
                    lastName = 'NameUndefined';
                } else {
                    String[] fromName = customerName.split(' ');

                    if (fromName.size() == 1) {
                        firstName = fromName[0];
                        lastName = fromName[0];
                    } else if (fromName.size() >= 2) {
                        for (Integer i = 0; i < fromName.size() - 1; i++) {
                            firstName += fromName[i] + ' ';
                        }
                        lastName = fromName[fromName.size() - 1];
                    }
                }
            } else if (serviceGroup[0].Name == 'Direct Delivery STI') {
                String bodyOfEmail = email.plainTextBody;
                String IdNumberFound = '';
                Pattern p = Pattern.compile('(\\d{13})');
                Matcher pm = p.matcher(bodyOfEmail);
                if (pm.find()) {
                    IdNumberFound = pm.group(1);
                }
              //  System.debug(' the Id is ' + IdNumberFound);
                if (IdNumberFound != null && IdNumberFound != '') {
                    List<Account> acclst = new AccountsSelector().selectByIdNumber(IdNumberFound, 1);
                    if (acclst.size() > 0) {
                        firstName = acclst[0].FirstName;
                        lastName = acclst[0].LastName;
                    } else {
                        //if name from the email is blank then populate
                        firstName = 'STILead';
                        lastName = 'NameUndefined';
                    }
                } else {
                    //if name from the email is blank then populate
                    firstName = 'STILead';
                    lastName = 'NameUndefined';
                }
            }
            else {
                //If the email subject is blank then populate with the from name
                //Try populate the first and last name of the lead
                if (String.isNotBlank(email.fromName)) {
                    String[] fromName = email.fromName.split(' ');
                    if (fromName.size() == 1) {
                        firstName = fromName[0];
                        lastName = fromName[0];
                    } else if (fromName.size() >= 2) {
                        for (Integer i = 0; i < fromName.size() - 1; i++) {
                            firstName += fromName[i] + ' ';
                        }
                        lastName = fromName[fromName.size() - 1];
                    }
                } else {
                    //if name from the email is blank then populate
                    firstName = 'MSALead';
                    lastName = 'NameUndefined';
                }
            }

            newEmailLead.FirstName = firstName;
            newEmailLead.LastName = lastName;
            newEmailLead.LeadSource = 'Email';
            newEmailLead.Subject__c = email.subject;
            newEmailLead.Email = email.fromAddress;
            newEmailLead.sd_Inbox_Name__c = absaSupportAddress;

            //RN : Extract Additional values from the email body
            //Business rule: Only extract values IF email was sent from MSA
            //Assumption: The from email address will start with 'MSAleads'

            if (email.fromAddress.endsWith('absa.africa') || email.fromAddress.endsWith('marketsa.co.za')) {
                String emailTextBody = email.plainTextBody;
                if (emailTextBody != null) {
                    List<String> emailBodyLines = emailTextBody.split('\n');
                    List<String> strValues = new List<String>();
                    Set<Id> idSet = new Set<Id>();

                    for (String line : emailBodyLines) {
                        if (line.contains('Preferred Contact Number')) {
                            strValues = line.split(':');

                            if (strValues.size() >= 2) {
                                newEmailLead.MobilePhone = strValues[1];
                            }
                        } else if (line.contains('Additional Contact Number')) {
                            strValues = line.split(':');

                            if (strValues.size() >= 2) {
                                newEmailLead.Phone = strValues[1];
                            }
                        } else if (line.contains('Customer Key')) {
                            strValues = line.split(':');

                            if (strValues.size() >= 2) {
                                newEmailLead.CIF__c = strValues[1];
                            }
                        } else if (line.contains('Product Interest')) {
                            strValues = line.split(':');
                            if (strValues.size() >= 2) {
                                String idStr = String.escapeSingleQuotes(strValues[1].trim());
                                if ((idStr.length() == 15 || idStr.length() == 18) && Pattern.matches('^[a-zA-Z0-9]*$', idStr)) {
                                    idSet.add(Id.valueOf(idStr));
                                }
                            }
                        }
                    }

                    List<Financial_Product__c> productList = new FinancialProductsSelector().selectById(idSet);

                    if (productList.size() > 0) {
                        newEmailLead.Product_Interest_1__c = productList[0].id;
                    }
                }
            }

            //Make the lead a hot lead if it is sent from an email
            newEmailLead.Hot_Deal__c = true;
            newEmailLead.LeadSource = 'MSA';

            //This field is used in the auto response emails to the client.
            //In some instances this from name do not pull through in the mail object
            //We set this value then to client as it will then display on the email template as
            //Dear Client, and not just a blank value
            if (String.isNotBlank(email.fromName)) {
                newEmailLead.Email_From_Name__c = email.fromName;
            } else {
                newEmailLead.Email_From_Name__c = 'Client';
            }

            newEmailLead.sd_Original_Service_Queue__c = serviceGroup[0].Queue__c;
            newEmailLead.sd_Original_Service_Group__c = serviceGroup[0].Name;
            newEmailLead.sd_Service_Group__c = serviceGroup[0].Name;
            newEmailLead.sd_Service_Group_Id__c = serviceGroup[0].Id;
            newEmailLead.sd_Communication_Plan_Id__c = commPlanId;

            if (String.isNotBlank(email.htmlBody)) {
                newEmailLead.Description = EmailRuleEngine.htmlToText(email.htmlBody);
            } else if (String.isNotBlank(email.plainTextBody)) {
                newEmailLead.Description = email.plainTextBody;
            }

            newEmailLead.sd_Pause_Statuses__c = serviceGroup[0].Pause_Statuses__c;
            newEmailLead.Business_Hours__c = serviceGroup[0].Business_Hours__c;
            newEmailLead.sd_Email_Template_Lead_Creation__c = serviceGroup[0].Email_Template_Lead_Creation__c;
            newEmailLead.sd_Internal_SLA_Time_Measure__c = serviceGroup[0].Internal_SLA_Time_Measure__c;
            newEmailLead.sd_Internal_SLA_Units__c = serviceGroup[0].Internal_SLA_Units__c;
            newEmailLead.Internal_SLA_Notification_User__c = serviceGroup[0].Internal_SLA_Notification_User__c;
            newEmailLead.Manager__c = serviceGroup[0].Manager__c;
            newEmailLead.sd_Response_Email_Address__c = serviceGroup[0].Response_Email_Address__c;
            queueIds = new GroupsSelector().selectByNameAndType(serviceGroup[0].Queue__c, 'Queue');

            if (!queueIds.isEmpty()) {
                newEmailLead.ownerId = queueIds[0].id;
            }

            //Email of classified lead values
            if (ruleType != 'Classify_Rule' || serviceType.isEmpty()) {
              //  System.debug(LoggingLevel.FINE, 'Is a Routing Rule');

                if (leadRecordTypeMap.containsKey(serviceGroup[0].Assign_Record_Type__c)) {
                    newEmailLead.RecordTypeId = leadRecordTypeMap.get(serviceGroup[0].Assign_Record_Type__c).RecordTypeId;
                    //newEmailLead.LeadSource = 'Email';

                    Id devRecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Direct Delivery Sales Lead').getRecordTypeId();

                    //added as part of DD lead creation

                    Id stiRecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('DD STI Lead').getRecordTypeId(); //aded by pranav
                    List<Financial_Product__c> financialProducts = new List<Financial_Product__c>();
                    List<Group> queue = new List<Group>();
                    //aded by pranav for sti
                    if (newEmailLead.RecordTypeId == stiRecordTypeId && serviceGroup[0].Name == 'Direct Delivery STI') {
                        newEmailLead.LeadSource = 'Email';
                        financialProducts = [SELECT Id, Name FROM Financial_Product__c WHERE Name = 'STI' LIMIT 1];

                        if (!financialProducts.isEmpty()) {
                          //  system.debug('inside if lead overrride');
                            newEmailLead = LeadOverrideController.createNewDirectDeliveryLead(
                                newEmailLead,
                                null,
                                financialProducts[0],
                                false,
                                null,
                                queueIds[0].id
                            );
                        }
                    }

                    //Check the record type and service group name and create lead for Direct Delivery lead
                    if (newEmailLead.RecordTypeId == devRecordTypeId && serviceGroup[0].Name == 'Extended Cover') {
                        newEmailLead.LeadSource = 'Email';
                        financialProducts = [SELECT Id, Name FROM Financial_Product__c WHERE Name = 'Extended Cover' LIMIT 1];
                        // queue = [SELECT Id, DeveloperName FROM Group WHERE DeveloperName = 'DD_Extended_Cover' LIMIT 1];

                        if (!financialProducts.isEmpty() /*&& !queue.isEmpty()*/) {
                            newEmailLead = LeadOverrideController.createNewDirectDeliveryLead(
                                newEmailLead,
                                null,
                                financialProducts[0],
                                false,
                                null,
                                queueIds[0].id
                            );
                        }
                    }
                    if (newEmailLead.RecordTypeId == devRecordTypeId && serviceGroup[0].Name == 'AVAF CreditLife') {
                        newEmailLead.LeadSource = 'Email';
                        financialProducts = [SELECT Id, Name FROM Financial_Product__c WHERE Name = 'AVAF Credit Life' LIMIT 1];
                        //queue = [SELECT Id,DeveloperName FROM Group WHERE DeveloperName = 'DD_AVAF_Credit_Life'];

                        if (!financialProducts.isEmpty() /*&& !queue.isEmpty()*/) {
                            newEmailLead = LeadOverrideController.createNewDirectDeliveryLead(
                                newEmailLead,
                                null,
                                financialProducts[0],
                                false,
                                null,
                                queueIds[0].id
                            );
                        }
                    }
                }

               // system.debug('bhId ' + serviceGroup[0].Business_Hours__c);
                String bhId = serviceGroup[0].Business_Hours__c;
                //use default if list is empty
                if (String.isBlank(bhId)) {
                    bhId = [SELECT Id FROM BusinessHours WHERE IsDefault = TRUE].Id;
                }

                Map<String, DateTime> slaDateMap = CaseTriggerFunctions.calculateSLADateTime(
                    System.now(),
                    bhId,
                    serviceGroup[0].Internal_SLA_Time_Measure__c,
                    Integer.valueOf(serviceGroup[0].Internal_SLA_Units__c)
                );

                newEmailLead.Internal_SLA_Warning_Date__c = slaDateMap.get('slaWarningDate');
                newEmailLead.Internal_SLA_End_Date__c = slaDateMap.get('slaEndDate');
                List<Service_Level__c> defaultSLA = new List<Service_Level__c>();

                //Use the default Service Level until the lead is classified by an agent
                if (String.isBlank(servicecLevelId)) {
                    defaultSLA = new ServiceLevelsSelector().selectDefaultServiceType();
                } else {
                    Set<Id> idSet = new Set<Id>();
                    idSet.add(servicecLevelId);
                    defaultSLA = new ServiceLevelsSelector().selectById(idSet);
                }

                if (!defaultSLA.isEmpty()) {
                    //newEmailLead.sd_Email_Template_Case_Classification__c = defaultSLA[0].Email_Template_Case_Classification__c;
                    //newEmailLead.sd_Email_Template_Case_Closure__c = defaultSLA[0].Email_Template_Case_Closure__c;
                    newEmailLead.sd_External_SLA_Time_Measure__c = defaultSLA[0].External_SLA_Time_Measure__c;
                    newEmailLead.sd_External_SLA_Units__c = defaultSLA[0].External_SLA_Units__c;
                    newEmailLead.External_SLA_Notification_User__c = defaultSLA[0].External_SLA_Notification_User__c;
                    newEmailLead.sd_Max_SLA_Units__c = defaultSLA[0].Max_SLA_Units__c;
                    newEmailLead.sd_Max_SLA_Time_Measure__c = defaultSLA[0].Max_SLA_Time_Measure__c;

                    //use default if list is empty
                    if (String.isBlank(bhId)) {
                        bhId = [SELECT Id FROM BusinessHours WHERE IsDefault = TRUE].Id;
                    }
                   // System.debug('bhId >>>>' + bhId);
                   // System.debug('defaultSLA[0].External_SLA_Time_Measure__c >>>>' + defaultSLA[0].External_SLA_Time_Measure__c);

                    slaDateMap = CaseTriggerFunctions.calculateSLADateTime(
                        System.now(),
                        bhId,
                        defaultSLA[0].External_SLA_Time_Measure__c,
                        Integer.valueOf(defaultSLA[0].External_SLA_Units__c)
                    );

                    newEmailLead.External_SLA_Warning_Date__c = slaDateMap.get('slaWarningDate');
                    newEmailLead.External_SLA_End_Date__c = slaDateMap.get('slaEndDate');
                }
            } else if (ruleType == 'Classify_Rule' || !serviceType.isEmpty()) {
             //   System.debug(LoggingLevel.FINE, 'Is a Classify Rule');

                //newEmailLead.sd_Email_Template_Case_Classification__c = serviceType[0].Service_Level__r.Email_Template_Case_Classification__c;
                //newEmailLead.sd_Email_Template_Case_Closure__c = serviceType[0].Service_Level__r.Email_Template_Case_Closure__c;

                if (leadRecordTypeMap.containsKey(serviceType[0].Service_Type__r.Case_Record_Type__c)) {
                    newEmailLead.RecordTypeId = leadRecordTypeMap.get(serviceType[0].Service_Type__r.Case_Record_Type__c).RecordTypeId;
                }

                newEmailLead.Type__c = serviceType[0].Service_Type__r.Type__c;
                newEmailLead.Subtype__c = serviceType[0].Service_Type__r.Subtype__c;
                newEmailLead.Service_Product__c = serviceType[0].Service_Type__r.Product__c;
                newEmailLead.sd_Service_Type__c = serviceType[0].Service_Type__r.Name;
                newEmailLead.sd_External_SLA_Time_Measure__c = serviceType[0].Service_Level__r.External_SLA_Time_Measure__c;
                newEmailLead.sd_External_SLA_Units__c = serviceType[0].Service_Level__r.External_SLA_Units__c;
                newEmailLead.External_SLA_Notification_User__c = serviceType[0].Service_Level__r.External_SLA_Notification_User__c;
                newEmailLead.sd_Service_Type_Id__c = serviceType[0].Id;

                String bhId = serviceGroup[0].Business_Hours__c;

                //use default if list is empty
                if (String.isBlank(bhId)) {
                    bhId = [SELECT Id FROM BusinessHours WHERE IsDefault = TRUE].Id;
                }

                Map<String, DateTime> slaDateMap = CaseTriggerFunctions.calculateSLADateTime(
                    System.now(),
                    bhId,
                    serviceType[0].Service_Level__r.External_SLA_Time_Measure__c,
                    Integer.valueOf(serviceType[0].Service_Level__r.External_SLA_Units__c)
                );

                newEmailLead.External_SLA_Warning_Date__c = slaDateMap.get('slaWarningDate');
                newEmailLead.External_SLA_End_Date__c = slaDateMap.get('slaEndDate');
            }

            if (referenceNumber != null && referenceNumber != '') {
                newEmailLead.External_Reference_Number__c = referenceNumber;
            }

            if (referenceType != null && referenceType != '') {
                newEmailLead.External_Reference_Type__c = referenceType;
            }
            Id recordTypeId = newEmailLead.RecordTypeId;

            if (String.isBlank(String.valueOf(newEmailLead.Id))) {
                insert newEmailLead;
            } else {
                update newEmailLead;
            }
        } catch (DmlException e) {
            if (e.getMessage().contains('DUPLICATE_VALUE')) {
                AuditTrailLog.logException(e, 'New', 'Info', 'EmailCreateLead', 'createRuleMatchingLead', 'Duplicate Email Message ID, Skip Lead creation');
            } else {
                AuditTrailLog.logException(e, 'New', 'Error', 'EmailCreateLead', 'createRuleMatchingLead', 'DML Exception on Lead creation');
              //  system.debug(LoggingLevel.FINE, e.getMessage());
            }
        } catch (Exception e) {
            AuditTrailLog.logException(e, 'New', 'Error', 'EmailCreateLead', 'createRuleMatchingLead', 'Unable to create new rule matching Lead');
          //  system.debug(LoggingLevel.FINE, e.getMessage());
        }
        //Call method to populate lead details with values from CIF.
        if (newEmailLead.Id != null && newEmailLead.CIF__c != null) {
            updateCIFDetailsOnLead(newEmailLead.Id, newEmailLead.CIF__c);
        }
        return newEmailLead.Id;
    }

    /**
     * @description createUnwantedEmailRecord description
     *
     * @param email (Messaging.InboundEmail): email
     * @param retention (Decimal): retention
     * @return Return Boolean: Return description
     */
    public static Boolean createUnwantedEmailRecord(Messaging.InboundEmail email, Decimal retention) {
        try {
            return EmailCreateCase.createUnwantedEmailRecord(email, retention);
        } catch (Exception e) {
            AuditTrailLog.logException(e, 'New', 'Error', 'EmailCreateLead', 'createUnwantedEmailRecord', 'Unable to create a new Unwanted_Email__c record');
            return false;
        }
    }
    /**
     * @description createEmailMessage description
     *
     * @param email (Messaging.InboundEmail): email
     * @param envelope (Messaging.InboundEnvelope): envelope
     * @param leadId (Id): leadId
     * @param recordType (String): recordType
     * @return Return emailMessage: Return description
     */
    public static emailMessage createEmailMessage(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope, Id leadId, String recordType) {
        if (recordType == 'Case') {
            String caseNumber = null;
            //Call method to extract the Case Number from the Email Subject/Body
            caseNumber = EmailExternalReferenceNo.getCaseNumber(email);
            if (String.isNotBlank(caseNumber)) {
             //   System.debug('###caseNumber : ' + caseNumber);
                //return case id regardless of close status
                leadId = EmailExternalReferenceNo.findCaseByCaseNo(caseNumber);
            }
        }
        //VA  Maturty Retetion update response date whenever we recive the incoming inbound email :Sulochana
        if (recordType == 'Lead'){
        UpdateFirstresponsedate(leadId);
        }
        return EmailCreateCase.createEmailMessage(email, envelope, leadId, recordType);

    }

    //This method inserts a content version from the email attachment
    /**
     * @description createContent description
     *
     * @param att (list<Messaging.InboundEmail.BinaryAttachment>): att
     * @param emsgId (ID): emsgId
     * @return Return list<String>: Return description
     */
    public static list<String> createContent(list<Messaging.InboundEmail.BinaryAttachment> att, ID emsgId) {
        return EmailCreateCase.createContent(att, emsgId);
    }

    /**
     * @description createContentLink description
     *
     * @param contentVersionId (list<String>): contentVersionId
     * @param leadID (String): leadID
     */
    public static void createContentLink(list<String> contentVersionId, String leadID) {
        EmailCreateCase.createContentLink(contentVersionId, leadID);
    }

    /**
     * @description emailLoopDetected description
     *
     * @param fromAddress (String): fromAddress
     * @param inboxName (String): inboxName
     * @return Return Boolean: Return description
     */
    public static Boolean emailLoopDetected(String fromAddress, String inboxName) {
        //Get the loop detection rule parameter values from a custom metadata type
        List<Org_Wide_Lookup_Value__mdt> timeThresholdRec = new OrgWideLookupValuesSelector().selectByLabel('Email Loop Time Threshold');
        List<Org_Wide_Lookup_Value__mdt> numberThresholdRec = new OrgWideLookupValuesSelector().selectByLabel('Email Loop Number Threshold');

        Integer timeThreshold;
        Integer countThreshold;

        //default if we couldnt get any values
        if (!timeThresholdRec.isEmpty()) {
            //convert decimal to integer
            timeThreshold = Integer.valueOf(timeThresholdRec[0].Integer_Value__c);
        } else {
            timeThreshold = 10;
        }
        if (!numberThresholdRec.isEmpty()) {
            countThreshold = Integer.valueOf(numberThresholdRec[0].Integer_Value__c);
        } else {
            countThreshold = 5;
        }

        //Go back in time x minutes
        DateTime cutOffTime = System.now();
        cutOffTime = cutOffTime.addMinutes((timeThreshold * -1));

        //Get the number of current cases that matched the from and inbox addresses for a specific time frame. If that number
        //is equal to or greater than the threshold number, then we can assume we are dealing with an infinit loop
        Integer numberOfDuplicates = new LeadsSelector().selectCountByFromAndToAddress(fromAddress, inboxName, cutOffTime);

        if (numberOfDuplicates >= countThreshold) {
            return true;
        } else {
            return false;
        }
    }

    //Kabelo Aphane, Given Madavhu - Populate lead details with values from CIF
    /**
     * @description updateCIFDetailsOnLead description
     *
     * @param leadId (Id): leadId
     * @param cifCode (String): cifCode
     */
    @future(callout=true)
    public static void updateCIFDetailsOnLead(Id leadId, String cifCode) {
        GetClientDetailsCIF_Resp_IB_v1 clientDetails = GetClientDetailsCIF_IH_v1.getClientDetails(cifCode, '0', '0');
        Lead newEmailLead = new Lead(Id = leadId);
        if (clientDetails != null) {
            String prefComMethTranslated = Sys_Utilities_Integration.getIntegrationTranslationInternalValue(
                StringConstants.CIF_STRING,
                'Preferred Communication Method',
                clientDetails.prefrdCommtionMthd,
                StringConstants.INBOUND_RECORD_TYPE
            );
            newEmailLead.Email = clientDetails.emailAddress;
            newEmailLead.ID_Number__c = clientDetails.idNumber;
            newEmailLead.Preferred_Communication_Channel_RBB__c = prefComMethTranslated;
        }
        update newEmailLead;
    }
//VA  Maturty Retetion update response date whenever we recive the incoming inbound email :Sulochana
/**
     * @description UpdateFirstresponsedate description
     *
     * @param leadId (Id): leadId
     *
     */
@future(callout=true)
    public static void UpdateFirstresponsedate(Id leadId) {
    Id maturityRecTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('Maturity_Retention').getRecordTypeId();
    Lead newEmailLead = new Lead();
    newEmailLead = [Select Id,RecordTypeId,First_Response_Date__c from Lead where Id =:leadId];
    if(newEmailLead.RecordTypeId == maturityRecTypeId){
        newEmailLead.First_Response_Date__c = System.now();
        update newEmailLead;
     }
        }
}