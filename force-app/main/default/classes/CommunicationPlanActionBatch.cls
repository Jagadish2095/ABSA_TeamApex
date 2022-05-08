/**
* This class gets allncommunication tasks and 
* execute the action defined by the communication rules
*
* @author  Rudolf Niehaus - CloudSmiths
* @since   2019-03-20
*/
global class CommunicationPlanActionBatch implements Database.Batchable<Task> {

    global Iterable<Task> start(Database.BatchableContext BC) {
        System.debug(' ----- start ----- ');
        List<Task> communicationTasks = new List<Task>();
        List<ApexClass> apList = [Select Id from ApexClass where Name = 'CommunicationPlanActionQueueable'];    
        Set<Id> apexClassIds = new Set<Id>();
        for(ApexClass eachApexClass : apList) {
            apexClassIds.add(eachApexClass.Id);
        }
        if (apexClassIds != null) {
            Integer enqueuedJobs = [SELECT COUNT() FROM AsyncApexJob 
                                    WHERE JobType='Queueable'
                                    AND Status IN ('Processing','Preparing','Queued', 'Holding')
                                    AND ApexClassID =: apexClassIds];
            System.debug(' ----- enqueuedJobs : '+enqueuedJobs);
            if(enqueuedJobs <= 0){
                DateTime actionDate = System.now();
                Map<String, Schema.RecordTypeInfo> taskRecordTypeMap = Task.sObjectType.getDescribe().getRecordTypeInfosByName();
                communicationTasks = new TasksSelector().
                                                selectByStatusAndRecordTypeIdAndActionDate('Scheduled', 
                                                                                            taskRecordTypeMap.get('Communication Plan Tasks').RecordTypeId,
                                                                                            actionDate);
                System.debug(' ----- communicationTasks : '+communicationTasks);
                return communicationTasks;
            }else {
                System.debug(' ----- communicationTasks : '+communicationTasks);
                return communicationTasks;
            }
        }else {
            System.debug(' ----- communicationTasks : '+communicationTasks);
            return communicationTasks; 
        }
    }

    global void execute(Database.BatchableContext BC, List<Task> scope){
        System.debug(' ----- execute ----- ');
        List<ApexClass> apList = [Select Id from ApexClass where Name = 'CommunicationPlanActionQueueable'];    
        Set<Id> apexClassIds = new Set<Id>();
        for(ApexClass eachApexClass : apList) {
            apexClassIds.add(eachApexClass.Id);
        }
        if (apexClassIds != null) {
            Integer enqueuedJobs = [SELECT COUNT() FROM AsyncApexJob 
                                    WHERE JobType='Queueable'
                                    AND Status IN ('Processing','Preparing','Queued', 'Holding')
                                    AND ApexClassID =: apexClassIds];
            System.debug(' ----- enqueuedJobs : '+enqueuedJobs);
            if(enqueuedJobs <= 0){
                System.debug(' ----- scope : '+scope);
                if(scope.size() > 0) {
                    System.debug(' ----- scope true : '+scope);
                    System.debug(' ----- System.now():'+System.now());
                    System.Queueable job = new CommunicationPlanActionQueueable(scope);
                    System.enqueueJob(job);
                }
            }
        }

    }
    global void finish(Database.BatchableContext BC){
        System.debug(' ----- finish ----- ');
        List<ApexClass> apList = [Select Id from ApexClass where Name = 'CommunicationPlanActionBatch' or Name = 'CommunicationPlanActionQueueable'];  
        Set<Id> apexClassIds = new Set<Id>();
        for(ApexClass eachApexClass : apList) {
            apexClassIds.add(eachApexClass.Id);
        }
        if (apexClassIds != null) {
            Integer enqueuedJobs = [SELECT COUNT() FROM AsyncApexJob 
                                    WHERE JobType= 'BatchApex'
                                    AND Status IN ('Processing','Preparing','Queued', 'Holding')
                                    AND ApexClassID =: apexClassIds];
            System.debug(' ----- enqueuedJobs : '+enqueuedJobs);
            if(enqueuedJobs <= 0){
                //Outbound callout limit is 10 from a batch
                if (!Test.isRunningTest()){
                    System.debug(' ----- finish restart ----- ');
                    Database.executeBatch(new CommunicationPlanActionBatch(),9);
                }
            }else {
                System.debug(' ----- finish not restart ----- ');
            }
        } else {
            if (!Test.isRunningTest()){
                System.debug(' ----- finish restart ----- ');
                Database.executeBatch(new CommunicationPlanActionBatch(),9);
            }
        }
    }
}