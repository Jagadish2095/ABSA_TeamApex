/**
* Handler for the task trigger
* @author  Kyle Alexander
* @created 2018-06-06
*/

public class TriggerHandlerTask extends TriggerHandler{
/*
  * DEREK HUGHES: Commetn out this code as this class is not longer needed in production adn will be deleted
  * 
    public virtual override void beforeInsert(List<sObject> newRecords) {
        //Cast sObject maps to Event maps
      
     List<Task> eventTriggerNew = (List<Task>)newRecords;

        for(Task task : eventTriggerNew) {
            if(task.WhatId != null){
                String checkIfIsOpportunity = String.valueOf(task.WhatId).substring(0, 3);
                //006 is prefix of opportunity record - this is done because the whatId is referenced
                if(checkIfIsOpportunity == '006'){
                    TaskTriggerFunctions.setValuesForTask(task);
                    TaskTriggerFunctions.incrementNumberCalls(task);
                }
            } 
        }


    }

    public virtual override void beforeDelete(Map<Id, sObject> oldRecords) {
  
        Map<Id, Task> taskTriggerOld = (Map<Id, Task>)oldRecords;

        List<Task> tasks = convertMapToList(taskTriggerOld);

        for(Task task : tasks) {
            if(task.WhatId != null){
                String checkIfIsOpportunity = String.valueOf(task.WhatId).substring(0, 3);
                //006 is prefix of opportunity record - this is done because the whatId is referenced
                if (checkIfIsOpportunity == '006') {
                    TaskTriggerFunctions.checkIfTaskHasComments(task);
                    TaskTriggerFunctions.decrementNumberCalls(task);
                }
            }
        }

    }

    /**
     * Method that converts Map of values into a List
     *
     * @param triggerMap Map of values
     *
     * @return List of tasks from map values
     
    private static List<Task> convertMapToList(Map<Id, Task> triggerMap){
        List<Task> tasks = new List<Task>();
        for(Task task : triggerMap.values()){
            tasks.add(task);
        }
        return tasks;
    }
*/
}