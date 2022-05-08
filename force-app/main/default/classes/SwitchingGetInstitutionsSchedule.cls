/**
* Switching Get Instituion Job
* @author André Pietersen
* @created 2020-10-05
*/
global class SwitchingGetInstitutionsSchedule implements Schedulable {
    global void execute(SchedulableContext ctx) {
        processSwitchingSync();
    }

    @future (callout=true)
    public static void processSwitchingSync() {
        List<Switching_Institution__c> currentInstitutions = [SELECT Id FROM Switching_Institution__c];
        integer count = currentInstitutions.size();
        System.debug(count);
        integer size = 1000;
        Integer page = 0;
        Integer difference = 0;
        if (count != 0) {
            difference = math.mod(count,1000);
        }
        
        if (difference == 0 || count == 0) {
            page = count/1000;
            //Get Institutions from Switch-It
            List<Switching_Institution__c> newInstitutions = new List<Switching_Institution__c>();
            SwitchingInstitutions_Resp_IB_v1 response = SwitchingInstitutions_IH_v1.getSwitchingInstitutionsWithSizeLimits(String.valueOf(page), String.valueOf(size));
            
            if (response != null && response.x_embedded.items.size() > 0) {
                List<Switching_Institution__c> institutionsPartialList = SwitchingInstitutions_IH_v1.createSwitchingInstitutionInSalesforce(response.x_embedded.items);
                newInstitutions.addall(institutionsPartialList);
                
                insert newInstitutions;

                List<CronTrigger> jobs = [select Id,CronJobDetail.Name,State
                from CronTrigger where CronJobDetail.Name LIKE 'Switching Get Institutions%'];
                for (CronTrigger job : jobs) {
                    if (!Test.isRunningTest()) {
                        system.abortJob(job.Id);
                    }
                }
                String minute = string.valueOf(system.now().minute()+1);
                System.schedule('Switching Get Institutions '+system.now(), '0 '+minute+' * * * ?', new SwitchingGetInstitutionsSchedule());  
            } 
        } else {
            List<CronTrigger> jobs = [select Id,CronJobDetail.Name,State
                from CronTrigger where CronJobDetail.Name LIKE 'Switching Get Institutions%'];
            for (CronTrigger job : jobs) {
                system.abortJob(job.Id);
            }
        }  
    }
}