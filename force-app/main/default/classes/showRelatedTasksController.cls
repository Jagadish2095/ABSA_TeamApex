/*
* Tinashe Mutsungi Shoko
* Changes for USSD Esign stories 3951, 4228 and 4229
* Code review recommended use Selector for SOQL queries
* 20-05-2020
*/
global class showRelatedTasksController {
    @AuraEnabled
    global static string getRelatedTasks(string context) {
        list<string> entries = new list<string>();
        Set<Id> whatIDsSet = new Set<Id>();
        whatIDsSet.add(context);
        TasksSelector taskSel = new TasksSelector();
        list<Task> relatedTasks = taskSel.selectById(whatIDsSet); //[SELECT id, status, subject, CreatedDate FROM Task WHERE WhatID = :context];
        for (Task t : relatedTasks) {
            entries.add('{"createdDate": "'+t.createdDate +'"');
            entries.add('"subject": "'+t.subject+'"}');
        }
        string retObj = String.join(entries,',');
        return '['+retObj+']';
    }
}