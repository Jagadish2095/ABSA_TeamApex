/**
* Batch class for updating relavant fields related to case SLAs 
* @author  Koketso Mpshane
* @date    21/08/2020
*/
global class CaseSLAManagementBatch implements Database.Batchable<Case>{
    
    global Iterable<Case> start(Database.BatchableContext BC) {
        
        Date currentDate = system.today();
        
        List<Case> caseList = [Select Id, CaseNumber, BusinessHoursId, Days_Since_SLA_Expired__c, External_SLA_End_Date__c From Case Where IsClosed = false And SLA_Extended__c = false And External_SLA_End_Date__c <: currentDate And (RecordType.DeveloperName =: 'Complaint' Or RecordType.DeveloperName =:'ATM') ];
        
        system.debug('***caseList:***'+caseList.size());
        
        return caseList;
    }
    
    global void execute(Database.BatchableContext BC, List<Case> scope){
        
        List<Case> updateCases = new List<Case>();
        
        try{
            for(Case cse: scope){
                //get time difference between now and when the case expired
                Set<Date> datesSinceExpired = new Set<Date>();
                
                Date slaExpiredDate = Date.valueOf(cse.External_SLA_End_Date__c);
                Date currentDate = system.today();
                
                //add the expiry date to the list as well, for correct calculation
				datesSinceExpired.add(slaExpiredDate);
                
                Date followingDate = slaExpiredDate.addDays(1);
                
                while(followingDate < currentDate){
                    if(BusinessHours.isWithin(cse.BusinessHoursId, followingDate)){
                        datesSinceExpired.add(followingDate);
                    }
                    followingDate = followingDate.addDays(1);
                }
                
                system.debug('***datesSinceExpired***'+datesSinceExpired);
                cse.Days_Since_SLA_Expired__c = datesSinceExpired.size();
                updateCases.add(cse);
            }
            
            update updateCases;
            
        }catch(DMLException ex){
            system.debug(LoggingLevel.FINE, '***CaseSLAManagementBatch Error:***'+ex.getMessage());
        }
        
    }
    
    global void finish(Database.BatchableContext BC){
        system.debug('CaseSLAManagementBatch finished processing!');
    }

}