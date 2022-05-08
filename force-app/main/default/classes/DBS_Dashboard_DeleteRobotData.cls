global class DBS_Dashboard_DeleteRobotData implements Database.Batchable<sObject>, Schedulable {

     global Database.QueryLocator start(Database.BatchableContext BC){
          String query = 'SELECT Id from Robot_Data_Retrieval__c WHERE CreatedDate < LAST_N_DAYS:30';
          return Database.getQueryLocator(query);
     }
      
     global void execute(Database.BatchableContext BC, List<Robot_Data_Retrieval__c> scope){
          delete scope;
     }
      
     global void finish(Database.BatchableContext BC){

     }
    
     global void execute(SchedulableContext sc) {
         DBS_Dashboard_DeleteRobotData b = new DBS_Dashboard_DeleteRobotData();
         database.executebatch(b);
     }
}