/**
 * @description EarlyRiskDetectionController
 * @author Kamil Rega
 * @created 2021-09-25
 */
public with sharing class EarlyRiskDetectionController {
    /**
* @description Transfers the Case to a new Service Group and create Reminder
* @param caseId
* @param dateFromCalendar
* @param caseOutcome
*/
    @AuraEnabled
    public static void pauseCaseAndCreateReminder(String caseId, DateTime dateFromCalendar, string caseOutcome) {
        CaseTransferActionExt.transferCase('Everyday Banking - Collections', 'Early Risk Detection Awaiting', caseId);
        createReminder(caseId, dateFromCalendar, caseOutcome);
    }
    /**
* @description Transfers the Case to a new Service Group
* @param caseId
*/
    @AuraEnabled
    public static void redirectCase(String caseId) {
        //serviceGroupName to change ->
        CaseTransferActionExt.transferCase('Early Risk detection - PFD Case Escalated to Fraud', 'Early Risk detection - PFD Case Escalated to Fraud', caseId);

        List<Group> groupList = new GroupsSelector().selectByNameAndType(Label.Possible_Fraud_Pre_legal_Internal, 'Queue');

        //Get Current Case
        List<Case> caseList = new CasesSelector().selectById(new Set<Id>{
                caseId
        });
        if (groupList.size() > 0 && caseList.size() == 1) {
            //Update Case Owner to the Rewards Call Centre Queue
            caseList[0].OwnerId = groupList[0].Id;

            update caseList;
        }

    }

    /**
* @description sendSms
* @param caseId
* @param phoneNumber
* @return String
*/
    @AuraEnabled
    public static String sendSms(String caseId, String phoneNumber) {
     return    NotifyBankerController.notifyClientBySMS(caseId, phoneNumber, Label.smsTextEarlyRiskDetection, Label.smsIntegrationService);
    }
    
    /**
* @description notifyClient
* @param caseId
* @param phoneNumber
*/
    @AuraEnabled
    public static void notifyClient(String caseId, String phoneNumber) {
       string smsResponse= NotifyBankerController.notifyClientBySMS(null, phoneNumber, Label.smsTextEarlyRiskDetection, Label.smsIntegrationService);
        //change staatus
        if(smsResponse.startsWith('Error:')){
           throw new AuraHandledException(smsResponse);
        }
        Task newTask = new Task(Description = 'Failed to contact the customer telephonically , an SMS was sent to the client @' + phoneNumber + ' on ' + System.now(),
                Priority = 'High',
                Status = 'Completed',
                Subject = 'Call Attempt',
                IsReminderSet = true,
                Type = 'Call',
                WhatId = caseId
        );
        insert newTask;
    }
    /**
* @description closecaseAndawaitingForResponse
* @param caseId
* @param selectedAccNumber
*/
    @AuraEnabled
    public static void pauseAndAwaitResponse(String caseId, String selectedAccNumber) {
       CaseTransferActionExt.transferCase('Everyday Banking - Collections', 'ERD- Runway And Highover Limit Awaiting Response', caseId);
       RecordType recType = [Select Id, Name From RecordType Where Name ='Service Request' And sObjectType =:'Case'];
       List<Case> caseList = new CasesSelector().selectByIdWithComplaintInfoTOM(caseId, 1);
        if (caseList !=null && !caseList.isEmpty()) {
            caseList[0].RecordTypeId = recType?.Id;
            caseList[0].Account_Number__c = selectedAccNumber;
        }
        update caseList;
    }
     /**
* @description Transfers the Case to a new Service Group and create Reminder
* @param caseId
* @param dateFromCalendar
* @param caseOutcome
* @param selectedAccNumber
*/
@AuraEnabled
public static void transferCaseAndCreateReminder(String caseId, DateTime dateFromCalendar, string caseOutcome,String selectedAccNumber) {
    pauseAndAwaitResponse(caseId,selectedAccNumber);
    createReminder(caseId, dateFromCalendar, caseOutcome);
}

    /**
* @description createReminder
* @param caseId
* @param dateFromCalendar
* @param caseOutcome
*/
    @AuraEnabled
    public static void createReminder(String caseId, DateTime dateFromCalendar, string caseOutcome) {
        List<Case> caseList = new CasesSelector().selectByIdWithCustomerInfo(new Set<String>{
                caseId
        });
        //change staatus
        Task newTask = new Task(Description = 'Call ' + caseList[0].ClientName__c + ' regarding Case number ' + caseList[0].CaseNumber,
                Priority = 'High',
                Status = 'Scheduled',
                Subject = 'Call',
                IsReminderSet = true,
                Type = 'Call',
                WhatId = caseId,
                ReminderDateTime = dateFromCalendar
        );
        insert newTask;
    }

    /**
* @description getECMDocuments
* @param caseId
* @param docType
* @param cifAccountNumber
* @return List<ContentVersion>
*/
    @AuraEnabled
    public static List<ContentVersion> getECMDocuments(String caseId, String docType, String cifAccountNumber) {
        List<ContentVersion> docs = new List<ContentVersion>();
        String token = login();

        List<ContentVersion> entries = new List<ContentVersion>();
        for (ContentVersion condocs : getContents(docType)) {
            if (condocs.title.contains(caseId + docType)) {
                entries.add(condocs);
            }
        }
        if (!entries.isEmpty()) {
            return entries;
        } else {
            List<Case> linkedCase = new CasesSelector().selectByIdWithSLAInfo(caseId, 1);
            Map<String, List<String>> docMap = new Map<String, List<String>>();
            String cifNumber = cifAccountNumber;
            ECM_QueryRequest request = new ECM_QueryRequest();
            request.QueryRequest = new ECM_QueryRequest.QueryRequest();
            request.QueryRequest.Token = token;
            request.QueryRequest.Query = '/' + docType + '[@CIFNr > \"' + cifNumber + '\"]';
            ECM_QueryResult res = new ECM_QueryResult();

            res = ECM_IH_V1.query(request);
            if (res == null) {
                throw new AuraHandledException('Query result is null for ' + docType);
            }

            if (res ?.QueryResult ?.Status == 'ERROR') {
                throw new AuraHandledException(res ?.QueryResult ?.Details);
            }
            DateTime creationDateFromResponse = DateTime.newInstance(1900, 6, 6, 3, 3, 3);
            DateTime latestCreationDate = DateTime.newInstance(1900, 6, 6, 3, 3, 3);
            String PIDForRequest = '';
            if (!Test.isRunningTest()) {
                for (ECM_QueryResult.Document doc : res.Documents.document) {
                    creationDateFromResponse = (DateTime) JSON.deserialize('"' + doc.CreationDate + '"', DateTime.class);
                    if (creationDateFromResponse > latestCreationDate) {
                        latestCreationDate = creationDateFromResponse;
                        PIDForRequest = doc.PID;
                    }

                }
            }
            ECM_GetResult_IB_V1 getResult = new ECM_GetResult_IB_V1();
            if (docType == 'Ent_Application') {
                List<Case> linkedCases = new CasesSelector().selectByIdWithComplaintInfoTOM(caseId, 1);
                getResult = ECM_IH_V1.getDocument(token, linkedCases[0].Account_Number__c);

            } else {
                getResult = ECM_IH_V1.getDocument(token, PIDForRequest);

            }
            if (getResult == null || getResult ?.Content == null || String.isBlank(getResult.Content.Data)) {
                throw new AuraHandledException('There is no ' + docType + ' document for account');
            } else {
                docs.addAll(insertContentFile(getResult.Content.Data, caseId, docType));
            }
            if (!docs.isEmpty()) {
                return docs;
            } else {
                throw new AuraHandledException('There is no ' + docType + ' document for account');
            }
        }
    }


    /**
        * @description login
        * @return String
        */
    private static String login() {

        Map<String, String> credentials = ECM_IH_V1.getCredentials();
        ECM_LoginResult_IB_V1 login = ECM_IH_V1.login(credentials.get('store'), credentials.get('username'), credentials.get('password'));

        return login.Token;
    }


    /**
       * @description insertContentFile
       * @param file
       * @param caseId
       * @param documentType
       * @return List<ContentVersion>
       */
    private static List<ContentVersion> insertContentFile(string file, string caseId, String documentType) {
        List<ContentVersion> entries;
        Id conDoc;
        ContentVersion contVerFile = new ContentVersion();
        contVerFile.VersionData = Blob.valueOf(file);
        contVerFile.VersionData = EncodingUtil.base64Decode(file);
        contVerFile.Title = caseId + documentType;
        contVerFile.PathOnClient = 'ECM.pdf';
        contVerFile.ContentLocation = 's';
        if (contentVersion.sObjectType.getDescribe().isCreateable()) {
            insert contVerFile;
        }
        if (ContentVersion.sObjectType.getDescribe().isAccessible()) {
            conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :contVerFile.Id].ContentDocumentId;
        }

        ContentDocumentLink cDe = new ContentDocumentLink();
        cDe.ContentDocumentId = conDoc;
        cDe.LinkedEntityId = caseId;
        cDe.ShareType = 'I';
        cDe.Visibility = 'AllUsers';
        if (ContentDocumentLink.sObjectType.getDescribe().isCreateable()) {
            insert cDe;
        }
        if (ContentVersion.sObjectType.getDescribe().isAccessible()) {
            entries = [SELECT Id, Title, FileType FROM ContentVersion WHERE ContentDocumentId = :cDe.ContentDocumentId ];
        }
        return entries;
    }

    /**
       * @description getContents
       * @param title
       * @return List<ContentVersion>
       */
    public static List<ContentVersion> getContents(string title) {
        List<ContentVersion> entries = new List<ContentVersion>();
        if (ContentVersion.SObjectType.getDescribe().isAccessible()) {
            entries = [SELECT Id, Title, FileType FROM ContentVersion WHERE Title = :title];
        } else {
            throw new AuraHandledException('ContentVersion is not Accessible');
        }
        return entries;
    }
}