/**
 * Created by kylealexander on 2018/08/01.
 * Test Class Name: TaskTriggerFunctionsTest
 * CHANGE LOG:
 * ==============================================================================================================
 * 19-03-04 DH Replaced use of Record Type ID with isPersonAccount to cater all future record types
 * TODO identified in code review by DH 4/3/2019
 * 1. Add Number_of_Calls__c field to Lead as formula to sum successful and unsuccessful
 * 2. Add Successful_Calls__c and Unsuccessful_Calls__c to Opportunity
 * 3. Change Number_of_Calls__c on Opp to be formula
 * 4. Update the logic in this class and the trigger for Opporunity to work the same as Lead
 * 5. Rename TasksSelector().selectTasksByLeadIds() to TasksSelector().selectCallsByLeadIds and use the field Type='Call' in the logic
 * ===============================================================================================================
 */
/**
 * @description TaskTriggerFunctions
 *
 */
public without sharing class TaskTriggerFunctions {
    /**
     * @description exception
     */
    public class CustomException extends Exception {
    }

    public static boolean isRecurringTrigger = false;
    /**
     * @description beforeInsert description
     *
     * @param newTasksList (List<Task>): newTasksList
     */
    public static void beforeInsert(List<Task> newTasksList) {
        Map<Id, Task> opptyTaskMap = new Map<Id, Task>();
        Set<Id> directDeliveryLeadIdsSet = new Set<Id>();
        Map<Id, Task> directDeliveryLeadTaskMap = new Map<Id, Task>();
        Map<Id, Task> directDeliverySTILeadTaskMap = new Map<Id, Task>();
        Map<Id, Task> directDeliveryAIPLeadTaskMap = new Map<Id, Task>();
        set<Id> leadIds = new Set<Id>();
        String directDeliveryTaskRecType = RecordTypeIdController.getRecordTypeId('Direct_Delivery_Sales_Task', 'Task');
        String dDSTITaskRecType = RecordTypeIdController.getRecordTypeId('DD_STI_Task', 'Task');
        String AIPTaskRecType = RecordTypeIdController.getRecordTypeId('AIP_Task', 'Task');
        string whoIds = '';
        Map<Id, Lead> mapofLeads;
        //Start:Vinay P:get whoIds if those related to lead
        for (Task currentTask : newTasksList) {
            whoIds = currentTask.whoId;
            if (whoIds != null && whoIds.startsWith('00Q')) {
                leadIds.add(currentTask.whoId);
            }
            if (
                currentTask.RecordTypeId == AIPTaskRecType // Added for AIP Record Type
            )
                currentTask.TaskSubtype = 'Call';
        }
        if (!leadIds.isEmpty())
            mapofLeads = new Map<Id, Lead>([SELECT Manager__r.Email FROM Lead WHERE Id = :leadIds]);
        //End: get whoIds if those related to lead
        for (Task currentTask : newTasksList) {
            String whatId = currentTask.WhatId;
            String whoId = currentTask.WhoId;
            if (whatId != null && whatId.startsWith('006')) {
                opptyTaskMap.put(whatId, currentTask);
            }
            //Added Minal Rama 2020/10/15 BlueSky
            //Check if all mandatory fields have been completed before attempting to convert the lead
            //If not then throw an error
            if (whoId != null && whoId.startsWith('00Q')) {
                if (
                    directDeliveryTaskRecType != '' &&
                    (currentTask.RecordTypeId == directDeliveryTaskRecType ||
                    currentTask.RecordTypeId == DDSTITaskRecType) &&
                    currentTask.Outcome__c == 'Client Interested'
                ) {
                    //directDeliveryLeadIdsSet.add(currentTask.WhoId);
                    directDeliveryLeadTaskMap.put(currentTask.WhoId, currentTask);
                }
                if (DDSTITaskRecType != '' && currentTask.RecordTypeId == DDSTITaskRecType && currentTask.Outcome__c == 'Client Interested') {
                    //directDeliveryLeadIdsSet.add(currentTask.WhoId);
                    directDeliverySTILeadTaskMap.put(currentTask.WhoId, currentTask);
                }
                if (AIPTaskRecType != '' && currentTask.RecordTypeId == AIPTaskRecType) {
                    directDeliveryAIPLeadTaskMap.put(currentTask.WhoId, currentTask);
                }

                //Added By Vinay P: To get branch manager email id from lead to task
                /* if(currentTask.RecordTypeId==AHPTaskRecType){
                    currentTask.Status = 'Open';
                    currentTask.DD_Team_Leader_Email__c = mapofLeads.get(WhoId).Manager__r.Email;
                    }*/
            }
        }
        if (!directDeliveryLeadTaskMap.isEmpty()) {
            checkOutcome(directDeliveryLeadTaskMap);
        }
        if (!directDeliverySTILeadTaskMap.isEmpty()) {
            List<Task> tasksErrors = checkVerificationAndITC(directDeliverySTILeadTaskMap);
            for (Task currentTask : tasksErrors) {
                currentTask.addError('The lead cannot be converted because ITC checks and verification have not passed');
            }
        }
        if (!directDeliveryAIPLeadTaskMap.isEmpty()) {
            List<Task> tasksErrors = checkVerificationAndITC(directDeliveryAIPLeadTaskMap);
            for (Task currentTask : tasksErrors) {
                currentTask.addError('The Lead is already Closed. No more call outcome cannot be selected.');
            }
        }
        if (!opptyTaskMap.isEmpty()) {
            // Set Oppty Id and ContactId on Task if whatId is Opportunity and Account is Person Account
            Map<Id, Opportunity> opptyMap = new OpportunitiesSelector().selectOpportunitiesById(opptyTaskMap.keySet());
            for (Opportunity currentOppty : opptyMap.values()) {
                if (currentOppty.Account.IsPersonAccount == true) {
                    Task newTask = opptyTaskMap.get(currentOppty.Id);
                    newTask.Opportunity__c = currentOppty.Id;
                    newTask.Contact__c = currentOppty.Account.PersonContactId;
                }
            }
        }
    }

    /**
     * @description Method that prevent deletion of a task if it has comments
     *
     * @param task Task current task instance
     */
    public static void checkIfTaskHasComments(Task task) {
        //If the task has comments then don't allow deletion
        if (task.HasComments__c == true) {
            task.addError('This record cannot be deleted as it has important client information');
        }
    }

    /**
     * @description Method that checks if all required fields on the lead are done before conversion (If client is interested)
     * @author: Minal Rama
     * @createdDate 2020/10/15
     * @param leadTaskMap (Map<Id,Task>) List of lead IDs
     *
     */
    private static void checkOutcome(Map<Id, Task> leadTaskMap) {
        LeadsSelector selector = new LeadsSelector();
        List<Lead> allLeads = selector.selectById(leadTaskMap.keySet());
        //Id ddSalesLeadRecordTypeId =  Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('Direct_Delivery_Sales_Lead').getRecordTypeId();
        //Id ddSTILeadRecordTypeId =  Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('DD_STI_Lead').getRecordTypeId();
        //String directDeliveryRecTypeLead = RecordTypeIdController.getRecordTypeId('Direct_Delivery_Sales_Lead','Lead');
        List<Task> taskErrors = new List<Task>();
        List<Task> taskErrorsConversion = new List<Task>();
        Id currentLoggedInUser = UserInfo.getUserId();

        for (Lead l : allLeads) {
            if (l.DD_Mandatory_Fields_Completed__c == false) {
                taskErrors.add(leadTaskMap.get(l.Id));
            }
            if (l.OwnerId != currentLoggedInUser) {
                taskErrorsConversion.add(leadTaskMap.get(l.Id));
            }
        }

        if (!taskErrors.isEmpty()) {
            for (Task currentTask : taskErrors) {
                currentTask.addError('Please complete all mandatory fields, including the address, on the lead before attempting to convert.');
            }
        }

        if (!taskErrorsConversion.isEmpty()) {
            for (Task currentTask : taskErrorsConversion) {
                currentTask.addError('You cannot convert this lead. Only the lead owner is able to convert this lead');
            }
        }

        //return taskErrors;
    }

    /**
     * @description Method that checks if all required fields on the lead are done before conversion (If client is interested)
     * @author: Minal Rama
     * @createdDate 2020/10/15
     * @param leadTaskMap List of lead IDs
     * @return List of tasks
     */
    private static List<Task> checkVerificationAndITC(Map<Id, Task> leadTaskMap) {
        LeadsSelector selector = new LeadsSelector();
        List<Lead> allLeads = selector.selectById(leadTaskMap.keySet());
        String directDeliverySTIRecTypeLead = RecordTypeIdController.getRecordTypeId('DD_STI_Lead', 'Lead');
        String AIPLeadRecType = RecordTypeIdController.getRecordTypeId('AIP_Lead', 'Lead');
        List<Task> taskErrors = new List<Task>();
        Task currentTask = leadTaskMap.values();
        for (Lead l : allLeads) {
            if (l.RecordTypeId == directDeliverySTIRecTypeLead) {
                if (l.DD_Verification_Passed__c == false || l.DD_ITC_Passed__c == false) {
                    taskErrors.add(leadTaskMap.get(l.Id));
                }
            } else if(l.RecordTypeId == AIPLeadRecType){
                if ((l.Status == 'Closed' && l.SubStatus__c != 'Unable to reach Contact') ||( l.SubStatus__c == 'Unable to reach Contact' &&
                    (currentTask.Outcome__c != null && currentTask.Outcome__c != ''))) {
                    taskErrors.add(leadTaskMap.get(l.Id));
                }
            }
        }
        return taskErrors;
    }

    /**
     *@description Method: Method that updates call attempts on Lead based
     * @param leadIdsSet set of Lead record Id's
     * @author: Rakesh Byri(Absa)
     * @created date: 2019-03-04
     * */

    public static void updateCallAttemptsOnLead(Set<Id> leadIdsSet) {
        //get all the call tasks for the leads to recalculate the call counters each time
        List<Task> tasksList = new TasksSelector().selectTasksByWhoId(leadIdsSet);
        Map<Id, Lead> leadsToUpdateMap = (Map<Id, Lead>) getRecdsToUpdate(leadIdsSet, 'Lead');
        Boolean isaiptask = false; //added for AIP
        String taskId = '';
        for (Task ct : tasksList) {
            if (ct.Call_Successful__c == 'Yes') {
                leadsToUpdateMap.get(ct.WhoId).Successful_Calls__c += 1;
            } else if (ct.Call_Successful__c == 'No') {
                leadsToUpdateMap.get(ct.WhoId).Unsuccessful_Calls__c += 1;
            }
            if (
                (ct.Outcome__c == 'Unable to reach Contact' && ct.RecordType.Name == 'DD STI Task') ||
                ((ct.Outcome__c == 'Unable to reach Contact' || ct.Outcome__c == 'Customer Hung Up') && ct.RecordType.Name == 'AIP Task')
            ) {
                if (!isRecurringTrigger) {
                    //
                    if (leadsToUpdateMap.get(ct.WhoId).Unsuccessful_Calls__c >= 2) {
                        isRecurringTrigger = true;
                        leadsToUpdateMap.get(ct.WhoId).Unsuccessful_Calls__c += 1;
                        leadsToUpdateMap.get(ct.WhoId).Status = 'Closed';
                        leadsToUpdateMap.get(ct.WhoId).SubStatus__c = 'Unable to reach Contact';
                        /*Added for by Kalyani AIP*/
                        if (ct.RecordType.Name == 'AIP Task' && !system.isFuture()) {
                            isaiptask = true;
                            taskId = ct.Id;
                        }
                    } else {
                        leadsToUpdateMap.get(ct.WhoId).Unsuccessful_Calls__c += 1;
                        leadsToUpdateMap.get(ct.WhoId).Status = 'Working';
                        leadsToUpdateMap.get(ct.WhoId).SubStatus__c = 'Attempted contact once';
                    }
                }
            }
        }
        try {
            update leadsToUpdateMap.values();
            //System.debug('leadsToUpdateMap.values() >>>>>>>>> ' + leadsToUpdateMap.values());
            /*Added by Kalyani AIP*/
            if (isaiptask) {
                smsEmailRequest request = new smsEmailRequest();
                request.leadId = leadsToUpdateMap.get(tasksList[0].WhoId).Id;
                request.preferredCommunicationChannel = 'SMS and Email';
                request.quickText = 'AIP Client Communication';
                request.emailTemplateName = 'AIP Client Communication';
                request.taskId = taskId;
                request.strOutcome = tasksList[0].Outcome__c;
                //System.debug('request=='+request);
                invokeSmsEmailMethod(new List<smsEmailRequest>{ request });
            }
        } catch (DmlException e) {
            if (e.getMessage().contains('Please enter a value for Product Interest')) {
                throw new CustomException('Please enter a value for Product Interest on Lead before Logging a Call');
            }
        }
    }

    /**
     *@description updating the call attempts on case
     * @param caseIdsSet
     */
    public static void updateCallAttemptsOnCase(Set<Id> caseIdsSet) {
        //get all the call tasks for the leads to recalculate the call counters each time
        List<Task> tasksList = new TasksSelector().selectByWhatId(caseIdsSet);
        Set<Id> caseIds = new Set<Id>();
        List<Case> casesToUpdate = new List<Case>();

        Id ddSTICaseTask = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('DD_STI_Case_Task').getRecordTypeId();

        for (Task ct : tasksList) {
            if (ct.Outcome__c == 'Unable to reach contact' && ct.RecordTypeId == ddSTICaseTask) {
                //System.debug('Added to case Ids <<<');

                caseIds.add(ct.WhatId);
            }
        }
        List<Case> allCases = new List<Case>();
        if (!caseIds.isEmpty()) {
            allCases = [SELECT Id, Unsuccessful_Calls__c, Status, Account.PersonContactId, ContactMobile FROM Case WHERE Id IN :caseIds];
            List<Direct_Delivery_Service_Setting__mdt> serviceSettings = [
                SELECT id, Max_call_Attempts__c
                FROM Direct_Delivery_Service_Setting__mdt
                WHERE label = 'DD STI Case'
                LIMIT 1
            ];

            //System.debug('addding to update list');
            for (Case theCase : allCases) {
                if (theCase.Status != 'Closed') {
                    if (string.isNotBlank(theCase.ContactMobile)) {
                        dispatchSMS(
                            theCase.Account.PersonContactId,
                            theCase.Id,
                            theCase.ContactMobile,
                            '',
                            'DDSTICASE_Unable_to_reach',
                            StringConstants.EPP_ITOUCH_SMS_INTEGRATION_SERVICE,
                            true
                        );
                    }
                    theCase.Unsuccessful_Calls__c += 1;
                }
                if(serviceSettings.size() > 0){
                if (theCase.Unsuccessful_Calls__c == serviceSettings[0].Max_call_Attempts__c) {
                    theCase.Status = 'Closed';
                    theCase.Unsuccessful_Calls__c = serviceSettings[0].Max_call_Attempts__c;
                }
                }
                //System.debug('case ID ' + theCase.Id + ' has been added');
                casesToUpdate.add(theCase);
            }
        }
        try {
            if (!casesToUpdate.isEmpty()) {
                //System.debug('cases is not empty');
                update casesToUpdate;
            }
        } catch (DmlException e) {
            throw new CustomException(e.getMessage());
        }
    }

    /**
     * @description update call data on oppurtunity
     * @param opptyIdsSet opportunity id set
     */
    public static void updateCallAttemptsonOppty(Set<Id> opptyIdsSet) {
        List<AggregateResult> arList = new TasksSelector().selectCallsCountByWhatId(opptyIdsSet);
        Map<Id, Opportunity> opptysToUpdateMap = (Map<Id, Opportunity>) getRecdsToUpdate(opptyIdsSet, 'Opportunity');
        if (arList.size() > 0) {
            for (AggregateResult ar : arList) {
                opptysToUpdateMap.get((Id) ar.get('WhatId')).Number_of_Calls__c = (Integer) ar.get('totalCount');
                // opptysToUpdateMap.get((Id) ar.get('WhatId')).Sys_BypassValidation__c = true;
            }
        }
        //Anka - recursive fix - W-10665
        Map<Id, Opportunity> updOppMap = new Map<Id, Opportunity>();
        for (Opportunity opp : opptysToUpdateMap.values()) {
            if (opp.IsFutureExecute__c != false) {
                updOppMap.put(opp.Id, opp);
            }
        }
        update updOppMap.values();
    }

    /**
     * @description getRecdsToUpdate description
     *
     * @param recdIdsSet (Set<Id>): recdIdsSet
     * @param sObjectName (String): sObjectName
     * @return Return Map<Id,sObject>: Return description
     */
    private static Map<Id, sObject> getRecdsToUpdate(Set<Id> recdIdsSet, String sObjectName) {
        Schema.SObjectType targetSObjectType = Schema.getGlobalDescribe().get(sObjectName);
        Type t = Type.forName('Map<Id,' + targetSObjectType + '>');
        Map<Id, Sobject> recdsToUpdateMap = (Map<Id, Sobject>) t.newInstance();
        for (Id currentId : recdIdsSet) {
            sObject newSobject = targetSObjectType.newSobject(currentId);
            if (sObjectName == 'Lead') {
                newSobject.put('Successful_Calls__c', 0);
                newSobject.put('Unsuccessful_Calls__c', 0);
            } else if (sObjectName == 'Opportunity') {
                newSobject.put('Number_of_Calls__c', 0);
            }
            recdsToUpdateMap.put(currentId, newSobject);
        }
        return recdsToUpdateMap;
    }

    /**
     * @description update the records realted to call task
     * @param newTasksList  id set
     *
     */
    public static void updateCallTask(List<Task> newTasksList) {
        for (Task currentTask : newTasksList) {
            if (currentTask.GlobalRefId__c != null && currentTask.GlobalRefId__c != '') {
                String uCID = currentTask.GlobalRefId__c;
                UCID = convertUCID(UCID);
                currentTask.GlobalRefId__c = UCID;
                break;
            }
        }
    }

    /**
     * @description update the records realted to call task
     * @param uCID  string
     * @return a formated string
     */
    public static String convertUCID(String uCID) {
        if (UCID != '') {
            String[] arrayString = UCID.split('x');

            if (arrayString != null && arrayString.Size() > 1) {
                Integer ucidpart1 = HexToIntegerCoverter.hexToInteger(arrayString[1].substring(0, 4));
                Integer ucidpart2 = HexToIntegerCoverter.hexToInteger(arrayString[1].substring(4, 8));
                Integer ucidpart3 = HexToIntegerCoverter.hexToInteger(arrayString[1].substring(8, 16));

                //append the zeros before decimal Version
                string strUcidPart1 = String.valueOf(ucidpart1).leftPad(5, '0');
                string strUcidPart2 = String.valueOf(ucidpart2).leftPad(5, '0');
                string strUcidPart3 = String.valueOf(ucidpart3).leftPad(10, '0');

                UCID = strUcidPart1 + strUcidPart2 + strUcidPart3;
            }
        }
        return UCID;
    }

    /**
     * @description Used for Direct Delivery stream, SMS the client once verbal disclosures have been validated
     * @param whoId Lead or contact
     * @param whatId opportunity
     * @param phoneNumberOverride if phone number needs to be overridden
     * @param recipientNameOverride if the name needs to be overridden
     * @param quickTextName name of quick text that needs to be sent out
     * @param integrationService intergration service to be used
     * @param saveAsActivity save as an activity true or false
     */
    @Future(Callout=true)
    private static void dispatchSMS(
        Id whoId,
        Id whatId,
        String phoneNumberOverride,
        String recipientNameOverride,
        String quickTextName,
        String integrationService,
        boolean saveAsActivity
    ) {
        if (phoneNumberOverride == null)
            phoneNumberOverride = '';
        SMSHandler.sendSMS(whoId, whatId, phoneNumberOverride, recipientNameOverride, quickTextName, integrationService, saveAsActivity);
    }
    /**
     * @description Used for Direct Delivery stream, SMS the client once verbal disclosures have been validated
     * @param requests
     */

    @InvocableMethod(label='Send Lead SMS/Email' description='Which Sends SMs/Email when meets criteria')
    public static void invokeSmsEmailMethod(smsEmailRequest[] requests) {
        //System.debug('Send Lead SMS/Email => '+requests[0].leadId);
        if(requests[0].strOutcome != 'Maturity_Retention')
            createCaseRecord(requests[0].leadId, requests[0].strOutcome, requests[0].taskId); // add newly by pranav on 1-07-2021 for case creation for AIP Product
        for(smsEmailRequest SSR : requests){
            if (SSR.strOutcome != 'Load Forced Debit' || SSR.strOutcome == 'Maturity_Retention')
                sendSmsEmail(
                    SSR.leadId,
                    SSR.preferredCommunicationChannel,
                    SSR.responseEmailAddress,
                    SSR.phoneNumberOverride,
                    SSR.quickText,
                    SSR.emailTemplateName,
                    SSR.ownerEmail,
                    SSR.managerEmail
                );
        }
        if (
            requests[0].strOutcome == 'Unable to Reach Contact' ||
            requests[0].strOutcome == 'Wrong Number' ||
            requests[0].strOutcome == 'Customer Hung Up' ||
            requests[0].strOutcome == 'No Authentication'
        )
            generateDocument(requests[0].leadId);
    }

    /**
     * @description generateDocument Description
     *
     * @param recordId (Id): Write the parameter description
     */
    @Future(Callout=true)
    public static void generateDocument(Id recordId) {
        DocumentTemplateProcessor documentTemplateProcessor = new DocumentTemplateProcessor();
        DocumentTemplateProcessor.ContextBuilder contextBuilder = new DocumentTemplateProcessor.ContextBuilder();
        if (recordId.getSObjectType().getDescribe().getName() == 'Lead') {
            Lead ld = new LeadsSelector().selectLeadById(recordId);
            if (ld.RecordType.Name == 'AIP Lead') {
                Account accountRecord = new AccountsSelector().selectAllByIdFOrDocs(ld.FinServ__RelatedAccount__c);
                Document_Template__c documentTemplate = new DocumentTemplateSelector().selectTemplateByName('Confirmation of Short Term Vehicle Insurance');
                contextBuilder.add('Lead', ld);
                contextBuilder.add('LeadName', ld.Salutation + ' ' + ld.Name);
                contextBuilder.add('LeadCreatedDate', System.today());
                contextBuilder.add('LeadAddress', ld.street + '\n' + ld.city + '\n' + ld.state + '\n' + ld.postalcode);

                String req = contextBuilder.serialize(documentTemplate.XML__c);
                Map<String, String> params = GenerateDocument.setECMParam(accountRecord, documentTemplate);
                CC_GenerateContentResponse response = documentTemplateProcessor.generateDocument(contextBuilder, documentTemplate, params);
                Blob b;
                String contentStore;
                //System.debug('serialise response ' + response);
                if (!Test.isRunningTest()) {
                    ECM_LoginResult_IB_V1 login = DocumentManagementControler.ECMLogin();
                    ECM_GetResult_IB_V1 getResult = ECM_IH_V1.getDocument(login.token, response.contentStoreToken);
                    b = EncodingUtil.base64Decode(getResult.Content.data);
                    contentStore = response.contentStoreToken;
                } else {
                    b = EncodingUtil.base64Decode('Test');
                    contentStore = '87654332HHAAKSHDH';
                }
                Document__c doc = new Document__c();
                doc.Name = documentTemplate.Name.left(75) + '.pdf';
                doc.Type__c = documentTemplate.Document_Type__c;
                doc.Reference__c = contentStore;
                doc.Lead__c = ld.Id;
                doc.ECM_Type__c = documentTemplate.ECM_Item_Type__c;
                insert doc;
                ContentVersion v = new ContentVersion();
                v.versionData = b;
                v.title = 'Physical Letter' + ' ' + ld.Name;
                v.pathOnClient = 'Physical Letter.pdf';
                insert v;
                if (!Test.isRunningTest()) {
                    Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :v.Id].ContentDocumentId;
                    ContentWorkspace ws = [SELECT Id, RootContentFolderId FROM ContentWorkspace WHERE Name = 'AIP Physical Letters' LIMIT 1];
                    ContentDocumentLink conDocLink = new ContentDocumentLink();
                    conDocLink.LinkedEntityId = ws.Id;
                    conDocLink.ContentDocumentId = conDoc;
                    conDocLink.shareType = 'I';
                    conDocLink.Visibility = 'AllUsers';
                    insert conDocLink;
                }
            }
        }
    }

    /**
     * @param LeadId
     * @param strOutcome
     * @param taskId
     * @description Create a case for the Lead based on outcome for AIP Product and link to the lead
     **/
    public static void createCaseRecord(id LeadId, string strOutcome, String taskId) {
        Lead ld = new LeadsSelector().selectLeadById(LeadId);
        Group gr = [SELECT Id FROM Group WHERE Type = 'Queue' AND NAME = 'AIP Cases'];
        String taskOutcome = '';
        list<case> caseList = new List<case>();
        if (ld != null) {
            case c = new case();
            c.Title__c = String.IsNotBlank(ld.Title) ? ld.Title : ld.FinServ__RelatedAccount__r.Titles__pc;
            c.Initials__c = ld.DD_Initials__c;
            c.Last_Name__c = ld.LastName;
            c.First_Name__c = ld.FirstName;
            c.ID_Type__c = ld.ID_Type__c;
            c.Customer_ID__c = ld.ID_Number__c;
            c.RecordTypeId = Schema.SObjectType.case.getRecordTypeInfosByName().get('AIP Case').getRecordTypeId();
            c.Direct_Delivery_Campaign__c = ld.Direct_Delivery_Campaign__c;
            c.OwnerId = Id.valueOf(gr.Id);
            c.Case_Ownership__c = 'Route';
            c.Mobile__c = ld.MobilePhone;
            c.Bypass_Validation_Rules__c = true;
            //c.Client_Absa_Account_Number__c = String.valueOf(ld.DD_AVAF_Account_Number__c);
            c.Client_Absa_Account_Number__c = ld.DD_AVAF_Account_Number__c;
            c.sd_Response_Email_Address__c = 'aipservices@absa.co.za';
            if (taskId != null && taskId != '') {
                Task aipTask = [SELECT id, WhoId, WhatId, Outcome__c FROM Task WHERE ID = :taskId];
                if (aipTask != null)
                    c.Outcome__c = aipTask.Outcome__c;
                taskOutcome = aipTask.Outcome__c;
            }
            if (String.isNotBlank(strOutcome)) {
                c.Category__c = 'Proof of insurance';
                //System.debug('taskOutcome'+taskOutcome);
                if (taskOutcome == 'Load Forced Debit') {
                    c.DD_Case_Outcome__c = 'Forced Debit Required';
                    //c.Status = 'Closed';
                } else {
                    c.Status = 'Proof to be sent'; // added for AIP Services by Pravin W on 2021/07/16
                    c.DD_Case_Outcome__c = 'Proof of insurance awaited';
                }
            }
            c.Email__c = String.IsNotBlank(ld.Email) ? ld.Email : ld.Lead_Email__c;
            c.AccountId = ld.FinServ__RelatedAccount__c;
            if (ld.FinServ__RelatedAccount__c != null) {
                Account a = new Account();
                a = new AccountsSelector().selectAllById(ld.FinServ__RelatedAccount__c);
                if (a != null && a.IsPersonAccount == true)
                    c.ContactId = a.PersonContactId;
            }
            caseList.add(c);
            //System.debug('case '+c);
        }
        if (caseList.size() > 0) {
            Database.SaveResult[] srList = Database.insert(caseList);
            //there will be only one lead.
            for (Database.SaveResult sr : srList) {
                if (sr.isSuccess()) {
                    // Operation was successful, so get the ID of the record that was processed
                    //System.debug('Successfully inserted account. Account ID: ' + sr.getId());
                    ld.case__c = sr.getId();
                }
            }
            update ld;
        }
    }
    /**
     * @description sendSmsEmail description for DD
     * @param leadId
     * @param preferredCommunicationChannel
     * @param responseEmailAddress
     * @param phoneNumberOverride
     * @param quickText
     * @param emailTemplateName
     * @param ownerEmail
     * @param managerEmail
     */
    @AuraEnabled
    public static void sendSmsEmail(
        Id leadId,
        string preferredCommunicationChannel,
        String responseEmailAddress,
        String phoneNumberOverride,
        String quickText,
        string emailTemplateName,
        string ownerEmail,
        string managerEmail
    ) {
        if (preferredCommunicationChannel.equalsIgnoreCase('Email') || preferredCommunicationChannel.equalsIgnoreCase('SMS and Email')) {
            sendEmailCase(leadId, responseEmailAddress, emailTemplateName, ownerEmail, managerEmail);
        }
        if (preferredCommunicationChannel.equalsIgnoreCase('SMS') || preferredCommunicationChannel.equalsIgnoreCase('SMS and Email')) {
            // dispatchSMS(Id whoId, Id whatId, String phoneNumberOverride, String recipientNameOverride, String quickTextName, String integrationService, boolean saveAsActivity) {
            lead ld = [
                SELECT
                    id,
                    Title,
                    DD_Initials__c,
                    LastName,
                    FirstName,
                    ID_Type__c,
                    ID_Number__c,
                    MobilePhone,
                    Email,
                    Lead_Email__c,
                    DD_Vehicle_Description__c,
                    DD_Policy_Number__c,
                    Direct_Delivery_Campaign__c,
                    FinServ__RelatedAccount__c,
                    OwnerId
                FROM Lead
                WHERE ID = :LeadId
            ];
            dispatchSMS(leadId, ld.FinServ__RelatedAccount__c, phoneNumberOverride, '', quickText, StringConstants.EPP_ITOUCH_SMS_INTEGRATION_SERVICE, true);
        }
    }
    /**
     * @description sendEmailCase description for DD
     *
     * @param leadId
     * @param responseEmailAddress (String): responseEmailAddress
     * @param emailTemplateName (string): emailTemplateName
     * @param ownerEmail (string): ownerEmail
     * @param managerEmail (string): managerEmail
     */
    @Future(Callout=true)
    public static void sendEmailCase(Id leadId, String responseEmailAddress, string emailTemplateName, string ownerEmail, string managerEmail) {
        List<EmailMessage> emailMessages = new List<EmailMessage>();
        Set<String> emailTemplateNames = new Set<String>();
        Map<String, EmailTemplate> emailTemplates = new Map<String, EmailTemplate>();
        try {
            //Used for SOQL query.
            //String directEmailTemplate = 'RBB Contact Centre - Email With Attachments';
            if (emailTemplateNames != null) {
                emailTemplateNames.add(emailTemplateName);
            }
            //Not using FFLIB to bypass CRUD / FLS as email folder is hidden.
            List<EmailTemplate> templates = new List<EmailTemplate>([SELECT Id, DeveloperName, Name FROM EmailTemplate WHERE Name = :emailTemplateNames]);
            List<Lead> leads = new LeadsSelector().selectById(new Set<Id>{ leadId });

            for (EmailTemplate template : templates) {
                emailTemplates.put(template.Name, template);
            }
            String defaulttargetObjectId = null;
            //This should match.
            if (emailTemplateNames.size() != emailTemplates.size()) {
                throw new CustomException('Invalid email template(s) found. : ' + emailTemplates.size());
            }
            List<String> toAddressList = new List<String>();
            if (ownerEmail != '' && ownerEmail != null) {
                toAddressList.add(ownerEmail);
            }
            if (managerEmail != '' && managerEmail != null && managerEmail != 'Maturity_Retention') {
                toAddressList.add(managerEmail);
            }
            if (!String.isBlank(leads.get(0).Email) && ownerEmail == '') {
                //Email_From_Address__c
                toAddressList.add(leads.get(0).Email); //Email_From_Address__c
            }
            //Outbound email message.
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            if(managerEmail == 'Maturity_Retention'){
            string replyToMail = system.Label.ReplayToLeadMaturityRetention;
            message.setReplyTo(replyToMail);
            OrgWideEmailAddress owa = [SELECT Id FROM OrgWideEmailAddress WHERE DisplayName='SVC-Virtualadviser' LIMIT 1];
            message.setOrgWideEmailAddressId(owa.Id);
            }
            message.setTemplateId(emailTemplates.get(emailTemplateName).Id);
            //message.setWhatId(leads.get(0).Id); lead id can't be what id
            message.setTargetObjectId(leads.get(0).Id);
            //message.setToAddresses(new List<String> { cases.get(0).Email_From_Address__c }); Replaced  by the if statement below by - Simangaliso
            if (!toAddressList.isEmpty()) {
                message.setToAddresses(toAddressList);
            }
            message.setSaveAsActivity(true);
            message.setTreatTargetObjectAsRecipient(false);
            //Send email(s).
            Messaging.SendEmailResult[] sendResults = Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ message });
        } catch (Exception e) {
            throw new CustomException('AHP Task OutCome: ' + responseEmailAddress + ' ' + e.getMessage());
        }
    }
    /**
     * @description smsEmailRequest Description
     *
     */
    public class smsEmailRequest {
        @InvocableVariable(required=true)
        public String leadId;

        @InvocableVariable
        public String preferredCommunicationChannel;

        @InvocableVariable
        public String responseEmailAddress;

        @InvocableVariable
        public String phoneNumberOverride;

        @InvocableVariable
        public String quickText;

        @InvocableVariable
        public String emailTemplateName;

        @InvocableVariable
        public String ownerEmail = '';

        @InvocableVariable
        public String managerEmail = '';

        @InvocableVariable
        public String strOutcome = '';

        @InvocableVariable
        public String taskId = '';
    }
    /**
     * @description Used for VA stream,Restric user to delete activities
     * @param listoftask
     */

    public static void ristrictaskDeletaionForVA(list<Task> listoftask) {
        set<id> setofCaseId = new Set<id>();
        set<id> setofOppId = new Set<id>();
        String prefix;
        for (Task tObj : listoftask) {
         if(tObj.WhatId != null){
            setofCaseId.add(tObj.WhatId);

            //Investment Opporutnity
             prefix=String.valueOf(tObj.WhatId).substring(0, 3);
            if (prefix == '006') {
                setofOppId.add(tObj.WhatId);
            }
    }
        }
        Map<ID, Case> caseMap = new Map<ID, Case>(
            [SELECT id, recordtype.name FROM case WHERE id IN :setofCaseId AND (recordtype.name = 'VA Client Review' OR recordtype.name = 'VA Maturity')]
        );
        if (caseMap.size() > 0) {
            for (Task tObj : listoftask) {
                if (caseMap.containsKey(tObj.WhatId)) {
                    tObj.addError('You are restricted to delete Activities');
                }
            }
        }
        //Investment Opporutnity
        //Added By Divya
        if(setofOppId.size()>0)
        {
            Map<ID, Opportunity> OppMap = new Map<ID, Opportunity>([select id,recordtype.name from Opportunity where id in :setofOppId AND recordtype.name = 'Investment Opportunity']);
            if(OppMap.size()>0){
                for(Task tObj:listoftask){
                    if(OppMap.containsKey(tObj.WhatId)){
                        tObj.addError('You are restricted to delete Activities');
                    }
                }
            }
        }
    }
}