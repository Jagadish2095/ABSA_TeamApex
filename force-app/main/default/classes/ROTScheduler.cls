global class ROTScheduler implements Schedulable{
     	String sType = 'Create New Restriction Groups';
        String status = 'In Progress';
        CasesSelector csIDs = new CasesSelector();        
        List<case> rotCaseIDLists = csIDs.selectByServiceTypeROT(sType, status, 'Submitted'); 
    	
    global void execute(SchedulableContext rot){
        system.debug('rotCaseIDLists...................' +rotCaseIDLists);
        if(rotCaseIDLists != null && rotCaseIDLists.size()>0){
            for(Case cs : rotCaseIDLists){
				Id csID = cs.Id;
				system.debug('csID for loop case ID...................' +csID);  
                system.debug('cs.Pre_Lapse_Start_Date__c...................' +cs.Pre_Lapse_Start_Date__c);
                system.debug('system date...................' +system.today());
                if(cs.Pre_Lapse_Start_Date__c == system.today()){                    
                    ROTSchedulerHandler.preLapseStartDateEmailContext(csID);                    
                }
                if(cs.Pre_Lapse_End_Date__c == system.today()){
                    ROTSchedulerHandler.preLapseEndDateEmailContext(csID);
                }
                if(cs.ROT_Start_Date__c == system.today()){
                    ROTSchedulerHandler.lapseStartDateEmailContext(csID);
                }
                if(cs.ROT_End_Date__c == system.today()){
                    ROTSchedulerHandler.lapseEndDateEmailContext(csID);
                }
            }
        }
    }
}