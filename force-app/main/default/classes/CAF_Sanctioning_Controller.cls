/** 
    * @description get cafApplication
    * @author: Masechaba Maseli
    * @return Sanctions
    
    */
public class CAF_Sanctioning_Controller {
    /** 
    * @description get cafApplication
    * @author: Masechaba Maseli
    * @return Sanctions
    * @param oppId
    * @param approvalName
    
    */
    @AuraEnabled
    public static List<approvalwrapper> getApprovalRequests(String oppId, String approvalName) {
        List<Id> processInstanceIds = new List<Id>();
        List<approvalwrapper> approvalList = new List<approvalwrapper>();
        String sanctionerRegion;
        Id approvalProcessId = [SELECT Id, Name, DeveloperName FROM ProcessDefinition WHERE DeveloperName = :'CAF_Sanctioning_Approval_Process'].Id;

        for (Opportunity a : [SELECT Id, Sanctioner_work_queue_regions__c, (SELECT ID, ProcessDefinitionId FROM ProcessInstances WHERE ProcessDefinitionId = :approvalProcessId ORDER BY CreatedDate DESC) FROM Opportunity WHERE ID = :oppId]) {
            sanctionerRegion = a.Sanctioner_work_queue_regions__c;

            for (ProcessInstance pi : a.ProcessInstances) {
                processInstanceIds.add(pi.Id);
            }
        }

        for (ProcessInstance pi : [SELECT TargetObjectId, LastActorId, LastActor.Name, CompletedDate, CreatedDate, (SELECT Id, ActorId, Actor.Name, OriginalActor.Name, Comments, ProcessInstanceId, StepStatus, ElapsedTimeInDays, ElapsedTimeInMinutes FROM StepsAndWorkitems WHERE StepStatus != '' ORDER BY ID DESC), (SELECT Id, StepStatus, Comments FROM Steps ORDER BY CreatedDate DESC LIMIT 1) FROM ProcessInstance WHERE Id IN :processInstanceIds ORDER BY CreatedDate DESC]) {
            String formatted = pi.CompletedDate != null ? formatDateTime(pi.CompletedDate) : null;
            String formatted2;

            if (pi.StepsAndWorkitems.size() > 0) {
                for (ProcessInstanceHistory pih : pi.StepsAndWorkitems) {
                    Integer numberMinutes = pih.ElapsedTimeInMinutes != null ? Integer.valueof(pih.ElapsedTimeInMinutes) : 0;
                    Datetime testDateCreated = pih.ElapsedTimeInMinutes != null ? pi.CreatedDate.addMinutes(numberMinutes) : null;
                    formatted2 = pi.CreatedDate != null ? formatDateTime(pi.CreatedDate) : null;

                    String stepStatusForm;
                    if (pih.StepStatus == 'Started') {
                        stepStatusForm = 'Submitted';
                    } else if (pih.StepStatus == 'Rejected' && pih.Comments.StartsWith('Decline')) {
                        stepStatusForm = 'Declined';
                    } else {
                        stepStatusForm = pih.StepStatus;
                    }
                    List<String> letsSeeComm = new List<String>();

                    if (pih.Comments != null) {
                        letsSeeComm = pih.Comments.split(':');
                    }
                    approvalwrapper approval = new approvalwrapper();
                    approval.applicationNumber = '';
                    approval.decision = stepStatusForm;
                    approval.comments = letsSeeComm.size() > 1 ? letsSeeComm[1] : pih.Comments;
                    approval.approver = pih.Actor.Name;
                    approval.region = sanctionerRegion;
                    approval.approvalDate = pih.StepStatus == 'Approved' || pih.StepStatus == 'Rejected' ? formatted : formatted2;
                    approvalList.add(approval);
                }
            }
        }

        return approvalList;
    }

    /** 
    * @description get cafApplication
    * @author: Masechaba Maseli
    
    */
    public class approvalwrapper {
         /** 
    * @description get cafApplication
    * @author: Masechaba Maseli
    
    */
        @AuraEnabled public String applicationNumber { get; set; }
         /** 
    * @description get cafApplication
    * @author: Masechaba Maseli
    
    */
        @AuraEnabled public String decision { get; set; }
       /** 
    * @description get cafApplication
    * @author: Masechaba Maseli
    
    */
        @AuraEnabled public String comments { get; set; }
       /** 
    * @description get cafApplication
    * @author: Masechaba Maseli
    
    */
        @AuraEnabled public String approver { get; set; }
       /** 
    * @description get cafApplication
    * @author: Masechaba Maseli
    
    */
        @AuraEnabled public String region { get; set; }
       /** 
    * @description get cafApplication
    * @author: Masechaba Maseli
    
    */
        @AuraEnabled public String approvalDate { get; set; }
    }

    /** 
    * @description get cafApplication
    * @author: Masechaba Maseli
    * @param oppId
    * @param approvalName
    * @param comments
    * @param status
    * @param reasons
    * @param approverId
    
    */
    @AuraEnabled
    public static void processRequest(String oppId, String approvalName, String comments, String status, String reasons, String approverId) {
        List<Id> processInstanceIds = new List<Id>();

        Id approvalProcessId = [SELECT Id, Name, DeveloperName FROM ProcessDefinition WHERE DeveloperName = :'CAF_Sanctioning_Approval_Process'].Id;
        Id currentUserId = UserInfo.getUserId();

        for (Opportunity a : [SELECT Id, (SELECT ID, ProcessDefinitionId FROM ProcessInstances WHERE ProcessDefinitionId = :approvalProcessId ORDER BY CreatedDate DESC) FROM Opportunity WHERE ID = :oppId]) {
            for (ProcessInstance pi : a.ProcessInstances) {
                processInstanceIds.add(pi.Id);
            }
        }
        list<Approval.ProcessWorkitemRequest> approvalList = new List<Approval.ProcessWorkitemRequest>();
        ProcessInstanceWorkItem piWI = [SELECT Id, ActorId, ProcessInstanceId FROM ProcessInstanceWorkItem WHERE ProcessInstanceId IN :processInstanceIds];
        for (ProcessInstance pi : [SELECT TargetObjectId, LastActorId, LastActor.Name, CompletedDate, CreatedDate, (SELECT Id, ActorId, Actor.Name, OriginalActor.Name, Comments, ProcessInstanceId, StepStatus, ElapsedTimeInDays, ElapsedTimeInMinutes FROM StepsAndWorkitems WHERE StepStatus = :'Pending' ORDER BY ID DESC), (SELECT Id, StepStatus, Comments FROM Steps ORDER BY CreatedDate DESC LIMIT 1) FROM ProcessInstance WHERE Id IN :processInstanceIds ORDER BY CreatedDate DESC]) {
            if (approverId != null && approverId != '') {
                
                piWI.ActorId = approverId;
            } else {
                if (pi.StepsAndWorkitems.size() > 0) {
                    for (ProcessInstanceHistory pih : pi.StepsAndWorkitems) {
                        String actualStatus = status == 'Decline' ? 'Reject' : status;
                        Approval.ProcessWorkitemRequest req2 = new Approval.ProcessWorkitemRequest();
                        req2.setComments(status + '' + ':' + '' + comments);
                        req2.setAction(actualStatus);
                        // req2.ActorId(approverId);
                        req2.setWorkitemId(pih.Id);
                        approvalList.add(req2);
                        //Approval.ProcessResult result2 = Approval.process(req2);
                    }
                }
            }
        }
        if(piWI != null){
            update piWI;
        }
        if(approvalList != null){
            List<Approval.ProcessResult> result2 = Approval.process(approvalList);
        }



    }

    /** 
    * @description get cafApplication
    * @author: Masechaba Maseli
    * @param caseId
    * @param processName
    * @param caseStatus
    * @param infoSource
   
    
    */
    @AuraEnabled
    public static void changeOwner(String caseId, String processName, String caseStatus, String infoSource){
        Id queueId;
        Set<Id> caseIdSet = new Set<Id>();
        caseIdSet.add(caseId);
        List<Case> currentCase = new CasesSelector().selectcasebyAccountId(caseIdSet);

        List <Decision_History__c> allDecisionHistoryList = new DecisionHistoriesSelector().selectByCaseDecision(caseId,'Approved');
        Map<String,String> infoSourceStatusMap = new Map<String,String>();
        infoSourceStatusMap.put('Security Validator','Validate Securities');
        infoSourceStatusMap.put('Payout Validator','Validate Payout');
        infoSourceStatusMap.put('Payout Release','Release Payout');
        infoSourceStatusMap.put('Sales Support Consultant','Submit for Fulfilment');

        Map<String,Id> processApproverMap = new Map<String,Id>();
        for(Decision_History__c approver: allDecisionHistoryList){
         If((approver.Process_Name__c == 'Sales Support Consultant' && approver.Details__c == 'Validate Securities')
            || approver.Process_Name__c != 'Sales Support Consultant')
        processApproverMap.put(approver.Process_Name__c, approver.Sanctioner__c);}

        if(processName != '' && (infoSource == '' || infoSource == null)){
            queueId = new GroupsSelector().selectByNameAndType(processName, 'Queue')[0].Id;
            currentCase[0].Status = caseStatus;
        }else if(processName != '' && (infoSource != '' || infoSource != null)){
         queueId =  processApproverMap.get(infoSource);
         currentCase[0].Status = infoSourceStatusMap.get(infoSource);
        }else{
            queueId =  currentCase[0].CreatedById ;
             currentCase[0].Status = caseStatus;}

        currentCase[0].OwnerId =  queueId;
        currentCase[0].Information_Source__c =  '';
        update currentCase;

    }
     /** 
    * @description get cafApplication
    * @author: Masechaba Maseli
    * @param dateToConvert
    * @return Date
   
    */
    @AuraEnabled
    public static string formatDateTime(Datetime dateToConvert) {
        Datetime now = dateToConvert;
        Integer offset = UserInfo.getTimezone().getOffset(now);
        Datetime local = now.addSeconds(offset / 1000);
        String formatted = local.formatGMT('yyyy-MM-dd  HH:mm');
        return formatted;
    }

     /** 
    * @description get cafApplication
    * @author: Masechaba Maseli
    * @param applicationId
    * @param bcmsCaseId
   
    */
    @AuraEnabled
    public static void createCase(String applicationId, String bcmsCaseId) {
        //create case
        Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('CAF Application').getRecordTypeId();
        OpportunityLineItem oppProduct = new OpportunityLineItemsSelector().byApplicationProductCAF(applicationId);
        Service_Group__c serviceGroup = [SELECT Id, Name, Queue__c FROM Service_Group__c WHERE Name = :'CAF Onboarding'];
        Id queueId = new GroupsSelector().selectByNameAndType(serviceGroup.Queue__c, 'Queue')[0].Id;
        Application_Product_CAF__c aPC = new ApplicationProductCAFSelector().selectByAppProdCAFId(applicationId);
        List<Document__c> documentList = new DocumentsSelector().getDocsRelatedToOpp(oppProduct.OpportunityId);
        List<Document__c> updateDocumentList = new List<Document__c>();
        Id caseId = aPC.Case__c;
        Map<String, List<Document__c>> documentMapByReference;

        Case fulfilmentcase = new Case();
        fulfilmentcase.RecordTypeId = caseRecordTypeId;
        fulfilmentcase.Status = 'Review Context';
        fulfilmentCase.Opportunity__c = oppProduct.OpportunityId;
        fulfilmentCase.Product__c = 'CAF';
        fulfilmentCase.Subject = 'CAF Case';
        fulfilmentcase.Relationship_Banker__c = oppProduct.Opportunity.OwnerId;
        fulfilmentcase.AccountId = oppProduct.Opportunity.AccountId;
        fulfilmentCase.Type = 'CAF Fulfilment';
        fulfilmentCase.Id = caseId;
        fulfilmentCase.sd_Service_Group__c = serviceGroup.Name;
        fulfilmentCase.sd_Service_Group_Id__c = serviceGroup.id;
        fulfilmentCase.OwnerId = queueId;
        fulfilmentCase.Application_Product_Id__c = applicationId;
        fulfilmentCase.External_Reference_Type__c = 'BCMS';
        fulfilmentCase.External_Reference_Number__c = bcmsCaseId;
        fulfilmentCase.Application_Number__c = aPC.Name;
        fulfilmentCase.CAF_Application_Number__c = aPC.Name;
        //fulfilmentCase.ownerId = serviceGroup.Id;
        //add service group and service type
        Set<Id> idSet = new Set<Id>();
        idSet.add(serviceGroup.Id);
        List<Service_Group_Type__c> serviceGroupTypes = new ServiceGroupTypesSelector().selectByServiceGroupWithServiceLevelInfo(idSet);

        if (!serviceGroupTypes.isEmpty()) {
            fulfilmentCase.sd_Original_Service_Group__c = serviceGroupTypes[0].Service_Group__r.Name;
            fulfilmentCase.sd_Service_Level_Id__c = serviceGroupTypes[0].Service_Level__c;
            fulfilmentCase.sd_Communication_Plan_Id__c = serviceGroupTypes[0].sd_Communication_Plan__c;
            fulfilmentCase.sd_Service_Group_Type_Id__c = serviceGroupTypes[0].id;
            fulfilmentCase.BusinessHoursId = serviceGroupTypes[0].Service_Group__r.Business_Hours__c;
            fulfilmentCase.sd_Response_Email_Address__c = serviceGroupTypes[0].Service_Group__r.Response_Email_Address__c;
            fulfilmentCase.sd_Email_Template_Case_Creation__c = serviceGroupTypes[0].Service_Group__r.Email_Template_Case_Creation__c;
            fulfilmentCase.Internal_SLA_Notification_User__c = serviceGroupTypes[0].Service_Group__r.Internal_SLA_Notification_User__c;
            fulfilmentCase.External_SLA_Notification_User__c = serviceGroupTypes[0].Service_Level__r.External_SLA_Notification_User__c;
        }

        upsert fulfilmentcase;

        if (String.isBlank(caseId)) {
            aPC.Case__c = fulfilmentcase.Id;
            update aPC;
        } else {
            List<Document__c> documentListByCase = new DocumentsSelector().selectDocumentsByOppId(caseId);
            documentMapByReference = Sys_Utilities_General.convertListToMapWithStringKey(documentListByCase, 'Reference__c');
        }

        if (!documentList.isEmpty()) {
            for (Document__c document : documentList) {
                if (document.Application_Product_CAF__c == applicationId) {
                    document.Case__c = fulfilmentcase.Id;
                    updateDocumentList.add(document);
                } else if (document.Application_Product_CAF__c == null) {
                    if (documentMapByReference == null || !documentMapByReference.containsKey(document.Reference__c)) {
                        Document__c cloneDocument = new Document__c();
                        cloneDocument.Name = document.Name;
                        cloneDocument.Case__c = fulfilmentcase.Id;
                        cloneDocument.Content_Size__c = document.Content_Size__c;
                        cloneDocument.Extension__c = document.Extension__c;
                        cloneDocument.Reference__c = document.Reference__c;
                        cloneDocument.Type__c = document.Type__c;
                        cloneDocument.Document_Status__c = document.Document_Status__c;
                        cloneDocument.ECM_Type__c = document.ECM_Type__c;
                        cloneDocument.Required__c = document.Required__c;
                        cloneDocument.Source_System__c = document.Source_System__c;
                        cloneDocument.File_Id__c = document.File_Id__c;
                        updateDocumentList.add(cloneDocument);
                    }
                }
            }
        }

        upsert updateDocumentList;
    }

    /** 
    * @description get cafApplication
    * @author: Masechaba Maseli
    * @param caseId
    * @param decision
    * @param details
    * @param comments
    * @param processName
    * @param isInsert
    * @param infoSource
    * @return bcmsCaseId
   
    */
    @AuraEnabled
    public static List<decisionHistoryWrapper> createDecisionHistory(String caseId, String decision, String details, String comments, String processName, Boolean isInsert, String infoSource) {
        List<decisionHistoryWrapper> historyWrapper = new List<decisionHistoryWrapper>();

        if (isInsert == true) {
            Decision_History__c decisionHistory = new Decision_History__c();
            decisionHistory.Decision__c = decision;
            decisionHistory.Details__c = details;
            decisionHistory.Comments__c = comments;
            decisionHistory.Case__c = caseId;
            decisionHistory.Process_Name__c = processName;
            decisionHistory.Approver__c = UserInfo.getUserId();
            decisionHistory.Sanctioner__c = UserInfo.getUserId();
            decisionHistory.Approver_Submitter__c = UserInfo.getName();
            decisionHistory.Information_Source__c = infoSource;
            decisionHistory.Changes__c = '';
            decisionHistory.Status__c = decision == 'Approved' ? 'Approved' : 'Rejected';
            insert decisionHistory;
        }

        List<Decision_History__c> decisionHistoryList = new DecisionHistoriesSelector().selectByCaseProcessName(caseId, processName);

        for (Decision_History__c historyLoop : decisionHistoryList) {
            decisionHistoryWrapper history = new decisionHistoryWrapper();
            history.outcome = String.valueOf(decisionHistoryList.size());
            history.processType = processName;
            history.decision = historyLoop.Decision__c;
            history.details = historyLoop.Details__c;
            history.comments = historyLoop.Comments__c;
            history.sanctioner = historyLoop.Approver_Submitter__c;
            history.changes = '1';
            history.decisionDate = historyLoop.CreatedDate != null ? formatDateTime(historyLoop.CreatedDate) : null;
            historyWrapper.add(history);
        }
        return historyWrapper;
    }
    /** 
    * @description get cafApplication
    * @author: Masechaba Maseli
    
    */

    public class decisionHistoryWrapper {
        /** 
    * @description get cafApplication
    * @author: Masechaba Maseli
    
    */
        @AuraEnabled public string outcome { get; set; }
      /** 
    * @description get cafApplication
    * @author: Masechaba Maseli
    
    */
        @AuraEnabled public string processType { get; set; }
      /** 
    * @description get cafApplication
    * @author: Masechaba Maseli
    
    */
        @AuraEnabled public String decision { get; set; }
      /** 
    * @description get cafApplication
    * @author: Masechaba Maseli
    
    */
        @AuraEnabled public String details { get; set; }
      /** 
    * @description get cafApplication
    * @author: Masechaba Maseli
    
    */
        @AuraEnabled public String comments { get; set; }
      /** 
    * @description get cafApplication
    * @author: Masechaba Maseli
    
    */
        @AuraEnabled public String sanctioner { get; set; }
      /** 
    * @description get cafApplication
    * @author: Masechaba Maseli
    
    */
        @AuraEnabled public string changes { get; set; }
      /** 
    * @description get cafApplication
    * @author: Masechaba Maseli
    
    */
        @AuraEnabled public String decisionDate { get; set; }
    }

    /** 
    * @description get cafApplication
    * @param caseId
    * @return
    
    */
    @AuraEnabled
    public static Case getCaseDetails(Id caseId) {
        try {
            Case currentCase = new CasesSelector().selectSecuritiesValidation(caseId);
            return currentCase;
        } catch (QueryException e) {
            // "Convert" the exception into an AuraHandledException
            throw new AuraHandledException('Something went wrong: ' + e.getMessage());
        }
    }

    /** 
    * @description get cafApplication
    * @param applicationId
    * @param Status
    * @param Queue
    
    */
    @AuraEnabled
    public static void updateCaseStatus(String applicationId, String Status, String Queue) {
        Application_Product_CAF__c aPC = new ApplicationProductCAFSelector().selectByAppProdCAFId(applicationId);
        Id queueId;
        if (Queue != '') {
            queueId = new GroupsSelector().selectByNameAndType(Queue, 'Queue')[0].Id;
        } else {
            queueId = aPC.Case__r.OwnerId;
        }
        Case fulfilmentcase = new Case();
        fulfilmentcase.Status = Status;
        fulfilmentCase.Id = aPC.Case__c;
        fulfilmentCase.OwnerId = queueId;
        try {
            upsert fulfilmentcase;
            aPC.Case__c = fulfilmentcase.Id;
            update aPC;
        } catch (Exception exp) {
            system.debug('Exception---' + exp.getMessage());
        }
    }

    /** 
    * @description get cafApplication
    * @param caseId
    * @return Queue
    
    */
    @AuraEnabled
    public static OpportunityLineItem getApplicationId(String caseId) {
        Application_Product_CAF__c application = [SELECT Id, Case__c FROM Application_Product_CAF__c WHERE Case__c = :caseId];
        OpportunityLineItem oppLine = new OpportunityLineItemsSelector().byApplicationProductCAF(application.Id);
        return oppLine;
    }
    /** 
    * @description get cafApplication
    * @param caseId
    * @return Queue
    
    */
    @AuraEnabled 
    public static Map<Object,Object> fetchSendToFromCase(String caseId){	
        Map<Object,Object> dataMap = new Map<Object,Object>();	
        Case cs = [Select Id,OwnerId,Information_Source__c,Decision_Data__c From Case Where Id =: caseId LIMIT 1];	
        if(cs.Decision_Data__c != '' && cs.Decision_Data__c != null){	
            String[] dataArray = cs.Decision_Data__c.split('#####');	
            System.debug('dataArray '+dataArray);	
            if(dataArray[1] == UserInfo.getUserId()){	
                dataMap.put('ISSAMEOWNER', 'TRUE');	
                dataMap.put('COMPNAME', dataArray[0]);	
            }else{	
                dataMap.put('ISSAMEOWNER', 'FALSE');	
            }	
        }	
        return dataMap;	
    }	
    /** 
    * @description get cafApplication
    * @param caseId
    * @return caseOwner
    
    */
    @AuraEnabled	
    public static String fetchCaseOwner(String caseId){	
        String caseOwner = '';	
        caseOwner = [Select Id,OwnerId,Owner.Name, Owner.Type From Case Where Id =: caseId LIMIT 1].Owner.Name;	
        return caseOwner;	
    }	
    /** 
    * @description get cafApplication
    * @param caseId
    * @param componentName
    * @param ownerId
    
    */
    @AuraEnabled	
    public static void updateDecisionDataToCase(String caseId,String componentName,String ownerId){	
        Case cs = [Select Id,OwnerId,Decision_Data__c From Case Where Id =: caseId LIMIT 1];	
        Boolean isCaseOwnerQueue = true;	
        String ownId = ownerId;//String.valueOf(cs.OwnerId);	
        System.debug('ownId '+ownId);	
        if(cs != null){	
            System.debug('IS USER '+ownId.StartsWith('005'));	
            if(ownId.StartsWith('005')){	
                isCaseOwnerQueue = false;	
            }	
            System.debug('isCaseOwnerQueue '+isCaseOwnerQueue);	
            if(!isCaseOwnerQueue){	
                cs.Decision_Data__c = componentName+'#####'+cs.OwnerId;	
            }else{	
                cs.Decision_Data__c = '';	
            }	
            System.debug('Decision_Data__c' +cs.Decision_Data__c);	
            update cs;	
        }
}
}