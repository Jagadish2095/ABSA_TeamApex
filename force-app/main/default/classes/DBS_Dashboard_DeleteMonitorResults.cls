global class DBS_Dashboard_DeleteMonitorResults implements Database.Batchable<sObject>, Schedulable {

     global Database.QueryLocator start(Database.BatchableContext BC){
          String query = 'SELECT Id from DBS_Monitoring_Result__c WHERE CreatedDate < LAST_N_DAYS:30';                          
          return Database.getQueryLocator(query);
     }
      
     global void execute(Database.BatchableContext BC, List<DBS_Monitoring_Result__c> scope){
          delete scope;
     }
      
     global void finish(Database.BatchableContext BC){

     }
    
     global void execute(SchedulableContext sc) {
         DBS_Dashboard_DeleteMonitorResults b = new DBS_Dashboard_DeleteMonitorResults();
         database.executebatch(b);
     }
}