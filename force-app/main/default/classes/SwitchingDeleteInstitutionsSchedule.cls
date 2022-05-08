/**
* Switching Delete Instituion Job
* @author André Pietersen
* @created 2021-04-25
*/
global class SwitchingDeleteInstitutionsSchedule implements Schedulable {
    global void execute(SchedulableContext ctx) {
        List<CronTrigger> jobs = [select Id,CronJobDetail.Name,State
            from CronTrigger where CronJobDetail.Name LIKE 'Switching Delete Institutions%'];
            for (CronTrigger job : jobs) {
                if (!Test.isRunningTest()) {
                    system.abortJob(job.Id);
                }
            }
        List<Switching_Institution__c> institutions = [SELECT Id FROM Switching_Institution__c];
        integer size = institutions.size();
        if (size == 0) {
            processSwitchingStartSync();
        } else {
            deleteAllInstitutions();
        }
    }

    public static void processSwitchingStartSync() {
        String minute = string.valueOf(system.now().minute()+1);
        System.schedule('Switching Get Institutions '+system.now(), '0 '+minute+' * * * ?', new SwitchingGetInstitutionsSchedule());  
    }

    public static void deleteAllInstitutions() {
        List<Switching_Institution__c> institutions = [SELECT Id FROM Switching_Institution__c LIMIT 10000];
        delete institutions;  

        String minute = string.valueOf(system.now().minute()+1);
        System.schedule('Switching Delete Institutions '+system.now(), '0 '+minute+' * * * ?', new SwitchingDeleteInstitutionsSchedule()); 
    }
}