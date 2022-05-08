/**
* Class that groups all the methods together that are used to
* implement a communication plan and rules for action
*
* @author  Rudolf Niehaus - CloudSmiths
* @since   2018-03-04
*/
public without sharing class CommunicationPlanFunctions {
    
    /*
    * Determine which sObject type is implimenting the communication plan
    * and execute accordingly
    * 
    * @param List<SObject> newObjects
    */
    public static void createCommunicationTasks(List<SObject> newObjects){        
        if(newObjects.size() > 0){            
            SObjectType objType = newObjects[0].getSObjectType();
            Map<String, Schema.SObjectField> fieldMap = objType.getDescribe().fields.getMap();            
            Map<String, String> labelApiMap = getLabelAPIMap(fieldMap);            
            String listType = 'List<' + objType + '>';            
            List<SObject> castRecordList = (List<SObject>)Type.forName(listType).newInstance();            
            castRecordList.addAll(newObjects);
            if(objType == Case.SObjectType){                
                createCaseRelatedTasks(castRecordList, labelApiMap);                    
            }else if(objType == Lead.SObjectType){
                createLeadRelatedTasks(castRecordList, labelApiMap);
            }
            else if(objType == Application__c.SObjectType){ //W-005904
                createApplRelatedTasks(castRecordList, labelApiMap);
            }
        }
    }
    
    /*
    * Determine which sObject type is implimenting the communication plan
    * and execute accordingly
    * 
    * @param List<SObject> newObjects
    * @param List<SObject> oldObjects
    */
    public static void evaluateCommunicationTasks(List<SObject> newObjects, List<SObject> oldObjects){ 
        if(newObjects.size() > 0){            
            SObjectType objType = newObjects[0].getSObjectType();
            SObjectType objTypeOld = oldObjects[0].getSObjectType();
            Map<String, Schema.SObjectField> fieldMap = objType.getDescribe().fields.getMap();
            Map<String, String> labelApiMap = getLabelAPIMap(fieldMap);            
            String listType = 'List<' + objType + '>';
            String listTypeOld = 'List<' + objTypeOld + '>';
            List<SObject> castNewRecordList = (List<SObject>)Type.forName(listType).newInstance();
            List<SObject> castOldRecordList = (List<SObject>)Type.forName(listTypeOld).newInstance();            
            castNewRecordList.addAll(newObjects);
            castOldRecordList.addAll(oldObjects);            
            if(objType == Case.SObjectType){                
                evaluateCaseRelatedTasks(castNewRecordList, castOldRecordList, labelApiMap);                
            }else if(objType == Lead.SObjectType){
                evaluateLeadRelatedTasks(castNewRecordList, castOldRecordList, labelApiMap);                
            }
            else if(objType == Application__c.SObjectType){ //W-005904
                evaluateApplRelatedTasks(castNewRecordList, castOldRecordList, labelApiMap);                
            }
        }
    }
    
    /*
    * Create or update a communication type task for each communication rule
    * 
    * @param SObject obj
    * @param sd_communication_Rule__c rule
    * @param Map<String, String> objLabelNameMap
    * @param Task tsk
    * @return Task
    */
    public static Task createSObjectTask(SObject obj, sd_Communication_Rule__c rule, Map<String, String> objLabelNameMap, Task tsk){
        SObjectType objType = obj.getSObjectType();
        SObject castRecord;
        if(objType == Case.SObjectType){
            castRecord = (Case)obj; 
        }else if(objType == Lead.SObjectType){
            castRecord = (Lead)obj;
        }else if(objType == Application__c.SObjectType){//W-005904
            castRecord = (Application__c)obj;
        }
        Task t = new Task();        
        if(tsk == null){
            Map<String, Schema.RecordTypeInfo> taskRecordTypeMap = Task.sObjectType.getDescribe().getRecordTypeInfosByName();
            t.Priority = 'Normal';
            t.Status = 'Scheduled';
            t.Type = 'Notification';          
            t.RecordTypeId = taskRecordTypeMap.get('Communication Plan Tasks').RecordTypeId;
            t.Subject = rule.sd_Rule_Description__c;
            t.Communication_Rule_Id__c = rule.Id;
            if(objType == Lead.SObjectType){
                t.WhoId = castRecord.Id;
            }else if(objType == Application__c.SObjectType){ //W-005904
                t.whatId = castRecord.Id;
            }else{
                t.WhatId = castRecord.Id;
            }
            t.Communication_Task_Unique_Key__c = castRecord.Id + '' + rule.Id;
        }else{  
            t = tsk;
        }        
        if(rule.sd_When_to_Trigger__c == 'Immediate'){
            t.Action_Date__c = System.now();            
        }else{
            if(rule.sd_Quantity__c != null && rule.sd_Quantity__c > 0){                
                Object fieldValue = castRecord.get(objLabelNameMap.get( rule.sd_Trigger_Date_Field__c ));
                DateTime futureDate = DateTime.valueOf( fieldValue );                
                t.Action_Date__c = calculateActionDate(futureDate, 
                                                       rule.sd_Business_Hours__c, 
                                                       rule.sd_Units__c, 
                                                       Integer.valueOf(rule.sd_Quantity__c), 
                                                       rule.sd_Before_After__c);                
            }
        }        
        return t;
    }

    /*
    * Get all the communication plan rules for updated cases and evaluate 
    * the relevant activities for each plan rule relevant to Cases
    * 
    * @param List<Case> newCasesValues
    * @param List<Case> oldCasesValues
    * @param Map<String, String> objLabelNameMap
    */
    public static void evaluateCaseRelatedTasks(List<Case> newCasesValues, List<Case> oldCasesValues, Map<String, String> objLabelNameMap){
        Map<Id, Case> oldCaseValueMap = new Map<Id, Case>(oldCasesValues);
        Map<Id, Case> newCasesValueMap = new Map<Id, Case>(newCasesValues);
        Set<Id> planIds = new Set<Id>();
        Set<Id> caseIds = new Set<Id>();
        Map<String, Task> ruleTaskMap = new Map<String, Task>();
        List<Task> taskUpdateList = new List<Task>();
        List<Task> taskDeletionList = new List<Task>();
        Set<String> closeStatuses = new Set<String>();
        //get all closes statuses as the isClose flag is not set in triggers when a user close a case
        for(CaseStatus cs :[Select MasterLabel From CaseStatus Where IsClosed = true]){
            closeStatuses.add(cs.MasterLabel);
        }
        for(Case c :newCasesValues){
            planIds.add(c.sd_Communication_Plan_Id__c);
            caseIds.add(c.Id);
        }        
        for(Task t :new TasksSelector().selectByWhatId(caseIds)){
            ruleTaskMap.put(t.Communication_Task_Unique_Key__c, t);
        }        
        List<sd_Communication_Plan__c> plansWithRules = new CommunicationPlansSelector().selectByIdWithRules(planIds);
        Map<Id, List<sd_Communication_Rule__c>> planRulesMap = new Map<Id, List<sd_Communication_Rule__c>>();
        Map<String, Schema.RecordTypeInfo> taskRecordTypeMap = Task.sObjectType.getDescribe().getRecordTypeInfosByName();            
        for(sd_Communication_Plan__c plan :plansWithRules){
            planRulesMap.put(plan.Id, plan.sd_Communication_Rules__r);
        }        
        Boolean ruleMetCondition = false;
        for(Case c :newCasesValues){
            if(String.isNotBlank( c.sd_Communication_Plan_Id__c )) {
                for(sd_communication_Rule__c rule :planRulesMap.get(c.sd_Communication_Plan_Id__c)){                
                     String commsTaskUniqueKey = c.Id + '' + rule.Id;
                    if( rule.sd_When_to_Trigger__c == 'Time Based'){
                        Object newFieldValue = c.get(objLabelNameMap.get( rule.sd_Trigger_Date_Field__c ));
                        Object oldFieldValue = oldCaseValueMap.get(c.Id).get(objLabelNameMap.get( rule.sd_Trigger_Date_Field__c ));
                        DateTime newFutureDate = DateTime.valueOf( newFieldValue );
                        DateTime oldFutureDate = DateTime.valueOf( oldFieldValue );                        
                        if(newFutureDate != oldFutureDate){
                            Task t = createSObjectTask(c, rule, objLabelNameMap, ruleTaskMap.get(commsTaskUniqueKey));
                            taskUpdateList.add(t);
                        }
                    }                    
                    switch on rule.sd_Trigger_Condition__c {
                        when 'Case Closed' {
                            if(c.Status != oldCaseValueMap.get(c.Id).Status 
                                && c.Case_Ownership__c != 'FPOC' 
                                && String.isBlank(c.Unwanted_Type__c) 
                                && String.isBlank(c.ParentId) ) {                                
                                if(closeStatuses.contains(c.Status)){
                                    ruleMetCondition = true;
                                }else{
                                    ruleMetCondition = false;
                                }
                            }
                        }
                        when 'Case Owner Change to User' {
                            //Owner.Type not accessable in triggers, look at the object prefix
                            if( c.OwnerId != oldCaseValueMap.get(c.Id).OwnerId 
                                && String.valueOf(c.OwnerId).startsWith('005')){
                                ruleMetCondition = true;
                            }else{
                                 ruleMetCondition = false;
                            }
                        }
                        when 'Status Change to In Progress' {
                            if( c.Status != oldCaseValueMap.get(c.Id).Status && !closeStatuses.contains(c.Status) ) {                                
                                if(c.Status == 'In Progress'){
                                    ruleMetCondition = true;
                                }else{
                                    ruleMetCondition = false;
                                }                                
                            }
                        }
                        when 'Case Owner Change to Queue' {
                            //Owner.Type not accessable in triggers, look at the object prefix
                            if( c.OwnerId != oldCaseValueMap.get(c.Id).OwnerId 
                                && String.valueOf(c.OwnerId).startsWith('00G')){
                                ruleMetCondition = true;
                            }else{
                                ruleMetCondition = false;
                            }
                        }
                        when 'Case Open' {
                            if(c.Status != oldCaseValueMap.get(c.Id).Status 
                                && c.Case_Ownership__c != 'FPOC' 
                                && String.isBlank(c.Unwanted_Type__c) ){
                                if( closeStatuses.contains(c.Status) ){
                                    ruleMetCondition = false;
                                }else{
                                    ruleMetCondition = true;
                                }
                            }
                        }
                        when 'Case External SLA Date Change' {
                            if( c.External_SLA_End_Date__c != oldCaseValueMap.get(c.Id).External_SLA_End_Date__c ) {                                
                                if( closeStatuses.contains(c.Status) ){
                                    ruleMetCondition = false;
                                }else{
                                    ruleMetCondition = true;
                                } 
                            }
                        }
                        when else {
                            //ruleMetCondition = false;
                        }
                    }
                    if(ruleMetCondition){
                        Task t = createSObjectTask(c, rule, objLabelNameMap, ruleTaskMap.get(commsTaskUniqueKey));
                        taskUpdateList.add(t);
                        ruleMetCondition = false;
                    }else{
                        if( ruleTaskMap.containsKey( commsTaskUniqueKey ) ){
                            if( ruleTaskMap.get(commsTaskUniqueKey).Status == 'Scheduled' && rule.sd_When_to_Trigger__c == 'Time Based' ){
                                  taskDeletionList.add( ruleTaskMap.get(commsTaskUniqueKey) );
                            }
                        }
                    }
                }
            }
        }
        if( taskUpdateList.size() > 0 ) {            
            try{
                upsert taskUpdateList Communication_Task_Unique_Key__c;
            }catch(DMLException ex){
                System.debug(ex.getMessage());
                AuditTrailLog.logException(ex, 'New', 'Error', 'CommunicationPlanFunctions', 'evaluateCaseRelatedTasks', 'There was an error updating existing communication tasks');
                throw ex;                 
            }
        }
        if( taskDeletionList.size() > 0 ) {            
            try{
                delete taskDeletionList;
            }catch(DMLException ex){
                System.debug(ex.getMessage());
                AuditTrailLog.logException(ex, 'New', 'Error', 'CommunicationPlanFunctions', 'evaluateCaseRelatedTasks', 'There was an error deleting existing communication tasks');
                throw ex;                 
            }
        }
    }
    
    /*
    * Get all the communication plan rules for updated Leads and evaluate 
    * the relevant activities for each plan rule relevant to Leads
    * 
    * @param List<Lead> newLeadValues
    * @param List<Lead> oldLeadValues
    * @param Map<String, String> objLabelNameMap
    */
    public static void evaluateLeadRelatedTasks(List<Lead> newLeadValues, List<Lead> oldLeadValues, Map<String, String> objLabelNameMap){       
        Map<Id, Lead> oldLeadValueMap = new Map<Id, Lead>(oldLeadValues);
        Set<Id> planIds = new Set<Id>();
        Set<Id> leadIds = new Set<Id>();
        Map<String, Task> ruleTaskMap = new Map<String, Task>();
        List<Task> taskUpdateList = new List<Task>();
        List<Task> taskDeletionList = new List<Task>();
        for(Lead l :newLeadValues){
            planIds.add(l.sd_Communication_Plan_Id__c);
            leadIds.add(l.Id);
        }        
        for(Task t :new TasksSelector().selectTasksByWhoId(LeadIds)){
            ruleTaskMap.put(t.Communication_Task_Unique_Key__c, t);
        }        
        List<sd_Communication_Plan__c> plansWithRules = new CommunicationPlansSelector().selectByIdWithRules(planIds);
        Map<Id, List<sd_Communication_Rule__c>> planRulesMap = new Map<Id, List<sd_Communication_Rule__c>>();
        Map<String, Schema.RecordTypeInfo> taskRecordTypeMap = Task.sObjectType.getDescribe().getRecordTypeInfosByName();            
        for(sd_Communication_Plan__c plan :plansWithRules){
            planRulesMap.put(plan.Id, plan.sd_Communication_Rules__r);
        }        
        Boolean ruleMetCondition = false;
        for(Lead l :newLeadValues){
            if(String.isNotBlank( l.sd_Communication_Plan_Id__c )) {
                for(sd_communication_Rule__c rule :planRulesMap.get(l.sd_Communication_Plan_Id__c)){                
                    String commsTaskUniqueKey = l.Id + '' + rule.Id;
                    if( rule.sd_When_to_Trigger__c == 'Time Based'){
                        Object newFieldValue = l.get(objLabelNameMap.get( rule.sd_Trigger_Date_Field__c ));
                        Object oldFieldValue = oldLeadValueMap.get(l.Id).get(objLabelNameMap.get( rule.sd_Trigger_Date_Field__c ));
                        DateTime newFutureDate = DateTime.valueOf( newFieldValue );
                        DateTime oldFutureDate = DateTime.valueOf( oldFieldValue );                        
                        if(newFutureDate != oldFutureDate){
                            Task t = createSObjectTask(l, rule, objLabelNameMap, ruleTaskMap.get(commsTaskUniqueKey));
                            taskUpdateList.add(t);
                        }
                    }                    
                    switch on rule.sd_Trigger_Condition__c {
                        when 'Lead Converted' {
                            if( l.Status != oldLeadValueMap.get(l.Id).Status   
                               && l.Status == 'Qualified' ){
                                ruleMetCondition = true;
                            }else{
                                ruleMetCondition = false;
                            }
                        }
                        when 'Lead Created Not As Internal Propensity' {
                            if(l.LeadSource != oldLeadValueMap.get(l.Id).LeadSource  
                                && l.LeadSource != 'Internal Propensity'){                                
                                ruleMetCondition = true; 
                            }else{
                                ruleMetCondition = false;
                            }
                        }
                        when 'First Unsuccessful Call' {
                            if(l.Unsuccessful_Calls__c != oldLeadValueMap.get(l.Id).Unsuccessful_Calls__c 
                                && l.Unsuccessful_Calls__c >= 1){                                
                                if(l.Status == 'Working' || l.Status == 'Nurturing'){
                                     ruleMetCondition = true; 
                                }
                            }
                            if(l.Status != oldLeadValueMap.get(l.Id).Status && l.Unsuccessful_Calls__c >= 1){
                                if(l.Status == 'Working' || l.Status == 'Nurturing'){
                                     ruleMetCondition = true; 
                                }else{
                                    ruleMetCondition = false;
                                }
                            }                         
                        }
                        when 'Status Change to Unqualified' {                            
                            if( l.Status != oldLeadValueMap.get(l.Id).Status   
                               && l.Status == 'Unqualified' ){
                                ruleMetCondition = true; 
                            }else{
                                ruleMetCondition = false;
                            }                           
                        }
                        when 'Status Change to Abandoned' {
                            if( l.Status != oldLeadValueMap.get(l.Id).Status   
                               && l.Status == 'Abandoned' ){
                                ruleMetCondition = true; 
                            }else{
                                ruleMetCondition = false;
                            }                            
                        }
                        when 'Lead Not Converted' {
                            //check id still not converted, else delete task
                            if( l.Status != oldLeadValueMap.get(l.Id).Status   
                               && l.Status == 'Qualified' ){                                
                                ruleMetCondition = false;
                            }
                        }
                    }
                    if(ruleMetCondition){
                        Task t = createSObjectTask(l, rule, objLabelNameMap, ruleTaskMap.get(commsTaskUniqueKey));
                        taskUpdateList.add(t);
                        ruleMetCondition = false;
                    }else{
                        if( ruleTaskMap.containsKey( commsTaskUniqueKey ) ){
                            if( ruleTaskMap.get( commsTaskUniqueKey ).Status == 'Scheduled' && rule.sd_When_to_Trigger__c == 'Time Based' ){
                                  taskDeletionList.add( ruleTaskMap.get( commsTaskUniqueKey ) );
                            }
                        }
                    }
                }
            }
        }
        if( taskUpdateList.size() > 0 ) {            
            try{
                upsert taskUpdateList Communication_Task_Unique_Key__c;
            }catch(DMLException ex){
                System.debug(ex.getMessage());                
                AuditTrailLog.logException(ex, 'New', 'Error', 'CommunicationPlanFunctions', 'evaluateCaseRelatedTasks', 'There was an error updating existing communication tasks');
                throw ex;                 
            }
        }
        if( taskDeletionList.size() > 0 ) {            
            try{
                delete taskDeletionList;
            }catch(DMLException ex){
                System.debug(ex.getMessage());
                AuditTrailLog.logException(ex, 'New', 'Error', 'CommunicationPlanFunctions', 'evaluateCaseRelatedTasks', 'There was an error deleting existing communication tasks');
                throw ex;                 
            }
        }
    }
   
     /* W-005904 -Anka Ganta 2020-09-14
    * Get all the communication plan rules for updated Application records and evaluate 
    * the relevant activities for each plan rule relevant to Application
    * 
    * @param List<Application__c> newApplValues
    * @param List<Application__c> oldApplValues
    * @param Map<String, String> objLabelNameMap
    */
    public static void evaluateApplRelatedTasks(List<Application__c> newApplValues, List<Application__c> oldApplValues, Map<String, String> objLabelNameMap){       
        Map<Id, Application__c> oldApplValueMap = new Map<Id, Application__c>(oldApplValues);
        Set<Id> planIds = new Set<Id>();
        Set<Id> applIds = new Set<Id>();
        Map<String, Task> ruleTaskMap = new Map<String, Task>();
        List<Task> taskUpdateList = new List<Task>();
        List<Task> taskDeletionList = new List<Task>();
        for(Application__c appl :newApplValues){
            planIds.add(appl.sd_Communication_Plan_Id__c);
            applIds.add(appl.Id);
        }        
        for(Task t :new TasksSelector().selectByWhatId(applIds)){
            ruleTaskMap.put(t.Communication_Task_Unique_Key__c, t);
        }        
        List<sd_Communication_Plan__c> plansWithRules = new CommunicationPlansSelector().selectByIdWithRules(planIds);
        Map<Id, List<sd_Communication_Rule__c>> planRulesMap = new Map<Id, List<sd_Communication_Rule__c>>();
        Map<String, Schema.RecordTypeInfo> taskRecordTypeMap = Task.sObjectType.getDescribe().getRecordTypeInfosByName();            
        for(sd_Communication_Plan__c plan :plansWithRules){
            planRulesMap.put(plan.Id, plan.sd_Communication_Rules__r);
        }        
        Boolean ruleMetCondition = false;
        for(Application__c app :newApplValues){
            if(String.isNotBlank( app.sd_Communication_Plan_Id__c )) {
                for(sd_communication_Rule__c rule :planRulesMap.get(app.sd_Communication_Plan_Id__c)){                
                    String commsTaskUniqueKey = app.Id + '' + rule.Id;
                    System.debug('commsTaskUniqueKey ++'+commsTaskUniqueKey);
                    if( rule.sd_When_to_Trigger__c == 'Time Based'){
                        Object newFieldValue = app.get(objLabelNameMap.get( rule.sd_Trigger_Date_Field__c ));
                        Object oldFieldValue = oldApplValueMap.get(app.Id).get(objLabelNameMap.get( rule.sd_Trigger_Date_Field__c ));
                        DateTime newFutureDate = DateTime.valueOf( newFieldValue );
                        DateTime oldFutureDate = DateTime.valueOf( oldFieldValue );                        
                        if(newFutureDate != oldFutureDate){
                            Task t = createSObjectTask(app, rule, objLabelNameMap, ruleTaskMap.get(commsTaskUniqueKey));
                            taskUpdateList.add(t);
                        }
                    }                    
                    switch on rule.sd_Trigger_Condition__c {
                        when 'Account Not Activated 7 days' {
                            if( app.Number_of_days_account_has_not_activated__c != oldApplValueMap.get(app.Id).Number_of_days_account_has_not_activated__c   
                               && app.Number_of_days_account_has_not_activated__c == 7 ){
                                   ruleMetCondition = true;
                               }
                        }
                        when 'Account Not Activated 14 days' {
                            if( app.Number_of_days_account_has_not_activated__c != oldApplValueMap.get(app.Id).Number_of_days_account_has_not_activated__c   
                               && app.Number_of_days_account_has_not_activated__c == 14 ){
                                   ruleMetCondition = true;
                               }
                        }
                        when 'Account Not Activated 75 days' {
                            if( app.Number_of_days_account_has_not_activated__c != oldApplValueMap.get(app.Id).Number_of_days_account_has_not_activated__c   
                               && app.Number_of_days_account_has_not_activated__c == 75 ){
                                   ruleMetCondition = true;
                               }
                        }
                        when 'Welcome Letter Day 7' {
                            System.debug('application Id '+app.Id);
                            if( app.Number_of_days_account_has_not_activated__c != oldApplValueMap.get(app.Id).Number_of_days_account_has_not_activated__c   
                               && app.Number_of_days_account_has_not_activated__c == 7 ){
                                   ruleMetCondition = true;
                               }
                        }
                        //Newly added by Rajesh @ 17/09/2020
                        when 'No Transactional Activity' {
                            if( app.Number_of_days_account_has_not_activated__c != oldApplValueMap.get(app.Id).Number_of_days_account_has_not_activated__c   
                               && (app.Number_of_days_account_has_not_activated__c == 21 || app.Number_of_days_account_has_not_activated__c == 42 || app.Number_of_days_account_has_not_activated__c == 63 || app.Number_of_days_account_has_not_activated__c == 84) ){
                                   ruleMetCondition = true;
                               }
                        }
                        //Added by Rajesh for W-5911
                        when 'Account Not Activated 45 days' {
                            System.debug('application Id '+app.Id);
                            if( app.Number_of_days_account_has_not_activated__c != oldApplValueMap.get(app.Id).Number_of_days_account_has_not_activated__c   
                               && app.Number_of_days_account_has_not_activated__c == 45 ){
                                   ruleMetCondition = true;
                               }
                        }
                        //Added by Rajesh for W-5902
                        when 'Welcome Letter' {
                            System.debug('application Id '+app.Id);
                            if( app.Number_of_days_account_has_not_activated__c != oldApplValueMap.get(app.Id).Number_of_days_account_has_not_activated__c   
                               && app.Number_of_days_account_has_not_activated__c == 1 ){
                                   ruleMetCondition = true;
                               }
                        }
                    }
                    System.debug('ruleMetCondition value'+ruleMetCondition);  
                    if(ruleMetCondition){
                        System.debug('create task before');
                        Task t = createSObjectTask(app, rule, objLabelNameMap, ruleTaskMap.get(commsTaskUniqueKey));
                        System.debug('create task after'+t.id);
                        taskUpdateList.add(t);
                        ruleMetCondition = false;
                    }else{
                        if( ruleTaskMap.containsKey( commsTaskUniqueKey ) ){
                            if( ruleTaskMap.get( commsTaskUniqueKey ).Status == 'Scheduled' && rule.sd_When_to_Trigger__c == 'Time Based' ){
                                taskDeletionList.add( ruleTaskMap.get( commsTaskUniqueKey ) );
                            }
                        }
                    }
                }
            }
        }
        if( taskUpdateList.size() > 0 ) {            
            try{
                upsert taskUpdateList Communication_Task_Unique_Key__c;
            }catch(DMLException ex){
                System.debug(ex.getMessage());                
                AuditTrailLog.logException(ex, 'New', 'Error', 'CommunicationPlanFunctions', 'evaluateApplRelatedTasks', 'There was an error updating existing communication tasks');
                throw ex;                 
            }
        }
        if( taskDeletionList.size() > 0 ) {            
            try{
                delete taskDeletionList;
            }catch(DMLException ex){
                System.debug(ex.getMessage());
                AuditTrailLog.logException(ex, 'New', 'Error', 'CommunicationPlanFunctions', 'evaluateApplRelatedTasks', 'There was an error deleting existing communication tasks');
                throw ex;                 
            }
        }
    }
    
    /*
    * Generate a map between field label and field name (API name)
    * for a specific SObject
    * 
    * @param Map<String, Schema.SObjectField> fieldMap
    * @return Map<String, String>
    */
    public static Map<String, String> getLabelAPIMap( Map<String, Schema.SObjectField> fieldMap ){        
        Map<String, String> objLabelAPIMap = new Map<String, String>();        
        for(String fieldName: fieldMap.keySet()) {
            String objLabel = fieldMap.get(fieldName).getDescribe().getLabel();
            objLabelAPIMap.put(objLabel, fieldName);
           //System.debug('Label => API map : ' + objLabel + ':' + fieldName);
        }        
        return objLabelAPIMap; 
    }
    
    /*
    * Action all the tasks passed into this method and return
    * the updated task list
    * @param List<Task> actionTasks - The tasks to action
    * @return List<Task>
    */
    public static List<Task> actionTasks(List<Task> actionTasks){
        Set<Id> ruleIds = new Set<Id>();
        List<Task> updatedTasks = new List<Task>();
        //Case related collections and object fieldmap
        Map<Id, Id> ruleCaseIdMap = new Map<Id, Id>();
        SObjectType objType = Case.getSObjectType();
        Map<String, Schema.SObjectField> fieldMap = objType.getDescribe().fields.getMap();
        Map<String, String> labelApiMap = getLabelAPIMap(fieldMap);
        Map<Id, List<Task>> ruleTaskMap = new Map<Id, List<Task>>();
        //Lead related collections and object fieldmap
        Map<Id, Id> ruleLeadIdMap = new Map<Id, Id>();
        SObjectType objTypeLead = Lead.getSObjectType();
        Map<String, Schema.SObjectField> fieldMapLead = objTypeLead.getDescribe().fields.getMap();
        Map<String, String> labelApiMapLeads = getLabelAPIMap(fieldMapLead);
        //Application related collections and object fieldmap- W-005904
        Map<Id, Id> ruleApplIdMap = new Map<Id, Id>();
        SObjectType objTypeApp = Application__c.getSObjectType();
        Map<String, Schema.SObjectField> fieldMapApp = objTypeApp.getDescribe().fields.getMap();
        Map<String, String> labelApiMapApps = getLabelAPIMap(fieldMapApp);
        Schema.SObjectType whatIdToken;
        Schema.SObjectType whoIdToken;
        for(Task t :actionTasks){
            Id whatId = null;
            Id whoId = null;
            if(String.isNotBlank(t.WhatId)){
                whatId = t.WhatId;
                whatIdToken = whatId.getSObjectType();
            }
            if(String.isNotBlank(t.WhoId)){
                whoId = t.WhoId;
                whoIdToken = whoId.getSObjectType();
            }
            //Non human object
            if(whatIdToken != null){
                if( whatIdToken == Case.SObjectType){
                    ruleCaseIdMap.put(t.WhatId, t.Communication_Rule_Id__c);
                }
                if( whatIdToken == Application__c.SObjectType){ //W-005904
                    ruleApplIdMap.put(t.WhatId, t.Communication_Rule_Id__c);
                }
                 //add logic here for other non human type objects eg Opportunities
            }
            //Human objects
            if(whoIdToken != null){
                if( whoIdToken == Lead.SObjectType ){
                    ruleLeadIdMap.put(t.WhoId, t.Communication_Rule_Id__c);
                }
                //add logic here for other human type objects eg Contact and Users
            }
            ruleIds.add(t.Communication_Rule_Id__c);
            //Group tasks per rule Id
            if(!ruleTaskMap.containsKey(t.Communication_Rule_Id__c)){
                ruleTaskMap.put(t.Communication_Rule_Id__c, new List<Task>());
            }
            if(ruleTaskMap.containsKey(t.Communication_Rule_Id__c)){
                ruleTaskMap.get(t.Communication_Rule_Id__c).add(t);
            }
        }
        if(ruleCaseIdMap.size() > 0){
             updatedTasks.addAll( actionCaseTasks( ruleIds, ruleCaseIdMap, labelApiMap, ruleTaskMap ));
        }
        if(ruleLeadIdMap.size() > 0){
            updatedTasks.AddAll( actionLeadTasks( ruleIds, ruleLeadIdMap, labelApiMapLeads, ruleTaskMap ));
        }
        if(ruleApplIdMap.size() > 0){// W-005904
            updatedTasks.AddAll( actionApplTasks( ruleIds, ruleApplIdMap, labelApiMapApps, ruleTaskMap ));
        }
        return updatedTasks;
    }

    /*
    * Method to send outbound email messages 
    * 
    * @param Id whatId
    * @param String targetObjectId
    * @param String toAddress
    * @param String fromAddress
    * @param String emailTemplate
    * @param Map<String,Id> orgWideIdMap
    * @return Messaging.SingleEmailMessage
    */
    public static Messaging.SingleEmailMessage emailAction(Id whatId, String toAddress,String targetObjectId, String fromAddress, String emailTemplate, Map<String,Id> orgWideIdMap){
        list<String> toAddresses = new list<String> {toAddress};
        Messaging.SingleEmailMessage emailOut = new Messaging.SingleEmailMessage();        
        if(orgWideIdMap.containsKey(fromAddress)){
            emailOut.setOrgWideEmailAddressId(orgWideIdMap.get(fromAddress));
        }else{
            emailOut.setSenderDisplayName('ABSA Support');
        }        
        if(String.isNotBlank( whatId )){
            emailOut.setWhatId(whatId);
            emailOut.setTreatTargetObjectAsRecipient(false);
            emailOut.setSaveAsActivity(false);
        }else{
            emailOut.setTreatTargetObjectAsRecipient(true);
            emailOut.setSaveAsActivity(true);
        }
        emailOut.setTargetObjectId(targetObjectId);
        emailOut.setToAddresses(toAddresses);
        emailOut.setUseSignature(false);
        List<EmailTemplate> emailTemps = new EmailTemplatesSelector().selectByName(emailTemplate);        
        if(!emailTemps.isEmpty()){
            emailOut.setTemplateId( emailTemps[0].Id );
        }        
        return emailOut;
    }
    
    /*
    * Method to send an SMS via the integration point
    * We use a Future callout anotation as we cannot 
    * do callouts from a future class
    * 
    * @param String targetObjectId
    * @param String whatId
    * @param String mobileNr
    * @param String contactName
    * @param String templateName
    * @param String serviceName
    */
    @Future(callout=true)
    public static void smsAction(String targetObjectId, String WhatId, String mobileNr, String contactName, String templateName, String serviceName){
       SMSHandler.sendSMS(targetObjectId, 
                            WhatId, 
                            mobileNr, 
                            contactName, 
                            templateName,  
                            serviceName, 
                            false);
    }

    /*
    * Case sepecific task action method 
    * 
    * @param Set<Id> ruleIds
    * @param Map<Id, Id> ruleCaseIdMap
    */
    public static List<Task> actionCaseTasks(Set<Id> ruleIds, Map<Id, Id> ruleCaseIdMap, Map<String, String> labelApiMap, Map<Id, List<Task>> ruleTaskMap){
        List<Messaging.SingleEmailMessage> emailsOutList = new List<Messaging.SingleEmailMessage>();
        Set<Id> ownerIds = new Set<Id>();
        Map<Id, Case> ruleCaseMap = new Map<Id, Case>();
        Map<Id, String> ownerMobileMap = new Map<Id, String>();
        Map<String,Id> OWDIdMap = new Map<String,Id>();
        Map<Id, sd_Communication_Rule__c> taskRuleMap = new Map<Id, sd_Communication_Rule__c>();
        List<Task> taskList = new List<Task>();
        Set<Id> intergrationServiceIds = new Set<Id>();
        Map<Id, String> integrationServiceMap = new Map<Id, String>();
        List<Task> updatedTaskListEmail = new List<Task>();
        List<Task> updatedTaskListSMS = new List<Task>();
        List<Org_Wide_Lookup_Value__mdt> mdt = new OrgWideLookupValuesSelector().selectByLabel('Email Template Default TargetObjectId');
        String defaulttargetObjectId = null;
        if (mdt.size()>0 ) {
            defaulttargetObjectId = mdt[0].Value__c;
        }
        for(OrgWideEmailAddress owd :[Select Id, Address From OrgWideEmailAddress]){
            OWDIdMap.put(owd.Address,owd.Id);
        }
        for(Case c :new CasesSelector().selectByIdWithCommunicationFields(ruleCaseIdMap.keySet())){
            ruleCaseMap.put(c.Id, c);
            if(c.Owner.Type == 'User'){
                ownerIds.add(c.OwnerId);
            }
        }
        for(User u :[Select Id, MobilePhone  From User Where Id IN :ownerIds]){
           ownerMobileMap.put(u.Id, u.MobilePhone);
        }
        //map all the rules for all tasks
        for(sd_Communication_Rule__c rule :new CommunicationRulesSelector().selectByRuleIdAndObjectType(ruleIds, 'Case')){
            for(List<Task> tlist :ruleTaskMap.values() ){
                for(Task t :tlist){
                    if(t.Communication_Rule_Id__c == rule.Id){
                        taskRuleMap.put( t.Id, rule );
                        taskList.add(t);
                    }
                }
            }
            intergrationServiceIds.add( rule.sd_Integration_Service__c );
        }
        //map all the integration services for all the communication rules
        for( Integration_Service__c service :new IntegrationServicesSelector().selectById(intergrationServiceIds) ){
            integrationServiceMap.put(service.Id, service.Name);
        }
        for(Task t :taskList){
            try{
                if(ruleCaseMap.containsKey(t.WhatId) && taskRuleMap.containsKey(t.Id)){
                    String targetObjectId = defaulttargetObjectId;
                    String emailField = '';
                    String smsField = '';
                    String contactName = '';
                    if(String.isNotBlank(taskRuleMap.get(t.Id).sd_Email_Field__c)){
                        if(taskRuleMap.get(t.Id).sd_Email_Field__c == 'Owner Email'){
                            emailField = ruleCaseMap.get(t.WhatId).Owner.Email;
                        }else{
                            Object fieldValue = ruleCaseMap.get(t.WhatId).get( labelApiMap.get( taskRuleMap.get(t.Id).sd_Email_Field__c ));
                            emailField = String.valueOf(fieldValue);
                        }
                    }
                    if(String.isNotBlank(taskRuleMap.get(t.Id).sd_SMS_Field__c)){
                        if(taskRuleMap.get(t.Id).sd_SMS_Field__c == 'Owner Mobile'){
                            smsField = ownerMobileMap.get( ruleCaseMap.get(t.WhatId).OwnerId );
                        }else{
                            Object fieldValue = ruleCaseMap.get(t.WhatId).get( labelApiMap.get( taskRuleMap.get(t.Id).sd_SMS_Field__c ));
                            smsField = String.valueOf(fieldValue);
                        }
                        if(ruleCaseMap.get(t.WhatId).ContactId != null){
                            Set<Id> contactIds = new Set<Id>();
                            contactIds.add(ruleCaseMap.get(t.WhatId).ContactId);
                            List<Contact> contactLst = new ContactsSelector().selectById(contactIds);
                            if(contactLst.size() > 0) {
                                contactName = contactLst[0].Name;
                            }
                        }
                    }
                    if(taskRuleMap.get(t.Id).sd_Action__c == 'Email'){
                            try{
                                emailsOutList.add(emailAction(t.WhatId,
                                                            emailField,
                                                            targetObjectId,
                                                            ruleCaseMap.get(t.WhatId).sd_Response_Email_Address__c,
                                                            taskRuleMap.get(t.Id).sd_Email_Template__c,
                                                            OWDIdMap));
                                updatedTaskListEmail.add(t);
                            }catch(Exception ex){
                                t.Status = 'Failed';
                                t.Action_Status__c = ex.getMessage();
                                updatedTaskListEmail.add(t);
                            }
                    }else if(taskRuleMap.get(t.Id).sd_Action__c == 'SMS'){
                            try{
                                smsAction(targetObjectId,
                                        t.WhatId, 
                                        smsField,
                                        contactName,
                                        taskRuleMap.get(t.Id).sd_SMS_Template__c,
                                        integrationServiceMap.get(taskRuleMap.get(t.Id).sd_Integration_Service__c));
                                t.Status = 'Completed';
                                t.Action_Status__c = 'Successful';
                                updatedTaskListSMS.add(t);
                            }catch(Exception ex){
                                t.Status = 'Failed';
                                t.Action_Status__c = ex.getMessage();
                                updatedTaskListSMS.add(t);
                            }
                    }else if(taskRuleMap.get(t.Id).sd_Action__c == 'User Preference'){
                        if(ruleCaseMap.get(t.WhatId).Communication_Method__c == 'Email'){
                                try{
                                    emailsOutList.add(emailAction(t.WhatId,
                                                                emailField,
                                                                targetObjectId,
                                                                ruleCaseMap.get(t.WhatId).sd_Response_Email_Address__c,
                                                                taskRuleMap.get(t.Id).sd_Email_Template__c,
                                                                OWDIdMap));
                                    updatedTaskListEmail.add(t);
                                }catch(Exception ex){
                                    t.Status = 'Failed';
                                    t.Action_Status__c = ex.getMessage();
                                    updatedTaskListEmail.add(t);
                                }
                        }else if(ruleCaseMap.get(t.WhatId).Communication_Method__c == 'SMS'){
                                try {
                                    smsAction(targetObjectId,
                                                t.WhatId,
                                                smsField,
                                                contactName,
                                                taskRuleMap.get(t.Id).sd_SMS_Template__c,
                                                integrationServiceMap.get(taskRuleMap.get(t.Id).sd_Integration_Service__c));
                                    t.Status = 'Completed';
                                    t.Action_Status__c = 'Successful';
                                    updatedTaskListSMS.add(t);
                                }catch(Exception ex){
                                    t.Status = 'Failed';
                                    t.Action_Status__c = ex.getMessage();
                                    updatedTaskListSMS.add(t);
                                }
                        } else{
                            t.Status = 'Completed';
                            t.Action_Status__c = 'Communication method "'+ruleCaseMap.get(t.WhatId).Communication_Method__c+'" is not catered for.';
                            updatedTaskListSMS.add(t);
                        }
                    }else{
                        t.Status = 'Completed';
                        t.Action_Status__c = 'Rule action "'+taskRuleMap.get(t.Id).sd_Action__c+'" is not catered for.';
                        updatedTaskListSMS.add(t);
                    }
                }
            }catch(Exception ex) {
                t.Status = 'Failed';
                t.Action_Status__c = ex.getMessage();
                updatedTaskListSMS.add(t);
            }
        }
         //now send the list of emails
        if(!emailsOutList.isEmpty()){
            List<EmailMessage> emailMsgList = new List<EmailMessage>();
            try{
                if( Limits.getEmailInvocations() <= Limits.getLimitEmailInvocations() ){
                    //Set allOrNothing = false, will send out succeful emails and push errors to the SendEmailResult 
                    //NOT using the traditional try/catch structure
                    Messaging.SendEmailResult[] result =  Messaging.sendEmail(emailsOutList, false);
                    Integer x = 0;
                    for(Messaging.SendEmailResult r :result){
                        if(r.IsSuccess()){
                            updatedTaskListEmail[x].Status = 'Completed';
                            updatedTaskListEmail[x].Action_Status__c = 'Successful';
                            //Create Email Message - to store on Case
                            EmailMessage emailMsg = new EmailMessage(); 
                            emailMsg.ToAddress = (emailsOutList[x].getToAddresses()[0]);
                            emailMsg.Subject = emailsOutList[x].getSubject();
                            emailMsg.HtmlBody = emailsOutList[x].getHtmlBody();
                            emailMsg.ParentId = emailsOutList[x].getWhatId();
                            emailMsg.MessageDate = system.now();
                            emailMsg.Status = '0';
                            emailMsg.Is_Auto_Response__c = true;
                            emailMsgList.add(emailMsg);
                        }else{
                            updatedTaskListEmail[x].Status = 'Failed';
                            Messaging.SendEmailError[] errArr = r.getErrors();
                            updatedTaskListEmail[x].Action_Status__c = errArr[0].getMessage();
                        }
                        x++;
                    }
                }
            }catch(Exception e){
                System.debug(e.getMessage());
                AuditTrailLog.logException(e, 'New', 'Warning', 'CommunicationPlanFunctions', 'actionTasks', 'There was an error while sending out communication emails');
                throw e;
            }
            if(!emailMsgList.isEmpty()){
                try{
                    insert emailMsgList;
                }catch(DMLException e){
                    System.debug(e.getMessage());
                    AuditTrailLog.logException(e, 'New', 'Warning', 'CommunicationPlanFunctions', 'actionTasks', 'There was an error while inserting the Case email message Task');
                    throw e;
                }
            }
        }
        updatedTaskListEmail.addAll( updatedTaskListSMS );
        return updatedTaskListEmail;
    }

    /*
    * Case sepecific task action method 
    * 
    * @param Set<Id> ruleIds
    * @param Map<Id, Id> ruleCaseIdMap
    */
    public static List<Task> actionLeadTasks(Set<Id> ruleIds, Map<Id, Id> ruleLeadIdMap, Map<String, String> labelApiMap, Map<Id, List<Task>> ruleTaskMap){
        List<Messaging.SingleEmailMessage> emailsOutList = new List<Messaging.SingleEmailMessage>();
        Map<Id, Lead> ruleLeadMap = new Map<Id, Lead>();
        Map<String,Id> OWDIdMap = new Map<String,Id>();
        Map<Id, sd_Communication_Rule__c> taskRuleMap = new Map<Id, sd_Communication_Rule__c>();
        List<Task> taskList = new List<Task>();
        Set<Id> intergrationServiceIds = new Set<Id>();
        Map<Id, String> integrationServiceMap = new Map<Id, String>();
        List<Task> updatedTaskListEmail = new List<Task>();
        List<Task> updatedTaskListSMS = new List<Task>();
        for(OrgWideEmailAddress owd :[Select Id, Address From OrgWideEmailAddress]){
            OWDIdMap.put(owd.Address,owd.Id);
        }
        ruleLeadMap.putAll( new LeadsSelector().selectById(ruleLeadIdMap.keySet()) );
        //map all the rules for all tasks
        for(sd_Communication_Rule__c rule :new CommunicationRulesSelector().selectByRuleIdAndObjectType(ruleIds, 'Lead')){
            for(List<Task> tlist :ruleTaskMap.values() ){
                for(Task t :tlist){
                    if(t.Communication_Rule_Id__c == rule.Id){
                        taskRuleMap.put( t.Id, rule );
                        taskList.add(t);
                    }
                }
            }
            intergrationServiceIds.add( rule.sd_Integration_Service__c );
        }
        //map all the integration services for all the communication rules
        for( Integration_Service__c service :new IntegrationServicesSelector().selectById(intergrationServiceIds) ){
            integrationServiceMap.put(service.Id, service.Name);
        }
        for(Task t :taskList){
            if(ruleLeadMap.containsKey(t.WhoId) && taskRuleMap.containsKey(t.Id)){
                String emailField = '';
                String targetObjectId = t.WhoId;
                String smsField = '';
                String leadName = '';
                leadName = ruleLeadMap.get(t.WhoId).Name;
                String emailTemplateLabelName = '';
                String smsTemplateLabelName = '';
                if(String.isNotBlank(taskRuleMap.get(t.Id).sd_Email_Field__c)){
                    Object fieldValue = ruleLeadMap.get(t.WhoId).get( labelApiMap.get( taskRuleMap.get(t.Id).sd_Email_Field__c ));
                    emailField = String.valueOf(fieldValue);
                    if( String.isNotBlank( taskRuleMap.get(t.Id).sd_Email_Template__c ) || String.isNotBlank( taskRuleMap.get(t.Id).sd_Email_Template_AFR__c ) ){
                        if( ruleLeadMap.get(t.WhoId).Language_Preference__c == 'Afrikaans' && String.isNotBlank(taskRuleMap.get(t.Id).sd_Email_Template_AFR__c)){
                            emailTemplateLabelName = taskRuleMap.get(t.Id).sd_Email_Template_AFR__c;
                        }else if( ruleLeadMap.get(t.WhoId).Language_Preference__c == 'English' &&  String.isNotBlank(taskRuleMap.get(t.Id).sd_Email_Template__c)){
                            emailTemplateLabelName = taskRuleMap.get(t.Id).sd_Email_Template__c;
                        }else{
                            if(String.isNotBlank(taskRuleMap.get(t.Id).sd_Email_Template__c)){
                                emailTemplateLabelName = taskRuleMap.get(t.Id).sd_Email_Template__c;
                            }
                        }
                    }
                }
                if(String.isNotBlank(taskRuleMap.get(t.Id).sd_SMS_Field__c)){
                    Object fieldValue = ruleLeadMap.get(t.WhoId).get( labelApiMap.get( taskRuleMap.get(t.Id).sd_SMS_Field__c ));
                    smsField = String.valueOf(fieldValue);
                    //Make sure email template is defined and that the Lable is used for the SMSHandler
                    if( String.isNotBlank(taskRuleMap.get(t.Id).sd_SMS_Template__c) || String.isNotBlank(taskRuleMap.get(t.Id).sd_SMS_Template_AFR__c)) {
                        if( ruleLeadMap.get(t.WhoId).Language_Preference__c == 'Afrikaans' && String.isNotBlank(taskRuleMap.get(t.Id).sd_SMS_Template_AFR__c)){
                            smsTemplateLabelName = taskRuleMap.get(t.Id).sd_SMS_Template_AFR__c;
                        }else if( ruleLeadMap.get(t.WhoId).Language_Preference__c == 'English' &&  String.isNotBlank(taskRuleMap.get(t.Id).sd_SMS_Template__c)){
                            smsTemplateLabelName = taskRuleMap.get(t.Id).sd_SMS_Template__c;
                        }else{
                            if(String.isNotBlank(taskRuleMap.get(t.Id).sd_SMS_Template__c)){
                                 smsTemplateLabelName = taskRuleMap.get(t.Id).sd_SMS_Template__c;
                            }
                        }
                    }
                }
                if(taskRuleMap.get(t.Id).sd_Action__c == 'Email'){
                    try{
                        emailsOutList.add(emailAction(null,
                                                    emailField,
                                                    targetObjectId,
                                                    ruleLeadMap.get(t.WhoId).sd_Response_Email_Address__c,
                                                    emailTemplateLabelName,
                                                    OWDIdMap));
                        updatedTaskListEmail.add(t);
                    }catch(Exception ex){
                        t.Status = 'Failed';
                        t.Action_Status__c = ex.getMessage();
                        updatedTaskListEmail.add(t);
                    }
                }else if(taskRuleMap.get(t.Id).sd_Action__c == 'SMS'){
                    try{
                        smsAction(targetObjectId,
                                    null,
                                    smsField,
                                    leadName,
                                    smsTemplateLabelName,
                                    integrationServiceMap.get(taskRuleMap.get(t.Id).sd_Integration_Service__c));
                        t.Status = 'Completed';
                        t.Action_Status__c = 'Successful';
                        updatedTaskListSMS.add(t);
                    }catch(Exception ex){
                        t.Status = 'Failed';
                        t.Action_Status__c = ex.getMessage();
                        updatedTaskListSMS.add(t);
                    }
                }else if(taskRuleMap.get(t.Id).sd_Action__c == 'User Preference'){
                    if(ruleLeadMap.get(t.WhoId).Preferred_Communication_Channel__c == 'Email'){
                        try{
                            emailsOutList.add(emailAction(null,
                                                        emailField,
                                                        targetObjectId,
                                                        ruleLeadMap.get(t.WhoId).sd_Response_Email_Address__c,
                                                        emailTemplateLabelName,
                                                        OWDIdMap));
                            updatedTaskListEmail.add(t);
                        }catch(Exception ex){
                            t.Status = 'Failed';
                            t.Action_Status__c = ex.getMessage();
                            updatedTaskListEmail.add(t);
                        }
                    }else if(ruleLeadMap.get(t.WhoId).Preferred_Communication_Channel__c == 'SMS'){
                        try {
                            smsAction(targetObjectId,
                                        null,
                                        smsField,
                                        leadName,
                                        smsTemplateLabelName,
                                        integrationServiceMap.get(taskRuleMap.get(t.Id).sd_Integration_Service__c));
                            t.Status = 'Completed';
                            t.Action_Status__c = 'Successful';
                            updatedTaskListSMS.add(t);
                        }catch(Exception ex){
                            t.Status = 'Failed';
                            t.Action_Status__c = ex.getMessage();
                            updatedTaskListSMS.add(t);
                        }
                    } else{
                        t.Status = 'Completed';
                        t.Action_Status__c = 'Communication method "'+ruleLeadMap.get(t.WhoId).Preferred_Communication_Channel__c+'" is not catered for.';
                        updatedTaskListSMS.add(t);
                    }
                } else{
                    t.Status = 'Completed';
                    t.Action_Status__c = 'Rule action "'+taskRuleMap.get(t.Id).sd_Action__c+'" is not catered for.';
                    updatedTaskListSMS.add(t);
                }
            }
        }
         //now send the list of emails
        if(!emailsOutList.isEmpty()){
            List<EmailMessage> emailMsgList = new List<EmailMessage>();
            try{
                if( Limits.getEmailInvocations() <= Limits.getLimitEmailInvocations() ){
                    //Set allOrNothing = false, will send out succeful emails and push errors to the SendEmailResult 
                    //NOT using the traditional try/catch structure
                    Messaging.SendEmailResult[] result =  Messaging.sendEmail(emailsOutList, false);
                    Integer x = 0;
                    for(Messaging.SendEmailResult r :result){
                        if(r.IsSuccess()){
                            updatedTaskListEmail[x].Status = 'Completed';
                            updatedTaskListEmail[x].Action_Status__c = 'Successful';
                        }else{
                            updatedTaskListEmail[x].Status = 'Failed';
                            Messaging.SendEmailError[] errArr = r.getErrors();
                            updatedTaskListEmail[x].Action_Status__c = errArr[0].getMessage();
                        }
                        x++;
                    }
                }
            }catch(Exception e){
                System.debug(e.getMessage());
                AuditTrailLog.logException(e, 'New', 'Warning', 'CommunicationPlanFunctions', 'actionLeadTasks', 'There was an error while sending out communication emails');
                throw e;
            }
            if(!emailMsgList.isEmpty()){
                try{
                    //insert emailMsgList;
                }catch(DMLException e){
                    System.debug(e.getMessage());
                    AuditTrailLog.logException(e, 'New', 'Warning', 'CommunicationPlanFunctions', 'actionLeadTasks', 'There was an error while inserting the Case email message Task');
                    throw e;
                }
            }
        }
        updatedTaskListEmail.addAll(updatedTaskListSMS);
        return updatedTaskListEmail;
    }
    
       /* W-005904 - Anka Ganta- 2020-09-14
    * Application sepecific task action method 
    * 
    * @param Set<Id> ruleIds
    * @param Map<Id, Id> ruleAppIdMap
    */
    public static List<Task> actionApplTasks(Set<Id> ruleIds, Map<Id, Id> ruleAppIdMap, Map<String, String> labelApiMap, Map<Id, List<Task>> ruleTaskMap){
        List<Messaging.SingleEmailMessage> emailsOutList = new List<Messaging.SingleEmailMessage>();
        Set<Id> ownerIds = new Set<Id>();
        Map<Id, Application__c> ruleApplMap = new Map<Id, Application__c>();
        Map<Id, String> ownerMobileMap = new Map<Id, String>();
        Map<String,Id> OWDIdMap = new Map<String,Id>();
        Map<Id, sd_Communication_Rule__c> taskRuleMap = new Map<Id, sd_Communication_Rule__c>();
        List<Task> taskList = new List<Task>();
        Set<Id> intergrationServiceIds = new Set<Id>();
        Map<Id, String> integrationServiceMap = new Map<Id, String>();
        List<Task> updatedTaskListEmail = new List<Task>();
        List<Task> updatedTaskListSMS = new List<Task>();
        List<Org_Wide_Lookup_Value__mdt> mdt = new OrgWideLookupValuesSelector().selectByLabel('Email Template Default TargetObjectId');
        String defaulttargetObjectId = null;
        if (mdt.size()>0 ) {
            defaulttargetObjectId = mdt[0].Value__c;
        }
        for(OrgWideEmailAddress owd :[Select Id, Address From OrgWideEmailAddress]){
            OWDIdMap.put(owd.Address,owd.Id);
        }
        for(Application__c a :new ApplicationsSelector().selectByIdWithCommunicationFields(ruleAppIdMap.keySet())){
            ruleApplMap.put(a.Id, a);
            if(a.Owner.Type == 'User'){
                ownerIds.add(a.OwnerId);
            }
        }
        for(User u :[Select Id, MobilePhone  From User Where Id IN :ownerIds]){
           ownerMobileMap.put(u.Id, u.MobilePhone);
        }
        //map all the rules for all tasks
        for(sd_Communication_Rule__c rule :new CommunicationRulesSelector().selectByRuleIdAndObjectType(ruleIds, 'Application')){
            for(List<Task> tlist :ruleTaskMap.values() ){
                for(Task t :tlist){
                    if(t.Communication_Rule_Id__c == rule.Id){
                        taskRuleMap.put( t.Id, rule );
                        taskList.add(t);
                    }
                }
            }
            intergrationServiceIds.add( rule.sd_Integration_Service__c );
        }
        //map all the integration services for all the communication rules
        for( Integration_Service__c service :new IntegrationServicesSelector().selectById(intergrationServiceIds) ){
            integrationServiceMap.put(service.Id, service.Name);
        }
        for(Task t :taskList){
            try{
                if(ruleApplMap.containsKey(t.WhatId) && taskRuleMap.containsKey(t.Id)){
                    String targetObjectId = defaulttargetObjectId;
                    String emailField = '';
                    String smsField = '';
                    String contactName = '';
                    String applName = '';
                    applName = ruleApplMap.get(t.whatId).Name;
                    if(String.isNotBlank(taskRuleMap.get(t.Id).sd_Email_Field__c)){
                        if(taskRuleMap.get(t.Id).sd_Email_Field__c == 'Owner Email'){
                            emailField = ruleApplMap.get(t.WhatId).Owner.Email;
                        }else{
                            System.debug('');
                            Object fieldValue = ruleApplMap.get(t.WhatId).get( labelApiMap.get( taskRuleMap.get(t.Id).sd_Email_Field__c ));
                            emailField = String.valueOf(fieldValue);

                        }
                    }
                    if(String.isNotBlank(taskRuleMap.get(t.Id).sd_SMS_Field__c)){
                        if(taskRuleMap.get(t.Id).sd_SMS_Field__c == 'Owner Mobile'){
                            smsField = ownerMobileMap.get( ruleApplMap.get(t.WhatId).OwnerId );
                        }else{
                            Object fieldValue = ruleApplMap.get(t.WhatId).get( labelApiMap.get( taskRuleMap.get(t.Id).sd_SMS_Field__c ));
                            smsField = String.valueOf(fieldValue);
                        }
                        /*if(ruleApplMap.get(t.WhatId).ContactId != null){
                            Set<Id> contactIds = new Set<Id>();
                            contactIds.add(ruleApplMap.get(t.WhatId).ContactId);
                            List<Contact> contactLst = new ContactsSelector().selectById(contactIds);
                            if(contactLst.size() > 0) {
                                contactName = contactLst[0].Name;
                            }
                        }*/
                    }
                    if(taskRuleMap.get(t.Id).sd_Action__c == 'Email'){
                            try{
                                emailsOutList.add(emailAction(t.WhatId,
                                                            emailField,
                                                            targetObjectId,
                                                            ruleApplMap.get(t.WhatId).sd_Response_Email_Address__c,
                                                            taskRuleMap.get(t.Id).sd_Email_Template__c,
                                                            OWDIdMap));
                                updatedTaskListEmail.add(t);
                            }catch(Exception ex){
                                t.Status = 'Failed';
                                t.Action_Status__c = ex.getMessage();
                                updatedTaskListEmail.add(t);
                            }
                    }else if(taskRuleMap.get(t.Id).sd_Action__c == 'SMS'){
                            try{
                                smsAction(targetObjectId,
                                        t.WhatId, 
                                        smsField,
                                        applName,
                                        taskRuleMap.get(t.Id).sd_SMS_Template__c,
                                        integrationServiceMap.get(taskRuleMap.get(t.Id).sd_Integration_Service__c));
                                t.Status = 'Completed';
                                t.Action_Status__c = 'Successful';
                                updatedTaskListSMS.add(t);
                            }catch(Exception ex){
                                t.Status = 'Failed';
                                t.Action_Status__c = ex.getMessage();
                                updatedTaskListSMS.add(t);
                            }
                    }else if(taskRuleMap.get(t.Id).sd_Action__c == 'User Preference'){
                        if(ruleApplMap.get(t.WhatId).Communication_Method__c == 'Email'){
                                try{
                                    emailsOutList.add(emailAction(t.WhatId,
                                                                emailField,
                                                                targetObjectId,
                                                                ruleApplMap.get(t.WhatId).sd_Response_Email_Address__c,
                                                                taskRuleMap.get(t.Id).sd_Email_Template__c,
                                                                OWDIdMap));
                                    updatedTaskListEmail.add(t);
                                }catch(Exception ex){
                                    t.Status = 'Failed';
                                    t.Action_Status__c = ex.getMessage();
                                    updatedTaskListEmail.add(t);
                                }
                        }else if(ruleApplMap.get(t.WhatId).Communication_Method__c == 'SMS'){
                                try {
                                    smsAction(targetObjectId,
                                                t.WhatId,
                                                smsField,
                                                applName,
                                                taskRuleMap.get(t.Id).sd_SMS_Template__c,
                                                integrationServiceMap.get(taskRuleMap.get(t.Id).sd_Integration_Service__c));
                                    t.Status = 'Completed';
                                    t.Action_Status__c = 'Successful';
                                    updatedTaskListSMS.add(t);
                                }catch(Exception ex){
                                    t.Status = 'Failed';
                                    t.Action_Status__c = ex.getMessage();
                                    updatedTaskListSMS.add(t);
                                }
                        } else{
                            t.Status = 'Completed';
                            t.Action_Status__c = 'Communication method "'+ruleApplMap.get(t.WhatId).Communication_Method__c+'" is not catered for.';
                            updatedTaskListSMS.add(t);
                        }
                    }else{
                        t.Status = 'Completed';
                        t.Action_Status__c = 'Rule action "'+taskRuleMap.get(t.Id).sd_Action__c+'" is not catered for.';
                        updatedTaskListSMS.add(t);
                    }
                }
            }catch(Exception ex) {
                t.Status = 'Failed';
                t.Action_Status__c = ex.getMessage();
                updatedTaskListSMS.add(t);
            }
        }
         //now send the list of emails
        if(!emailsOutList.isEmpty()){
            List<EmailMessage> emailMsgList = new List<EmailMessage>();
            try{
                if( Limits.getEmailInvocations() <= Limits.getLimitEmailInvocations() ){
                    //Set allOrNothing = false, will send out succeful emails and push errors to the SendEmailResult 
                    //NOT using the traditional try/catch structure
                    Messaging.SendEmailResult[] result =  Messaging.sendEmail(emailsOutList, false);
                    Integer x = 0;
                    for(Messaging.SendEmailResult r :result){
                        if(r.IsSuccess()){
                            updatedTaskListEmail[x].Status = 'Completed';
                            updatedTaskListEmail[x].Action_Status__c = 'Successful';
                            //Create Email Message - to store on Application
                            EmailMessage emailMsg = new EmailMessage(); 
                            emailMsg.ToAddress = (emailsOutList[x].getToAddresses()[0]);
                            emailMsg.Subject = emailsOutList[x].getSubject();
                            emailMsg.HtmlBody = emailsOutList[x].getHtmlBody();
                            emailMsg.RelatedToId = emailsOutList[x].getWhatId();
                            emailMsg.MessageDate = system.now();
                            emailMsg.Status = '0';
                            emailMsg.Is_Auto_Response__c = true;
                            emailMsgList.add(emailMsg);
                        }else{
                            updatedTaskListEmail[x].Status = 'Failed';
                            Messaging.SendEmailError[] errArr = r.getErrors();
                            updatedTaskListEmail[x].Action_Status__c = errArr[0].getMessage();
                        }
                        x++;
                    }
                }
            }catch(Exception e){
                System.debug(e.getMessage());
                AuditTrailLog.logException(e, 'New', 'Warning', 'CommunicationPlanFunctions', 'actionTasks', 'There was an error while sending out communication emails');
                throw e;
            }
            if(!emailMsgList.isEmpty()){
                try{
                    insert emailMsgList;
                }catch(DMLException e){
                    System.debug(e.getMessage());
                    AuditTrailLog.logException(e, 'New', 'Warning', 'CommunicationPlanFunctions', 'actionTasks', 'There was an error while inserting the Application email message Task');
                    throw e;
                }
            }
        }
        updatedTaskListEmail.addAll( updatedTaskListSMS );
        return updatedTaskListEmail;
    }

    /*
    * Get all the communication plan rules for new cases and create 
    * the relevant activities for each plan rule relevant to Cases
    * 
    * @param List<Case> newCases
    * @param Map<String, String> objLabelNameMap
    */
    public static void createCaseRelatedTasks(List<Case> newCases, Map<String, String> objLabelNameMap){        
            Set<Id> planIds = new Set<Id>();            
            for(Case c :newCases){
                planIds.add(c.sd_Communication_Plan_Id__c);
            }            
            List<sd_Communication_Plan__c> plansWithRules = new CommunicationPlansSelector().selectByIdWithRules(planIds);
            Map<Id, List<sd_Communication_Rule__c>> planRulesMap = new Map<Id, List<sd_Communication_Rule__c>>();
            for(sd_Communication_Plan__c plan :plansWithRules){
                planRulesMap.put(plan.Id, plan.sd_Communication_Rules__r);
            }            
            List<Task> schTasks = new List<Task>();
            Boolean ruleMetCondition = false;
            for(Case c :newCases){                
                if(String.isNotBlank( c.sd_Communication_Plan_Id__c )) {
                    for(sd_communication_Rule__c rule :planRulesMap.get(c.sd_Communication_Plan_Id__c)){                        
                        if(c.Case_Ownership__c != 'FPOC'){
                            switch on rule.sd_Trigger_Condition__c {
                                when 'Case Created in a Queue' {
                                    if(c.OwnerID.getSObjectType() != User.SObjectType) {
                                        ruleMetCondition = true;
                                    }
                                }
                                when 'Case Created for a User' {
                                    if( c.OwnerID.getSObjectType() == User.SObjectType && c.Status != 'In Progress' ) {
                                        ruleMetCondition = true;
                                    }
                                }
                                when 'Case Created as Closed' {
                                    if(c.IsClosedOnCreate){
                                        ruleMetCondition = true;
                                    }
                                }
                                when 'Status Change to In Progress' {
                                    if(c.Status == 'In Progress') {
                                        ruleMetCondition = true;
                                    }
                                }
                                when 'Case Open' {
                                    if(!c.IsClosedOnCreate) {
                                        ruleMetCondition = true;
                                    }
                                }
                                when else {
                                    //ruleMetCondition = false;
                                }
                            }
                        }                        
                        if(ruleMetCondition){
                            Task t = createSObjectTask((SObject)c, rule, objLabelNameMap, null);
                            schTasks.add(t);
                            ruleMetCondition = false;
                        }
                    }
                }
            }
            if( !schTasks.isEmpty() ){                
                try{
                    insert schTasks;
                }catch(DmlException ex){
                    System.debug(ex.getMessage());
                    AuditTrailLog.logException(ex, 'New', 'Error', 'CommunicationPlanFunctions', 'createCaseRelatedTasks', 'There was an error inserting new communication tasks');
                    throw ex;
                }
            }
    }
    
    /*
    * Get all the communication plan rules for new cases and create 
    * the relevant activities for each plan rule relevant to Cases
    * 
    * @param List<Case> newCases
    * @param Map<String, String> objLabelNameMap
    */
    public static void createLeadRelatedTasks(List<Lead> newLeads, Map<String, String> objLabelNameMap){
        Set<Id> planIds = new Set<Id>();        
        for(Lead l :newLeads){
            planIds.add(l.sd_Communication_Plan_Id__c);
        }        
        List<sd_Communication_Plan__c> plansWithRules = new CommunicationPlansSelector().selectByIdWithRules(planIds);
        Map<Id, List<sd_Communication_Rule__c>> planRulesMap = new Map<Id, List<sd_Communication_Rule__c>>();
        for(sd_Communication_Plan__c plan :plansWithRules){
            planRulesMap.put(plan.Id, plan.sd_Communication_Rules__r);
        }        
        List<Task> schTasks = new List<Task>();
        Boolean ruleMetCondition = false;
        for(Lead l :newLeads){            
            if(String.isNotBlank( l.sd_Communication_Plan_Id__c )) {                
                for(sd_communication_Rule__c rule :planRulesMap.get(l.sd_Communication_Plan_Id__c)){                    
                    switch on rule.sd_Trigger_Condition__c {
                        when 'Lead Converted' {
                            if(l.Status == 'Qualified'){ 
                                ruleMetCondition = true;
                            }
                        }   
                        when 'Lead Created Not As Internal Propensity' {
                            if( l.LeadSource != 'Internal Propensity' ) {
                                ruleMetCondition = true;
                            }
                        }
                        when 'First Unsuccessful Call' {
                            if( l.Unsuccessful_Calls__c >= 1 ){
                                if(l.Status == 'Working' || l.Status == 'Nurturing'){
                                     ruleMetCondition = true; 
                                }
                            }
                        }
                        when 'Status Change to Unqualified' {
                            if( l.Status == 'Unqualified' ) {
                                ruleMetCondition = true;
                            }
                        }
                        when 'Status Change to Abandoned' {
                            if( l.Status == 'Abandoned' ) {
                                ruleMetCondition = true;
                            }
                        }
                        when 'Lead Not Converted' {
                            if( l.Status != 'Qualified' ) {
                                ruleMetCondition = true;
                            }
                        }
                    }                    
                    if(ruleMetCondition){                        
                        Task t = createSObjectTask((SObject)l, rule, objLabelNameMap, null);
                        schTasks.add(t);
                        ruleMetCondition = false;
                    }
                }
            }
        }
        if( !schTasks.isEmpty() ){            
            try{
                insert schTasks;
            }catch(DmlException ex){
                System.debug(ex.getMessage());
                AuditTrailLog.logException(ex, 'New', 'Error', 'CommunicationPlanFunctions', 'createLeadRelatedTasks', 'There was an error inserting new communication tasks');
                throw ex;
            }
        }
    }
   /*  W-005904 - Anka Ganta - 2020-09-14
    * Get all the communication plan rules for new Applications and create 
    * the relevant activities for each plan rule relevant to Applications
    * 
    * @param List<Application__c> newAppls
    * @param Map<String, String> objLabelNameMap
    */
    public static void createApplRelatedTasks(List<Application__c> newAppls, Map<String, String> objLabelNameMap){
        Set<Id> planIds = new Set<Id>();        
        for(Application__c a :newAppls){
            planIds.add(a.sd_Communication_Plan_Id__c);
        }        
        List<sd_Communication_Plan__c> plansWithRules = new CommunicationPlansSelector().selectByIdWithRules(planIds);
        Map<Id, List<sd_Communication_Rule__c>> planRulesMap = new Map<Id, List<sd_Communication_Rule__c>>();
        for(sd_Communication_Plan__c plan :plansWithRules){
            planRulesMap.put(plan.Id, plan.sd_Communication_Rules__r);
        }        
        List<Task> schTasks = new List<Task>();
        Boolean ruleMetCondition = false;
        for(Application__c a :newAppls){            
            if(String.isNotBlank( a.sd_Communication_Plan_Id__c )) {        
                for(sd_communication_Rule__c rule :planRulesMap.get(a.sd_Communication_Plan_Id__c)){
                    switch on rule.sd_Trigger_Condition__c {
                        when 'Account Not Activated 7 days' {
                            if(a.Number_of_days_account_has_not_activated__c == 7){ 
                                ruleMetCondition = true;
                            }
                            
                        }
                        when 'Account Not Activated 14 days' {
                            // If Account is not activated for 14 days send EMAIL
                            if(a.Number_of_days_account_has_not_activated__c == 14){ 
                                ruleMetCondition = true;
                            }
                        }
                        when 'Account Not Activated 75 days' {
                            // If Account is not activated for 14 days send EMAIL
                            if(a.Number_of_days_account_has_not_activated__c == 75){ 
                                ruleMetCondition = true;
                            }
                        }
                        when 'Welcome Letter Day 7' {
                            if(a.Number_of_days_account_has_not_activated__c == 7){ 
                                ruleMetCondition = true;
                            }
                        } 
                        //Added by Rajesh for W-5902 & W-5901
                        when 'Account Not Activated 45 days' {
                            if(a.Number_of_days_account_has_not_activated__c == 45){ 
                                ruleMetCondition = true;
                            }
                            
                        }
                        //Newly added by Rajesh
                        when 'No Transactional Activity' {
                            if(a.Number_of_days_account_has_not_activated__c == 21 || a.Number_of_days_account_has_not_activated__c == 42 || a.Number_of_days_account_has_not_activated__c == 63 || a.Number_of_days_account_has_not_activated__c == 84){ 
                                ruleMetCondition = true;
                            }
                            
                        }
                        when 'Welcome Letter' {
                            if(a.Number_of_days_account_has_not_activated__c == 1){ 
                                ruleMetCondition = true;
                            }
                        } 
                    }         
                    if(ruleMetCondition){                        
                        Task t = createSObjectTask((SObject)a, rule, objLabelNameMap, null);
                        schTasks.add(t);
                        ruleMetCondition = false;
                    }
                }
            }
        }
        if( !schTasks.isEmpty() ){            
            try{
                insert schTasks;
            }catch(DmlException ex){
                System.debug(ex.getMessage());
                AuditTrailLog.logException(ex, 'New', 'Error', 'CommunicationPlanFunctions', 'createApplRelatedTasks', 'There was an error inserting new communication tasks');
                throw ex;
            }
        }
    }
    /*
    * Calculate the action date for a task
    * 
    * @param DateTime dateTimeCalc
    * @param Id busHoursId
    * @param String timesMeasure
    * @param Integer units
    * @param String beforeAfter
    * @return DateTime
    */
    public static DateTime calculateActionDate(DateTime dateTimeCalc, Id busHoursId, String timesMeasure, Integer units, String beforeAfter) {
        //System.debug('----- timesMeasure : '+timesMeasure);
        if(dateTimeCalc == null){
            dateTimeCalc = System.now();
            return dateTimeCalc;
        }
        String timeMeasure = timesMeasure;
        Integer timeUnits = Integer.valueOf(units);        
        //to milliseconds
        if(timeMeasure.contains('Hour')){
            timeUnits = timeUnits * 60 * 60 * 1000;
        }else if(timeMeasure.contains('Day')){
            timeUnits = timeUnits * 8; //8 hour day
            timeUnits = timeUnits * 60 * 60 * 1000;
        }        
        if( beforeAfter == 'After'){            
            if(String.isNotBlank(busHoursId)){
                dateTimeCalc = BusinessHours.add(busHoursId, dateTimeCalc, timeUnits);
            }else{
                dateTimeCalc = dateTimeCalc.addSeconds( (timeUnits / 1000) );
            }            
        }else{            
            if(String.isNotBlank(busHoursId)){
                dateTimeCalc = BusinessHours.add(busHoursId, dateTimeCalc, ( timeUnits * -1));
            }else{
                dateTimeCalc = dateTimeCalc.addSeconds( (timeUnits / 1000) * -1 );
            }
        }                
        return dateTimeCalc;
    }
}