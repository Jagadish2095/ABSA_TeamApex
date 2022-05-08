/**
* @description Handler for the task trigger
* Test Class Name: TaskTriggerFunctionsTest
* @author  Kyle Alexander
* @created 2018-06-06
* CHANGE LOG:
*=======================================================================================================
* @Rakesh Byri - 2019-03-04: Added logic for After Insert, After Update and After Delete.
* ======================================================================================================
*/

public class TaskTriggerHandler extends TriggerHandler{
    
    public virtual override void beforeInsert(List<sObject> newRecords) {
        //Cast sObject maps to Event maps        
        List<Task> eventTriggerNew = (List<Task>)newRecords;
        TaskTriggerFunctions.beforeInsert(eventTriggerNew);
        TaskTriggerFunctions.updateCallTask(eventTriggerNew);
    }
    
    /* Method: afterInsert - To collect tasks created for lead/Oppty records and update the call attempts.
* @params: map of new Records
* @author: Rakesh Byri(Absa)
* @created date: 2019-03-04 
* */
    
    public virtual override void afterInsert(Map<Id, sObject> newRecords) {
        Set<Id> leadIdsSet = new Set<Id>();
        Set<Id> OpptyIdsSet = new Set<Id>();
        Set<Id> caseIdsSet = new Set<Id>();
        for(Task currentTask: (List<Task>)newRecords.values()){
            String whoId = currentTask.WhoId;
            String whatId = currentTask.WhatId;
            if(whoId !=null && whoId.startsWith('00Q')){
                leadIdsSet.add(currentTask.WhoId);
            }
            if(whatId !=null && whatId.startsWith('006')){
                OpptyIdsSet.add(currentTask.whatId);
            }
            if(whatId !=null && whatId.startsWith('500')){
                caseIdsSet.add(currentTask.whatId);
            }
        }
        if(!leadIdsSet.isEmpty()){
            TaskTriggerFunctions.updateCallAttemptsOnLead(leadIdsSet);
        }
        if(!OpptyIdsSet.isEmpty()){
            TaskTriggerFunctions.updateCallAttemptsonOppty(OpptyIdsSet);
        }
        if(!caseIdsSet.isEmpty() && Trigger.isInsert) {
            TaskTriggerFunctions.updateCallAttemptsOnCase(caseIdsSet);
        }
    }
    
    public virtual override void beforeUpdate(Map<Id, sObject> newRecords, Map<Id, sObject> oldRecords) {
        List<Task> newTasksList = (List<Task>)newRecords.values();
        TaskTriggerFunctions.updateCallTask(newTasksList);
    }
    /* Method: afterUpdate - To collect tasks created for lead/Oppty records and update the call attempts.
* @params: map of new Records and old records
* @author: Rakesh Byri(Absa)
* @created date: 2019-03-04 
* */
    
    public virtual override void afterUpdate(Map<Id, sObject> newRecords, Map<Id, sObject> oldRecords) {
        Set<Id> leadIdsSet = new Set<Id>();
        for(Task currentTask: (List<Task>)newRecords.values()){
            String whoId = String.valueOf(currentTask.WhoId);
            String whatId = currentTask.WhatId;
            if(whoId !=null && whoId.startsWith('00Q')){
                leadIdsSet.add(currentTask.WhoId);
            }
        }
        if(!leadIdsSet.isEmpty()){
            TaskTriggerFunctions.updateCallAttemptsOnLead(leadIdsSet);
        }
    }
    
    /* Method: afterDelete - To collect tasks created for lead/oppty records and update the call attempts.
* @prams: map of new Records and old records
* author: Rakesh Byri(Absa)
* @created date: 2019-03-04 
* */
    
    public virtual override void afterDelete(Map<Id, sObject> oldRecords) {
        Set<Id> leadIdsSet = new Set<Id>();
        Set<Id> OpptyIdsSet = new Set<Id>();
        for(Task currentTask: (List<Task>)oldRecords.values()){
            String whoId = String.valueOf(currentTask.WhoId);
            String whatId = currentTask.WhatId;
            if(whoId !=null && whoId.startsWith('00Q')){
                leadIdsSet.add(currentTask.WhoId);
            }
            if(whatId !=null && whatId.startsWith('006')){
                OpptyIdsSet.add(currentTask.whatId);
            }
        }
        if(!leadIdsSet.isEmpty()){
            TaskTriggerFunctions.updateCallAttemptsOnLead(leadIdsSet);
        }
        if(!OpptyIdsSet.isEmpty()){
            TaskTriggerFunctions.updateCallAttemptsonOppty(OpptyIdsSet);
        }
    }
    
    public virtual override void beforeDelete(Map<Id, sObject> oldRecords) {
        //Cast sObject maps to Task maps
        Map<Id, Task> taskTriggerOld = (Map<Id, Task>)oldRecords;
        
        List<Task> tasks = convertMapToList(taskTriggerOld);
        
        TaskTriggerFunctions.ristrictaskDeletaionForVA(tasks);
        for(Task task : tasks) {
            if(task.WhatId != null){
                String checkIfIsOpportunity = String.valueOf(task.WhatId).substring(0, 3);
                //006 is prefix of opportunity record - this is done because the whatId is referenced
                if (checkIfIsOpportunity == '006') {
                    TaskTriggerFunctions.checkIfTaskHasComments(task);
                    //TaskTriggerFunctions.decrementNumberCalls(task);
                }
            }
        }
    }
    
    /**
*  @description Method that converts Map of values into a List
*
* @param triggerMap Map of values
*
* @return List of tasks from map values
*/
    private static List<Task> convertMapToList(Map<Id, Task> triggerMap){
        List<Task> tasks = new List<Task>();
        for(Task task : triggerMap.values()){
            tasks.add(task);
        }
        return tasks;
    }
    
}