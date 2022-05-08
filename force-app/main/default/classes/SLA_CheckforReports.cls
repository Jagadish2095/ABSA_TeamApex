/**
* @description Batch Class is created to check SLA breach cases and update them.
* MVP3 - CLient Review & Client Maturity
* */
global class SLA_CheckforReports implements Database.Batchable<sObject>,Database.Stateful, Schedulable {
    
    static Set<Decimal> assignedBreachedValues = new Set<Decimal>{100, 101, 110, 111};
    static Set<Decimal> callingAttemptStartedBreachedValues = new Set<Decimal>{10, 11, 110, 111};
    static Set<Decimal> inProgressBreachedValues = new Set<Decimal>{1, 11, 101, 111};
    static Integer businessHoursCount = Test.isRunningTest() ? 0 : Integer.valueOf(System.label.VA_Business_Hours_Count);
    
    /**
    * @description Schedulable execute method
    * @param SC - Database.SchedulableContext.
    * 
    * */
    global void execute(SchedulableContext SC) {
        Database.executeBatch(new SLA_CheckforReports(), 10);
    }
    
    /**
    * @description Requierd method for batch class implementation.
    * @param bc - Database.BatchableContext.
    * @return list of case records.
    * */ 
    global Database.QueryLocator start(Database.BatchableContext bc) {
        Datetime dt=system.now();
        Integer hr=dt.hour(); 
        if(hr >= 8 && hr <= 16){
            return Database.getQueryLocator([SELECT ID,Status,Case_Age__c, SLA_Adjustment_Day_s__c, recordtype.developername,SLA_Extension_Date__c FROM Case Where /*(SLA_Extension_Date__c != null) AND*/ Status!='Closed' AND (recordtype.developername ='VA_Client_review' OR recordtype.developername ='VA_Maturity')]);
        }
        DateTime filterDate = Date.today().addDays(Test.isRunningTest() ? -1 : 1);
        return Database.getQueryLocator([SELECT ID,Status,Case_Age__c, SLA_Adjustment_Day_s__c, recordtype.developername,SLA_Extension_Date__c FROM Case WHERE CreatedDate >=:filterDate LIMIT 1]);
    }
    
    
    /**
    * @description method will check all cases SLA Breach status of Client Maturity and Client Review type cases.
    * @param bc - Database.BatchableContext.
    * @param scope - list of current case records.
    * 
    * */
    global void execute(Database.BatchableContext bc, List<Case> scope){
        List<Case> ListOfCase = new List<Case>();
        Set<Id> addedCaseIds = new Set<Id>();
        for (Case casObj : scope) {
            //System.debug('RecordType : '+casObj.recordtype.developername);
            //System.debug('Status : '+casObj.Status);
            if(casObj.recordtype.developername == 'VA_Client_Review'){                          
                if((casObj.Status == 'New' || casObj.Status == 'Assigned')
                && casObj.Case_Age__c >= Integer.valueOf(System.Label.VA_Assigned_SLA_Days)*businessHoursCount 
                && !assignedBreachedValues.contains(casObj.SLA_Adjustment_Day_s__c)){
                    //casObj.SLA_Breach_Assigned_Status__c=true;
                    casObj.SLA_Adjustment_Day_s__c = processCode(casObj.SLA_Adjustment_Day_s__c, 0);
                    //System.debug('Code : '+casObj.SLA_Adjustment_Day_s__c);
                    casObj.is_level_1_SLA_done__c=true;
                    ListOfCase.add(casObj);
                    addedCaseIds.add(casObj.Id);
                }
                if((casObj.Status == 'New' || casObj.Status == 'Calling Attemps Started' ||  casObj.Status == 'Assigned') 
                && casObj.Case_Age__c >= Integer.valueOf(System.Label.VA_Client_review_Calling_attemps_started_SLA_Days)*businessHoursCount 
                && !callingAttemptStartedBreachedValues.contains(casObj.SLA_Adjustment_Day_s__c)){
                    //casObj.SLA_Breach_Calling_Attemps_Started__c=true;
                    casObj.SLA_Adjustment_Day_s__c = processCode(casObj.SLA_Adjustment_Day_s__c, 1);
                    //System.debug('Code : '+casObj.SLA_Adjustment_Day_s__c);
                    casObj.is_level_1_SLA_done__c=true;
                    if(!addedCaseIds.contains(casObj.Id)){
                        ListOfCase.add(casObj);
                        addedCaseIds.add(casObj.Id);
                    }
                }
                if((casObj.Status == 'New' || casObj.Status == 'Calling Attemps Started' ||  casObj.Status == 'Assigned' || casObj.Status == 'In Progress') 
                && casObj.Case_Age__c >=Integer.valueOf(System.Label.VA_Client_review_In_Progress_SLA_Days)*businessHoursCount
                && !inProgressBreachedValues.contains(casObj.SLA_Adjustment_Day_s__c)){
                    //casObj.SLA_Breach_In_Progress__c=true;
                    casObj.SLA_Adjustment_Day_s__c = processCode(casObj.SLA_Adjustment_Day_s__c, 2);
                    //System.debug('Code : '+casObj.SLA_Adjustment_Day_s__c);
                    casObj.is_level_1_SLA_done__c=true;
                    if(!addedCaseIds.contains(casObj.Id)){
                        ListOfCase.add(casObj);
                        addedCaseIds.add(casObj.Id);
                    }
                }
            }
            if(casObj.recordtype.developername == 'VA_Maturity'){                          
                if((casObj.Status == 'New' || casObj.Status == 'Assigned' )
                && casObj.Case_Age__c >= Integer.valueOf(System.Label.VA_Maturity_Assigned_SLA_Days)*businessHoursCount 
                && !assignedBreachedValues.contains(casObj.SLA_Adjustment_Day_s__c)){
                    //casObj.SLA_Breach_Assigned_Status__c=true;
                    casObj.SLA_Adjustment_Day_s__c = processCode(casObj.SLA_Adjustment_Day_s__c, 0);
                    //System.debug('Code : '+casObj.SLA_Adjustment_Day_s__c);
                    casObj.is_level_1_SLA_done__c=true;
                    if(!addedCaseIds.contains(casObj.Id)){
                        ListOfCase.add(casObj);
                        addedCaseIds.add(casObj.Id);
                    }
                }
                if((casObj.Status == 'New' || casObj.Status == 'Calling Attemps Started' ||  casObj.Status == 'Assigned')
                && casObj.Case_Age__c >=Integer.valueOf(System.Label.VA_Maturity_Calling_attemps_started_SLA_Days)*businessHoursCount
                && !callingAttemptStartedBreachedValues.contains(casObj.SLA_Adjustment_Day_s__c)){
                    //casObj.SLA_Breach_Calling_Attemps_Started__c=true;
                    casObj.SLA_Adjustment_Day_s__c = processCode(casObj.SLA_Adjustment_Day_s__c, 1);
                    //System.debug('Code : '+casObj.SLA_Adjustment_Day_s__c);
                    casObj.is_level_1_SLA_done__c=true;
                    if(!addedCaseIds.contains(casObj.Id)){
                        ListOfCase.add(casObj);
                        addedCaseIds.add(casObj.Id);
                    }
                }
                if((casObj.Status == 'New' || casObj.Status == 'Calling Attemps Started' ||  casObj.Status == 'Assigned' || casObj.Status == 'In Progress') 
                && casObj.Case_Age__c >=Integer.valueOf(System.Label.VA_Maturity_In_Progress_SLA_Days)*businessHoursCount
                && !inProgressBreachedValues.contains(casObj.SLA_Adjustment_Day_s__c)){
                    //casObj.SLA_Breach_In_Progress__c=true;
                    casObj.SLA_Adjustment_Day_s__c = processCode(casObj.SLA_Adjustment_Day_s__c, 2);
                    //System.debug('Code : '+casObj.SLA_Adjustment_Day_s__c);
                    casObj.is_level_1_SLA_done__c=true;
                    if(!addedCaseIds.contains(casObj.Id)){
                        ListOfCase.add(casObj);
                        addedCaseIds.add(casObj.Id);
                    }
                }
            }        
        }
        //System.debug('Details ---'+ListOfCase);
        if(ListOfCase.Size() > 0){
            TriggerDispatcher.skip(CaseTriggerHandler.class.getName());
            Update ListOfCase;
        }
    }
    
    /**
    * @description Requierd method for batch class implementation.
    * @param bc - Database.BatchableContext.
    * */   
    global void finish(Database.BatchableContext bc){
        
        
    }    
    
    /**
    * @description utility method to process code.
    * @param previousCode - previousCode.
    * @param index - index.
    * @return Integer
    * */   
    static Integer processCode(Decimal previousCode, Integer index){
        previousCode = previousCode==null ? 0 : previousCode;
        String stringCode = String.valueOf(Integer.valueOf(previousCode));
        stringCode = stringCode.length()==3 ? stringCode : '0'.repeat(3-stringCode.length())+stringCode;
        //System.debug(stringCode);
        List<String> codeArray = stringCode.split('');
        codeArray[index] = '1';
        stringCode = String.join(codeArray, '');
        //System.debug(stringCode);
        return Integer.valueOf(stringCode);
    }
    
}