public with sharing class MVP2_CallActivityDetailsController {
   
    @AuraEnabled
    public static list<Task> getListOfCallActivity(String oppId){
        list<task> listOfCallTask=new list<task>();
        List<task> listOfTask=[select Call_ID__c, Call_Start_Time__c,Call_Duration__c from task where Call_ID__c != null order by Call_Start_Time__c ASC]; 
        for(Task tObj:listOfTask){
            if(tObj.Call_ID__c != null){
                    listOfCallTask.add(tObj);
            }
        }       
        return listOfCallTask;
    }

}