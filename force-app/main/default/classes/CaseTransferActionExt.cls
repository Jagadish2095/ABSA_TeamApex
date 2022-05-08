/**
* Apex extension class for the lightning quick action CaseTransferAction
*
* @author  Rudolf Niehaus : CloudSmiths
* @since   2018-06-28
*
* 12/07/2018 - TdB - Query related Service Queue and update Case
*
**/
public class CaseTransferActionExt {
    
    
    
     /*
    * Return the closed status of teh current case
    *
    * @param  caseId String
    * @return Boolean
    */
    @AuraEnabled
    public static Boolean getCaseCloseStatus(String caseId) {
        
        Set<Id> idSet = new Set<Id>();
        idSet.add(caseId);
        
        List<Case> focusedCase = new CasesSelector().selectById(idSet);
        
        if(focusedCase.size() > 0){
            
            if(focusedCase[0].isClosed){
                return true;
            }else{
                return false;
            }
            
        }else{
           return false;  
        }
    }
    
   /*
    * Transfer a Case                        
    * <p>
    * Transfer a Case from the existing queue
    * to a new queue that were selected by 
    * the end user
    *
    * @param  caseId String 
    * @param  qname String 
    * @param  reason String
    * @param  comments String
    * @return void
    */
    @AuraEnabled
    public static void transferCase(String caseId, String qname, String reason, String comments, Service_Group__c serviceGroupRecord) {
        //Add Case Id to Set
        Set<Id> caseIds = new Set<Id>();
        caseIds.add(caseId);
        
        Set<Id> serviceGroupIds = new Set<Id>();
        List<Service_Group_Type__c> serviceGroupTypes = new List<Service_Group_Type__c>();
        
        //Call method from Case selector to query case details
        List<Case> actionCases = new CasesSelector().selectById(caseIds);
        
        if(serviceGroupRecord != null) {
            
            actionCases[0].sd_Service_Group__c = serviceGroupRecord.Name;
            actionCases[0].sd_Service_Group_Id__c = serviceGroupRecord.id;
            actionCases[0].Service_Group_Search__c = serviceGroupRecord.id;
            actionCases[0].Bulk_Transfer_Selected_Cases__c = true;
            actionCases[0].Transfer_Reason__c = reason;
            actionCases[0].Transfer_Comments__c = comments;
            
            serviceGroupIds.add(serviceGroupRecord.Id);
            //Call method from Service Group Types Selector to query Service Group Types details
            serviceGroupTypes = new ServiceGroupTypesSelector().selectByServiceGroupWithGroupAndServiceInfo(serviceGroupIds);
            
            if(!serviceGroupTypes.isEmpty()){
                actionCases[0].Internal_SLA_Notification_User__c  = serviceGroupTypes[0].Service_Group__r.Internal_SLA_Notification_User__c;     
                actionCases[0].External_SLA_Notification_User__c = serviceGroupTypes[0].Service_Level__r.External_SLA_Notification_User__c;
                actionCases[0].sd_Service_Group_Type_Id__c = serviceGroupTypes[0].Id;
            }
            
            RecordType rtype = [Select Id, Name From RecordType Where Name =:serviceGroupRecord.Assign_Record_Type__c And sObjectType =:'Case'];
            system.debug(LoggingLevel.FINE, 'caseREOCRDTYPE:'+rtype);
            if(rtype != null){
                actionCases[0].RecordTypeId = rtype.Id;
                actionCases[0].Bypass_Validation_Rules__c = true;
            }
                            
            if(qname == 'EmailTransfer'){
                
                List<Group> caseQueues = [Select Id, Name, DeveloperName From Group Where Name =: serviceGroupRecord.Queue__c AND  Type =: 'Queue'];
                if(caseQueues.size() > 0){
                    actionCases[0].OwnerId = caseQueues[0].Id;
                }
                //koketso - when complaint's sla is extended and approved, do not update the sla end date on case escalation
                if(actionCases[0].SLA_Extension_Approval__c != 'Approved'){
                    if(actionCases[0].BusinessHoursId == null){
                       actionCases[0].BusinessHoursId = [Select Id From BusinessHours Where isActive = true Limit 1].Id; 
                    }
                    
                    Map<String, DateTime> externalSLA = CaseTriggerFunctions.calculateSLADateTime(actionCases[0].CreatedDate, actionCases[0].BusinessHoursId, 
                                                                                                  serviceGroupTypes[0].Service_Level__r.External_SLA_Time_Measure__c, 
                                                                                                  Integer.valueOf(serviceGroupTypes[0].Service_Level__r.External_SLA_Units__c));
                    
                    actionCases[0].External_SLA_Warning_Date__c = externalSLA.get('slaWarningDate');
                    actionCases[0].External_SLA_End_Date__c = externalSLA.get('slaEndDate');
                    actionCases[0].sd_External_SLA_Units__c = serviceGroupTypes[0].Service_Level__r.External_SLA_Units__c;
                    actionCases[0].sd_External_SLA_Time_Measure__c = serviceGroupTypes[0].Service_Level__r.External_SLA_Time_Measure__c;
                    
                    
                    if(actionCases[0].SLA_Extension_Approval__c == 'Pending'){
                        Approval.ProcessResult recallResult = recallPendingApproval(actionCases[0].Id);

                        if(recallResult != null && recallResult.isSuccess()){
                            actionCases[0].SLA_Extension_Approval__c = 'Rejected';
                        }
                    }
                    
                }
                
                actionCases[0].Case_Escalated_by_Email__c = true;
            }
            
            try{
                update actionCases;
            }catch(DMLException ex){
                System.debug(LoggingLevel.FINE, 'Additional Info:' + ex.getMessage());
                throw new AuraHandledException(ex.getMessage()); 
            }
        }else{
            
            System.debug('There was an error transferring the Case - Service Group is not setup correctly, please contact your Salesforce Administrator');
            throw new AuraHandledException('There was an error transferring the Case - Service Group is not setup correctly, please contact your Salesforce Administrator'); 
        }
    } 
    
    /*JQUEV W-007101 2020/10/29
    * Transfer a Case from the existing queue
    * to a new queue that is specified on the Service_Group_Type__c Obj
    * based on the Service Group Name and Service Type Name
    */
    @AuraEnabled
    public static void transferCase(String serviceGroupName, String serviceTypeName, String caseId) {

        List<Service_Group_Type__c> serviceGroupTypeList = new ServiceGroupTypesSelector().selectByServiceGroupNameAndServiceTypeName(serviceGroupName, serviceTypeName);

        if(!serviceGroupTypeList.isEmpty()){

            List<Case> caseList = new CasesSelector().selectById(new Set<Id>{caseId});
            caseList[0].sd_Service_Group__c = serviceGroupTypeList[0].Service_Group__r.Name;
            caseList[0].sd_Service_Group_Id__c = serviceGroupTypeList[0].Service_Group__r.Id;
            caseList[0].Service_Group_Search__c = serviceGroupTypeList[0].Service_Group__r.Id;

            caseList[0].Internal_SLA_Notification_User__c  = serviceGroupTypeList[0].Service_Group__r.Internal_SLA_Notification_User__c;
            caseList[0].External_SLA_Notification_User__c = serviceGroupTypeList[0].Service_Level__r.External_SLA_Notification_User__c;
            caseList[0].sd_Service_Group_Type_Id__c = serviceGroupTypeList[0].Id;

            caseList[0].Type__c = serviceGroupTypeList[0].Service_Type__r.Type__c;
            caseList[0].Subtype__c = serviceGroupTypeList[0].Service_Type__r.Subtype__c;
            caseList[0].Bulk_Transfer_Selected_Cases__c = false;

            RecordType recType = [Select Id, Name From RecordType Where Name =: serviceGroupTypeList[0].Service_Group__r.Assign_Record_Type__c And sObjectType =:'Case'];
            if(recType != null){
                caseList[0].RecordTypeId = recType.Id;
                caseList[0].Bypass_Validation_Rules__c = true;
            }
            update caseList[0];
        }else{
            //Error none found
            String msg = 'There was an error transferring the Case - Could not locate the Service_Group_Type__c from associated Service_Group__c (' + serviceGroupName + ') and Service_Type__c (' + serviceTypeName + '), Method: CaseTransferActionExt.transferCase, please contact your Salesforce Administrator';
            throw new AuraHandledException(msg);
        }
    }

    /*
     * Search case Service Group records                         
     * <p>
     * Search and return a single Service_Group__c object
     * based on the record Id
     *
     * @param  recId String Service_Group__c object Id  
     * @return A single Service_Group__c object 
    */
    @AuraEnabled
    public static Service_Group__c findServiceGroupRecord(String serviceGroupId) {
        
        //Add Id to a Set
        Set<Id> serviceGroupTypes = new Set<Id>();
        serviceGroupTypes.add(serviceGroupId);
        list<Service_Group__c> returnRec = new ServiceGroupsSelector().selectById(serviceGroupTypes);
        
        if(returnRec.size() > 0){
            return returnRec[0];
        }else{
            return null;
        }
    }
    
    /*
     * Koketso - recall currently pending approval request for an escalated case                        
     * @param  recId ID target object Id for an item to be recalled 
     * @date 17-11-2020
    */
    public static Approval.ProcessResult recallPendingApproval(Id recId){
        
        Approval.ProcessResult result;
        List<ProcessInstanceWorkitem> iWorkItems = [Select Id, ProcessInstance.TargetObjectId, ProcessInstance.Status From ProcessInstanceWorkitem Where ProcessInstance.TargetObjectId = :recId And ProcessInstance.Status =:'Pending'];
        system.debug(LoggingLevel.FINE, '***iWorkItems:***'+iWorkItems);
        
        try{
            if(iWorkItems.size() > 0){
                Approval.ProcessWorkitemRequest pWorkItemRequest = new Approval.ProcessWorkitemRequest(); 
                pWorkItemRequest.setAction('Reject');
                pWorkItemRequest.setWorkItemId(iWorkItems[0].Id);
                result = Approval.process(pWorkItemRequest);
                system.debug(LoggingLevel.FINE, '***ProcessResult:***'+result);
            }
        }catch(Exception ex){
            system.debug(LoggingLevel.FINE, '***Recall Pending Approval Error:***'+ex.getMessage());
        }
        
        return result;
        
    }
}