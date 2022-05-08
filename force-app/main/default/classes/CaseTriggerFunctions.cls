/******************************************************
 *
 * Author : Tracy de Bruin
 *
 * 20/06/2018 - TdB - Created Class
 * 04/07/2018 - TdB - Add rejectedCaseLogic() - Display error message if no comment provided when rejecting Deadlock
 * 09/2018 - Rudolf Niehaus : Contact Center updates. Implement the use of the service design
 * @description CaseTriggerFunctions
 * ***************************************************/
public class CaseTriggerFunctions {
    /**
     * @description emailResponse description
     *@comment : emailResponse
     * @param newCases (List<Case>): newCases
     * @param oldRecords (Map<IdsObject>): oldRecords
     * @param responseType (String): responseType
     */
    public static void emailResponse(List<Case> newCases, Map<Id, sObject> oldRecords, String responseType){
        //Get all recordtypes for Cases in a map - use one query then ref map multipal times
        map<String, Schema.RecordTypeInfo> caseRecordTypeMap = Case.sObjectType.getDescribe().getRecordTypeInfosByName();

        //get any contact with a valid email address. We need this because you cannot send an email with a template without
        //the Target Object ID, and this can only be a Lead, Contact or user. The WhatId is the Case and this
        //will populate the merged fields as we use the case.email_sender_name in the templates.

        //RN - Remove FFLIB function and replace with an inline SOQL query
        //as it returns no records after the new SF release. FFLIB security issue
        List<Org_Wide_Lookup_Value__mdt> mdt = new OrgWideLookupValuesSelector().selectByLabel('Email Template Default TargetObjectId');
        String defaulttargetObjectId = null;
        if (mdt.size()>0 ) {
            defaulttargetObjectId = mdt[0].Value__c;
        }
        
        //RN : TESTING A THEORY
        //Cannot use the selector layer as it inforces CRUD access, this prevents
        //site users to query org wide email addresses
        map<String,Id> OWDIdMap = new map<String,Id>();        
        for(OrgWideEmailAddress owd :[Select Id, Address From OrgWideEmailAddress]) {
            OWDIdMap.put(owd.Address,owd.Id);            
        }
                
        List<Messaging.SingleEmailMessage> emailsOutList = new List<Messaging.SingleEmailMessage>();
        list<EmailMessage> emailMsgList = new list<EmailMessage>();
        
        for(Case c :newCases ){            
            //Check response type against polulated email template
            String emailTemplateName = NULL;
            if(responseType.equals('create')){
                //skip auto responses if true, as this case was created as part of an infinit loop email
                //This will hopefully break the loop
                if(!c.Skip_Auto_Response__c ){
                    //R. Niehaus - Check if the matching email rule, stamped a rule template name on the case,
                    //if yes use the rule template instead, as this was a key word matching rule
                    if(String.isBlank(c.sd_Email_Rule_Template__c)){
                        emailTemplateName = c.sd_Email_Template_Case_Creation__c;
                    }else{
                        emailTemplateName = c.sd_Email_Rule_Template__c;
                    }                    
                }
            }else if(responseType.equals('update')){
                if(oldRecords != null){
                    Case oldCase = (Case)oldRecords.get(c.Id);
                    if( oldCase.Type__c != c.Type__c ){
                        emailTemplateName = c.sd_Email_Template_Case_Classification__c;
                    }
                    if( oldCase.Status != c.Status && c.IsClosed && String.isBlank(c.Unwanted_Type__c)){                                              
                        //ignore if email was flagged as unwanted                       
                        emailTemplateName = c.sd_Email_Template_Case_Closure__c;                        
                    }
                }
            }                   
            
            if( String.isNotBlank( c.Email_From_Address__c ) && String.isNotBlank(emailTemplateName)){
                //create a list with the original senders email address (Email From Address)
                list<String> toAddress = new list<String> {c.Email_From_Address__c};
                Messaging.SingleEmailMessage emailOut = new Messaging.SingleEmailMessage();
                if(OWDIdMap.containsKey(c.sd_Response_Email_Address__c)){
                    emailOut.setOrgWideEmailAddressId(OWDIdMap.get(c.sd_Response_Email_Address__c));
                }else{
                    emailOut.setSenderDisplayName('ABSA Support');
                }
                if(c.ContactId!=NULL) {
                    defaulttargetObjectId=c.ContactId;
                }
                emailOut.setTargetObjectId(defaulttargetObjectId);
                emailOut.setTreatTargetObjectAsRecipient(false);
                emailOut.setToAddresses(toAddress);
                emailOut.setWhatId(c.Id);               
                emailOut.setSaveAsActivity(false);
                if(String.isNotBlank(label.DocumentsCollectionEmail) && caseRecordTypeMap.get('FIC Case').RecordTypeID==c.RecordTypeID 
                   && c.Owner_Queue_Name__c=='Awaiting Documents'){
                    emailOut.setInReplyTo(label.DocumentsCollectionEmail);                    
                }               
                //RN HOT FIX - FFLIB not returning any email templates back if the user is not a system admin
                //List<EmailTemplate> emailTemps = [Select Id, DeveloperName From EmailTemplate Where Name = :emailTemplateName];                
                List<EmailTemplate> emailTemps = new EmailTemplatesSelector().selectByName(emailTemplateName);
                if (!emailTemps.isEmpty()) {
                    emailOut.setTemplateId(emailTemps[0].Id);
                    emailsOutList.add(emailOut);                                                               
                }               
            }
        }

        //now send the list of emails
        if(!emailsOutList.isEmpty()){
            Messaging.sendEmail(emailsOutList);
            for(Messaging.SingleEmailMessage eachEmail : emailsOutList){
                //Create Email Message - to store on Case
                EmailMessage emailMsg = new EmailMessage();
                emailMsg.ToAddress=(eachEmail.getToAddresses()[0]);
                emailMsg.Subject=eachEmail.getSubject();
                emailMsg.HtmlBody=eachEmail.getHtmlBody();
                emailMsg.ParentId = eachEmail.getWhatId();
                emailMsg.MessageDate = system.now();
                emailMsg.Status = '0';
                emailMsg.Is_Auto_Response__c = true;
                emailMsgList.add(emailMsg);
            }
            try {
                if (!emailMsgList.isEmpty()) {
                    insert emailMsgList;
                }
            } catch (DMLException e) {
                AuditTrailLog.logException(
                    e,
                    'New',
                    'Warning',
                    'Case_Trigger_Functions',
                    'emailResponse',
                    'There was an error while inserting the Case email message Task'
                );
            }
        }
    }

    /**
     * @description rejectedCaseLogic description
     *
     * @param rejectedCaseMap (Map<IdCase>): rejectedCaseMap
     */
    public static void rejectedCaseLogic(Map<Id, Case> rejectedCaseMap) {
        Set<Id> caseIds = (new Map<Id, Case>(rejectedCaseMap)).keySet();
        Set<Id> processInstanceIds = new Set<Id>();

        //Get all the ProcessInstance related to the Case and add to a Set
        List<Case> CasesWithProcessInstanceIds = new CasesSelector().selectByIdWithProcessInstances(caseIds);
        for (Case eachCase : CasesWithProcessInstanceIds) {
            if (!eachCase.ProcessInstances.isEmpty()) {
                processInstanceIds.add(eachCase.ProcessInstances[0].Id);
            }
        }

        // Now that we have the most recent process instances, we can check
        // the most recent process steps for comments.
        for (ProcessInstance eachProcess : new ProcessInstancesSelector().selectByIdWithProcessInstanceSteps(processInstanceIds)) {
            //Display error message if no comment provided when rejecting a approval
            if ((eachProcess.Steps[0].Comments == null || eachProcess.Steps[0].Comments.trim().length() == 0)) {
                rejectedCaseMap.get(eachProcess.TargetObjectId).addError('Please provide a Comment for Rejecting the Deadlock');
            }
        }
    }

    // Make sure method work from new Trigger Framework and existing trigger
    /**
     * @description pauseSLA description
     *
     * @param newRecords (Map<IdsObject>): newRecords
     * @param oldRecords (Map<IdsObject>): oldRecords
     */
    public static void pauseSLA(Map<Id, sObject> newRecords, Map<Id, sObject> oldRecords) {
        List<Case> caseList = new List<Case>();
        Map<Id, Case> oldValues = new Map<Id, Case>();

        for (Id newRecordId : newRecords.keySet()) {
            //Get old and new values for the Case
            Case newCase = (Case) newRecords.get(newRecordId);
            caseList.add(newCase);
            Case oldCase = (Case) oldRecords.get(newRecordId);
            oldValues.put(newRecordId, oldCase);
        }

        pauseSLA(caseList, oldValues);
    }

    /**
     * @description pauseSLA description
     *
     * @param caseList (list<Case>): caseList
     * @param oldValues (Map<IdCase>): oldValues
     */
    public static void pauseSLA(list<Case> caseList, Map<Id, Case> oldValues) {
        Case c = caseList[0];
        // user storie (W-002861) : Added Service Request RecordType and Set status field for "On Hold" to pause SLA in Service Request
        String recordTypeName = Schema.SObjectType.Case.getRecordTypeInfosById().get(c.recordtypeid).getname();

        Boolean execcuteLogicForRBServiceRequest = false;
        Boolean shouldPauseForRB = false;

        Set<String> pauseStatusSet = new Set<String>();

        Schema.DescribeFieldResult F = Case.Awaiting_status__c.getDescribe();

        List<Schema.PicklistEntry> P = F.getPicklistValues();

        for (Schema.PicklistEntry sp : p) {
            pauseStatusSet.add(sp.getValue());
        }

        if (recordTypeName == 'Service Request' && c.sd_Pause_Statuses__c == 'On Hold' && c.Status != oldValues.get(c.Id).Status) {
            execcuteLogicForRBServiceRequest = true;

            if (c.Status == 'Awaiting External') {
                shouldPauseForRB = true;
            } else if (oldValues.get(c.Id).Status == 'Awaiting External') {
                shouldPauseForRB = false;
            }
        }

        if (
            execcuteLogicForRBServiceRequest ||
            recordTypeName == 'Complaint' ||
            recordTypeName == 'NBFS Dispute Resolution' ||
            recordTypeName == 'DD STI Case' ||
            recordTypeName =='Short Term Complaint'
        ) {
            if (c.Awaiting_Status__c != oldValues.get(c.Id).Awaiting_Status__c || execcuteLogicForRBServiceRequest) {
                if (
                    (!pauseStatusSet.contains(c.Awaiting_Status__c) && pauseStatusSet.contains(oldValues.get(c.Id).Awaiting_Status__c)) ||
                    shouldPauseForRB == false
                ) {
                    //get diff between current date/time and when the pause was date stamped

                    DateTime pauseDateTime = c.SLA_Pause_Date__c;

                    long currentTime = System.now().getTime();
                    long pauseTime = 0;

                    if (pauseDateTime != null) {
                        pauseTime = pauseDateTime.getTime();
                    } else {
                        pauseTime = currentTime;
                    }

                    long timeDiff = (currentTime - pauseTime);

                    //Move SLA date forward with the timeframe the Case was paused
                    if (c.External_SLA_Warning_Date__c != null) {
                        c.External_SLA_Warning_Date__c = BusinessHours.add(c.BusinessHoursId, c.External_SLA_Warning_Date__c, timeDiff);
                    }

                    if (c.External_SLA_End_Date__c != null) {
                        c.External_SLA_End_Date__c = BusinessHours.add(c.BusinessHoursId, c.External_SLA_End_Date__c, timeDiff);
                    }

                    c.SLA_Pause_Flag__c = false;
                    c.SLA_Pause_Date__c = null;
                }
                //set SLA pause flag
                if ((pauseStatusSet.contains(c.Awaiting_Status__c) && !pauseStatusSet.contains(oldValues.get(c.Id).Awaiting_Status__c)) || shouldPauseForRB) {
                    c.SLA_Pause_Flag__c = true;
                    c.SLA_Pause_Date__c = System.now();

                    if (c.External_SLA_End_Date__c > c.SLA_Pause_Date__c) {
                        Long slaPauseDate = c.SLA_Pause_Date__c.getTime();
                        Long slaEndDate = c.External_SLA_End_Date__c.getTime();

                        Long milliseconds = slaEndDate - slaPauseDate;
                        Long seconds = milliseconds / 1000;
                        Long minutes = seconds / 60;
                        Long hours = minutes / 60;
                        Long days = hours / 24;
                        Long minDiv = 60;
                        Long hoursDiv = 24;
                        minutes = getremainder(minutes, minDiv);
                        hours = getremainder(hours, hoursDiv);

                        c.ExternalSLA_Pause_Remaining__c = days + ' ' + 'd ' + hours + ' ' + 'h ' + minutes + ' m  '; //+seconds+' s '+milliseconds;
                    }
                }
            }
        }
    }
    /**
     * @description trackTransferInsert description
     *
     * @param newRecords (List<Case>): newRecords
     */
    public static void trackTransferInsert(List<Case> newRecords) {
        //Added for VA Record
        Id BrokerNoteRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Broker Note').getRecordTypeId();

        list<Case_Transfer_Tracking__c> trackingList = new List<Case_Transfer_Tracking__c>();
        //get default business hours
        list<BusinessHours> defaultBhrs = new BusinessHoursSelector().selectDefault();

        for (Case c : newRecords) {

            Case_Transfer_Tracking__c tracking = new Case_Transfer_Tracking__c();

            tracking.Case__c = c.Id;
            tracking.From__c = 'System';
            if (String.isBlank(c.Owner_User_Name__c)) {
                tracking.To__c = c.Owner_Queue_Name__c;
            } else {
                tracking.To__c = c.Owner_User_Name__c;
            }
            tracking.In__c = System.now();
            tracking.In_Status__c = c.Status;
            tracking.In_Service_Type__c = c.Subtype__c;
            if (
                BrokerNoteRecordTypeId != c.recordTypeId //Added for VA Record
            )
                trackingList.add(tracking);
        }

        try {
            if (trackingList.size() > 0) {
                insert trackingList;
            }
        } catch (DMLException e) {
            AuditTrailLog.logException(
                e,
                'New',
                'Warning',
                'CaseTriggerFunctions',
                'trackTransfer',
                'There was an error while inserting a new case transfer tracking record'
            );
        }
    }

    /**
     * @description trackTransfer description
     *
     * @param newRecords (Map<IdsObject>): newRecords
     * @param oldRecords (Map<IdsObject>): oldRecords
     */
    public static void trackTransfer(Map<Id, sObject> newRecords, Map<Id, sObject> oldRecords) {
        boolean isInsert = false;
        list<Case_Transfer_Tracking__c> trackingList = new List<Case_Transfer_Tracking__c>();
        list<Case_Transfer_Tracking__c> trackingListUpdate = new List<Case_Transfer_Tracking__c>();

        //get case ids
        set<Id> caseIds = new Set<Id>();
        for (Id c : newRecords.keySet()) {
            caseIds.add(newRecords.get(c).Id);
        }

        //insert or update
        if (oldRecords == null) {
            isInsert = true;
        }

        //get default business hours
        list<BusinessHours> defaultBhrs = new BusinessHoursSelector().selectDefault();

        for (Case c : new CasesSelector().selectByIdWithCaseTransferTracking(caseIds)) {
            if (isInsert) {
                Case_Transfer_Tracking__c tracking = new Case_Transfer_Tracking__c();

                tracking.Case__c = c.Id;
                tracking.From__c = 'System';
                if (String.isBlank(c.Owner_User_Name__c)) {
                    tracking.To__c = c.Owner_Queue_Name__c;
                } else {
                    tracking.To__c = c.Owner_User_Name__c;
                }
                tracking.In__c = System.now();
                tracking.In_Status__c = c.Status;
                tracking.In_Service_Type__c = c.Subtype__c;
                trackingList.add(tracking);
            } else {
                Case_Transfer_Tracking__c tracking = new Case_Transfer_Tracking__c();
                //Check if the owner changed
                if (c.OwnerId != oldRecords.get(c.Id).get('OwnerId') || (c.IsClosed && oldRecords.get(c.Id).get('IsClosed') == false)) {
                    //Check if this is NOT the first transfer on an existing case
                    if (c.Case_Transfer_Tracking__r.size() > 0) {
                        //UPDATE last tracking entry
                        Id bhrsId = c.BusinessHoursId;

                        if (String.isBlank(bhrsId)) {
                            bhrsId = defaultBhrs[0].Id;
                        }

                        //get time difference between now and the date/time when the case were transferred
                        long timeDiff = BusinessHours.diff(bhrsId, c.Case_Transfer_Tracking__r[0].In__c, System.now());
                        //convert millisecons to min
                        Integer minDiff = (timeDiff.intValue() / 1000) / 60;

                        //update last tracking entry
                        c.Case_Transfer_Tracking__r[0].Out__c = System.now();
                        c.Case_Transfer_Tracking__r[0].Total_Time_Min__c = minDiff;
                        trackingListUpdate.add(c.Case_Transfer_Tracking__r[0]);
                    }

                    //INSERT new tracking record
                    tracking.Case__c = c.Id;
                    if (String.isBlank(c.Owner_User_Name__c)) {
                        tracking.To__c = c.Owner_Queue_Name__c;
                    } else {
                        tracking.To__c = c.Owner_User_Name__c;
                    }
                    if (String.isBlank((String) oldRecords.get(c.Id).get('Owner_User_Name__c'))) {
                        tracking.From__c = (String) oldRecords.get(c.Id).get('Owner_Queue_Name__c');
                    } else {
                        tracking.From__c = (String) oldRecords.get(c.Id).get('Owner_User_Name__c');
                    }

                    tracking.In__c = System.now();
                    tracking.In_Status__c = c.Status;
                    tracking.In_Service_Type__c = c.Subtype__c;
                    trackingList.add(tracking);
                }
            }
        }

        try {
            //System.debug('trackingListUpdate : ' + trackingListUpdate);
            if (trackingListUpdate.size() > 0) {
                update trackingListUpdate;
            }
        } catch (DMLException e) {
            AuditTrailLog.logException(
                e,
                'New',
                'Warning',
                'CaseTriggerFunctions',
                'trackTransfer',
                'There was an error while updating an existing case transfer tracking record'
            );
        }

        try {
            if (trackingList.size() > 0) {
                insert trackingList;
            }
        } catch (DMLException e) {
            AuditTrailLog.logException(
                e,
                'New',
                'Warning',
                'CaseTriggerFunctions',
                'trackTransfer',
                'There was an error while inserting a new case transfer tracking record'
            );
        }
    }

    /**
     * @description trackCaseAge description
     *
     * @param newRecords (Map<IdsObject>): newRecords
     * @param oldRecords (Map<IdsObject>): oldRecords
     */
    public static void trackCaseAge(Map<Id, sObject> newRecords, Map<Id, sObject> oldRecords) {
        List<Case> caseList = new List<Case>();
        Map<Id, Case> oldValues = new Map<Id, Case>();

        for (Id newRecordId : newRecords.keySet()) {
            //Get old and new values for the Case
            Case newCase = (Case) newRecords.get(newRecordId);
            caseList.add(newCase);
            Case oldCase = (Case) oldRecords.get(newRecordId);
            oldValues.put(newRecordId, oldCase);
        }

        boolean isInsert = false;

        //get case ids
        set<Id> cids = new Set<Id>();

        for (Case c : caseList) {
            cids.add(c.Id);
        }

        //get pause status values for each Case
        map<String, set<String>> pauseStatusMap = new Map<String, set<String>>();

        for (Case eachCase : caseList) {
            String pauseStatusList = eachCase.sd_Pause_Statuses__c;

            if (pauseStatusList != null) {
                set<String> pauseStatusSet = new Set<String>(pauseStatusList.split(','));
                pauseStatusMap.put(eachCase.Id, pauseStatusSet);
            }
        }

        //insert or update based on oldMap status
        if (oldValues == null) {
            isInsert = true;
        }

        for (Case c : caseList) {
            set<String> pauseStatusSet = pauseStatusMap.get(c.Id);
            Decimal minDiff = 0;
            Decimal totalPauseTime = 0;
            if (isInsert) {
                c.Last_Status_Change__c = System.now();

                c.Case_Age_In_Business_Hours__c = 0;
                c.Consultant_Case_Duration__c = 0;
                c.Consultant_Time_in_Pause_Status__c = 0;

                c.SME_Case_Duration__c = 0;
                c.SME_Time_in_Pause_Status__c = 0;

                c.Manager_Case_Duration__c = 0;
                c.Manager_Time_in_Pause_Status__c = 0;
            } else {
                //Check if Status changed OR if an email case were premoted to a support case with the same status
                if ((c.Awaiting_Status__c != oldValues.get(c.Id).Awaiting_Status__c)) {
                    if (c.Last_Status_Change__c != null) {
                        //get time difference between now and the date/time when the case were transferred
                        long timeDiff = BusinessHours.diff(c.BusinessHoursId, c.Last_Status_Change__c, System.now());
                        //convert millisecons to min
                        minDiff = (timeDiff.intValue() / 1000) / 60;
                    }

                    if (pauseStatusSet != null) {
                        if (pauseStatusSet.contains(c.Awaiting_Status__c)) {
                            c.Last_Status_Change__c = System.now();
                            //c.Time_in_Pause_Status__c += minDiff;
                        }

                        if (pauseStatusSet.contains(oldValues.get(c.Id).Awaiting_Status__c) && !pauseStatusSet.contains(c.Awaiting_Status__c)) {
                            //Manager time in Pause Status
                            if (c.Out_of_Internal_SLA__c == true && c.Out_of_External_SLA__c == true) {
                                if (c.Manager_Time_in_Pause_Status__c == null) {
                                    c.Manager_Time_in_Pause_Status__c = 0;
                                }
                                c.Manager_Time_in_Pause_Status__c += minDiff;
                            } else if (c.Out_of_Internal_SLA__c == true && c.Out_of_External_SLA__c == false) {
                                //SME time in Pause Status
                                if (c.SME_Time_in_Pause_Status__c == null) {
                                    c.SME_Time_in_Pause_Status__c = 0;
                                }
                                c.SME_Time_in_Pause_Status__c += minDiff;
                            } else if (c.Out_of_Internal_SLA__c == false && c.Out_of_External_SLA__c == false) {
                                //Consultant time in Pause Status
                                if (c.Consultant_Time_in_Pause_Status__c == null) {
                                    c.Consultant_Time_in_Pause_Status__c = 0;
                                }
                                c.Consultant_Time_in_Pause_Status__c += minDiff;
                            }
                            totalPauseTime = c.Manager_Time_in_Pause_Status__c + c.SME_Time_in_Pause_Status__c + c.Consultant_Time_in_Pause_Status__c;
                        }
                    }
                }
            }

            //get time difference between now and the date/time when the case were created
            long timeDiffCreatedDate = BusinessHours.diff(c.BusinessHoursId, c.CreatedDate, System.now());
            //convert millisecons to min
            Decimal minDiffCreatedDate = (timeDiffCreatedDate.intValue() / 1000) / 60;
        }
    }
    /**
     * @description updateCaseServiceTypeInfoBeforeUpdate description
     *
     * @param newCaseRecords (List<Case>): newCaseRecords
     * @param oldCaseRecords (Map<IdCase>): oldCaseRecords
     */
    public static void updateCaseServiceTypeInfoBeforeUpdate(List<Case> newCaseRecords, Map<Id, Case> oldCaseRecords) {
        Set<Id> serviceTypeIdSet = new Set<Id>();
        Set<Id> serviceGroupIdSet = new Set<Id>();
        Set<Id> serviceGroupDefaultIdSet = new Set<Id>();
        Boolean DDSTICase = true; // Added for DD STI Case
        List<GroupMember> queueGroup;

        Map<String, Schema.RecordTypeInfo> caseRecordTypeMap = Case.sObjectType.getDescribe().getRecordTypeInfosByName();
        Map<String, Schema.RecordTypeInfo> caseDevRecordTypeMap = Case.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
        Map<Id, Service_Group_Type__c> serviceGroupTypeMap = new Map<Id, Service_Group_Type__c>();
        Map<String, Service_Group_Type__c> serviceTypeWithServiceGroupTypeMap = new Map<String, Service_Group_Type__c>();
        Map<String, Id> queueMap = new Map<String, Id>();
        // To fetch the service group type id for NBFS Service Groups:
        String ServiceGroupTypeId;

        //RN - CloudSmiths 2020-01-22 - Remove FFLIB query from the selector layer and do an inline query
        //to resolve the sites user from not access the group object due to strickter security mesures in the new SF release
        //
        //List<Group> caseQueues = new GroupsSelector().selectByType('Queue');
        List<Group> caseQueues = [SELECT Id, Name, DeveloperName FROM Group WHERE Type = 'Queue'];
        List<GroupMember> stiqueueGroup = [
            SELECT Id, Group.DeveloperName
            FROM GroupMember
            WHERE UserOrGroupId = :UserInfo.getUserId() AND (group.type = 'Queue' OR group.type = 'Regular')
        ];

        //Add all Queues to a Map
        for (Group eachQueue : caseQueues) {
            queueMap.put(eachQueue.Name, eachQueue.id);
        }

        //Add all Service Types to a set
        for (Case eachCase : newCaseRecords) {
            String recordTypeName = Schema.getGlobalDescribe().get('Case').getDescribe().getRecordTypeInfosById().get(eachCase.RecordTypeId).getDeveloperName();
            //Validation for DD STI Case Record Type for owner change
            if (recordTypeName == 'DD_STI_Case') {
                Boolean stiTeamLead = false;
                Boolean stiAgent = false;
                if (DDSTICase == true) {
                    queueGroup = stiqueueGroup;
                    //queueGroup  = [SELECT Id,Group.DeveloperName FROM GroupMember where UserOrGroupId =:UserInfo.getUserId() and (group.type = 'Queue' or group.type = 'Regular')];
                    if (queueGroup.size() > 0) {
                        for (GroupMember groupName : queueGroup) {
                            //System.debug('groupName.Group.DeveloperName' + groupName.Group.DeveloperName);
                            if (groupName.Group.DeveloperName == 'DD_Advice_STI_Team_Leaders')
                                stiTeamLead = true;
                            else if (groupName.Group.DeveloperName == 'DD_Advice_STI' && stiTeamLead == false)
                                stiAgent = true;
                        }
                    }
                }
                //System.debug('eachCase.Category__c' + eachCase.Category__c);
                if (
                    eachCase.Category__c == null &&
                    eachCase.AccountId != null &&
                    oldCaseRecords.get(eachCase.id).Owner_Queue_Name__c != 'DD Advice STI' &&
                    eachCase.Owner_Queue_Name__c != 'DD Advice STI'
                )
                    eachCase.adderror('Please select Case Category.');

                //if(eachCase.DD_Sub_Category__c == null && eachCase.AccountId != null && oldCaseRecords.get(eachCase.id).Owner_Queue_Name__c != 'DD Advice STI' && eachCase.Owner_Queue_Name__c != 'DD Advice STI')
                //eachCase.adderror('Please select Case Sub Category.');

                if (eachCase.Status != oldCaseRecords.get(eachCase.id).Status && stiTeamLead == true) {
                    eachCase.Bypass_Validation_Rules__c = true;
                }
                if (eachCase.Discount_Approved__c != oldCaseRecords.get(eachCase.id).Discount_Approved__c && stiTeamLead == false && eachCase.Discount__c > 11)
                    eachCase.adderror('You cannot update the Discount Approved.');

                if (eachCase.OwnerId != oldCaseRecords.get(eachCase.id).OwnerId) {
                    List<Case> queueCases = new CasesSelector().selectCasesByQueueName('DD Advice STI');
                    if (queueCases.size() > 0) {
                        for (Case queueCase : queueCases) {
                            //System.debug('eachCase.CreatedDate' + eachCase.CreatedDate);
                            //System.debug('queueCase.CreatedDate' + queueCase.CreatedDate);
                            if (eachCase.CreatedDate > queueCase.CreatedDate && !queueCase.isClosed && stiTeamLead == false) {
                                eachCase.adderror('Please select previous Case.');
                                break;
                            }
                        }
                    }

                    if (
                        String.valueOf(eachCase.OwnerId).startsWith('005') &&
                        stiTeamLead == false &&
                        oldCaseRecords.get(eachCase.id).OwnerId == UserInfo.getUserId()
                    )
                        eachCase.adderror('You cannot update the Lead Owner.');
                    else if (stiTeamLead == false && stiAgent == true && String.valueOf(eachCase.OwnerId).startsWith('00G'))
                        eachCase.adderror('You cannot update the Case Owner to Queue.');
                    else if (
                        oldCaseRecords.get(eachCase.id).OwnerId != UserInfo.getUserId() &&
                        String.valueOf(oldCaseRecords.get(eachCase.id).OwnerId).startsWith('005') &&
                        (eachCase.OwnerId == UserInfo.getUserId() ||
                        eachCase.OwnerId != UserInfo.getUserId()) &&
                        stiTeamLead == false
                    )
                        eachCase.adderror('You cannot update the Lead Owner.');
                }
                //DDSTICase = false;
            }
            //Determine if the case was manually created, classified, transferred or Bulk transferred
            if (eachCase.Bulk_Transfer_Selected_Cases__c && recordTypeName != 'NBFS_Dispute_Resolution' && recordTypeName != 'DD_STI_Case') {
                serviceGroupDefaultIdSet.add(eachCase.Service_Group_Search__c);
                serviceGroupIdSet.add(eachCase.Service_Group_Search__c);
                eachCase.sd_Service_Group_Id__c = eachCase.Service_Group_Search__c;

                //Koketso: added to bypass validation rules when bulk transfered
                eachCase.Bypass_Validation_Rules__c = true;

                //System.debug('###eachCase.sd_Service_Group_Id__c : ' + eachCase.sd_Service_Group_Id__c);

                //Reset service type and levels as we now use a new service group
                eachCase.sd_Service_Level_Id__c = null;
                eachCase.sd_Service_Type_Id__c = null;
                eachCase.Type__c = null;
                eachCase.Subtype__c = null;
                eachCase.Product__c = null;
            } else {
                if (oldCaseRecords.get(eachCase.id).sd_Service_Type_Id__c != eachCase.sd_Service_Type_Id__c) {
                    serviceTypeIdSet.add(eachCase.sd_Service_Type_Id__c);
                } else if (oldCaseRecords.get(eachCase.id).sd_Service_Group_Type_Id__c != eachCase.sd_Service_Group_Type_Id__c) {
                    serviceGroupIdSet.add(eachCase.sd_Service_Group_Id__c);
                } else if (eachCase.NBFS_Category__c != null && eachCase.Source__c != null && eachCase.Case_Ownership__c != null) {
                    // Added by kalyani to get service Group ID's for NBFS recordtype
                    serviceGroupIdSet.add(eachCase.sd_Service_Group_Id__c);
                } else if (eachCase.NBFS_Category__c != null && eachCase.Source__c == null) {
                    eachCase.adderror('Please select Source for the Category.');
                } //Ashok adde the following check for AIP Cases
                else if(eachCase.RecordType.Name == 'AIP Case'){
                    serviceGroupIdSet.add(eachCase.sd_Service_Group_Id__c);
                }else if (
                    recordTypeName == 'NBFS_Dispute_Resolution' &&
                    (oldCaseRecords.get(eachCase.id).OwnerId != eachCase.OwnerId) &&
                    (eachCase.ContactId == null ||
                    eachCase.Expectation_of_the_Customer__c == null ||
                    eachCase.Incident_Date__c == null ||
                    eachCase.NBFS_Category__c == null ||
                    eachCase.Source__c == null ||
                    eachCase.Originated_By__c == null)
                ) {
                    eachCase.adderror('You cannot change the case owner. Please Edit the case to enter the required information.');
                } else if (eachCase.NBFS_Category__c == null && recordTypeName == 'NBFS_Dispute_Resolution' && eachCase.ClientFinderAction__c == false) {
                    //else if(eachCase.NBFS_Category__c == null && recordTypeName == 'NBFS_Dispute_Resolution'){
                    eachCase.adderror('Please select Category for the Case.');
                } else if (eachCase.Source__c == null && recordTypeName == 'NBFS_Dispute_Resolution' && eachCase.ClientFinderAction__c == false) {
                    //else if(eachCase.Source__c == null && recordTypeName == 'NBFS_Dispute_Resolution'){
                    eachCase.adderror('Please select Source for the Category of the case.');
                }
                // Poulami Added to store the Service Group Type for Classified Cases for NBFS Case Record Type:
                if (eachCase.NBFS_Category__c != null && eachCase.Source__c != null && eachCase.Case_Ownership__c == null) {
                    if (eachCase.Service_Group_Search__c == null)
                        serviceGroupIdSet.add(eachCase.sd_Service_Group_Id__c);
                    else
                        serviceGroupIdSet.add(eachCase.Service_Group_Search__c);
                }
                eachCase.ClientFinderAction__c = false;
            }
        }
        DDSTICase = false;

        // Chandra Bhushan Singh: 20210106: Remove blanks and nulls from sets
        serviceTypeIdSet.remove(null);
        serviceGroupIdSet.remove(null);
        serviceGroupDefaultIdSet.remove(null);

        if (serviceTypeIdSet.size() > 0) {
            List<Service_Group_Type__c> serviceGroupTypesforServiceType = new ServiceGroupTypesSelector()
                .selectByServiceTypeWithGroupAndServiceInfo(serviceTypeIdSet);
            serviceGroupTypeMap.putAll(serviceGroupTypesforServiceType);
        }

        if (serviceGroupIdSet.size() > 0) {
            List<Service_Group_Type__c> serviceGroupTypesforServiceGroup = new ServiceGroupTypesSelector()
                .selectByServiceGroupWithGroupAndServiceInfo(serviceGroupIdSet);
            // To fetch the service group type id for NBFS Service Groups:
            ServiceGroupTypeId = serviceGroupTypesforServiceGroup[0].Id;
            serviceGroupTypeMap.putAll(serviceGroupTypesforServiceGroup);
        }

        if (serviceGroupDefaultIdSet.size() > 0) {
            List<Service_Group_Type__c> serviceGroupTypesforServiceGroup = new ServiceGroupTypesSelector()
                .selectByServiceGroupWithServiceLevelInfo(serviceGroupDefaultIdSet);

            //Add Service Group types to map with Service Group
            if (!serviceGroupTypesforServiceGroup.isEmpty()) {
                for (Service_Group_Type__c eachSrviceGrouppType : serviceGroupTypesforServiceGroup) {
                    serviceTypeWithServiceGroupTypeMap.put(eachSrviceGrouppType.Service_Group__c, eachSrviceGrouppType);
                }
            }
        }
        ///----Added newly on 13052021 to avoid soql query inside the for loop

        Schema.DescribeSObjectResult r= case.SObjectType.getDescribe();
        List<Schema.RecordTypeInfo> rtInfo = r.getRecordTypeInfos();
        //System.debug('RT==>'+rtInfo);
        Map<String,Id> recordtypeNameAndIdMap = new Map<String,Id>();
        for(Schema.RecordTypeInfo stinf : rtInfo){
            recordtypeNameAndIdMap.put(stinf.getName(),stinf.getRecordTypeId());
        }
        //---end----
        for (Case eachCase : newCaseRecords) {
            String recordTypeName = Schema.getGlobalDescribe().get('Case').getDescribe().getRecordTypeInfosById().get(eachCase.RecordTypeId).getDeveloperName();
            //Change ownership for bulk transfer cases and set Service Group Type
            if (
                eachCase.Bulk_Transfer_Selected_Cases__c == true &&
                eachCase.sd_Service_Group_Id__c != null &&
                recordTypeName != 'NBFS_Dispute_Resolution' &&
                recordTypeName != 'DD_STI_Case'
            ) {
                if (serviceTypeWithServiceGroupTypeMap.containsKey(eachCase.sd_Service_Group_Id__c)) {
                    //Koketso - assign the correct record type to case after transfer
                    recordTypeName = serviceTypeWithServiceGroupTypeMap.get(eachCase.sd_Service_Group_Id__c).Service_Group__r.Assign_Record_Type__c;
                    //RecordType rType = [SELECT Id, Name FROM RecordType WHERE Name = :recordTypeName AND sObjectType = :'Case'];
                    //if (rtype != null) { // changed above 2 lines to the below  on 13052021
                    if(recordtypeNameAndIdMap != null && recordtypeNameAndIdMap.containsKey(recordTypeName) ){
                        //eachCase.RecordTypeId = rType.Id;
                        eachCase.RecordTypeId = recordtypeNameAndIdMap.get(recordTypeName);
                    }
                    //Koketso - update SLA notification users on bulk transfer cases
                    eachCase.Internal_SLA_Notification_User__c = serviceTypeWithServiceGroupTypeMap.get(eachCase.sd_Service_Group_Id__c)
                        .Service_Group__r.Internal_SLA_Notification_User__c;
                    eachCase.External_SLA_Notification_User__c = serviceTypeWithServiceGroupTypeMap.get(eachCase.sd_Service_Group_Id__c)
                        .Service_Level__r.External_SLA_Notification_User__c;

                    String queueName = serviceTypeWithServiceGroupTypeMap.get(eachCase.sd_Service_Group_Id__c).Service_Group__r.Queue__c;

                    if (queueName != null && queueMap.containsKey(queueName)) {
                        eachCase.OwnerId = queueMap.get(queueName);
                        eachCase.sd_Service_Group_Type_Id__c = serviceTypeWithServiceGroupTypeMap.get(eachCase.sd_Service_Group_Id__c).Id;
                    }
                }

                //Clear Service Group Search and bulk transfer is cleared by workflow
                //eachCase.Bulk_Transfer_Selected_Cases__c = false;
                eachCase.Service_Group_Search__c = null;
            }
            // Poulami Added to store the Service Group Type Id for Classified Cases for NBFS Case Record Type:
            if (eachCase.NBFS_Category__c != null && eachCase.Source__c != null && eachCase.Case_Ownership__c == null) {
                eachCase.sd_Service_Group_Type_Id__c = ServiceGroupTypeId;
                eachCase.sd_Service_Group_Id__c = eachCase.Service_Group_Search__c;
            }
            //end

            if (serviceGroupTypeMap.containsKey(eachCase.sd_Service_Group_Type_Id__c) && recordTypeName != 'Short Term Complaint') {
                // Kalyani Modified the condition for NBFS Case Record Type
                if (
                    (!serviceGroupTypeMap.isEmpty() && oldCaseRecords.get(eachCase.id).sd_Service_Group_Type_Id__c != eachCase.sd_Service_Group_Type_Id__c) ||
                    (eachCase.NBFS_Category__c != null &&
                    eachCase.Source__c != null)
                ) {
                    if (
                        serviceGroupTypeMap.get(eachCase.sd_Service_Group_Type_Id__c).Service_Type__c != null &&
                        caseRecordTypeMap.containsKey(serviceGroupTypeMap.get(eachCase.sd_Service_Group_Type_Id__c).Service_Type__r.Case_Record_Type__c)
                    ) {
                        if (!eachCase.Bulk_Transfer_Selected_Cases__c) {
                            eachCase.RecordTypeId = caseRecordTypeMap.get(
                                    serviceGroupTypeMap.get(eachCase.sd_Service_Group_Type_Id__c).Service_Type__r.Case_Record_Type__c
                                )
                                .RecordTypeId;
                        }
                    }
                    if(recordTypeName != 'Short_term_Complaint'){ // added by Mbuyiseni to exclude STI from the below code change
                        eachCase.BusinessHoursId = serviceGroupTypeMap.get(eachCase.sd_Service_Group_Type_Id__c).Service_Group__r.Business_Hours__c;
                        eachCase.sd_Email_Template_Case_Creation__c = serviceGroupTypeMap.get(eachCase.sd_Service_Group_Type_Id__c).Service_Group__r.Email_Template_Case_Creation__c;
                        eachCase.sd_Email_Template_Case_Classification__c = serviceGroupTypeMap.get(eachCase.sd_Service_Group_Type_Id__c).Service_Level__r.Email_Template_Case_Classification__c;
                        eachCase.sd_Email_Template_Case_Closure__c = serviceGroupTypeMap.get(eachCase.sd_Service_Group_Type_Id__c).Service_Level__r.Email_Template_Case_Closure__c;
                        eachCase.sd_Max_SLA_Units__c = serviceGroupTypeMap.get(eachCase.sd_Service_Group_Type_Id__c).Service_Level__r.Max_SLA_Units__c;
                        eachCase.sd_Max_SLA_Time_Measure__c = serviceGroupTypeMap.get(eachCase.sd_Service_Group_Type_Id__c).Service_Level__r.Max_SLA_Time_Measure__c;
                        eachCase.sd_Service_Group__c = serviceGroupTypeMap.get(eachCase.sd_Service_Group_Type_Id__c).Service_Group__r.Name;
                        eachCase.sd_Response_Email_Address__c = serviceGroupTypeMap.get(eachCase.sd_Service_Group_Type_Id__c).Service_Group__r.Response_Email_Address__c;
                        eachCase.sd_Internal_SLA_Time_Measure__c = serviceGroupTypeMap.get(eachCase.sd_Service_Group_Type_Id__c).Service_Group__r.Internal_SLA_Time_Measure__c;
                        eachCase.sd_Internal_SLA_Units__c = serviceGroupTypeMap.get(eachCase.sd_Service_Group_Type_Id__c).Service_Group__r.Internal_SLA_Units__c;
                        eachCase.sd_External_SLA_Units__c = serviceGroupTypeMap.get(eachCase.sd_Service_Group_Type_Id__c).Service_Level__r.External_SLA_Units__c;
                        eachCase.sd_External_SLA_Time_Measure__c = serviceGroupTypeMap.get(eachCase.sd_Service_Group_Type_Id__c).Service_Level__r.External_SLA_Time_Measure__c;
                        eachCase.sd_Pause_Statuses__c = serviceGroupTypeMap.get(eachCase.sd_Service_Group_Type_Id__c).Service_Group__r.Pause_Statuses__c;
                        eachCase.External_SLA_Hours__c = decimal.valueOf(serviceGroupTypeMap.get(eachCase.sd_Service_Group_Type_Id__c).Service_Level__r.External_SLA_Units__c);
                    
                    //RN : Communication plan stamp - NEXT PHASE - TO ALLOW THE PLAN TO BE CHNAGED BASED ON SERVICE GROUP UPDATE
                    //     TODO: If the service plan Id changes all exiting communication tasks on a case should be deleted and new
                    //           tasks based on the new Id (Comm Plan) should be created
                    // DO NOT DELETE
                    //eachCase.sd_Communication_Plan_Id__c = serviceGroupTypeMap.get(eachCase.sd_Service_Group_Type_Id__c).sd_Communication_Plan__c;
                    eachCase.BusinessHoursId = serviceGroupTypeMap.get(eachCase.sd_Service_Group_Type_Id__c).Service_Group__r.Business_Hours__c;
                    eachCase.sd_Email_Template_Case_Creation__c = serviceGroupTypeMap.get(eachCase.sd_Service_Group_Type_Id__c)
                        .Service_Group__r.Email_Template_Case_Creation__c;
                    eachCase.sd_Email_Template_Case_Classification__c = serviceGroupTypeMap.get(eachCase.sd_Service_Group_Type_Id__c)
                        .Service_Level__r.Email_Template_Case_Classification__c;
                    eachCase.sd_Email_Template_Case_Closure__c = serviceGroupTypeMap.get(eachCase.sd_Service_Group_Type_Id__c)
                        .Service_Level__r.Email_Template_Case_Closure__c;
                    eachCase.sd_Max_SLA_Units__c = serviceGroupTypeMap.get(eachCase.sd_Service_Group_Type_Id__c).Service_Level__r.Max_SLA_Units__c;
                    eachCase.sd_Max_SLA_Time_Measure__c = serviceGroupTypeMap.get(eachCase.sd_Service_Group_Type_Id__c)
                        .Service_Level__r.Max_SLA_Time_Measure__c;
                    eachCase.sd_Service_Group__c = serviceGroupTypeMap.get(eachCase.sd_Service_Group_Type_Id__c).Service_Group__r.Name;
                    eachCase.sd_Response_Email_Address__c = serviceGroupTypeMap.get(eachCase.sd_Service_Group_Type_Id__c)
                        .Service_Group__r.Response_Email_Address__c;
                    eachCase.sd_Internal_SLA_Time_Measure__c = serviceGroupTypeMap.get(eachCase.sd_Service_Group_Type_Id__c)
                        .Service_Group__r.Internal_SLA_Time_Measure__c;
                    eachCase.sd_Internal_SLA_Units__c = serviceGroupTypeMap.get(eachCase.sd_Service_Group_Type_Id__c).Service_Group__r.Internal_SLA_Units__c;
                    eachCase.sd_External_SLA_Units__c = serviceGroupTypeMap.get(eachCase.sd_Service_Group_Type_Id__c).Service_Level__r.External_SLA_Units__c;
                    eachCase.sd_External_SLA_Time_Measure__c = serviceGroupTypeMap.get(eachCase.sd_Service_Group_Type_Id__c)
                        .Service_Level__r.External_SLA_Time_Measure__c;
                    eachCase.sd_Pause_Statuses__c = serviceGroupTypeMap.get(eachCase.sd_Service_Group_Type_Id__c).Service_Group__r.Pause_Statuses__c;
                    eachCase.External_SLA_Hours__c = decimal.valueOf(
                        serviceGroupTypeMap.get(eachCase.sd_Service_Group_Type_Id__c).Service_Level__r.External_SLA_Units__c
                    );
                }
                    // Kalyani - configure of SLA's for NBFS Case Record Type:
                    if (recordTypeName == 'NBFS_Dispute_Resolution' || (eachCase.NBFS_Category__c != null && eachCase.Source__c != null)) {
                        String uRoleId = UserInfo.getUserRoleId();
                        //List<Group> groupWithRole=[Select Id From Group where RelatedId=:uRoleId and type= 'Role'];
                        List<Group> groupWithRole = new GroupsSelector().selectByGroupRole(uRoleId, 'Role');
                        /*queueGroup = [
                            SELECT Id
                            FROM GroupMember
                            WHERE
                                (UserOrGroupId = :groupWithRole[0].Id
                                OR UserOrGroupId = :UserInfo.getUserId())
                                AND group.name = :serviceGroupTypeMap.get(eachCase.sd_Service_Group_Type_Id__c).Service_Group__r.Queue__c
                                AND group.type = 'Queue'
                        ];*/
                        //Added for short term insurance cases
                        //List<GroupMember> queueGroup;
                        if(recordTypeName == 'Short_term_Complaint'){
                            if(!groupWithRole.isEmpty()){
                                queueGroup = new GroupMemberSelector().selectByRole(UserInfo.getUserId(),eachCase.sd_Service_Group_Type_Id__c,'Queue');

                                                            //[SELECT Id FROM GroupMember where UserOrGroupId =:groupWithRole[0].Id and 
                                                            //group.name=:serviceGroupTypeMap.get(eachCase.sd_Service_Group_Type_Id__c).Service_Group__r.Queue__c and group.type = 'Queue'];
                            }else{
                                queueGroup = new GroupMemberSelector().selectByRole(UserInfo.getUserId(),eachCase.sd_Service_Group_Type_Id__c,'Queue');

                                //[SELECT Id FROM GroupMember where UserOrGroupId =:UserInfo.getUserId() and 
                                //group.name=:serviceGroupTypeMap.get(eachCase.sd_Service_Group_Type_Id__c).Service_Group__r.Queue__c and group.type = 'Queue'];
                            }
                        }else{
                            queueGroup = new GroupMemberSelector().selectByRole(UserInfo.getUserId(),eachCase.sd_Service_Group_Type_Id__c,'Queue');
                            
                            //[SELECT Id FROM GroupMember where (UserOrGroupId =:groupWithRole[0].Id or UserOrGroupId =:UserInfo.getUserId()) and 
                            // group.name=:serviceGroupTypeMap.get(eachCase.sd_Service_Group_Type_Id__c).Service_Group__r.Queue__c and group.type = 'Queue'];
                        }
                        
                            /*queueGroups = [SELECT Id FROM GroupMember where (UserOrGroupId =:groupWithRole[0].Id or UserOrGroupId =:UserInfo.getUserId()) and 
                                                        group.name=:serviceGroupTypeMap.get(eachCase.sd_Service_Group_Type_Id__c).Service_Group__r.Queue__c and group.type = 'Queue'];*/

                        
                        
                        if(recordTypeName != 'Short_term_Complaint'){ //added by short term insurance 
                            queueGroup = new GroupMemberSelector().selectByGroupName(groupWithRole[0].Id, UserInfo.getUserId(), serviceGroupTypeMap.get(eachCase.sd_Service_Group_Type_Id__c).Service_Group__r.Queue__c, 'Queue');
                        }
                        
                        //List<User> LevelCheck = [SELECT Id, Level_1__c FROM User WHERE Id = :UserInfo.getUserId()];
                        User LevelCheck = new UsersSelector().selectById(UserInfo.getUserId());
                        if (
                            recordTypeName == 'NBFS_Dispute_Resolution' &&
                            (!eachCase.isClosed) &&
                            (LevelCheck.Level_1__c == false) &&
                            ((oldCaseRecords.get(eachCase.id).OwnerId ==
                            queueMap.get(serviceGroupTypeMap.get(eachCase.sd_Service_Group_Type_Id__c).Service_Group__r.Queue__c)) ||
                            (oldCaseRecords.get(eachCase.id).OwnerId != eachCase.OwnerId) ||
                            (eachCase.OwnerId != UserInfo.getUserId()))
                        ) {
                            if (queueGroup.isEmpty())
                                eachCase.adderror('You cannot update the Case.');
                        } else if (eachCase.isClosed && eachCase.Reopen_Case_Approval_Required__c == false)
                            eachCase.adderror('The Case is already Closed.');
                        else if (
                            (oldCaseRecords.get(eachCase.id).NBFS_Category__c != eachCase.NBFS_Category__c) &&
                            (eachCase.OwnerId == UserInfo.getUserId()) &&
                            eachCase.NBFS_Category__c != null &&
                            queueGroup.isEmpty()
                        )
                            eachCase.adderror('The Category of the Case cannot be the updated.');
                        else if (
                            recordTypeName == 'NBFS_Dispute_Resolution' &&
                            LevelCheck.Level_1__c == true &&
                            (oldCaseRecords.get(eachCase.id).OwnerId ==
                            queueMap.get(serviceGroupTypeMap.get(eachCase.sd_Service_Group_Type_Id__c).Service_Group__r.Queue__c))
                        )
                            eachCase.adderror('You cannot update the Case.');

                        List<String> NBFScategory = eachCase.NBFS_Category__c.split(' ');
                        String level = NBFScategory[1];
                        String servicegroupName = eachCase.sd_Service_Group__c;
                        if (eachCase.sd_Service_Group__c.contains('Complaints')) {
                            servicegroupName = eachCase.sd_Service_Group__c.substring(0, eachCase.sd_Service_Group__c.indexOf('Complaints'));
                        }
                        string specsearch = servicegroupName + level + eachCase.Source__c;
                        specsearch = specsearch.replace(' ', '');
                        //string specsearch = eachCase.sd_Service_Group__c+level+eachCase.Source__c;
                        //specsearch = specsearch.replace(' ','');
                        /*List<SLA_Configuration__mdt> SlaCalNBFS = [
                            SELECT
                                id,
                                External_SLA_Units__c,
                                Internal_SLA_Time_Measure__c,
                                Internal_SLA_Units__c,
                                External_SLA_Time_Measure__c,
                                MasterLabel,
                                Service_Group__c,
                                DeveloperName
                            FROM SLA_Configuration__mdt
                            WHERE MasterLabel = :specsearch
                        ];*/
                        List<SLA_Configuration__mdt> SlaCalNBFS = new SLAConfigurationCustomMdtSelector().selectByLabel(specsearch);
                        if (SlaCalNBFS.size() > 0) {
                            eachCase.sd_External_SLA_Units__c = SlaCalNBFS[0].External_SLA_Units__c;
                            eachCase.sd_External_SLA_Time_Measure__c = SlaCalNBFS[0].External_SLA_Time_Measure__c;
                            eachCase.sd_Internal_SLA_Time_Measure__c = SlaCalNBFS[0].Internal_SLA_Time_Measure__c;
                            eachCase.sd_Internal_SLA_Units__c = SlaCalNBFS[0].Internal_SLA_Units__c;
                            eachCase.External_SLA_Hours__c = decimal.valueOf(SlaCalNBFS[0].External_SLA_Units__c);
                            eachCase.External_SLA_Notification_User__c = serviceGroupTypeMap.get(eachCase.sd_Service_Group_Type_Id__c)
                                .Service_Level__r.External_SLA_Notification_User__c;
                            eachCase.Internal_SLA_Notification_User__c = serviceGroupTypeMap.get(eachCase.sd_Service_Group_Type_Id__c)
                                .Service_Group__r.Internal_SLA_Notification_User__c;
                            if (eachCase.Service_Group_Search__c == null)
                                eachCase.Service_Group_Search__c = serviceGroupTypeMap.get(eachCase.sd_Service_Group_Type_Id__c).Service_Group__r.Id;
                            if (eachCase.sd_Original_Service_Group__c == null || eachCase.sd_Service_Group__c == null) {
                                eachCase.sd_Original_Service_Group__c = serviceGroupTypeMap.get(eachCase.sd_Service_Group_Type_Id__c).Service_Group__r.Name;
                                eachCase.sd_Service_Group__c = serviceGroupTypeMap.get(eachCase.sd_Service_Group_Type_Id__c).Service_Group__r.Name;
                            }
                        }
                        /***************Addd by Kalyani to change Owner when category changes from Level 1 to 2 and throw error if changed to 3***********/
                        /*if((oldCaseRecords.get(eachCase.id).NBFS_Category__c != eachCase.NBFS_Category__c) && (eachCase.OwnerId != queueMap.get(serviceGroupTypeMap.get(eachCase.sd_Service_Group_Type_Id__c).Service_Group__r.Queue__c))){
                            eachCase.adderror('You cannot update the Category of the Case.');
                        }*/
                        /*********End of code by Kalyani**********/
                    }
                    //Calculate Internal SLA
                    if (
                        serviceGroupTypeMap.get(eachCase.sd_Service_Group_Type_Id__c).Service_Group__r.Internal_SLA_Time_Measure__c != null &&
                        serviceGroupTypeMap.get(eachCase.sd_Service_Group_Type_Id__c).Service_Group__r.Internal_SLA_Units__c != null
                    ) {
                        Map<String, DateTime> internalSLA = new Map<String, DateTime>();
                        if (
                            eachCase.SLA_Extension_Approval__c != 'Approved' &&
                            eachCase.Internal_SLA_Warning_Date__c != null &&
                            eachCase.Internal_SLA_End_Date__c != null
                        ) {
                            // Kalyani - configure of Internal SLA Date for NBFS Case Record Type
                            //if(recordTypeName == 'NBFS_Dispute_Resolution'){
                            if (eachCase.NBFS_Category__c != null && eachCase.Source__c != null) {
                                internalSLA = calculateSLADateTime(
                                    eachCase.CreatedDate,
                                    eachCase.BusinessHoursId,
                                    eachCase.sd_Internal_SLA_Time_Measure__c,
                                    integer.valueof(eachCase.sd_Internal_SLA_Units__c)
                                );
                            } else {
                                internalSLA = calculateSLADateTime(
                                    eachCase.CreatedDate,
                                    eachCase.BusinessHoursId,
                                    serviceGroupTypeMap.get(eachCase.sd_Service_Group_Type_Id__c).Service_Group__r.Internal_SLA_Time_Measure__c,
                                    integer.valueof(serviceGroupTypeMap.get(eachCase.sd_Service_Group_Type_Id__c).Service_Group__r.Internal_SLA_Units__c)
                                );
                            }
                        } else if (
                            eachCase.SLA_Extension_Approval__c != 'Approved' &&
                            eachCase.Internal_SLA_Warning_Date__c == null &&
                            eachCase.Internal_SLA_End_Date__c == null
                        ) {
                            // Added for Classified Cases for NBFS Case Record Type:
                            if (eachCase.NBFS_Category__c != null && eachCase.Source__c != null) {
                                internalSLA = calculateSLADateTime(
                                    eachCase.CreatedDate,
                                    eachCase.BusinessHoursId,
                                    eachCase.sd_Internal_SLA_Time_Measure__c,
                                    integer.valueof(eachCase.sd_Internal_SLA_Units__c)
                                );
                            }
                        }
                        if (!internalSLA.isEmpty()) {
                            if(recordTypeName != 'Short_term_Complaint'){
                            eachCase.Internal_SLA_Warning_Date__c = internalSLA.get('slaWarningDate');
                            eachCase.Internal_SLA_End_Date__c = internalSLA.get('slaEndDate');
                        }
                        }
                    }

                    //Calculate External SLA
                    if (
                        serviceGroupTypeMap.get(eachCase.sd_Service_Group_Type_Id__c).Service_Level__r.External_SLA_Units__c != null &&
                        serviceGroupTypeMap.get(eachCase.sd_Service_Group_Type_Id__c).Service_Level__r.External_SLA_Time_Measure__c != null
                    ) {
                        Map<String, DateTime> externalSLA = new Map<String, DateTime>();
                        //koketso - when complaint's sla is extended and approved, do not update the sla end date
                        if (
                            eachCase.SLA_Extension_Approval__c != 'Approved' &&
                            eachCase.External_SLA_Warning_Date__c != null &&
                            eachCase.External_SLA_End_Date__c != null
                        ) {
                            // Kalyani - configure of External SLA Date for NBFS Case Record Type
                            //if(recordTypeName == 'NBFS_Dispute_Resolution'){
                            if (eachCase.NBFS_Category__c != null && eachCase.Source__c != null) {
                                externalSLA = calculateSLADateTime(
                                    eachCase.CreatedDate,
                                    eachCase.BusinessHoursId,
                                    eachCase.sd_External_SLA_Time_Measure__c,
                                    integer.valueof(eachCase.sd_External_SLA_Units__c)
                                );
                            }
                            if((eachCase.NBFS_Category__c != null && eachCase.Source__c != null) || recordTypeName == 'Short_term_Complaint'){ 
                                externalSLA = calculateSLADateTime(eachCase.CreatedDate,eachCase.BusinessHoursId,eachCase.sd_External_SLA_Time_Measure__c,
                                                                   integer.valueof(eachCase.sd_External_SLA_Units__c));
                                
                            }
                            else {
                                externalSLA = calculateSLADateTime(
                                    eachCase.CreatedDate,
                                    eachCase.BusinessHoursId,
                                    serviceGroupTypeMap.get(eachCase.sd_Service_Group_Type_Id__c).Service_Level__r.External_SLA_Time_Measure__c,
                                    integer.valueof(serviceGroupTypeMap.get(eachCase.sd_Service_Group_Type_Id__c).Service_Level__r.External_SLA_Units__c)
                                );
                            }
                        } else if (
                            eachCase.SLA_Extension_Approval__c != 'Approved' &&
                            eachCase.External_SLA_Warning_Date__c == null &&
                            eachCase.External_SLA_End_Date__c == null
                        ) {
                            // Added for Classified Cases for NBFS Case Record Type:
                            if (eachCase.NBFS_Category__c != null && eachCase.Source__c != null) {
                                externalSLA = calculateSLADateTime(
                                    eachCase.CreatedDate,
                                    eachCase.BusinessHoursId,
                                    eachCase.sd_External_SLA_Time_Measure__c,
                                    integer.valueof(eachCase.sd_External_SLA_Units__c)
                                );
                            }
                        }
                        if(!externalSLA.isEmpty()){
                            if(recordTypeName != 'Short_term_Complaint'){
                                eachCase.External_SLA_Warning_Date__c = externalSLA.get('slaWarningDate');
                                eachCase.External_SLA_End_Date__c = externalSLA.get('slaEndDate');
                            }
                        }
                        
                    }

                    //Calculate Maximum Extension Date
                    Map<String, DateTime> extensionSLA = new Map<String, DateTime>();
                    if (
                        serviceGroupTypeMap.get(eachCase.sd_Service_Group_Type_Id__c).Service_Level__r.Max_SLA_Units__c != null &&
                        serviceGroupTypeMap.get(eachCase.sd_Service_Group_Type_Id__c).Service_Level__r.Max_SLA_Time_Measure__c != null
                    ) {
                         extensionSLA = calculateSLADateTime(
                            eachCase.External_SLA_End_Date__c,
                            eachCase.BusinessHoursId,
                            serviceGroupTypeMap.get(eachCase.sd_Service_Group_Type_Id__c).Service_Level__r.Max_SLA_Time_Measure__c,
                            integer.valueof(serviceGroupTypeMap.get(eachCase.sd_Service_Group_Type_Id__c).Service_Level__r.Max_SLA_Units__c)
                        );
                        if(recordTypeName != 'Short_term_Complaint'){
                            eachCase.Max_SLA_Extension_Date__c = extensionSLA.get('slaEndDate');
                        }
                    }
                }
            }
        }
    }

    /**
    * @description 
    * @author muvhuso.nekhubvi@absa.africa | 2021-06-06 
    * @param newCaseRecordId 
    **/

    @future (callout=true)  
    public static void refreshCaseClient(Id newCaseRecordId){
        List<Case> currentCase = new CasesSelector().selectByIdWithSLAInfo(newCaseRecordId, 1);
        String siteCode;
        Set<Id> userIds = new Set<Id>();
        userIds.add(UserInfo.getUserId());
        List<User> loggedInUserInfo = new UsersSelector().selectById(userIds); 
        siteCode = loggedInUserInfo[0].SiteCode__c;

        try{
          if(currentCase != null && currentCase.size() > 0){
              if(currentCase[0].ID_Type__c != 'CIF'){
                 AccountCreate_CIF_MDM.GIPResponse createdAccount = AccountCreate_CIF_MDM.createAccountFromMDM(currentCase[0].ID_Type__c, currentCase[0].Customer_ID__c);
                 if (createdAccount.response == 'Success') {
                    currentCase[0].AccountId = createdAccount.accountId; 
                  }
               }else{
                  AccountCreate_CIF_MDM.GIPResponse createdAccountCIF = AccountCreate_CIF_MDM.createAccountFromCIF(currentCase[0].Customer_ID__c,'0',siteCode);
                  if (createdAccountCIF.response == 'Success') {
                    currentCase[0].AccountId = createdAccountCIF.accountId; 
                   }
               }
              
               if(currentCase[0].Type__c == 'PEP High Risk and Very High Risk' || currentCase[0].Type__c == 'Complex Application' || currentCase[0].Type__c == 'Account Maintenance'){
                  Id devRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Stockbrokers and Portfolio Management').getRecordTypeId();
                  currentCase[0].RecordTypeId = devRecordTypeId; 
                  List<BusinessHours> bhObj = new BusinessHoursSelector().selectByIdName('Mondays to Fridays (08h30 - 17h00) excluding Public Holidays' , 1);//[SELECT Id , Name FROM BusinessHours where Name = :'Mondays to Fridays (08h30 - 17h00) excluding Public Holidays'];
                     if(bhObj != null || bhObj.size() > 0){
                        currentCase[0].BusinessHoursId = bhObj[0].Id;
                     }
                }
           update currentCase[0];
      
          }
        }catch(DmlException ex){
            //System.debug('The following exception has occurred: ' + ex.getMessage()); 
            AuditTrailLog.logException(new DMLException(), 'New', 'Error', 'CaseTriggerFunctions', 'refreshCaseClient', ex.getMessage());
        }
    }
    
    /**
    * @description 
    * @author muvhuso.nekhubvi@absa.africa | 2021-06-06 
    * @param newCaseRecordId 
    * @param serviceTypeName 
    * @param accountId 
    * @return String 
    **/
    public static String createEDDCase(Id newCaseRecordId , String serviceTypeName , String accountId){

        Id devRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Onboarding').getRecordTypeId();
        Case eddCase = new Case();
        eddCase.status = 'New';
        eddCase.Type__c = 'Client Onboarding';
        eddCase.Subtype__c = 'High Risk/PEP';
        eddCase.sd_Original_Service_Queue__c = 'Enhanced Due Diligence';
        eddCase.sd_Original_Service_Group__c = 'Enhanced Due Diligence';
        eddCase.sd_Service_Group__c = 'Enhanced Due Diligence';
        eddCase.Product__c = 'SPM';
        eddCase.ParentId = newCaseRecordId;
        eddCase.RecordTypeId = devRecordTypeId;
        eddCase.AccountId = accountId;
        eddCase.Subject = 'High Risk / Pep Client Onboarding';
        eddCase.Description = 'Perform Enhanced Due Diligence';
        eddCase.sd_Service_Type__c = 'High Risk/PEP - SPM';
        try{
            insert eddCase; 
        }catch(DMLException ex){
            //System.debug('The following exception has occurred: ' + ex.getMessage());
            AuditTrailLog.logException(new DMLException(), 'New', 'Error', 'CaseTriggerFunctions', 'createEDDCase', ex.getMessage());
        }
        
    return null;

}
    /**
     * @description updateCaseServiceTypeInfoBeforeInsert description
     *
     * @param newCaseRecords (List<Case>): newCaseRecords
     */
    public static void updateCaseServiceTypeInfoBeforeInsert(List<Case> newCaseRecords) {
        Set<Id> serviceTypeIdSet = new Set<Id>();
        Set<Id> serviceGroupIdSet = new Set<Id>();

        Map<String, Schema.RecordTypeInfo> caseRecordTypeMap = Case.sObjectType.getDescribe().getRecordTypeInfosByName();
        Map<String, Schema.RecordTypeInfo> caseDevRecordTypeMap = Case.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
        Map<Id, Service_Group_Type__c> serviceGroupTypeMap = new Map<Id, Service_Group_Type__c>();

        //Map to carry all queue names for each service group
        Map<String, String> serviceGroupQueueMap = new Map<String, String>();

        //Add all Service Types to a set
        for (Case eachCase : newCaseRecords) {
            String recordTypeName = Schema.getGlobalDescribe().get('Case').getDescribe().getRecordTypeInfosById().get(eachCase.RecordTypeId).getDeveloperName();

            //Added for DD STI Case to link Account to DD STI Case
            if (recordTypeName == 'DD_STI_Case' && eachCase.Customer_ID__c != null && eachCase.AccountId == null) {
                List<Account> acclst = new AccountsSelector().selectByIdNumber(eachCase.Customer_ID__c, 1);
                if (acclst.size() > 0) {
                    eachCase.AccountId = acclst[0].Id;
                    if (acclst[0].PersonContactId != null) {
                        eachCase.ContactId = acclst[0].PersonContactId;
                    }
                }
            }

            if (eachCase.sd_Service_Type_Id__c != null) {
                serviceTypeIdSet.add(eachCase.sd_Service_Type_Id__c);
            } else if (eachCase.sd_Service_Group_Id__c != null) {
                serviceGroupIdSet.add(eachCase.sd_Service_Group_Id__c);
            }
        }

        if (!serviceTypeIdSet.isEmpty()) {
            List<Service_Group_Type__c> serviceGroupTypesforServiceType = new ServiceGroupTypesSelector()
                .selectByServiceTypeWithGroupAndServiceInfo(serviceTypeIdSet);
            serviceGroupTypeMap.putAll(serviceGroupTypesforServiceType);
        }

        if (!serviceGroupIdSet.isEmpty()) {
            List<Service_Group_Type__c> serviceGroupTypesforServiceGroup = new ServiceGroupTypesSelector()
                .selectByServiceGroupWithServiceLevelInfo(serviceGroupIdSet);
            serviceGroupTypeMap.putAll(serviceGroupTypesforServiceGroup);

            //Get list of service groups to get the related queues
            List<Service_Group__c> serviceGroups = new ServiceGroupsSelector().selectById(serviceGroupIdSet);
            if (serviceGroups.size() > 0) {
                for (Service_Group__c sg : serviceGroups) {
                    serviceGroupQueueMap.put(sg.Name, sg.Queue__c);
                }
            }
        }

        Map<String, Id> queueMap = new Map<String, Id>();
        //RN - CloudSmiths 2020-01-22 - Remove FFLIB query from the selector layer and do an inline query
        //to resolve the sites user from not access the group object due to strickter security mesures in the new SF release
        //
        //List<Group> caseQueues = new GroupsSelector().selectByType('Queue');
        List<Group> caseQueues = [SELECT Id, Name, DeveloperName FROM Group WHERE Type = 'Queue'];

        //for short term insurance
        //Map<Id,Short_Term_Insurance_SLA__mdt> shortTermSla = new Map<Id,Short_Term_Insurance_SLA__mdt>([SELECT Category__c, External_SLA_Time_Measure__c,External_SLA_Units__c,Internal_SLA_Time_Measure__c,Internal_SLA_Units__c FROM Short_Term_Insurance_SLA__mdt]);

        for (Group eachQueue : caseQueues) {
            queueMap.put(eachQueue.Name, eachQueue.id);
        }

        for (Case eachCase : newCaseRecords) {
            String caseRecordTypeName = Schema.getGlobalDescribe().get('Case').getDescribe().getRecordTypeInfosById().get(eachCase.RecordTypeId).getDeveloperName(); // added Mbuyiseni to get Record type
            if (!serviceGroupTypeMap.isEmpty() && eachCase.sd_Service_Group_Type_Id__c != null) {
                //Update Case fields based on updated service type / classification
                /*if (
                    serviceGroupTypeMap.get(eachCase.sd_Service_Group_Type_Id__c).Service_Type__c != null &&
                    caseRecordTypeMap.containsKey(serviceGroupTypeMap.get(eachCase.sd_Service_Group_Type_Id__c).Service_Type__r.Case_Record_Type__c)
                ) {
                    eachCase.RecordTypeId = caseRecordTypeMap.get(
                            serviceGroupTypeMap.get(eachCase.sd_Service_Group_Type_Id__c).Service_Type__r.Case_Record_Type__c
                        )
                        .RecordTypeId;
                }*/

                String queueName = serviceGroupTypeMap.get(eachCase.sd_Service_Group_Type_Id__c).Service_Group__r.Queue__c;
                if (
                    queueName != null &&
                    queueMap.containsKey(queueName) &&
                    eachCase.Origin != Label.What_do_you_want_to_do_today &&
                    (eachCase.Case_Ownership__c != 'FPOC' &&
                    eachCase.Case_Ownership__c != 'I will Resolve' &&
                    eachCase.Case_Ownership__c != 'Close')
                ) {
                    eachCase.OwnerId = queueMap.get(queueName);
                } else {
                    eachCase.OwnerId = UserInfo.getUserId();
                }

                //RN : Communication plan stamp
                eachCase.sd_Communication_Plan_Id__c = serviceGroupTypeMap.get(eachCase.sd_Service_Group_Type_Id__c).sd_Communication_Plan__c;

                eachCase.BusinessHoursId = serviceGroupTypeMap.get(eachCase.sd_Service_Group_Type_Id__c).Service_Group__r.Business_Hours__c;
                eachCase.sd_Email_Template_Case_Creation__c = serviceGroupTypeMap.get(eachCase.sd_Service_Group_Type_Id__c)
                    .Service_Group__r.Email_Template_Case_Creation__c;
                eachCase.sd_Email_Template_Case_Classification__c = serviceGroupTypeMap.get(eachCase.sd_Service_Group_Type_Id__c)
                    .Service_Level__r.Email_Template_Case_Classification__c;
                eachCase.sd_Email_Template_Case_Closure__c = serviceGroupTypeMap.get(eachCase.sd_Service_Group_Type_Id__c)
                    .Service_Level__r.Email_Template_Case_Closure__c;
                //eachCase.sd_Max_SLA_Units__c = serviceGroupTypeMap.get(eachCase.sd_Service_Group_Type_Id__c).Service_Level__r.Max_SLA_Units__c;
                //added the logic for STI
                if(eachCase.NBFS_Category__c == 'Level 3' || eachCase.Level__c == 3 && serviceGroupTypeMap.get(eachCase.sd_Service_Group_Type_Id__c).Service_Group__r.Name == 'Absa Short Term Insurance'){
                    eachCase.sd_Max_SLA_Units__c = System.Label.Level_3_Max_SLA_Units;
                }else{
                    eachCase.sd_Max_SLA_Units__c = serviceGroupTypeMap.get(eachCase.sd_Service_Group_Type_Id__c).Service_Level__r.Max_SLA_Units__c;
                }
                eachCase.sd_Max_SLA_Time_Measure__c = serviceGroupTypeMap.get(eachCase.sd_Service_Group_Type_Id__c).Service_Level__r.Max_SLA_Time_Measure__c;

                if (queueName != null && queueMap.containsKey(queueName) && eachCase.Origin != Label.What_do_you_want_to_do_today) {
                    eachCase.sd_Original_Service_Queue__c = serviceGroupTypeMap.get(eachCase.sd_Service_Group_Type_Id__c).Service_Group__r.Queue__c;
                } else {
                    eachCase.sd_Original_Service_Queue__c = UserInfo.getName();
                }

                eachCase.sd_Original_Service_Group__c = serviceGroupTypeMap.get(eachCase.sd_Service_Group_Type_Id__c).Service_Group__r.Name;
                eachCase.sd_Service_Group__c = serviceGroupTypeMap.get(eachCase.sd_Service_Group_Type_Id__c).Service_Group__r.Name;
                eachCase.sd_Response_Email_Address__c = serviceGroupTypeMap.get(eachCase.sd_Service_Group_Type_Id__c)
                    .Service_Group__r.Response_Email_Address__c;
                eachCase.sd_Internal_SLA_Time_Measure__c = serviceGroupTypeMap.get(eachCase.sd_Service_Group_Type_Id__c)
                    .Service_Group__r.Internal_SLA_Time_Measure__c;
                eachCase.sd_Internal_SLA_Units__c = serviceGroupTypeMap.get(eachCase.sd_Service_Group_Type_Id__c).Service_Group__r.Internal_SLA_Units__c;
                eachCase.sd_External_SLA_Units__c = serviceGroupTypeMap.get(eachCase.sd_Service_Group_Type_Id__c).Service_Level__r.External_SLA_Units__c;
                eachCase.sd_External_SLA_Time_Measure__c = serviceGroupTypeMap.get(eachCase.sd_Service_Group_Type_Id__c)
                    .Service_Level__r.External_SLA_Time_Measure__c;
                eachCase.sd_Pause_Statuses__c = serviceGroupTypeMap.get(eachCase.sd_Service_Group_Type_Id__c).Service_Group__r.Pause_Statuses__c;

                // Kalyani - configure of SLA's for NBFS Case Record Type
                if (eachCase.NBFS_Category__c != null && eachCase.Source__c != null && serviceGroupTypeMap.get(eachCase.sd_Service_Group_Type_Id__c).Service_Group__r.Name != 'Absa Short Term Insurance') {//added to exclude the short term insurance.
                    List<String> NBFScategory = eachCase.NBFS_Category__c.split(' ');
                    String level = NBFScategory[1];
                    String servicegroupName = eachCase.sd_Service_Group__c;
                    //string specsearch = eachCase.sd_Service_Group__c+level+eachCase.Source__c;
                    //specsearch = specsearch.replace(' ','');
                    if (eachCase.sd_Service_Group__c.contains('Complaints')) {
                        servicegroupName = eachCase.sd_Service_Group__c.substring(0, eachCase.sd_Service_Group__c.indexOf('Complaints'));
                    }
                    string specsearch = servicegroupName + level + eachCase.Source__c;
                    specsearch = specsearch.replace(' ', '');
                    /*List<SLA_Configuration__mdt> SlaCalNBFS = [
                        SELECT
                            id,
                            External_SLA_Units__c,
                            Internal_SLA_Time_Measure__c,
                            Internal_SLA_Units__c,
                            External_SLA_Time_Measure__c,
                            MasterLabel,
                            Service_Group__c,
                            DeveloperName
                        FROM SLA_Configuration__mdt
                        WHERE MasterLabel = :specsearch
                    ];*/
                    List<SLA_Configuration__mdt> SlaCalNBFS = new SLAConfigurationCustomMdtSelector().selectByLabel(specsearch);
                    if (SlaCalNBFS.size() > 0) {
                        eachCase.sd_External_SLA_Units__c = SlaCalNBFS[0].External_SLA_Units__c;
                        eachCase.sd_External_SLA_Time_Measure__c = SlaCalNBFS[0].External_SLA_Time_Measure__c;
                        eachCase.sd_Internal_SLA_Time_Measure__c = SlaCalNBFS[0].Internal_SLA_Time_Measure__c;
                        eachCase.sd_Internal_SLA_Units__c = SlaCalNBFS[0].Internal_SLA_Units__c;
                        eachCase.External_SLA_Hours__c = decimal.valueOf(SlaCalNBFS[0].External_SLA_Units__c);
                        eachCase.Service_Group_Search__c = serviceGroupTypeMap.get(eachCase.sd_Service_Group_Type_Id__c).Service_Group__r.Id;
                        eachCase.External_SLA_Notification_User__c = serviceGroupTypeMap.get(eachCase.sd_Service_Group_Type_Id__c)
                            .Service_Level__r.External_SLA_Notification_User__c;
                        eachCase.Internal_SLA_Notification_User__c = serviceGroupTypeMap.get(eachCase.sd_Service_Group_Type_Id__c)
                            .Service_Group__r.Internal_SLA_Notification_User__c;
                    }
                }

                //Calculate Internal SLA
                //Internal SLA calculation for short term insurance
                if(caseRecordTypeName == 'Short_term_Complaint' && serviceGroupTypeMap.get(eachCase.sd_Service_Group_Type_Id__c).Service_Group__r.Name == 'Absa Short Term Insurance'){
                    //List<Short_Term_Insurance_SLA__mdt> shortTermSla = [SELECT Category__c, External_SLA_Time_Measure__c,External_SLA_Units__c,Internal_SLA_Time_Measure__c,Internal_SLA_Units__c FROM Short_Term_Insurance_SLA__mdt WHERE MasterLabel =: eachCase.NBFS_Category__c]; --Monde
                    List<Short_Term_Insurance_SLA__mdt> shortTermSla = new ShortTermSLAsSelector().selectShortTermSLA(eachCase.NBFS_Category__c);
                    if(!shortTermSla.isEmpty()){
                        
                        eachCase.sd_External_SLA_Units__c = shortTermSla[0].External_SLA_Units__c;
                        eachCase.sd_External_SLA_Time_Measure__c = shortTermSla[0].External_SLA_Time_Measure__c;
                        eachCase.sd_Internal_SLA_Time_Measure__c = shortTermSla[0].Internal_SLA_Time_Measure__c;
                        eachCase.sd_Internal_SLA_Units__c = shortTermSla[0].Internal_SLA_Units__c;
                        eachCase.External_SLA_Hours__c = decimal.valueOf(shortTermSla[0].External_SLA_Units__c);

                        eachCase.Service_Group_Search__c = serviceGroupTypeMap.get(eachCase.sd_Service_Group_Type_Id__c).Service_Group__r.Id;
                        eachCase.External_SLA_Notification_User__c = serviceGroupTypeMap.get(eachCase.sd_Service_Group_Type_Id__c).Service_Level__r.External_SLA_Notification_User__c;
                        eachCase.Internal_SLA_Notification_User__c = serviceGroupTypeMap.get(eachCase.sd_Service_Group_Type_Id__c).Service_Group__r.Internal_SLA_Notification_User__c; 
                    }
                }
                if (
                    serviceGroupTypeMap.get(eachCase.sd_Service_Group_Type_Id__c).Service_Group__r.Internal_SLA_Time_Measure__c != null &&
                    serviceGroupTypeMap.get(eachCase.sd_Service_Group_Type_Id__c).Service_Group__r.Internal_SLA_Units__c != null
                ) {
                    Map<String, DateTime> internalSLA = new Map<String, DateTime>();
                    // Kalyani - configure of Internal SLA Date for NBFS Case Record Type
                    if (eachCase.NBFS_Category__c != null && eachCase.Source__c != null || caseRecordTypeName == 'Short_term_Complaint') {// Mbuyiseni added short term insurance record type
                        internalSLA = calculateSLADateTime(
                            System.now(),
                            eachCase.BusinessHoursId,
                            eachCase.sd_Internal_SLA_Time_Measure__c,
                            integer.valueof(eachCase.sd_Internal_SLA_Units__c)
                        );
                    } else {
                        internalSLA = calculateSLADateTime(
                            System.now(),
                            eachCase.BusinessHoursId,
                            serviceGroupTypeMap.get(eachCase.sd_Service_Group_Type_Id__c).Service_Group__r.Internal_SLA_Time_Measure__c,
                            integer.valueof(serviceGroupTypeMap.get(eachCase.sd_Service_Group_Type_Id__c).Service_Group__r.Internal_SLA_Units__c)
                        );
                    }

                    eachCase.Internal_SLA_Warning_Date__c = internalSLA.get('slaWarningDate');
                    eachCase.Internal_SLA_End_Date__c = internalSLA.get('slaEndDate');
                }

                //Calculate External SLA
                if (
                    serviceGroupTypeMap.get(eachCase.sd_Service_Group_Type_Id__c).Service_Level__r.External_SLA_Units__c != null &&
                    serviceGroupTypeMap.get(eachCase.sd_Service_Group_Type_Id__c).Service_Level__r.External_SLA_Time_Measure__c != null
                ) {
                    Map<String, DateTime> externalSLA = new Map<String, DateTime>();

                    // Kalyani - configure of External SLA Date for NBFS Case Record Type
                    if (eachCase.NBFS_Category__c != null && eachCase.Source__c != null || caseRecordTypeName == 'Short_term_Complaint') { // Mbuyiseni added short term record type
                        externalSLA = calculateSLADateTime(
                            System.now(),
                            eachCase.BusinessHoursId,
                            eachCase.sd_External_SLA_Time_Measure__c,
                            integer.valueof(eachCase.sd_External_SLA_Units__c)
                        );
                    } else {
                        externalSLA = calculateSLADateTime(
                            System.now(),
                            eachCase.BusinessHoursId,
                            serviceGroupTypeMap.get(eachCase.sd_Service_Group_Type_Id__c).Service_Level__r.External_SLA_Time_Measure__c,
                            integer.valueof(serviceGroupTypeMap.get(eachCase.sd_Service_Group_Type_Id__c).Service_Level__r.External_SLA_Units__c)
                        );
                    }

                    eachCase.External_SLA_Warning_Date__c = externalSLA.get('slaWarningDate');
                    eachCase.External_SLA_End_Date__c = externalSLA.get('slaEndDate');
                }

                //Calculate Maximum Extension Date
                if (
                    serviceGroupTypeMap.get(eachCase.sd_Service_Group_Type_Id__c).Service_Level__r.Max_SLA_Units__c != null &&
                    serviceGroupTypeMap.get(eachCase.sd_Service_Group_Type_Id__c).Service_Level__r.Max_SLA_Time_Measure__c != null
                ) {
                    /*Map<String, DateTime> extensionSLA = calculateSLADateTime(
                        eachCase.External_SLA_End_Date__c,
                        eachCase.BusinessHoursId,
                        serviceGroupTypeMap.get(eachCase.sd_Service_Group_Type_Id__c).Service_Level__r.Max_SLA_Time_Measure__c,
                        integer.valueof(serviceGroupTypeMap.get(eachCase.sd_Service_Group_Type_Id__c).Service_Level__r.Max_SLA_Units__c)
                    );*/
                    Map<String, DateTime> extensionSLA = new Map<String, DateTime>();
                    if((eachCase.NBFS_Category__c == 'Level 1' || eachCase.NBFS_Category__c == 'Level 2') && caseRecordTypeName == 'Short_term_Complaint'){
                           
                        extensionSLA = calculateSLADateTime(eachCase.External_SLA_End_Date__c,
                                                            eachCase.BusinessHoursId, serviceGroupTypeMap.get(eachCase.sd_Service_Group_Type_Id__c).Service_Level__r.Max_SLA_Time_Measure__c,
                                                            integer.valueof(System.Label.Leve_1_2_Max_Externsion));
                        
                    }else if(eachCase.NBFS_Category__c == 'Level 3' && caseRecordTypeName == 'Short_term_Complaint'){
                        extensionSLA = calculateSLADateTime(eachCase.External_SLA_End_Date__c,
                                                            eachCase.BusinessHoursId, serviceGroupTypeMap.get(eachCase.sd_Service_Group_Type_Id__c).Service_Level__r.Max_SLA_Time_Measure__c,
                                                            integer.valueof(System.Label.Level_3_Max_Extension));
                        
                    }else{
                        extensionSLA = calculateSLADateTime(eachCase.External_SLA_End_Date__c,
                                                            eachCase.BusinessHoursId, serviceGroupTypeMap.get(eachCase.sd_Service_Group_Type_Id__c).Service_Level__r.Max_SLA_Time_Measure__c,
                                                            integer.valueof(serviceGroupTypeMap.get(eachCase.sd_Service_Group_Type_Id__c).Service_Level__r.Max_SLA_Units__c ));
                        
                    }

                    eachCase.Max_SLA_Extension_Date__c = extensionSLA.get('slaEndDate');
                }
            }
            //Koketso - Check if case is reopened, and assign it to correct queue
            if (eachCase.Case_Reopened_From__c != null && eachCase.sd_Service_Group__c != null) {
                //System.debug(LoggingLevel.FINE, '****Case Reopened****');
                if (serviceGroupQueueMap.containsKey(eachCase.sd_Service_Group__c)) {
                    eachCase.OwnerId = queueMap.get(serviceGroupQueueMap.get(eachCase.sd_Service_Group__c));
                }
            }
        }
    }
    /**
     * @description calculateCaseDuration description
     *
     * @param newCaseRecords (List<Case>): newCaseRecords
     * @param oldCaseRecords (Map<IdCase>): oldCaseRecords
     */
    public static void calculateCaseDuration(List<Case> newCaseRecords, Map<Id, Case> oldCaseRecords) {
        Map<String, Boolean> caseStatusMap = new Map<String, Boolean>();
        Decimal smeHours = 0;
        Decimal managerHours = 0;
        Decimal consultantHours = 0;

        //Get all closed Case status values
        for (CaseStatus eachCaseStatus : [SELECT MasterLabel, IsClosed FROM CaseStatus WHERE IsClosed = TRUE]) {
            caseStatusMap.put(eachCaseStatus.MasterLabel, eachCaseStatus.IsClosed);
        }

        for (Case eachCase : newCaseRecords) {
            //Assign SME hours
            if (eachCase.SME_Case_Duration__c != null) {
                smeHours = eachCase.SME_Case_Duration__c;
            }

            //Assign Manager hours
            if (eachCase.Manager_Case_Duration__c != null) {
                managerHours = eachCase.Manager_Case_Duration__c;
            }

            //Assign Consultant hours
            if (eachCase.Consultant_Case_Duration__c != null) {
                consultantHours = eachCase.Consultant_Case_Duration__c;
            }

            //get time difference between now and the date/time when the case created
            Long timeDiffCreatedDate = BusinessHours.diff(eachCase.BusinessHoursId, eachCase.CreatedDate, System.now());
            //convert millisecons to min
            Decimal minDiffCreatedDate = (timeDiffCreatedDate.intValue() / 1000) / 60;
            Decimal totalCaseDuration = 0;

            //SME Case Duration
            if (
                (eachCase.Out_of_External_SLA__c == true &&
                oldCaseRecords.get(eachCase.Id).Out_of_External_SLA__c == false &&
                eachCase.Out_of_Internal_SLA__c == true) ||
                (eachCase.Out_of_External_SLA__c == false &&
                eachCase.Out_of_Internal_SLA__c == true &&
                caseStatusMap.get(eachCase.Status) == true)
            ) {
                //System.debug('### in sme time');
                //With Pause time
                if (eachCase.SME_Time_in_Pause_Status__c > 0) {
                    totalCaseDuration = (minDiffCreatedDate - eachCase.SME_Time_in_Pause_Status__c) / 60;
                    //No Pause time
                } else {
                    totalCaseDuration = (minDiffCreatedDate) / 60;
                }

                smeHours = totalCaseDuration - eachCase.Consultant_Case_Duration__c;

                eachCase.SME_Case_Duration__c = smeHours;
            } else if (
                (eachCase.Out_of_External_SLA__c == false &&
                eachCase.Out_of_Internal_SLA__c == true &&
                oldCaseRecords.get(eachCase.Id).Out_of_Internal_SLA__c == false) ||
                (eachCase.Out_of_External_SLA__c == false &&
                eachCase.Out_of_Internal_SLA__c == false &&
                caseStatusMap.get(eachCase.Status) == true)
            ) {
                //Consultant Case Duration
                //With Pause time
                //System.debug('### in consultant time');
                if (eachCase.Consultant_Time_in_Pause_Status__c > 0) {
                    consultantHours = (minDiffCreatedDate - eachCase.Consultant_Time_in_Pause_Status__c) / 60;
                    //No Pause time
                } else {
                    consultantHours = (minDiffCreatedDate) / 60;
                }
                eachCase.Consultant_Case_Duration__c = consultantHours;
            } else if (eachCase.Out_of_External_SLA__c == true && eachCase.Out_of_Internal_SLA__c == true && caseStatusMap.get(eachCase.Status) == true) {
                //Manager case duration
                //With Pause time
                //System.debug('### in manager time');
                if (eachCase.Manager_Time_in_Pause_Status__c > 0) {
                    totalCaseDuration = (minDiffCreatedDate - eachCase.Manager_Time_in_Pause_Status__c) / 60;
                    //No Pause time
                } else {
                    totalCaseDuration = (minDiffCreatedDate) / 60;
                }

                managerHours = totalCaseDuration - eachCase.Consultant_Case_Duration__c - eachCase.Manager_Case_Duration__c;
                eachCase.Manager_Case_Duration__c = managerHours;
            }

            eachCase.Case_Age_In_Business_Hours__c = managerHours + smeHours + consultantHours;

            //Koketso - Calculate case duration and display in days, hours, munites
            Long numberOfSeconds = timeDiffCreatedDate / 1000;
            //System.debug(LoggingLevel.FINE, '**numberOfSeconds**' + numberOfSeconds);
            Long hours = numberOfSeconds / 3600;
            Long secondsRemainder = Math.mod(numberOfSeconds, 3600);
            Long minutes = secondsRemainder / 60;
            Long seconds = Math.mod(secondsRemainder, 60);

            Long days = hours / 24;
            Long remainingHours = Math.mod(hours, 24);
            //String caseTimeSpan = hours+'H :'+minutes+'m :'+seconds+'s';
            String caseTimeSpan = days + ' Days : ' + remainingHours + ' H : ' + minutes + ' m';

            eachCase.Case_Duration_In_Business_Hours__c = caseTimeSpan;
        }
    }
    /**
     * @description closeUnwantedCases description
     *
     * @param newCaseRecords (List<Case>): newCaseRecords
     * @param oldCaseRecords (Map<IdCase>): oldCaseRecords
     */
    public static void closeUnwantedCases(List<Case> newCaseRecords, Map<Id, Case> oldCaseRecords) {
        //Get unwanted Queue Id
        List<Group> queueIds = new List<Group>();

        //RN - CloudSmiths 2020-01-22 - Remove FFLIB query from the selector layer and do an inline query
        //to resolve the sites user from not access the group object due to strickter security mesures in the new SF release
        //
        //queueIds = new GroupsSelector().selectByNameAndType('Unwanted Emails - Business Admin', 'Queue');
        queueIds = [SELECT Id, Name, DeveloperName FROM Group WHERE Type = 'Queue' AND Name = 'Unwanted Emails - Business Admin'];

        for (Case eachCase : newCaseRecords) {
            if (eachCase.Unwanted_Type__c != null && eachCase.Status != 'Unwanted') {
                //Change owner to Queue
                if (queueIds.size() > 0) {
                    //System.debug('If 1178');
                    eachCase.OwnerId = queueIds[0].Id;
                } else {
                    eachCase.OwnerId = UserInfo.getUserId();
                }

                //Koketso: added to bypass validation rules when unwanted
                eachCase.Bypass_Validation_Rules__c = true;

                //Close the Case
                eachCase.Status = 'Unwanted';
            }
        }
    }
    /**
     * @description insertTransferCaseComment description
     *
     * @param newCaseRecords (List<Case>): newCaseRecords
     * @param oldCaseRecords (Map<IdCase>): oldCaseRecords
     */
    public static void insertTransferCaseComment(List<Case> newCaseRecords, Map<Id, Case> oldCaseRecords) {
        List<CaseComment> caseCommentsInsert = new List<CaseComment>();

        for (Case eachCase : newCaseRecords) {
            if (eachCase.OwnerId != oldCaseRecords.get(eachCase.Id).OwnerId && eachCase.Transfer_Reason__c != null) {
                CaseComment caseTransferComment = new CaseComment();
                caseTransferComment.ParentId = eachCase.Id;
                caseTransferComment.CommentBody =
                    'Transfer Reason: ' +
                    eachCase.Transfer_Reason__c +
                    '\n' +
                    'Transfer Comments: ' +
                    eachCase.Transfer_Comments__c;
                caseCommentsInsert.add(caseTransferComment);
            }
        }

        if (caseCommentsInsert.Size() > 0) {
            insert caseCommentsInsert;
        }
    }
    /**
     * @description reopenClosedCase description
     *
     * @param newCaseRecords (List<Case>): newCaseRecords
     */
    public static void reopenClosedCase(List<Case> newCaseRecords) {
        for (Case eachCase : newCaseRecords) {
            if (eachCase.Reopen_Case_Approval_Status__c == 'Approved' && eachCase.ClosedDate != null) {
                DateTime todaysDate = System.now();

                //Calculate Internal SLA
                if (eachCase.sd_Internal_SLA_Time_Measure__c != eachCase.sd_Internal_SLA_Units__c != null) {
                    Map<String, DateTime> internalSLA = calculateSLADateTime(
                        todaysDate,
                        eachCase.BusinessHoursId,
                        eachCase.sd_Internal_SLA_Time_Measure__c,
                        integer.valueof(eachCase.sd_Internal_SLA_Units__c)
                    );

                    eachCase.Internal_SLA_Warning_Date__c = internalSLA.get('slaWarningDate');
                    eachCase.Internal_SLA_End_Date__c = internalSLA.get('slaEndDate');
                }

                //Calculate External SLA
                if (eachCase.sd_External_SLA_Units__c != null && eachCase.sd_External_SLA_Time_Measure__c != null) {
                    Map<String, DateTime> externalSLA = calculateSLADateTime(
                        todaysDate,
                        eachCase.BusinessHoursId,
                        eachCase.sd_External_SLA_Time_Measure__c,
                        integer.valueof(eachCase.sd_External_SLA_Units__c)
                    );

                    eachCase.External_SLA_Warning_Date__c = externalSLA.get('slaWarningDate');
                    eachCase.External_SLA_End_Date__c = externalSLA.get('slaEndDate');
                }

                //Calculate Maximum Extension Date
                if (eachCase.sd_Max_SLA_Units__c != null && eachCase.sd_Max_SLA_Time_Measure__c != null) {
                    Map<String, DateTime> extensionSLA = calculateSLADateTime(
                        todaysDate,
                        eachCase.BusinessHoursId,
                        eachCase.sd_Max_SLA_Time_Measure__c,
                        integer.valueof(eachCase.sd_Max_SLA_Units__c)
                    );

                    eachCase.Max_SLA_Extension_Date__c = extensionSLA.get('slaEndDate');
                }

                //Update case status to in progress after new SLA Calculation based on pre closed date
                eachCase.Status = 'New';
            }
        }
    }

    //Method to calculate new SLA DateTime
    /**
     * @description calculateSLADateTime description
     *
     * @param dateTimeCalc (DateTime): dateTimeCalc
     * @param busHoursId (Id): busHoursId
     * @param timesMeasure (String): timesMeasure
     * @param units (Integer): units
     * @return Return Map<String,DateTime>: Return description
     */
    public static Map<String, DateTime> calculateSLADateTime(DateTime dateTimeCalc, Id busHoursId, String timesMeasure, Integer units) {
        Map<String, DateTime> slaDateTimeMap = new Map<String, DateTime>();

        String timeMeasure = timesMeasure;
        Integer timeUnits = units;
        Integer warningTime = 0;

        //hours in milliseconds
        if (timeMeasure.contains('Hour')) {
            timeUnits = timeUnits * 60 * 60 * 1000;
        } else if (timeMeasure.contains('Day')) {
            timeUnits = timeUnits * 8; //8 hour day
            timeUnits = timeUnits * 60 * 60 * 1000;
        } else if (timeMeasure.contains('Week')) {
            timeUnits = timeUnits * 40; //5 day week at 8 hours per day
            timeUnits = timeUnits * 60 * 60 * 1000;
        }

        //If SLA is 1 hour use 30min as warning else 60min
        if (timeUnits == (60 * 60 * 1000)) {
            warningTime = 30 * 60 * 1000; //30min
        } else if (timeUnits > (60 * 60 * 1000)) {
            warningTime = 60 * 60 * 1000; //60min
        }

        //This should be the Team Classifications SLA dates
        DateTime finalSLADate = BusinessHours.add(busHoursId, dateTimeCalc, timeUnits);
        DateTime warningSLADate = BusinessHours.add(busHoursId, finalSLADate, (warningTime * -1));

        slaDateTimeMap.put('slaEndDate', finalSLADate);
        slaDateTimeMap.put('slaWarningDate', warningSLADate);
        return slaDateTimeMap;
    }

    /**
     * @description createCommunicationPlanTasks description
     *
     * @param objs (List<SObject>): objs
     */
    public static void createCommunicationPlanTasks(List<SObject> objs) {
        CommunicationPlanFunctions.createCommunicationTasks(objs);
    }
    /**
     * @description evaluateCommunicationPlanTasks description
     *
     * @param newObjs (List<SObject>): newObjs
     * @param oldObjs (List<SObject>): oldObjs
     */
    public static void evaluateCommunicationPlanTasks(List<SObject> newObjs, List<SObject> oldObjs) {
        CommunicationPlanFunctions.evaluateCommunicationTasks(newObjs, oldObjs);
    }
    /*Get the remainder value for minutes,hours for pause SLA calculation.*/
    /**
     * @description getremainder description
     *
     * @param value (Long): value
     * @param divider (Long): divider
     * @return Return Long: Return description
     */
    public static Long getremainder(Long value, Long divider) {
        return Math.mod(value, divider);
    }

    /**
     * @description sendchatteronCaseCreation description
     *
     * @param newCaseRecords (Map<IdCase>): newCaseRecords
     */
    public static void sendchatteronCaseCreation(Map<Id, Case> newCaseRecords) {
        for (Case c : newCaseRecords.values()) {
            if (c.accountId != null) {
                //the cases who linked to account to get cif

                callCMSservice(c.id); //call future method
            }
        }
    }
    /**
     * @description callCMSservice description
     *
     * @param newCaseId (Id): newCaseId
     */
    @future(callout=true)
    public static void callCMSservice(Id newCaseId) {
        String cmsEmpNo = '';
        String cmsSiteCode = '';
        List<Sys_Log_Integration__c> logList = new List<Sys_Log_Integration__c>(); //created new list for adding all system logs from callouts in one list and inserting at once
        CMSGetBankerInfo_Resp_IB_v1 CMSGetBankerInfo_ResponseBean;

        list<Case> cslst = new CasesSelector().selectcasebyAccountId(new Set<Id>{ newCaseId });

        if (cslst != null && !cslst.isempty()) {
            if (cslst.get(0).Client_CIF_Number__c != null) {
                //Calling CMS service and updating the relationship banker name
                Map<CMSGetBankerInfo_Resp_IB_v1, List<Sys_Log_Integration__c>> CMSGetBankerInfo_ResponseMap = CMSGetBankerInfo_IH_v1.getBankerDeatils(
                    'SALESFORCE',
                    cslst.get(0).Client_CIF_Number__c
                );

                if (CMSGetBankerInfo_ResponseMap != null && CMSGetBankerInfo_ResponseMap.size() > 0) {
                    CMSGetBankerInfo_ResponseBean = (new List<CMSGetBankerInfo_Resp_IB_v1>(CMSGetBankerInfo_ResponseMap.keySet()))[0];

                    for (List<Sys_Log_Integration__c> currentLogList : CMSGetBankerInfo_ResponseMap.values()) {
                        logList.addAll(currentLogList);
                    }
                }

                if (CMSGetBankerInfo_ResponseBean.body != null) {
                    if (CMSGetBankerInfo_ResponseBean.body.GBlistCmsContOffPerClntV2Response != null) {
                        if (CMSGetBankerInfo_ResponseBean.body.GBlistCmsContOffPerClntV2Response.gsp019o != null) {
                            if (
                                CMSGetBankerInfo_ResponseBean.body.GBlistCmsContOffPerClntV2Response.gsp019o.contOffDet != null &&
                                !CMSGetBankerInfo_ResponseBean.body.GBlistCmsContOffPerClntV2Response.gsp019o.contOffDet.isempty()
                            ) {
                                for (
                                    CMSGetBankerInfo_Resp_IB_v1.ContOffDet contoff : CMSGetBankerInfo_ResponseBean.body.GBlistCmsContOffPerClntV2Response.gsp019o.contOffDet
                                ) {
                                    if (contoff.contOffType.equalsIgnoreCase('BB')) {
                                        //System.debug('cmsEmpNo' + cmsEmpNo);
                                        cmsEmpNo = contoff.coEmployeeNum;
                                        cmsSiteCode = contoff.overallControl;
                                        break;
                                    }
                                }
                            }
                        }
                    }
                }

                List<User> userlst = new UsersSelector().userwithEmployeeNumber(cmsEmpNo);

                if (userlst != null && !userlst.isempty()) {
                    //check case owner and that banker is different
                    if (Userlst.get(0).id != cslst.get(0).OwnerId && cslst.get(0).Responsible_Site__r.Site_Code__c == cmsSiteCode) {
                        string body =
                            '\n Subject: ' +
                            cslst.get(0).subject +
                            '\n Description: ' +
                            cslst.get(0).description +
                            '\n Responsible site: ' +
                            cslst.get(0).Responsible_Site__r.name +
                            '\n Status: ' +
                            cslst.get(0).Status;

                        ConnectApi.FeedItem fi = (ConnectApi.FeedItem) ConnectApiHelper.postFeedItemWithMentions(
                            Network.getNetworkId(),
                            cslst.get(0).Accountid,
                            'Case Notification {' +
                            userlst.get(0).id +
                            '}' +
                            body
                        );
                    }
                }
            }
        }
        if (logList.size() > 0) {
            insert logList;
        }
    }

    /**
     * @description sendchatteronCaseUpdate description
     *
     * @param newCaseRecords (Map<IdCase>): newCaseRecords
     * @param oldCaseRecords (Map<IdCase>): oldCaseRecords
     */
    public static void sendchatteronCaseUpdate(Map<Id, Case> newCaseRecords, Map<Id, Case> oldCaseRecords) {
        for (Case c : newCaseRecords.values()) {
            if (oldCaseRecords.get(c.id).accountID != null && c.AccountId != null) {
                if (c.Status != oldCaseRecords.get(c.id).status) {
                    callCMSservice(c.id);
                }
            }
        }
    }

    /**
     * @description blockSpamJunkEmails description
     *
     * @param newCaseRecords (List<Case>): newCaseRecords
     */
    public static void blockSpamJunkEmails(List<Case> newCaseRecords) {
        Set<String> serviceGroupIds = new Set<String>();
        Set<String> fromEmailAddressSet = new Set<String>();
        Set<String> inboxAliasSet = new Set<String>();

        Map<String, String> fromAndInboxAddressesMap = new Map<String, String>();
        Map<String, String> serviceGroupsMap = new Map<String, String>();
        Map<String, String> inboxAndServiceGroupMap = new Map<String, String>();
        Map<String, String> serviceGroupManagerMap = new Map<String, String>();

        for (Case eachCase : newCaseRecords) {
            if (eachCase.Status == 'Unwanted' && eachCase.Unwanted_Type__c == 'Spam / Junk' && eachCase.sd_Inbox_Name__c != null) {
                serviceGroupIds.add(eachCase.sd_Service_Group_Id__c);
                fromEmailAddressSet.add(eachCase.Email_From_Address__c);
                inboxAliasSet.add(eachCase.sd_Inbox_Name__c);
                fromAndInboxAddressesMap.put(eachCase.Email_From_Address__c, eachCase.sd_Inbox_Name__c);
                inboxAndServiceGroupMap.put(eachCase.Email_From_Address__c, eachCase.sd_Service_Group_Id__c);
            }
        }

        if (serviceGroupIds.size() > 0) {
            List<Service_Group__c> serviceGroupList = [SELECT Id, Manager__c FROM Service_Group__c WHERE Id IN :serviceGroupIds];
            for (Service_Group__c sg : serviceGroupList) {
                if (sg.Manager__c != null) {
                    serviceGroupManagerMap.put(sg.Id, sg.Manager__c);
                }
            }
        }

        if (fromEmailAddressSet.size() > 0) {
            EmailRuleEngine.autoBlockSpamJunkEmails(
                fromEmailAddressSet,
                inboxAliasSet,
                fromAndInboxAddressesMap,
                inboxAndServiceGroupMap,
                serviceGroupManagerMap
            );
        }
    }

    /**
     * @description callDocPredictionService description
     *
     * @param caseId (Id): caseId
     */
    public static void callDocPredictionService(Id caseId) {
        List<Case> currentCases = new CasesSelector().selectByIdWithSLAInfo(caseId, 1);
        Case caseReq = [SELECT Id, CaseNumber FROM Case WHERE Id = :caseId LIMIT 1];
        if (currentCases != null && currentCases.size() > 0) {
            Case currentCase = currentCases.get(0);
            if (currentCase.sd_Service_Group__c == 'AP Queries' || currentCase.sd_Service_Group__c == 'Staff Expense') {
                predictionServiceFutureCallout(
                    currentCase.Id,
                    caseReq.CaseNumber,
                    currentCase.Status,
                    currentCase.sd_Service_Type_Id__c,
                    currentCase.Email_From_Address__c,
                    currentCase.subject,
                    currentCase.description,
                    currentCase.sd_Service_Group__c
                );
            }
        }
    }

    // PJAIN: 20200627: Temporary bug fix.
    // Updated callDocPredictionService to be non future and have only the callout as future
    // This was causing issues with merchant stream testing as a case was being created in future context
    // and calling another future method is not supported.
    // Preferable solution is to use Queueable apex rather than future method.
    /**
     * @description predictionServiceFutureCallout description
     *
     * @param caseId (String): caseId
     * @param caseNo (String): caseNo
     * @param status (String): status
     * @param serviceTypeId (String): serviceTypeId
     * @param suppliedEmail (String): suppliedEmail
     * @param subject (String): subject
     * @param description (String): description
     * @param serviceGroup (String): serviceGroup
     */
    @future(callout=true)
    public static void predictionServiceFutureCallout(
        String caseId,
        String caseNo,
        String status,
        String serviceTypeId,
        String suppliedEmail,
        String subject,
        String description,
        String serviceGroup
    ) {
        Map<Prediction_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = Prediction_IH_v1.Prediction(
            caseId,
            caseNo,
            status,
            serviceTypeId,
            suppliedEmail,
            subject,
            description,
            serviceGroup
        );
        Prediction_Resp_IB_v1 responseBean = (new List<Prediction_Resp_IB_v1>(responseMap.keySet()))[0];
        if (responseBean != null) {
            if (responseBean.statusCode == 200) {
                if (responseBean.Data != null) {
                    if (responseBean.Data.caseId != '') {
                        try {
                            Case caseObj = new Case(Id = caseId);
                            caseObj.Confidence__c = String.valueOf(responseBean.Data.confidence);
                            caseObj.AccountId = responseBean.Data.accountId;
                            caseObj.Status = responseBean.Data.status;
                            caseObj.Service_Type_Search__c = responseBean.Data.serviceTypeId;
                            caseObj.Bypass_Validation_Rules__c = true;
                            update caseObj;
                        } catch (DmlException ex) {
                            throw ex;
                        }
                    }
                }
            }
        }
    }
    /**
     * @description validateActiveTaskOnCase description
     *
     * @param listOfCases (list<case>): listOfCases
     */
    public static void validateActiveTaskOnCase(list<case> listOfCases) {
        set<id> setOfCaseId = new Set<id>();
        set<string> tastStatus = new Set<string>{ 'Open' };
        set<id> setOfNoTaskcases = new Set<id>();

        Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Broker Note').getRecordTypeId();
        for (case caseObj : listOfCases) {
            if (caseObj.Status == 'Follow Up' && caseObj.RecordTypeId == caseRecordTypeId) {
                setOfCaseId.add(caseObj.id);
            }
        }
        list<case> listOfCaseRec = [
            SELECT Id, Status, Case_Record_Type_Name__c, (SELECT Id, Status FROM Tasks WHERE status IN :tastStatus)
            FROM case
            WHERE id IN :setOfCaseId
        ];
        for (case cObj : listOfCaseRec) {
            if (cobj.Tasks.isEmpty()) {
                setOfNoTaskcases.add(cobj.id);
            }
        }
        for (Case cobj : listOfCases) {
            if (setOfNoTaskcases.contains(cobj.Id)) {
                cobj.addError('Please create a Task before updating the status to Follow Up');
            }
        }
    }

    /**
     * @description CheckValidAdvisorCode description
     *
     * @param listOfCases (list<case>): listOfCases
     */
    public static void CheckValidAdvisorCode(list<case> listOfCases) {
        //System.debug('TriggerHandler : beforeInsert');
        Id CaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Broker Note').getRecordTypeId();
        map<string, case> AvisorCode = new Map<string, case>();
        for (case cs : listOfCases) {
            if (CaseRecordTypeId == cs.recordtypeid) {
                AvisorCode.put(cs.Adviser_Code__c, cs);
            }
        }
        Map<string, user> usrMap = new Map<string, user>();
        for (user usr : [SELECT id, Advisor_Code__c FROM user WHERE Advisor_Code__c IN :AvisorCode.keyset()]) {
            usrMap.put(usr.Advisor_Code__c, usr);
        }
        for (case cs1 : listOfCases) {
            if (AvisorCode.containsKey(cs1.Adviser_Code__c) && !usrMap.containsKey(cs1.Adviser_Code__c)) {
                cs1.addError('Please enter valid Advisor code');
            }
        }
    }
    
    /**
    * @description Code block added by Almas Aleem W-7233 send update to power curve once case is fulfilled for products
    * @author almas.aleem@absa.africa | 2021-07-13 
    * @param newCaseRecords 
    * @param oldCaseRecords 
    **/
    public static void sendUpdateToPCO(List<Case> newCaseRecords, Map<Id, Case> oldCaseRecords){
        
        
        List<Application_Product__c> appProdtobeUpdated = new  List<Application_Product__c>();
        List<Id> childprodIds = new List<Id>();
        
        List<Case> CaseRecordstoUpdate = new List<Case> ();
        newCaseRecords = new casesSelector().selectcasebyAccountId(oldCaseRecords.keySet());
        for(Case eachCase : newCaseRecords){
            if(eachCase.Product__c !=null){
                
                
                if(eachCase.Product__c.equalsIgnoreCase('Overdraft')){
                    childprodIds.add(eachCase.Application_Product_Id__c);
                }
            }    
        }
        List<Application_Product__c> childAppProdList = [SELECT Id, Application_Product_Parent__c,Final_Decision_Date_Time__c
                                                         FROM Application_Product__c
                                                         WHERE  Application_Product_Parent__c != null AND Id IN:childprodIds];
        
        
        for(Case eachCase : newCaseRecords){
            if(eachCase.Opportunity__c !=null ){
                
                //add feed for banker to get notified ,application require more info
                //Removing notification from trigger moved to when case is getting accepted at UI level
              /*  String body =' Application has been successfully fulfilled.';
                 String body = ',\n\n Please note, Case Number: '+eachCase.CaseNumber+' has been successfully fulfilled.\n Account Number: '+eachCase.Account_Number__c +' \n Customer Name:'+eachCase.Account.Name+'\n Opportunity Number'+eachCase.Opportunity__r.Opportunity_Number__c+' \n\n Kind regards \nRBB Credit Fulfilment';
               
               
                
                if(!Test.isRunningTest()){
                    ConnectApi.FeedItem fi = (ConnectApi.FeedItem) ConnectApiHelper.postFeedItemWithMentions(Network.getNetworkId(), eachCase.Opportunity__c ,'Hello {'+eachCase.Relationship_Banker__c+'}'+body+'');
                }*/ 
                //make a call to pco to send update case is updated if opportunity product is of credit onboarding 
                //check if opportunity product is related to credit on boarding then only go for pco call
                //in future time once scored and non scored get implemented add check for it
                if(eachCase.Product__c !='COVID-19 Bank Guarantee' && eachCase.Application_Product_Id__c !=null) {
                    
                    Application_Product__c  appProd;
                    if(eachCase.Product__c.equalsIgnoreCase('Overdraft')){
                        for(Application_Product__c childAppProd : childAppProdList){
                            if(childAppProd.Id == eachCase.Application_Product_Id__c){
                                appProd  = new Application_Product__c(Id = childAppProd.Application_Product_Parent__c); 
                            }
                        }
                        
                        
                        
                }if(eachCase.Product__c.equalsIgnoreCase('Credit Card')){ //
                    
                    appProd  = new Application_Product__c(Id = eachCase.Application_Product_Id__c);
                    
            }else if(eachCase.Product__c.equalsIgnoreCase('Bank Guarantee')){ //

                appProd = new Application_Product__c(Id = eachCase.Application_Product_Id__c);
                
                }
                    
                    appProd.Product_Status__c = 'FulFilled';
                    appProd.Final_Decision_Date_Time__c = system.now();
                    appProdtobeUpdated.add(appProd);
                    
                    CaseRecordstoUpdate.add(eachCase);
                    
                }                
            }
        }
        
        try{
            update appProdtobeUpdated;
        }catch(Exception e){
            //system.debug('dml---'+e.getMessage()+'estack trace---'+e.getStackTraceString());
            AuditTrailLog.logException(new DMLException(), 'New', 'Error', 'CaseTriggerFunctions', 'sendUpdateToPCO', e.getMessage());
        }
        
        for(case eachCase : CaseRecordstoUpdate){
             //making pco call at front end level
           // pcoCallout(eachCase.id,eachCase.Opportunity__c); 
            // check all the related open cases for Opportunity if all of them are closed
            // then mark the opportunity as complete.
            completeRelatedCreditOpportunty(eachCase.Opportunity__c);   
            
        }
        
    }
    /**
    * @description 
    * @author almas.aleem@absa.africa | 2021-07-13 
    * @param caseId 
    * @param OpportunityId 
    **/
     @future(callout = true)
    public static void pcoCallout(Id caseId,Id OpportunityId){
        
        PowerCurveStatusUpdate.pcoCallout(OpportunityId);
    } 

    
    /**
    * @description 
    * @author almas.aleem@absa.africa | 2021-07-13 
    * @param oppId 
    **/
    public static void completeRelatedCreditOpportunty(string oppId){
    //not using selector to avoid CRUD issues
    List<Case> notClosedCaseList = [SELECT Id,Opportunity__r.RecordType.Name, Status from Case where Opportunity__c =:oppId and Status != 'Closed' and RecordType.Name = 'Credit FulFillment'];
        //if notClosedCaseList is null that means there are no open cases for Opp
        if( notClosedCaseList == Null || notClosedCaseList.isEmpty()){
            try{
                Opportunity opp = new Opportunity(id = oppId);
                opp.StageName = 'Closed Won'; //temp testing
                update opp;
               }
            catch(Exception e){
            //system.debug('Error occured during Opp update'+e.getCause());
            AuditTrailLog.logException(new DMLException(), 'New', 'Error', 'CaseTriggerFunctions', 'completeRelatedCreditOpportunty', e.getMessage());
            }
        }
    }   
     /**
    * @description 
    * @author Anu Dhaka 2021-09-28
    * @param oldRecords  
    * @param listOfCases
    **/
    public static void validateCaseAccordingAIC(Map<Id, sObject> oldRecords, list<case> listOfCases){
        Id recordIDOfAIC = [Select id from recordtype Where DeveloperName ='AIC'].id;
        Id queueId =  [Select Id from Group where Type = 'Queue'  AND DeveloperName = 'Outbound_AIC'].Id;
        Id unAssignQueueId = [Select Id from Group where Type = 'Queue'  AND DeveloperName = 'Awaiting_Documents_AIC'].Id;
        Set<Id> accountIds = new set<Id>();
        Map<String,EmailTemplate> emailTeampleteMap = new Map<String,EmailTemplate> ();
        for(EmailTemplate em : [Select Id,Name,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where name IN ('US_Email: Outbound Outcome: Uncontactable Individuals','US_Email: Outbound Outcome: Uncontactable Complex Entities')] ){
            emailTeampleteMap.put(em.name ,em);
        }
        
        for(Case caseObj : listOfCases){
            Case oldCaseObj = (Case) oldRecords.get(caseObj.Id);
            if(caseObj.AccountId != null && caseObj.RecordTypeId == recordIDOfAIC && caseObj.DD_Case_Outcome__c == 'Uncontactable' && oldCaseObj.DD_Case_Outcome__c != caseObj.DD_Case_Outcome__c && caseObj.ownerid == queueId){
                accountIds.add(caseObj.AccountId);
            }
        }
        Map<Id,Account> accMap = new Map<Id,Account>([Select id, PersonEmail,IsPersonAccount, Active_Email__c From account where id IN: accountIds]);
        List<Messaging.SingleEmailMessage> messages = new List<Messaging.SingleEmailMessage>();
        for(Case caseObj : listOfCases){
            Case oldCase = (Case) oldRecords.get(caseObj.Id);
            if(caseObj.RecordTypeId == recordIDOfAIC && caseObj.DD_Case_Outcome__c == 'Uncontactable' && oldCase.DD_Case_Outcome__c != caseObj.DD_Case_Outcome__c && caseObj.ownerid == queueId ){
                // Send Email template;
                if(accMap.get(caseObj.AccountId) != null && ( accMap.get(caseObj.AccountId).PersonEmail != null || accMap.get(caseObj.AccountId).Active_Email__c != null)){
                    Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                   // message.setToAddresses(new String[] {accMap.get(caseObj.AccountId).PersonEmail!=null:}); 
                    message.setSenderDisplayName('Company Support'); 
                    message.setTargetObjectId(caseObj.ContactId);
                    message.setUseSignature(false); 
                    message.setBccSender(false); 
                    message.setSaveAsActivity(false);   
                    String emailTemplateName;
                    if(accMap.get(caseObj.AccountId).IsPersonAccount == true){
                        emailTemplateName = 'US_Email: Outbound Outcome: Uncontactable Individuals';
                        message.setToAddresses(new String[] {accMap.get(caseObj.AccountId).PersonEmail}); 
                    }else{
                        emailTemplateName = 'US_Email: Outbound Outcome: Uncontactable Complex Entities';
                        message.setToAddresses(new String[] {accMap.get(caseObj.AccountId).Active_Email__c}); 
                    }
                    EmailTemplate emailTemplate = emailTeampleteMap.get(emailTemplateName);
                    if(emailTemplate.id != null){
                        message.setTemplateID(emailTemplate.Id); 
                        message.setWhatId(caseObj.Id); 
                        messages.add(message);
                    }
                }
                caseObj.Status = 'Uncontactable';
               
                caseObj.OwnerId = unAssignQueueId;
            }
        }
        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
     /* if (results[0].success){
            System.debug('The email was sent successfully.');
        } else {
            System.debug('The email failed to send: '+  results[0].errors[0].message);
        }  
            */
    }
    /**
    * @description 
    * @param listOfCases
    **/
    public static void ControllerOfficerCaseAssignment(list<case> listOfCases){
        set<id> setOfCaseId=new set<id>();
        set<string> tastStatus=new set<string>{'Open'};
            set<id> setOfNoTaskcases=new set<id>();
        
        Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Service Request').getRecordTypeId();
        
        List<case> caseLst = new List<case>();
        for(case caseObj:listOfCases){
            if(caseObj.subject != null && caseObj.Product__c != null){
                if(caseObj.subject.contains('Request') && caseObj.RecordTypeId == caseRecordTypeId && caseObj.Product__c == 'Bank Codes' ){
                    caseLst.add(caseObj);
                }
            }
        }
        map<string,user> userMap = new Map<string,user>();
        if(Test.isRunningTest()){
            for(user userObj:[Select id, EmployeeNumber from user where EmployeeNumber != null AND IsActive = true LIMIT 10]){
                userMap.put(userObj.EmployeeNumber,userObj);
            } 
        }else{
            for(user userObj:[Select id, EmployeeNumber from user where EmployeeNumber != null AND IsActive = true LIMIT 49999]){
                userMap.put(userObj.EmployeeNumber,userObj);
            }
        }
        
        List<Group> groupLst = [select Id from Group where Name ='Bank Codes' and Type = 'Queue' Limit 1];
        
        List<case> updLst = new List<case>();
        for(Case caseObj:caseLst){
            string controllofficer='';
            if(caseObj.Extended_Request_Data__c != null){
                Object result = JSON.deserializeUntyped(caseObj.Extended_Request_Data__c);
                if(result != null){
                  List<Object> resultObjectData  = (List<Object>)result;
                    if(!resultObjectData.isEmpty() && resultObjectData  != null){
                        for (Object instance : resultObjectData){
                            Map<String, Object> resultMap = (Map<String, Object>)instance;
                            Object dataVal= resultMap.get('attributes');
                            for (Object instanceObj : (List<Object>)dataVal){
                                Map<String, Object> resultMapVal = (Map<String, Object>)instanceObj;
                                if(resultMapVal.ContainsKey('attrLabel')){
                                    if(resultMapVal.get('attrLabel')=='Control Officer Employee Number'){
                                        controllofficer = string.valueOf(resultMapVal.get('attrValue'));
                                    }
                                }
                            }
                        }
                    }
                }
                
                case cs = new case();
                if(userMap.containsKey(controllofficer)){
                    cs.id = caseObj.id;
                    cs.OwnerId =  userMap.get(controllofficer).Id;
                    cs.Decision_Data__c = 'True';
                } else{
                    cs.id = caseObj.id;
                    cs.OwnerId =groupLst[0].Id; 
                }
                updLst.add(cs);
            }
        }
        if(updLst.size()>0){
            upsert updLst;
        }
    }

    /**
     * @description updateApplicationOnCaseStatusRejected
     * @param triggerNew
     * @param oldMap
     */
    Public static void updateApplicationOnCaseStatusRejected( List<Case> triggerNew, Map<Id,Case> oldMap ){
        List<Application__c> applicationList = new List<Application__c>();
        Set<Id> OppId = new Set<Id>();
        for( Case eachCase : triggerNew ){
            if( eachCase.Status != oldMap.get( eachCase.Id ).Status && 
                eachCase.Status == 'Rejected-Awaiting Feedback' ){
                OppId.add( eachCase.Opportunity__c );
            }
        }
        For( Application__c eachApp : [SELECT id,Application_Generation_Date__c,Application_Status__c
                                         FROM Application__c
                                        WHERE Opportunity__c IN : OppId ] ){
            eachApp.Application_Generation_Date__c = null;
            eachApp.Application_Status__c = '';
            applicationList.add( eachApp );
        }
        if( !applicationList.isEmpty() ){ 
            Database.update( applicationList, false ); 
        }
    }
}